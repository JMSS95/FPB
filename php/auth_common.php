<?php

if (!function_exists('ok4EnsureSession')) {

	function ok4EnsureSession($sessionName = 'ok4')
	{
		if (session_status() === PHP_SESSION_ACTIVE) {
			return;
		}

		session_name($sessionName);
		session_start();
	}
}

if (!function_exists('ok4GetAuthorizationHeader')) {

	function ok4GetAuthorizationHeader()
	{
		$headers = null;
		if (isset($_SERVER['Authorization'])) {
			$headers = trim($_SERVER['Authorization']);
		} else if (isset($_SERVER['HTTP_AUTHORIZATION'])) {
			$headers = trim($_SERVER['HTTP_AUTHORIZATION']);
		} else if (function_exists('apache_request_headers')) {
			$requestHeaders = apache_request_headers();
			$requestHeaders = array_combine(array_map('ucwords', array_keys($requestHeaders)), array_values($requestHeaders));
			if (isset($requestHeaders['Authorization'])) {
				$headers = trim($requestHeaders['Authorization']);
			}
		}

		return $headers;
	}
}

if (!function_exists('ok4GetBearerToken')) {
	/**
	 * Extrai o token Bearer do header Authorization.
	 *
	 * Retorna apenas o token (sem o prefixo "Bearer ") ou null
	 * quando o header não existe ou está inválido.
	 */
	function ok4GetBearerToken()
	{
		$headers = ok4GetAuthorizationHeader();
		if (!empty($headers) && preg_match('/Bearer\s(\S+)/', $headers, $matches)) {
			return $matches[1];
		}

		return null;
	}
}

if (!function_exists('ok4ResolveExpectedToken')) {
	/**
	 * Resolve o token esperado para validar o pedido autenticado.
	 *
	 * Prioridade:
	 * 1) $_SESSION['timer_rev']
	 * 2) token em uploads/utilizadores/userlog{login}/noti.json
	 * 3) fallback md5(' ')
	 */
	function ok4ResolveExpectedToken($contentheaders, $basePath)
	{
		$token = md5(' ');

		if (isset($_SESSION['timer_rev']) && $_SESSION['timer_rev'] != '') {
			$token = $_SESSION['timer_rev'];
		} else if (isset($_SESSION['login']) && $_SESSION['login'] != '') {
			$userLogPath = rtrim($basePath, '/\\')."/uploads/utilizadores/userlog".$_SESSION['login']."/noti.json";
			if (file_exists($userLogPath)) {
				$filejson = json_decode(file_get_contents($userLogPath), true);
				if (is_array($filejson) && isset($filejson['token'])) {
					$token = ($filejson['token'] == '' ? $contentheaders : md5('"'.$filejson['token'].'"'));
				}
			}
		}

		return $token;
	}
}
