<?php
$GLOBALS['ex'] = 0;

class Utilizadoresdb
{

	// Função que carrega a lista de utilizadores
	function loadusers($esc)
	{
		global $conn;
		$btn = "";
		$msg = "";

		if ($esc == 1) {
			if ($_SESSION['perm']['core']['utilizadores']['Adicionar']) {
				$btn .= "<button type='button' class='btn btn-default btn-xs' onclick='modfunc(0,1);'><i class='fa fa-plus'></i>Adicionar</button>";
			}
			$msg = "<table class='table datatable table-hover' style='font-size: 12px;' cellspacing='0' width='100%' id='main" . $esc . "1'>
					<thead>
						<tr>
							<th>Nº</th>
							<th>Nome</th>
							<th>Mail</th>
							<th>Contacto</th>
							<th>Tipo</th>
						</tr>
					</thead>
					<tbody>";
			$sql = "";
			$sql = "SELECT core_user.id, core_user.cod, core_user.nome, core_user.email, core_user.is_active, core_user.contacto, core_user.id_tipouser, core_tipouser.descricao as tipo
			FROM core_user, core_tipouser
			WHERE core_user.id_tipouser=core_tipouser.id
			AND core_user.is_active=1
			AND core_tipouser.is_active!=0";
			try {
				$stmt = $conn->prepare($sql);
				$stmt->execute();
				$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
				if ($rows) {
					foreach ($rows as $row) {
						$estado = "";
						if ($row['is_active'] == 0) {
							$estado = " style='background-color:rgba(204, 204, 204, 0.5);'";
						}
						$msg .= "<tr" . $estado . " onclick='toggleDropdown(this);' class='text-secondary' style='position:relative; cursor:pointer;'>
			    					<td>" . $row['cod'] . "</td>
			    					<td>" . $row['nome'] . "</td>
			    					<td>" . $row['email'] . "</td>
			    					<td>" . $row['contacto'] . "</td>
									<td>" . $row['tipo'] . "
										<ul class='dropdown-menu dropdown-menu-right hidden-dropdown'>";

						if ($_SESSION['perm']['core']['utilizadores']['Editar']) {
							$msg .= "<li><button type='button' class='btn btn-outline-secondary-transparent btn-sm' color:#00acac' onclick='modfunc(" . $row['id'] . ",2)'>Editar</button></li>";
						} else {
							$msg .= "<li><button type='button' class='btn btn-outline-secondary-transparent btn-sm' color:#00acac' onclick='modfunc(" . $row['id'] . ",2)'>Ver</button></li>";
						}
						if ($_SESSION['perm']['core']['utilizadores']['Gerir']) {
							$msg .= "<li class='divider'></li>";
							if ($row['is_active'] == 1) {
								$msg .= "<li><button type='button' class='btn btn-outline-secondary-transparent btn-sm' color:red' onclick='modconf(\"Tem a certeza que pretende desativar este utilizador?\",\"desact(" . $row['id'] . ",0)\")'>Desativar</button></li>";
							} else {
								$msg .= "<li><button type='button' class='btn btn-outline-secondary-transparent btn-sm' color:green' onclick='modconf(\"Tem a certeza que pretende ativar este utilizador?\",\"desact(" . $row['id'] . ",1)\")'>Ativar</button></li>";
							}
						}

						$msg .= "	</ul>
								</td>
                  			</tr>";
					}
				}
			} catch (PDOException $e) {
				echo "Error fetching data: " . $e->getMessage();
			}

			$msg .= "</tbody>
				</table>";
		} else {
			$msg = "<table class='table datatable table-hover' style='font-size: 12px;' cellspacing='0' width='100%' id='main" . $esc . "1'>
						<thead>
							<tr>
								<th>Nº</th>
								<th>Nome</th>
								<th>Mail</th>
								<th>Contacto</th>
								<th>Tipo</th>
							</tr>
						</thead>
						<tbody>";

							try {
				$sql = "SELECT core_user.id, core_user.cod, core_user.nome, core_user.email, core_user.is_active, core_user.contacto, core_user.id_tipouser, core_tipouser.descricao as tipo
					FROM core_user, core_tipouser
					WHERE core_user.id_tipouser=core_tipouser.id
					AND core_user.is_active= 0";
				$stmt = $conn->prepare($sql);
				$stmt->execute();
				$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
				if ($rows) {
					foreach ($rows as $row) {
						$estado = "";
						$msg .= "
							<tr" . $estado . " onclick='toggleDropdown(this);' class='text-secondary' style='position:relative; cursor:pointer;'>
								<td>" . $row['cod'] . "</td>
								<td>" . $row['nome'] . "</td>
								<td>" . $row['email'] . "</td>
								<td>" . $row['contacto'] . "</td>
								<td>" . $row['tipo'] . "
									<ul class='dropdown-menu dropdown-menu-right hidden-dropdown'>";

							if ($_SESSION['perm']['core']['utilizadores']['Editar']) {
								$msg .= "<li><button type='button' class='btn btn-outline-secondary-transparent btn-sm' color:#00acac' onclick='modfunc(" . $row['id'] . ",2)'>Editar</button></li>";
							} else {
								$msg .= "<li><button type='button' class='btn btn-outline-secondary-transparent btn-sm' color:#00acac' onclick='modfunc(" . $row['id'] . ",2)'>Ver</button></li>";
							}
							if ($_SESSION['perm']['core']['utilizadores']['Gerir']) {
								$msg .= "<li class='divider'></li>";
								if ($row['is_active'] == 1) {
									$msg .= "<li><button type='button' class='btn btn-outline-secondary-transparent btn-sm' color:red' onclick='modconf(\"Tem a certeza que pretende desativar este utilizador?\",\"desact(" . $row['id'] . ",0)\")'>Desativar</button></li>";
								} else {
									$msg .= "<li><button type='button' class='btn btn-outline-secondary-transparent btn-sm' color:green' onclick='modconf(\"Tem a certeza que pretende ativar este utilizador?\",\"desact(" . $row['id'] . ",1)\")'>Ativar</button></li>";
								}
							}
						$msg .= "
									</ul>
								</td>
							</tr>";

					}
				}
			} catch (PDOException $e) {
				echo "Error fetching data: " . $e->getMessage();
			}

			$msg .= 	"</tbody>
				</table>";
		}
		return json_encode(array("msg" => $msg, "btn" => $btn));
	}

