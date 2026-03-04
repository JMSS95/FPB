<?php
$GLOBALS['ex'] = 0;
class Dashboarddb
{
	function normalizeDashboardCsvValue($value)
	{
		if (!is_string($value) || $value === '') {
			return '';
		}

		if (!preg_match('//u', $value)) {
			$converted = false;
			foreach (['Windows-1252', 'ISO-8859-1'] as $encoding) {
				$converted = @iconv($encoding, 'UTF-8//IGNORE', $value);
				if ($converted !== false && $converted !== '' && preg_match('//u', $converted)) {
					$value = $converted;
					break;
				}
				$converted = false;
			}
			if ($converted === false) {
				$value = @mb_convert_encoding($value, 'UTF-8', 'UTF-8, Windows-1252, ISO-8859-1');
			}
		}

		$value = str_replace("\xC2\xA0", ' ', $value);
		return trim($value);
	}

	function normalizeDashboardCsvHeaderKey($value)
	{
		$key = $this->normalizeDashboardCsvValue($value);
		$key = ltrim($key, "\xEF\xBB\xBF");
		$key = strtolower($key);
		$key = str_replace([' ', '-'], '_', $key);
		return $key;
	}

	function parseDashboardCsvInt($value)
	{
		$value = $this->normalizeDashboardCsvValue($value);
		if ($value === '' || !is_numeric($value)) {
			return null;
		}

		$intValue = (int)$value;
		return ($intValue > 0) ? $intValue : null;
	}

	function getDashboardCsvIdVendaValidation($value)
	{
		$rawValue = $this->normalizeDashboardCsvValue($value);
		if ($rawValue === '') {
			return [
				'valid' => false,
				'id' => null,
				'msg' => 'ID Venda em falta'
			];
		}

		if (!preg_match('/^\d+$/', $rawValue)) {
			return [
				'valid' => false,
				'id' => null,
				'msg' => 'ID Venda com caracteres inválidos'
			];
		}

		$idVenda = (int)$rawValue;
		if ($idVenda <= 0) {
			return [
				'valid' => false,
				'id' => null,
				'msg' => 'ID Venda inválido'
			];
		}

		return [
			'valid' => true,
			'id' => $idVenda,
			'msg' => ''
		];
	}

	function parseDashboardCsvDateTime($value)
	{
		$value = $this->normalizeDashboardCsvValue($value);
		if ($value === '') {
			return null;
		}

		$formats = [
			'd/m/Y H:i',
			'd/m/Y H:i:s',
			'Y-m-d H:i',
			'Y-m-d H:i:s',
			'Y-m-d\\TH:i',
			'Y-m-d\\TH:i:s'
		];

		foreach ($formats as $format) {
			$dt = DateTime::createFromFormat($format, $value);
			if ($dt instanceof DateTime) {
				$errors = DateTime::getLastErrors();
				$hasErrors = is_array($errors) && (((int)($errors['warning_count'] ?? 0) > 0) || ((int)($errors['error_count'] ?? 0) > 0));
				if (!$hasErrors) {
					return $dt->format('Y-m-d H:i:s');
				}
			}
		}

		return null;
	}

	function detectDashboardCsvDelimiter($line)
	{
		$line = $this->normalizeDashboardCsvValue($line);
		if (preg_match('/^sep\s*=\s*[,;]$/i', $line)) {
			return (strpos($line, ',') !== false) ? ',' : ';';
		}
		$semicolonCount = substr_count($line, ';');
		$commaCount = substr_count($line, ',');
		return ($commaCount > $semicolonCount) ? ',' : ';';
	}

	function parseDashboardCsvDecimal($value)
	{
		$value = $this->normalizeDashboardCsvValue($value);
		if ($value === '') {
			return null;
		}

		$value = str_replace([' ', ','], ['', '.'], $value);
		if (!is_numeric($value)) {
			return null;
		}

		return (float)$value;
	}

	function getOrCreateDashboardDimensionId($table, $descricao, &$cache)
	{
		global $conn;

		$descricao = $this->normalizeDashboardCsvValue($descricao);
		if ($descricao === '') {
			return null;
		}

		$cacheKey = strtolower($descricao);
		if (isset($cache[$cacheKey])) {
			return $cache[$cacheKey];
		}

		$sqlGet = "SELECT id FROM {$table} WHERE descricao = :descricao LIMIT 1";
		$stmtGet = $conn->prepare($sqlGet);
		$stmtGet->execute([':descricao' => $descricao]);
		$row = $stmtGet->fetch(PDO::FETCH_ASSOC);
		if ($row && isset($row['id'])) {
			$cache[$cacheKey] = (int)$row['id'];
			return $cache[$cacheKey];
		}

		$sqlInsert = "INSERT INTO {$table} (descricao) VALUES (:descricao)";
		$stmtInsert = $conn->prepare($sqlInsert);
		$stmtInsert->execute([':descricao' => $descricao]);

		$cache[$cacheKey] = (int)$conn->lastInsertId();
		return $cache[$cacheKey];
	}

	function getOrCreateDashboardProdutoId($descricao, $idTipoProduto, $precoUnitario, &$cache)
	{
		global $conn;

		$descricao = $this->normalizeDashboardCsvValue($descricao);
		if ($descricao === '') {
			return null;
		}
		if ($precoUnitario === null) {
			return null;
		}
		$precoNormalizado = round((float)$precoUnitario, 4);

		$cacheKey = strtolower($descricao).'|'.(int)$idTipoProduto.'|'.number_format($precoNormalizado, 4, '.', '');
		if (isset($cache[$cacheKey])) {
			return $cache[$cacheKey];
		}

		$sqlGet = "SELECT id, preco_uni FROM produtos WHERE id_tipo_produto = :id_tipo_produto AND LOWER(TRIM(descricao)) = LOWER(TRIM(:descricao)) AND ABS(preco_uni - :preco_uni) < 0.0001 LIMIT 1";
		$stmtGet = $conn->prepare($sqlGet);
		$stmtGet->execute([
			':descricao' => $descricao,
			':id_tipo_produto' => $idTipoProduto,
			':preco_uni' => $precoNormalizado
		]);
		$row = $stmtGet->fetch(PDO::FETCH_ASSOC);
		if ($row && isset($row['id'])) {
			$cache[$cacheKey] = (int)$row['id'];
			return $cache[$cacheKey];
		}

		$sqlInsert = "INSERT INTO produtos (descricao, id_tipo_produto, preco_uni, created_at, updated_at) VALUES (:descricao, :id_tipo_produto, :preco_uni, NOW(), NOW())";
		$stmtInsert = $conn->prepare($sqlInsert);
		$stmtInsert->execute([
			':descricao' => $descricao,
			':id_tipo_produto' => $idTipoProduto,
			':preco_uni' => $precoNormalizado
		]);

		$cache[$cacheKey] = (int)$conn->lastInsertId();
		return $cache[$cacheKey];
	}

	function parseDashboardCsvRowsFromFile($csvPath)
	{
		$result = [
			'val' => 2,
			'msg' => 'Não foi possível ler o ficheiro CSV.',
			'rows' => []
		];

		if (!file_exists($csvPath) || !is_readable($csvPath)) {
			$result['msg'] = 'O ficheiro CSV não está disponível para leitura.';
			return $result;
		}

		$handle = fopen($csvPath, 'r');
		if ($handle === false) {
			$result['msg'] = 'Não foi possível abrir o ficheiro CSV.';
			return $result;
		}

		try {
			$firstLine = fgets($handle);
			if ($firstLine === false) {
				$result['msg'] = 'O ficheiro CSV está vazio ou inválido.';
				return $result;
			}

			$firstLineNormalized = strtolower($this->normalizeDashboardCsvValue($firstLine));
			$delimiter = $this->detectDashboardCsvDelimiter($firstLine);

			if (preg_match('/^sep\s*=\s*[,;]$/i', $firstLineNormalized)) {
				$header = fgetcsv($handle, 0, $delimiter);
			} else {
				rewind($handle);
				$header = fgetcsv($handle, 0, $delimiter);
			}
			if ($header === false || !is_array($header)) {
				$result['msg'] = 'O ficheiro CSV está vazio ou inválido.';
				return $result;
			}

			$headerMap = [];
			foreach ($header as $index => $columnName) {
				$normalizedColumn = $this->normalizeDashboardCsvHeaderKey($columnName);
				$headerMap[$normalizedColumn] = $index;
			}

			if (isset($headerMap['receita_total']) && !isset($headerMap['receita_calculada'])) {
				$headerMap['receita_calculada'] = $headerMap['receita_total'];
			}

			if (isset($headerMap['data_hora']) && !isset($headerMap['datahora'])) {
				$headerMap['datahora'] = $headerMap['data_hora'];
			}

			$requiredColumns = [
				'id_venda',
				'datahora',
				'tipo_produto',
				'descricao_artigo',
				'categoria',
				'preco_unitario',
				'quantidade',
				'receita_calculada',
				'canal_venda',
				'cidade'
			];

			foreach ($requiredColumns as $requiredColumn) {
				if (!array_key_exists($requiredColumn, $headerMap)) {
					$result['msg'] = 'CSV inválido: coluna obrigatória em falta ('.$requiredColumn.').';
					return $result;
				}
			}

			$rows = [];
			$rowNumber = 1;
			while (($row = fgetcsv($handle, 0, $delimiter)) !== false) {
				$rowNumber++;
				if (!is_array($row) || count($row) === 0) {
					continue;
				}

				$rows[] = [
					'row_number' => $rowNumber,
					'id_venda' => $this->normalizeDashboardCsvValue($row[$headerMap['id_venda']] ?? ''),
					'datahora' => $this->normalizeDashboardCsvValue($row[$headerMap['datahora']] ?? ''),
					'tipo_produto' => $this->normalizeDashboardCsvValue($row[$headerMap['tipo_produto']] ?? ''),
					'descricao_artigo' => $this->normalizeDashboardCsvValue($row[$headerMap['descricao_artigo']] ?? ''),
					'categoria' => $this->normalizeDashboardCsvValue($row[$headerMap['categoria']] ?? ''),
					'preco_unitario' => $this->normalizeDashboardCsvValue($row[$headerMap['preco_unitario']] ?? ''),
					'quantidade' => $this->normalizeDashboardCsvValue($row[$headerMap['quantidade']] ?? ''),
					'receita_calculada' => $this->normalizeDashboardCsvValue($row[$headerMap['receita_calculada']] ?? ''),
					'canal_venda' => $this->normalizeDashboardCsvValue($row[$headerMap['canal_venda']] ?? ''),
					'cidade' => $this->normalizeDashboardCsvValue($row[$headerMap['cidade']] ?? ''),
				];
			}

			$result['val'] = 1;
			$result['msg'] = 'Ficheiro CSV processado com sucesso.';
			$result['rows'] = $rows;
			return $result;
		} finally {
			fclose($handle);
		}
	}

	function importDashboardCsvRows($rows)
	{
		global $conn;

		$result = [
			'val' => 2,
			'msg' => 'Não foi possível importar o conteúdo do CSV.',
			'importedRows' => 0,
			'skippedRows' => 0,
			'duplicateRows' => 0,
			'invalidRows' => 0
		];

		if (!is_array($rows) || count($rows) === 0) {
			$result['msg'] = 'Não existem registos para importar.';
			return $result;
		}

		$tipoCache = [];
		$categoriaCache = [];
		$cidadeCache = [];
		$produtoCache = [];
		$importedRows = 0;
		$skippedRows = 0;
		$duplicateRows = 0;
		$invalidRows = 0;
		$seenIdVendaInBatch = [];

		$sqlVendasExists = "SELECT id FROM vendas WHERE id_venda = :id_venda LIMIT 1";
		$stmtVendasExists = $conn->prepare($sqlVendasExists);

		$sqlVendasInsert = "INSERT INTO vendas (id_venda, id_produto, id_cidade, id_categoria, DataHora, Quantidade, Receita, canal_venda)
			VALUES (:id_venda, :id_produto, :id_cidade, :id_categoria, :data_hora, :quantidade, :receita, :canal_venda)";
		$stmtVendasInsert = $conn->prepare($sqlVendasInsert);

		try {
			$conn->beginTransaction();

			foreach ($rows as $row) {
				$idVenda = $this->parseDashboardCsvInt($row['id_venda'] ?? '');
				$dataHora = $this->parseDashboardCsvDateTime($row['datahora'] ?? '');
				$tipoProduto = $this->normalizeDashboardCsvValue($row['tipo_produto'] ?? '');
				$descricaoArtigo = $this->normalizeDashboardCsvValue($row['descricao_artigo'] ?? '');
				$categoria = $this->normalizeDashboardCsvValue($row['categoria'] ?? '');
				$precoUnitario = $this->parseDashboardCsvDecimal($row['preco_unitario'] ?? '');
				$quantidade = $this->parseDashboardCsvInt($row['quantidade'] ?? '');
				$receita = $this->parseDashboardCsvDecimal($row['receita_calculada'] ?? '');
				$canalVenda = $this->normalizeDashboardCsvValue($row['canal_venda'] ?? '');
				$cidade = $this->normalizeDashboardCsvValue($row['cidade'] ?? '');

				if ($idVenda === null || $dataHora === null || $tipoProduto === '' || $descricaoArtigo === '' || $categoria === '' || $precoUnitario === null || $quantidade === null || $receita === null || $canalVenda === '' || $cidade === '') {
					$skippedRows++;
					$invalidRows++;
					continue;
				}

				if (isset($seenIdVendaInBatch[$idVenda])) {
					$skippedRows++;
					$duplicateRows++;
					continue;
				}

				$stmtVendasExists->execute([':id_venda' => $idVenda]);
				$existingVenda = $stmtVendasExists->fetch(PDO::FETCH_ASSOC);
				if ($existingVenda) {
					$skippedRows++;
					$duplicateRows++;
					continue;
				}

				$seenIdVendaInBatch[$idVenda] = true;

				$idTipoProduto = $this->getOrCreateDashboardDimensionId('tipo_produto', $tipoProduto, $tipoCache);
				$idCategoria = $this->getOrCreateDashboardDimensionId('categorias', $categoria, $categoriaCache);
				$idCidade = $this->getOrCreateDashboardDimensionId('cidade', $cidade, $cidadeCache);
				$idProduto = $this->getOrCreateDashboardProdutoId($descricaoArtigo, $idTipoProduto, $precoUnitario, $produtoCache);

				if ($idTipoProduto === null || $idCategoria === null || $idCidade === null || $idProduto === null) {
					$skippedRows++;
					$invalidRows++;
					continue;
				}

				$stmtVendasInsert->execute([
					':id_venda' => $idVenda,
					':id_produto' => $idProduto,
					':id_cidade' => $idCidade,
					':id_categoria' => $idCategoria,
					':data_hora' => $dataHora,
					':quantidade' => $quantidade,
					':receita' => $receita,
					':canal_venda' => $canalVenda
				]);
				$importedRows++;
			}

			$conn->commit();
			if ($importedRows > 0) {
				$result['val'] = 1;
				$result['msg'] = 'CSV importado com sucesso.';
			} else if ($duplicateRows > 0 && $invalidRows == 0) {
				$result['val'] = 2;
				$result['msg'] = 'Nenhuma venda foi importada: todos os ID_Venda já existem na base de dados.';
			} else {
				$result['val'] = 2;
				$result['msg'] = 'Nenhuma venda válida foi importada a partir do CSV.';
			}
			$result['importedRows'] = $importedRows;
			$result['skippedRows'] = $skippedRows;
			$result['duplicateRows'] = $duplicateRows;
			$result['invalidRows'] = $invalidRows;
		} catch (Exception $e) {
			if ($conn->inTransaction()) {
				$conn->rollBack();
			}
			$result['msg'] = 'Erro na importação do CSV: '.$e->getMessage();
		}

		return $result;
	}

	function validateDashboardCsvRows($rows)
	{
		global $conn;

		$result = [
			'val' => 1,
			'msg' => 'Validação concluída.',
			'rows' => [],
			'validRows' => 0,
			'invalidRows' => 0,
			'duplicateFileRows' => 0,
			'duplicateDbRows' => 0
		];

		if (!is_array($rows) || count($rows) === 0) {
			$result['msg'] = 'Não existem linhas para validar.';
			return $result;
		}

		$idVendaCount = [];
		foreach ($rows as $row) {
			$idVendaValidation = $this->getDashboardCsvIdVendaValidation($row['id_venda'] ?? '');
			$idVenda = $idVendaValidation['id'];
			if ($idVenda !== null) {
				if (!isset($idVendaCount[$idVenda])) {
					$idVendaCount[$idVenda] = 0;
				}
				$idVendaCount[$idVenda]++;
			}
		}

		$sqlVendasExists = "SELECT id FROM vendas WHERE id_venda = :id_venda LIMIT 1";
		$stmtVendasExists = $conn->prepare($sqlVendasExists);

		$validatedRows = [];
		foreach ($rows as $row) {
			$idVendaValidation = $this->getDashboardCsvIdVendaValidation($row['id_venda'] ?? '');
			$idVenda = $idVendaValidation['id'];
			$dataHora = $this->parseDashboardCsvDateTime($row['datahora'] ?? '');
			$tipoProduto = $this->normalizeDashboardCsvValue($row['tipo_produto'] ?? '');
			$descricaoArtigo = $this->normalizeDashboardCsvValue($row['descricao_artigo'] ?? '');
			$categoria = $this->normalizeDashboardCsvValue($row['categoria'] ?? '');
			$precoUnitario = $this->parseDashboardCsvDecimal($row['preco_unitario'] ?? '');
			$quantidade = $this->parseDashboardCsvInt($row['quantidade'] ?? '');
			$receita = $this->parseDashboardCsvDecimal($row['receita_calculada'] ?? '');
			$canalVenda = $this->normalizeDashboardCsvValue($row['canal_venda'] ?? '');
			$cidade = $this->normalizeDashboardCsvValue($row['cidade'] ?? '');

			$validationValid = true;
			$validationMsg = 'Válida';

			if (!$idVendaValidation['valid']) {
				$validationValid = false;
				$validationMsg = $idVendaValidation['msg'];
			} else if ($dataHora === null) {
				$validationValid = false;
				$validationMsg = 'DataHora inválida';
			} else if ($tipoProduto === '') {
				$validationValid = false;
				$validationMsg = 'Tipo Produto obrigatório';
			} else if ($descricaoArtigo === '') {
				$validationValid = false;
				$validationMsg = 'Descrição obrigatória';
			} else if ($categoria === '') {
				$validationValid = false;
				$validationMsg = 'Categoria obrigatória';
			} else if ($precoUnitario === null) {
				$validationValid = false;
				$validationMsg = 'Preço inválido';
			} else if ($quantidade === null) {
				$validationValid = false;
				$validationMsg = 'Quantidade inválida';
			} else if ($receita === null) {
				$validationValid = false;
				$validationMsg = 'Receita inválida';
			} else if ($canalVenda === '') {
				$validationValid = false;
				$validationMsg = 'Canal obrigatório';
			} else if ($cidade === '') {
				$validationValid = false;
				$validationMsg = 'Cidade obrigatória';
			} else if (isset($idVendaCount[$idVenda]) && $idVendaCount[$idVenda] > 1) {
				$validationValid = false;
				$validationMsg = 'ID Venda duplicado no ficheiro';
				$result['duplicateFileRows']++;
			} else {
				$stmtVendasExists->execute([':id_venda' => $idVenda]);
				$existingVenda = $stmtVendasExists->fetch(PDO::FETCH_ASSOC);
				if ($existingVenda) {
					$validationValid = false;
					$validationMsg = 'ID Venda já existe na base de dados';
					$result['duplicateDbRows']++;
				}
			}

			$row['_validation_valid'] = $validationValid;
			$row['_validation_msg'] = $validationMsg;
			$validatedRows[] = $row;

			if ($validationValid) {
				$result['validRows']++;
			} else {
				$result['invalidRows']++;
			}
		}

		$result['rows'] = $validatedRows;
		return $result;
	}

	function getDashboardCsvStoragePaths($userId)
	{
		$workspacePath = dirname(__DIR__, 3);
		$finalRelativePath = "uploads/dashboard/csv/user".$userId;
		$tempRelativePath = "uploads/dashboard/csv_tmp/user".$userId;

		return [
			'workspacePath' => $workspacePath,
			'finalRelativePath' => $finalRelativePath,
			'tempRelativePath' => $tempRelativePath,
			'finalAbsolutePath' => $workspacePath."/".$finalRelativePath,
			'tempAbsolutePath' => $workspacePath."/".$tempRelativePath,
		];
	}

