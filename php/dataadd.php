<?php
require __DIR__ . '/../vendor/autoload.php';
use WebSocket\Client;

function saveData($tabela, $dados, $id = 0, $idColumn = 'id')
{
    global $conn;
    $val = 0;
    $msg = "";
    try {
        $fieldsToUpdate = [];
        $values = [];

        // Verificar se $dados é um array associativo simples
        if (!isArrayAssociative($dados)) {
            throw new Exception("Dados inválidos");
        }

        foreach ($dados as $key => $value) {
            if ($key != $idColumn) {
                // Se o valor for null, apenas adicionar às arrays sem aplicar transformações
                if (is_null($value)) {
                    $fieldsToUpdate[] = $key;
                    $values[$key] = null;
                } else {
                    // Para arrays, transformar em string
                    if (is_array($value)) {
                        $value = implode(',', $value);
                    }
                    if (preg_match('/%[0-9A-F]{2}/i', $value)) {
                        $value = urldecode($value);
                    }
                    // Aplicar addslashes apenas em valores não nulos
                    // $value = addslashes($value);
                    $fieldsToUpdate[] = $key;
                    $values[$key] = $value;
                }
            }
        }

        if ($id == 0) {
            // Construir a query de INSERT
            $escapedColumns = array_map(function ($col) {
                return "`$col`";
            }, $fieldsToUpdate);
            $sql = "INSERT INTO `$tabela` (" . implode(", ", $escapedColumns) . ") VALUES(:" . implode(", :", $fieldsToUpdate) . ")";

            // Preparar a query de INSERT
            $stmt = $conn->prepare($sql);
            foreach ($values as $key => $value) {
                // Verificar se o valor é NULL e associar o tipo correto
                if (is_null($value)) {
                    $stmt->bindValue(":$key", $value, PDO::PARAM_NULL); // Usar PDO::PARAM_NULL para valores NULL
                } else {
                    $stmt->bindValue(":$key", $value); // Usar o padrão para outros tipos de dados
                }
            }
            // Executar a query de INSERT
            if ($stmt->execute()) {
                $id = $conn->lastInsertId();
                if(!in_array($tabela,['sky_voucher_excel','sky_voucher','sky_client_temp','sky_produtos_fact'])){
                    logInsert($tabela, $id, 'INSERT');
                }
                $msg = "Operação realizada com sucesso.";
                $val = 1;
            }
        } else {
            // Construir a query de UPDATE
            $setClause = array_map(function ($col) {
                return "`$col` = :$col";
            }, $fieldsToUpdate);
            $sql = "UPDATE `$tabela` SET " . implode(", ", $setClause) . " WHERE `$idColumn` = :id";

            // Preparar a query de UPDATE
            $stmt = $conn->prepare($sql);
            foreach ($values as $key => $value) {
                // Verificar se o valor é NULL e associar o tipo correto
                if (is_null($value)) {
                    $stmt->bindValue(":$key", $value, PDO::PARAM_NULL); // Usar PDO::PARAM_NULL para valores NULL
                } else {
                    $stmt->bindValue(":$key", $value); // Usar o padrão para outros tipos de dados
                }
            }
            $stmt->bindValue(":id", $id);

            // Executar a query de UPDATE
            if ($stmt->execute()) {
                if ($stmt->rowCount() > 0) {
                    if($idColumn != "id") {
                        $stmt = $conn->prepare("SELECT id FROM `$tabela` WHERE `$idColumn` = :id");
                        $stmt->bindValue(":id", $id);
                        $stmt->execute();
                        $registro = $stmt->fetch(PDO::FETCH_ASSOC);
                        if(!in_array($tabela,['sky_voucher_excel','sky_voucher','sky_client_temp','sky_produtos_fact'])){
                            logInsert($tabela, $registro['id'], 'UPDATE');
                        }
                        
                    }else{
                        if(!in_array($tabela,['sky_voucher_excel','sky_voucher','sky_client_temp','sky_produtos_fact'])){
                            logInsert($tabela, $id, 'UPDATE');
                        }
                    }
                    $msg = "Operação realizada com sucesso.";
                    $val = 1;
                } else {
                    $msg = "Nenhuma alteração foi feita.";
                    $val = 1;
                }
            }
        }
    } catch (PDOException $e) {
        if ($e->getCode() == 23000) {
            if (preg_match("/Duplicate entry '.*?' for key '(.*?)'/", $e->getMessage(), $matches)) {
                $campoDuplicado = $matches[1];
                $msg = "Campo '{$campoDuplicado}' duplicado.";
            } else {
                $msg = "Erro de duplicidade, mas o campo não foi identificado.Erro: " . $e->getMessage();;
            }
        } else {
            $msg = "Erro: " . $e->getMessage();
        }
        $val = 2;
    } catch (Exception $e) {
        $val = 2;
        $msg = "Erro: " . $e->getMessage();
    }

    return array("id" => $id, "val" => $val, "msg" => $msg);
}

function isArrayAssociative($array)
{
    if (!is_array($array))
        return false;
    return array_keys($array) !== range(0, count($array) - 1);
}

