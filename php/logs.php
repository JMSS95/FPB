<?php

function getLog($tabela, $id, $campo = "id") {
    global $conn_logs;

    $val = 1;
    $msg = "";
    $html = "";
    $alteracoes = [];

    try {
        $html .= "<div class='widget-todolist-body'>";
        // Buscar o cometário da tabela
        $sql = "SELECT table_name as nome, table_comment as traducao
        FROM information_schema.tables
        WHERE table_schema = 'ok4_aernnova_pintura_logs'
        AND table_name = :tabela;";
        $stmt = $conn_logs->prepare($sql);
        $stmt->execute([
            ':tabela' => $tabela
        ]);
        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
        $objTabela = $rows;

        $objCampos = [];
        // Buscar o comentário das colunas
        $sql = "SELECT COLUMN_NAME as nome, COLUMN_COMMENT as traducao
        FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = 'ok4_aernnova_pintura_logs'
        AND TABLE_NAME = :tabela";
        $stmt = $conn_logs->prepare($sql);
        $stmt->execute([
            ':tabela' => $tabela
        ]);
        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
        $objCampos = $rows;

        $sql = "SELECT * FROM $tabela WHERE $campo = :id ORDER BY dth_log DESC";
        $stmt = $conn_logs->prepare($sql);
        $stmt->execute([
            ':id' => $id
        ]);
        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
        if ($rows) {

            $anterior = null;

            // Percorrer cada linha do resultado
            foreach ($rows as $row) {
                $log = [
                    'id_log' => $row['id_log'],
                    'iduser_text_log' => $row['iduser_text_log'],
                    'iduser_log' => $row['iduser_log'],
                    'dth_log' => $row['dth_log'],
                    'dth_format_log' => (new DateTime($row['dth_log']))->format('d-m-Y H:i'),
                    'acao_log' => $row['acao_log'],
                    'info' => []
                ];


                // Para casos especificos "marteladas"
                if($anterior && ($tabela == "faturacao_faturas_escalas_itens" || $tabela == "coord_escalas_user")) {
                    $tempAlteracoes = [];
                    foreach ($row as $campo => $valor_novo) {
                        if (!in_array($campo, ['id_log', 'iduser_text_log', 'iduser_log', 'dth_log', 'acao_log', 'funcao_log', 'updated_at'])) {
                            // Verifica se o campo não é do tipo 'hide'
                            $traducaoCampo = traduzirCampo($campo, $objCampos);
                            if ($traducaoCampo == 'hide') continue;
                            $tempAlteracoes[] = [
                                'campo' => $traducaoCampo,
                                'valor_antigo' => "",
                                'valor_novo' => $valor_novo
                            ];
                        }
                    }
                    $alteracoes[count($alteracoes)-1]['info'] = $tempAlteracoes;
                }
                // Casos normais
                else if ($anterior) {
                    $tempAlteracoes = [];
                    foreach ($row as $campo => $valor_novo) {
                        if (!in_array($campo, ['id_log', 'iduser_text_log', 'iduser_log', 'dth_log', 'acao_log', 'funcao_log', 'updated_at']) && $anterior[$campo] != $valor_novo) {
                            // Verifica se o campo não é do tipo 'hide'
                            $traducaoCampo = traduzirCampo($campo, $objCampos);
                            if ($traducaoCampo == 'hide') continue;
                            $tempAlteracoes[] = [
                                'campo' => $traducaoCampo,
                                'valor_antigo' => $valor_novo,
                                'valor_novo' => $anterior[$campo]
                            ];
                        }
                    }
                    $alteracoes[count($alteracoes)-1]['info'] = $tempAlteracoes;
                }
                $alteracoes[] = $log;
                $anterior = $row;
            }
            // print_r($alteracoes);
            foreach ($alteracoes as $data) {
                $html .= "<div class='widget-todolist-item'>
                            <div class='widget-todolist-content'>

                                <h6 class='mb-1'>".traduzirCampo($tabela, $objTabela)." ".($data['acao_log'] == "INSERT" ? 'criado' : ($data['acao_log'] == "UPDATE" ? 'atualizado' : ($data['acao_log'] == "DELETE" ? 'eliminado' : 'atualizado')))." - <span style='font-size:10px; color:#5d5d5d'>".$data['dth_format_log']." por ".$data['iduser_text_log']."</span></h6>";
                                if($data['acao_log'] == "INSERT") {
                                    foreach ($data['info'] as $dataLog) {
                                        if($dataLog['valor_novo'] != null && $dataLog['valor_novo'] != "") {
                                            $html .= "<div class='text-body text-opacity-75 fw-bold fs-11px ml-2'> ● ".$dataLog['campo'].": ".$dataLog['valor_novo']."</div>";
                                        }
                                    }
                                }else if($data['acao_log'] == "UPDATE") {
                                    foreach ($data['info'] as $dataLog) {
                                        if($dataLog['campo'] == "act" || $dataLog['campo'] == "is_active") {
                                            $html .= "<div class='text-body text-opacity-75 fw-bold fs-11px ml-2'> ● Estado: ".($dataLog['valor_novo'] == 1 ? "Ativo" : "Eliminado")." <span style='color:gray'>(Anteriormente: ".($dataLog['valor_antigo'] == 1 ? "Ativo" : "Eliminado").")</span></div>";
                                        }else{
                                            $html .= "<div class='text-body text-opacity-75 fw-bold fs-11px ml-2'> ● ".$dataLog['campo'].": ".(($dataLog['valor_novo'] == null || $dataLog['valor_novo'] == "") ? "removido" : $dataLog['valor_novo'])." <span style='color:gray'>".(($dataLog['valor_antigo'] != null && $dataLog['valor_antigo'] != "") ? "(Anteriormente: ".$dataLog['valor_antigo'].")" : "")."</span></div>";
                                        }
                                    }
                                }
                  $html .= "</div>
                        </div>";
            }
        }

        $html .= "</div>";
    } catch (PDOException $e) {
        $msg = $e->getMessage();
        $val = 2;
        error_log("getLogs PDOException: " . $msg);
    }

    return array("msg" => $msg, "val" => $val, "html" => $html, "data" => $alteracoes ? $alteracoes : []);
}

