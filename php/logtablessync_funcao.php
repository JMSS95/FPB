<?php
// Configurações de conexão com o banco de dados
require '../config_ok4_core.php';

// Conexão com o banco de dados
try {
    
    // Query para pegar todas as tabelas do banco de dados
    $stmt = $conn_logs->query("SHOW TABLES");
    $tabelas = $stmt->fetchAll(PDO::FETCH_COLUMN);
    
    // Percorre cada tabela
    foreach ($tabelas as $tabela) {
        // Verifica se a coluna dth_log existe na tabela
        $colunas = $conn_logs->query("SHOW COLUMNS FROM `$tabela` LIKE 'dth_log'");
        
        if ($colunas->rowCount() > 0) {
            // Verifica se funcao_log já existe
            $check_funcao = $conn_logs->query("SHOW COLUMNS FROM `$tabela` LIKE 'funcao_log'");
            
            if ($check_funcao->rowCount() == 0) {
                // Adiciona a coluna funcao_log após dth_log
                $sql = "ALTER TABLE `$tabela` 
                        ADD COLUMN `funcao_log` VARCHAR(1000) NULL 
                        AFTER `dth_log`";
                
                try {
                    $conn_logs->exec($sql);
                    echo "Coluna funcao_log adicionada com sucesso na tabela $tabela\n";
                } catch (PDOException $e) {
                    echo "Erro ao adicionar coluna na tabela $tabela: " . $e->getMessage() . "\n";
                }
            } else {
                echo "A coluna funcao_log já existe na tabela $tabela\n";
            }
        } else {
            echo "A coluna dth_log não existe na tabela $tabela\n";
        }
    }
    
} catch (PDOException $e) {
    echo "Erro na conexão com o banco de dados: " . $e->getMessage();
}

?>