	function getDashboardVendasModalOptions()
	{
		global $conn;

		$produtoOptions = "";
		$cidadeOptions = "";
		$categoriaOptions = "";
		$canalOptions = "";
		$nextIdVenda = 1;

		try {
			$sqlProdutos = "SELECT
				MIN(id) AS id,
				TRIM(descricao) AS descricao,
				ROUND(COALESCE(preco_uni, 0), 2) AS preco_uni
			FROM produtos
			WHERE descricao IS NOT NULL AND TRIM(descricao) <> ''
			GROUP BY LOWER(TRIM(descricao)), ROUND(COALESCE(preco_uni, 0), 2)
			ORDER BY CONVERT(TRIM(descricao) USING utf8mb4) COLLATE utf8mb4_unicode_ci ASC, ROUND(COALESCE(preco_uni, 0), 2) ASC";
			$stmtProdutos = $conn->prepare($sqlProdutos);
			$stmtProdutos->execute();
			$rowsProdutos = $stmtProdutos->fetchAll(PDO::FETCH_ASSOC);
			foreach ($rowsProdutos as $rowProduto) {
				$produtoDescricao = trim((string)($rowProduto['descricao'] ?? ''));
				$produtoPreco = isset($rowProduto['preco_uni']) ? (float)$rowProduto['preco_uni'] : 0;
				$produtoPrecoFormatado = number_format($produtoPreco, 2, ',', '.');
				$produtoLabel = $produtoDescricao.' - '.$produtoPrecoFormatado.' €';
				$produtoOptions .= "<option value='".(int)$rowProduto['id']."' data-preco='".htmlspecialchars((string)$produtoPreco, ENT_QUOTES, 'UTF-8')."'>".htmlspecialchars($produtoLabel)."</option>";
			}

			$sqlCidade = "SELECT id, descricao FROM cidade ORDER BY CONVERT(descricao USING utf8mb4) COLLATE utf8mb4_unicode_ci ASC";
			$stmtCidade = $conn->prepare($sqlCidade);
			$stmtCidade->execute();
			$rowsCidade = $stmtCidade->fetchAll(PDO::FETCH_ASSOC);
			foreach ($rowsCidade as $rowCidade) {
				$cidadeOptions .= "<option value='".(int)$rowCidade['id']."'>".htmlspecialchars((string)$rowCidade['descricao'])."</option>";
			}

			$sqlCategorias = "SELECT id, descricao FROM categorias ORDER BY CONVERT(descricao USING utf8mb4) COLLATE utf8mb4_unicode_ci ASC";
			$stmtCategorias = $conn->prepare($sqlCategorias);
			$stmtCategorias->execute();
			$rowsCategorias = $stmtCategorias->fetchAll(PDO::FETCH_ASSOC);
			foreach ($rowsCategorias as $rowCategoria) {
				$categoriaOptions .= "<option value='".(int)$rowCategoria['id']."'>".htmlspecialchars((string)$rowCategoria['descricao'])."</option>";
			}

			$canalValues = [
				'Online' => 'Online',
				'Loja Física' => 'Loja Física'
			];

			$sqlCanais = "SELECT DISTINCT TRIM(canal_venda) AS canal_venda FROM vendas WHERE canal_venda IS NOT NULL AND TRIM(canal_venda) <> '' ORDER BY CONVERT(TRIM(canal_venda) USING utf8mb4) COLLATE utf8mb4_unicode_ci ASC";
			$stmtCanais = $conn->prepare($sqlCanais);
			$stmtCanais->execute();
			$rowsCanais = $stmtCanais->fetchAll(PDO::FETCH_ASSOC);
			foreach ($rowsCanais as $rowCanal) {
				$canal = isset($rowCanal['canal_venda']) ? trim((string)$rowCanal['canal_venda']) : '';
				if ($canal != '') {
					$canalValues[$canal] = $canal;
				}
			}

			natcasesort($canalValues);
			foreach ($canalValues as $canalValue) {
				$canalOptions .= "<option value='".htmlspecialchars((string)$canalValue, ENT_QUOTES, 'UTF-8')."'>".htmlspecialchars((string)$canalValue)."</option>";
			}

			$sqlNextIdVenda = "SELECT COALESCE(MAX(id_venda), 0) + 1 AS next_id_venda FROM vendas";
			$stmtNextIdVenda = $conn->prepare($sqlNextIdVenda);
			$stmtNextIdVenda->execute();
			$rowNextIdVenda = $stmtNextIdVenda->fetch(PDO::FETCH_ASSOC);
			if ($rowNextIdVenda && isset($rowNextIdVenda['next_id_venda'])) {
				$nextIdVenda = (int)$rowNextIdVenda['next_id_venda'];
				if ($nextIdVenda < 1) {
					$nextIdVenda = 1;
				}
			}
		} catch (PDOException $e) {
			$produtoOptions = "";
			$cidadeOptions = "";
			$categoriaOptions = "";
			$canalOptions = "";
			$nextIdVenda = 1;
		}

		return [
			'produtoOptions' => $produtoOptions,
			'cidadeOptions' => $cidadeOptions,
			'categoriaOptions' => $categoriaOptions,
			'canalOptions' => $canalOptions,
			'nextIdVenda' => $nextIdVenda
		];
	}

	function addDashboardVenda($info){
		$info = json_decode($info, true);

		$isAdmin = isset($_SESSION['tipo']) && (int)$_SESSION['tipo'] === 1;
		if (!$isAdmin || !isset($_SESSION['perm']['core']['dashboard']['Adicionar']) || !$_SESSION['perm']['core']['dashboard']['Adicionar']) {
			return json_encode(array('val' => 2, 'msg' => 'Sem permissão para adicionar vendas.'));
		}

		$idProduto = isset($info['id_produto']) ? (int)$info['id_produto'] : 0;
		$idCidade = isset($info['id_cidade']) ? (int)$info['id_cidade'] : 0;
		$idCategoria = isset($info['id_categoria']) ? (int)$info['id_categoria'] : 0;
		$dataHoraInput = isset($info['data_hora']) ? trim((string)$info['data_hora']) : '';
		$quantidade = isset($info['quantidade']) ? (int)$info['quantidade'] : 0;
		$canalVenda = isset($info['canal_venda']) ? trim((string)$info['canal_venda']) : '';

		if ($idProduto <= 0 || $idCidade <= 0 || $idCategoria <= 0 || $dataHoraInput == '' || $canalVenda == '') {
			return json_encode(array('val' => 2, 'msg' => 'Preencha todos os campos obrigatórios para adicionar a venda.'));
		}

		if ($quantidade < 0) {
			return json_encode(array('val' => 2, 'msg' => 'A quantidade deve ser maior ou igual a zero.'));
		}

		$dateTime = DateTime::createFromFormat('Y-m-d\TH:i', $dataHoraInput);
		if (!($dateTime instanceof DateTime)) {
			$dateTime = DateTime::createFromFormat('Y-m-d H:i:s', $dataHoraInput);
		}

		if (!($dateTime instanceof DateTime)) {
			return json_encode(array('val' => 2, 'msg' => 'Data/Hora inválida.'));
		}

		$dataHora = $dateTime->format('Y-m-d H:i:s');

		global $conn;
		$stmtProduto = $conn->prepare("SELECT preco_uni FROM produtos WHERE id = :id LIMIT 1");
		$stmtProduto->execute(array(':id' => $idProduto));
		$rowProduto = $stmtProduto->fetch(PDO::FETCH_ASSOC);
		if (!$rowProduto) {
			return json_encode(array('val' => 2, 'msg' => 'Produto inválido.'));
		}

		$precoUni = (float)$rowProduto['preco_uni'];
		if ($precoUni < 0) {
			$precoUni = 0;
		}

		$receita = round($precoUni * $quantidade, 2);

		$stmtNextVenda = $conn->prepare("SELECT COALESCE(MAX(id_venda), 0) + 1 AS next_id_venda FROM vendas");
		$stmtNextVenda->execute();
		$rowNextVenda = $stmtNextVenda->fetch(PDO::FETCH_ASSOC);
		$idVenda = ($rowNextVenda && isset($rowNextVenda['next_id_venda'])) ? (int)$rowNextVenda['next_id_venda'] : 1;
		if ($idVenda < 1) {
			$idVenda = 1;
		}

		$dados = array(
			'id_venda' => $idVenda,
			'id_produto' => $idProduto,
			'id_cidade' => $idCidade,
			'id_categoria' => $idCategoria,
			'DataHora' => $dataHora,
			'Quantidade' => $quantidade,
			'Receita' => $receita,
			'canal_venda' => $canalVenda
		);

		$insert = saveData("vendas", $dados);
		return json_encode(array('val' => $insert['val'], 'msg' => $insert['msg']));
	}

	function addDashboardProduto($info)
	{
		$info = json_decode($info, true);

		if (!isset($_SESSION['perm']['core']['dashboard']['Adicionar']) || !$_SESSION['perm']['core']['dashboard']['Adicionar']) {
			return json_encode(array('val' => 2, 'msg' => 'Sem permissão para adicionar produtos.'));
		}

		$descricao = isset($info['descricao']) ? trim((string)$info['descricao']) : '';
		$idTipoProduto = isset($info['id_tipo_produto']) ? (int)$info['id_tipo_produto'] : 0;
		$precoUni = isset($info['preco_uni']) ? (float)$info['preco_uni'] : 0;

		if ($descricao == '' || $idTipoProduto <= 0) {
			return json_encode(array('val' => 2, 'msg' => 'Preencha os campos obrigatórios para adicionar o produto.'));
		}

		if ($precoUni < 0) {
			return json_encode(array('val' => 2, 'msg' => 'O preço unitário deve ser maior ou igual a zero.'));
		}

		$dados = array(
			'descricao' => $descricao,
			'id_tipo_produto' => $idTipoProduto,
			'preco_uni' => $precoUni,
			'created_at' => date('Y-m-d H:i:s'),
			'updated_at' => date('Y-m-d H:i:s')
		);

		$insert = saveData("produtos", $dados);
		return json_encode(array('val' => $insert['val'], 'msg' => $insert['msg']));
	}

	function updateDashboardProduto($info)
	{
		$info = json_decode($info, true);

		if (!isset($_SESSION['perm']['core']['dashboard']['Editar']) || !$_SESSION['perm']['core']['dashboard']['Editar']) {
			return json_encode(array('val' => 2, 'msg' => 'Sem permissão para editar produtos.'));
		}

		$id = isset($info['id']) ? (int)$info['id'] : 0;
		$descricao = isset($info['descricao']) ? trim((string)$info['descricao']) : '';
		$idTipoProduto = isset($info['id_tipo_produto']) ? (int)$info['id_tipo_produto'] : 0;
		$precoUni = isset($info['preco_uni']) ? (float)$info['preco_uni'] : 0;

		if ($id <= 0 || $descricao == '' || $idTipoProduto <= 0) {
			return json_encode(array('val' => 2, 'msg' => 'Preencha os campos obrigatórios para editar o produto.'));
		}

		if ($precoUni < 0) {
			return json_encode(array('val' => 2, 'msg' => 'O preço unitário deve ser maior ou igual a zero.'));
		}

		$dados = array(
			'descricao' => $descricao,
			'id_tipo_produto' => $idTipoProduto,
			'preco_uni' => $precoUni,
			'updated_at' => date('Y-m-d H:i:s')
		);

		$update = saveData("produtos", $dados, $id);
		return json_encode(array('val' => $update['val'], 'msg' => $update['msg']));
	}

	function deleteDashboardData($tabela, $id, $idColumn = 'id')
	{
		global $conn;
		$val = 1;
		$msg = "";

		try {
			$sql = "DELETE FROM `".$tabela."` WHERE `".$idColumn."` = :id";
			$stmt = $conn->prepare($sql);
			$stmt->execute([':id' => $id]);

			$msg = ($stmt->rowCount() > 0) ? "Operação realizada com sucesso." : "Nenhuma alteração foi feita.";
		} catch (PDOException $e) {
			$msg = $this->formatDashboardDeleteErrorMessage($tabela, $e, false);
			$val = 2;
		}

		return array("val" => $val, "msg" => $msg);
	}

	function getDashboardEntityName($tabela, $plural = false)
	{
		switch ($tabela) {
			case 'vendas':
				return $plural ? 'vendas' : 'venda';
			case 'produtos':
				return $plural ? 'produtos' : 'produto';
			case 'categorias':
				return $plural ? 'categorias' : 'categoria';
			case 'cidade':
				return $plural ? 'cidades' : 'cidade';
			default:
				return $plural ? 'registos' : 'registo';
		}
	}

	function formatDashboardDeleteErrorMessage($tabela, $exception, $bulk = false)
	{
		$sqlState = (string)$exception->getCode();
		$driverCode = (isset($exception->errorInfo) && isset($exception->errorInfo[1])) ? (int)$exception->errorInfo[1] : 0;

		if ($sqlState === '23000' && $driverCode === 1451) {
			switch ($tabela) {
				case 'cidade':
					return $bulk
						? 'Não foi possível eliminar uma ou mais cidades porque existem vendas associadas.'
						: 'Não foi possível eliminar esta cidade porque existem vendas associadas.';
				case 'categorias':
					return $bulk
						? 'Não foi possível eliminar uma ou mais categorias porque existem produtos associados.'
						: 'Não foi possível eliminar esta categoria porque existem produtos associados.';
				case 'produtos':
					return $bulk
						? 'Não foi possível eliminar um ou mais produtos porque existem vendas associadas.'
						: 'Não foi possível eliminar este produto porque existem vendas associadas.';
				case 'vendas':
					return $bulk
						? 'Não foi possível eliminar uma ou mais vendas porque existem registos associados.'
						: 'Não foi possível eliminar esta venda porque existem registos associados.';
				default:
					return $bulk
						? 'Não foi possível eliminar um ou mais registos porque existem dados associados.'
						: 'Não foi possível eliminar este registo porque existem dados associados.';
			}
		}

		$entityName = $this->getDashboardEntityName($tabela, $bulk);
		return $bulk
			? 'Não foi possível eliminar os '.$entityName.'. Tente novamente.'
			: 'Não foi possível eliminar este '.$entityName.'. Tente novamente.';
	}

	function parseDashboardBulkIds($info)
	{
		$ids = [];
		if (!is_array($info) || !isset($info['ids']) || !is_array($info['ids'])) {
			return $ids;
		}

		foreach ($info['ids'] as $rawId) {
			$id = (int)$rawId;
			if ($id > 0) {
				$ids[$id] = $id;
			}
		}

		return array_values($ids);
	}

	function deleteDashboardDataBulk($tabela, $ids, $idColumn = 'id')
	{
		global $conn;
		$val = 1;
		$msg = "";

		if (!is_array($ids) || count($ids) < 1) {
			return array("val" => 2, "msg" => "Selecione pelo menos um registo para eliminar.");
		}

		try {
			$placeholders = [];
			$params = [];
			foreach ($ids as $index => $id) {
				$placeholder = ':id'.$index;
				$placeholders[] = $placeholder;
				$params[$placeholder] = (int)$id;
			}

			$sql = "DELETE FROM `".$tabela."` WHERE `".$idColumn."` IN (".implode(',', $placeholders).")";
			$conn->beginTransaction();
			$stmt = $conn->prepare($sql);
			$stmt->execute($params);
			$conn->commit();

			$msg = ($stmt->rowCount() > 0) ? "Operação realizada com sucesso." : "Nenhuma alteração foi feita.";
		} catch (PDOException $e) {
			if ($conn->inTransaction()) {
				$conn->rollBack();
			}
			$msg = $this->formatDashboardDeleteErrorMessage($tabela, $e, true);
			$val = 2;
		}

		return array("val" => $val, "msg" => $msg);
	}

	function deleteDashboardProdutoBulk($info)
	{
		$info = json_decode($info, true);

		if (!isset($_SESSION['perm']['core']['dashboard']['Apagar']) || !$_SESSION['perm']['core']['dashboard']['Apagar']) {
			return json_encode(array('val' => 2, 'msg' => 'Sem permissão para eliminar produtos.'));
		}

		$ids = $this->parseDashboardBulkIds($info);
		if (count($ids) < 1) {
			return json_encode(array('val' => 2, 'msg' => 'Selecione pelo menos um produto para eliminar.'));
		}

		$delete = $this->deleteDashboardDataBulk("produtos", $ids);
		return json_encode(array('val' => $delete['val'], 'msg' => $delete['msg']));
	}

	function allowDashboardDescricaoDuplicates($table)
	{
		global $conn;

		$allowedTables = ['categorias', 'cidade'];
		if (!in_array($table, $allowedTables, true)) {
			return;
		}

		try {
			$sqlIndexes = "SELECT INDEX_NAME
			FROM INFORMATION_SCHEMA.STATISTICS
			WHERE TABLE_SCHEMA = DATABASE()
			AND TABLE_NAME = :table_name
			AND COLUMN_NAME = 'descricao'
			AND NON_UNIQUE = 0
			AND INDEX_NAME <> 'PRIMARY'";

			$stmtIndexes = $conn->prepare($sqlIndexes);
			$stmtIndexes->execute([
				':table_name' => $table
			]);
			$indexes = $stmtIndexes->fetchAll(PDO::FETCH_ASSOC);

			foreach ($indexes as $index) {
				$indexName = isset($index['INDEX_NAME']) ? trim((string)$index['INDEX_NAME']) : '';
				if ($indexName == '') {
					continue;
				}

				$safeIndexName = str_replace('`', '', $indexName);
				$sqlDrop = "ALTER TABLE `".$table."` DROP INDEX `".$safeIndexName."`";
				$conn->exec($sqlDrop);
			}
		} catch (Exception $e) {
		}
	}

	function addDashboardCategoria($info)
	{
		$info = json_decode($info, true);

		if (!isset($_SESSION['perm']['core']['dashboard']['Adicionar']) || !$_SESSION['perm']['core']['dashboard']['Adicionar']) {
			return json_encode(array('val' => 2, 'msg' => 'Sem permissão para adicionar categorias.'));
		}

		$descricao = isset($info['descricao']) ? trim((string)$info['descricao']) : '';

		if ($descricao == '') {
			return json_encode(array('val' => 2, 'msg' => 'Preencha os campos obrigatórios para adicionar a categoria.'));
		}

		if (mb_strlen($descricao, 'UTF-8') > 100) {
			return json_encode(array('val' => 2, 'msg' => 'A descrição da categoria não pode ter mais de 100 caracteres.'));
		}

		$this->allowDashboardDescricaoDuplicates('categorias');

		$dados = array(
			'descricao' => $descricao
		);

		$insert = saveData("categorias", $dados);
		return json_encode(array('val' => $insert['val'], 'msg' => $insert['msg']));
	}

	function updateDashboardCategoria($info)
	{
		$info = json_decode($info, true);

		if (!isset($_SESSION['perm']['core']['dashboard']['Editar']) || !$_SESSION['perm']['core']['dashboard']['Editar']) {
			return json_encode(array('val' => 2, 'msg' => 'Sem permissão para editar categorias.'));
		}

		$id = isset($info['id']) ? (int)$info['id'] : 0;
		$descricao = isset($info['descricao']) ? trim((string)$info['descricao']) : '';

		if ($id <= 0 || $descricao == '') {
			return json_encode(array('val' => 2, 'msg' => 'Preencha os campos obrigatórios para editar a categoria.'));
		}

		if (mb_strlen($descricao, 'UTF-8') > 100) {
			return json_encode(array('val' => 2, 'msg' => 'A descrição da categoria não pode ter mais de 100 caracteres.'));
		}

		$this->allowDashboardDescricaoDuplicates('categorias');

		$dados = array(
			'descricao' => $descricao
		);

		$update = saveData("categorias", $dados, $id);
		return json_encode(array('val' => $update['val'], 'msg' => $update['msg']));
	}

	function deleteDashboardCategoriaBulk($info)
	{
		$info = json_decode($info, true);

		if (!isset($_SESSION['perm']['core']['dashboard']['Apagar']) || !$_SESSION['perm']['core']['dashboard']['Apagar']) {
			return json_encode(array('val' => 2, 'msg' => 'Sem permissão para eliminar categorias.'));
		}

		$ids = $this->parseDashboardBulkIds($info);
		if (count($ids) < 1) {
			return json_encode(array('val' => 2, 'msg' => 'Selecione pelo menos uma categoria para eliminar.'));
		}

		$delete = $this->deleteDashboardDataBulk("categorias", $ids);
		return json_encode(array('val' => $delete['val'], 'msg' => $delete['msg']));
	}

	function ensureDashboardCategoriasStatsColumns()
	{
		global $conn;

		$columns = [
			'total_produtos' => "ALTER TABLE categorias ADD COLUMN total_produtos INT UNSIGNED NOT NULL DEFAULT 0",
			'total_vendas' => "ALTER TABLE categorias ADD COLUMN total_vendas INT UNSIGNED NOT NULL DEFAULT 0",
			'total_receita' => "ALTER TABLE categorias ADD COLUMN total_receita DECIMAL(14,2) NOT NULL DEFAULT 0.00"
		];

		try {
			foreach ($columns as $columnName => $sqlAdd) {
				$sqlCheck = "SELECT COUNT(*)
				FROM INFORMATION_SCHEMA.COLUMNS
				WHERE TABLE_SCHEMA = DATABASE()
					AND TABLE_NAME = 'categorias'
					AND COLUMN_NAME = :column_name";

				$stmtCheck = $conn->prepare($sqlCheck);
				$stmtCheck->execute([
					':column_name' => $columnName
				]);
				$exists = (int)$stmtCheck->fetchColumn() > 0;

				if (!$exists) {
					$conn->exec($sqlAdd);
				}
			}
		} catch (Exception $e) {
		}
	}

	function syncDashboardCategoriasStatsColumns()
	{
		global $conn;
		$this->ensureDashboardCategoriasStatsColumns();

		try {
			$sql = "UPDATE categorias c
			LEFT JOIN (
				SELECT
					v.id_categoria AS categoria_id,
					COUNT(DISTINCT LOWER(TRIM(p.descricao))) AS total_produtos
				FROM vendas v
				LEFT JOIN produtos p ON p.id = v.id_produto
				WHERE p.descricao IS NOT NULL AND TRIM(p.descricao) <> ''
				GROUP BY v.id_categoria
			) p ON p.categoria_id = c.id
			LEFT JOIN (
				SELECT
					base.categoria_id,
					SUM(base.total_vendas_produto) AS total_vendas
				FROM (
					SELECT
						v.id_categoria AS categoria_id,
						LOWER(TRIM(p.descricao)) AS produto_key,
						COALESCE(SUM(v.Quantidade), 0) AS total_vendas_produto
					FROM vendas v
					LEFT JOIN produtos p ON p.id = v.id_produto
					WHERE p.descricao IS NOT NULL AND TRIM(p.descricao) <> ''
					GROUP BY v.id_categoria, LOWER(TRIM(p.descricao))
				) base
				GROUP BY base.categoria_id
			) s ON s.categoria_id = c.id
			LEFT JOIN (
				SELECT v.id_categoria AS categoria_id, COALESCE(SUM(v.Receita), 0) AS total_receita
				FROM vendas v
				GROUP BY v.id_categoria
			) r ON r.categoria_id = c.id
			SET
				c.total_produtos = COALESCE(p.total_produtos, 0),
				c.total_vendas = COALESCE(s.total_vendas, 0),
				c.total_receita = COALESCE(r.total_receita, 0)";

			$conn->prepare($sql)->execute();
		} catch (Exception $e) {
		}
	}

