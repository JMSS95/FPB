<?php
$GLOBALS['ex'] = 0;
class Checkdb
{
	function runheaders()
	{
		global $conn;
		$arr = [];

		try {
			$sql = "SELECT * FROM core_empresa";
			$stmt = $conn->prepare($sql);
			$stmt->execute();
			$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
			if ($rows) {
				foreach ($rows as $row) {
					$arr = [
						"logo" => $row['logo'],
						"nome" => $row['nome'],
						"expire" => $row['actcod'],
						"icon" => $row['icon'],
					];
				}
			}
		} catch (PDOException $e) {
			echo "Error fetching data: " . $e->getMessage();
		}

		// Return JSON encoded data
		return json_encode($arr);
	}

	function login($info)
	{
		global $conn;
		$info = json_decode($info, true);
		$val = 0;
		$_SESSION['login'] = "";
		$_SESSION['user'] = "";
		$_SESSION['tipo'] = "";
		$_SESSION['email'] = "";
		$_SESSION['nome'] = "";
		$_SESSION['empresa'] = "";
		$_SESSION['expire'] = "";
		$_SESSION['perm'] = [];
		$_SESSION['comp'] = [];
		$_SESSION['tipoesp'] = "";
		$_SESSION['id_depart'] = "";
		$_SESSION['logo'] = "";
		$_SESSION['serial'] = "";
		$_SESSION['main'] = "";
		$_SESSION['menu'] = [];
		$_SESSION['last'] = time();
		$_SESSION['lang'] = "pt";
		$_SESSION['timer'] = "";
		$_SESSION['fix'] = 1;
		$_SESSION['img'] = "assets/img/user/user.png";
		$_SESSION['verizon_token'] = "";
		$_SESSION['verizon_token_expire'] = "";
		try {
			$sql1 = "SELECT core_empresa.* FROM core_empresa";
			$stmt = $conn->prepare($sql1);
			$stmt->execute();
			$row1 = $stmt->fetchAll(PDO::FETCH_ASSOC);
			if ($row1) {
				foreach ($row1 as $row) {
					$arr = [
						$_SESSION['expire'] = $row['actcod'],
						$_SESSION['empresa'] = $row['nome'],
						$_SESSION['logo'] = $row['logo'],
						$_SESSION['serial'] = $row['serial'],
					];
				}
			}
		} catch (PDOException $e) {
			echo "Error fetching data: " . $e->getMessage();
		}

		$arr = [];
		$perm = [];
		$sub = [];
		$page = [];
		$comp = [];
		$user = $info['user'];
		$pass = $info['pass'];
		$msg = "";
		$link = "";
		$main = "";
		$checkassi = 0;
		try {
			$sql = "SELECT * FROM core_login WHERE MD5(username) = :username AND pass = :pass AND core_login.is_active!=0";
			$stmt = $conn->prepare($sql);
			$stmt->execute([
				':username' => md5($user),
				':pass' => $pass,
			]);
			$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
			if ($rows) {
				foreach ($rows as $row) {
					if ($row['pass'] == $pass) {
						try {
							$sql99 = "SELECT acro FROM core_idioma WHERE id=:id_lang";
							$stmt = $conn->prepare($sql99);
							$stmt->execute([
								':id_lang' => $row['id_lang']
							]);
							$rows2 = $stmt->fetchAll(PDO::FETCH_ASSOC);
							if ($rows2) {
								foreach ($rows2 as $row2) {
									$_SESSION['lang'] = $row2['acro'];
								}
							}
						} catch (PDOException $e) {
							echo "Error fetching data: " . $e->getMessage();
						}

						if ($row['id_tipo'] == 1) {
							try {
								$sql1 = "SELECT * FROM core_user WHERE id=:id_user";
								$stmt = $conn->prepare($sql1);
								$stmt->execute([
									':id_user' => $row['id_user']
								]);
								$rows3 = $stmt->fetchAll(PDO::FETCH_ASSOC);

								if ($rows3) {
									foreach ($rows3 as $row3) {
										if (in_array($row['id_user'], [1])) {
											$_SESSION['fix'] = 1;
										}
										$_SESSION['login'] = $row['id'];
										$_SESSION['user'] = $row3['id'];
										$_SESSION['tipo'] = $row3['id_tipouser'];
										$_SESSION['tipoesp'] = $row['id_tipo'];
										$_SESSION['email'] = $row3['email'];
										$_SESSION['nome'] = $row3['nome'];
										$_SESSION['id_departamento'] = $row3['id_departamento'];
										if (!is_null($row3['img']) && trim((string)$row3['img']) !== "") {
											$userImg = str_replace("\\", "/", trim((string)$row3['img']));
											if (strpos($userImg, "/") === false) {
												$userImg = "assets/img/user/".$userImg;
											}
											if (!file_exists(dirname(__DIR__)."/".$userImg)) {
												$userImg = "assets/img/user/user.png";
											}
											$_SESSION['img'] = $userImg;
										}
										$_SESSION['main'] = "module/core/dashboard.html";
										$msg = "Login Efectuado com Sucesso.\nBem-vindo " . $row3['nome'];

										$val = 1;
										$arr = [];
										try {
											$sql2 = "SELECT id FROM core_notification WHERE id_sent=:id_sent AND is_active=1";
											$stmt = $conn->prepare($sql2);
											$stmt->execute([
												':id_sent' => $row['id']
											]);
											$rows4 = $stmt->fetchAll(PDO::FETCH_ASSOC);
											if ($rows4) {
												foreach ($rows4 as $row4) {
													$arr[count($arr)] = $row4['id'];
												}
											}
										} catch (PDOException $e) {
											echo "Error fetching data: " . $e->getMessage();
										}

										// Carregar perms
										try {
											$sql5 = "SELECT core_module.cod AS module, core_tipopermissao.cod AS perm, core_permissao.descricao, CASE WHEN core_rel_tipouser_permissao.id IS NOT NULL THEN TRUE ELSE FALSE END AS permissao
											FROM core_permissao
											LEFT JOIN core_tipopermissao ON core_permissao.id_tipo=core_tipopermissao.id
											LEFT JOIN core_module ON core_tipopermissao.id_module=core_module.id
											LEFT JOIN core_rel_tipouser_permissao ON core_permissao.id=core_rel_tipouser_permissao.id_perm
											AND core_tipopermissao.is_active = 1
											AND core_module.is_active = 1
											AND core_rel_tipouser_permissao.id_tipo = :id_tipo
											ORDER BY core_permissao.id ASC";
											$stmt5 = $conn->prepare($sql5);
											$stmt5->execute([
												":id_tipo" => $row3['id_tipouser']
											]);
											$row5 = $stmt5->fetchAll(PDO::FETCH_ASSOC);
											if ($row5) {
												foreach ($row5 as $row5) {
													if(array_key_exists($row5['module'],$perm)) {
														if(array_key_exists($row5['perm'],$perm[$row5['module']])) {
															$perm[$row5['module']][$row5['perm']][$row5['descricao']] = $row5['permissao'];
														}else{
															$perm[$row5['module']][$row5['perm']] = null;
															$perm[$row5['module']][$row5['perm']][$row5['descricao']] = $row5['permissao'];
														}
													}else{
														$perm[$row5['module']] = null;
														$perm[$row5['module']][$row5['perm']] = null;
														$perm[$row5['module']][$row5['perm']][$row5['descricao']] = $row5['permissao'];
													}
												}
											}
										} catch (PDOException $e) {
											echo "Error fetching data: " . $e->getMessage();
										}

										$_SESSION['perm'] = $perm;
										$_SESSION['comp'] = $comp;

										$menu = [];
										// Carregar menu
										try {
											$sql6 = "SELECT core_module.id as id_module, core_module.descricao AS descricao_module, core_module.icon as icon_module, core_tipopermissao.id as id_tipopermissao, core_tipopermissao.url, core_tipopermissao.descricao, core_tipopermissao.icon, core_tipopermissao.sub, core_tipopermissao.page
											FROM core_permissao,core_tipopermissao,core_module, core_rel_tipouser_permissao
											WHERE core_permissao.id_tipo=core_tipopermissao.id
											AND core_rel_tipouser_permissao.id_perm = core_permissao.id
											AND core_tipopermissao.id_module=core_module.id
											AND core_tipopermissao.is_active = 1
											AND core_module.is_active= 1
											AND core_rel_tipouser_permissao.id_tipo = :id_tipo
											AND core_permissao.descricao = 'Ver'
											ORDER BY core_tipopermissao.sub ASC, core_tipopermissao.page ASC";
											$stmt6 = $conn->prepare($sql6);
											$stmt6->execute([
												":id_tipo" => $row3['id_tipouser']
											]);
											$row6 = $stmt6->fetchAll(PDO::FETCH_ASSOC);
											if ($row6) {
												foreach ($row6 as $row6) {
													$menu[] = array("id_module" => $row6['id_module'], "descricao_module" => $row6['descricao_module'], "icon_module" => $row6['icon_module'], "id_tipopermissao" => $row6['id_tipopermissao'], "url" => $row6['url'], "descricao" => $row6['descricao'], "icon" => $row6['icon'], "sub" => $row6['sub'], "page" => $row6['page']);
												}
											}
										} catch (PDOException $e) {
											echo "Error fetching data: " . $e->getMessage();
										}
										$_SESSION['menu'] = $menu;
									}
								}
							} catch (PDOException $e) {
								echo "Error fetching data: " . $e->getMessage();
							}
						}

						$pathname = "uploads/utilizadores/userlog" . $row['id'];
						if (!file_exists($pathname)) {
							mkdir($pathname, 0777, true);
						}
						$_SESSION['timer'] = md5($_SESSION['login'] . "a" . $_SESSION['user'] . "c" . $_SESSION['tipo'] . "b" . strtotime(date("Y-m-d H:i:s")));
						$filejson = array("token" => "", "timer" => md5($_SESSION['login'] . "a" . $_SESSION['user'] . "c" . $_SESSION['tipo'] . "b" . strtotime(date("Y-m-d H:i:s"))), "noti" => $arr, "fix" => $_SESSION['fix']);
						file_put_contents("uploads/utilizadores/userlog" . $row['id'] . "/noti.json", json_encode($filejson));
						//chmod("uploads/utilizadores/userlog".$row['id']."/noti.json",0755);
					} else {
						$_SESSION['user'] = "";
						$_SESSION['tipo'] = "";
						$_SESSION['nome'] = "";
						$_SESSION['email'] = "";
						$_SESSION['main'] = "";
						$_SESSION['menu'] = "";
						$msg = "Password ou Nome de Utilizador Errados.";
						$val = 2;
					}
				}
			} else {
				$_SESSION['user'] = "";
				$_SESSION['tipo'] = "";
				$_SESSION['nome'] = "";
				$_SESSION['email'] = "";
				$_SESSION['main'] = "";
				$_SESSION['menu'] = "";
				$msg = "Password ou Nome de Utilizador Errados.";
				$val = 2;
			}
		} catch (PDOException $e) {
			echo "Error fetching data: " . $e->getMessage();
		}
		return json_encode(array("msg" => $msg, "val" => $val, "email" => $_SESSION['email'], "empresa" => $_SESSION['empresa'], "img" => $_SESSION['img'], "last" => $_SESSION['last'], "main" => $_SESSION['main'], "login" => $_SESSION['login'], "logo" => $_SESSION['logo'], "menu" => $_SESSION['menu'], "nome" => $_SESSION['nome'], "perm" => $_SESSION['perm'], "timer" => strrev($_SESSION['timer']), "tipoesp" => $_SESSION['tipoesp'], "tipo" => $_SESSION['tipo'], "user" => $_SESSION['user'], "lang" => $_SESSION['lang'], "serial" => $_SESSION['serial'], "comp" => $_SESSION['comp'], "checkassi" => $checkassi, "fix" => $_SESSION['fix']));
	}


