<?php
$GLOBALS['ex'] = 0;
class TabelasAuxiliaresdb
{
    function loadPage()
    {
        global $conn;
        $status = 1;
        $page = "";

        //Menus
        $page .= "
            <div class='list-group d-flex flex-row mb-3' id='list-tab-tabAuxMenu' role='tablist'>
                <a class='list-group-item list-group-item-action active' id='list-backoffice-list' data-toggle='list'
                    href='#list-backoffice' role='tab' aria-controls='backoffice' onclick='toggleTablesBackoffice()'>Backoffice</a>
            </div>
        ";

        //Tables Backoffice
        $page .= "
        <div id='tablesBackofficeDiv'>
            <div class='list-group d-flex flex-row mb-3' id='list-tab-tabAuxTablesBackoffice' role='tablist'>
                <a class='list-group-item list-group-item-action active' id='list-tiposcolaborador-list' data-toggle='list' href='#list-tiposcolaborador' role='tab' aria-controls='turnos'>Tipos Colaborador</a>
                <a class='list-group-item list-group-item-action' id='list-funcoes-list' data-toggle='list' href='#list-funcoes' role='tab' aria-controls='grupos'>Funções</a>
                <a class='list-group-item list-group-item-action' id='list-departamentos-list' data-toggle='list' href='#list-departamentos' role='tab' aria-controls='anexos'>Departamentos</a>
            </div>
        </div>
        ";


        return json_encode(array('status' => $status, 'page' => $page));
    }

    //BACKOFFICE - Tipos Colaborador
    function loadTableTiposcolaborador()
    {
        global $conn;
        $status = 1;
        $btn = "";
        $msg = '
            <div class="table-responsive">
                <table class="table table-hover table-compact" id="tblTiposcolaborador">
                    <thead>
                        <tr>
                            <th>Descrição</th>
                        </tr>
                    </thead>
                    <tbody>
        ';
        $array = core_tipouser();
        foreach ($array as $row) {
            $msg .= '
            <tr style="' . ($row['is_active'] == 0 ? "background-color:rgba(204, 204, 204, 0.5);" : "") . '" onclick="editTiposcolaborador(' . $row["id"] . ')">
                <td>' . $row['descricao'] . '</td>
            </tr>
        ';
        }

        $msg .= '
                    </tbody>
                </table>
            </div>
        ';

        if ($_SESSION['perm']['core']['tabelasAuxiliares']['Adicionar']) {
            $btn = "<button class='btn btn-default btn-xs' onclick='drawerTiposcolaborador()'>Adicionar Tipo de Utilizador <i class='fas fa-plus-circle'></i></button>";
        }

        return json_encode(array('msg' => $msg, 'status' => $status, 'btn' => $btn));
    }
    function addTiposcolaborador($info)
    {
        global $conn;
        $dados = json_decode($info, true);
        $dados['is_active'] = 1;
        $msg = "";
        $val = 1;

        try {
            $insert = saveData("core_tipouser", $dados);
            if ($insert['val'] == 1) {
                $msg = "Tipo de utilizador adicionado com sucesso.";
                $val = 1;
            } else {
                $msg = $insert['msg'];
                $val = 2;
            }

        } catch (PDOException $e) {
            $msg = $e->getMessage();
            $val = 2;
        }

        return json_encode(array("msg" => $msg, "val" => $val));
    }
    function editTiposcolaborador($info)
    {
        global $conn;
        $info = json_decode($info, true);
        $status = 0;
        $msg = "";
        $id = $info['id'];
        $get = "";
        try {
            $sql = "SELECT * FROM core_tipouser WHERE id = :id";
            $stmt = $conn->prepare($sql);
            $stmt->execute([
                ':id' => $id
            ]);
            $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
            if ($rows) {
                $status = 1;
                foreach ($rows as $row) {
                    $get = $row;
                }
            } else {
                $status = 2;
            }
        } catch (PDOException $e) {
            $status = 2;
            $msg = "Error fetching data: " . $e->getMessage();
        }

        $responseLog = getLog("core_tipouser", $id);

        return json_encode(array('status' => $status, 'get' => $get, 'msg' => $msg, "responseLog" => $responseLog));
    }
    function guardarEditTiposcolaborador($info)
    {
        global $conn;
        $dados = json_decode($info, true);
        $id = $dados['id'];

        $msg = "";
        $val = 1;
        try {
            $update = saveData("core_tipouser", $dados, $id);
            if ($update['val'] == 1) {
                $msg = "Tipo de utilizador atualizado com sucesso.";
                $val = 1;
            } else {
                $msg = $update['msg'];
                $val = 2;
            }

        } catch (PDOException $e) {
            $msg = $e->getMessage();
            $val = 2;
        }

        return json_encode(array("msg" => $msg, "val" => $val));
    }