	// Função do modal de adicionar e editar utilizador
	function modfunc($info)
	{
		global $conn;
		$info = json_decode($info, true);
		$arr = array();
		$msg = "";
		$esc = $info['esc'];
		$id = $info['id'];
		$checkExistsFin = false;
		$turnos_utilizador = array();
		$sabado = "";
		$domingo = "";
		$pool_excep = [1, 2, 3, 7];
		$iddepartamento = 0;
		$idgrupo = 0;
		$nome = "";
		$titulo = "";

		if ($esc == 2) {
			try {
				$sql2 = "SELECT core_user.*
						 FROM core_user
						 WHERE core_user.id= :id";
				$stmt = $conn->prepare($sql2);
				$stmt->execute([':id' => $id]);
				$rows2 = $stmt->fetchAll(PDO::FETCH_ASSOC);
				if ($rows2) {
					foreach ($rows2 as $row2) {
						$nome = $row2['nome'];
						$img = "";
						if (!is_null($row2['img']) && $row2['img'] != "img/user.png") {
							$img = $row2['img'];
						}
						$arr = array("id" => $row2['id'], "id_departamento" => $row2['id_departamento'], "id_tipouser" => $row2['id_tipouser'], "id_tipocont" => $row2['id_tipocont'], "id_hl" => $row2['id_hl'], "id_sexo" => $row2['id_sexo'],  "id_funcao" => $row2['id_funcao'], "nome" => $row2['nome'], "email" => $row2['email'], "contacto" => $row2['contacto'], "cor" => $row2['cor'], "img" => $img, "cod" => $row2['cod']);
					}
				}
			} catch (PDOException $e) {
				echo "Error fetching data: " . $e->getMessage();
			}

			$titulo = "<i class='fa fa-edit'></i> &nbsp;Editar Utilizador - {$nome}";
		} else {
			$arr[0] = 0;
			$titulo = "<i class='fa fa-pencil-square'></i> &nbsp;Adicionar Utilizador";
		}
		$msg .= "				<div class='col-md-12 row' id='swal-utilizador'>
									<div class='col-md-1'>
										<div class='form-group row'>
										<label for='cod' class='col-form-label col-md-12'>Nº</label>
											<div class='col-md-12'>
												<input type='text' id='cod' name='cod' class='form-control core_user  required'>
											</div>
										</div>
									</div>
									<div class='col-md-3'>
										<div class='form-group row'>
											<label for='nome' class='col-form-label col-md-12'>Nome</label>
											<div class='col-md-12'>
												<input type='text' id='nome' name='nome' class='form-control core_user  required'>
											</div>
										</div>
									</div>
									<div class='col-md-2'>
										<div class='form-group row'>
											<label for='idtipouser' class='col-form-label col-md-12'>Tipo</label>
											<div class='col-md-12'>
												<select id='id_tipouser' name='id_tipouser' min ='1' class='default-select2 form-control  required'>
													<option value='0'>Selecione o Tipo</option>";

	try {
		$sql1 = "SELECT id,descricao FROM core_tipouser WHERE is_active=1";
		$stmt = $conn->prepare($sql1);
		$stmt->execute();
		$rows1 = $stmt->fetchAll(PDO::FETCH_ASSOC);
		if ($rows1) {
			foreach ($rows1 as $row1) {
				$select = "";
				if(isset($arr['id_tipouser']) && $row1['id'] == $arr['id_tipouser']){
					$select = ' selected ';
				}
				$msg .= "							<option value='" . $row1['id'] . "' {$select}>" . $row1['descricao'] . "</option>";
			}
		}
	} catch (PDOException $e) {
		echo "Error fetching data: " . $e->getMessage();
	}

	$msg .= "										</select>
											</div>
										</div>
									</div>
									<div class='col-md-3'>
										<div class='form-group row'>
											<label for='id_funcao' class='col-form-label col-md-12'>Função</label>
											<div class='col-md-12'>
												<select id='id_funcao' name='id_funcao' min='1' class='default-select2 form-control required'>
													<option value='0'>Selecione a Função</option>";
	try {
		$sql1 = "SELECT * FROM core_funcao WHERE is_active=1";
		$stmt = $conn->prepare($sql1);
		$stmt->execute();
		$rows1 = $stmt->fetchAll(PDO::FETCH_ASSOC);
		if ($rows1) {
			foreach ($rows1 as $row1) {
				$select = "";
				if(isset($arr['id_funcao']) && $row1['id'] == $arr['id_funcao']){
					$select = ' selected ';
				}
				$msg .= "							<option value='" . $row1['id'] . "' {$select}>" . $row1['descricao'] . "</option>";
			}
		}
	} catch (PDOException $e) {
		echo "Error fetching data: " . $e->getMessage();
	}

		$msg .= "								</select>
											</div>
										</div>
									</div>
									<div class='col-md-3'>
										<div class='form-group row'>
											<label for='iddepartamento' class='col-form-label col-md-12'>Departamento</label>
											<div class='col-md-12'>
												<select id='id_departamento' name='id_departamento' class='default-select2 form-control required'>
												<option value='0'>Selecione o departamento</option>";
	try {
		$sql1 = "SELECT id,descricao FROM core_departamento WHERE is_active=1 ORDER BY descricao ASC";
		$stmt = $conn->prepare($sql1);
		$stmt->execute();
		$rows1 = $stmt->fetchAll(PDO::FETCH_ASSOC);
		if ($rows1) {
			foreach ($rows1 as $row1) {
				// var_dump($row1);
				$select = "";
				if(isset($arr['id_departamento']) && $row1['id'] == $arr['id_departamento']){
					$select = ' selected ';
				}
				$msg .= "						<option value='" . $row1['id'] . "' {$select}>" . $row1['descricao'] . "</option>";
			}
		}
	} catch (PDOException $e) {
		echo "Error fetching data: " . $e->getMessage();
	}

		$msg .= "								</select>
											</div>
										</div>
									</div>

									<div class='col-md-3'>
										<div class='form-group row'>
											<label for='email' class='col-form-label col-md-12'>Email</label>
											<div class='col-md-12'>
												<input type='text' id='email' name='email' class='form-control  '>
											</div>
										</div>
									</div>
									<div class='col-md-3'>
										<div class='form-group row'>
											<label for='contacto' class='col-form-label col-md-12'>Contacto</label>
											<div class='col-md-12'>
												<input type='text' id='contacto' name='contacto' class='form-control required'>
											</div>
										</div>
									</div>
									<div class='col-md-3'>
										<div class='form-group row'>
											<label for='cor' class='col-form-label col-md-12'>Cor</label>
											<div class='col-md-5'>
												<input type='color' class='form-control required' id='cor' name='cor' style='width:100%;'>
											</div>
											<div class='col-md-7'>
												<p id='hexacode' class='form-control' style='width:100%;'></p>
											</div>
										</div>
									</div>
									<div class='col-md-3'>
										<div class='form-group row'>
											<label for='id_sexo' class='col-form-label col-md-12'>Sexo</label>
											<div class='col-md-12'>
												<select id='id_sexo' name='id_sexo' min='1' class='default-select2 form-control required'>
													<option value='0'>Selecione o Sexo</option>";
	try {
		$sql1 = "SELECT id,descricao FROM core_user_sexo WHERE is_active=1";
		$stmt = $conn->prepare($sql1);
		$stmt->execute();
		$rows1 = $stmt->fetchAll(PDO::FETCH_ASSOC);
		if ($rows1) {
			foreach ($rows1 as $row1) {
				$select = "";
				if(isset($arr['id_sexo']) && $row1['id'] == $arr['id_sexo']){
					$select = ' selected ';
				}
				$msg .= "							<option value='" . $row1['id'] . "' {$select}>" . $row1['descricao'] . "</option>";
			}
		}
	} catch (PDOException $e) {
		echo "Error fetching data: " . $e->getMessage();
	}

		$msg .= "								</select>
											</div>
										</div>
									</div>

									<div class='col-md-6'>
										<div class='form-group row'>
											<label for='passori' class='col-md-6 col-form-label'>Inserir Password</label>
											<label for='pass' class='col-md-6 col-form-label'>Validar Password</label>
											<div class='col-md-6'>
												<input id='pass1' type='password' class='form-control'/>
												<small class='f-s-12 text-grey-darker'>Password com 8 ou mais caracteres, alfanumérica.</small>
											</div>
											<div class='col-md-6'>
												<input id='pass2' type='password' class='form-control' disabled  />
											</div>
											<div class='col-md-12'>
												<label class='col-sm-12 control-label form-label' id='passlog' style='text-align:center;'></label>
											</div>
										</div>
									</div>

								</div>
							</div>
							";
		$footer = "
	          	<div class='drawer-footer'>
	          		<button type='button' class='btn btn-success' id='btnmod'>Guardar</button>
	            	<button type='button' class='btn btn-white' onclick='Swal.close();'>Fechar</button>
	          	</div>";
		return json_encode(array("msg" => $msg, "titulo" => $titulo, "footer" => $footer, "arr" => $arr));
	}