	function regOverall($info)
	{
		$info = json_decode($info, true);
		$token = $info['sessionObject'];
		$val = 0;
		$filejson = json_decode(file_get_contents("uploads/utilizadores/userlog" . $_SESSION['login'] . "/noti.json"), true);
		$filejson['token'] = $token;
		$_SESSION['timer_rev'] = md5('"' . $token . '"');
		$msg = file_put_contents("uploads/utilizadores/userlog" . $_SESSION['login'] . "/noti.json", json_encode($filejson));
		if ($msg) {
			$val = 1;
		}
		return json_encode(array("val" => $val));
	}

	function logout($info)
	{
		$msg = "";
		$val = 0;
		session_unset();
		session_destroy();
		if (!isset($_SESSION['user'])) {
			$val = 1;
			$msg = "Sessão terminada com sucesso.";
		} else {
			$val = 2;
			$msg = "Não foi possivel terminar esta sessão.";
		}
		return json_encode(array("msg" => $msg, "val" => $val));
	}

	function runcheck($info)
	{
		$info = json_decode($info, true);
		$session = $info['session'];
		$val = 0;
		$current = time();
		$assi = 0;
		$pausas = 0;
		$inicio = 0;
		$currentplusone = strtotime(date('Y-m-d H:i:s', strtotime(date("Y-m-d H:i:s") . ' +1 hour')));
		//if (isset($session['last']) && $session['last'] <= $currentplusone && !is_null($session['email'])) {
			$_SESSION['comp'] = $session['comp'];
			$_SESSION['email'] = $session['email'];
			$_SESSION['empresa'] = $session['empresa'];
			$sessionImg = isset($session['img']) ? str_replace("\\", "/", trim((string)$session['img'])) : "";
			if ($sessionImg === "") {
				$sessionImg = "assets/img/user/user.png";
			} else if (strpos($sessionImg, "/") === false) {
				$sessionImg = "assets/img/user/".$sessionImg;
			}
			if (!file_exists(dirname(__DIR__)."/".$sessionImg)) {
				$sessionImg = "assets/img/user/user.png";
			}
			$_SESSION['img'] = $sessionImg;
			$_SESSION['last'] = $current;
			$_SESSION['login'] = $session['login'];
			$_SESSION['logo'] = $session['logo'];
			$_SESSION['menu'] = $session['menu'];
			$_SESSION['nome'] = $session['nomeutilizador'];
			$_SESSION['perm'] = $session['perm'];
			$_SESSION['expire'] = $session['timer'];
			$_SESSION['timer'] = $session['timer'];
			$_SESSION['tipoesp'] = $session['tipoesp'];
			$_SESSION['tipo'] = $session['tipoutilizador'];
			$_SESSION['user'] = $session['utilizador'];
			$_SESSION['lang'] = $session['lang'];

			$val = 1;
		// } else {
		// 	$val = 2;
		// }
		return json_encode(array("val" => $val, "current" => $current, "currentplusone" => $currentplusone, "assi" => $assi, "pausas" => $pausas, "inicio" => $inicio));
	}