	function addDashboardCidade($info)
	{
		$info = json_decode($info, true);

		if (!isset($_SESSION['perm']['core']['dashboard']['Adicionar']) || !$_SESSION['perm']['core']['dashboard']['Adicionar']) {
			return json_encode(array('val' => 2, 'msg' => 'Sem permissão para adicionar cidades.'));
		}

		$descricao = isset($info['descricao']) ? trim((string)$info['descricao']) : '';

		if ($descricao == '') {
			return json_encode(array('val' => 2, 'msg' => 'Preencha os campos obrigatórios para adicionar a cidade.'));
		}

		if (mb_strlen($descricao, 'UTF-8') > 100) {
			return json_encode(array('val' => 2, 'msg' => 'A descrição da cidade não pode ter mais de 100 caracteres.'));
		}

		$this->allowDashboardDescricaoDuplicates('cidade');
		$geo = $this->getDashboardCidadeGeoByDescricao($descricao);

		$dados = array(
			'descricao' => $descricao,
			'id_distrito' => $geo['id_distrito'],
			'id_concelho' => $geo['id_concelho']
		);

		$insert = saveData("cidade", $dados);
		return json_encode(array('val' => $insert['val'], 'msg' => $insert['msg']));
	}

	function updateDashboardCidade($info)
	{
		$info = json_decode($info, true);

		if (!isset($_SESSION['perm']['core']['dashboard']['Editar']) || !$_SESSION['perm']['core']['dashboard']['Editar']) {
			return json_encode(array('val' => 2, 'msg' => 'Sem permissão para editar cidades.'));
		}

		$id = isset($info['id']) ? (int)$info['id'] : 0;
		$descricao = isset($info['descricao']) ? trim((string)$info['descricao']) : '';

		if ($id <= 0 || $descricao == '') {
			return json_encode(array('val' => 2, 'msg' => 'Preencha os campos obrigatórios para editar a cidade.'));
		}

		if (mb_strlen($descricao, 'UTF-8') > 100) {
			return json_encode(array('val' => 2, 'msg' => 'A descrição da cidade não pode ter mais de 100 caracteres.'));
		}

		$this->allowDashboardDescricaoDuplicates('cidade');
		$geo = $this->getDashboardCidadeGeoByDescricao($descricao);

		$dados = array(
			'descricao' => $descricao,
			'id_distrito' => $geo['id_distrito'],
			'id_concelho' => $geo['id_concelho']
		);

		$update = saveData("cidade", $dados, $id);
		return json_encode(array('val' => $update['val'], 'msg' => $update['msg']));
	}

	function deleteDashboardCidadeBulk($info)
	{
		$info = json_decode($info, true);

		if (!isset($_SESSION['perm']['core']['dashboard']['Apagar']) || !$_SESSION['perm']['core']['dashboard']['Apagar']) {
			return json_encode(array('val' => 2, 'msg' => 'Sem permissão para eliminar cidades.'));
		}

		$ids = $this->parseDashboardBulkIds($info);
		if (count($ids) < 1) {
			return json_encode(array('val' => 2, 'msg' => 'Selecione pelo menos uma cidade para eliminar.'));
		}

		$delete = $this->deleteDashboardDataBulk("cidade", $ids);
		return json_encode(array('val' => $delete['val'], 'msg' => $delete['msg']));
	}

	function getDashboardCidadeGeoByDescricao($descricao)
	{
		global $conn;

		$descricao = trim((string)$descricao);
		$result = [
			'id_distrito' => 0,
			'id_concelho' => 0
		];

		if ($descricao == '') {
			return $result;
		}

		try {
			$params = [':descricao' => mb_strtolower($descricao, 'UTF-8')];

			$sqlConcelho = "SELECT cc.id, cc.id_distrito
				FROM core_concelhos cc
				WHERE LOWER(TRIM(cc.descricao)) = :descricao
				LIMIT 1";
			$stmtConcelho = $conn->prepare($sqlConcelho);
			$stmtConcelho->execute($params);
			$rowConcelho = $stmtConcelho->fetch(PDO::FETCH_ASSOC);
			if ($rowConcelho) {
				$result['id_concelho'] = (int)$rowConcelho['id'];
				$result['id_distrito'] = (int)$rowConcelho['id_distrito'];
				return $result;
			}

			$sqlDistrito = "SELECT cd.id
				FROM core_distritos cd
				WHERE LOWER(TRIM(cd.descricao)) = :descricao
				LIMIT 1";
			$stmtDistrito = $conn->prepare($sqlDistrito);
			$stmtDistrito->execute($params);
			$rowDistrito = $stmtDistrito->fetch(PDO::FETCH_ASSOC);
			if ($rowDistrito) {
				$result['id_distrito'] = (int)$rowDistrito['id'];
			}
		} catch (Exception $e) {
		}

		return $result;
	}

	function backfillDashboardCidadeGeoRelations()
	{
		global $conn;

		try {
			$sqlConcelho = "UPDATE cidade c
				INNER JOIN core_concelhos cc ON LOWER(TRIM(cc.descricao)) = LOWER(TRIM(c.descricao))
				SET
					c.id_concelho = cc.id,
					c.id_distrito = CASE
						WHEN c.id_distrito IS NULL OR c.id_distrito = 0 THEN cc.id_distrito
						ELSE c.id_distrito
					END
				WHERE c.id_concelho IS NULL OR c.id_concelho = 0";
			$conn->prepare($sqlConcelho)->execute();

			$sqlDistritoFromConcelho = "UPDATE cidade c
				INNER JOIN core_concelhos cc ON cc.id = c.id_concelho
				SET c.id_distrito = cc.id_distrito
				WHERE (c.id_distrito IS NULL OR c.id_distrito = 0)
					AND c.id_concelho IS NOT NULL
					AND c.id_concelho > 0";
			$conn->prepare($sqlDistritoFromConcelho)->execute();

			$sqlDistrito = "UPDATE cidade c
				INNER JOIN core_distritos cd ON LOWER(TRIM(cd.descricao)) = LOWER(TRIM(c.descricao))
				SET c.id_distrito = cd.id
				WHERE c.id_distrito IS NULL OR c.id_distrito = 0";
			$conn->prepare($sqlDistrito)->execute();
		} catch (Exception $e) {
		}
	}

	function updateDashboardVenda($info)
	{
		$info = json_decode($info, true);

		if (!isset($_SESSION['perm']['core']['dashboard']['Editar']) || !$_SESSION['perm']['core']['dashboard']['Editar']) {
			return json_encode(array('val' => 2, 'msg' => 'Sem permissão para editar vendas.'));
		}

		$id = isset($info['id']) ? (int)$info['id'] : 0;
		$idProduto = isset($info['id_produto']) ? (int)$info['id_produto'] : 0;
		$idCidade = isset($info['id_cidade']) ? (int)$info['id_cidade'] : 0;
		$idCategoria = isset($info['id_categoria']) ? (int)$info['id_categoria'] : 0;
		$dataHoraInput = isset($info['data_hora']) ? trim((string)$info['data_hora']) : '';
		$quantidade = isset($info['quantidade']) ? (int)$info['quantidade'] : 0;
		$canalVenda = isset($info['canal_venda']) ? trim((string)$info['canal_venda']) : '';

		if ($id <= 0 || $idProduto <= 0 || $idCidade <= 0 || $idCategoria <= 0 || $dataHoraInput == '' || $canalVenda == '') {
			return json_encode(array('val' => 2, 'msg' => 'Preencha todos os campos obrigatórios para editar a venda.'));
		}

		if ($quantidade < 0) {
			return json_encode(array('val' => 2, 'msg' => 'A quantidade deve ser maior ou igual a zero.'));
		}

		$dateTime = DateTime::createFromFormat('Y-m-d\TH:i', $dataHoraInput);
		if (!($dateTime instanceof DateTime)) {
			$dateTime = DateTime::createFromFormat('Y-m-d H:i:s', $dataHoraInput);
		}

		if (!($dateTime instanceof DateTime)) {
			return json_encode(array('val' => 2, 'msg' => 'Data/Hora inválida.'));
		}

		$dataHora = $dateTime->format('Y-m-d H:i:s');

		global $conn;
		$stmtProduto = $conn->prepare("SELECT preco_uni FROM produtos WHERE id = :id LIMIT 1");
		$stmtProduto->execute(array(':id' => $idProduto));
		$rowProduto = $stmtProduto->fetch(PDO::FETCH_ASSOC);
		if (!$rowProduto) {
			return json_encode(array('val' => 2, 'msg' => 'Produto inválido.'));
		}

		$precoUni = (float)$rowProduto['preco_uni'];
		if ($precoUni < 0) {
			$precoUni = 0;
		}

		$receita = round($precoUni * $quantidade, 2);

		$dados = array(
			'id_produto' => $idProduto,
			'id_cidade' => $idCidade,
			'id_categoria' => $idCategoria,
			'DataHora' => $dataHora,
			'Quantidade' => $quantidade,
			'Receita' => $receita,
			'canal_venda' => $canalVenda
		);

		$update = saveData("vendas", $dados, $id);
		return json_encode(array('val' => $update['val'], 'msg' => $update['msg']));
	}

	function deleteDashboardVendaBulk($info)
	{
		$info = json_decode($info, true);

		if (!isset($_SESSION['perm']['core']['dashboard']['Apagar']) || !$_SESSION['perm']['core']['dashboard']['Apagar']) {
			return json_encode(array('val' => 2, 'msg' => 'Sem permissão para eliminar vendas.'));
		}

		$ids = $this->parseDashboardBulkIds($info);
		if (count($ids) < 1) {
			return json_encode(array('val' => 2, 'msg' => 'Selecione pelo menos uma venda para eliminar.'));
		}

		$delete = $this->deleteDashboardDataBulk("vendas", $ids);
		return json_encode(array('val' => $delete['val'], 'msg' => $delete['msg']));
	}

	function buildDashboardVendasFilterOptions($array)
	{
		$categorias = [];
		$cidades = [];
		$canais = [];
		$produtos = [];

		foreach ($array as $row) {
			if (isset($row['categoria']) && trim((string)$row['categoria']) != '') {
				$categorias[trim((string)$row['categoria'])] = trim((string)$row['categoria']);
			}
			if (isset($row['cidade']) && trim((string)$row['cidade']) != '') {
				$cidades[trim((string)$row['cidade'])] = trim((string)$row['cidade']);
			}
			if (isset($row['canal_venda']) && trim((string)$row['canal_venda']) != '') {
				$canais[trim((string)$row['canal_venda'])] = trim((string)$row['canal_venda']);
			}
			if (isset($row['produto']) && trim((string)$row['produto']) != '') {
				$produtos[trim((string)$row['produto'])] = trim((string)$row['produto']);
			}
		}

		sort($categorias);
		sort($cidades);
		sort($canais);
		sort($produtos);

		$optionsCategoria = "";
		foreach ($categorias as $categoria) {
			$optionsCategoria .= "<option value='".htmlspecialchars($categoria)."'>".htmlspecialchars($categoria)."</option>";
		}

		$optionsCidade = "";
		foreach ($cidades as $cidade) {
			$optionsCidade .= "<option value='".htmlspecialchars($cidade)."'>".htmlspecialchars($cidade)."</option>";
		}

		$optionsCanal = "";
		foreach ($canais as $canal) {
			$optionsCanal .= "<option value='".htmlspecialchars($canal)."'>".htmlspecialchars($canal)."</option>";
		}

		$optionsProduto = "";
		foreach ($produtos as $produto) {
			$optionsProduto .= "<option value='".htmlspecialchars($produto)."'>".htmlspecialchars($produto)."</option>";
		}

		return [
			'categoria' => $optionsCategoria,
			'cidade' => $optionsCidade,
			'canal' => $optionsCanal,
			'produto' => $optionsProduto
		];
	}

	function buildDashboardProdutosFilterOptions($array)
	{
		$produtos = [];
		$tipos = [];

		foreach ($array as $row) {
			if (isset($row['descricao']) && trim((string)$row['descricao']) != '') {
				$produtos[trim((string)$row['descricao'])] = trim((string)$row['descricao']);
			}
			if (isset($row['tipo_produto']) && trim((string)$row['tipo_produto']) != '') {
				$tipos[trim((string)$row['tipo_produto'])] = trim((string)$row['tipo_produto']);
			}
		}

		sort($produtos);
		sort($tipos);

		$optionsProdutos = "";
		foreach ($produtos as $produto) {
			$optionsProdutos .= "<option value='".htmlspecialchars($produto)."'>".htmlspecialchars($produto)."</option>";
		}

		$optionsTipos = "";
		foreach ($tipos as $tipo) {
			$optionsTipos .= "<option value='".htmlspecialchars($tipo)."'>".htmlspecialchars($tipo)."</option>";
		}

		return [
			'produto' => $optionsProdutos,
			'tipo' => $optionsTipos
		];
	}

	function buildDashboardCategoriasFilterOptions($array)
	{
		$categorias = [];

		foreach ($array as $row) {
			if (isset($row['descricao']) && trim((string)$row['descricao']) != '') {
				$categorias[trim((string)$row['descricao'])] = trim((string)$row['descricao']);
			}
		}

		sort($categorias);

		$optionsCategorias = "";
		foreach ($categorias as $categoria) {
			$optionsCategorias .= "<option value='".htmlspecialchars($categoria)."'>".htmlspecialchars($categoria)."</option>";
		}

		return [
			'categoria' => $optionsCategorias
		];
	}

	function buildDashboardCidadesFilterOptions($array)
	{
		$cidades = [];
		$distritos = [];
		$concelhos = [];
		$produtos = [];

		foreach ($array as $row) {
			if (isset($row['descricao']) && trim((string)$row['descricao']) != '') {
				$cidades[trim((string)$row['descricao'])] = trim((string)$row['descricao']);
			}
			if (isset($row['distrito']) && trim((string)$row['distrito']) != '') {
				$distritos[trim((string)$row['distrito'])] = trim((string)$row['distrito']);
			}
			if (isset($row['concelho']) && trim((string)$row['concelho']) != '') {
				$concelhos[trim((string)$row['concelho'])] = trim((string)$row['concelho']);
			}
			if (isset($row['produtos_tokens']) && trim((string)$row['produtos_tokens']) != '') {
				$tokens = explode('||', (string)$row['produtos_tokens']);
				foreach ($tokens as $token) {
					$token = trim((string)$token);
					if ($token != '') {
						$produtos[$token] = $token;
					}
				}
			}
		}

		sort($cidades);
		sort($distritos);
		sort($concelhos);
		sort($produtos);

		$optionsCidades = "";
		foreach ($cidades as $cidade) {
			$optionsCidades .= "<option value='".htmlspecialchars($cidade)."'>".htmlspecialchars($cidade)."</option>";
		}

		$optionsDistritos = "";
		foreach ($distritos as $distrito) {
			$optionsDistritos .= "<option value='".htmlspecialchars($distrito)."'>".htmlspecialchars($distrito)."</option>";
		}

		$optionsConcelhos = "";
		foreach ($concelhos as $concelho) {
			$optionsConcelhos .= "<option value='".htmlspecialchars($concelho)."'>".htmlspecialchars($concelho)."</option>";
		}

		$optionsProdutos = "";
		foreach ($produtos as $produto) {
			$optionsProdutos .= "<option value='".htmlspecialchars($produto)."'>".htmlspecialchars($produto)."</option>";
		}

		return [
			'cidade' => $optionsCidades,
			'distrito' => $optionsDistritos,
			'concelho' => $optionsConcelhos,
			'produto' => $optionsProdutos
		];
	}

	function normalizeDashboardStatsDate($date)
	{
		$date = trim((string)$date);
		if ($date == '') {
			return '';
		}

		$dateObj = DateTime::createFromFormat('Y-m-d', $date);
		if (!($dateObj instanceof DateTime) || $dateObj->format('Y-m-d') != $date) {
			return '';
		}

		return $date;
	}

	function normalizeDashboardMultiFilterValues($value)
	{
		$values = [];

		if (is_array($value)) {
			$values = $value;
		} else if (is_string($value) && trim($value) != '') {
			$values = [$value];
		}

		$normalized = [];
		foreach ($values as $item) {
			$item = trim((string)$item);
			if ($item != '') {
				$normalized[] = $item;
			}
		}

		$normalized = array_values(array_unique($normalized));
		return $normalized;
	}

	function normalizeDashboardFilterNumber($value)
	{
		$raw = trim((string)$value);
		if ($raw == '') {
			return null;
		}

		$normalized = str_replace([' ', '€'], '', $raw);
		if (strpos($normalized, ',') !== false) {
			$normalized = str_replace('.', '', $normalized);
			$normalized = str_replace(',', '.', $normalized);
		}

		if (!is_numeric($normalized)) {
			return null;
		}

		return (float)$normalized;
	}

	function getDashboardStatsFilters($filters = [])
	{
		if (!is_array($filters)) {
			$filters = [];
		}

		return [
			'startDate' => $this->normalizeDashboardStatsDate($filters['startDate'] ?? ''),
			'endDate' => $this->normalizeDashboardStatsDate($filters['endDate'] ?? ''),
			'categoria' => trim((string)($filters['categoria'] ?? '')),
			'cidade' => trim((string)($filters['cidade'] ?? '')),
			'canal' => trim((string)($filters['canal'] ?? '')),
			'produto' => trim((string)($filters['produto'] ?? '')),
			'categoriaId' => (int)($filters['categoriaId'] ?? 0),
			'cidadeId' => (int)($filters['cidadeId'] ?? 0),
			'produtoId' => (int)($filters['produtoId'] ?? 0),
		];
	}

	function buildDashboardStatsWhereSql($filters, &$params)
	{
		$whereSql = " WHERE 1=1";

		if ($filters['startDate'] != '') {
			$whereSql .= " AND v.DataHora >= :start_datetime";
			$params[':start_datetime'] = $filters['startDate'].' 00:00:00';
		}

		if ($filters['endDate'] != '') {
			$whereSql .= " AND v.DataHora <= :end_datetime";
			$params[':end_datetime'] = $filters['endDate'].' 23:59:59';
		}

		if ($filters['canal'] != '') {
			$whereSql .= " AND LOWER(TRIM(v.canal_venda)) = :canal";
			$params[':canal'] = mb_strtolower($filters['canal'], 'UTF-8');
		}

		if ($filters['categoriaId'] > 0) {
			$whereSql .= " AND v.id_categoria = :categoria_id";
			$params[':categoria_id'] = $filters['categoriaId'];
		} else if ($filters['categoria'] != '') {
			$whereSql .= " AND v.id_categoria IN (SELECT id FROM categorias WHERE LOWER(TRIM(descricao)) = :categoria_nome)";
			$params[':categoria_nome'] = mb_strtolower($filters['categoria'], 'UTF-8');
		}

		if ($filters['cidadeId'] > 0) {
			$whereSql .= " AND v.id_cidade = :cidade_id";
			$params[':cidade_id'] = $filters['cidadeId'];
		} else if ($filters['cidade'] != '') {
			$whereSql .= " AND v.id_cidade IN (SELECT id FROM cidade WHERE LOWER(TRIM(descricao)) = :cidade_nome)";
			$params[':cidade_nome'] = mb_strtolower($filters['cidade'], 'UTF-8');
		}

		if ($filters['produtoId'] > 0) {
			$whereSql .= " AND v.id_produto = :produto_id";
			$params[':produto_id'] = $filters['produtoId'];
		} else if ($filters['produto'] != '') {
			$whereSql .= " AND v.id_produto IN (SELECT id FROM produtos WHERE descricao LIKE :produto_nome)";
			$params[':produto_nome'] = '%'.$filters['produto'].'%';
		}

		return $whereSql;
	}

	function getDashboardRevenueSummary($filters = [])
	{
		global $conn;

		$filters = $this->getDashboardStatsFilters($filters);
		$params = [];
		$whereSql = $this->buildDashboardStatsWhereSql($filters, $params);

		$sql = "SELECT
			COALESCE(SUM(v.Receita), 0) AS total_revenue,
			COALESCE(SUM(v.Quantidade), 0) AS total_quantity,
			COUNT(v.id) AS total_sales,
			COALESCE(AVG(v.Receita), 0) AS average_ticket
		FROM vendas v".$whereSql;

		$stmt = $conn->prepare($sql);
		$stmt->execute($params);
		$row = $stmt->fetch(PDO::FETCH_ASSOC);

		if (!$row) {
			$row = [
				'total_revenue' => 0,
				'total_quantity' => 0,
				'total_sales' => 0,
				'average_ticket' => 0
			];
		}

		return [
			'totalRevenue' => (float)$row['total_revenue'],
			'totalQuantity' => (int)$row['total_quantity'],
			'totalSales' => (int)$row['total_sales'],
			'averageTicket' => (float)$row['average_ticket']
		];
	}

