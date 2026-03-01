// Função que carrega a lista de utilizadores
function loadusers(esc){
    $.ajax({
        type    : 'POST',
        url     : 'connect.php',
        headers: {
            "Authorization": "Bearer " + md5(localStorage.getItem('sessionObject'))
        },
        data    : {package: overal({origin: 'module/core/php/utilizadoresdb.php', function: "loadusers", attr: esc})},
        success : function(response) {
            var res = pars(JSON.parse(response));
            $("#info"+esc+"2").hide("slow");
            $("#info"+esc+"2").html("");
            $("#info"+esc+"1").show("slow");
            $("#info"+esc+"1").html(res['msg']);
            $("#currentbtn").html(res['btn']);
            createDataTable("main"+esc+"1");
        }
    });
}

async function toggleDropdown(row) {
    // Fecha outros dropdowns
    $('ul.hidden-dropdown').hide();
    // Localiza o dropdown associado à linha clicada
    const dropdown = $(row).find('td ul.hidden-dropdown');
  
    if (dropdown.length) {
        dropdown.toggle(); // Alternar visibilidade
    } else {
        console.warn('Nenhum dropdown encontrado nesta linha.');
    }
}

// Função do modal de adicionar e editar utilizador
function modfunc(id,esc){
  $.ajax({
    type    : 'POST',
    url     : 'connect.php',
    headers: {
        "Authorization": "Bearer " + md5(localStorage.getItem('sessionObject'))
    },
    data    : {package: overal({origin: 'module/core/php/utilizadoresdb.php', function: "modfunc", attr: JSON.stringify({id: id,esc:esc})})},
    success : function(response) {
      var res = pars(JSON.parse(response));
      drawer('right', res['msg'], res['titulo'], '70%', res['footer']);
      $("#cor").change(function(){
        $('#hexacode').html($('#cor').val());
      });
      $(".default-select2").select2({dropdownParent: $('#divModalTab')});
      if(esc==2){
        $('#cod').val(res['arr']['cod']);
        $('#nome').val(res['arr']['nome']);
        $("#idtipouser").val(res['arr']['idtipouser']).trigger("change");
        $("#idfuncao").val(res['arr']['idfuncao']).trigger("change");
        $('#email').val(res['arr']['email']);
        $('#contacto').val(res['arr']['contacto']);
        $("#idtipocont").val(res['arr']['idtipocont']).trigger("change");
        $("#cor").val(res['arr']['cor']).trigger("change");
        $('#hexacode').html(res['arr']['cor']);
        $("#idhl").val(res['arr']['idhl']).trigger("change");
        $("#idsexo").val(res['arr']['idsexo']).trigger("change");
        if(perm['core']['utilizadores']['Editar']){
          $("#btnmod").attr("onclick","guardar("+res['arr']['id']+",2)");
          $("#btnmod").show();
        }else{
          $("#btnmod").hide();
        }
      }else{
          $('#hexacode').html("#000000");
          $("#btnmod").attr("onclick","guardar(0,1)");
      }
      $("#pass1").on("keyup",function(){
        $.getScript("js/expression.js", function(){
          var pass1 = $("#pass1").val();
          var pass2 = $("#pass2").val();
          var alfa = matchExpression(pass1.replace(/[^\w\s]/gi, ''));
          if(alfa['mixOfAlphaNumeric'] !== false  && pass1.length >= 8){
            $('#passlog').html("<span style='color:green;font-weight:bold;'>A password introduzida preenche os requisitos obrigatórios.</span>");
            $("#pass2").removeAttr("disabled");
            if(pass1 == pass2){
              $('#passlog').html("<span style='color:green;font-weight:bold;'>Ambas as passwords introduzidas são iguais.</span>");
              $("#btnmod").removeAttr("disabled");
            }else{
              $('#passlog').html("<span style='color:red;font-weight:bold;'>As passwords introduzidas não são iguais.</span>");
              $("#btnmod").attr("disabled","true");
            }
          }else{
            $('#passlog').html("<span style='color:red;font-weight:bold;'>A password introduzida não preenche os requisitos obrigatórios.</span>");
            $("#pass2").attr("disabled","true");
            $("#pass2 ").val("");
            if(pass1.length > 0){
              $("#btnmod").attr("disabled","true");
            }else if(pass1.length == 0) {
              $('#passlog').html("");
              $("#btnmod").removeAttr("disabled");
            }
          }
        });
      });
      $("#pass2").on("keyup",function(){
        var pass1 = $("#pass1").val();
        var pass2 = $("#pass2").val();
        if(pass1 == pass2){
          $('#passlog').html("<span style='color:green;font-weight:bold;'>Ambas as passwords introduzidas são iguais.</span>");
          $("#btnmod").removeAttr("disabled");
        }else{
          $('#passlog').html("<span style='color:red;font-weight:bold;'>As passwords introduzidas não são iguais.</span>");
          $("#btnmod").attr("disabled","true");
        }
      });
      $(document).ready(function() {
        $('#id_tipouser').select2({
            width: '100%',
            dropdownParent: $("#swal-utilizador")
        });
        $('#id_funcao').select2({
            width: '100%',
            dropdownParent: $("#swal-utilizador")
        });
        $('#id_departamento').select2({
            width: '100%',
            dropdownParent: $("#swal-utilizador")
        });
        $('#id_sexo').select2({
            width: '100%',
            dropdownParent: $("#swal-utilizador")
        });
    });
    }
  });
}