	function buildlang($info)
	{
		global $conn;
		$info = json_decode($info, true);
		$lang = $info['lang'];
		$page = $info['page'];
		$msg = "";
		$filelang = json_decode(file_get_contents("uploads/lang/" . $lang . ".json"), true);
		if (in_array($page, $filelang["ids"])) {
			$id = 0;
			$msg = "";
			try {
				$sql1 = "SELECT id,acro FROM core_idioma WHERE acro=:lang";
				$stmt = $conn->prepare($sql1);
				$stmt->execute([
					':lang' => $lang
				]);
				$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
				if ($rows) {
					foreach ($rows as $row) {
						$id = $row['id'];
						$msg .= "<a href='#' class='dropdown-toggle' data-toggle='dropdown'>
								<span class='flag-icon flag-icon-" . strtolower($row['acro']) . "' title='" . strtolower($row['acro']) . "'></span>
								<span class='name'>" . strtoupper($row['acro']) . "</span> <b class='caret'></b>
							</a>";
					}
				}
			} catch (PDOException $e) {
				echo "Error fetching data: " . $e->getMessage();
			}

			$msg .= "<ul class='dropdown-menu p-b-0'>
						<li class='arrow'></li>";

			try {
				$sql2 = "SELECT id,acro,descri FROM core_idioma WHERE id != :id";
				$stmt = $conn->prepare($sql2);
				$stmt->execute([
					':id' => $id
				]);
				$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
				if ($rows) {
					foreach ($rows as $row) {
						$msg .= "<li><a href='javascript:;' onclick='changelang(\"" . strtolower($row['acro']) . "\")'><span class='flag-icon flag-icon-" . strtolower($row['acro']) . "' title='" . strtolower($row['acro']) . "'></span> " . $row['descri'] . "</a></li>";
					}
				}
			} catch (PDOException $e) {
				echo "Error fetching data: " . $e->getMessage();
			}

			$msg .= "</ul>";
		}
		return json_encode(array("msg" => $msg));
	}

	function changelang($info)
	{
		global $conn;
		$lang = $info['lang'];
		$msg = "";
		$val = 0;
		try {
			$sql1 = "SELECT id,acro FROM core_idioma WHERE acro = :lang";
			$stmt = $conn->prepare($sql1);
			$stmt->execute([
				':lang' => $lang
			]);
			$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
			if ($rows) {
				foreach ($rows as $row) {
					try {
						$sql0 = "UPDATE core_login SET id_lang = :id_lang WHERE id = :login";
						$stmt = $conn->prepare($sql0);
						$update = $stmt->execute([
							'id_lang' => $row['id'],
							':login' => $_SESSION['login']
						]);
						if ($update) {
							$msg = "Idioma alterada com Sucesso.";
							$_SESSION['lang'] = $lang;
							$val = 1;
						}
					} catch (PDOException $e) {
						$msg = "Error fetching data: " . $e->getMessage();
						$val = 2;
					}
				}
			}
		} catch (PDOException $e) {
			echo "Error fetching data: " . $e->getMessage();
		}

		return json_encode(array("msg" => $msg, "val" => $val));
	}