    //BACKOFFICE - Funções
    function loadTableFuncoes()
    {
        global $conn;
        $status = 1;
        $btn = "";
        $msg = '
            <div class="table-responsive">
                <table class="table table-hover table-compact" id="tblFuncoes">
                    <thead>
                        <tr>
                            <th>Descrição</th>
                            <th>Ordem</th>
                            <th>Departamento</th>
                        </tr>
                    </thead>
                    <tbody>
        ';
        $array = core_funcao(0, true);
        foreach ($array as $row) {
            $msg .= '
            <tr style="' . ($row['is_active'] == 0 ? "background-color:rgba(204, 204, 204, 0.5);" : "") . '" onclick="editFuncoes(' . $row["id"] . ')">
                <td>' . $row['descricao'] . '</td>
                <td>' . $row['ordem'] . '</td>
                <td>' . $row['id_depart'] . '</td>
            </tr>
        ';
        }

        $msg .= '
                    </tbody>
                </table>
            </div>
        ';

        if ($_SESSION['perm']['core']['tabelasAuxiliares']['Adicionar']) {
            $btn = "<button class='btn btn-default btn-xs' onclick='drawerFuncoes()'>Adicionar Função <i class='fas fa-plus-circle'></i></button>";
        }

        return json_encode(array('msg' => $msg, 'status' => $status, 'btn' => $btn));
    }
    function drawerFuncoes() {
        global $conn;
        $msg = "";
        $val = 1;
        $departamentos = [];

        try {
            // Buscar todos os departamentos
            $sql = "SELECT core_departamento.id, core_departamento.descricao FROM core_departamento WHERE core_departamento.is_active = 1";
            $stmt = $conn->prepare($sql);
            $stmt->execute();
            $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
            if ($rows) {
                foreach ($rows as $row) {
                    $departamentos[] = $row;
                }
            }
        } catch (PDOException $e) {
            $val = 2;
            $msg = "Error fetching data: " . $e->getMessage();
        }

        return json_encode(array('msg' => $msg, 'val' => $val, 'departamentos' => $departamentos));
    }
    function addFuncoes($info)
    {
        global $conn;
        $dados = json_decode($info, true);
        $dados['is_active'] = 1;
        $msg = "";
        $val = 1;

        try {
            $insert = saveData("core_funcao", $dados);
            if ($insert['val'] == 1) {
                $msg = "Função adicionada com sucesso.";
                $val = 1;
            } else {
                $msg = $insert['msg'];
                $val = 2;
            }

        } catch (PDOException $e) {
            $msg = $e->getMessage();
            $val = 2;
        }

        return json_encode(array("msg" => $msg, "val" => $val));
    }
    function editFuncoes($info)
    {
        global $conn;
        $info = json_decode($info, true);
        $val = 0;
        $msg = "";
        $id = $info['id'];
        $get = "";
        $departamentos = [];
        try {
            $sql = "SELECT id, descricao, is_active FROM core_departamento";
            $stmt = $conn->prepare($sql);
            $stmt->execute();
            $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
            if ($rows) {
                $val = 1;
                foreach ($rows as $row) {
                    $departamentos[] = $row;
                }
            } else {
                $val = 2;
            }

            $sql = "SELECT * FROM core_funcao WHERE id = :id";
            $stmt = $conn->prepare($sql);
            $stmt->execute([
                ':id' => $id
            ]);
            $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
            if ($rows) {
                $val = 1;
                foreach ($rows as $row) {
                    $get = $row;
                }
            } else {
                $val = 2;
            }
        } catch (PDOException $e) {
            $val = 2;
            $msg = "Error fetching data: " . $e->getMessage();
        }

        $responseLog = getLog("core_funcao", $id);

        return json_encode(array('val' => $val, 'get' => $get, 'msg' => $msg, "departamentos"=>$departamentos,"responseLog" => $responseLog));
    }
    function guardarEditFuncoes($info)
    {
        global $conn;
        $dados = json_decode($info, true);
        $id = $dados['id'];

        $msg = "";
        $val = 1;
        try {
            $update = saveData("core_funcao", $dados, $id);
            if ($update['val'] == 1) {
                $msg = "Função atualizada com sucesso.";
                $val = 1;
            } else {
                $msg = $update['msg'];
                $val = 2;
            }

        } catch (PDOException $e) {
            $msg = $e->getMessage();
            $val = 2;
        }

        return json_encode(array("msg" => $msg, "val" => $val));
    }