// Função que adicionar e edita o utilizador
async function guardar(id, esc) {
    var info = {};
    var msg = id == 0 ? "Utilizador registado com sucesso" : "Dados do utilizador atualizados com sucesso";
    let error = false;

    let cod = $("#cod").val();
    let nome = $("#nome").val();
    let id_tipouser = $("#id_tipouser").val();
    let id_funcao = $("#id_funcao").val();
    let id_departamento = $("#id_departamento").val();
    let email = $("#email").val();
    let contacto = $("#contacto").val();
    let cor = $("#cor").val();
    let id_sexo = $("#id_sexo").val();

    if(cod) {
        info['cod'] = cod;
    }else{
        toaster('O Nº é obrigatório!', 'warning');
        error = true;
    }

    if(nome) {
        info['nome'] = nome;
    }else{
        toaster('O Nome é obrigatório!', 'warning');
        error = true;
    }

    if(id_tipouser && id_tipouser != 0) {
        info['id_tipouser'] = id_tipouser;
    }else{
        toaster('O tipo é obrigatório!', 'warning');
        error = true;
    }

    if(id_funcao && id_tipouser != 0) {
        info['id_funcao'] = id_funcao;
    }else{
        toaster('A função obrigatória!', 'warning');
        error = true;
    }

    if(id_departamento && id_departamento != 0) {
        info['id_departamento'] = id_departamento;
    }else{
        toaster('O departamento obrigatório!', 'warning');
        error = true;
    }

    if(id_sexo && id_sexo != 0) {
        info['id_sexo'] = id_sexo;
    }else{
        toaster('O género obrigatório!', 'warning');
        error = true;
    }

    if(email) {
        info['email'] = email;
    }else{
        toaster('O email é obrigatório!', 'warning');
        error = true;
    }

    if(contacto) {
        info['contacto'] = contacto;
    }else{
        toaster('O contacto é obrigatório!', 'warning');
        error = true;
    }

    info['cor'] = cor;

    if (!error) {
        // Verificar a password
        let pass1 = $("#pass1").val();
        let pass = $("#pass2").val();
        if(pass.length > 0) {
            info['pass'] = md5(pass);
        }
        if(pass1.length > 0 && pass1 != pass) {
            toaster('As passwords não coincidem!', 'warning');
        }else{
            var formData = new FormData();
            formData.append('package',overal({origin:'module/core/php/utilizadoresdb.php',function: 'guardar',attr: JSON.stringify({ info, id, esc })}));
        
            $.ajax({
                type    : 'POST',
                url     : 'connect.php',
                headers: {
                    "Authorization": "Bearer " + md5(localStorage.getItem('sessionObject'))
                },
                data: formData,
                processData: false,
                contentType: false
            }).done(function (response) {
                var res = pars(JSON.parse(response));
                if (res['val'] == 1) {
                    Swal.close();
                    toaster(msg, 'success');
                    loadusers(1);
                } else {
                    toaster(res['msg'], 'error');
                }
            }).fail(function (jqXHR, textStatus) {
                moderr("Request failed: " + textStatus);
            });
        }
    }
}

// Função para desativar e ativar os utilizadores
function desact(iduser,esc){
  $.ajax({
      type    : 'POST',
      url     : 'connect.php',
      headers: {
          "Authorization": "Bearer " + md5(localStorage.getItem('sessionObject'))
      },
      data    : {package: overal({origin: 'module/core/php/utilizadoresdb.php', function: "desact", attr: JSON.stringify({id: iduser,esc: esc})})},
      success : function(response) {
      var res = pars(JSON.parse(response));
      if(res['val'] == 1){
        modsuc(res['msg']);
      $("#btntab1").click();
      }else{
        moderr(res['msg']);
      }
    }
  });
}