<?php
$GLOBALS['ex'] = 0;

class Permissoesdb
{

	function loadTipo()
	{
		global $conn;
		$msg = "";
		$i = 0;
		$msg = "<table id='tabl1' class='table table-bordered' style='width:100%;'>
		                    <thead>
		                      <tr>
		                        <th>Tipo de Utilizador</th>
		                        <th>Atribuidos</th>
		                        <th style='width: 50px !important;'><center>Opções</center></th>
		                      </tr>
		                    </thead>
		                    <tbody>";
		try {
			$sql = "SELECT * FROM core_tipouser WHERE core_tipouser.is_active=1";
			$stmt = $conn->prepare($sql);
			$stmt->execute();
			$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
			if ($rows) {
				foreach ($rows as $row) {
					$msg .= "<tr>
		    				<td>" . $row['descricao'] . "</td>";

					try {
						$sql1 = "SELECT COUNT(*) as conta FROM core_user WHERE id_tipouser=:id_tipouser";
						$stmt = $conn->prepare($sql1);
						$stmt->execute([
							':id_tipouser' => $row['id'],
						]);
						$rows1 = $stmt->fetchAll(PDO::FETCH_ASSOC);
						if ($rows1) {
							foreach ($rows1 as $row1) {
								$msg .= "<td>" . $row1['conta'] . "</td>";
							}
						}
					} catch (PDOException $e) {
						echo "Error fetching data: " . $e->getMessage();
					}

					$msg .= "<td style='text-align:center;'>
							<div class='btn-group m-r-5 m-b-5'>
	                            <button  data-toggle='dropdown' class='btn btn-inverse' style='border-radius: .25rem !important'><i class='fa fa-cog'></i></button>
	                            <ul class='dropdown-menu dropdown-menu-right' x-placement='bottom-start'>
		    						<li><button type='button' class='btn btn-link' style='text-decoration:none; color:#00acac' onclick='loadPerm(" . $row['id'] . ")'>".($_SESSION['perm']['core']['permissoes']['Editar'] ? "Gerir Permissões" : "Ver Permissões")."</button></li>
		    					</ul>
		    				</div>
		    			</td>
		    		</tr>";
				}
			}
		} catch (PDOException $e) {
			echo "Error fetching data: " . $e->getMessage();
		}

		$msg .= "</tbody>
	    </table>";
		return json_encode(array("msg" => $msg));
	}

	function loadPerm($id)
	{
		global $conn;
		$extra = "";
		try {
			$sql1 = "SELECT descricao FROM core_tipouser WHERE id=:id";
			$stmt = $conn->prepare($sql1);
			$stmt->execute([
				':id' => $id
			]);
			$rows1 = $stmt->fetchAll(PDO::FETCH_ASSOC);
			if ($rows1) {
				foreach ($rows1 as $row1) {
					$extra = $row1['descricao'];
				}
			}
		} catch (PDOException $e) {
			echo "Error fetching data: " . $e->getMessage();
		}

		$perm = [];
		try {
			$sql2 = "SELECT id_perm FROM core_rel_tipouser_permissao WHERE id_tipo=:id";
			$stmt = $conn->prepare($sql2);
			$stmt->execute([
				':id' => $id
			]);
			$rows2 = $stmt->fetchAll(PDO::FETCH_ASSOC);
			if ($rows2) {
				foreach ($rows2 as $row2) {
					$perm[count($perm)] = $row2['id_perm'];
				}
			}
		} catch (PDOException $e) {
			echo "Error fetching data: " . $e->getMessage();
		}

		$arr = [];
		$titulo = "Listagem de Permissões - " . $extra;
		$btn = "<button type='button' class='btn btn-default btn-xs' onclick='loadTipo()'><i class='fa fa-reply'></i> Voltar</button>";

		$msg = "<button id='mudarperm' type='button' class='btn btn-success pull-right' onclick='changePerm(" . $id . ")'>Validar <i class='fa fa-check'></i></button><div class='clearfix'></div><br>
				<div id='accordion' class='card-accordion'>";
		try {
			$sql = "SELECT core_module.id,core_module.cod,core_module.descricao as module FROM core_module 
					WHERE core_module.is_active=1 ORDER BY core_module.descricao ASC";
			$stmt = $conn->prepare($sql);
			$stmt->execute();
			$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
			if ($rows) {
				foreach ($rows as $row) {
					$msg .= "<div class='card'>
							<div id='acc" . $row['id'] . "' class='card-header bg-black text-white pointer-cursor' data-toggle='collapse' data-target='#" . $row['cod'] . "'>
								" . $row['module'] . "
							</div>
							<div id='" . $row['cod'] . "' class='collapse row' data-parent='#accordion'>
								<div class='card-body row'><table class='table' id='tabacc" . $row['id'] . "' style='width:100%;'>";
					$subarr = [];
					try {
						$sql4 = "SELECT core_tipopermissao.id,core_tipopermissao.descricao as page FROM core_tipopermissao 
						WHERE core_tipopermissao.id_module=:id AND core_tipopermissao.is_active=1";
						$stmt = $conn->prepare($sql4);
						$stmt->execute([
							':id' => $row['id']
						]);
						$rows4 = $stmt->fetchAll(PDO::FETCH_ASSOC);
						if ($rows4) {
							foreach ($rows4 as $row4) {
								$msg .= "<tr><th colspan='4'><h5>" . $row4['page'] . "</h5></th></tr>";
								$i = 1;
								$contentarr = [];
								try {
									$sql3 = "SELECT core_permissao.id,core_permissao.descricao,core_permissao.notas FROM core_permissao 
									WHERE core_permissao.id_tipo=:id";
									$stmt = $conn->prepare($sql3);
									$stmt->execute([
										':id' => $row4['id']
									]);
									$rows3 = $stmt->fetchAll(PDO::FETCH_ASSOC);
									if ($rows3) {
										foreach ($rows3 as $row3) {
											$check = 0;
											if (in_array($row3['id'], $perm)) {
												$check = 1;
											} else {
												$check = 0;
											}

											$contentarr[count($contentarr)] = array("id" => $row3['id'], "descricao" => $row3['descricao'] . " - " . $row3['notas'], "id_tipo" => $row4['id'], "id_module" => $row['id'], "check" => $check);
										}
									}
								} catch (PDOException $e) {
									echo "Error fetching data: " . $e->getMessage();
								}

								$subarr[count($subarr)] = array("id" => $row4['id'], "page" => $row4['page'], "arr" => $contentarr);
							}
						}
					} catch (PDOException $e) {
						echo "Error fetching data: " . $e->getMessage();
					}

					$arr[count($arr)] = array("id" => $row['id'], "arr" => $subarr);
					$msg .= "</table></div>
							</div>
						</div>";
				}
			}
		} catch (PDOException $e) {
			echo "Error fetching data: " . $e->getMessage();
		}

		$msg .= "</div>";
		return json_encode(array("msg" => $msg, "titulo" => $titulo, "arr" => $arr, "btn" => $btn));
	}