    // BACKOFFICE - Departamentos
    function loadTableDepartamentos()
    {
        global $conn;
        $status = 1;
        $btn = "";

        $msg = '
            <div class="table-responsive">
                <table class="table table-hover table-compact" id="tblDepartamentos">
                    <thead>
                        <tr>
                            <th>Cod</th>
                            <th>Descrição</th>
                        </tr>
                    </thead>
                    <tbody>
        ';
        $array = core_departamento();
        foreach ($array as $row) {
            $msg .= '
            <tr style="' . ($row['is_active'] == 0 ? "background-color:rgba(204, 204, 204, 0.5);" : "") . '" onclick="editDepartamentos(' . $row["id"] . ')">
                <td>' . $row['cod'] . '</td>
                <td>' . $row['descricao'] . '</td>
            </tr>
        ';
        }

        $msg .= '
                    </tbody>
                </table>
            </div>
        ';

        if ($_SESSION['perm']['core']['tabelasAuxiliares']['Adicionar']) {
            $btn = "<button class='btn btn-default btn-xs' onclick='drawerDepartamentos()'>Adicionar Departamento <i class='fas fa-plus-circle'></i></button>";
        }

        return json_encode(array('msg' => $msg, 'status' => $status, 'btn' => $btn));
    }
    function addDepartamentos($info)
    {
        global $conn;
        $dados = json_decode($info, true);
        $dados['is_active'] = 1;
        $msg = "";
        $val = 1;

        try {
            $insert = saveData("core_departamento", $dados);
            if ($insert['val'] == 1) {
                $msg = "Departamento adicionado com sucesso.";
                $val = 1;
            } else {
                $msg = $insert['msg'];
                $val = 2;
            }

        } catch (PDOException $e) {
            $msg = $e->getMessage();
            $val = 2;
        }

        return json_encode(array("msg" => $msg, "val" => $val));
    }
    function editDepartamentos($info)
    {
        global $conn;
        $info = json_decode($info, true);
        $val = 0;
        $msg = "";
        $id = $info['id'];
        $get = "";
        try {
            $sql = "SELECT * FROM core_departamento WHERE id = :id";
            $stmt = $conn->prepare($sql);
            $stmt->execute([
                ':id' => $id
            ]);
            $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
            if ($rows) {
                $val = 1;
                foreach ($rows as $row) {
                    $get = $row;
                }
            } else {
                $val = 2;
            }
        } catch (PDOException $e) {
            $val = 2;
            $msg = "Error fetching data: " . $e->getMessage();
        }

        $responseLog = getLog("core_departamento", $id);

        return json_encode(array('val' => $val, 'get' => $get, 'msg' => $msg, "responseLog" => $responseLog));
    }
    function guardarEditDepartamentos($info)
    {
        global $conn;
        $dados = json_decode($info, true);
        $id = $dados['id'];

        $msg = "";
        $val = 1;
        try {
            $update = saveData("core_departamento", $dados, $id);
            if ($update['val'] == 1) {
                $msg = "Departamento atualizado com sucesso.";
                $val = 1;
            } else {
                $msg = $update['msg'];
                $val = 2;
            }

        } catch (PDOException $e) {
            $msg = $e->getMessage();
            $val = 2;
        }

        return json_encode(array("msg" => $msg, "val" => $val));
    }