	function logoutaction($info)
	{
		$info = json_decode($info, true);
		$val = 0;
		// $iduser = $info['iduser'];
		return json_encode(array("val" => $val));
	}

	function perfil($info)
	{
		global $conn;
		$id = $_SESSION['user'];
		$tipoesp = $_SESSION['tipoesp'];
		$arr = [];
		$sql1 = "";
		$content = "";
		if ($tipoesp == 1) {
			try {
				$sql1 = "SELECT * FROM core_user WHERE id = :id";
				$stmt = $conn->prepare($sql1);
				$stmt->execute([
					':id' => $id
				]);
				$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
				if ($rows) {
					foreach ($rows as $row) {
						$arr = array("id" => $row['id'], "nome" => $row['nome'], "email" => $row['email'], "contacto" => $row['contacto'], "img" => $row['img']);
					}
				}
			} catch (PDOException $e) {
				echo "Error fetching data: " . $e->getMessage();
			}

			$content = "
							<center>
								<img id='colabimg' style='width:50%;'>
							</center>
							<div class='row m-b-15'>
								<label class='col-md-3 col-form-label' style='text-align: end !important;'>Imagem</label>
								<div class='col-md-7'>
									<input id='inputimg' type='file' class='form-control' />
								</div>
								<div class='col-md-2'>
									<button type='button' id='botaouploadperfil' class='btn btn-warning' onclick='uploadInfoImg(" . $_SESSION['user'] . ")'><i class='fa fa-edit'></i></button>
								</div>
							</div>


							<div class='row mt-5'>
								<div class='mb-2 col-6'>
									<label class='form-label'>Nome</label>
									<input id='nome' type='text' class='form-control' placeholder='Nome' required='' />
								</div>
								<div class='mb-2 col-6'>
									<label class='form-label'>E-Mail</label>
									<input id='email' type='email' class='form-control' placeholder='E-Mail' required='' />
								</div>
								<div class='mb-2 col-6'>
									<label class='form-label'>Contacto</label>
									<input id='contacto' type='text' class='form-control' placeholder='Contacto Telefónico' required=''/>
								</div>
								<div class='mb-2 col-6'>
									<label class='form-label'>Password</label>
									<center>
										<button type='button' class='btn btn-danger' onclick='changepass(" . $_SESSION['user'] . ",1)'>Alterar <i class='fa fa-key'></i></button>
									</center>
								</div>
							</div
							";
		} else if ($tipoesp == 4) {

			$content = "<div class='row'>
							<div class='col-md-12 mb-3'>
								<label class='form-label'>Nome</label>
								<input id='nome' type='text' class='form-control' placeholder='Nome' required='' />
							</div>
						</div>
						<div class='col-md-6 mb-3'>
							<label class='form-label'>E-Mail</label>
							<input id='email' type='email' class='form-control' placeholder='E-Mail' required='' />
						</div>
						<div class='col-md-6 mb-3'>
							<label class='form-label'>Contacto</label>
							<input id='contacto' type='number' class='form-control' placeholder='Contacto Telefónico' required=''/>
						</div>
						<div class='col-md-12 mb-3'>
							<div class='row'>
								<label class='form-label'>Notificação<br>por email</label>
								<div class='col-md-7'>
									<div class='radio radio-css radio-inline'>
										<input type='radio' name='noti_email' id='noti_email0' value='0'>
										<label for='noti_email0'>Sim</label>
									</div>
									<div class='radio radio-css radio-inline'>
										<input type='radio' name='noti_email' id='noti_email1' value='1'>
										<label for='noti_email1'>Não</label>
									</div>
								</div>
							</div>
						</div>
						<div class='col-md-12'>
							<div class='form-group row m-b-15'>
								<label class='col-md-3 col-form-label'>Password</label>
								<div class='col-md-7'>
									<center>
										<button type='button' class='btn btn-danger' onclick='changepass(" . $_SESSION['user'] . ",1)'>Alterar <i class='fa fa-key'></i></button>
									</center>
								</div>
							</div>
						</div>";
		}
		$btn = "regPerfil(" . $_SESSION['user'] . "," . $_SESSION['tipoesp'] . ")";

		return json_encode(array("msg" => $content, "arr" => $arr, "tipoesp" => $_SESSION['tipoesp'], "btnFooter" => $btn));
	}

	function regPerfil($info)
	{
		global $conn;
		$info = json_decode($info, true);
		try {
			$id_user = $info['iduser'];
			$id_tipo = $info['tipo'];
			$nome = $info['nome'];
			$email = $info['email'];
			$contacto = $info['contacto'];
			$noti_email = isset($info['noti_email']) ? $info['noti_email'] : '';
			$msg = "";
			$val = 0;
			$sql = "";

			$sql = "UPDATE core_user SET nome=:nome, email=:email, contacto=:contacto WHERE core_user.id=:id_user";
			$stmt = $conn->prepare($sql);
			$update = $stmt->execute([
				':nome' => $nome,
				':email' => $email,
				':contacto' => $contacto,
				':id_user' => $id_user,
			]);

			if ($update) {
				$sql1 = "UPDATE core_login SET username = :email WHERE id_tipo = :id_tipo AND id_user = :id_user";
				$stmt = $conn->prepare($sql1);
				$update2 = $stmt->execute([
					':email' => $email,
					':id_tipo' => $id_tipo,
					':id_user' => $id_user,
				]);
				if ($update2) {
					$msg = "Perfil Editado com Sucesso.";
					$val = 1;
				} else {
					$msg = "Error record util: " . $sql1 . "<br>";
					$val = 3;
				}
			} else {
				$msg = "Error record util: " . $sql . "<br>";
				$val = 2;
			}
		} catch (PDOException $e) {
			$msg = $e->getMessage();
			$val = 2;
		}
		return json_encode(array("msg" => $msg, "val" => $val));
	}

