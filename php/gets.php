<?php
function core_departamento($id = 0, $flag = false)
{
    global $conn;

    $sql = "SELECT core_departamento.*
            FROM core_departamento" . ($id != 0 ? " WHERE core_departamento.id = :id" : "");

    $stmt = $conn->prepare($sql);
    $stmt->execute($id != 0 ? [':id' => $id] : []);
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

    return $rows;
}

function core_funcao($id = 0, $flag = false)
{
    global $conn;
    $sql = "";
    // Select normal
    if (!$flag) {
        $sql = "SELECT core_funcao.*
        FROM core_funcao" . ($id != 0 ? " WHERE core_funcao.id = :id" : "");
    }
    // Select para logs
    else {
        $sql = "SELECT core_funcao.*, core_departamento.descricao as id_depart
        FROM core_funcao
        INNER JOIN core_departamento ON core_departamento.id = core_funcao.id_depart
        " . ($id != 0 ? " WHERE core_funcao.id = :id" : "").";";
    }
    $stmt = $conn->prepare($sql);
    $stmt->execute($id != 0 ? [':id' => $id] : []);
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

    return $rows;
}

function core_login($id = 0, $flag = false)
{
    global $conn;
    $sql = "";
    // Select normal
    if (!$flag) {
        $sql = "SELECT core_login.*
        FROM core_login" . ($id != 0 ? " WHERE core_login.id = :id" : "");
    }
    // Select para logs
    else {
        $sql = "SELECT core_login.*, core_tipologin.descricao as id_tipo, core_idioma.descricao as id_lang
        FROM core_login
        INNER JOIN core_tipologin ON core_tipologin.id = core_login.id_tipo
        INNER JOIN core_idioma ON core_idioma.id = core_login.id_lang
        WHERE core_login.id = :id";
    }
    $stmt = $conn->prepare($sql);
    $stmt->execute($id != 0 ? [':id' => $id] : []);
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

    return $rows;
}

function core_tipouser($id = 0, $flag = false)
{
    global $conn;
    $sql = "";
    // Select normal
    $sql = "SELECT core_tipouser.*
            FROM core_tipouser" . ($id != 0 ? " WHERE core_tipouser.id = :id" : "");

    $stmt = $conn->prepare($sql);
    $stmt->execute($id != 0 ? [':id' => $id] : []);
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

    return $rows;
}

function core_user($id = 0, $flag = false)
{
    global $conn;
    $sql = "";
    // Select normal
    if (!$flag) {
        $sql = "SELECT core_user.*
        FROM core_user " . ($id != 0 ? " WHERE core_user.id = :id" : "");
    }
    // Select para logs
    else {
        $sql = "SELECT core_user.*, core_tipouser.descricao as id_tipouser, core_tipocont.descricao as id_tipocont, core_funcao.descricao as id_funcao, core_user_hl.descricao as id_hl, core_user_sexo.descricao as id_sexo
                FROM core_user
                INNER JOIN core_tipouser ON core_tipouser.id = core_user.id_tipouser
                INNER JOIN core_tipocont ON core_tipocont.id = core_user.id_tipocont
                INNER JOIN core_funcao ON core_funcao.id = core_user.id_funcao
                INNER JOIN core_user_hl ON core_user_hl.id = core_user.id_hl
                INNER JOIN core_user_sexo ON core_user_sexo.id = core_user.id_sexo
                WHERE core_user.id = :id";
    }
    $stmt = $conn->prepare($sql);
    $stmt->execute($id != 0 ? [':id' => $id] : []);
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

    return $rows;
}

function session_messages($id = 0, $flag = false)
{
    global $conn;
    $sql = "";
    // Select normal
    $sql = "SELECT session_messages.*
            FROM session_messages" . ($id != 0 ? " WHERE session_messages.id = :id" : "");

    $stmt = $conn->prepare($sql);
    $stmt->execute($id != 0 ? [':id' => $id] : []);
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

    return $rows;
}

function session_messages_users($id = 0, $flag = false)
{
    global $conn;
    $sql = "";
    // Select normal
    $sql = "SELECT session_messages_users.*
            FROM session_messages_users" . ($id != 0 ? " WHERE session_messages_users.id = :id" : "");

    $stmt = $conn->prepare($sql);
    $stmt->execute($id != 0 ? [':id' => $id] : []);
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

    return $rows;
}