    //Marcação - Tipo
    function loadTableTipo()
    {
        global $conn;
        $status = 1;
        $btn = "";
        $msg = '
            <div class="table-responsive">
                <table class="table table-hover table-compact" id="tblTipo">
                    <thead>
                        <tr>
                            <th style="width:15%">Descrição</th>
                            <th>Observações</th>
                            <th style="width:5%">Preço</th>
                            <th style="width:5%">Altura</th>
                            <th style="width:10%">Duração Salto</th>
                            <th style="width:10%">Upgrade</th>
                            <th style="width:10%">Extras</th>
                            <th style="width:12%">Disponivel Voucher</th>
                            <th style="width:12%">Disponivel Marcação</th>
                        </tr>
                    </thead>
                    <tbody>
        ';

        $msg .= '
                    </tbody>
                </table>
            </div>
        ';

        if ($_SESSION['perm']['core']['tabelasAuxiliares']['Adicionar']) {
            $btn = "<button class='btn btn-default btn-xs' onclick='drawerTipo()'>Adicionar Tipo <i class='fas fa-plus-circle'></i></button>";
        }

        return json_encode(array('msg' => $msg, 'status' => $status, 'btn' => $btn));
    }
    function addTipo($info)
    {
        global $conn;
        $dados = json_decode($info, true);
        $dados['is_active'] = 1;
        $msg = "";
        $val = 1;

        try {
            $insert = saveData("sky_tipo", $dados);
            if ($insert['val'] == 1) {
                $msg = "Tipo adicionado com sucesso.";
                $val = 1;
            } else {
                $msg = $insert['msg'];
                $val = 2;
            }

        } catch (PDOException $e) {
            $msg = $e->getMessage();
            $val = 2;
        }

        return json_encode(array("msg" => $msg, "val" => $val));
    }
    function editTipo($info)
    {
        global $conn;
        $info = json_decode($info, true);
        $status = 0;
        $msg = "";
        $id = $info['id'];
        $get = "";
        try {
            $sql = "SELECT * FROM sky_tipo WHERE id = :id";
            $stmt = $conn->prepare($sql);
            $stmt->execute([
                ':id' => $id
            ]);
            $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
            if ($rows) {
                $status = 1;
                foreach ($rows as $row) {
                    $get = $row;
                }
            } else {
                $status = 2;
            }
        } catch (PDOException $e) {
            $status = 2;
            $msg = "Error fetching data: " . $e->getMessage();
        }

        $responseLog = getLog("sky_tipo", $id);

        return json_encode(array('status' => $status, 'get' => $get, 'msg' => $msg, "responseLog" => $responseLog));
    }
    function guardarEditTipo($info)
    {
        global $conn;
        $dados = json_decode($info, true);
        $id = $dados['id'];

        $msg = "";
        $val = 1;
        try {
            $update = saveData("sky_tipo", $dados, $id);
            if ($update['val'] == 1) {
                $msg = "Tipo atualizado com sucesso.";
                $val = 1;
            } else {
                $msg = $update['msg'];
                $val = 2;
            }

        } catch (PDOException $e) {
            $msg = $e->getMessage();
            $val = 2;
        }

        return json_encode(array("msg" => $msg, "val" => $val));
    }