	function changepass($info)
	{
		global $conn;
		$info = json_decode($info, true);
		$esc = $info['esc'];
		$id = $info['id'];
		$msg = "";
		$val = 0;
		$oripass = "";
		if ($esc == 1) {
			$sql1 = "SELECT pass FROM core_login WHERE id_user = :id";
			$stmt = $conn->prepare($sql1);
			$stmt->execute([
				':id' => $id
			]);
			$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
			if ($rows) {
				foreach ($rows as $row) {
					$oripass = $row['pass'];
				}
			}

			$msg = "<div class='modal-dialog'>
				<div class='modal-content'>
					<div class='modal-header'>
					<h4 class='modal-title'>Alterar Password</h4>

					<button type='button' class='close' data-dismiss='modal' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
					</div>
					<div class='modal-body'>
						<div class='form-group row m-b-15'>
							<label for='passori' class='col-md-3 col-form-label'>Password Original</label>
							<div class='col-md-7'>
								<input id='passori' type='password' class='form-control'/>
							</div>
						</div>
						<div class='form-group row m-b-15'>
							<label for='passori' class='col-md-3 col-form-label'>Nova Password</label>
							<div class='col-md-7'>
								<input id='pass1' type='password' class='form-control'/>
								<small class='f-s-12 text-grey-darker'>Password com 8 ou mais caracteres, alfanumérica.</small>
							</div>
						</div>
						<div class='form-group row m-b-15'>
							<label for='passori' class='col-md-3 col-form-label'>Confirmação</label>
							<div class='col-md-7'>
								<input id='pass2' type='password' class='form-control'/>
							</div>
						</div>
						<br>
						<div class='form-group'>
							<label class='col-sm-12 control-label form-label' id='passlog'></label>
						</div>
					</div>
					<div class='modal-footer'>
					<button type='button' class='btn btn-default' onclick='perfil()'>Voltar</button>
					<button type='button' id='botaopass' class='btn btn-default' onclick='changepass(" . $id . ",2);' disabled='true'>Alterar</button>
					</div>
				</div>
				</div>";
			$val = 0;
		} else {
			$pass = $info['pass'];
			$sql0 = "UPDATE core_login SET pass = :pass WHERE id_user = :id;";
			$stmt = $conn->prepare($sql0);
			$update = $stmt->execute([
				':pass' => $pass,
				':id' => $id
			]);
			try {
				if ($update) {
					try {
						$sql0 = "UPDATE core_login SET pass = :pass WHERE id_user = :id_user AND id_tipo = :id_tipo";
						$stmt = $conn->prepare($sql0);
						$update2 = $stmt->execute([
							':pass' => $pass,
							':id_user' => $id,
							':id_tipo' => $_SESSION['tipoesp']
						]);
						if ($update2) {
							$msg = "Password alterada com Sucesso.";
							$val = 1;
						}
					} catch (PDOException $e) {
						$msg = "Error fetching data: " . $e->getMessage();
						$val = 3;
					}
				}
			} catch (PDOException $e) {
				$msg = "Error fetching data: " . $e->getMessage();
				$val = 2;
			}

		}
		return json_encode(array("msg" => $msg, "val" => $val, "n" => $oripass));
	}

	function showNote($info)
	{
		global $conn;
		$info = json_decode($info, true);
		$arr = $info['arr'];
		$send = [];
		if (count($arr) > 1) {
			$send[0] = array("id" => 0, "title" => "Fechar Todas as Notificações", "message" => "", "img" => "");
		}
		for ($i = 0; $i < count($arr); $i++) {
			$sql = "SELECT core_notification.message,core_notification.dth FROM core_notification WHERE core_notification.id = :notification";
			$stmt = $conn->prepare($sql);
			$stmt->execute([
				':notification' => $arr[$i]
			]);
			$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
			if ($rows) {
				foreach ($rows as $row) {
					$img = "";
					$img = "img/blena.png";
					$send[count($send)] = array("id" => $arr[$i], "title" => "<span style='-webkit-transform: rotate(-90deg);'>B</span>lena<small style='weight:normal'> - " . $row['dth'] . "</small>", "message" => $row['message'], "img" => $img);
				}
			}
		}
		return json_encode($send);
	}

	function closeNote($info)
	{
		global $conn;
		$info = json_decode($info, true);
		$id = $info['id'];
		$arr = [];
		$msg = "";
		$val = 0;
		if ($id == 0) {
			try {
				$sql1 = "UPDATE core_notification SET act=1 WHERE idsent = :idsent";
				$stmt = $conn->prepare($sql1);
				$update = $stmt->execute([
					':idsent' => $_SESSION['login']
				]);
				if ($update) {
					$filejson = json_decode(file_get_contents("uploads/utilizadores/userlog" . $_SESSION['login'] . "/noti.json"), true);
					$arr = $filejson['noti'];
					$sendarr = [];
					$filejson['noti'] = $sendarr;
					$msg = file_put_contents("uploads/utilizadores/userlog" . $_SESSION['login'] . "/noti.json", json_encode($filejson));
					$val = 1;
				}
			} catch (PDOException $e) {
				$msg = "Error fetching data: " . $e->getMessage();
				$val = 2;
			}
		} else {
			try {
				$sql1 = "UPDATE core_notification SET act=1 WHERE id=:id";
				$stmt = $conn->prepare($sql1);
				$update2 = $stmt->execute([
					':id' => $id
				]);
			} catch (PDOException $e) {
				$msg = "Error fetching data: " . $e->getMessage();
				$val = 2;
			}
			try {
				if ($update2) {
					$filejson = json_decode(file_get_contents("uploads/utilizadores/userlog" . $_SESSION['login'] . "/noti.json"), true);
					$arr = $filejson['noti'];
					$sendarr = [];
					for ($i = 0; $i < count($arr); $i++) {
						if ($arr[$i] == $id) {
						} else {
							$sendarr[count($sendarr)] = $arr[$i];
						}
					}
					$filejson['noti'] = $sendarr;
					$msg = file_put_contents("uploads/utilizadores/userlog" . $_SESSION['login'] . "/noti.json", json_encode($filejson));
					$val = 1;
				}
			} catch (PDOException $e) {
				$msg = "Error fetching data: " . $e->getMessage();
				$val = 2;
			}
		}
		return json_encode(array("arr" => $arr, "val" => $val, "msg" => $msg));
	}