function logInsert($tabela, $id, $acao, $user = "Cron", $iduser = "Cron") {
    global $conn_logs;
    try {
        if(!function_exists($tabela)) {
            return; // Função de log não definida para esta tabela, ignorar
        }
        $trace = getBacktrace();
        $rows = $tabela($id, true)[0];
        if(count($rows) > 0) {
            // Adicionando colunas e placeholders fixos dos logs
            $fixedColumns = ["acao_log", "iduser_text_log", "iduser_log", "dth_log", "funcao_log"];
            $sessionNome = isset($_SESSION['nome']) ? $_SESSION['nome'] : $user;
            $sessionUser = isset($_SESSION['user']) ? $_SESSION['user'] : $iduser;
            $fixedValues = [$acao, $sessionNome, $sessionUser, date("Y-m-d H:i:s"), $trace];

             // Obtendo as colunas e os placeholders
            $colunas = array_merge(array_keys($rows), $fixedColumns);
            $placeholders = array_map(function($col) { return ":$col"; }, array_keys($rows));

            // Construindo a query SQL
            $escapedColumns = array_map(function($col) { return "`$col`"; }, $colunas);
            $sql = "INSERT INTO `$tabela` (" . implode(", ", $escapedColumns) . ")
            VALUES (" . implode(", ", $placeholders) . ", :acao_log, :iduser_text_log, :iduser_log, :dth_log, :funcao_log)";

            // Preparando a query
            $stmt = $conn_logs->prepare($sql);

            // Associando os valores aos placeholders
            foreach ($rows as $key => $value) {
                if($key == "loguser" && !isset($value)) {
                    $value = -1;
                }elseif($key == "logdth" && !isset($value)) {
                    $value = (new DateTime())->format('Y-m-d H:i:s');
                }
                $stmt->bindValue(":$key", $value);
            }

            // Associando os valores fixos dos logs
            $stmt->bindValue(":acao_log", $fixedValues[0]);
            $stmt->bindValue(":iduser_text_log", $fixedValues[1]);
            $stmt->bindValue(":iduser_log", $fixedValues[2]);
            $stmt->bindValue(":dth_log", $fixedValues[3]);
            $stmt->bindValue(":funcao_log", $fixedValues[4]);

            $stmt->execute();
        }

    }
    catch (PDOException $e) {
        error_log("logInsert PDOException [" . $tabela . "]: " . $e->getMessage());
    }
}

