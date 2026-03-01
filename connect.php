<?php
include_once ('config_ok4_core.php');
if (function_exists('ok4EnsureSession')) {
	ok4EnsureSession("ok4");
} else if(!isset($_SESSION)){
	session_name("ok4");
	session_start();
}

// Incluir as funções de logs
require './php/logs.php';

// Incluir as funções gets
require './php/gets.php';

// Incluir as funções gerais de saves e upates
require './php/dataadd.php';

// Incluir as funções globais
require './php/global.php';

// && $contentheaders == '7215ee9c7d9dc229d2921a40e899ec5f'
if(!isset($_SESSION['user']) && !in_array(($_POST['function'] ?? ""), ["runheaders","login"])){
	// echo var_dump($_SESSION);
	// echo var_dump($_POST);
    // header_remove("Location");
    // $actual_link = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https" : "http") . "://$_SERVER[HTTP_HOST]";
    // $actual_link =  explode("connect",$actual_link.$_SERVER['PHP_SELF'])[0];
    // header("Location: ".$actual_link."/js/break.js?v=2");
    // exit;
}
function hexToRgb($hex, $alpha = false) {
	$hex      = str_replace('#', '', $hex);
	$length   = strlen($hex);
	$rgb['r'] = hexdec($length == 6 ? substr($hex, 0, 2) : ($length == 3 ? str_repeat(substr($hex, 0, 1), 2) : 0));
	$rgb['g'] = hexdec($length == 6 ? substr($hex, 2, 2) : ($length == 3 ? str_repeat(substr($hex, 1, 1), 2) : 0));
	$rgb['b'] = hexdec($length == 6 ? substr($hex, 4, 2) : ($length == 3 ? str_repeat(substr($hex, 2, 1), 2) : 0));
	if ( $alpha ) {
	   $rgb['a'] = $alpha;
	}
	return $rgb;
}
function pars($info){
	$postFunction = isset($_POST['function']) ? (string)$_POST['function'] : "";

	// uploadFiles foi removido da exceção para garantir que segue o mesmo controlo
	// de sessão e autorização das restantes operações.
	if((isset($_SESSION['fix']) && $_SESSION['fix'] == 1) && !in_array($postFunction, ["login","regOverall","logout","loadManifestoEcra"])){
		//echo "entra 1 -> ".$_POST['function'];
		return $info;
	}else if(in_array($postFunction, ["loadManifestoEcra"])){
 		//echo "entra 1 -> ".$_POST['function'];
		return $info;
	// Lista de funções públicas que continuam com token de bootstrap.
	}else if(in_array($postFunction, ["runheaders","login","logout","regOverall"])){
		//echo "entra 2 -> ".$_POST['function'];
		$info = json_decode($info,true);
		$demo_header = '{"typ": "JWT","alg": "HS256"}';
		$extratxt = strrev(md5(' '));
		//base64_decode(strrev($opcoes[2])
		$demo_payload = json_encode($info);
		$base64Header = base64_encode($demo_header);
		$base64Payload = base64_encode($demo_payload);
		$signature = hash_hmac("sha256",$base64Header . "." .$base64Payload,$extratxt, false);
		$base64sign = base64_encode($signature);
		$jwt = str_replace("=","",strrev($base64Header)) . ".".str_replace("=","",strrev($base64sign)) . "." . str_replace("=","",strrev($base64Payload));
		return json_encode(array("package"=>$jwt));
	}else{
		//echo "entra 3 -> ".$_POST['function'];
		$info = json_decode($info,true);
		$demo_header = '{"typ": "JWT","alg": "HS256"}';
		$filejson = json_decode(file_get_contents("uploads/utilizadores/userlog".$_SESSION['login']."/noti.json"),true);
		$extratxt = strrev($filejson['timer']);
		//base64_decode(strrev($opcoes[2])
		$demo_payload = json_encode($info);
		$base64Header = base64_encode($demo_header);
		$base64Payload = base64_encode($demo_payload);
		$signature = hash_hmac("sha256",$base64Header . "." .$base64Payload,$extratxt, false);
		$base64sign = base64_encode($signature);
		$jwt = str_replace("=","",strrev($base64Header)) . ".".str_replace("=","",strrev($base64sign)) . "." . str_replace("=","",strrev($base64Payload));
		return json_encode(array("package"=>$jwt));
 	}
}
if (!defined('OK4_CONNECT_NO_DISPATCH') || OK4_CONNECT_NO_DISPATCH !== true) {
	$origin = isset($_POST['origin']) ? $_POST['origin'] : "";
	$function = isset($_POST['function']) ? (string)$_POST['function'] : "";
	$attr = isset($_POST['attr']) ? $_POST['attr'] : "";

	if ($origin === "" || $function === "") {
		echo json_encode(array("package" => "", "msg" => "Pedido inválido."));
		exit;
	}

	require_once $origin;
	$current_origin = explode("/", $origin);
	$current_origin = end($current_origin);
	$current_origin = ucfirst(str_replace(".php", "", $current_origin));
	$info = new $current_origin();
	$return = $info->$function($attr);
	echo pars($return);
}