	// Função que adicionar e edita o utilizador
	function guardar($info)
	{
		global $conn;
		$msg = "";
		$info = json_decode($info, true);
		$val = 0;
		if (isset($info['info'])) {
			$data = $info['info'];

			// Verificar se as chaves existem antes de acessá-las
			$id = isset($info['id']) ? $info['id'] : null;
			$core_user = $data;
			$esc = isset($info['esc']) ? $info['esc'] : null;

			if ($id === null || $core_user === null) {
				$msg = "Dados incompletos fornecidos.";
			}else{
				$msg = "";
				$flag= 0;
				try {
					$sql9 = "SELECT id FROM core_user WHERE cod = :cod AND id != :id";
					$stmt = $conn->prepare($sql9);
					$stmt->execute([
						':cod' => $core_user['cod'],
						':id'  => $id
					]);
					$rows9 = $stmt->fetchAll(PDO::FETCH_ASSOC);
					if ($rows9) {
						foreach ($rows9 as $row9) {
							$val = 2;
							$msg .= "Esse Nº de Utilizador já se encontra atribuido.";
						}
					} else {
						$flag = 1;
						if ($esc == 1) {
							$flag = 2;
							try {
								$sql1 = "SELECT email FROM core_user WHERE email = :email";
								$stmt = $conn->prepare($sql1);
								$stmt->execute([':email' => $core_user['email']]);
								$rows1 = $stmt->fetchAll(PDO::FETCH_ASSOC);

								if ($rows1) {
									foreach ($rows1 as $row1) {
										$msg = "O Email já se encontra registado";
										$val = 2;
									}
								}else {
									$flag = 3;
									$pass = $core_user['pass'];
									unset($core_user['pass']);
									$insert = saveData("core_user", $core_user);
									$flag = 4;
									if ($insert['val'] == 1) {
										$flag = 5;
										$id = $insert['id'];
										$pathname = "uploads/utilizadores/userlog" . $id;
										if (!file_exists($pathname)) {
											mkdir($pathname, 0777, true);
										}
										$dados1 = array("id_tipo"=>1,"id_user"=>$id,"id_lang"=>1,"username"=>$core_user['email'],"pass"=>$pass);
										$insert1 = saveData("core_login", $dados1);
										$flag = 6;
										if ($insert1['val']== 1) {
											$msg = "Utilizador registado com sucesso.";
											$val = 1;
										}
									}else{
										$msg = "Erro ao registar utilizador, ".$insert['msg'];
										$val = 2;
									}
								}
							} catch (PDOException $e) {
								$msg .= "Error fetching data: " . $e->getMessage();
								$val = 6;
							}
						} else {
							$flag = 7;
							$dados2 = array("username"=>$core_user['email']);
							if(isset($core_user['pass'])){
								$dados2['pass'] = $core_user['pass'];
								unset($core_user['pass']);
							}
							$update = saveData("core_user", $core_user, $id);
							if ($update['val'] == 1) {
								$flag = 9;
								$pathname = "uploads/utilizadores/userlog" . $id;
								if (!file_exists($pathname)) {
									mkdir($pathname, 0777, true);
								}
								$idlogin = 0;
								try {
									$sql1 = "SELECT id FROM core_login WHERE core_login.id_user=:id_user AND core_login.id_tipo=1";
									$stmt = $conn->prepare($sql1);
									$stmt->execute([
										':id_user' => $id
									]);
									$rows1 = $stmt->fetchAll(PDO::FETCH_ASSOC);
									if ($rows1) {
										foreach ($rows1 as $row1) {
											$idlogin = $row1['id'];
											$update1 = saveData("core_login", $dados2,$idlogin);
											if($update1['val'] == 1){
												$msg = "Utilizador editado com sucesso." ;
												$val = 1;
											}else{
												$val = 9;
												$msg = $update1['msg'];
											}
										}
									}
								} catch (PDOException $e) {
									$msg .= "Error fetching data: " . $e->getMessage()."<br>". $e;
									$val = 6;
								}
							}else{
								$val = 2;
								$msg = "Erro ao atualizar o utilizador, ".$update['msg'];
							}
						}
					}
				} catch (PDOException $e) {
					$msg .= "Error fetching data: " . $e->getMessage();
					$val = 3;
				}
			}
		}
		return json_encode(array("val" => $val, "msg" => $msg, "id" => $id, "flag" => $flag));
	}