	function getDashboardRevenueMonthly($filters = [])
	{
		global $conn;

		$filters = $this->getDashboardStatsFilters($filters);
		$params = [];
		$whereSql = $this->buildDashboardStatsWhereSql($filters, $params);

		$sql = "SELECT
			DATE_FORMAT(v.DataHora, '%Y-%m') AS month_label,
			COALESCE(SUM(v.Receita), 0) AS total_revenue
		FROM vendas v".$whereSql."
		GROUP BY DATE_FORMAT(v.DataHora, '%Y-%m')
		ORDER BY DATE_FORMAT(v.DataHora, '%Y-%m') ASC";

		$stmt = $conn->prepare($sql);
		$stmt->execute($params);
		$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

		$result = [];
		foreach ($rows as $row) {
			$result[] = [
				'label' => (string)$row['month_label'],
				'revenue' => (float)$row['total_revenue']
			];
		}

		return $result;
	}

	function getDashboardRevenueByCategory($filters = [])
	{
		global $conn;

		$filters = $this->getDashboardStatsFilters($filters);
		$params = [];
		$whereSql = $this->buildDashboardStatsWhereSql($filters, $params);

		$sql = "SELECT
			ca.descricao AS category_label,
			COALESCE(SUM(v.Receita), 0) AS total_revenue
		FROM vendas v
		LEFT JOIN categorias ca ON ca.id = v.id_categoria".$whereSql."
		GROUP BY ca.descricao
		ORDER BY total_revenue DESC";

		$stmt = $conn->prepare($sql);
		$stmt->execute($params);
		$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

		$result = [];
		foreach ($rows as $row) {
			$result[] = [
				'label' => (trim((string)($row['category_label'] ?? '')) ?: 'Desconhecido'),
				'revenue' => (float)$row['total_revenue']
			];
		}

		return $result;
	}

	function getDashboardRevenueByCity($filters = [])
	{
		global $conn;

		$filters = $this->getDashboardStatsFilters($filters);
		$params = [];
		$whereSql = $this->buildDashboardStatsWhereSql($filters, $params);

		$sql = "SELECT
			c.descricao AS city_label,
			COALESCE(SUM(v.Receita), 0) AS total_revenue
		FROM vendas v
		LEFT JOIN cidade c ON c.id = v.id_cidade".$whereSql."
		GROUP BY c.descricao
		ORDER BY total_revenue DESC";

		$stmt = $conn->prepare($sql);
		$stmt->execute($params);
		$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

		$result = [];
		foreach ($rows as $row) {
			$result[] = [
				'label' => (trim((string)($row['city_label'] ?? '')) ?: 'Desconhecido'),
				'revenue' => (float)$row['total_revenue']
			];
		}

		return $result;
	}

	function getDashboardRevenueByChannel($filters = [])
	{
		global $conn;

		$filters = $this->getDashboardStatsFilters($filters);
		$params = [];
		$whereSql = $this->buildDashboardStatsWhereSql($filters, $params);

		$sql = "SELECT
			v.canal_venda AS channel_label,
			COALESCE(SUM(v.Receita), 0) AS total_revenue
		FROM vendas v".$whereSql."
		GROUP BY v.canal_venda
		ORDER BY total_revenue DESC";

		$stmt = $conn->prepare($sql);
		$stmt->execute($params);
		$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

		$result = [];
		foreach ($rows as $row) {
			$result[] = [
				'label' => (trim((string)($row['channel_label'] ?? '')) ?: 'Desconhecido'),
				'revenue' => (float)$row['total_revenue']
			];
		}

		return $result;
	}

	function getDashboardTopProducts($filters = [], $limit = 10)
	{
		global $conn;

		$filters = $this->getDashboardStatsFilters($filters);
		$params = [];
		$whereSql = $this->buildDashboardStatsWhereSql($filters, $params);

		$limit = (int)$limit;
		if ($limit <= 0) {
			$limit = 10;
		}

		$sql = "SELECT
			p.descricao AS product_label,
			COALESCE(SUM(v.Receita), 0) AS total_revenue,
			COALESCE(SUM(v.Quantidade), 0) AS total_quantity,
			COUNT(v.id) AS total_sales
		FROM vendas v
		LEFT JOIN produtos p ON p.id = v.id_produto".$whereSql."
		GROUP BY p.descricao
		ORDER BY total_revenue DESC
		LIMIT ".$limit;

		$stmt = $conn->prepare($sql);
		$stmt->execute($params);
		$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

		$result = [];
		foreach ($rows as $row) {
			$result[] = [
				'label' => (trim((string)($row['product_label'] ?? '')) ?: 'Desconhecido'),
				'revenue' => (float)$row['total_revenue'],
				'quantity' => (int)$row['total_quantity'],
				'sales' => (int)$row['total_sales']
			];
		}

		return $result;
	}

	function getDashboardStatsData($filters = [])
	{
		$revenue = $this->getDashboardRevenueSummary($filters);
		$monthly = $this->getDashboardRevenueMonthly($filters);
		$categories = $this->getDashboardRevenueByCategory($filters);
		$cities = $this->getDashboardRevenueByCity($filters);
		$channels = $this->getDashboardRevenueByChannel($filters);
		$topProducts = $this->getDashboardTopProducts($filters, 10);

		return [
			'revenue' => $revenue,
			'monthly' => $monthly,
			'categories' => $categories,
			'cities' => $cities,
			'channels' => $channels,
			'topProducts' => $topProducts,
			'filters' => $this->getDashboardStatsFilters($filters)
		];
	}

