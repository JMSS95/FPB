<?php
ini_set('session.gc_maxlifetime', 3600);

$dsn = 'mysql:host=localhost;dbname=ok4_base';
$username = 'root';
$password = '';

$dsn_logs = 'mysql:host=localhost;dbname=ok4_base_logs';

require_once __DIR__."/php/auth_common.php";

// Base de dados normal
try {
	$conn = new PDO($dsn, $username, $password);
	$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

	date_default_timezone_set("Europe/Lisbon");
	// $conn->exec('SET NAMES utf8');
	$conn->exec("SET NAMES utf8mb4");
} catch (PDOException $e) {
	echo 'Error connecting to database: ' . $e->getMessage();
	exit;
}

// Base de dados logs
try {
	$conn_logs = new PDO($dsn_logs, $username, $password);
	$conn_logs->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

	date_default_timezone_set("Europe/Lisbon");
	$conn_logs->exec('SET NAMES utf8');
} catch (PDOException $e) {
	echo 'Error connecting to database: ' . $e->getMessage();
	exit;
}

if ($_POST) {
	ok4EnsureSession("ok4");

	if (!function_exists('getAuthorizationHeader')) {
		function getAuthorizationHeader()
		{
			return ok4GetAuthorizationHeader();
		}
	}

	if (!function_exists('getBearerToken')) {
		function getBearerToken()
		{
			return ok4GetBearerToken();
		}
	}

	$contentheaders = getBearerToken();

	if (!is_null($contentheaders)) {
		$token = ok4ResolveExpectedToken($contentheaders, __DIR__);

		// if($contentheaders != '7215ee9c7d9dc229d2921a40e899ec5f'){
		// 	echo $contentheaders." -> ".md5('"'.$token.'"')." -> ".$token;
		// }

		if (strpos($contentheaders, $token) !== false) {
			// if($contentheaders != '7215ee9c7d9dc229d2921a40e899ec5f'){
			// 	echo "fix -> ".$_SESSION['fix'];
			// }
			if (isset($_SESSION['fix']) && $_SESSION['fix'] == 1 && $contentheaders != '7215ee9c7d9dc229d2921a40e899ec5f') {
				if (isset($_POST['package'])) {
					// Caso os dados sejam enviados no formato original (com 'package')
					$opcoes = $_POST['package'];
					$_POST = json_decode($_POST['package'], true);
				} else {
					// Caso os dados sejam enviados com FormData
					$origin = $_POST['origin'];
					$function = (string)$_POST['function'];
					$attr = json_decode($_POST['attr'], true); // Decodifica o JSON de 'attr'
				}
			} else {
				if (isset($_POST['package']) && strpos($_POST['package'], '.') !== false) {
					// Continua a lógica de quando o pacote é enviado com base64 e strrev
					$opcoes = explode(".", $_POST['package']);
					if (!is_null(json_decode(base64_decode(strrev($opcoes[2])), true))) {
						$_POST = json_decode(base64_decode(strrev($opcoes[2])), true);
					} else {
						$_POST = json_decode(base64_decode(($opcoes[1])), true);
					}
				} else {
					// Processamento quando os dados são enviados via FormData
					$origin = $_POST['origin'];
					$function = (string)$_POST['function'];
					$attr = json_decode($_POST['attr'], true); // Decodifica o JSON de 'attr'
				}
			}
		} else {
			session_unset();
			session_destroy();
			header_remove("Location");
			$actual_link = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https" : "http") . "://$_SERVER[HTTP_HOST]";
			$actual_link =  explode("connect", $actual_link . $_SERVER['PHP_SELF'])[0];
			header("Location: " . $actual_link . "/js/break.js?v=1");
			exit;
		}
	}
}