    //Marcação - Voucher Tema
    function loadTableVoucherTema()
    {
        global $conn;
        $status = 1;
        $btn = "";
        $msg = '
            <div class="table-responsive">
                <table class="table table-hover table-compact" id="tblVoucherTema">
                    <thead>
                        <tr>
                            <th style="width:20%">Descrição</th>
                            <th>Observações</th>
                        </tr>
                    </thead>
                    <tbody>
        ';

        $msg .= '
                    </tbody>
                </table>
            </div>
        ';

        if ($_SESSION['perm']['core']['tabelasAuxiliares']['Adicionar']) {
            $btn = "<button class='btn btn-default btn-xs' onclick='drawerVoucherTema()'>Adicionar Voucher Tema <i class='fas fa-plus-circle'></i></button>";
        }

        return json_encode(array('msg' => $msg, 'status' => $status, 'btn' => $btn));
    }
    function addVoucherTema($info)
    {
        global $conn;
        $dados = json_decode($info, true);
        $dados['is_active'] = 1;
        $msg = "";
        $val = 1;

        try {
            $insert = saveData("sky_voucher_tema", $dados);
            if ($insert['val'] == 1) {
                $msg = "Voucher Tema adicionado com sucesso.";
                $val = 1;
            } else {
                $msg = $insert['msg'];
                $val = 2;
            }

        } catch (PDOException $e) {
            $msg = $e->getMessage();
            $val = 2;
        }

        return json_encode(array("msg" => $msg, "val" => $val));
    }
    function editVoucherTema($info)
    {
        global $conn;
        $info = json_decode($info, true);
        $status = 0;
        $msg = "";
        $id = $info['id'];
        $get = "";
        try {
            $sql = "SELECT * FROM sky_voucher_tema WHERE id = :id";
            $stmt = $conn->prepare($sql);
            $stmt->execute([
                ':id' => $id
            ]);
            $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
            if ($rows) {
                $status = 1;
                foreach ($rows as $row) {
                    $get = $row;
                }
            } else {
                $status = 2;
            }
        } catch (PDOException $e) {
            $status = 2;
            $msg = "Error fetching data: " . $e->getMessage();
        }

        $responseLog = getLog("sky_voucher_tema", $id);

        return json_encode(array('status' => $status, 'get' => $get, 'msg' => $msg, "responseLog" => $responseLog));
    }
    function guardarEditVoucherTema($info)
    {
        global $conn;
        $dados = json_decode($info, true);
        $id = $dados['id'];

        $msg = "";
        $val = 1;
        try {
            $update = saveData("sky_voucher_tema", $dados, $id);
            if ($update['val'] == 1) {
                $msg = "Voucher Tema atualizado com sucesso.";
                $val = 1;
            } else {
                $msg = $update['msg'];
                $val = 2;
            }

        } catch (PDOException $e) {
            $msg = $e->getMessage();
            $val = 2;
        }

        return json_encode(array("msg" => $msg, "val" => $val));
    }

    //Marcação - Piloto
    function loadTablePiloto()
    {
        global $conn;
        $status = 1;
        $btn = "";
        $msg = '
            <div class="table-responsive">
                <table class="table table-hover table-compact" id="tblPiloto">
                    <thead>
                        <tr>
                            <th>Nome</th>
                        </tr>
                    </thead>
                    <tbody>
        ';

        $msg .= '
                    </tbody>
                </table>
            </div>
        ';

        if ($_SESSION['perm']['core']['tabelasAuxiliares']['Adicionar']) {
            $btn = "<button class='btn btn-default btn-xs' onclick='drawerPiloto()'>Adicionar Piloto <i class='fas fa-plus-circle'></i></button>";
        }

        return json_encode(array('msg' => $msg, 'status' => $status, 'btn' => $btn));
    }
    function addPiloto($info)
    {
        global $conn;
        $dados = json_decode($info, true);
        $dados['is_active'] = 1;
        $msg = "";
        $val = 1;

        try {
            $insert = saveData("sky_piloto", $dados);
            if ($insert['val'] == 1) {
                $msg = "Piloto adicionado com sucesso.";
                $val = 1;
            } else {
                $msg = $insert['msg'];
                $val = 2;
            }

        } catch (PDOException $e) {
            $msg = $e->getMessage();
            $val = 2;
        }

        return json_encode(array("msg" => $msg, "val" => $val));
    }
    function editPiloto($info)
    {
        global $conn;
        $info = json_decode($info, true);
        $status = 0;
        $msg = "";
        $id = $info['id'];
        $get = "";
        try {
            $sql = "SELECT * FROM sky_piloto WHERE id = :id";
            $stmt = $conn->prepare($sql);
            $stmt->execute([
                ':id' => $id
            ]);
            $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
            if ($rows) {
                $status = 1;
                foreach ($rows as $row) {
                    $get = $row;
                }
            } else {
                $status = 2;
            }
        } catch (PDOException $e) {
            $status = 2;
            $msg = "Error fetching data: " . $e->getMessage();
        }

        $responseLog = getLog("sky_piloto", $id);

        return json_encode(array('status' => $status, 'get' => $get, 'msg' => $msg, "responseLog" => $responseLog));
    }
    function guardarEditPiloto($info)
    {
        global $conn;
        $dados = json_decode($info, true);
        $id = $dados['id'];

        $msg = "";
        $val = 1;
        try {
            $update = saveData("sky_piloto", $dados, $id);
            if ($update['val'] == 1) {
                $msg = "Piloto atualizado com sucesso.";
                $val = 1;
            } else {
                $msg = $update['msg'];
                $val = 2;
            }

        } catch (PDOException $e) {
            $msg = $e->getMessage();
            $val = 2;
        }

        return json_encode(array("msg" => $msg, "val" => $val));
    }