	function genMessage($info)
	{
		global $conn;
		$msg = "<div class='modal-dialog'>
				<div class='modal-content'>
					<div class='modal-header'>
						<h4 class='modal-title'>Notificação Geral</h4>
						<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
					</div>
					<div class='modal-body'>

						<div class='form-group row m-b-15'>
							<label for='idtipouser' class='col-md-3 col-form-label'>Grupos</label>
							<div class='col-md-7'>
								<select id='idtipouser' type='text' class='form-control'>
									<option value='0'>Todos os colaboradores</option>";

		try {
			$sql1 = "SELECT * FROm core_tipouser WHERE act=0";
			$stmt = $conn->prepare($sql1);
			$stmt->execute();
			$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
			if ($rows) {
				foreach ($rows as $row) {
					$msg .= "<option value='" . $row['id'] . "'>" . $row['descricao'] . "</option>";
				}
			}
		} catch (PDOException $e) {
			echo "Error fetching data: " . $e->getMessage();
		}

		$msg .= "</select></div>
						</div>
						<div class='form-group row m-b-15'>
							<label class='col-md-3 col-form-label'>Mesagem</label>
							<div class='col-md-7'>
								<textarea id='message' class='form-control' placeholder='Mensagem' rows='4'></textarea>
							</div>
							<div class='col-md-2'>
								<span id='conta'>0</span> de 150
							</div>
						</div>
					</div>
					<div class='modal-footer'>
						<button class='btn btn-success' style='color: white' onclick='regmessage(" . $_SESSION['user'] . ")'>Enviar <i class='fa fa-bell'></i></button>
						<a class='btn btn-white' data-dismiss='modal'>Fechar</a>
					</div>
				</div>
			</div>";
		return json_encode(array("msg" => $msg));
	}

	function regmessage($info)
	{
		global $conn;
		$info = json_decode($info, true);
		$id = $info['id'];
		$idtipo = $info['idtipo'];
		$message = addslashes($info['message']);
		$msg = "";
		$val = 0;
		$conta = 0;
		$real = 0;

		try {
			$sql9 = "SELECT core_login.id,core_user.nome FROM core_login,core_user
			WHERE core_login.idesp=core_user.id AND core_login.idtipo=1 AND core_user.act=0";
			if ($idtipo != 0) {
				$sql9 .= " AND core_user.idtipouser=:idtipouser";
			}
			$stmt = $conn->prepare($sql9);
			if ($idtipo != 0) {
				$stmt->bindValue(':idtipouser', $idtipo, PDO::PARAM_INT);
			}
			$stmt->execute();
			$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
			if ($rows) {
				foreach ($rows as $row) {
					$conta++;
					try {
						$sql10 = "INSERT INTO core_notification (iduser,idsent,message,act)
						VALUES(:login, :id, :mensage, 0)";
						$stmt = $conn->prepare($sql10);
						$insert = $stmt->execute([
							':login',
							$_SESSION['login'],
							':id',
							$row['id'],
							':mensage',
							$message
						]);
						if ($insert) {
							$real++;
							$arr = [];
							$pathname = "uploads/utilizadores/userlog" . $row['id'];
							if (!file_exists($pathname)) {
								//mkdir($pathname,0777,true);
							} else {
								$filejson = json_decode(file_get_contents("uploads/utilizadores/userlog" . $row['id'] . "/noti.json"), true);
								$arr = $filejson['noti'];
								$sendarr = [];
								for ($i = 0; $i < count($arr); $i++) {
									$sendarr[count($sendarr)] = $arr[$i];
								}
								$sendarr[count($sendarr)] = $insert;
								$filejson['noti'] = $sendarr;
								$msg2 = file_put_contents("uploads/utilizadores/userlog" . $row['id'] . "/noti.json", json_encode($filejson));
							}
						}
					} catch (PDOException $e) {
						$msg = "Error fetching data: " . $e->getMessage();
						$val = 9;
					}
				}
			}
		} catch (PDOException $e) {
			$msg = "Error fetching data: " . $e->getMessage();
			$val = 10;
		}

		if ($conta == $real) {
			$msg = "Notificação Enviada com Sucesso.";
			$val = 1;
		} else {
			$msg .= "";
			$val = 2;
		}

		return json_encode(array("msg" => $msg, "val" => $val));
	}

	function logErro($msg) {
		file_put_contents("log_erros.txt", date('Y-m-d H:i:s') . " - " . $msg . PHP_EOL, FILE_APPEND);
	}