	// Função para desativar e ativar os utilizadores
	function desact($info)
	{
		global $conn;
		$info = json_decode($info, true);
		$msg = "";
		$id = $info['id'];
		$esc = $info['esc'];
		$val = 0;
		try {
			$sql = "UPDATE core_user SET is_active=:is_active WHERE id=:id";
			$stmt = $conn->prepare($sql);
			$update = $stmt->execute([
				':is_active' => $esc,
				':id' => $id
			]);
			if ($update) {
				try {
					$sql1 = "UPDATE core_login SET is_active=:is_active WHERE id_user=:id AND id_tipo=1";
					$stmt = $conn->prepare($sql1);
					$update1 = $stmt->execute([
						':is_active' => $esc,
						':id' => $id
					]);
					if ($update1) {
						if ($esc == 0) {
							$msg .= "Utiliador desativado com sucesso!";
						} else {
							$msg .= "Utilizador ativado com sucesso!";
						}
						$val = 1;
					} else {
						$msg .= "Erro a alterar o estado do utilizador, ".$update1['msg'];
						$val = 2;
					}
				} catch (PDOException $e) {
					$msg .= "Erro a alterar o estado do utilizador, ".$e->getMessage();
					$val = 3;
				}

			} else {
				$msg .= "Erro a alterar o estado do utilizador, ".$update['msg'];
				$val = 4;
			}
		} catch (PDOException $e) {
			$msg .= "Erro a alterar o estado do utilizador, ".$e->getMessage();
			$val = 5;
		}

		return json_encode(array("msg" => $msg, "val" => $val));
	}
}