    //Marcação - Avião
    function loadTableAviao()
    {
        global $conn;
        $status = 1;
        $btn = "";
        $msg = '
            <div class="table-responsive">
                <table class="table table-hover table-compact" id="tblAviao">
                    <thead>
                        <tr>
                            <th>Descrição</th>
                            <th>Nº Lugares</th>
                        </tr>
                    </thead>
                    <tbody>
        ';

        $msg .= '
                    </tbody>
                </table>
            </div>
        ';

        if ($_SESSION['perm']['core']['tabelasAuxiliares']['Adicionar']) {
            $btn = "<button class='btn btn-default btn-xs' onclick='drawerAviao()'>Adicionar avião <i class='fas fa-plus-circle'></i></button>";
        }

        return json_encode(array('msg' => $msg, 'status' => $status, 'btn' => $btn));
    }
    function addAviao($info)
    {
        global $conn;
        $dados = json_decode($info, true);
        $dados['is_active'] = 1;
        $msg = "";
        $val = 1;

        try {
            $insert = saveData("sky_aviao", $dados);
            if ($insert['val'] == 1) {
                $msg = "Avião adicionado com sucesso.";
                $val = 1;
            } else {
                $msg = $insert['msg'];
                $val = 2;
            }

        } catch (PDOException $e) {
            $msg = $e->getMessage();
            $val = 2;
        }

        return json_encode(array("msg" => $msg, "val" => $val));
    }
    function editAviao($info)
    {
        global $conn;
        $info = json_decode($info, true);
        $status = 0;
        $msg = "";
        $id = $info['id'];
        $get = "";
        try {
            $sql = "SELECT * FROM sky_aviao WHERE id = :id";
            $stmt = $conn->prepare($sql);
            $stmt->execute([
                ':id' => $id
            ]);
            $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
            if ($rows) {
                $status = 1;
                foreach ($rows as $row) {
                    $get = $row;
                }
            } else {
                $status = 2;
            }
        } catch (PDOException $e) {
            $status = 2;
            $msg = "Error fetching data: " . $e->getMessage();
        }

        $responseLog = getLog("sky_aviao", $id);

        return json_encode(array('status' => $status, 'get' => $get, 'msg' => $msg, "responseLog" => $responseLog));
    }
    function guardarEditAviao($info)
    {
        global $conn;
        $dados = json_decode($info, true);
        $id = $dados['id'];

        $msg = "";
        $val = 1;
        try {
            $update = saveData("sky_aviao", $dados, $id);
            if ($update['val'] == 1) {
                $msg = "Avião atualizado com sucesso.";
                $val = 1;
            } else {
                $msg = $update['msg'];
                $val = 2;
            }

        } catch (PDOException $e) {
            $msg = $e->getMessage();
            $val = 2;
        }

        return json_encode(array("msg" => $msg, "val" => $val));
    }