	function resetAccess($info)
	{
		global $conn;
		$info = json_decode($info, true);
		$val = 2;
		$msg = "Sem Sessão";
		if (isset($_SESSION['user'])) {
			$newDate = date("Y-m-d", $info['dth']);
			$val = $newDate;
			try {
				$sql1 = "SELECT id FROM rh_assiduidade WHERE DATE(dth)=:newdate AND idtipoassi=2 AND iduser=:iduser";
				$stmt = $conn->prepare($sql1);
				$stmt->execute([
					':newdate' => $newDate,
					':iduser' => $_SESSION['user']
				]);
				$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
				if ($rows) {
					foreach ($rows as $row) {
						$val = 3;
						$msg = "Dia já encerrado.";
					}
				} else {
					try {
						$sql2 = "SELECT id FROM rh_pausas WHERE iduser=:iduser AND DATE(dthstart)=:newdate AND dthend IS NULL";
						$stmt = $conn->prepare($sql2);
						$stmt->execute([
							':iduser' => $_SESSION['user'],
							':newdate' => $newDate
						]);
						$rows2 = $stmt->fetchAll(PDO::FETCH_ASSOC);
						if ($rows2) {
							foreach ($rows2 as $row2) {
								$val = 4;
								$msg = "Pausa em aberto.";
							}
						} else {
							try {
								$sql3 = "INSERT INTO rh_assiduidade (iduser,idtipoassi,dth,est,loguser,logdth)
								VALUES(:iduser, 2, :newdate, 0, 2, :today)";
								$stmt = $conn->prepare($sql3);
								$insert = $stmt->execute([
									':iduser' => $_SESSION['user'],
									':newdate' => $newDate . " 23:59:59",
									':today' => date("Y-m-d H:i:s")
								]);
								if ($insert) {
									$newDateTomorrow = date('Y-m-d', strtotime($newDate . ' +1 day'));
									try {
										$sql3 = "INSERT INTO rh_assiduidade(iduser,idtipoassi,dth,est,loguser,logdth)
										VALUES(:iduser, 1, :newdateTomorrow, 0, 2, :today)";
										$stmt = $conn->prepare($sql3);
										$insert2 = $stmt->execute([
											':iduser' => $_SESSION['user'],
											':newdateTomorrow' => $newDateTomorrow . " 00:00:59",
											':today' => date("Y-m-d H:i:s")
										]);
										if ($insert2) {
											$val = 1;
											$msg = "Boa noite, iremos encerrar automaticamente o seu dia de trabalho e iniciar um novo dia de trabalho.<br>Continuação de bom trabalho.";
										}
									} catch (PDOException $e) {
										$msg = "Error fetching data: " . $e->getMessage();
										$val = 4;
									}
								}
							} catch (PDOException $e) {
								$msg = "Error fetching data: " . $e->getMessage();
								$val = 3;
							}
						}
					} catch (PDOException $e) {
						$msg = "Error fetching data: " . $e->getMessage();
						$val = 5;
					}
				}
			} catch (PDOException $e) {
				$msg = "Error fetching data: " . $e->getMessage();
				$val = 2;
			}
		}
		return json_encode(array("val" => $val, "msg" => $msg));
	}

	// Endpoint genérico de upload
  // Sessão obrigatória;
	// Para ficheiros CSV exige ação de negócio importar.
	function uploadFiles($info){
		$info = json_decode($info, true);
		$val = 1;
		$msg = "";
		$savedPaths = [];

		// Sem sessão válida não existe contexto de permissões.
		if (!isset($_SESSION['user'])) {
			return json_encode(array("files" => $savedPaths, "val" => 2, "msg" => "Sessão inválida."));
		}

		if (!isset($info['targetPath']) || trim($info['targetPath']) === '') {
			return json_encode(array("files" => $savedPaths, "val" => 2, "msg" => "Caminho inválido."));
		}

		// Normalização do destino e validação simples anti-traversal.
		$targetPath = rtrim($info['targetPath'], '/') . '/';
		if (strpos($targetPath, '..') !== false) {
			return json_encode(array("files" => $savedPaths, "val" => 2, "msg" => "Caminho inválido."));
		}

		$files = null;
		if (isset($_FILES['files'])) {
			$files = $_FILES['files'];
		} else if (isset($_FILES['files[]'])) {
			$files = $_FILES['files[]'];
		}

		if ($files === null || !isset($files['name'])) {
			return json_encode(array("files" => $savedPaths, "val" => 2, "msg" => "Sem ficheiros para upload."));
		}

		$fileNames = is_array($files['name']) ? $files['name'] : [$files['name']];
		// Contexto de permissão pode ser passado pelo caller;
		// se não vier, mantém defaults compatíveis com o sistema atual.
		$module = isset($info['module']) && $info['module'] != "" ? $info['module'] : 'core';
		$permKey = isset($info['permKey']) && $info['permKey'] != "" ? $info['permKey'] : 'permissoes';

		$hasCsv = false;
		for ($i = 0; $i < count($fileNames); $i++) {
			$extension = strtolower(pathinfo($fileNames[$i], PATHINFO_EXTENSION));
			if ($extension === 'csv') {
				$hasCsv = true;
				break;
			}
		}

		// Só exige a permissão "Importar" quando há pelo menos um CSV.
		// Desta forma não altera comportamento de uploads não-CSV existentes.
		if ($hasCsv && (!isset($_SESSION['perm'][$module][$permKey]['Importar']) || !$_SESSION['perm'][$module][$permKey]['Importar'])) {
			return json_encode(array("files" => $savedPaths, "val" => 2, "msg" => "Sem permissão para importar ficheiros CSV."));
		}

		// Converte targetPath para formato de pasta esperado pela função global uploadFiles($files, $folder)
		$normalizedTarget = trim(str_replace('\\', '/', $targetPath), '/');
		$folder = strpos($normalizedTarget, 'uploads/') === 0 ? substr($normalizedTarget, strlen('uploads/')) : $normalizedTarget;

		if ($folder === '' || strpos($folder, '..') !== false) {
			return json_encode(array("files" => $savedPaths, "val" => 2, "msg" => "Caminho inválido."));
		}

		// Cria o diretório de destino para manter compatibilidade com o helper global.
		$destinationDir = __DIR__ . '/../uploads/' . $folder;
		if (!is_dir($destinationDir)) {
			mkdir($destinationDir, 0777, true);
		}

		$uploadPayload = array('files' => $files);
		$uploadResultRaw = uploadFiles($uploadPayload, $folder);
		$uploadResult = json_decode($uploadResultRaw, true);

		if (!is_array($uploadResult) || !isset($uploadResult['val']) || $uploadResult['val'] != 'uf2') {
			$val = 2;
			$msg = "Não foi possível guardar os ficheiros enviados.";
		} else if (isset($uploadResult['files']) && is_array($uploadResult['files'])) {
			foreach ($uploadResult['files'] as $group) {
				if (is_array($group)) {
					foreach ($group as $filePath) {
						$savedPaths[] = $filePath;
					}
				}
			}
		}

		return json_encode(array("files" => $savedPaths, "val" => $val, "msg"=>$msg));
	}

