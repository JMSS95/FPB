<?php

require '../config_ok4_core.php';

$actions = [];

try {
    // Obter todas as tabelas do banco de dados de origem
    $tableQuery = "SHOW TABLES";
    $tableResult = $conn->query($tableQuery);

    while ($tableRow = $tableResult->fetch(PDO::FETCH_NUM)) {
        $tableName = $tableRow[0];
        $tableActions = [];

        // Verifica se a tabela já existe no banco de dados de destino
        $checkTableQuery = "SHOW TABLES LIKE '$tableName'";
        $checkTableResult = $conn_logs->query($checkTableQuery);

        if ($checkTableResult->rowCount() == 0) {
            // A tabela não existe no banco de dados de destino, então vamos criá-la
            $columnQuery = "SHOW COLUMNS FROM $tableName";
            $columnResult = $conn->query($columnQuery);

            $columns = [];
            while ($columnRow = $columnResult->fetch(PDO::FETCH_ASSOC)) {
                $columns[] = $columnRow['Field'];
            }

            $createTableQuery = "CREATE TABLE IF NOT EXISTS $tableName (
               id_log INT PRIMARY KEY AUTO_INCREMENT,
               acao_log VARCHAR(255),
               iduser_text_log VARCHAR(255),
               iduser_log VARCHAR(255),
               dth_log DATETIME,
               funcao_log VARCHAR(1000),";

            foreach ($columns as $column) {
                $createTableQuery .= "`$column` VARCHAR(255),";
            }

            $createTableQuery = rtrim($createTableQuery, ',') . ")";
            $conn_logs->exec($createTableQuery);

            $tableActions[] = "Tabela criada com sucesso na base de dados de logs.";

        } else {
            // A tabela já existe no banco de dados de destino, então vamos verificar as colunas
            $columnQuery = "SHOW COLUMNS FROM $tableName";
            $columnResult = $conn->query($columnQuery);

            $originColumns = [];
            while ($columnRow = $columnResult->fetch(PDO::FETCH_ASSOC)) {
                $originColumns[] = $columnRow['Field'];
            }

            $columnQuery = "SHOW COLUMNS FROM $tableName";
            $columnResult = $conn_logs->query($columnQuery);

            $destColumns = [];
            while ($columnRow = $columnResult->fetch(PDO::FETCH_ASSOC)) {
                $destColumns[] = $columnRow['Field'];
            }

            // Verificar novas colunas
            $newColumns = array_diff($originColumns, $destColumns);
            if (!empty($newColumns)) {
                $prevColumn = null;

                foreach ($originColumns as $column) {
                    if (in_array($column, $newColumns)) {
                        $alterTableQuery = "ALTER TABLE $tableName ADD `$column` VARCHAR(255)";

                        if ($prevColumn) {
                            $alterTableQuery .= " AFTER `$prevColumn`";
                        } else {
                            $alterTableQuery .= " FIRST";
                        }

                        $conn_logs->exec($alterTableQuery);
                        $tableActions[] = "Coluna <strong>$column</strong> adicionada.";
                    }

                    if (in_array($column, $destColumns)) {
                        $prevColumn = $column;
                    }
                }
            }

            // Verificar colunas removidas
            $removedColumns = array_diff($destColumns, $originColumns);
            foreach ($removedColumns as $removedColumn) {
                if (!in_array($removedColumn, ['id_log', 'acao_log', 'iduser_text_log', 'iduser_log', 'dth_log', 'funcao_log'])) {
                    $alterTableQuery = "ALTER TABLE $tableName DROP COLUMN `$removedColumn`";
                    $conn_logs->exec($alterTableQuery);
                    $tableActions[] = "Coluna <strong>$removedColumn</strong> removida.";
                }
            }

            if (empty($tableActions)) {
                continue; // Se não houve alteração, pula para a próxima tabela
            }

            // $tableActions[] = "Tabela verificada/atualizada com sucesso.";
        }

        // Se houve alguma ação para esta tabela, adiciona no array principal
        if (!empty($tableActions)) {
            $actions[$tableName] = $tableActions;
        }
    }

} catch (PDOException $e) {
    $actions['Erro'] = ["Erro: " . $e->getMessage()];
}

// Exibir o resultado em HTML
?>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Atualização do Banco de Dados</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 800px;
            margin: auto;
            background: #fff;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }
        h1 {
            text-align: center;
            color: #333;
        }
        .table-group {
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
            padding: 10px;
        }
        .table-group h2 {
            margin: 0;
            padding: 10px;
            background-color: #007bff;
            color: #fff;
            border-radius: 5px 5px 0 0;
            font-size: 18px;
        }
        ul {
            list-style-type: none;
            padding: 0;
            margin: 0;
        }
        li {
            background: #e0e0e0;
            margin: 5px 0;
            padding: 10px;
            border-radius: 5px;
            color: #333;
        }
        li strong {
            color: #007bff;
        }
        .error {
            color: #ff0000;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Atualização Base de dados LOGs</h1>
        <?php foreach ($actions as $table => $tableActions): ?>
            <div class="table-group">
                <h2>Tabela: <?php echo $table; ?></h2>
                <ul>
                    <?php foreach ($tableActions as $action): ?>
                        <li><?php echo $action; ?></li>
                    <?php endforeach; ?>
                </ul>
            </div>
        <?php endforeach; ?>
        <?php if (empty($actions)): ?>
            <p>Nenhuma tabela sofreu alterações.</p>
        <?php endif; ?>
    </div>
</body>
</html>