	function changePerm($info)
	{
		global $conn;
		$info = json_decode($info, true);
		$id = $info['id'];
		$arr = $info['arr'];
		$contador = 0;
		$val = 0;
		$msg = "";
		for ($i = 0; $i < count($arr); $i++) {
			if (isset($arr[$i]['id'])) {
				try {
					$sql1 = "SELECT id FROM core_rel_tipouser_permissao WHERE id_perm=:id_perm AND id_tipo=:id_tipo";
					$stmt = $conn->prepare($sql1);
					$stmt->execute([
						':id_perm' => $arr[$i]['id'],
						':id_tipo' => $id
					]);
					$rows1 = $stmt->fetchAll(PDO::FETCH_ASSOC);
					if ($rows1) {
						foreach ($rows1 as $row1) {
							if ($arr[$i]['check'] == 0) {
								try {
									$sql2 = "DELETE FROM core_rel_tipouser_permissao WHERE id=:id";
									$stmt = $conn->prepare($sql2);
									$delete = $stmt->execute([
										':id' => $row1['id']
									]);
									if ($delete) {
										$contador++;
									} else {
										$msg .= "Error record util: " . $sql2 . "<br>";
										$val = 2;
									}
								} catch (PDOException $e) {
									echo "Error fetching data: " . $e->getMessage();
								}
							} else {
								$contador++;
							}
						}
					} else {
						if ($arr[$i]['check'] == 0) {
							$contador++;
						} else {
							try {
								$sql2 = "INSERT INTO core_rel_tipouser_permissao(id_tipo,id_perm) 
								VALUES(:id, :id_perm);";
								$stmt = $conn->prepare($sql2);
								$insert = $stmt->execute([
									':id' => $id,
									':id_perm' => $arr[$i]['id']
								]);
								if ($insert) {
									$contador++;
								} else {
									$msg .= "Error record util: " . $sql2 . "<br>" . $insert['msg'];
									$val = 2;
								}
							} catch (PDOException $e) {
								echo "Error fetching data: " . $e->getMessage();
							}
						}
					}
				} catch (PDOException $e) {
					echo "Error fetching data: " . $e->getMessage();
				}
			} else {
				$contador++;
			}
		}
		if ($contador == count($arr)) {
			$msg .= "Permissões actualizadas com sucesso.";
			$val = 1;
		} else {
			$msg .= "Erro nas contagens ".$contador." | ".count($arr);
			$val = 2;
		}
		echo json_encode(array("val" => $val, "msg" => $msg));
	}
}