	// Endpoint de remoção de ficheiros enviados.
	// Sessão obrigatória;
	// Permissão "Apagar" obrigatória;
	// Remoção restrita fisicamente ao diretório uploads.
	function deleteUploadedFile($info)
	{
		$info = json_decode($info, true);
		$msg = "";
		$val = 1;

		if (!isset($_SESSION['user'])) {
			return json_encode(array("msg" => "Sessão inválida.", "val" => 2));
		}

		// Contexto de autorização segue o mesmo padrão do upload.
		$module = isset($info['module']) && $info['module'] != "" ? $info['module'] : 'core';
		$permKey = isset($info['permKey']) && $info['permKey'] != "" ? $info['permKey'] : 'permissoes';
		if (!isset($_SESSION['perm'][$module][$permKey]['Apagar']) || !$_SESSION['perm'][$module][$permKey]['Apagar']) {
			return json_encode(array("msg" => "Sem permissão para apagar ficheiros.", "val" => 2));
		}

		if (!isset($info['filePath']) || trim($info['filePath']) === "") {
			return json_encode(array("msg" => "Ficheiro inválido.", "val" => 2));
		}

		// Normaliza separadores e remove barras iniciais para tratar sempre como relativo.
		$relativePath = str_replace('\\', '/', trim($info['filePath']));
		$relativePath = preg_replace('/^\/+/', '', $relativePath);
		if (strpos($relativePath, '..') !== false) {
			return json_encode(array("msg" => "Caminho inválido.", "val" => 2));
		}

		// Se vier sem prefixo "uploads/", força o prefixo para manter escopo controlado.
		if (strpos($relativePath, 'uploads/') !== 0) {
			$relativePath = 'uploads/' . $relativePath;
		}

		$baseDir = realpath(__DIR__ . '/../uploads');
		$fileToDelete = realpath(__DIR__ . '/../' . $relativePath);

		// Valida que o ficheiro final resolvido por realpath está dentro de uploads.
		// Evita apagar ficheiros fora do storage permitido.
		if ($baseDir === false || $fileToDelete === false || strpos(str_replace('\\', '/', $fileToDelete), str_replace('\\', '/', $baseDir) . '/') !== 0) {
			return json_encode(array("msg" => "Ficheiro não encontrado.", "val" => 2));
		}

		if (!is_file($fileToDelete)) {
			return json_encode(array("msg" => "Ficheiro inválido.", "val" => 2));
		}

		if (!unlink($fileToDelete)) {
			$msg = "Não foi possível apagar o ficheiro.";
			$val = 2;
		} else {
			$msg = "Ficheiro apagado com sucesso.";
			$val = 1;
		}

		return json_encode(array("msg" => $msg, "val" => $val));
	}

	function getSessionMessage($info)
	{
		global $conn;
		$info = json_decode($info, true);
		$id_user = $info['id_user'];
		$val = 1;
		$msg = "";
		$sessionMessage = [];
		$dataHoje = date('Y-m-d');
		$dataNasc = null;
		// Ir buscar a mensagem de login
		try {
			// Buscar aniversário do user
			$sqlU = "SELECT dtnasc
			FROM core_user
			WHERE id = 1";
			$stmtU = $conn->prepare($sqlU);
			$stmtU->execute();
			$rowsU = $stmtU->fetchAll(PDO::FETCH_ASSOC);
			if ($rowsU) {
				$dataNasc = $rowsU[0]['dtnasc'];
			}

			// Buscar geral
			$sqlM = "SELECT id, message, type_event, type, date, emoji
			FROM session_messages
			WHERE id NOT IN (SELECT id_session FROM session_messages_users)
			AND is_active = 1";
			$stmtM = $conn->prepare($sqlM);
			$stmtM->execute();
			$rowsM = $stmtM->fetchAll(PDO::FETCH_ASSOC);
			if ($rowsM) {
				foreach ($rowsM as $rowM) {
					$sessionMessage[] = array("id"=>$rowM['id'],"message"=>$rowM['message'],"type"=>$rowM['type'],"type_event"=>$rowM['type_event'],"date"=>$rowM['date'],"emoji"=>$rowM['emoji'],"user"=>false);
				}
			}
			// Buscar especifica
			$sqlM = "SELECT session_messages.id, session_messages.message, session_messages.type, session_messages.type_event, session_messages.date, session_messages.emoji
			FROM session_messages, session_messages_users
			WHERE session_messages_users.id_session = session_messages.id
			AND is_active = 1
			AND session_messages_users.id_user = :id";
			$stmtM = $conn->prepare($sqlM);
			$stmtM->execute([
				':id' => $id_user
			]);
			$rowsM = $stmtM->fetchAll(PDO::FETCH_ASSOC);
			if ($rowsM) {
				foreach ($rowsM as $rowM) {
					$sessionMessage[] = array("id"=>$rowM['id'],"message"=>$rowM['message'],"type"=>$rowM['type'],"type_event"=>$rowM['type_event'],"date"=>$rowM['date'],"emoji"=>$rowM['emoji'],"user"=>true);
				}
			}

			// Se não for dia de aniversário remover tudo
			if($dataNasc != date('Y-m-d')) {
				$sessionMessage = array_filter($sessionMessage, function ($item) {
					return $item['type_event'] !== 'birthday';
				});
				$sessionMessage = array_values($sessionMessage);
			}

			// Se não for dia de natal
			if("12-24" != date('m-d') && "12-25" != date('m-d')) {
				$sessionMessage = array_filter($sessionMessage, function ($item) {
					return $item['type_event'] !== 'christmas';
				});
				$sessionMessage = array_values($sessionMessage);
			}

			// Se não for dia de ano novo
			if("12-31" != date('m-d') && "01-01" != date('m-d')) {
				$sessionMessage = array_filter($sessionMessage, function ($item) {
					return $item['type_event'] !== 'new year';
				});
				$sessionMessage = array_values($sessionMessage);
			}

			// Remover os que tem data e não é o dia de hoje
			$sessionMessage = array_filter($sessionMessage, function ($item) {
				return $item['date'] != date('Y-m-d');
			});
			$sessionMessage = array_values($sessionMessage);
		}catch (PDOException $e) {
			$msg = "Erro a buscar mensagem de sessão, " . $e->getMessage();
			$val = 2;
		}

		return json_encode(array('val' => $val, 'msg' => $msg, "sessionMessage"=>$sessionMessage));
	}
}