function getBacktrace() {
    $trace = debug_backtrace(DEBUG_BACKTRACE_IGNORE_ARGS, 10);

    $trace = array_slice($trace, 3);

    foreach ($trace as &$chamada) {
        if (isset($chamada['type'])) { unset($chamada['type']);}
        if (isset($chamada['file'])) { unset($chamada['file']);}
        if (isset($chamada['line'])) { unset($chamada['line']);}
    }
    unset($chamada);

    return json_encode($trace);
}

function mergeLogs($arrays, $tabela){
    $val = 1;
    $msg = "";
    $html = "";
    $mergeLogs = [];

    try{
        foreach ($arrays as $subArray) {
            foreach ($subArray as $item) {
                if (!isset($item['iduser_log'], $item['dth_log'], $item['info'])) {
                    // Ignora itens sem as chaves necessárias.
                    continue;
                }

                // Chave de agrupamento com base nos campos `iduser_log`, `dth_log` e `acao_log`.
                $chaveAgrupamento = $item['iduser_log'] . '|' . $item['dth_log'];

                if (!isset($mergeLogs[$chaveAgrupamento])) {
                    // Adiciona o item no resultado, iniciando o agrupamento.
                    $mergeLogs[$chaveAgrupamento] = $item;
                } else {
                    // Mescla os dados de `info`.
                    $mergeLogs[$chaveAgrupamento]['info'] = array_merge(
                        $mergeLogs[$chaveAgrupamento]['info'],
                        $item['info']
                    );
                }
            }
        }

        $mergeLogs = array_values($mergeLogs);

        // Ordena o array por dth_log
        usort($mergeLogs, function ($a, $b) {
            return strtotime($b['dth_log']) <=> strtotime($a['dth_log']);
        });

        foreach ($mergeLogs as $index => $data) {
            $html .= "<div class='widget-todolist-item'>
                        <div class='widget-todolist-content'>

                            <h6 class='mb-1'>".$tabela." ".(($index+1) == count($mergeLogs) ? "criado" : ($data['acao_log'] == "DELETE" ? "eliminado" : "atualizado"))." - <span style='font-size:10px; color:#5d5d5d'>".$data['dth_format_log']." por ".$data['iduser_text_log']."</span></h6>";
                            if($data['acao_log'] == "INSERT") {
                                foreach ($data['info'] as $dataLog) {
                                    if($dataLog['valor_novo'] != null && $dataLog['valor_novo'] != "") {
                                        $html .= "<div class='text-body text-opacity-75 fw-bold fs-11px ml-2'> ● ".$dataLog['campo'].": ".$dataLog['valor_novo']."</div>";
                                    }
                                }
                            }else if($data['acao_log'] == "UPDATE") {
                                foreach ($data['info'] as $dataLog) {
                                    if($dataLog['campo'] == "act" || $dataLog['campo'] == "is_active") {
                                        $html .= "<div class='text-body text-opacity-75 fw-bold fs-11px ml-2'> ● Estado: ".($dataLog['valor_novo'] == 1 ? "Ativo" : "Eliminado")." <span style='color:gray'>(Anteriormente: ".($dataLog['valor_antigo'] == 1 ? "Ativo" : "Eliminado").")</span></div>";
                                    }else{
                                        $html .= "<div class='text-body text-opacity-75 fw-bold fs-11px ml-2'> ● ".$dataLog['campo'].": ".(($dataLog['valor_novo'] == null || $dataLog['valor_novo'] == "") ? "removido" : $dataLog['valor_novo'])." <span style='color:gray'>".(($dataLog['valor_antigo'] != null && $dataLog['valor_antigo'] != "") ? "(Anteriormente: ".$dataLog['valor_antigo'].")" : "")."</span></div>";
                                    }
                                }
                            }
              $html .= "</div>
                    </div>";
        }

    } catch (PDOException $e) {
        $msg = $e->getMessage();
        $val = 2;
        error_log("mergeLogs PDOException [" . $tabela . "]: " . $msg);
    }


    return array("msg" => $msg, "val" => $val, "html" => $html, "data" => $mergeLogs);
}

function traduzirCampo($campo, $objCampos) {
    foreach ($objCampos as $objCampo) {
        if ($objCampo["nome"] == $campo) {
            if (!empty($objCampo["traducao"])) {
                return $objCampo["traducao"];
            }
            break;
        }
    }
    return $campo;
}
