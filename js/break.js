modinf("A sua sessão expirou por questões de segurança.<br>Caso esteja a preencher um formulário, os dados inseridos não serão guardados.<br>Tentaremos reencaminhá-lo para a página atual, caso não seja possível irá para a página de login.<br>Poderá ter que fazer novo login.");
localStorage.clear();
setTimeout(function(){
	if(window.location.href.indexOf("login.h") > -1){
	}else{
	  	window.location.assign('./login.html');
	}
},1500);