    //Marcação - Extras
    function loadTableExtra()
    {
        global $conn;
        $status = 1;
        $btn = "";
        $msg = '
            <div class="table-responsive">
                <table class="table table-hover table-compact" id="tblExtra">
                    <thead>
                        <tr>
                            <th>Descrição</th>
                            <th>Observações</th>
                            <th>Preço</th>
                        </tr>
                    </thead>
                    <tbody>
        ';

        $msg .= '
                    </tbody>
                </table>
            </div>
        ';

        if ($_SESSION['perm']['core']['tabelasAuxiliares']['Adicionar']) {
            $btn = "<button class='btn btn-default btn-xs' onclick='drawerExtra()'>Adicionar Extra <i class='fas fa-plus-circle'></i></button>";
        }

        return json_encode(array('msg' => $msg, 'status' => $status, 'btn' => $btn));
    }
    function addExtra($info)
    {
        global $conn;
        $dados = json_decode($info, true);
        $dados['is_active'] = 1;
        $msg = "";
        $val = 1;

        try {
            $insert = saveData("sky_extra", $dados);
            if ($insert['val'] == 1) {
                $msg = "Extra adicionado com sucesso.";
                $val = 1;
            } else {
                $msg = $insert['msg'];
                $val = 2;
            }

        } catch (PDOException $e) {
            $msg = $e->getMessage();
            $val = 2;
        }

        return json_encode(array("msg" => $msg, "val" => $val));
    }
    function editExtra($info)
    {
        global $conn;
        $info = json_decode($info, true);
        $status = 0;
        $msg = "";
        $id = $info['id'];
        $get = "";
        try {
            $sql = "SELECT * FROM sky_extra WHERE id = :id";
            $stmt = $conn->prepare($sql);
            $stmt->execute([
                ':id' => $id
            ]);
            $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
            if ($rows) {
                $status = 1;
                foreach ($rows as $row) {
                    $get = $row;
                }
            } else {
                $status = 2;
            }
        } catch (PDOException $e) {
            $status = 2;
            $msg = "Error fetching data: " . $e->getMessage();
        }

        $responseLog = getLog("sky_extra", $id);

        return json_encode(array('status' => $status, 'get' => $get, 'msg' => $msg, "responseLog" => $responseLog));
    }
    function guardarEditExtra($info)
    {
        global $conn;
        $dados = json_decode($info, true);
        $id = $dados['id'];

        $msg = "";
        $val = 1;
        try {
            $update = saveData("sky_extra", $dados, $id);
            if ($update['val'] == 1) {
                $msg = "Extra atualizado com sucesso.";
                $val = 1;
            } else {
                $msg = $update['msg'];
                $val = 2;
            }

        } catch (PDOException $e) {
            $msg = $e->getMessage();
            $val = 2;
        }

        return json_encode(array("msg" => $msg, "val" => $val));
    }

