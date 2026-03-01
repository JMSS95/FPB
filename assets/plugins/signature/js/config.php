<?php


$con=mysqli_connect("localhost","root","AlentApp@2015","cnc20");
/* check connection */
if (mysqli_connect_errno()) {
    printf("Connect failed: %s\n", mysqli_connect_error());
    exit();
}


    mysqli_set_charset($con,"utf8");



?>