function sendMailOk4($titulo, $assunto, $msg, $listaDestinatarios, $anexo = [])
{
	$actual_link = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https" : "http") . "://$_SERVER[HTTP_HOST]";
	$body = "";
	$cump = "Continuação de um bom trabalho!";
	$body = "<p style='text-align:justify'>" . $msg . "<br><br></p>";
	$mensagem = '<!DOCTYPE html>
			<html lang="en" xmlns="http://www.w3.org/1999/xhtml" xmlns:o="urn:schemas-microsoft-com:office:office">
			<head>
			<meta charset="utf-8">
			  <meta name="viewport" content="width=device-width,initial-scale=1">
			  <meta name="x-apple-disable-message-reformatting">
			  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
			  <title></title>
			  <style type="text/css">
				@media screen and (max-width: 350px) {
				  .three-col .column {
					max-width: 100% !important;
				  }
				}
				@media screen and (min-width: 351px) and (max-width: 460px) {
				  .three-col .column {
					max-width: 50% !important;
				  }
				}
				@media screen and (max-width: 460px) {
				  .two-col .column {
					max-width: 100% !important;
				  }
				  .two-col img {
					width: 100% !important;
				  }
				}
				@media screen and (min-width: 461px) {
				  .three-col .column {
					max-width: 33.3% !important;
				  }
				  .two-col .column {
					max-width: 50% !important;
				  }
				  .sidebar .small {
					max-width: 16% !important;
				  }
				  .sidebar .large {
					max-width: 84% !important;
				  }
				}
			  </style>
			</head>
			<body style="margin:0;padding:0;word-spacing:normal;background-color:#ffffff;">
			  <div role="article" aria-roledescription="email" lang="en" style="-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#ffffff;">
				<table role="presentation" style="width:100%;border:0;border-spacing:0;">
				  <tr>
					<td align="center">
					  <div class="outer" style="width:96%;max-width:660px;margin:20px auto;">

						<table role="presentation" style="width:100%;border:0;border-spacing:0;">
						  <tr>
							<td style="padding:0px;font-family:Arial, sans-serif;font-size:20px;line-height:20px;font-weight:bold;background-color: #0c88e2;">
								<center>
							  		<img src="https://www.alentapp.pt/ok4alentapp/img/bannernotificacao_clean_skydive.jpg" width="500" alt="" style="width:100%;height:auto;" />
							  	</center>
							</td>
						  </tr>
						  <tr>
							<td style="padding:10px;text-align:left;">
							  <h6 style="margin-top:20px;margin-bottom:16px;font-family:Arial, sans-serif;font-size:14px;line-height:10px; color: black; opacity:0.8; margin-left: 20px;">Skydive Portugal</h6>
							  <h1 style="margin-top:0;margin-bottom:16px;font-family:Arial, sans-serif;font-size:24px;line-height:32px;color: #eea47f; margin-left: 20px;margin-right: 20px;">Parabéns! Acabou de receber o seu Voucher!</h1>
							  <p style="margin:0;font-family:Arial, sans-serif;font-size:16px;line-height:22px;color: #0057a3; margin-left: 20px;">' . $titulo . ' </p>
							</td>
						  </tr>
						  <tr>
							<td style="padding:10px;text-align:left;">
							  <h6 style="margin-top:0px;margin-bottom:16px;font-family:Arial, sans-serif;font-size:14px;line-height:10px; color: black; opacity:0.8; margin-left: 20px;">MENSAGEM:</h6>
							  <div style="margin-top:0;margin-bottom:14px;margin-left: 40px; margin-right: 40px; font-family:Arial, sans-serif;text-align: justify;line-height:28px; opacity: 0.8;color:black !important;">' . $msg . '</div>
							  <p style="margin-top:0;margin-bottom:14px;margin-left: 40px; margin-right: 40px; font-family:Arial, sans-serif;text-align: justify;line-height:20px; font-size: 12px; opacity: 0.8;color:black !important;">
								<b>Nota: </b>Esta comunicação foi realizada através de envio de email automático por parte do sistema de informação. Este email foi enviado de um endereço apenas de envio e não consegue receber qualquer comunicação. Caso possua alguma dúvida ou necessidade de esclarecimento adicional,  <a href="https://skydiveportugal.pt/contactos/">carregue aqui</a>. <!-- Se não desejar receber mais notificações, desactive as mesmas através da gestão do seu perfil -->
							  </p>
		                  	<br><p style="text-align:center;font-family:Arial, sans-serif;line-height:20px; font-size: 12px; opacity: 0.8;color:black !important;">Obrigada por escolher a Skydive Portugal!</p>
		                  	<center>
		                    <img src="https://skydiveportugal.pt/wp-content/uploads/2021/11/logo-skydive-site-pequeno-min.png" width="100" alt="" style="width:20%;height:auto;" />
		                  </center>
							</td>
						  </tr>
						</table>
						<div class="spacer" style="line-height:10px;height:10px;mso-line-height-rule:exactly;">&nbsp;</div>

						<div class="sidebar" style="text-align:center;direction:rtl;background-color: #0c88e2; ">
						  <div class="large" style="width:100%;max-width:560px;height: 65px; display:inline-block;vertical-align:middle;direction:ltr;">
							<div style="font-size:14px;">
							  <br><p style="margin:0;font-family:Arial, sans-serif;color:white; font-size:14px"><b>Skydive Portugal ®</b></p>
							  <p style="margin:0;font-family:Arial, sans-serif;color:white; font-size:10px;margin-top:5px;">powered by: AlentApp, LDA. | Todos os direitos reservados © ' . date("Y") . '<br></p>
							  <br>
							</div>
						  </div>
						</div>
						<div class="spacer" style="line-height:40px;height:40px;mso-line-height-rule:exactly;">&nbsp;</div>
					  </div>
					</td>
				  </tr>
				</table>
			  </div>
			</body>
		</html>';
	$body_message = $mensagem . "\n";
	date_default_timezone_set('Etc/UTC');
	require 'assets/plugins/phpmailer/PHPMailerAutoload.php';
	$mail = new PHPMailer;
	$mail->isSMTP();
	$mail->SMTPDebug = 0;
	$mail->Debugoutput = 'html';
	$mail->SMTPDebug = 0;
	//Ask for HTML-friendly debug output
	$mail->Debugoutput = 'html';
	//Set the hostname of the mail server
	$mail->Host = "smtp.alentapp.pt";
	//Set the SMTP port number - likely to be 25, 465 or 587
	$mail->Port = 25;
	//Whether to use SMTP authentication
	$mail->SMTPAuth = true;
	$mail->SMTPSecure = 'tls';
	//Username to use for SMTP authentication
	$mail->Username = "";
	//Password to use for SMTP authentication
	$mail->Password = "";

	$mail->SMTPOptions = array(
		'ssl' => array(
			'verify_peer' => false,
			'verify_peer_name' => false,
			'allow_self_signed' => true
		)
	);
	$mail->CharSet = 'UTF-8';
	//Set who the message is to be sent from
	$mail->addReplyTo('info@alentapp.pt', 'Base OK4');
	$mail->setFrom('support@alentapp.pt', 'Base OK4');

	foreach ($listaDestinatarios as $email => $nome) {
		$mail->addAddress($email, $nome);
	}

	if (count($anexo) > 0) {
		for($a = 0;$a < count($anexo);$a++){
			$mail->addAttachment($anexo[$a]);
		}
	}

	$mail->Subject = $assunto;
	$mail->msgHTML($body_message);
	//$resposta = array("mail"=>$mail,"anexo"=>$anexo);
	if (!$mail->send()) {
		$resposta = array("val" => 2, "msg" => "Erro no envio de email. Por favor tente mais tarde.<br>" . $mail->ErrorInfo);
	} else {
		$resposta = array("val" => 1, "msg" => "Notificação enviada com sucesso.");
	}
	return $resposta;
}