function isArrayOfObjects($array)
{
    // Verifica se é realmente um array
    if (!is_array($array)) {
        return false;
    }

    // Verifica se o array não é associativo
    if (array_keys($array) === range(0, count($array) - 1)) {
        // Verifica se cada elemento do array é um array associativo
        foreach ($array as $item) {
            if (!isArrayAssociative($item)) {
                return false;
            }
        }
        return true;
    }

    return false;
}

function uploadFiles($files, $folder)
{
    $uploadedFiles = array();

    foreach ($files as $fieldName => $fieldArray) {
        if (is_array($fieldArray['name'])) {
            foreach ($fieldArray['name'] as $index => $name) {
                $tmpName = $fieldArray['tmp_name'][$index];
                $extension = pathinfo($name, PATHINFO_EXTENSION);
                $newName = uniqid() . '.' . $extension;
                $destination = 'uploads/' . $folder . '/' . $newName;

                if (move_uploaded_file($tmpName, $destination)) {
                    $uploadedFiles[$fieldName][] = $destination;
                } else {
                    return json_encode(array("val" => "uf1"));
                }
            }
        } else {
            // Caso onde há apenas um arquivo
            $name = $fieldArray['name'];
            $tmpName = $fieldArray['tmp_name'];
            $extension = pathinfo($name, PATHINFO_EXTENSION);
            $newName = uniqid() . '.' . $extension;
            $destination = 'uploads/' . $folder . '/' . $newName;

            if (move_uploaded_file($tmpName, $destination)) {
                $uploadedFiles[$fieldName][] = $destination;
            } else {
                return json_encode(array("val" => "uf1"));
            }
        }
    }

    return json_encode(array("val" => "uf2", "files" => $uploadedFiles));
}

function socketOperacoes($val)
{
    // WebSocket server URL
    $wsUrl = "ws://localhost:8082";

    try {
        // Create a new WebSocket client connection
        $client = new Client($wsUrl);
        // Send the message to the WebSocket server
        $client->send(json_encode($val));
        // Optionally, you can receive a response from the server
        $response = $client->receive();
        // Close the WebSocket connection
        $client->close();

        return $response;
    } catch (Exception $e) {
        echo "Error: {$e->getMessage()}\n";
        return null;
    }
}
 
// function isArrayOfObjects($array) {
//     // Verifica se é realmente um array
//     if (!is_array($array)) {
//         return false;
//     }

//     // Verifica se o array não é associativo
//     if (array_keys($array) === range(0, count($array) - 1)) {
//         // Verifica se cada elemento do array é um array associativo
//         foreach ($array as $item) {
//             if (!isArrayAssociative($item)) {
//                 return false;
//             }
//         }
//         return true;
//     }

//     return false;
// }
// function isArrayAssociative($array) {
//     // Verifica se é realmente um array
//     if (!is_array($array)) {
//         return false;
//     }

//     // Verifica se o array é associativo
//     return array_keys($array) !== range(0, count($array) - 1);
// }

// function saveData($tabela, $dados, $id = 0, $idColumn = 'id') {
//     global $conn;
//     $msg = "";
//     $val = 1;
//     try {
//         $fieldsToUpdate = [];

//         // Verificar se $fieldsToUpdate é multidimensional
//         if (is_array($dados)) {
//             $dados = [$dados];
//         }

//         foreach ($dados as $item) {
//             foreach ($item as $key => $value) {
//                 if (!empty($value) || (is_array($value) && count($value) > 0)) {
//                     if (preg_match('/%[0-9A-F]{2}/i', $value)) {
//                         $value = urldecode($value);
//                     }
//                     $value = htmlspecialchars($value, ENT_QUOTES, 'UTF-8');
//                     $fieldsToUpdate[$key] = $value;
//                 }
//             }
//         }

//         // Obter as colunas e os placeholders
//         $colunas = array_keys($fieldsToUpdate);
//         $placeholders = array_map(function($col) { return ":$col"; }, $colunas);

//         if($id == 0){
//             // Construir a query SQL de INSERT
//             $escapedColumns = array_map(function($col) { return "`$col`"; }, $colunas);
//             $sql = "INSERT INTO `$tabela` (" . implode(", ", $escapedColumns) . ") 
//                     VALUES (" . implode(", ", $placeholders) . ")";
//             $acaoLog = 'INSERT';
//         } else {
//             // Construir a query SQL de UPDATE
//             $setClause = array_map(function($col) { return "`$col` = :$col"; }, $colunas);
//             $sql = "UPDATE `$tabela` SET " . implode(", ", $setClause) . " WHERE `$idColumn` = :id";
//             $acaoLog = 'UPDATE';
//         }

//         // Preparar a query
//         $stmt = $conn->prepare($sql);

//         // Associar os valores aos placeholders
//         foreach ($fieldsToUpdate as $key => $value) {
//             $stmt->bindValue(":$key", $value);
//         }

//         if ($id != 0) {
//             // Associar o valor do identificador ao placeholder
//             $stmt->bindValue(":id", $id);
//         }

//         // Executar a query
//         if($stmt->execute()){
//             if($id == 0){
//                 $id = $conn->lastInsertId();
//             }
//             logInsert($tabela, $id, $acaoLog);
//         }

//         $msg = "Operação realizada com sucesso.";
//     } catch (PDOException $e) {
//         $val = 2;
//         $msg = "Erro: " . $e->getMessage();
//     }


//     return array("id"=>$id, "val" =>$val ,"msg"=>$msg);

// }