	function exportDashboardVendasPdf($info)
	{
		global $conn;
		$info = json_decode($info, true);

		$startDate = isset($info['startDate']) ? trim((string)$info['startDate']) : '';
		$endDate = isset($info['endDate']) ? trim((string)$info['endDate']) : '';
		$categorias = $this->normalizeDashboardMultiFilterValues($info['categoria'] ?? []);
		$cidades = $this->normalizeDashboardMultiFilterValues($info['cidade'] ?? []);
		$canais = $this->normalizeDashboardMultiFilterValues($info['canal'] ?? []);
		$produtos = $this->normalizeDashboardMultiFilterValues($info['produto'] ?? []);

		if ($startDate == '' || $endDate == '') {
			return json_encode(array("val" => 2, "msg" => "Para gerar PDF deve preencher: intervalo de datas."));
		}

		$startDateObj = DateTime::createFromFormat('Y-m-d', $startDate);
		$endDateObj = DateTime::createFromFormat('Y-m-d', $endDate);
		if (!($startDateObj instanceof DateTime) || !($endDateObj instanceof DateTime) || $startDateObj->format('Y-m-d') != $startDate || $endDateObj->format('Y-m-d') != $endDate) {
			return json_encode(array("val" => 2, "msg" => "Intervalo de datas inválido."));
		}

		if ($startDate > $endDate) {
			return json_encode(array("val" => 2, "msg" => "Data inicial não pode ser maior que a data final."));
		}

		try {
			$sql = "SELECT
				v.DataHora,
				p.descricao AS produto,
				ca.descricao AS categoria,
				v.Quantidade AS quantidade,
				v.Receita AS total,
				v.canal_venda,
				c.descricao AS cidade
			FROM vendas v
			LEFT JOIN produtos p ON p.id = v.id_produto
			LEFT JOIN cidade c ON c.id = v.id_cidade
			LEFT JOIN categorias ca ON ca.id = v.id_categoria
			WHERE v.DataHora BETWEEN :start_datetime AND :end_datetime";

			$params = [
				':start_datetime' => $startDate.' 00:00:00',
				':end_datetime' => $endDate.' 23:59:59'
			];

			if (count($categorias) > 0) {
				$categoriaPlaceholders = [];
				foreach ($categorias as $idx => $categoriaValue) {
					$placeholder = ':categoria_'.$idx;
					$categoriaPlaceholders[] = $placeholder;
					$params[$placeholder] = mb_strtolower($categoriaValue, 'UTF-8');
				}
				$sql .= " AND LOWER(TRIM(ca.descricao)) IN (".implode(',', $categoriaPlaceholders).")";
			}

			if (count($cidades) > 0) {
				$cidadePlaceholders = [];
				foreach ($cidades as $idx => $cidadeValue) {
					$placeholder = ':cidade_'.$idx;
					$cidadePlaceholders[] = $placeholder;
					$params[$placeholder] = mb_strtolower($cidadeValue, 'UTF-8');
				}
				$sql .= " AND LOWER(TRIM(c.descricao)) IN (".implode(',', $cidadePlaceholders).")";
			}

			if (count($canais) > 0) {
				$canalPlaceholders = [];
				foreach ($canais as $idx => $canalValue) {
					$placeholder = ':canal_'.$idx;
					$canalPlaceholders[] = $placeholder;
					$params[$placeholder] = mb_strtolower($canalValue, 'UTF-8');
				}
				$sql .= " AND LOWER(TRIM(v.canal_venda)) IN (".implode(',', $canalPlaceholders).")";
			}

			if (count($produtos) > 0) {
				$produtoPlaceholders = [];
				foreach ($produtos as $idx => $produtoValue) {
					$placeholder = ':produto_'.$idx;
					$produtoPlaceholders[] = $placeholder;
					$params[$placeholder] = mb_strtolower($produtoValue, 'UTF-8');
				}
				$sql .= " AND LOWER(TRIM(p.descricao)) IN (".implode(',', $produtoPlaceholders).")";
			}

			$sql .= " ORDER BY v.DataHora DESC";

			$stmt = $conn->prepare($sql);
			$stmt->execute($params);
			$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

			if (!$rows) {
				return json_encode(array("val" => 2, "msg" => "Não existem registos para os filtros selecionados."));
			}

			require_once dirname(__DIR__, 3)."/vendor/autoload.php";
			$workspacePath = dirname(__DIR__, 3);

			$mpdf = new \Mpdf\Mpdf([
				"mode"            => "utf-8",
				"format"          => "A4-L",
				"margin_top"      => 38,
				"margin_bottom"   => 22,
				"margin_left"     => 14,
				"margin_right"    => 14,
				"margin_header"   => 8,
				"margin_footer"   => 6,
			]);

			$mpdf->AliasNbPages();

			$logoTag = "<span style='font-size:22px;font-weight:900;color:#FF8800;letter-spacing:1px;font-family:Arial;'>FPB</span>";

			$mpdf->SetHTMLHeader("
				<table width='100%' cellpadding='0' cellspacing='0'
					style='border-bottom:2.5px solid #FF8800;padding-bottom:5px;'>
					<tr>
						<td width='50%'>".$logoTag."</td>
						<td width='50%' style='text-align:right;font-size:14px;
							font-weight:bold;color:#111111;font-family:Arial;'>
							Relatório de Vendas
						</td>
					</tr>
				</table>");

			$mpdf->SetHTMLFooter("
				<table width='100%' cellpadding='0' cellspacing='0'
					style='border-top:1px solid #cbd5e0;padding-top:4px;
					font-size:8px;color:#888888;font-family:Arial;'>
					<tr>
						<td width='33%'>FPB &copy; ".date('Y')."</td>
						<td width='34%' style='text-align:center;'>
							Gerado em: ".date('d/m/Y H:i')."
						</td>
						<td width='33%' style='text-align:right;'>
							P&aacute;gina {PAGENO} de {nb}
						</td>
					</tr>
				</table>");

			/* -- Labels ----------------------------------------------------------- */
			$categoriaLabel = (count($categorias) > 0) ? implode(', ', $categorias) : 'Todas';
			$cidadeLabel    = (count($cidades) > 0) ? implode(', ', $cidades) : 'Todas';
			$canalLabel     = (count($canais) > 0) ? implode(', ', $canais) : 'Todos';
			$produtoLabel   = (count($produtos) > 0) ? implode(', ', $produtos) : '';

			/* -- Totals ------------------------------------------------------------ */
			$totalQtd     = 0;
			$totalReceita = 0.0;
			foreach ($rows as $row) {
				$totalQtd     += (int)(float)$row['quantidade'];
				$totalReceita += (float)$row['total'];
			}

			/* -- Styles ------------------------------------------------------------ */
			$html  = "<style>
				body      { font-family:Arial,sans-serif; color:#333333; font-size:10px; }
				.fbox     { background:#fff8f3; border-left:4px solid #FF8800;
				            padding:7px 11px; margin-bottom:12px; font-size:9.5px; line-height:1.6; }
				.flabel   { color:#FF8800; font-weight:bold; }
				table.m   { width:100%; border-collapse:collapse; font-size:9.5px; }
				table.m thead tr   { background-color:#111111; color:#ffffff; }
				table.m thead th   { padding:7px 6px; text-align:left;
				                     border:1px solid #333333; white-space:nowrap; color:#ffffff; }
				table.m tbody tr.o { background-color:#ffffff; }
				table.m tbody tr.e { background-color:#fff3ec; }
				table.m tbody td   { padding:5px 6px; border:1px solid #ffe0cc;
				                     vertical-align:top; }
				table.m tfoot tr   { background-color:#ffe8d6; }
				table.m tfoot td   { padding:6px 6px; border:1px solid #ffbf99;
				                     font-weight:bold; font-size:9.5px; }
				.tr { text-align:right; }
				.tc { text-align:center; }
			</style>";

			/* -- Filter summary box ------------------------------------------------ */
			$html .= "<div class='fbox'>";
			$html .= "<span class='flabel'>Per&iacute;odo:</span> "
				.htmlspecialchars($startDate)." &mdash; ".htmlspecialchars($endDate)
				." &nbsp;&bull;&nbsp; ";
			$html .= "<span class='flabel'>Categoria:</span> "
				.htmlspecialchars($categoriaLabel)." &nbsp;&bull;&nbsp; ";
			$html .= "<span class='flabel'>Cidade:</span> "
				.htmlspecialchars($cidadeLabel)." &nbsp;&bull;&nbsp; ";
			$html .= "<span class='flabel'>Canal:</span> "
				.htmlspecialchars($canalLabel);
			if ($produtoLabel != '') {
				$html .= " &nbsp;&bull;&nbsp; <span class='flabel'>Produto:</span> "
					.htmlspecialchars($produtoLabel);
			}
			$html .= "</div>";

			/* -- Data table ------------------------------------------------------- */
			$html .= "<table class='m'>";
			$html .= "<thead><tr>"
				."<th>Data / Hora</th>"
				."<th>Produto</th>"
				."<th>Categoria</th>"
				."<th class='tc'>Qtd.</th>"
				."<th class='tr'>Total (&euro;)</th>"
				."<th>Canal</th>"
				."<th>Cidade</th>"
				."</tr></thead>";
			$html .= "<tbody>";
			$i = 0;
			foreach ($rows as $row) {
				$cls  = ($i % 2 === 0) ? 'o' : 'e';
				$html .= "<tr class='".$cls."'>";
				$html .= "<td>".htmlspecialchars((string)$row['DataHora'])."</td>";
				$html .= "<td>".htmlspecialchars((string)$row['produto'])."</td>";
				$html .= "<td>".htmlspecialchars((string)$row['categoria'])."</td>";
				$html .= "<td class='tc'>".htmlspecialchars((string)$row['quantidade'])."</td>";
				$html .= "<td class='tr'>".htmlspecialchars(number_format((float)$row['total'], 2, ',', '.'))." &euro;</td>";
				$html .= "<td>".htmlspecialchars((string)$row['canal_venda'])."</td>";
				$html .= "<td>".htmlspecialchars((string)$row['cidade'])."</td>";
				$html .= "</tr>";
				$i++;
			}
			$html .= "</tbody>";
			$html .= "<tfoot><tr>"
				."<td colspan='3'>Total &mdash; ".count($rows)." registo(s)</td>"
				."<td class='tc'>".number_format($totalQtd, 0, ',', '.')."</td>"
				."<td class='tr'>".number_format($totalReceita, 2, ',', '.')." &euro;</td>"
				."<td colspan='2'></td>"
				."</tr></tfoot>";
			$html .= "</table>";

			/* -- Output ----------------------------------------------------------- */
			$relativePath = "uploads/dashboard/pdf/user".$_SESSION['user'];
			$targetPath   = $workspacePath."/".$relativePath;
			if (!is_dir($targetPath)) {
				mkdir($targetPath, 0777, true);
			}

			$fileName    = "relatorio_vendas_".date("Ymd_His").".pdf";
			$destination = $targetPath."/".$fileName;

			$mpdf->WriteHTML($html);
			$mpdf->Output($destination, 'F');

			return json_encode(array("val" => 1, "msg" => "Relatório PDF gerado com sucesso.", "link" => $relativePath."/".$fileName));
		} catch (Exception $e) {
			return json_encode(array("val" => 2, "msg" => "Erro ao gerar PDF: ".$e->getMessage()));
		}
	}

	function exportDashboardProdutosPdf($info)
	{
		global $conn;
		$info = json_decode($info, true);

		$produtos = $this->normalizeDashboardMultiFilterValues($info['produtos'] ?? []);
		if (count($produtos) < 1 && isset($info['descricao']) && trim((string)$info['descricao']) != '') {
			$produtos = [trim((string)$info['descricao'])];
		}
		$tipos = $this->normalizeDashboardMultiFilterValues($info['tipos'] ?? []);
		$precoMin = $this->normalizeDashboardFilterNumber($info['precoMin'] ?? '');
		$precoMax = $this->normalizeDashboardFilterNumber($info['precoMax'] ?? '');
		$estadoVendas = isset($info['estadoVendas']) ? trim((string)$info['estadoVendas']) : '';

		if ($precoMin !== null && $precoMax !== null && $precoMin > $precoMax) {
			return json_encode(array("val" => 2, "msg" => "Preço mínimo não pode ser maior que o preço máximo."));
		}

		try {
			$sql = "SELECT
				p.id,
				p.descricao,
				tp.descricao AS tipo_produto,
				p.preco_uni,
				p.created_at,
				p.updated_at,
				COUNT(v.id) AS total_vendas,
				COALESCE(SUM(v.Receita), 0) AS total_receita
			FROM produtos p
			LEFT JOIN tipo_produto tp ON tp.id = p.id_tipo_produto
			LEFT JOIN vendas v ON v.id_produto = p.id
			WHERE 1=1";

			$params = [];

			if (count($produtos) > 0) {
				$produtoPlaceholders = [];
				foreach ($produtos as $idx => $produtoValue) {
					$placeholder = ':produto_'.$idx;
					$produtoPlaceholders[] = $placeholder;
					$params[$placeholder] = mb_strtolower($produtoValue, 'UTF-8');
				}
				$sql .= " AND LOWER(TRIM(p.descricao)) IN (".implode(',', $produtoPlaceholders).")";
			}

			if ($precoMin !== null) {
				$sql .= " AND p.preco_uni >= :preco_min";
				$params[':preco_min'] = $precoMin;
			}

			if ($precoMax !== null) {
				$sql .= " AND p.preco_uni <= :preco_max";
				$params[':preco_max'] = $precoMax;
			}

			if (count($tipos) > 0) {
				$tipoPlaceholders = [];
				foreach ($tipos as $idx => $tipoValue) {
					$placeholder = ':tipo_'.$idx;
					$tipoPlaceholders[] = $placeholder;
					$params[$placeholder] = mb_strtolower($tipoValue, 'UTF-8');
				}
				$sql .= " AND LOWER(TRIM(tp.descricao)) IN (".implode(',', $tipoPlaceholders).")";
			}

			$sql .= " GROUP BY p.id, p.descricao, tp.descricao, p.preco_uni, p.created_at, p.updated_at";

			if ($estadoVendas === 'com') {
				$sql .= " HAVING COUNT(v.id) > 0";
			} else if ($estadoVendas === 'sem') {
				$sql .= " HAVING COUNT(v.id) = 0";
			}

			$sql .= " ORDER BY CONVERT(p.descricao USING utf8mb4) COLLATE utf8mb4_unicode_ci ASC";

			$stmt = $conn->prepare($sql);
			$stmt->execute($params);
			$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

			if (!$rows) {
				return json_encode(array("val" => 2, "msg" => "Não existem registos para os filtros selecionados."));
			}

			require_once dirname(__DIR__, 3)."/vendor/autoload.php";
			$workspacePath = dirname(__DIR__, 3);

			$mpdf = new \Mpdf\Mpdf([
				"mode"            => "utf-8",
				"format"          => "A4-L",
				"margin_top"      => 38,
				"margin_bottom"   => 22,
				"margin_left"     => 14,
				"margin_right"    => 14,
				"margin_header"   => 8,
				"margin_footer"   => 6,
			]);

			$mpdf->AliasNbPages();
			$logoTag = "<span style='font-size:22px;font-weight:900;color:#FF8800;letter-spacing:1px;font-family:Arial;'>FPB</span>";

			$mpdf->SetHTMLHeader("<table width='100%' cellpadding='0' cellspacing='0' style='border-bottom:2.5px solid #FF8800;padding-bottom:5px;'><tr><td width='50%'>".$logoTag."</td><td width='50%' style='text-align:right;font-size:14px;font-weight:bold;color:#111111;font-family:Arial;'>Relatório de Produtos</td></tr></table>");
			$mpdf->SetHTMLFooter("<table width='100%' cellpadding='0' cellspacing='0' style='border-top:1px solid #cbd5e0;padding-top:4px;font-size:8px;color:#888888;font-family:Arial;'><tr><td width='33%'>FPB &copy; ".date('Y')."</td><td width='34%' style='text-align:center;'>Gerado em: ".date('d/m/Y H:i')."</td><td width='33%' style='text-align:right;'>P&aacute;gina {PAGENO} de {nb}</td></tr></table>");

			$tipoLabel = (count($tipos) > 0) ? implode(', ', $tipos) : 'Todos';
			$produtoLabel = (count($produtos) > 0) ? implode(', ', $produtos) : 'Todos';
			$precoMinLabel = ($precoMin !== null) ? number_format($precoMin, 2, ',', '.') : '-';
			$precoMaxLabel = ($precoMax !== null) ? number_format($precoMax, 2, ',', '.') : '-';
			$estadoLabel = ($estadoVendas === 'com') ? 'Com vendas' : (($estadoVendas === 'sem') ? 'Sem vendas' : 'Todos');
			$totalVendas = 0;
			$totalReceita = 0;
			foreach ($rows as $row) {
				$totalVendas += (int)$row['total_vendas'];
				$totalReceita += (float)$row['total_receita'];
			}

			$html  = "<style>body{font-family:Arial,sans-serif;color:#333333;font-size:10px}.fbox{background:#fff8f3;border-left:4px solid #FF8800;padding:7px 11px;margin-bottom:12px;font-size:9.5px;line-height:1.6}.flabel{color:#FF8800;font-weight:bold}table.m{width:100%;border-collapse:collapse;font-size:9.5px}table.m thead tr{background-color:#111111;color:#ffffff}table.m thead th{padding:7px 6px;text-align:left;border:1px solid #333333;white-space:nowrap;color:#ffffff}table.m tbody tr.o{background-color:#ffffff}table.m tbody tr.e{background-color:#fff3ec}table.m tbody td{padding:5px 6px;border:1px solid #ffe0cc;vertical-align:top}table.m tfoot tr{background-color:#ffe8d6}table.m tfoot td{padding:6px 6px;border:1px solid #ffbf99;font-weight:bold;font-size:9.5px}.tr{text-align:right}.tc{text-align:center}</style>";
			$html .= "<div class='fbox'><span class='flabel'>Produto:</span> ".htmlspecialchars($produtoLabel)." &nbsp;&bull;&nbsp; <span class='flabel'>Tipo:</span> ".htmlspecialchars($tipoLabel)." &nbsp;&bull;&nbsp; <span class='flabel'>Preço mín.:</span> ".htmlspecialchars($precoMinLabel)." &nbsp;&bull;&nbsp; <span class='flabel'>Preço máx.:</span> ".htmlspecialchars($precoMaxLabel)." &nbsp;&bull;&nbsp; <span class='flabel'>Vendas:</span> ".htmlspecialchars($estadoLabel)."</div>";

			$html .= "<table class='m'><thead><tr><th>ID</th><th>Produto</th><th>Tipo</th><th class='tr'>Preço (&euro;)</th><th class='tc'>N.&ordm; vendas</th><th>Criado em</th><th>Atualizado em</th><th class='tr'>Receita total (&euro;)</th></tr></thead><tbody>";
			$i = 0;
			foreach ($rows as $row) {
				$cls = ($i % 2 === 0) ? 'o' : 'e';
				$html .= "<tr class='".$cls."'><td>".htmlspecialchars((string)$row['id'])."</td><td>".htmlspecialchars((string)$row['descricao'])."</td><td>".htmlspecialchars((string)$row['tipo_produto'])."</td><td class='tr'>".number_format((float)$row['preco_uni'], 2, ',', '.')." &euro;</td><td class='tc'>".(int)$row['total_vendas']."</td><td>".htmlspecialchars((string)$row['created_at'])."</td><td>".htmlspecialchars((string)$row['updated_at'])."</td><td class='tr'>".number_format((float)$row['total_receita'], 2, ',', '.')." &euro;</td></tr>";
				$i++;
			}
			$html .= "</tbody><tfoot><tr><td colspan='4'>Total &mdash; ".count($rows)." registo(s)</td><td class='tc'>".number_format($totalVendas, 0, ',', '.')."</td><td colspan='2'></td><td class='tr'>".number_format($totalReceita, 2, ',', '.')." &euro;</td></tr></tfoot></table>";

			$relativePath = "uploads/dashboard/pdf/user".$_SESSION['user'];
			$targetPath = $workspacePath."/".$relativePath;
			if (!is_dir($targetPath)) {
				mkdir($targetPath, 0777, true);
			}

			$fileName = "relatorio_produtos_".date("Ymd_His").".pdf";
			$destination = $targetPath."/".$fileName;

			$mpdf->WriteHTML($html);
			$mpdf->Output($destination, 'F');

			return json_encode(array("val" => 1, "msg" => "Relatório PDF gerado com sucesso.", "link" => $relativePath."/".$fileName));
		} catch (Exception $e) {
			return json_encode(array("val" => 2, "msg" => "Erro ao gerar PDF: ".$e->getMessage()));
		}
	}

	function exportDashboardCategoriasPdf($info)
	{
		global $conn;
		$info = json_decode($info, true);

		$categorias = $this->normalizeDashboardMultiFilterValues($info['categorias'] ?? []);
		if (count($categorias) < 1 && isset($info['descricao']) && trim((string)$info['descricao']) != '') {
			$categorias = [trim((string)$info['descricao'])];
		}
		$estadoProdutos = isset($info['estadoProdutos']) ? trim((string)$info['estadoProdutos']) : '';
		$estadoVendas = isset($info['estadoVendas']) ? trim((string)$info['estadoVendas']) : '';

		try {
			$sql = "SELECT
				c.id,
				c.descricao,
				COALESCE(SUM(v.Quantidade), 0) AS total_vendas,
				COUNT(DISTINCT CASE
					WHEN p.descricao IS NOT NULL AND TRIM(p.descricao) <> ''
					THEN LOWER(TRIM(p.descricao))
					ELSE NULL
				END) AS total_produtos,
				COALESCE(SUM(v.Receita), 0) AS total_receita
			FROM categorias c
			LEFT JOIN vendas v ON v.id_categoria = c.id
			LEFT JOIN produtos p ON p.id = v.id_produto
			WHERE 1=1";

			$params = [];
			if (count($categorias) > 0) {
				$categoriaPlaceholders = [];
				foreach ($categorias as $idx => $value) {
					$placeholder = ':categoria_'.$idx;
					$categoriaPlaceholders[] = $placeholder;
					$params[$placeholder] = mb_strtolower($value, 'UTF-8');
				}
				$sql .= " AND LOWER(TRIM(c.descricao)) IN (".implode(',', $categoriaPlaceholders).")";
			}

			$sql .= " GROUP BY c.id, c.descricao";

			$having = [];
			if ($estadoProdutos === 'com') {
				$having[] = "COUNT(DISTINCT CASE WHEN p.descricao IS NOT NULL AND TRIM(p.descricao) <> '' THEN LOWER(TRIM(p.descricao)) ELSE NULL END) > 0";
			} else if ($estadoProdutos === 'sem') {
				$having[] = "COUNT(DISTINCT CASE WHEN p.descricao IS NOT NULL AND TRIM(p.descricao) <> '' THEN LOWER(TRIM(p.descricao)) ELSE NULL END) = 0";
			}
			if ($estadoVendas === 'com') {
				$having[] = "COALESCE(SUM(v.Quantidade), 0) > 0";
			} else if ($estadoVendas === 'sem') {
				$having[] = "COALESCE(SUM(v.Quantidade), 0) = 0";
			}

			if (count($having) > 0) {
				$sql .= " HAVING ".implode(' AND ', $having);
			}

			$sql .= " ORDER BY CONVERT(c.descricao USING utf8mb4) COLLATE utf8mb4_unicode_ci ASC";

			$stmt = $conn->prepare($sql);
			$stmt->execute($params);
			$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

			if (!$rows) {
				return json_encode(array("val" => 2, "msg" => "Não existem registos para os filtros selecionados."));
			}

			require_once dirname(__DIR__, 3)."/vendor/autoload.php";
			$workspacePath = dirname(__DIR__, 3);

			$mpdf = new \Mpdf\Mpdf([
				"mode"            => "utf-8",
				"format"          => "A4-L",
				"margin_top"      => 38,
				"margin_bottom"   => 22,
				"margin_left"     => 14,
				"margin_right"    => 14,
				"margin_header"   => 8,
				"margin_footer"   => 6,
			]);

			$mpdf->AliasNbPages();
			$logoTag = "<span style='font-size:22px;font-weight:900;color:#FF8800;letter-spacing:1px;font-family:Arial;'>FPB</span>";

			$mpdf->SetHTMLHeader("<table width='100%' cellpadding='0' cellspacing='0' style='border-bottom:2.5px solid #FF8800;padding-bottom:5px;'><tr><td width='50%'>".$logoTag."</td><td width='50%' style='text-align:right;font-size:14px;font-weight:bold;color:#111111;font-family:Arial;'>Relatório de Categorias</td></tr></table>");
			$mpdf->SetHTMLFooter("<table width='100%' cellpadding='0' cellspacing='0' style='border-top:1px solid #cbd5e0;padding-top:4px;font-size:8px;color:#888888;font-family:Arial;'><tr><td width='33%'>FPB &copy; ".date('Y')."</td><td width='34%' style='text-align:center;'>Gerado em: ".date('d/m/Y H:i')."</td><td width='33%' style='text-align:right;'>P&aacute;gina {PAGENO} de {nb}</td></tr></table>");

			$categoriaIds = [];
			foreach ($rows as $row) {
				$categoriaId = (int)$row['id'];
				$categoriaIds[] = $categoriaId;
			}

			$produtosPorCategoria = [];
			if (count($categoriaIds) > 0) {
				$produtoPlaceholders = [];
				$produtoParams = [];
				foreach ($categoriaIds as $idx => $categoriaId) {
					$placeholder = ':cat_id_'.$idx;
					$produtoPlaceholders[] = $placeholder;
					$produtoParams[$placeholder] = $categoriaId;
				}

				$sqlProdutos = "SELECT
					v.id_categoria AS categoria_id,
					p.descricao AS produto,
					COALESCE(SUM(v.Quantidade), 0) AS total_vendas,
					COALESCE(SUM(v.Receita), 0) AS total_receita
				FROM vendas v
				INNER JOIN produtos p ON p.id = v.id_produto
				WHERE v.id_categoria IN (".implode(',', $produtoPlaceholders).")
				GROUP BY v.id_categoria, LOWER(TRIM(p.descricao)), p.descricao
				ORDER BY CONVERT(p.descricao USING utf8mb4) COLLATE utf8mb4_unicode_ci ASC";

				$stmtProdutos = $conn->prepare($sqlProdutos);
				$stmtProdutos->execute($produtoParams);
				$rowsProdutos = $stmtProdutos->fetchAll(PDO::FETCH_ASSOC);

				foreach ($rowsProdutos as $rowProduto) {
					$categoriaId = (int)$rowProduto['categoria_id'];
					if (!isset($produtosPorCategoria[$categoriaId])) {
						$produtosPorCategoria[$categoriaId] = [];
					}

					$produtosPorCategoria[$categoriaId][] = [
						'produto' => trim((string)$rowProduto['produto']),
						'total_vendas' => (int)$rowProduto['total_vendas'],
						'total_receita' => (float)$rowProduto['total_receita'],
					];
				}
			}

			$estadoProdutosLabel = ($estadoProdutos === 'com') ? 'Com produtos' : (($estadoProdutos === 'sem') ? 'Sem produtos' : 'Todos');
			$estadoVendasLabel = ($estadoVendas === 'com') ? 'Com vendas' : (($estadoVendas === 'sem') ? 'Sem vendas' : 'Todos');
			$totalProdutos = 0;
			$totalVendas = 0;
			$totalReceita = 0;
			foreach ($rows as $row) {
				$totalProdutos += (int)$row['total_produtos'];
				$totalVendas += (int)$row['total_vendas'];
				$totalReceita += (float)$row['total_receita'];
			}

			$html  = "<style>
				body      { font-family:Arial,sans-serif; color:#333333; font-size:10px; }
				.fbox     { background:#fff8f3; border-left:4px solid #FF8800;
				            padding:7px 11px; margin-bottom:12px; font-size:9.5px; line-height:1.6; }
				.flabel   { color:#FF8800; font-weight:bold; }
				table.m   { width:100%; border-collapse:collapse; font-size:9.5px; }
				table.m thead tr   { background-color:#111111; color:#ffffff; }
				table.m thead th   { padding:7px 6px; text-align:left;
				                     border:1px solid #333333; white-space:nowrap; color:#ffffff; }
				table.m tbody tr.o { background-color:#ffffff; }
				table.m tbody tr.e { background-color:#fff3ec; }
				table.m tbody td   { padding:5px 6px; border:1px solid #ffe0cc;
				                     vertical-align:top; }
				table.m tfoot tr   { background-color:#ffe8d6; }
				table.m tfoot td   { padding:6px 6px; border:1px solid #ffbf99;
				                     font-weight:bold; font-size:9.5px; }
				.tr { text-align:right; }
				.tc { text-align:center; }
			</style>";
			$categoriaLabel = (count($categorias) > 0) ? implode(', ', $categorias) : 'Todas';
			$html .= "<div class='fbox'><span class='flabel'>Categorias:</span> ".htmlspecialchars($categoriaLabel)." &nbsp;&bull;&nbsp; <span class='flabel'>Produtos:</span> ".htmlspecialchars($estadoProdutosLabel)." &nbsp;&bull;&nbsp; <span class='flabel'>Vendas:</span> ".htmlspecialchars($estadoVendasLabel)."</div>";

			$html .= "<table class='m'><thead><tr><th>ID</th><th>Categoria</th><th class='tc'>N.&ordm; produtos</th><th class='tc'>N.&ordm; vendas</th><th>Produtos</th><th class='tc'>Vendas por produto</th><th class='tr'>Receita por produto (&euro;)</th><th class='tr'>Receita total (&euro;)</th></tr></thead><tbody>";
			$i = 0;
			foreach ($rows as $row) {
				$cls = ($i % 2 === 0) ? 'o' : 'e';
				$categoriaId = (int)$row['id'];
				$produtosDetalhe = '-';
				$vendasDetalhe = '-';
				$receitaDetalhe = '-';
				if (isset($produtosPorCategoria[$categoriaId]) && count($produtosPorCategoria[$categoriaId]) > 0) {
					$produtosLinhas = [];
					$vendasLinhas = [];
					$receitasLinhas = [];
					foreach ($produtosPorCategoria[$categoriaId] as $detalheProduto) {
						$produtosLinhas[] = htmlspecialchars((string)$detalheProduto['produto']);
						$vendasLinhas[] = number_format((int)$detalheProduto['total_vendas'], 0, ',', '.');
						$receitasLinhas[] = number_format((float)$detalheProduto['total_receita'], 2, ',', '.')." &euro;";
					}
					$produtosDetalhe = implode('<br>', $produtosLinhas);
					$vendasDetalhe = implode('<br>', $vendasLinhas);
					$receitaDetalhe = implode('<br>', $receitasLinhas);
				}
				$html .= "<tr class='".$cls."'><td>".htmlspecialchars((string)$row['id'])."</td><td>".htmlspecialchars((string)$row['descricao'])."</td><td class='tc'>".(int)$row['total_produtos']."</td><td class='tc'>".(int)$row['total_vendas']."</td><td>".$produtosDetalhe."</td><td class='tc'>".$vendasDetalhe."</td><td class='tr'>".$receitaDetalhe."</td><td class='tr'>".number_format((float)$row['total_receita'], 2, ',', '.')." &euro;</td></tr>";
				$i++;
			}
			$html .= "</tbody><tfoot><tr><td colspan='2'>Total &mdash; ".count($rows)." registo(s)</td><td class='tc'>".number_format($totalProdutos, 0, ',', '.')."</td><td class='tc'>".number_format($totalVendas, 0, ',', '.')."</td><td></td><td></td><td></td><td class='tr'>".number_format($totalReceita, 2, ',', '.')." &euro;</td></tr></tfoot></table>";

			$relativePath = "uploads/dashboard/pdf/user".$_SESSION['user'];
			$targetPath = $workspacePath."/".$relativePath;
			if (!is_dir($targetPath)) {
				mkdir($targetPath, 0777, true);
			}

			$fileName = "relatorio_categorias_".date("Ymd_His").".pdf";
			$destination = $targetPath."/".$fileName;

			$mpdf->WriteHTML($html);
			$mpdf->Output($destination, 'F');

			return json_encode(array("val" => 1, "msg" => "Relatório PDF gerado com sucesso.", "link" => $relativePath."/".$fileName));
		} catch (Exception $e) {
			return json_encode(array("val" => 2, "msg" => "Erro ao gerar PDF: ".$e->getMessage()));
		}
	}

	function exportDashboardCidadesPdf($info)
	{
		global $conn;
		$info = json_decode($info, true);

		$cidades = $this->normalizeDashboardMultiFilterValues($info['cidades'] ?? []);
		if (count($cidades) < 1 && isset($info['descricao']) && trim((string)$info['descricao']) != '') {
			$cidades = [trim((string)$info['descricao'])];
		}
		$distritos = $this->normalizeDashboardMultiFilterValues($info['distritos'] ?? []);
		$concelhos = $this->normalizeDashboardMultiFilterValues($info['concelhos'] ?? []);
		$produtos = $this->normalizeDashboardMultiFilterValues($info['produtos'] ?? []);
		$estadoVendas = isset($info['estadoVendas']) ? trim((string)$info['estadoVendas']) : '';
		$this->backfillDashboardCidadeGeoRelations();

		try {
			$sql = "SELECT
				c.id,
				c.descricao,
				COALESCE(cd.descricao, '') AS distrito,
				COALESCE(cc.descricao, '') AS concelho,
				COALESCE(SUM(v.Quantidade), 0) AS total_vendas,
				COALESCE(SUM(v.Quantidade), 0) AS total_produtos,
				COALESCE(SUM(v.Receita), 0) AS total_receita
			FROM cidade c
			LEFT JOIN core_distritos cd ON cd.id = c.id_distrito
			LEFT JOIN core_concelhos cc ON cc.id = c.id_concelho
			LEFT JOIN vendas v ON v.id_cidade = c.id
			LEFT JOIN produtos p ON p.id = v.id_produto
			WHERE 1=1";

			$params = [];
			if (count($cidades) > 0) {
				$cidadePlaceholders = [];
				foreach ($cidades as $idx => $value) {
					$placeholder = ':cidade_'.$idx;
					$cidadePlaceholders[] = $placeholder;
					$params[$placeholder] = mb_strtolower($value, 'UTF-8');
				}
				$sql .= " AND LOWER(TRIM(c.descricao)) IN (".implode(',', $cidadePlaceholders).")";
			}

			if (count($distritos) > 0) {
				$distritoPlaceholders = [];
				foreach ($distritos as $idx => $value) {
					$placeholder = ':distrito_'.$idx;
					$distritoPlaceholders[] = $placeholder;
					$params[$placeholder] = mb_strtolower($value, 'UTF-8');
				}
				$sql .= " AND LOWER(TRIM(cd.descricao)) IN (".implode(',', $distritoPlaceholders).")";
			}

			if (count($concelhos) > 0) {
				$concelhoPlaceholders = [];
				foreach ($concelhos as $idx => $value) {
					$placeholder = ':concelho_'.$idx;
					$concelhoPlaceholders[] = $placeholder;
					$params[$placeholder] = mb_strtolower($value, 'UTF-8');
				}
				$sql .= " AND LOWER(TRIM(cc.descricao)) IN (".implode(',', $concelhoPlaceholders).")";
			}

			if (count($produtos) > 0) {
				$produtoPlaceholders = [];
				foreach ($produtos as $idx => $value) {
					$placeholder = ':produto_'.$idx;
					$produtoPlaceholders[] = $placeholder;
					$params[$placeholder] = mb_strtolower($value, 'UTF-8');
				}
				$sql .= " AND LOWER(TRIM(p.descricao)) IN (".implode(',', $produtoPlaceholders).")";
			}

			$sql .= " GROUP BY c.id, c.descricao, cd.descricao, cc.descricao";

			if ($estadoVendas === 'com') {
				$sql .= " HAVING COALESCE(SUM(v.Quantidade), 0) > 0";
			} else if ($estadoVendas === 'sem') {
				$sql .= " HAVING COALESCE(SUM(v.Quantidade), 0) = 0";
			}

			$sql .= " ORDER BY CONVERT(c.descricao USING utf8mb4) COLLATE utf8mb4_unicode_ci ASC";

			$stmt = $conn->prepare($sql);
			$stmt->execute($params);
			$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

			if (!$rows) {
				return json_encode(array("val" => 2, "msg" => "Não existem registos para os filtros selecionados."));
			}

			require_once dirname(__DIR__, 3)."/vendor/autoload.php";
			$workspacePath = dirname(__DIR__, 3);

			$mpdf = new \Mpdf\Mpdf([
				"mode"            => "utf-8",
				"format"          => "A4-L",
				"margin_top"      => 38,
				"margin_bottom"   => 22,
				"margin_left"     => 14,
				"margin_right"    => 14,
				"margin_header"   => 8,
				"margin_footer"   => 6,
			]);

			$mpdf->AliasNbPages();
			$logoTag = "<span style='font-size:22px;font-weight:900;color:#FF8800;letter-spacing:1px;font-family:Arial;'>FPB</span>";

			$mpdf->SetHTMLHeader("<table width='100%' cellpadding='0' cellspacing='0' style='border-bottom:2.5px solid #FF8800;padding-bottom:5px;'><tr><td width='50%'>".$logoTag."</td><td width='50%' style='text-align:right;font-size:14px;font-weight:bold;color:#111111;font-family:Arial;'>Relatório de Cidades</td></tr></table>");
			$mpdf->SetHTMLFooter("<table width='100%' cellpadding='0' cellspacing='0' style='border-top:1px solid #cbd5e0;padding-top:4px;font-size:8px;color:#888888;font-family:Arial;'><tr><td width='33%'>FPB &copy; ".date('Y')."</td><td width='34%' style='text-align:center;'>Gerado em: ".date('d/m/Y H:i')."</td><td width='33%' style='text-align:right;'>P&aacute;gina {PAGENO} de {nb}</td></tr></table>");

			$cidadeIds = [];
			foreach ($rows as $row) {
				$cidadeIds[] = (int)$row['id'];
			}

			$receitaPorProdutoCidade = [];
			if (count($cidadeIds) > 0) {
				$cidadePlaceholders = [];
				$produtoCidadeParams = [];
				foreach ($cidadeIds as $idx => $cidadeId) {
					$placeholder = ':cidade_id_'.$idx;
					$cidadePlaceholders[] = $placeholder;
					$produtoCidadeParams[$placeholder] = $cidadeId;
				}

				$sqlReceitaProduto = "SELECT
					v.id_cidade AS cidade_id,
					p.descricao AS produto,
					COALESCE(SUM(v.Receita), 0) AS total_receita
				FROM vendas v
				INNER JOIN produtos p ON p.id = v.id_produto
				WHERE v.id_cidade IN (".implode(',', $cidadePlaceholders).")";

				if (count($produtos) > 0) {
					$produtoPlaceholders = [];
					foreach ($produtos as $idx => $value) {
						$placeholder = ':produto_pdf_'.$idx;
						$produtoPlaceholders[] = $placeholder;
						$produtoCidadeParams[$placeholder] = mb_strtolower($value, 'UTF-8');
					}
					$sqlReceitaProduto .= " AND LOWER(TRIM(p.descricao)) IN (".implode(',', $produtoPlaceholders).")";
				}

				$sqlReceitaProduto .= " GROUP BY v.id_cidade, p.id, p.descricao ORDER BY CONVERT(p.descricao USING utf8mb4) COLLATE utf8mb4_unicode_ci ASC";

				$stmtReceitaProduto = $conn->prepare($sqlReceitaProduto);
				$stmtReceitaProduto->execute($produtoCidadeParams);
				$rowsReceitaProduto = $stmtReceitaProduto->fetchAll(PDO::FETCH_ASSOC);

				foreach ($rowsReceitaProduto as $rowProduto) {
					$cidadeId = (int)$rowProduto['cidade_id'];
					if (!isset($receitaPorProdutoCidade[$cidadeId])) {
						$receitaPorProdutoCidade[$cidadeId] = [];
					}

					$receitaPorProdutoCidade[$cidadeId][] = [
						'produto' => trim((string)$rowProduto['produto']),
						'total_receita' => (float)$rowProduto['total_receita'],
					];
				}
			}

			$distritoLabel = (count($distritos) > 0) ? implode(', ', $distritos) : 'Todos';
			$concelhoLabel = (count($concelhos) > 0) ? implode(', ', $concelhos) : 'Todos';
			$produtoLabel = (count($produtos) > 0) ? implode(', ', $produtos) : 'Todos';
			$estadoLabel = ($estadoVendas === 'com') ? 'Com vendas' : (($estadoVendas === 'sem') ? 'Sem vendas' : 'Todos');
			$totalVendas = 0;
			$totalProdutos = 0;
			$totalReceita = 0;
			foreach ($rows as $row) {
				$totalVendas += (int)$row['total_vendas'];
				$totalProdutos += (int)$row['total_produtos'];
				$totalReceita += (float)$row['total_receita'];
			}

			$html  = "<style>
				body      { font-family:Arial,sans-serif; color:#333333; font-size:10px; }
				.fbox     { background:#fff8f3; border-left:4px solid #FF8800;
				            padding:7px 11px; margin-bottom:12px; font-size:9.5px; line-height:1.6; }
				.flabel   { color:#FF8800; font-weight:bold; }
				table.m   { width:100%; border-collapse:collapse; font-size:9.5px; }
				table.m thead tr   { background-color:#111111; color:#ffffff; }
				table.m thead th   { padding:7px 6px; text-align:left;
				                     border:1px solid #333333; white-space:nowrap; color:#ffffff; }
				table.m tbody tr.o { background-color:#ffffff; }
				table.m tbody tr.e { background-color:#fff3ec; }
				table.m tbody td   { padding:5px 6px; border:1px solid #ffe0cc;
				                     vertical-align:top; }
				table.m tfoot tr   { background-color:#ffe8d6; }
				table.m tfoot td   { padding:6px 6px; border:1px solid #ffbf99;
				                     font-weight:bold; font-size:9.5px; }
				.tr { text-align:right; }
				.tc { text-align:center; }
			</style>";
			$cidadeLabel = (count($cidades) > 0) ? implode(', ', $cidades) : 'Todas';
			$html .= "<div class='fbox'><span class='flabel'>Cidade:</span> ".htmlspecialchars($cidadeLabel)." &nbsp;&bull;&nbsp; <span class='flabel'>Distrito:</span> ".htmlspecialchars($distritoLabel)." &nbsp;&bull;&nbsp; <span class='flabel'>Concelho:</span> ".htmlspecialchars($concelhoLabel)." &nbsp;&bull;&nbsp; <span class='flabel'>Produtos:</span> ".htmlspecialchars($produtoLabel)." &nbsp;&bull;&nbsp; <span class='flabel'>Vendas:</span> ".htmlspecialchars($estadoLabel)."</div>";

			$html .= "<table class='m'><thead><tr><th>ID</th><th>Cidade</th><th>Distrito</th><th>Concelho</th><th class='tc'>Qtd. produtos vendidos</th><th>Produtos</th><th class='tr'>Receita por produto (&euro;)</th><th class='tc'>N.&ordm; vendas</th><th class='tr'>Receita total (&euro;)</th></tr></thead><tbody>";
			$i = 0;
			foreach ($rows as $row) {
				$cls = ($i % 2 === 0) ? 'o' : 'e';
				$cidadeId = (int)$row['id'];
				$produtosDetalhe = '-';
				$receitaProdutoDetalhe = '-';
				if (isset($receitaPorProdutoCidade[$cidadeId]) && count($receitaPorProdutoCidade[$cidadeId]) > 0) {
					$produtosLinhas = [];
					$receitasLinhas = [];
					foreach ($receitaPorProdutoCidade[$cidadeId] as $detalheProduto) {
						$produtosLinhas[] = htmlspecialchars((string)$detalheProduto['produto']);
						$receitasLinhas[] = number_format((float)$detalheProduto['total_receita'], 2, ',', '.')." &euro;";
					}
					$produtosDetalhe = implode('<br>', $produtosLinhas);
					$receitaProdutoDetalhe = implode('<br>', $receitasLinhas);
				}
				$html .= "<tr class='".$cls."'><td>".htmlspecialchars((string)$row['id'])."</td><td>".htmlspecialchars((string)$row['descricao'])."</td><td>".htmlspecialchars((string)$row['distrito'])."</td><td>".htmlspecialchars((string)$row['concelho'])."</td><td class='tc'>".(int)$row['total_produtos']."</td><td>".$produtosDetalhe."</td><td class='tr'>".$receitaProdutoDetalhe."</td><td class='tc'>".(int)$row['total_vendas']."</td><td class='tr'>".number_format((float)$row['total_receita'], 2, ',', '.')." &euro;</td></tr>";
				$i++;
			}
			$html .= "</tbody><tfoot><tr><td colspan='4'>Total &mdash; ".count($rows)." registo(s)</td><td class='tc'>".number_format($totalProdutos, 0, ',', '.')."</td><td></td><td></td><td class='tc'>".number_format($totalVendas, 0, ',', '.')."</td><td class='tr'>".number_format($totalReceita, 2, ',', '.')." &euro;</td></tr></tfoot></table>";

			$relativePath = "uploads/dashboard/pdf/user".$_SESSION['user'];
			$targetPath = $workspacePath."/".$relativePath;
			if (!is_dir($targetPath)) {
				mkdir($targetPath, 0777, true);
			}

			$fileName = "relatorio_cidades_".date("Ymd_His").".pdf";
			$destination = $targetPath."/".$fileName;

			$mpdf->WriteHTML($html);
			$mpdf->Output($destination, 'F');

			return json_encode(array("val" => 1, "msg" => "Relatório PDF gerado com sucesso.", "link" => $relativePath."/".$fileName));
		} catch (Exception $e) {
			return json_encode(array("val" => 2, "msg" => "Erro ao gerar PDF: ".$e->getMessage()));
		}
	}

	function topbar(){
    	global $conn;
    	$arr = [];
		$id = $_SESSION['user'];
		$val = 0;
		$msg = "";
		try {
            $sql1 = "SELECT core_dashboard.id,core_dashboard.titulo,core_dashboard.opcao,core_dashboard.espaco FROM core_dashboard,core_user_dash WHERE core_dashboard.id=core_user_dash.id_dash AND core_user_dash.id_user=:id ORDER BY core_user_dash.ordem ASC";
            $stmt1 = $conn->prepare($sql1);
            $stmt1->execute([
                ':id' => $id
            ]);
            $rows1 = $stmt1->fetchAll(PDO::FETCH_ASSOC);
            if ($rows1) {
                foreach ($rows1 as $row1) {
                    $arr[count($arr)] = array("id"=>$row1['id'],"titulo"=>$row1['titulo'],"opcao"=>$row1['opcao'],"espaco"=>$row1['espaco'],"user"=>$_SESSION['user']);
                }
            }

        } catch (PDOException $e) {
			$msg = "Erro ao carregar marcações, ".$e->getMessage();
            $val = 2;
        }
		return json_encode(array("arr"=>$arr,"val"=>$val,"msg"=>$msg));
    }

    function reworkbar($info){
    	global $conn;
		$info = json_decode($info,true);
		$arr = [];
		$msg = "";
		$btn = "";
		$array = [];
		if($info['esc'] == 1){
			$result = $this->renderDashboardStatsPanel();
			$msg = $result['msg'];
			$array = $result['array'];
		}else if($info['esc'] == 2){
			$result = $this->renderDashboardCsvPanel();
			$msg = $result['msg'];
			$array = $result['array'];
		}else if($info['esc'] == 3){
			$result = $this->renderDashboardVendasPanel();
			$msg = $result['msg'];
			$array = $result['array'];
		}else if($info['esc'] == 4){
			$result = $this->renderDashboardProdutosPanel();
			$msg = $result['msg'];
			$array = $result['array'];
		}else if($info['esc'] == 5){
			$result = $this->renderDashboardCategoriasPanel();
			$msg = $result['msg'];
			$array = $result['array'];
		}else if($info['esc'] == 6){
			$result = $this->renderDashboardCidadesPanel();
			$msg = $result['msg'];
			$array = $result['array'];
		}
		$payload = array("msg"=>$msg,"arr"=>$arr,"btn"=>$btn,"array" => $array);
		$json = json_encode($payload, JSON_INVALID_UTF8_SUBSTITUTE);
		if($json === false){
			return json_encode(array("msg"=>"Erro interno ao preparar dados do painel.","arr"=>array(),"btn"=>"","array"=>array()));
		}
		return $json;
    }

	function renderDashboardStatsPanel(){
		global $conn;
		$msg = "";
		$array = [];
			try {
				$array = $this->getDashboardStatsData([]);
				$msg = "
					<div class='row'>
						<div class='col-md-3 col-sm-6 mb-3'>
							<div class='panel panel-inverse mb-0 dashboard-stats-panel'>
								<div class='panel-heading'><h4 class='panel-title'><i class='fas fa-wallet dashboard-kpi-title-icon dashboard-kpi-tone-success'></i>Receita total</h4></div>
								<div class='panel-body'>
									<div class='dashboard-kpi-content'>
										<div class='dashboard-kpi-value-wrap'>
											<h3 class='mb-0 dashboard-kpi-value' id='dashboardStatsTotalRevenue'>0,00 €</h3>
										</div>
										<div class='dashboard-kpi-icon dashboard-kpi-tone-success'><i class='fas fa-euro-sign'></i></div>
									</div>
								</div>
							</div>
						</div>
						<div class='col-md-3 col-sm-6 mb-3'>
							<div class='panel panel-inverse mb-0 dashboard-stats-panel'>
								<div class='panel-heading'><h4 class='panel-title'><i class='fas fa-receipt dashboard-kpi-title-icon dashboard-kpi-tone-primary'></i>Ticket médio</h4></div>
								<div class='panel-body'>
									<div class='dashboard-kpi-content'>
										<div class='dashboard-kpi-value-wrap'>
											<h3 class='mb-0 dashboard-kpi-value' id='dashboardStatsAverageTicket'>0,00 €</h3>
										</div>
										<div class='dashboard-kpi-icon dashboard-kpi-tone-primary'><i class='fas fa-calculator'></i></div>
									</div>
								</div>
							</div>
						</div>
						<div class='col-md-3 col-sm-6 mb-3'>
							<div class='panel panel-inverse mb-0 dashboard-stats-panel'>
								<div class='panel-heading'><h4 class='panel-title'><i class='fas fa-shopping-cart dashboard-kpi-title-icon dashboard-kpi-tone-danger'></i>Total de vendas</h4></div>
								<div class='panel-body'>
									<div class='dashboard-kpi-content'>
										<div class='dashboard-kpi-value-wrap'>
											<h3 class='mb-0 dashboard-kpi-value' id='dashboardStatsTotalSales'>0</h3>
										</div>
										<div class='dashboard-kpi-icon dashboard-kpi-tone-danger'><i class='fas fa-cash-register'></i></div>
									</div>
								</div>
							</div>
						</div>
						<div class='col-md-3 col-sm-6 mb-3'>
							<div class='panel panel-inverse mb-0 dashboard-stats-panel'>
								<div class='panel-heading'><h4 class='panel-title'><i class='fas fa-boxes dashboard-kpi-title-icon dashboard-kpi-tone-warning'></i>Quantidade vendida</h4></div>
								<div class='panel-body'>
									<div class='dashboard-kpi-content'>
										<div class='dashboard-kpi-value-wrap'>
											<h3 class='mb-0 dashboard-kpi-value' id='dashboardStatsTotalQuantity'>0</h3>
										</div>
										<div class='dashboard-kpi-icon dashboard-kpi-tone-warning'><i class='fas fa-cubes'></i></div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class='row'>
						<div class='col-md-12 mb-3'>
							<div class='panel panel-inverse mb-0 dashboard-stats-chart-panel'>
								<div class='panel-heading'><h4 class='panel-title'><i class='fas fa-chart-line dashboard-kpi-title-icon dashboard-kpi-tone-primary'></i>Receita mensal</h4></div>
								<div class='panel-body'>
									<div id='dashboardMonthlyChart'></div>
								</div>
							</div>
						</div>
						<div class='col-md-6 mb-3'>
							<div class='panel panel-inverse mb-0 dashboard-stats-chart-panel'>
								<div class='panel-heading'><h4 class='panel-title'><i class='fas fa-tags dashboard-kpi-title-icon dashboard-kpi-tone-success'></i>Receita por categoria</h4></div>
								<div class='panel-body'>
									<div id='dashboardCategoryChart'></div>
								</div>
							</div>
						</div>
						<div class='col-md-6 mb-3'>
							<div class='panel panel-inverse mb-0 dashboard-stats-chart-panel'>
								<div class='panel-heading'><h4 class='panel-title'><i class='fas fa-store dashboard-kpi-title-icon dashboard-kpi-tone-warning'></i>Receita por canal</h4></div>
								<div class='panel-body'>
									<div id='dashboardChannelChart'></div>
								</div>
							</div>
						</div>
					</div>
					<div class='row'>
						<div class='col-md-6 mb-3'>
							<div class='panel panel-inverse mb-0 dashboard-stats-table-panel'>
								<div class='panel-heading'><h4 class='panel-title'><i class='fas fa-trophy dashboard-kpi-title-icon dashboard-kpi-tone-danger'></i>Top 10 produtos</h4></div>
								<div class='panel-body'>
									<div class='table-responsive'>
										<table class='table table-sm table-hover mb-0' id='dashboardTopProductsTable'>
											<thead>
												<tr>
													<th><i class='fas fa-box mr-1'></i>Produto</th>
													<th><i class='fas fa-euro-sign mr-1'></i>Receita</th>
													<th><i class='fas fa-hashtag mr-1'></i>Qtd</th>
												</tr>
											</thead>
											<tbody id='dashboardTopProductsTableBody'></tbody>
										</table>
									</div>
								</div>
							</div>
						</div>
						<div class='col-md-6 mb-3'>
							<div class='panel panel-inverse mb-0 dashboard-stats-table-panel'>
								<div class='panel-heading'><h4 class='panel-title'><i class='fas fa-city dashboard-kpi-title-icon dashboard-kpi-tone-success'></i>Receita por cidade</h4></div>
								<div class='panel-body'>
									<div class='table-responsive'>
										<table class='table table-sm table-hover mb-0' id='dashboardCitiesTable'>
											<thead>
												<tr>
													<th><i class='fas fa-city mr-1'></i>Cidade</th>
													<th><i class='fas fa-euro-sign mr-1'></i>Receita</th>
												</tr>
											</thead>
											<tbody id='dashboardCitiesTableBody'></tbody>
										</table>
									</div>
								</div>
							</div>
						</div>
					</div>
				";
			} catch (Exception $e) {
				$msg = "Erro ao carregar estatísticas do dashboard, ".$e->getMessage();
			}
		return array('msg' => $msg, 'array' => $array);
	}

	function renderDashboardCsvPanel(){
		global $conn;
		$msg = "";
		$array = [];
			$array = $this->getDashboardCsvFiles();
			$msg = "";
			$canImportCsv = isset($_SESSION['perm']['core']['dashboard']['Importar']) && $_SESSION['perm']['core']['dashboard']['Importar'];
			$canDeleteCsv = isset($_SESSION['perm']['core']['dashboard']['Apagar']) && $_SESSION['perm']['core']['dashboard']['Apagar'];
			if($canImportCsv){
				$msg .= "
					<div class='dashboard-upload-zone' id='dashboardUploadZone'>
						<div class='dashboard-upload-icon-wrap'>
							<i class='fas fa-cloud-upload-alt'></i>
						</div>
						<span class='dashboard-upload-main-text'>Importe dados de vendas via ficheiro CSV</span>
						<span class='dashboard-upload-sub-text'>Apenas ficheiros <strong>.csv</strong> são suportados &bull; 1 ficheiro por upload</span>
						<div class='dashboard-upload-controls'>
							<div class='dashboard-upload-file-row'>
								<input type='file' id='dashboardCsvFiles' class='dashboard-upload-file-input' accept='.csv,text/csv'
									onchange=\"document.getElementById('dashboardCsvFileName').textContent = this.files && this.files.length ? this.files[0].name : 'Nenhum ficheiro selecionado'\">
								<label for='dashboardCsvFiles' class='btn-upload-choose'>
									<i class='fas fa-folder-open mr-1'></i> Escolher ficheiro
								</label>
								<span id='dashboardCsvFileName' class='dashboard-upload-filename'></span>
							</div>
							<button type='button' class='dashboard-upload-btn' onclick='uploadDashboardCsv()'>
								<i class='fas fa-upload mr-2'></i> Carregar CSV
							</button>
						</div>
					</div>
				";
			}else{
				$msg .= "
					<div class='dashboard-upload-zone dashboard-upload-zone-noperm'>
						<div class='dashboard-upload-icon-wrap'>
							<i class='fas fa-lock'></i>
						</div>
						<span class='dashboard-upload-main-text'>Sem permissão para upload de ficheiros CSV</span>
					</div>
				";
			}

			$msg .= "
				<div class='mb-2 d-flex justify-content-end align-items-center'>
					".($canDeleteCsv ? "<button type='button' class='btn btn-secondary dashboard-table-delete-btn dashboard-bulk-delete-btn' id='dashboardCsvDeleteSelectedBtn' onclick='confirmDeleteSelectedDashboardCsvFiles()' disabled><i class='fas fa-trash mr-1'></i>Eliminar</button>" : "")."
				</div>
				<div class='table-responsive'>
					<table class='table table-hover table-sm' id='dashboardCsvTable'>
						<thead>
							<tr>
								".($canDeleteCsv ? "<th class='text-center dashboard-bulk-select-col' style='width:88px;'><label class='dashboard-bulk-select-label mb-0'><input type='checkbox' class='dashboard-bulk-select-all' id='dashboardCsvSelectAll' title='Selecionar todos'><span class='dashboard-bulk-select-text'>Sel. Todos</span></label></th>" : "")."
								<th><i class='fas fa-file-csv mr-1'></i>Ficheiro</th>
								<th><i class='fas fa-weight-hanging mr-1'></i>Tamanho</th>
								<th><i class='fas fa-calendar-alt mr-1'></i>Data</th>
								<th><i class='fas fa-download mr-1'></i>Download</th>
							</tr>
						</thead>
						<tbody id='dashboardCsvTableBody'></tbody>
					</table>
				</div>
				<input type='hidden' id='dashboardCsvCanImport' value='".($canImportCsv ? "1" : "0")."'>
				<input type='hidden' id='dashboardCsvCanDelete' value='".($canDeleteCsv ? "1" : "0")."'>
			";
		return array('msg' => $msg, 'array' => $array);
	}

	function renderDashboardVendasPanel(){
		global $conn;
		$msg = "";
		$array = [];
			try {
				$isAdminVenda = isset($_SESSION['tipo']) && (int)$_SESSION['tipo'] === 1;
				$canCreateVenda = $isAdminVenda && isset($_SESSION['perm']['core']['dashboard']['Adicionar']) && $_SESSION['perm']['core']['dashboard']['Adicionar'];
				$canEditVenda = isset($_SESSION['perm']['core']['dashboard']['Editar']) && $_SESSION['perm']['core']['dashboard']['Editar'];
				$canDeleteVenda = isset($_SESSION['perm']['core']['dashboard']['Apagar']) && $_SESSION['perm']['core']['dashboard']['Apagar'];
				$showVendasActions = $canEditVenda;
				$modalOptions = [
					'produtoOptions' => '',
					'cidadeOptions' => '',
					'categoriaOptions' => '',
					'canalOptions' => '',
					'nextIdVenda' => 1
				];
				if($canCreateVenda || $canEditVenda){
					$modalOptions = $this->getDashboardVendasModalOptions();
				}
				$sql = "SELECT
					v.id,
					v.id_venda,
					v.id_produto,
					v.id_cidade,
					v.id_categoria,
					v.DataHora,
					v.Quantidade AS quantidade,
					v.Receita AS total,
					v.canal_venda,
					p.descricao AS produto,
					c.descricao AS cidade,
					ca.descricao AS categoria
				FROM vendas v
				LEFT JOIN produtos p ON p.id = v.id_produto
				LEFT JOIN cidade c ON c.id = v.id_cidade
				LEFT JOIN categorias ca ON ca.id = v.id_categoria
				ORDER BY v.DataHora DESC";
				$stmt = $conn->prepare($sql);
				$stmt->execute();
				$array = $stmt->fetchAll(PDO::FETCH_ASSOC);
				$filterOptions = $this->buildDashboardVendasFilterOptions($array);

				$msg = "
					<div class='dashboard-filters-panel'>
						<div class='dashboard-filters-header'>
							<i class='fas fa-sliders-h mr-2'></i>Filtros
						</div>
						<div class='dashboard-filters-body'>
							<div class='row dashboard-filters-row'>
								<div class='col-md col-sm-6 mb-3'>
									<label class='dashboard-filter-label'><i class='fas fa-calendar-day'></i>Data inicial</label>
									<input type='date' id='dashboardVendasStartDate' class='dashboard-filter-control'>
								</div>
								<div class='col-md col-sm-6 mb-3'>
									<label class='dashboard-filter-label'><i class='fas fa-calendar-check'></i>Data final</label>
									<input type='date' id='dashboardVendasEndDate' class='dashboard-filter-control'>
								</div>
								<div class='col-md col-sm-6 mb-3'>
									<label class='dashboard-filter-label'><i class='fas fa-tags'></i>Categoria</label>
									<select id='dashboardVendasCategoria' class='dashboard-filter-control' multiple data-placeholder='Selecione uma categoria'>".$filterOptions['categoria']."</select>
								</div>
								<div class='col-md col-sm-6 mb-3'>
									<label class='dashboard-filter-label'><i class='fas fa-city'></i>Cidade</label>
									<select id='dashboardVendasCidade' class='dashboard-filter-control' multiple data-placeholder='Selecione uma cidade'>".$filterOptions['cidade']."</select>
								</div>
								<div class='col-md col-sm-6 mb-3'>
									<label class='dashboard-filter-label'><i class='fas fa-store'></i>Canal</label>
									<select id='dashboardVendasCanal' class='dashboard-filter-control' multiple data-placeholder='Selecione um canal'>".$filterOptions['canal']."</select>
								</div>
							</div>
							<div class='dashboard-filters-actions'>
								<button type='button' class='dashboard-filter-btn dashboard-filter-btn-apply' onclick='applyDashboardVendasFilters()'>
									<i class='fas fa-filter mr-1'></i> Aplicar filtros
								</button>
								<button type='button' class='dashboard-filter-btn dashboard-filter-btn-clear' onclick='clearDashboardVendasFilters()'>
									<i class='fas fa-eraser mr-1'></i> Limpar
								</button>
								<button type='button' class='dashboard-filter-btn dashboard-filter-btn-pdf' onclick='downloadDashboardVendasPdf()'>
									<i class='fas fa-file-pdf mr-1'></i> Gerar PDF
								</button>
								<div class='ml-auto d-flex align-items-center'>
									".($canCreateVenda ? "<button type='button' class='btn btn-success dashboard-table-add-btn' onclick='openDashboardVendaModal()'><i class='fas fa-plus mr-1'></i>Adicionar venda</button>" : "")."
									".($canDeleteVenda ? "<button type='button' class='btn btn-secondary dashboard-table-delete-btn dashboard-bulk-delete-btn ml-2' id='dashboardVendasDeleteSelectedBtn' onclick='confirmDeleteSelectedDashboardVendas()' disabled><i class='fas fa-trash mr-1'></i>Eliminar</button>" : "")."
								</div>
							</div>
						</div>
					</div>
					<div class='table-responsive'>
						<table class='table table-hover table-sm' id='dashboardVendasTable'>
							<thead>
								<tr>
									".($canDeleteVenda ? "<th class='text-center dashboard-bulk-select-col' style='width:88px;'><label class='dashboard-bulk-select-label mb-0'><input type='checkbox' class='dashboard-bulk-select-all' id='dashboardVendasSelectAll' title='Selecionar todos'><span class='dashboard-bulk-select-text'>Sel. Todos</span></label></th>" : "")."
									<th><i class='fas fa-hashtag mr-1'></i>ID Venda</th>
									<th><i class='fas fa-calendar-alt mr-1'></i>Data</th>
									<th><i class='fas fa-box mr-1'></i>Produto</th>
									<th><i class='fas fa-tags mr-1'></i>Categoria</th>
									<th><i class='fas fa-cubes mr-1'></i>Quantidade</th>
									<th><i class='fas fa-euro-sign mr-1'></i>Receita (€)</th>
									<th><i class='fas fa-store mr-1'></i>Canal</th>
									<th><i class='fas fa-city mr-1'></i>Cidade</th>
									".($showVendasActions ? "<th class='dashboard-actions-col'><i class='fas fa-cogs mr-1'></i>Ações</th>" : "")."
								</tr>
							</thead>
							<tbody id='dashboardVendasTableBody'></tbody>
						</table>
					</div>
					<div class='modal fade' id='dashboardVendaModal' tabindex='-1' role='dialog' aria-hidden='true'>
						<div class='modal-dialog modal-lg' role='document'>
							<div class='modal-content'>
								<div class='modal-header'>
									<h5 class='modal-title'>Adicionar venda</h5>
									<button type='button' class='close' data-dismiss='modal' aria-label='Close'>
										<span aria-hidden='true'>&times;</span>
									</button>
								</div>
								<div class='modal-body'>
									<div class='row'>
										<div class='col-md-6 mb-2'>
											<input type='hidden' id='dashboardVendaRowId' value=''>
											<label class='form-label'>Data/Hora *</label>
											<input type='datetime-local' class='form-control' id='dashboardVendaDataHora'>
										</div>
										<div class='col-md-6 mb-2'>
											<label class='form-label'>Canal de venda *</label>
											<select class='form-control' id='dashboardVendaCanal'>
												<option value=''>Selecione...</option>
												".$modalOptions['canalOptions']."
											</select>
										</div>
										<div class='col-md-4 mb-2'>
											<label class='form-label'>Produto *</label>
											<select class='form-control' id='dashboardVendaProduto'>
												<option value=''>Selecione...</option>
												".$modalOptions['produtoOptions']."
											</select>
										</div>
										<div class='col-md-4 mb-2'>
											<label class='form-label'>Cidade *</label>
											<select class='form-control' id='dashboardVendaCidade'>
												<option value=''>Selecione...</option>
												".$modalOptions['cidadeOptions']."
											</select>
										</div>
										<div class='col-md-4 mb-2'>
											<label class='form-label'>Categoria *</label>
											<select class='form-control' id='dashboardVendaCategoria'>
												<option value=''>Selecione...</option>
												".$modalOptions['categoriaOptions']."
											</select>
										</div>
										<div class='col-md-6 mb-2'>
											<label class='form-label'>Quantidade *</label>
											<input type='number' min='0' class='form-control' id='dashboardVendaQuantidade' value='1'>
										</div>
									</div>
								</div>
								<div class='modal-footer'>
									<button type='button' class='btn btn-secondary' data-dismiss='modal'><i class='fas fa-times mr-1'></i>Cancelar</button>
									".(($canCreateVenda || $canEditVenda) ? "<button type='button' class='btn btn-success' id='dashboardVendaSaveBtn' onclick='saveDashboardVenda()'><i class='fas fa-check mr-1'></i>Guardar venda</button>" : "")."
								</div>
							</div>
						</div>
					</div>
					<input type='hidden' id='dashboardVendaCanCreate' value='".($canCreateVenda ? "1" : "0")."'>
					<input type='hidden' id='dashboardVendaCanEdit' value='".($canEditVenda ? "1" : "0")."'>
					<input type='hidden' id='dashboardVendaCanDelete' value='".($canDeleteVenda ? "1" : "0")."'>
				";
			} catch (PDOException $e) {
				$msg = "Erro ao carregar vendas, ".$e->getMessage();
			}
		return array('msg' => $msg, 'array' => $array);
	}

	function renderDashboardProdutosPanel(){
		global $conn;
		$msg = "";
		$array = [];
			try {
				$canCreateProduto = isset($_SESSION['perm']['core']['dashboard']['Adicionar']) && $_SESSION['perm']['core']['dashboard']['Adicionar'];
				$canEditProduto = isset($_SESSION['perm']['core']['dashboard']['Editar']) && $_SESSION['perm']['core']['dashboard']['Editar'];
				$canDeleteProduto = isset($_SESSION['perm']['core']['dashboard']['Apagar']) && $_SESSION['perm']['core']['dashboard']['Apagar'];
				$showProdutosActions = $canEditProduto;
				$modalOptions = [
					'tipoProdutoOptions' => ''
				];
				if($canCreateProduto || $canEditProduto){
					$sqlTipoProduto = "SELECT id, descricao FROM tipo_produto ORDER BY CONVERT(descricao USING utf8mb4) COLLATE utf8mb4_unicode_ci ASC";
					$stmtTipoProduto = $conn->prepare($sqlTipoProduto);
					$stmtTipoProduto->execute();
					$rowsTipoProduto = $stmtTipoProduto->fetchAll(PDO::FETCH_ASSOC);
					foreach ($rowsTipoProduto as $rowTipoProduto) {
						$modalOptions['tipoProdutoOptions'] .= "<option value='".(int)$rowTipoProduto['id']."'>".htmlspecialchars((string)$rowTipoProduto['descricao'])."</option>";
					}
				}

				$sql = "SELECT
					p.id,
					p.descricao,
					p.id_tipo_produto,
					p.preco_uni,
					p.created_at,
					p.updated_at,
					tp.descricao AS tipo_produto,
					COUNT(v.id) AS total_vendas
				FROM produtos p
				LEFT JOIN tipo_produto tp ON tp.id = p.id_tipo_produto
				LEFT JOIN vendas v ON v.id_produto = p.id
				GROUP BY p.id, p.descricao, p.id_tipo_produto, p.preco_uni, p.created_at, p.updated_at, tp.descricao
				ORDER BY CONVERT(p.descricao USING utf8mb4) COLLATE utf8mb4_unicode_ci ASC";
				$stmt = $conn->prepare($sql);
				$stmt->execute();
				$array = $stmt->fetchAll(PDO::FETCH_ASSOC);
				$filterOptions = $this->buildDashboardProdutosFilterOptions($array);

				$msg = "
					<div class='dashboard-filters-panel'>
						<div class='dashboard-filters-header'>
							<i class='fas fa-sliders-h mr-2'></i>Filtros
						</div>
						<div class='dashboard-filters-body'>
							<div class='row dashboard-filters-row'>
								<div class='col-md-3 col-sm-6 mb-3'>
									<label class='dashboard-filter-label'><i class='fas fa-search'></i>Produto</label>
									<select id='dashboardProdutosDescricaoFilter' class='dashboard-filter-control' multiple data-placeholder='Selecione o produto'>".$filterOptions['produto']."</select>
								</div>
								<div class='col-md-3 col-sm-6 mb-3'>
									<label class='dashboard-filter-label'><i class='fas fa-layer-group'></i>Tipo de produto</label>
									<select id='dashboardProdutosTipoFilter' class='dashboard-filter-control' multiple data-placeholder='Selecione o tipo'>".$filterOptions['tipo']."</select>
								</div>
								<div class='col-md-2 col-sm-6 mb-3'>
									<label class='dashboard-filter-label'><i class='fas fa-arrow-down'></i>Preço mín. (€)</label>
									<input type='number' id='dashboardProdutosPrecoMin' class='dashboard-filter-control' min='0' step='0.01' placeholder='0,00'>
								</div>
								<div class='col-md-2 col-sm-6 mb-3'>
									<label class='dashboard-filter-label'><i class='fas fa-arrow-up'></i>Preço máx. (€)</label>
									<input type='number' id='dashboardProdutosPrecoMax' class='dashboard-filter-control' min='0' step='0.01' placeholder='0,00'>
								</div>
								<div class='col-md-2 col-sm-6 mb-3'>
									<label class='dashboard-filter-label'><i class='fas fa-shopping-cart'></i>Vendas</label>
									<select id='dashboardProdutosVendasEstado' class='dashboard-filter-control'>
										<option value=''>Todos</option>
										<option value='com'>Com vendas</option>
										<option value='sem'>Sem vendas</option>
									</select>
								</div>
							</div>
							<div class='dashboard-filters-actions'>
								<button type='button' class='dashboard-filter-btn dashboard-filter-btn-apply' onclick='applyDashboardProdutosFilters()'>
									<i class='fas fa-filter mr-1'></i> Aplicar filtros
								</button>
								<button type='button' class='dashboard-filter-btn dashboard-filter-btn-clear' onclick='clearDashboardProdutosFilters()'>
									<i class='fas fa-eraser mr-1'></i> Limpar
								</button>
								<button type='button' class='dashboard-filter-btn dashboard-filter-btn-pdf' onclick='downloadDashboardProdutosPdf()'>
									<i class='fas fa-file-pdf mr-1'></i> Gerar PDF
								</button>
								<div class='ml-auto d-flex align-items-center'>
									".($canCreateProduto ? "<button type='button' class='btn btn-success dashboard-table-add-btn' onclick='openDashboardProdutoModal()'><i class='fas fa-plus mr-1'></i>Adicionar produto</button>" : "")."
									".($canDeleteProduto ? "<button type='button' class='btn btn-secondary dashboard-table-delete-btn dashboard-bulk-delete-btn ml-2' id='dashboardProdutosDeleteSelectedBtn' onclick='confirmDeleteSelectedDashboardProdutos()' disabled><i class='fas fa-trash mr-1'></i>Eliminar</button>" : "")."
								</div>
							</div>
						</div>
					</div>
					<div class='table-responsive'>
						<table class='table table-hover table-sm' id='dashboardProdutosTable'>
							<thead>
								<tr>
									".($canDeleteProduto ? "<th class='text-center dashboard-bulk-select-col' style='width:88px;'><label class='dashboard-bulk-select-label mb-0'><input type='checkbox' class='dashboard-bulk-select-all' id='dashboardProdutosSelectAll' title='Selecionar todos'><span class='dashboard-bulk-select-text'>Sel. Todos</span></label></th>" : "")."
									<th class='dashboard-produtos-col-id'><i class='fas fa-hashtag mr-1'></i>ID</th>
									<th class='dashboard-produtos-col-produto'><i class='fas fa-box-open mr-1'></i>Produto</th>
									<th class='dashboard-produtos-col-tipo'><i class='fas fa-layer-group mr-1'></i>Tipo Produto</th>
									<th class='dashboard-produtos-col-preco'><i class='fas fa-euro-sign mr-1'></i>Preço Unitário (€)</th>
									<th class='dashboard-produtos-col-criado'><i class='fas fa-calendar-plus mr-1'></i>Criado em</th>
									<th class='dashboard-produtos-col-atualizado'><i class='fas fa-calendar-check mr-1'></i>Atualizado em</th>
									".($showProdutosActions ? "<th class='dashboard-actions-col'><i class='fas fa-cogs mr-1'></i>Ações</th>" : "")."
								</tr>
							</thead>
							<tbody id='dashboardProdutosTableBody'></tbody>
						</table>
					</div>
					<div class='modal fade' id='dashboardProdutoModal' tabindex='-1' role='dialog' aria-hidden='true'>
						<div class='modal-dialog modal-lg' role='document'>
							<div class='modal-content'>
								<div class='modal-header'>
									<h5 class='modal-title'>Adicionar produto</h5>
									<button type='button' class='close' data-dismiss='modal' aria-label='Close'>
										<span aria-hidden='true'>&times;</span>
									</button>
								</div>
								<div class='modal-body'>
									<div class='row'>
										<div class='col-md-6 mb-2'>
											<label class='form-label'>Nome Produto *</label>
											<input type='hidden' id='dashboardProdutoRowId' value=''>
											<input type='text' class='form-control' id='dashboardProdutoDescricao' placeholder='Nome do produto'>
										</div>
										<div class='col-md-6 mb-2'>
											<label class='form-label'>Tipo Produto *</label>
											<select class='form-control' id='dashboardProdutoTipoProduto'>
												<option value=''>Selecione...</option>
												".$modalOptions['tipoProdutoOptions']."
											</select>
										</div>
										<div class='col-md-6 mb-2'>
											<label class='form-label'>Preço Unitário *</label>
											<input type='number' min='0' step='0.01' class='form-control' id='dashboardProdutoPrecoUni' value='0'>
										</div>
									</div>
								</div>
								<div class='modal-footer'>
									<button type='button' class='btn btn-secondary' data-dismiss='modal'><i class='fas fa-times mr-1'></i>Cancelar</button>
									".(($canCreateProduto || $canEditProduto) ? "<button type='button' class='btn btn-success' id='dashboardProdutoSaveBtn' onclick='saveDashboardProduto()'><i class='fas fa-check mr-1'></i>Guardar produto</button>" : "")."
								</div>
							</div>
						</div>
					</div>
					<input type='hidden' id='dashboardProdutoCanCreate' value='".($canCreateProduto ? "1" : "0")."'>
					<input type='hidden' id='dashboardProdutoCanEdit' value='".($canEditProduto ? "1" : "0")."'>
					<input type='hidden' id='dashboardProdutoCanDelete' value='".($canDeleteProduto ? "1" : "0")."'>
				";
			} catch (PDOException $e) {
				$msg = "Erro ao carregar produtos, ".$e->getMessage();
			}
		return array('msg' => $msg, 'array' => $array);
	}

	function renderDashboardCategoriasPanel(){
		global $conn;
		$msg = "";
		$array = [];
			try {
				$this->syncDashboardCategoriasStatsColumns();
				$canCreateCategoria = isset($_SESSION['perm']['core']['dashboard']['Adicionar']) && $_SESSION['perm']['core']['dashboard']['Adicionar'];
				$canEditCategoria = isset($_SESSION['perm']['core']['dashboard']['Editar']) && $_SESSION['perm']['core']['dashboard']['Editar'];
				$canDeleteCategoria = isset($_SESSION['perm']['core']['dashboard']['Apagar']) && $_SESSION['perm']['core']['dashboard']['Apagar'];
				$showCategoriasActions = $canEditCategoria;

				$sql = "SELECT
					c.id,
					c.descricao,
					c.total_vendas,
					c.total_produtos,
					c.total_receita
				FROM categorias c
				ORDER BY CONVERT(c.descricao USING utf8mb4) COLLATE utf8mb4_unicode_ci ASC";
				$stmt = $conn->prepare($sql);
				$stmt->execute();
				$array = $stmt->fetchAll(PDO::FETCH_ASSOC);
				$filterOptions = $this->buildDashboardCategoriasFilterOptions($array);

				$msg = "
					<div class='dashboard-filters-panel'>
						<div class='dashboard-filters-header'>
							<i class='fas fa-sliders-h mr-2'></i>Filtros
						</div>
						<div class='dashboard-filters-body'>
							<div class='row dashboard-filters-row'>
								<div class='col-md-4 col-sm-6 mb-3'>
									<label class='dashboard-filter-label'><i class='fas fa-tags'></i>Categoria</label>
									<select id='dashboardCategoriasFilter' class='dashboard-filter-control' multiple data-placeholder='Selecione a categoria'>".$filterOptions['categoria']."</select>
								</div>
								<div class='col-md-4 col-sm-6 mb-3'>
									<label class='dashboard-filter-label'><i class='fas fa-boxes'></i>Produtos</label>
									<select id='dashboardCategoriasProdutosEstado' class='dashboard-filter-control'>
										<option value=''>Todos</option>
										<option value='com'>Com produtos</option>
										<option value='sem'>Sem produtos</option>
									</select>
								</div>
								<div class='col-md-4 col-sm-6 mb-3'>
									<label class='dashboard-filter-label'><i class='fas fa-shopping-cart'></i>Vendas</label>
									<select id='dashboardCategoriasVendasEstado' class='dashboard-filter-control'>
										<option value=''>Todos</option>
										<option value='com'>Com vendas</option>
										<option value='sem'>Sem vendas</option>
									</select>
								</div>
							</div>
							<div class='dashboard-filters-actions'>
								<button type='button' class='dashboard-filter-btn dashboard-filter-btn-apply' onclick='applyDashboardCategoriasFilters()'>
									<i class='fas fa-filter mr-1'></i> Aplicar filtros
								</button>
								<button type='button' class='dashboard-filter-btn dashboard-filter-btn-clear' onclick='clearDashboardCategoriasFilters()'>
									<i class='fas fa-eraser mr-1'></i> Limpar
								</button>
								<button type='button' class='dashboard-filter-btn dashboard-filter-btn-pdf' onclick='downloadDashboardCategoriasPdf()'>
									<i class='fas fa-file-pdf mr-1'></i> Gerar PDF
								</button>
								<div class='ml-auto d-flex align-items-center'>
									".($canCreateCategoria ? "<button type='button' class='btn btn-success dashboard-table-add-btn' onclick='openDashboardCategoriaModal()'><i class='fas fa-plus mr-1'></i>Adicionar categoria</button>" : "")."
									".($canDeleteCategoria ? "<button type='button' class='btn btn-secondary dashboard-table-delete-btn dashboard-bulk-delete-btn ml-2' id='dashboardCategoriasDeleteSelectedBtn' onclick='confirmDeleteSelectedDashboardCategorias()' disabled><i class='fas fa-trash mr-1'></i>Eliminar</button>" : "")."
								</div>
							</div>
						</div>
					</div>
					<div class='table-responsive'>
						<table class='table table-hover table-sm' id='dashboardCategoriasTable'>
							<thead>
								<tr>
									".($canDeleteCategoria ? "<th class='text-center dashboard-bulk-select-col' style='width:88px;'><label class='dashboard-bulk-select-label mb-0'><input type='checkbox' class='dashboard-bulk-select-all' id='dashboardCategoriasSelectAll' title='Selecionar todos'><span class='dashboard-bulk-select-text'>Sel. Todos</span></label></th>" : "")."
									<th><i class='fas fa-tags mr-1'></i>Categoria</th>
									<th><i class='fas fa-boxes mr-1'></i>Produtos</th>
									<th><i class='fas fa-shopping-cart mr-1'></i>Vendas</th>
									".($showCategoriasActions ? "<th class='dashboard-actions-col'><i class='fas fa-cogs mr-1'></i>Ações</th>" : "")."
								</tr>
							</thead>
							<tbody id='dashboardCategoriasTableBody'></tbody>
						</table>
					</div>
					<div class='modal fade' id='dashboardCategoriaModal' tabindex='-1' role='dialog' aria-hidden='true'>
						<div class='modal-dialog modal-lg' role='document'>
							<div class='modal-content'>
								<div class='modal-header'>
									<h5 class='modal-title'>Adicionar categoria</h5>
									<button type='button' class='close' data-dismiss='modal' aria-label='Close'>
										<span aria-hidden='true'>&times;</span>
									</button>
								</div>
								<div class='modal-body'>
									<div class='row'>
										<div class='col-md-12 mb-2'>
											<label class='form-label'>Categoria *</label>
											<input type='hidden' id='dashboardCategoriaRowId' value=''>
											<input type='text' class='form-control' id='dashboardCategoriaDescricao' maxlength='100' placeholder='Nome da categoria'>
										</div>
									</div>
								</div>
								<div class='modal-footer'>
									<button type='button' class='btn btn-secondary' data-dismiss='modal'><i class='fas fa-times mr-1'></i>Cancelar</button>
									".(($canCreateCategoria || $canEditCategoria) ? "<button type='button' class='btn btn-success' id='dashboardCategoriaSaveBtn' onclick='saveDashboardCategoria()'><i class='fas fa-check mr-1'></i>Guardar categoria</button>" : "")."
								</div>
							</div>
						</div>
					</div>
					<input type='hidden' id='dashboardCategoriaCanCreate' value='".($canCreateCategoria ? "1" : "0")."'>
					<input type='hidden' id='dashboardCategoriaCanEdit' value='".($canEditCategoria ? "1" : "0")."'>
					<input type='hidden' id='dashboardCategoriaCanDelete' value='".($canDeleteCategoria ? "1" : "0")."'>
				";
			} catch (PDOException $e) {
				$msg = "Erro ao carregar categorias, ".$e->getMessage();
			}
		return array('msg' => $msg, 'array' => $array);
	}

	function renderDashboardCidadesPanel(){
		global $conn;
		$msg = "";
		$array = [];
			try {
				$this->backfillDashboardCidadeGeoRelations();
				$canCreateCidade = isset($_SESSION['perm']['core']['dashboard']['Adicionar']) && $_SESSION['perm']['core']['dashboard']['Adicionar'];
				$canEditCidade = isset($_SESSION['perm']['core']['dashboard']['Editar']) && $_SESSION['perm']['core']['dashboard']['Editar'];
				$canDeleteCidade = isset($_SESSION['perm']['core']['dashboard']['Apagar']) && $_SESSION['perm']['core']['dashboard']['Apagar'];
				$showCidadesActions = $canEditCidade;

				$sql = "SELECT
					c.id,
					c.descricao,
					c.id_distrito,
					c.id_concelho,
					COALESCE(cd.descricao, '') AS distrito,
					COALESCE(cc.descricao, '') AS concelho,
					COALESCE(SUM(v.Quantidade), 0) AS total_vendas,
					COALESCE(SUM(v.Quantidade), 0) AS total_produtos,
					COALESCE(GROUP_CONCAT(DISTINCT p.descricao ORDER BY CONVERT(p.descricao USING utf8mb4) COLLATE utf8mb4_unicode_ci SEPARATOR '||'), '') AS produtos_tokens
				FROM cidade c
				LEFT JOIN core_distritos cd ON cd.id = c.id_distrito
				LEFT JOIN core_concelhos cc ON cc.id = c.id_concelho
				LEFT JOIN vendas v ON v.id_cidade = c.id
				LEFT JOIN produtos p ON p.id = v.id_produto
				GROUP BY c.id, c.descricao, c.id_distrito, c.id_concelho, cd.descricao, cc.descricao
				ORDER BY CONVERT(c.descricao USING utf8mb4) COLLATE utf8mb4_unicode_ci ASC";
				$stmt = $conn->prepare($sql);
				$stmt->execute();
				$array = $stmt->fetchAll(PDO::FETCH_ASSOC);
				$filterOptions = $this->buildDashboardCidadesFilterOptions($array);

				$msg = "
					<div class='dashboard-filters-panel'>
						<div class='dashboard-filters-header'>
							<i class='fas fa-sliders-h mr-2'></i>Filtros
						</div>
						<div class='dashboard-filters-body'>
							<div class='row dashboard-filters-row'>
								<div class='col-lg col-md-6 col-sm-6 mb-3'>
									<label class='dashboard-filter-label'><i class='fas fa-city'></i>Cidade</label>
									<select id='dashboardCidadesCidadeFilter' class='dashboard-filter-control' multiple data-placeholder='Selecione a cidade'>".$filterOptions['cidade']."</select>
								</div>
								<div class='col-lg col-md-6 col-sm-6 mb-3'>
									<label class='dashboard-filter-label'><i class='fas fa-map-marked-alt'></i>Distrito</label>
									<select id='dashboardCidadesDistritoFilter' class='dashboard-filter-control' multiple data-placeholder='Selecione o distrito'>".$filterOptions['distrito']."</select>
								</div>
								<div class='col-lg col-md-6 col-sm-6 mb-3'>
									<label class='dashboard-filter-label'><i class='fas fa-map'></i>Concelho</label>
									<select id='dashboardCidadesConcelhoFilter' class='dashboard-filter-control' multiple data-placeholder='Selecione o concelho'>".$filterOptions['concelho']."</select>
								</div>
								<div class='col-lg col-md-6 col-sm-6 mb-3'>
									<label class='dashboard-filter-label'><i class='fas fa-box-open'></i>Produtos</label>
									<select id='dashboardCidadesProdutoFilter' class='dashboard-filter-control' multiple data-placeholder='Selecione o produto'>".$filterOptions['produto']."</select>
								</div>
								<div class='col-lg col-md-6 col-sm-6 mb-3'>
									<label class='dashboard-filter-label'><i class='fas fa-shopping-cart'></i>Vendas</label>
									<select id='dashboardCidadesVendasEstado' class='dashboard-filter-control'>
										<option value=''>Todos</option>
										<option value='com'>Com vendas</option>
										<option value='sem'>Sem vendas</option>
									</select>
								</div>
							</div>
							<div class='dashboard-filters-actions'>
								<button type='button' class='dashboard-filter-btn dashboard-filter-btn-apply' onclick='applyDashboardCidadesFilters()'>
									<i class='fas fa-filter mr-1'></i> Aplicar filtros
								</button>
								<button type='button' class='dashboard-filter-btn dashboard-filter-btn-clear' onclick='clearDashboardCidadesFilters()'>
									<i class='fas fa-eraser mr-1'></i> Limpar
								</button>
								<button type='button' class='dashboard-filter-btn dashboard-filter-btn-pdf' onclick='downloadDashboardCidadesPdf()'>
									<i class='fas fa-file-pdf mr-1'></i> Gerar PDF
								</button>
								<div class='ml-auto d-flex align-items-center'>
									".($canCreateCidade ? "<button type='button' class='btn btn-success dashboard-table-add-btn' onclick='openDashboardCidadeModal()'><i class='fas fa-plus mr-1'></i>Adicionar cidade</button>" : "")."
									".($canDeleteCidade ? "<button type='button' class='btn btn-secondary dashboard-table-delete-btn dashboard-bulk-delete-btn ml-2' id='dashboardCidadesDeleteSelectedBtn' onclick='confirmDeleteSelectedDashboardCidades()' disabled><i class='fas fa-trash mr-1'></i>Eliminar</button>" : "")."
								</div>
							</div>
						</div>
					</div>
					<div class='table-responsive'>
						<table class='table table-hover table-sm' id='dashboardCidadesTable'>
							<thead>
								<tr>
									".($canDeleteCidade ? "<th class='text-center dashboard-bulk-select-col' style='width:88px;'><label class='dashboard-bulk-select-label mb-0'><input type='checkbox' class='dashboard-bulk-select-all' id='dashboardCidadesSelectAll' title='Selecionar todos'><span class='dashboard-bulk-select-text'>Sel. Todos</span></label></th>" : "")."
									<th><i class='fas fa-city mr-1'></i>Cidade</th>
									<th><i class='fas fa-boxes mr-1'></i>Qtd. produtos vendidos</th>
									".($showCidadesActions ? "<th class='dashboard-actions-col'><i class='fas fa-cogs mr-1'></i>Ações</th>" : "")."
								</tr>
							</thead>
							<tbody id='dashboardCidadesTableBody'></tbody>
						</table>
					</div>
					<div class='modal fade' id='dashboardCidadeModal' tabindex='-1' role='dialog' aria-hidden='true'>
						<div class='modal-dialog modal-lg' role='document'>
							<div class='modal-content'>
								<div class='modal-header'>
									<h5 class='modal-title'>Adicionar cidade</h5>
									<button type='button' class='close' data-dismiss='modal' aria-label='Close'>
										<span aria-hidden='true'>&times;</span>
									</button>
								</div>
								<div class='modal-body'>
									<div class='row'>
										<div class='col-md-12 mb-2'>
											<label class='form-label'>Cidade *</label>
											<input type='hidden' id='dashboardCidadeRowId' value=''>
											<input type='text' class='form-control' id='dashboardCidadeDescricao' maxlength='100' placeholder='Nome da cidade'>
										</div>
									</div>
								</div>
								<div class='modal-footer'>
									<button type='button' class='btn btn-secondary' data-dismiss='modal'><i class='fas fa-times mr-1'></i>Cancelar</button>
									".(($canCreateCidade || $canEditCidade) ? "<button type='button' class='btn btn-success' id='dashboardCidadeSaveBtn' onclick='saveDashboardCidade()'><i class='fas fa-check mr-1'></i>Guardar cidade</button>" : "")."
								</div>
							</div>
						</div>
					</div>
					<input type='hidden' id='dashboardCidadeCanCreate' value='".($canCreateCidade ? "1" : "0")."'>
					<input type='hidden' id='dashboardCidadeCanEdit' value='".($canEditCidade ? "1" : "0")."'>
					<input type='hidden' id='dashboardCidadeCanDelete' value='".($canDeleteCidade ? "1" : "0")."'>
				";
			} catch (PDOException $e) {
				$msg = "Erro ao carregar cidades, ".$e->getMessage();
			}
		return array('msg' => $msg, 'array' => $array);
	}

	function getDashboardCsvFiles(){
		$array = [];
		$canDelete = isset($_SESSION['perm']['core']['dashboard']['Apagar']) && $_SESSION['perm']['core']['dashboard']['Apagar'];
		$paths = $this->getDashboardCsvStoragePaths($_SESSION['user']);
		$relativePath = $paths['finalRelativePath'];
		$targetPath = $paths['finalAbsolutePath'];

		if(!is_dir($targetPath)){
			return $array;
		}

		$files = scandir($targetPath);
		$validFiles = [];
		foreach ($files as $file) {
			if($file == "." || $file == ".."){
				continue;
			}
			$fullPath = $targetPath."/".$file;
			if(!is_file($fullPath)){
				continue;
			}
			$extension = strtolower(pathinfo($file, PATHINFO_EXTENSION));
			if($extension != "csv"){
				continue;
			}
			$validFiles[] = $file;
		}

		usort($validFiles, function($a, $b) use ($targetPath){
			$timeA = filemtime($targetPath."/".$a);
			$timeB = filemtime($targetPath."/".$b);
			if($timeA == $timeB){
				return 0;
			}
			return ($timeA > $timeB) ? -1 : 1;
		});

		foreach ($validFiles as $file) {
			$fullPath = $targetPath."/".$file;
			$array[] = array(
				"nome" => $file,
				"tamanho" => number_format(filesize($fullPath) / 1024, 2, ',', '.')." KB",
				"data" => date("Y-m-d H:i:s", filemtime($fullPath)),
				"link" => $relativePath."/".$file,
				"canDelete" => $canDelete
			);
		}

		return $array;
	}

	function uploadDashboardCsv($info){
		$info = json_decode($info, true);
		$val = 1;
		$msg = "";
		$previewRows = [];
		$uploadTempPath = "";

		if(!isset($_SESSION['perm']['core']['dashboard']['Importar']) || !$_SESSION['perm']['core']['dashboard']['Importar']){
			return json_encode(array("val" => 2, "msg" => "Sem permissão para upload de ficheiros CSV.", "array" => $this->getDashboardCsvFiles()));
		}

		if(!isset($_FILES['files']) && !isset($_FILES['files[]'])){
			return json_encode(array("val" => 2, "msg" => "Não foi selecionado nenhum ficheiro.", "array" => $this->getDashboardCsvFiles()));
		}

		$paths = $this->getDashboardCsvStoragePaths($_SESSION['user']);
		$workspacePath = $paths['workspacePath'];
		$targetPath = $paths['tempAbsolutePath'];

		if (!is_dir($targetPath)) {
			mkdir($targetPath, 0777, true);
		}

		$files = isset($_FILES['files']) ? $_FILES['files'] : $_FILES['files[]'];
		$isMultiple = is_array($files['name']);
		$totalFiles = $isMultiple ? count($files['name']) : 1;

		if($totalFiles !== 1){
			return json_encode(array("val" => 2, "msg" => "É permitido enviar apenas 1 ficheiro por vez.", "array" => $this->getDashboardCsvFiles()));
		}

		for ($i = 0; $i < $totalFiles; $i++) {
			$currentName = $isMultiple ? $files['name'][$i] : $files['name'];
			$extension = strtolower(pathinfo($currentName, PATHINFO_EXTENSION));
			if($extension != "csv"){
				$msg = "Apenas ficheiros CSV são permitidos.";
				$val = 2;
			}
		}

		if($val == 1){
			$folder = "dashboard/csv_tmp/user".$_SESSION['user'];
			$uploadPayload = array("files" => $files);
			$uploadResultRaw = uploadFiles($uploadPayload, $folder);
			$uploadResult = json_decode($uploadResultRaw, true);

			if (!is_array($uploadResult) || !isset($uploadResult['val']) || $uploadResult['val'] != 'uf2') {
				$msg = "Não foi possível guardar o ficheiro enviado.";
				$val = 2;
			} else {
				$savedFiles = [];
				if (isset($uploadResult['files']) && is_array($uploadResult['files'])) {
					foreach ($uploadResult['files'] as $group) {
						if (is_array($group)) {
							foreach ($group as $savedPath) {
								$savedFiles[] = $savedPath;
							}
						}
					}
				}

				if(count($savedFiles) < 1){
					$msg = "Não foi possível guardar o ficheiro enviado.";
					$val = 2;
				}else{
					$relativeSavedPath = str_replace('\\', '/', $savedFiles[0]);
					$destination = $workspacePath."/".$relativeSavedPath;
					$parseResult = $this->parseDashboardCsvRowsFromFile($destination);

					if ($parseResult['val'] != 1) {
						$val = 2;
						$msg = $parseResult['msg'];
						if (is_file($destination)) {
							@unlink($destination);
						}
					} else {
						$previewRows = $parseResult['rows'];
						$uploadTempPath = $relativeSavedPath;
						$msg = "Ficheiro CSV carregado para tratamento temporário. Só será registado após confirmação com inserção válida.";
					}
				}
			}
		}

		if($msg == ""){
			$msg = "Não foi possível enviar os ficheiros CSV.";
			$val = 2;
		}

		return json_encode(array("val" => $val, "msg" => $msg, "rows" => $previewRows, "uploadTempPath" => $uploadTempPath, "array" => $this->getDashboardCsvFiles()));
	}

	function commitDashboardCsvPreview($info){
		$info = json_decode($info, true);

		if(!isset($_SESSION['perm']['core']['dashboard']['Importar']) || !$_SESSION['perm']['core']['dashboard']['Importar']){
			return json_encode(array("val" => 2, "msg" => "Sem permissão para importar dados do CSV."));
		}

		$rows = [];
		if (isset($info['rows']) && is_array($info['rows'])) {
			$rows = $info['rows'];
		}
		$uploadTempPath = isset($info['uploadTempPath']) ? str_replace('\\', '/', trim((string)$info['uploadTempPath'])) : '';

		if(count($rows) < 1){
			return json_encode(array("val" => 2, "msg" => "Não existem linhas válidas para importar."));
		}

		$importResult = $this->importDashboardCsvRows($rows);
		$paths = $this->getDashboardCsvStoragePaths($_SESSION['user']);
		$tempRelativePrefix = $paths['tempRelativePath'].'/';

		if ($uploadTempPath != '' && strpos($uploadTempPath, '..') === false && strpos($uploadTempPath, $tempRelativePrefix) === 0) {
			$tempAbsolutePath = $paths['workspacePath'].'/'.$uploadTempPath;
			if (is_file($tempAbsolutePath)) {
				if ((int)$importResult['val'] === 1 && (int)$importResult['importedRows'] > 0) {
					if (!is_dir($paths['finalAbsolutePath'])) {
						mkdir($paths['finalAbsolutePath'], 0777, true);
					}

					$fileName = basename($tempAbsolutePath);
					$finalAbsolutePath = $paths['finalAbsolutePath'].'/'.$fileName;
					if (file_exists($finalAbsolutePath)) {
						$nameWithoutExt = pathinfo($fileName, PATHINFO_FILENAME);
						$ext = pathinfo($fileName, PATHINFO_EXTENSION);
						$fileName = $nameWithoutExt.'_'.date('YmdHis').($ext != '' ? '.'.$ext : '');
						$finalAbsolutePath = $paths['finalAbsolutePath'].'/'.$fileName;
					}

					if (!@rename($tempAbsolutePath, $finalAbsolutePath)) {
						$importResult['msg'] .= ' As linhas foram importadas, mas não foi possível registar o ficheiro no histórico.';
						@unlink($tempAbsolutePath);
					}
				} else {
					@unlink($tempAbsolutePath);
				}
			}
		}

		return json_encode(array(
			"val" => $importResult['val'],
			"msg" => $importResult['msg'],
			"importedRows" => (int)$importResult['importedRows'],
			"skippedRows" => (int)$importResult['skippedRows'],
			"duplicateRows" => (int)$importResult['duplicateRows'],
			"invalidRows" => (int)$importResult['invalidRows']
		));
	}

	function discardDashboardCsvUpload($info){
		$info = json_decode($info, true);

		if(!isset($_SESSION['perm']['core']['dashboard']['Importar']) || !$_SESSION['perm']['core']['dashboard']['Importar']){
			return json_encode(array("val" => 2, "msg" => "Sem permissão para remover upload temporário."));
		}

		$uploadTempPath = isset($info['uploadTempPath']) ? str_replace('\\', '/', trim((string)$info['uploadTempPath'])) : '';
		if ($uploadTempPath == '' || strpos($uploadTempPath, '..') !== false) {
			return json_encode(array("val" => 1, "msg" => "Sem ficheiro temporário para remover."));
		}

		$paths = $this->getDashboardCsvStoragePaths($_SESSION['user']);
		$tempRelativePrefix = $paths['tempRelativePath'].'/';
		if (strpos($uploadTempPath, $tempRelativePrefix) !== 0) {
			return json_encode(array("val" => 2, "msg" => "Caminho temporário inválido."));
		}

		$tempAbsolutePath = $paths['workspacePath'].'/'.$uploadTempPath;
		if (!is_file($tempAbsolutePath)) {
			return json_encode(array("val" => 1, "msg" => "Sem ficheiro temporário para remover."));
		}

		if (@unlink($tempAbsolutePath)) {
			return json_encode(array("val" => 1, "msg" => "Ficheiro temporário removido."));
		}

		return json_encode(array("val" => 2, "msg" => "Não foi possível remover o ficheiro temporário."));
	}

	function validateDashboardCsvPreview($info){
		$info = json_decode($info, true);

		if(!isset($_SESSION['perm']['core']['dashboard']['Importar']) || !$_SESSION['perm']['core']['dashboard']['Importar']){
			return json_encode(array("val" => 2, "msg" => "Sem permissão para validar dados do CSV.", "rows" => array()));
		}

		$rows = [];
		if (isset($info['rows']) && is_array($info['rows'])) {
			$rows = $info['rows'];
		}

		$validationResult = $this->validateDashboardCsvRows($rows);
		return json_encode(array(
			"val" => (int)$validationResult['val'],
			"msg" => $validationResult['msg'],
			"rows" => $validationResult['rows'],
			"validRows" => (int)$validationResult['validRows'],
			"invalidRows" => (int)$validationResult['invalidRows'],
			"duplicateFileRows" => (int)$validationResult['duplicateFileRows'],
			"duplicateDbRows" => (int)$validationResult['duplicateDbRows']
		));
	}
}