    //Marcação - Produto
    function drawerProduto() {
        global $conn;
        $msg = "";
        $val = 1;
        $sky_tipo = [];
        $sky_extra = [];

        try {
            // Buscar todos os sky_tipo
            $sql = "SELECT sky_tipo.id, sky_tipo.descricao FROM sky_tipo WHERE sky_tipo.is_active = 1";
            $stmt = $conn->prepare($sql);
            $stmt->execute();
            $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
            if ($rows) {
                foreach ($rows as $row) {
                    $sky_tipo[] = $row;
                }
            }
            // Buscar todos os sky_extra
            $sql = "SELECT sky_extra.id, sky_extra.descricao FROM sky_extra WHERE sky_extra.is_active = 1";
            $stmt = $conn->prepare($sql);
            $stmt->execute();
            $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
            if ($rows) {
                foreach ($rows as $row) {
                    $sky_extra[] = $row;
                }
            }
        } catch (PDOException $e) {
            $val = 2;
            $msg = "Error fetching data: " . $e->getMessage();
        }

        return json_encode(array('msg' => $msg, 'val' => $val, 'sky_tipo' => $sky_tipo, 'sky_extra' => $sky_extra));
    }
    function loadTableProduto()
    {
        global $conn;
        $status = 1;
        $btn = "";
        $msg = '
            <div class="table-responsive">
                <table class="table table-hover table-compact" id="tblProduto">
                    <thead>
                        <tr>
                            <th>Cod</th>
                            <th>Descrição</th>
                            <th>Tipo</th>
                            <th>Extra</th>
                        </tr>
                    </thead>
                    <tbody>
        ';
        $sql = "SELECT sky_produtos_fact.*, sky_tipo.descricao as id_tipo, sky_extra.descricao as id_extra
        FROM sky_produtos_fact
        LEFT JOIN sky_tipo ON sky_tipo.id = sky_produtos_fact.id_tipo
        LEFT JOIN sky_extra ON sky_extra.id = sky_produtos_fact.id_extra";
        $stmt = $conn->prepare($sql);
        $stmt->execute();
        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
        if ($rows) {
            foreach ($rows as $row) {
                $msg .= '
                <tr onclick="editProduto(' . $row["id"] . ')">
                    <td>' . $row['cod'] . '</td>
                    <td>' . $row['descricao'] . '</td>
                    <td>' . $row['id_tipo'] . '</td>
                    <td>' . $row['id_extra'] . '</td>
                </tr>
            ';
            }
        }

        $msg .= '
                    </tbody>
                </table>
            </div>
        ';

        // if ($_SESSION['perm']['core']['tabelasAuxiliares']['Adicionar']) {
        //     $btn = "<button class='btn btn-default btn-xs' onclick='drawerProduto()'>Adicionar Produto <i class='fas fa-plus-circle'></i></button>";
        // }

        return json_encode(array('msg' => $msg, 'status' => $status, 'btn' => $btn));
    }
    function addProduto($info)
    {
        global $conn;
        $dados = json_decode($info, true);
        $dados['is_active'] = 1;
        $msg = "";
        $val = 1;

        try {
            $insert = saveData("sky_produtos_fact", $dados);
            if ($insert['val'] == 1) {
                $msg = "Produto de faturação adicionado com sucesso.";
                $val = 1;
            } else {
                $msg = $insert['msg'];
                $val = 2;
            }

        } catch (PDOException $e) {
            $msg = $e->getMessage();
            $val = 2;
        }

        return json_encode(array("msg" => $msg, "val" => $val));
    }
    function editProduto($info)
    {
        global $conn;
        $info = json_decode($info, true);
        $status = 0;
        $msg = "";
        $id = $info['id'];
        $get = "";
        $sky_tipo = [];
        $sky_extra = [];
        try {
            // Buscar todos os sky_tipo
            $sql = "SELECT sky_tipo.id, sky_tipo.descricao FROM sky_tipo WHERE sky_tipo.is_active = 1";
            $stmt = $conn->prepare($sql);
            $stmt->execute();
            $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
            if ($rows) {
                foreach ($rows as $row) {
                    $sky_tipo[] = $row;
                }
            }
            // Buscar todos os sky_extra
            $sql = "SELECT sky_extra.id, sky_extra.descricao FROM sky_extra WHERE sky_extra.is_active = 1";
            $stmt = $conn->prepare($sql);
            $stmt->execute();
            $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
            if ($rows) {
                foreach ($rows as $row) {
                    $sky_extra[] = $row;
                }
            }

            $sql = "SELECT * FROM sky_produtos_fact WHERE id = :id";
            $stmt = $conn->prepare($sql);
            $stmt->execute([
                ':id' => $id
            ]);
            $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
            if ($rows) {
                $status = 1;
                foreach ($rows as $row) {
                    $get = $row;
                }
            } else {
                $status = 2;
            }
        } catch (PDOException $e) {
            $status = 2;
            $msg = "Error fetching data: " . $e->getMessage();
        }

        $responseLog = getLog("sky_extra", $id);

        return json_encode(array('status' => $status, 'get' => $get, 'msg' => $msg, "responseLog" => $responseLog, 'sky_tipo' => $sky_tipo, 'sky_extra' => $sky_extra));
    }
    function guardarEditProduto($info)
    {
        global $conn;
        $dados = json_decode($info, true);
        $id = $dados['id'];

        $msg = "";
        $val = 1;
        try {
            $update = saveData("sky_produtos_fact", $dados, $id);
            if ($update['val'] == 1) {
                $msg = "Produto de faturação atualizado com sucesso.";
                $val = 1;
            } else {
                $msg = $update['msg'];
                $val = 2;
            }

        } catch (PDOException $e) {
            $msg = $e->getMessage();
            $val = 2;
        }

        return json_encode(array("msg" => $msg, "val" => $val));
    }
}
