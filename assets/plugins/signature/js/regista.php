<?php
include_once("config.php");

$assinatura = $_POST['sig'];
$nome = $_POST['nome'];
$texto = $_POST['texto'];


//$nome = json_decode($nome);

$sql= "INSERT INTO depoimento (id,nome,texto,sig) VALUES (NULL,'$nome','$texto','$assinatura')";

mysqli_query($con,$sql);


header("Location: http://teste.alentapp.pt/cnc20");