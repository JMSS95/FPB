var utilizador = 0;
var userlogin = 0;
var tipoutilizador = 0;
var nomeutilizador = 0;
var perm = [];
var empresa = [];
var lostid = 0;
var newtemporal = new Date().valueOf();
var bearer = "";
var inicio = 0;
var pausas = 0;

function runheaders() {
  $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization:
        "Bearer " +
        md5(
          localStorage.getItem("sessionObject")
            ? localStorage.getItem("sessionObject")
            : " ",
        ),
    },
    data: {
      package: overal({
        origin: "php/checkdb.php",
        function: "runheaders",
        attr: JSON.stringify({}),
      }),
    },
  })
    .done(function (response) {
      var obj = pars(JSON.parse(response));
      empresa = obj;
      $("#plattitle").html("OK4" + obj["nome"]);
      $("#platicon").attr("href", obj["icon"]);
      $("#platheader").html(obj["nome"]);
      if ($("#footeremp").length > 0) {
        $("#footeremp").html(obj["nome"]);
      }
      if ($("#sideemp").length > 0) {
        $("#sideemp").html(obj["nome"]);
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}

function checkfooter() {
  if ($("#footer").length) {
    $("#footer").html("");
  } else {
    setTimeout(function () {
      checkfooter();
    }, 500);
  }
}

function runcheck() {
  if (localStorage.getItem("sessionObject")) {
    var sessionObject = localStorage.getItem("sessionObject").split(".");
    sessionObject = JSON.parse(getBase64Decode(sessionObject[1]));
    var sessionPages = localStorage.getItem("sessionPages").split(".");
    sessionPages = JSON.parse(getBase64Decode(sessionPages[1]));
    $.ajax({
      type: "POST",
      url: "connect.php",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: {
        package: overal({
          origin: "php/checkdb.php",
          function: "runcheck",
          attr: JSON.stringify({ session: sessionObject }),
        }),
      },
    })
      .done(function (response) {
        var res = pars(JSON.parse(response));
        if (res["val"] == 1) {
          utilizador = sessionObject.utilizador;
          userlogin = sessionObject.login;
          tipoutilizador = sessionObject.tipoutilizador;
          nomeutilizador = sessionObject.nomeutilizador;
          perm = sessionObject.perm;
          $("#dash").attr(
            "onclick",
            "loadpage('module/core/dashboard.html',0,1)",
          );
          $("#dashtop").attr(
            "onclick",
            "loadpage('module/core/dashboard.html',0,1)",
          );
          $("#username").html(nomeutilizador);
          $("#useremail").html(nomeutilizador);
          if (parseInt(sessionObject.tipoesp) == 1) {
            $("#btneditarperfil").show();
            $("#btngerarqr").show();
            $("#divdivider").show();
            if (parseInt(tipoutilizador) == 1) {
              $("#btnmessage").show();
              $("#idhelp").show();
            }
          } else {
            $("#btneditarperfil").show();
            $("#divdivider").show();
          }
          if (sessionObject.img == "") {
            $("#userimg").html("<i class='fa fa-user'></i>");
            $("#userimg2").html("<i class='fa fa-user'></i>");
          } else {
            $("#userimg").html(
              "<img src='" +
                sessionObject.img +
                "' style='width:100%;height:100%;object-fit: cover;' onerror=\"this.onerror=null;this.parentNode.innerHTML='<i class=&quot;fa fa-user&quot;></i>'\">",
            );
            $("#userimg2").html(
              "<img src='" +
                sessionObject.img +
                "' style='width:100%;height:100%;margin-top:0px;object-fit: cover;' onerror=\"this.onerror=null;this.parentNode.innerHTML='<i class=&quot;fa fa-user&quot;></i>'\">",
            );
          }
          // Criar menu
          var menu = sessionObject.menu;
          var menuHtml = ``;
          let lastModule = 0;
          let menuLevel0 = menu.filter((item) => Number(item.sub) == 0);
          let menuLevels = menu.filter((item) => Number(item.sub) != 0);
          for (let index = 0; index < menuLevel0.length; index++) {
            let menuData = menuLevel0[index];
            // Quando é novo modulo criar novo menu
            menuHtml += `
                    <li style="cursor:pointer;" id="menu${menuData.sub}${menuData.page}" >
                        <a onclick="loadpage('${menuData.url}',${menuData.sub},${menuData.page})" >
                            <i class="${menuData.icon}" title="Home"></i>
                            <span>${menuData.descricao}</span>
                        </a>
                    </li>
                    `;
          }
          for (let index = 0; index < menuLevels.length; index++) {
            let menuData = menuLevels[index];
            // Quando é novo modulo criar novo menu
            if (lastModule != Number(menuData.id_module)) {
              lastModule = Number(menuData.id_module);
              menuHtml += `
                        <li class="has-sub closed" id="sub${lastModule}" style="cursor: pointer;">
                            <a href="javascript:void(0);" onClick='handleMenu("sub${lastModule}", event)'>
                                <b class="caret"></b>
                                <i class="${menuData.icon_module}"></i>
                                <span id="module">${menuData.descricao_module}</span>
                            </a>
                        `;
              // if(menu.filter(item => item.sub === lastModule).length > 1) {
              menuHtml += `<ul class="sub-menu" style='display:none;'>`;
              // }
            }

            // if(menu.filter(item => item.sub === lastModule).length > 1) {
            menuHtml += `
                            <li id="menu${menuData.sub}${menuData.page}" style="cursor: pointer;">
                                <a onclick="loadpage('${menuData.url}',${menuData.sub},${menuData.page})"><i class="${menuData.icon} text-theme m-l-5" title="${menuData.descricao}"></i> ${menuData.descricao}
                                </a>
                            </li>
                        `;
            // }

            // Fechar o menu quando vai para outro modulo
            if (menuLevels.length > index + 1) {
              if (lastModule != Number(menuLevels[index + 1].id_module)) {
                menuHtml += "</ul></li>";
              }
            } else {
              menuHtml += "</ul></li>";
            }
          }
          $("#nav-menu").html(menuHtml);
          $(document).on("click", ".sub-menu li", function (event) {
            event.stopPropagation();
          });
          // buildlang(sessionObject.lang, sessionPages.page);
          if (sessionPages.sub != 0) {
            $("#sub" + sessionPages.sub)
              .addClass("expand")
              .children(".sub-menu")
              .show();
          }
          $("#menu" + sessionPages.sub + "" + sessionPages.page).addClass(
            "active",
          );
          if (res["assi"] == 0) {
            $("#customsidemenu").hide();
          } else if (res["assi"] == 1) {
            //<button type='button' class='btn btn-success' onclick='addAssiManu("+sessionObject.utilizador+",2)' disabled='true'><i class='fa fa-play'></i> Retomar</button>
            $("#countingtimer").html("");
            $("#countingtimer_li").hide();
            // $("#customsidemenupanel").html("<button type='button' class='btn btn-warning btn-lg' onclick='addAssiManu(" + sessionObject.utilizador + ",1)' style='margin-left:70px;'><i class='fa fa-pause'></i> Pausa</button>");
          } else {
            //<button type='button' class='btn btn-warning' onclick='addAssiManu("+sessionObject.utilizador+",1)' style='margin-left:37px;margin-right:5px;' disabled='true'><i class='fa fa-pause'></i> Pausa</button>
            $("#countingtimer").html(
              "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;A sua <b>PAUSA</b> encontram-se a ativa.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;",
            );
            $("#countingtimer_li").show();
            // $("#customsidemenupanel").html("<button type='button' class='btn btn-success btn-lg' onclick='addAssiManu(" + sessionObject.utilizador + ",2)' style='margin-left:65px;'><i class='fa fa-play'></i> Retomar</button>");
          }
          if (
            window.location.href.indexOf("index.h") > -1 ||
            window.location.href.indexOf("login.h") > -1
          ) {
            window.location.assign("index.html?v=" + newtemporal);
          } else if (
            window.location.href.indexOf("func.html") > -1 &&
            tipoutilizador > 2
          ) {
            window.location.assign("index.html?v=" + newtemporal);
          }
          inicio = parseInt(res["inicio"]);
          pausas = parseInt(res["pausas"]);
        } else {
          localStorage.clear();
          if (window.location.href.indexOf("login.h") > -1) {
          } else {
            window.location.assign("login.html");
          }
        }
      })
      .fail(function (jqXHR, textStatus) {
        moderr("Request failed: " + textStatus);
      });
  } else {
    if (window.location.href.indexOf("login.h") > -1) {
    } else {
      window.location.assign("login.html");
    }
  }
}

function handleMenu(menuId, event) {
  if (event) {
    event.stopPropagation(); // Bloqueia a propagação do clique para evitar fechamento indesejado
  }

  var $menu = $("#" + menuId); // Seleciona o <li> pelo ID
  var $submenu = $menu.find(".sub-menu"); // Encontra o submenu dentro do <li>

  // Se o submenu estiver visível, fecha e troca as classes
  if ($submenu.is(":visible")) {
    $submenu.slideUp();
    $menu.removeClass("expand").addClass("closed"); // Alterna classes
  } else {
    $(".sub-menu").slideUp(); // Fecha todos os outros submenus
    $(".has-sub").removeClass("expand").addClass("closed"); // Reseta outros menus

    $submenu.slideDown(); // Abre o submenu clicado
    $menu.removeClass("closed").addClass("expand"); // Alterna classes
  }
}

setTimeout(function () {
  keepReloading(0);
  checkfooter();
  worktimer();
}, 500);
// Login----------------------------------------------------->
function login() {
  var user = $("#user").val();
  var pass = md5($("#pass").val());
  var sessionObject = {};
  var sessionPages = {};
  $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization:
        "Bearer " +
        md5(
          localStorage.getItem("sessionObject")
            ? localStorage.getItem("sessionObject")
            : " ",
        ),
    },
    data: {
      package: overal({
        origin: "php/checkdb.php",
        function: "login",
        attr: JSON.stringify({ user: user, pass: pass }),
      }),
    },
  })
    .done(function (response) {
      var obj = pars(JSON.parse(response));
      console.log(obj);
      if (obj["val"] == 1) {
        var pagina = 0;
        lostid = obj["login"];
        sessionObject = {
          comp: obj["comp"],
          email: obj["email"],
          empresa: obj["empresa"],
          img: obj["img"],
          last: obj["last"],
          login: obj["login"],
          logo: obj["logo"],
          main: obj["main"],
          menu: obj["menu"],
          nomeutilizador: obj["nome"],
          perm: obj["perm"],
          timer: obj["timer"],
          tipoesp: obj["tipoesp"],
          tipoutilizador: obj["tipo"],
          utilizador: obj["user"],
          lang: obj["lang"],
          fix: obj["fix"],
        };
        sessionPages = {
          link: obj["main"],
          page: pagina,
          sub: 0,
        };
        sessionObject = overall(sessionObject);
        sessionPages = overall(sessionPages);
        regOverall(sessionObject, sessionPages);
      } else {
        moderr(obj["msg"]);
        $("#pass").val("");
        $("#user").val("");
        $("#user").focus();
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}

function regOverall(sessionObject, sessionPages) {
  $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization:
        "Bearer " +
        md5(
          localStorage.getItem("sessionObject")
            ? localStorage.getItem("sessionObject")
            : " ",
        ),
    },
    data: {
      package: overal({
        origin: "php/checkdb.php",
        function: "regOverall",
        attr: JSON.stringify({ sessionObject: sessionObject }),
      }),
    },
  })
    .done(function (response) {
      var obj = pars(JSON.parse(response));

      localStorage.setItem("sessionObject", JSON.stringify(sessionObject));
      localStorage.setItem("sessionPages", JSON.stringify(sessionPages));
      var sessionObject_temp = localStorage.getItem("sessionObject").split(".");
      sessionObject_temp = JSON.parse(getBase64Decode(sessionObject_temp[1]));
      $.ajax({
        type: "POST",
        url: "connect.php",
        headers: {
          Authorization:
            "Bearer " +
            md5(
              localStorage.getItem("sessionObject")
                ? localStorage.getItem("sessionObject")
                : " ",
            ),
        },
        data: {
          package: overal({
            origin: "php/checkdb.php",
            function: "getSessionMessage",
            attr: JSON.stringify({ id_user: sessionObject_temp["utilizador"] }),
          }),
        },
      })
        .done(function (response) {
          var obj = pars(JSON.parse(response));
          if (obj.val == 1) {
            let selected = null;
            // Filtrar pelo tipo Login
            let filterS = obj.sessionMessage.filter(
              (item) => item.type == "start",
            );
            let filterGeral = filterS.filter(
              (item) =>
                !item.user && item.type_event == null && item.date == null,
            );
            let filterEvent = filterS.filter(
              (item) => !item.user && item.type_event != null,
            );
            let filterDate = filterS.filter(
              (item) => !item.user && item.date != null,
            );
            let filterGeralUser = filterS.filter((item) => item.user);
            let filterEventUser = filterS.filter(
              (item) => item.user && item.type_event != null,
            );
            let filterDateUser = filterS.filter(
              (item) => item.user && item.date != null,
            );
            selected =
              filterDateUser.length > 0
                ? filterDateUser
                : filterEventUser.length > 0
                  ? filterEventUser
                  : filterDate.length > 0
                    ? filterDate
                    : filterEvent.length > 0
                      ? filterEvent
                      : filterGeralUser.length > 0
                        ? filterGeralUser
                        : filterGeral;

            if (selected != null && selected.length != 0) {
              // 'birthday','christmas','new year'
              let position = Math.floor(Math.random() * selected.length);
              let title =
                selected[position]?.type_event == "birthday"
                  ? "Feliz Aniversário!"
                  : selected[position]?.type_event == "christmas"
                    ? "Feliz Natal!"
                    : selected[position]?.type_event == "new year"
                      ? "Feliz Ano Novo!"
                      : "Bem vindo!";
              new oldSwal({
                title: title,
                text: selected[position]?.message,
                icon:
                  selected[position]?.emoji == null ||
                  selected[position]?.emoji == ""
                    ? "success"
                    : null,
                timer: 3000,
                buttons: {},
                content: {
                  element: "span",
                  attributes: {
                    innerHTML: selected[position]?.emoji
                      ? `<span style="font-size: 5em;">${selected[position]?.emoji}</span>`
                      : "",
                  },
                },
              });
            } else {
              modsuc(
                "Login Efectuado com Sucesso.<br>Bem-vindo " +
                  sessionObject_temp["nomeutilizador"],
              );
            }
            setTimeout(function () {
              window.open("index.html?v=" + newtemporal, "_self");
            }, 3000);
            // setTimeout(function () { loadpage('module/core/dashboard.html',0,0); }, 3200);
            // setTimeout(function () { window.open('/aernnova_pintura/module/core/dashboard.html', "_self"); }, 3000);
          } else {
            modsuc(
              "Login Efectuado com Sucesso.<br>Bem-vindo " +
                sessionObject_temp["nomeutilizador"],
            );
            toaster("Erro a ir buscar mensagem de sessão!", "warning");
            setTimeout(function () {
              window.open("index.html?v=" + newtemporal, "_self");
            }, 3000);
            // setTimeout(function () { loadpage('module/core/dashboard.html',0,0); }, 3200);
            // setTimeout(function () { window.open('/aernnova_pintura/module/core/dashboard.html', "_self"); }, 3000);
          }
        })
        .fail(function (jqXHR, textStatus) {
          moderr("Request failed: " + textStatus);
        });
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}

// Logout ------------------------------------------------------>
function logout() {
  $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization:
        "Bearer " +
        md5(
          localStorage.getItem("sessionObject")
            ? localStorage.getItem("sessionObject")
            : " ",
        ),
    },
    data: {
      package: overal({
        origin: "php/checkdb.php",
        function: "getSessionMessage",
        attr: JSON.stringify({ id_user: utilizador }),
      }),
    },
  })
    .done(function (response) {
      var obj = pars(JSON.parse(response));
      if (obj.val == 1) {
        let selected = null;
        // Filtrar pelo tipo Login
        let filterS = obj.sessionMessage.filter((item) => item.type == "end");
        let filterGeral = filterS.filter(
          (item) => !item.user && item.type_event == null && item.date == null,
        );
        let filterEvent = filterS.filter(
          (item) => !item.user && item.type_event != null,
        );
        let filterDate = filterS.filter(
          (item) => !item.user && item.date != null,
        );
        let filterGeralUser = filterS.filter((item) => item.user);
        let filterEventUser = filterS.filter(
          (item) => item.user && item.type_event != null,
        );
        let filterDateUser = filterS.filter(
          (item) => item.user && item.date != null,
        );
        selected =
          filterDateUser.length > 0
            ? filterDateUser
            : filterEventUser.length > 0
              ? filterEventUser
              : filterDate.length > 0
                ? filterDate
                : filterEvent.length > 0
                  ? filterEvent
                  : filterGeralUser.length > 0
                    ? filterGeralUser
                    : filterGeral;
        if (selected != null && selected.length != 0) {
          // 'birthday','christmas','new year'
          let position = Math.floor(Math.random() * selected.length);
          let title =
            selected[position]?.type_event == "birthday"
              ? "Feliz Aniversário!"
              : selected[position]?.type_event == "christmas"
                ? "Feliz Natal!"
                : selected[position]?.type_event == "new year"
                  ? "Feliz Ano Novo!"
                  : "Logout!";
          new oldSwal({
            title: title,
            text: selected[position]?.message,
            icon:
              selected[position]?.emoji == null ||
              selected[position]?.emoji == ""
                ? "success"
                : null,
            timer: 3000,
            buttons: {},
            content: {
              element: "span",
              attributes: {
                innerHTML: selected[position]?.emoji
                  ? `<span style="font-size: 5em;">${selected[position]?.emoji}</span>`
                  : "",
              },
            },
          });
        } else {
          modsuc("Sessão terminada com sucesso!");
        }
      } else {
        modsuc("Sessão terminada com sucesso!");
        toaster("Erro a ir buscar mensagem de sessão!", "warning");
      }
      setTimeout(() => {
        $.ajax({
          type: "POST",
          url: "connect.php",
          headers: {
            Authorization:
              "Bearer " + md5(localStorage.getItem("sessionObject")),
          },
          data: {
            package: overal({
              origin: "php/checkdb.php",
              function: "logout",
              attr: JSON.stringify({}),
            }),
          },
        })
          .done(function (response) {
            var obj = pars(JSON.parse(response));
            sessionPages = "";
            localStorage.clear();
            // socket(0);
            window.open("index.html?v=" + newtemporal, "_self");
            sessionObject = "";
          })
          .fail(function (jqXHR, textStatus) {
            moderr("Request failed: " + textStatus);
          });
      }, 3000);
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}

function buildlang(lang, page) {
  $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: {
      package: overal({
        origin: "php/checkdb.php",
        function: "buildlang",
        attr: JSON.stringify({ lang: lang, page: page }),
      }),
    },
  })
    .done(function (response) {
      var obj = pars(JSON.parse(response));
      $("#divlang").html(obj["msg"]);
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}

function changelang(lang) {
  $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: {
      package: overal({
        origin: "php/checkdb.php",
        function: "changelang",
        attr: JSON.stringify({ lang: lang }),
      }),
    },
  })
    .done(function (response) {
      var obj = pars(JSON.parse(response));
      if (obj["val"] == 1) {
        var sessionObject = localStorage.getItem("sessionObject").split(".");
        sessionObject = JSON.parse(getBase64Decode(sessionObject[1]));
        sessionObject.lang = lang;
        sessionObject = overall(sessionObject);
        localStorage.setItem("sessionObject", JSON.stringify(sessionObject));
        location.reload();
      } else {
        moderr(obj["msg"]);
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}

function logoutaction() {
  var sessionObject = localStorage.getItem("sessionObject").split(".");
  sessionObject = JSON.parse(getBase64Decode(sessionObject[1]));
  $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: {
      package: overal({
        origin: "php/checkdb.php",
        function: "logoutaction",
        attr: JSON.stringify({ iduser: sessionObject["utilizador"] }),
      }),
    },
  })
    .done(function (response) {
      var obj = pars(JSON.parse(response));
      if (obj["val"] == 1) {
        var data = new Date();
        modLogout(
          "Por favor, indique se continuará a trabalhar, se iniciará uma pausa ou se pretende encerrar o dia de trabalho.",
          "logout()",
          "desloassi(" + sessionObject["utilizador"] + ",2,1)",
          "modCloseDay(" +
            sessionObject["utilizador"] +
            ',"' +
            data.getFullYear() +
            "-" +
            Number(data.getMonth() + 1) +
            "-" +
            data.getDate() +
            '")',
        );
      } else {
        logout(); //novo
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}

// função para utilizar o Enter no LogIn
$(document).keyup(function (event) {
  if ($("#pass").is(":focus") && event.key == "Enter") {
    login();
  }
});

function toaster(msg, type, close = true) {
  var texto = "";
  if (msg != "" && msg != null) {
    texto = msg.split("<br>").join("\n");
  }

  toastr.options = {
    closeButton: true,
    debug: false,
    newestOnTop: false,
    progressBar: false,
    positionClass: "toast-top-right",
    preventDuplicates: false,
    onclick: null,
    showDuration: "1000",
    hideDuration: "1000",
    timeOut: close ? "3000" : "",
    extendedTimeOut: "2000",
    showEasing: "swing",
    hideEasing: "linear",
    showMethod: "fadeIn",
    hideMethod: "fadeOut",
  };
  var $toast = toastr[type](texto);
}

function modsuc(msg) {
  var texto = msg.split("<br>").join("\n");
  new oldSwal({
    title: "Sucesso!",
    text: texto,
    icon: "success",
    timer: 2500,
    buttons: {},
  });
}

function modinf(msg) {
  var texto = msg.split("<br>").join("\n");
  new oldSwal({
    title: "Informação",
    text: texto,
    icon: "info",
    timer: 2500,
    buttons: {},
  });
}

function moderr(msg) {
  var texto = "";
  if (msg != "" && msg != null) {
    texto = msg.split("<br>").join("\n");
  }
  new oldSwal({
    title: "Erro!",
    text: texto,
    icon: "error",
    timer: 2500,
    buttons: {},
  });
}

function modconf(msg, func, title = "Atenção!", funcCancel = null) {
  var texto = msg.split("<br>").join("\n");
  new oldSwal({
    title: title,
    text: texto,
    icon: "warning",
    buttons: {
      cancel: {
        text: "✕ Recusar",
        value: false,
        visible: true,
        className: "btn btn-secondary",
        closeModal: true,
      },
      confirm: {
        text: "✓ Confirmar",
        value: true,
        visible: true,
        className: "btn btn-success",
        closeModal: true,
      },
    },
    customClass: {
      popup: "swal-custom-popup",
    },
  }).then(async function (isConfirm) {
    if (isConfirm) {
      // Remove any previous onclick handlers
      $(".swal-button--confirm").removeAttr("onclick");

      // Assign the new onclick handler
      $(".swal-button--confirm").attr("onclick", func);

      // Trigger the click event
      $(".swal-button--confirm").click();
    } else {
      if (funcCancel) {
        funcCancel();
      }
    }
  });
}

function modconfAsync(msg, func, title = "Atenção!", funcCancel = null) {
  var texto = msg.split("<br>").join("\n");
  new oldSwal({
    title: title,
    text: texto,
    icon: "warning",
    buttons: {
      cancel: {
        text: "✕ Recusar",
        value: false,
        visible: true,
        className: "btn btn-secondary",
        closeModal: true,
      },
      confirm: {
        text: "✓ Confirmar",
        value: true,
        visible: true,
        className: "btn btn-success",
        closeModal: true,
      },
    },
  }).then(async function (isConfirm) {
    if (isConfirm) {
      await func();
    } else {
      if (funcCancel) {
        funcCancel();
      }
    }
  });
}

function modLogin(msg, func, func2) {
  new oldSwal({
    title: "Sucesso!",
    text: msg,
    icon: "success",
    buttons: {
      confirm: {
        text: "Sim",
        value: 1,
        visible: true,
        className: "btn btn-success btn-lg",
        closeModal: true,
      },
      confirm2: {
        text: "Não",
        value: 2,
        visible: true,
        className: "btn btn-danger btn-lg",
        closeModal: true,
      },
    },
  }).then(function (isConfirm) {
    if (isConfirm == 1) {
      $("#btnhidden").attr("onclick", func);
      $("#btnhidden").click();
    } else if (isConfirm == 2) {
      $("#btnhidden").attr("onclick", func2);
      $("#btnhidden").click();
    }
  });
}

function modLogout(msg, func1, func2, func3) {
  new oldSwal({
    title: "Escolha uma das opções",
    text: msg,
    icon: "info",
    buttons: {
      confirm: {
        text: "Continuar",
        value: 1,
        visible: true,
        className: "btn btn-info btn-lg fullbtn",
        closeModal: true,
      },
      confirm2: {
        text: "Pausa",
        value: 2,
        visible: true,
        className: "btn btn-warning btn-lg fullbtn",
        closeModal: true,
      },
      confirm3: {
        text: "Encerrar",
        value: 3,
        visible: true,
        className: "btn btn-success btn-lg fullbtn",
        closeModal: true,
      },
    },
  }).then(function (isConfirm) {
    if (isConfirm == 1) {
      $("#btnhidden").attr("onclick", func1);
      $("#btnhidden").click();
    } else if (isConfirm == 2) {
      $("#btnhidden").attr("onclick", func2);
      $("#btnhidden").click();
    } else if (isConfirm == 3) {
      $("#btnhidden").attr("onclick", func3);
      $("#btnhidden").click();
    }
  });
}

function loadpage(link, sub, page) {
  var retrievedObject = localStorage.getItem("sessionPages").split(".");
  retrievedObject = JSON.parse(getBase64Decode(retrievedObject[1]));
  retrievedObject.link = link;
  retrievedObject.sub = sub;
  retrievedObject.page = page;
  var sessionObject = overall(retrievedObject);
  localStorage.setItem("sessionPages", JSON.stringify(sessionObject));
  var url = window.location.href;
  var temporal = new Date().valueOf();
  var partir = url.split("index.html");
  window.history.pushState("", "", partir[0]);
  if (localStorage.getItem("sessionPages")) {
    if (localStorage.getItem("sessionPages").indexOf(".")) {
      retrievedObject = localStorage.getItem("sessionPages").split(".");
      retrievedObject = JSON.parse(getBase64Decode(retrievedObject[1]));
    } else {
      retrievedObject = JSON.parse(localStorage.getItem("sessionPages"));
    }
    $("#page").empty();
    if (retrievedObject.link == "") {
      $("#page").load("module/core/dashboard.html?v=" + temporal);
    } else {
      $("#page").load(
        retrievedObject.link + "?v=" + temporal,
        function (responseTxt, statusTxt, xhr) {
          if (statusTxt == "success") {
          } else {
            $("#page").load("module/core/dashboard.html?v=" + temporal);
          }
        },
      );
    }
    $("li.has-sub").each(function (index) {
      if (
        $(this).hasClass("expand") &&
        $(this).attr("id") != "sub" + retrievedObject.sub
      ) {
        $(this).removeClass("expand").addClass("closed");
      }
    });
    $("ul.sub-menu").hide();
    $("li").removeClass("active");
    if (retrievedObject.sub != 0) {
      $("#sub" + retrievedObject.sub)
        .addClass("expand")
        .children(".sub-menu")
        .show();
    }
    $("#menu" + retrievedObject.sub + "" + retrievedObject.page).addClass(
      "active",
    );
    retrievedObject = JSON.parse(
      getBase64Decode(localStorage.getItem("sessionObject").split(".")[1]),
    );
    perm = retrievedObject.perm;
    retrievedObject = "";
  } else {
    localStorage.clear();
    window.location.assign("login.html");
  }
}

function perfil() {
  $("#addfase").modal("hide");
  $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: {
      package: overal({
        origin: "php/checkdb.php",
        function: "perfil",
        attr: "",
      }),
    },
  })
    .done(function (response) {
      var obj = pars(JSON.parse(response));
      drawer("left", obj["msg"], "Perfil");
      $("#drawerFooterBtn").attr("onclick", obj["btnFooter"]);
      if (obj["tipoesp"] == 1) {
        $("#contacto").val(obj["arr"]["contacto"]);
        $("#colabimg").attr("src", obj["arr"]["img"]);
        $("#inputimg").change(function () {
          if ($("#inputimg").val() != "") {
            uploadcheck("inputimg", 1);
          }
        });
      } else if (obj["tipoesp"] == 4) {
        $("#contacto").val(obj["arr"]["contacto"]);
        $("#noti_email" + obj["arr"]["noti_email"]).attr("checked", "true");
      }
      $("#nome").val(obj["arr"]["nome"]);
      $("#email").val(obj["arr"]["email"]);
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}

//editar perfil
function regPerfil(id, tipo) {
  var info = {};
  var errorMsg = "";
  var error = false;
  info["iduser"] = id;
  info["tipo"] = tipo;
  var nome = $("#nome").val();
  if (nome) {
    info["nome"] = nome;
  } else {
    errorMsg += "O campo do Nome encontra-se inválido ou vazio.\n";
    error = true;
  }
  var email = $("#email").val();
  if (email) {
    info["email"] = email;
  } else {
    errorMsg += "O campo do Email encontra-se inválido ou vazio.\n";
    error = true;
  }
  var contacto = $("#contacto").val();
  if (contacto) {
    info["contacto"] = contacto;
  } else {
    errorMsg += "O campo do contacto encontra-se inválido ou vazio.\n";
    error = true;
  }
  if (tipo == 4) {
    var noti_email = $("input[name=noti_email]:checked").val();
    if (noti_email) {
      info["noti_email"] = noti_email;
    } else {
      info["noti_email"] = 0;
    }
  }
  info["pwd"] = "";
  if (error) {
    toaster(errorMsg, "error");
  } else {
    $.ajax({
      type: "POST",
      url: "connect.php",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: {
        package: overal({
          origin: "php/checkdb.php",
          function: "regPerfil",
          attr: JSON.stringify(info),
        }),
      },
    })
      .done(function (response) {
        var obj = pars(JSON.parse(response));
        if (obj["val"] == 1) {
          $("#jjamodalperfil").modal("hide");
          toaster(obj["msg"], "success");
          setTimeout(function () {
            perfil();
          }, 1500);
        } else {
          toaster(obj["msg"], "error");
        }
      })
      .fail(function (jqXHR, textStatus) {
        toaster("Request failed: " + textStatus, "error");
      });
  }
}

function uploadInfoImg(ident) {
  //carregamento de ficheiros
  var file = document.getElementById("inputimg").files;
  if (file.length != 0) {
    var formData = new FormData();
    // formData.append('origin', 'php/utilizadoresdb.php');
    // formData.append('function', 'uploadInfo');
    // formData.append('attr', JSON.stringify({ id: ident, esc: 1 }));
    formData.append("file0", file[0]);
    formData.append(
      "package",
      overal({
        origin: "php/utilizadoresdb.php",
        function: "uploadInfo",
        attr: JSON.stringify({ id: ident, esc: 1 }),
      }),
    );
    $.ajax({
      type: "POST",
      url: "connect.php",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: formData,
      processData: false, // tell jQuery not to process the data
      contentType: false, // tell jQuery not to set contentType
    })
      .done(function (response) {
        var obj = pars(JSON.parse(response));
        if (parseInt(obj["val"]) == 1) {
          $("#jjamodalperfil").modal("hide");
          modsuc("Imagem alterada com sucesso.");
          setTimeout(function () {
            perfil();
          }, 500);
        } else {
          moderr(obj["msg"]);
        }
      })
      .fail(function (jqXHR, textStatus) {
        moderr(textStatus);
      });
  } else {
    moderr("Sem ficheiro selecionado.");
  }
}

function changepass(id, esc) {
  if (esc == 1) {
    $("#jjamodalperfil").modal("hide");
    $.ajax({
      type: "POST",
      url: "connect.php",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: {
        package: overal({
          origin: "php/checkdb.php",
          function: "changepass",
          attr: JSON.stringify({ id: id, esc: esc }),
        }),
      },
    })
      .done(function (response) {
        var obj = pars(JSON.parse(response));
        $("#addfase").html(obj["msg"]).modal("show");
        $("#passori").on("keyup", function () {
          var passori = $("#passori").val();
          if (md5(passori) == obj["n"]) {
            $("#passlog").html(
              "<span style='color:green;font-weight:bold;'>Password original validada.</span>",
            );
            $("#pass1").removeAttr("disabled");
            $("#pass2").attr("disabled", "true");
          } else {
            $("#passlog").html(
              "<span style='color:red;font-weight:bold;'>A Password introduzida não é a actual.</span>",
            );
            $("#pass1").attr("disabled", "true");
            $("#pass2").attr("disabled", "true");
          }
        });

        $("#pass1").on("keyup", function () {
          $.getScript("js/expression.js", function () {
            var pass1 = $("#pass1").val();
            var alfa = matchExpression(pass1.replace(/[^\w\s]/gi, ""));
            if (alfa["mixOfAlphaNumeric"] !== false && pass1.length >= 8) {
              $("#passlog").html(
                "<span style='color:green;font-weight:bold;'>A password introduzida preenche os requisitos obrigatórios.</span>",
              );
              $("#pass2").removeAttr("disabled");
            } else {
              $("#passlog").html(
                "<span style='color:red;font-weight:bold;'>A password introduzida não preenche os requisitos obrigatórios.</span>",
              );
              $("#pass2").attr("disabled", "true");
            }
          });
        });
        $("#pass2").on("keyup", function () {
          var pass1 = $("#pass1").val();
          var pass2 = $("#pass2").val();
          if (pass1 == pass2) {
            $("#passlog").html(
              "<span style='color:green;font-weight:bold;'>Ambas as passwords introduzidas são iguais.</span>",
            );
            $("#botaopass").removeAttr("disabled");
          } else {
            $("#passlog").html(
              "<span style='color:red;font-weight:bold;'>As passwords introduzidas não são iguais.</span>",
            );
            $("#botaopass").attr("disabled", "true");
          }
        });
      })
      .fail(function (jqXHR, textStatus) {
        moderr(textStatus);
      });
  } else {
    var pass = md5($("#pass2").val());
    $.ajax({
      type: "POST",
      url: "connect.php",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: {
        package: overal({
          origin: "php/checkdb.php",
          function: "changepass",
          attr: JSON.stringify({ id: id, esc: esc, pass: pass }),
        }),
      },
    })
      .done(function (response) {
        var obj = pars(JSON.parse(response));
        if (obj["val"] == 1) {
          $("#addfase").modal("hide");
          perfil();
          toaster(obj["msg"], "success");
        } else {
          toaster(obj["msg"], "error");
        }
      })
      .fail(function (jqXHR, textStatus) {
        moderr(textStatus);
      });
  }
}

function showImg(str, type = null) {
  var isMobile = false; //initiate as false
  // device detection
  if (
    /(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|ipad|iris|kindle|Android|Silk|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(
      navigator.userAgent,
    ) ||
    /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(
      navigator.userAgent.substr(0, 4),
    )
  ) {
    isMobile = true;
  }
  $("#modalimgdownload").hide();
  if (isMobile == true) {
    window.open(str, "_blank");
  } else {
    var checkcontent = 0;
    if (
      (type == null &&
        (str.toLowerCase().indexOf(".pdf") !== -1 ||
          str.toLowerCase().indexOf(".php") !== -1)) ||
      (type != null && type == ".pdf")
    ) {
      document.getElementById("img").innerHTML =
        "<embed src='" +
        str +
        "' width='100%' height='900' type='application/pdf'>";
    } else if (
      (type == null &&
        (str.toLowerCase().indexOf(".jpg") !== -1 ||
          str.toLowerCase().indexOf(".png") !== -1 ||
          str.toLowerCase().indexOf(".jpeg") !== -1)) ||
      (type != null && (type == ".jpg" || type == ".png" || type == ".jpeg"))
    ) {
      document.getElementById("img").innerHTML =
        "<img style='width:100%;' src='" + str + "'>";
      $("#modalimgdownload").attr("href", str);
      $("#modalimgdownload").show();
    } else if (
      str.toLowerCase().indexOf(".doc") !== -1 ||
      str.toLowerCase().indexOf(".docx") !== -1 ||
      str.toLowerCase().indexOf(".xls") !== -1 ||
      str.toLowerCase().indexOf(".xlsx") !== -1 ||
      str.toLowerCase().indexOf(".csv") !== -1
    ) {
      checkcontent = 1;
    } else {
      document.getElementById("img").innerHTML =
        "<p>Imagem Indisponível. Formato Desconhecido.</p>";
    }
    if (checkcontent == 0) {
      var id = $("div.modal.show").attr("id");
      $("#" + id).modal("hide");
      setTimeout(function () {
        $("#modalimg").modal("show");
      }, 500);
      if (id) {
        $("#modalimgfechar").attr(
          "onclick",
          '$("#modalimg").modal("hide");setTimeout(function(){ $("#' +
            id +
            '").modal("show");},500);',
        );
      } else {
        $("#modalimgfechar").attr("onclick", '$("#modalimg").modal("hide");');
      }
    } else {
      var name1 = str.split("/");
      var name2 = name1[parseInt(name1.length - 1)].split(".");
      var link = document.createElement("a");
      link.download = name2[0];
      link.href = str;
      link.click();
    }
  }
}

function lookupNoti() {
  if (userlogin != 0) {
    $.ajax({
      type: "GET",
      url: "uploads/utilizadores/userlog" + userlogin + "/noti.json",
      cache: false,
    })
      .done(function (response) {
        try {
          var info = JSON.parse(response);
          if (info["noti"].length > 0) {
            showNote(info["noti"]);
          } else {
            setTimeout(function () {
              lookupNoti();
            }, 10000);
          }
        } catch (error) {}
      })
      .fail(function (jqXHR, textStatus) {
        moderr(textStatus);
      });
  }
}

function showNote(arr) {
  $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: {
      package: overal({
        origin: "php/checkdb.php",
        function: "showNote",
        attr: JSON.stringify({ arr: arr }),
      }),
    },
  })
    .done(function (response) {
      var obj = pars(JSON.parse(response));
      for (var i = 0; i < obj.length; i++) {
        $.gritter.add({
          title: obj[i]["title"],
          text: obj[i]["message"],
          image: obj[i]["img"],
          sticky: true,
          time: "",
          class_name: "my-sticky-class",
          id: obj[i]["id"],
        });
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr(textStatus);
    });
}

function closeNote(id) {
  $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: {
      package: overal({
        origin: "php/checkdb.php",
        function: "closeNote",
        attr: JSON.stringify({ id: id }),
      }),
    },
  })
    .done(function (response) {
      var obj = pars(JSON.parse(response));
      if (id == 0) {
        if ($(".gritter-item-wrapper").length > 0) {
          $(".gritter-item-wrapper").hide();
        }
        lookupNoti();
      } else {
        if ($(".gritter-item-wrapper").length > 0) {
        } else {
          lookupNoti();
        }
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr(textStatus);
    });
}

setTimeout(function () {
  lookupNoti();
}, 2000);

function genMessage() {
  $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: {
      package: overal({
        origin: "php/checkdb.php",
        function: "genMessage",
        attr: JSON.stringify({}),
      }),
    },
  })
    .done(function (response) {
      var obj = pars(JSON.parse(response));
      $("#addfase").html(obj["msg"]);
      $("#addfase").modal("show");
      $("#message").on("keyup", function () {
        var num = $("#message").val();
        if (parseInt(num.length) > 150) {
          $("#message").val(num.substring(0, 150));
          $("#conta").html(150);
        } else {
          $("#conta").html(num.length);
        }
      });
    })
    .fail(function (jqXHR, textStatus) {
      moderr(textStatus);
    });
}

function regmessage(id) {
  var idtipo = $("#idtipouser").val();
  var error = false;
  var errorMsg = "";
  var info = {};
  info["id"] = id;
  info["idtipo"] = idtipo;
  var message = $("#message").val();
  if (message) {
    info["message"] = message;
  } else {
    errorMsg += "Por favor, escreva a mensagem.";
    error = true;
  }
  if (error) {
    moderr(errorMsg);
  } else {
    $.ajax({
      type: "POST",
      url: "connect.php",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: {
        package: overal({
          origin: "php/checkdb.php",
          function: "regmessage",
          attr: JSON.stringify(info),
        }),
      },
    })
      .done(function (response) {
        var obj = pars(JSON.parse(response));
        if (obj["val"] == 1) {
          $("#addfase").modal("hide");
          modsuc(obj["msg"]);
        } else {
          moderr(obj["msg"]);
        }
      })
      .fail(function (jqXHR, textStatus) {
        moderr(textStatus);
      });
  }
}

function uploadcheck(input, tipo) {
  var c = 0;
  var limiter = [];
  var mensagem = "";
  if (tipo == 1) {
    limiter = ["png", "jpg", "jpeg"];
    mensagem =
      "Apenas é possível carregar ficheiros com a extensão: png, jpg e jpeg.";
  } else if (tipo == 2) {
    limiter = ["pdf", "doc", "docx", "xls", "xlsx", "csv"];
    mensagem =
      "Apenas é possível carregar ficheiros com a extensão: pdf, doc, docx, xls, xlsx e csv.";
  } else if (tipo == 3) {
    limiter = [
      "png",
      "jpg",
      "jpeg",
      "pdf",
      "doc",
      "docx",
      "xls",
      "xlsx",
      "csv",
    ];
    mensagem =
      "Apenas é possível carregar ficheiros com a extensão: png, jpg, jpeg, pdf, doc, docx, xls, xlsx e csv.";
  } else if (tipo == 4) {
    limiter = ["sql", "zip", "rar", "7z"];
    mensagem =
      "Apenas é possível carregar ficheiros com a extensão: sql, zip, rar e 7z.";
  }
  var conteudo = $("#" + input).prop("files");
  for (var a = 0; a < conteudo.length; a++) {
    if (tipo != 5) {
      var ext = conteudo[a]["name"].split(".").pop().toLowerCase();
      if ($.inArray(ext, limiter) == -1) {
        moderr(conteudo[a]["name"] + ".<br>" + mensagem);
        c = 0;
      } else {
        var picsize = conteudo[a]["size"];
        if (picsize > 2000000) {
          moderr(conteudo[a]["name"] + " tem mais que 2 mb.");
          $("#" + input).val("");
          c = 0;
        } else {
          c = 1;
        }
      }
    } else {
      c = 1;
    }
  }
  if (c == 1) {
  } else {
    $("#" + input).val("");
  }
}

function fixRound(num) {
  return Math.round((num + Number.EPSILON) * 100) / 100;
}

function keepReloading(contador) {
  runcheck();
  var song = ["Ah", "ha", "ha", "ha", "stayin' alive", "stayin' alive"];
  var currentdate = new Date();
  var datetime =
    song[contador] +
    " -> " +
    currentdate.getDate() +
    "/" +
    (currentdate.getMonth() + 1) +
    "/" +
    currentdate.getFullYear() +
    " @ " +
    currentdate.getHours() +
    ":" +
    currentdate.getMinutes() +
    ":" +
    currentdate.getSeconds();
  contador++;
  if (contador > 5) {
    contador = 0;
  }
  setTimeout(function () {
    keepReloading(contador);
  }, 100000);
}

function fixRound2(num) {
  return Math.round((num + Number.EPSILON) * 100) / 100;
}

function fixRound4(num) {
  return Math.round((num + Number.EPSILON) * 10000) / 10000;
}

function worktimer() {
  if (parseInt(inicio) == 0) {
  } else {
    var currentTime = new Date().getTime() / 1000;
    var currentDateTime = new Date();
    if (currentDateTime.toString().includes("23:59:")) {
      resetAccess(currentTime);
    }
    var diff = Math.abs(currentTime - inicio - pausas) / (60 * 60);
    if (diff.toString().includes(".")) {
      var exdiff = diff.toString().split(".");
      $("#customsidecurrentttime").html(
        " - " +
          (parseInt(exdiff[0]) +
            "h " +
            parseInt(Math.abs(parseFloat("0." + exdiff[1]) * 60)) +
            "m"),
      );
    }
  }
  setTimeout(function () {
    worktimer();
  }, 60000);
}

function resetAccess(datetime) {
  $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: {
      package: overal({
        origin: "php/checkdb.php",
        function: "resetAccess",
        attr: JSON.stringify({ dth: datetime }),
      }),
    },
  })
    .done(function (response) {
      var obj = JSON.parse(response);
      if (obj["val"] == 1) {
        modinf(obj["msg"]);
      } else {
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}

// ############################### NOVO ###############################
function drawer(
  side,
  html,
  title,
  size = "33%",
  footer = null,
  closeFunction = () => {},
) {
  let position = "";
  let showClass = "";
  let hideClass = "";
  let customStyles = {};
  const isMobileViewport = window.innerWidth <= 768;

  if (side == "left") {
    position = "top-start";
    showClass = `animate__animated animate__fadeInLeft animate__faster`;
    hideClass = `animate__animated animate__fadeOutLeft animate__faster`;
  } else if (side == "right") {
    position = "top-end";
    showClass = `animate__animated animate__fadeInRight animate__faster`;
    hideClass = `animate__animated animate__fadeOutRight animate__faster`;
  } else if (side == "bottom") {
    position = "bottom";
    showClass = `animate__animated animate__fadeInUp animate__faster`;
    hideClass = `animate__animated animate__fadeOutDown animate__faster`;
    customStyles = {
      height: size,
      width: isMobileViewport ? "100%" : "70%",
    };
  } else if (side == "top") {
    position = "top";
    showClass = `animate__animated animate__fadeInDown animate__faster`;
    hideClass = `animate__animated animate__fadeOutUp animate__faster`;
    customStyles = {
      height: size,
      width: isMobileViewport ? "100%" : "70%",
    };
  }

  Swal.fire({
    title: `${title} <hr/>`,
    position: position,
    showClass: {
      popup: showClass,
    },
    hideClass: {
      popup: hideClass,
    },
    grow: side == "top" || side == "bottom" ? "row" : "column",
    width:
      side == "top" || side == "bottom"
        ? isMobileViewport
          ? "100%"
          : "70%"
        : size,
    showConfirmButton: false,
    showCloseButton: false,
    customClass: {
      popup: "custom-drawer-popup",
    },
    html: html,
    footer:
      footer == null
        ? /*html*/ `
            <div class='drawer-footer'>
              <button class='btn btn-success' id='drawerFooterBtn'>Guardar</button>
            </div>`
        : footer,
    didRender: () => {
      // Apply the custom styles after rendering
      const popup = Swal.getPopup();
      if (popup) {
        Object.assign(popup.style, customStyles);
      }
    },
    didClose: () => {
      closeFunction();
    },
  });
}

async function createDataTable(
  id = null,
  buttons = false,
  title = "",
  horizontal = false,
  limit = 10,
  data = [],
  filters = true,
  cache = false,
  customOptions = null,
) {
  function isCardTableViewport(maxWidth) {
    /* Use clientWidth (excludes scrollbar) to match CSS @media queries.
       On Windows the scrollbar is ~17px, causing window.innerWidth to
       exceed the CSS viewport width and miss the breakpoint. */
    var viewportWidth =
      document.documentElement.clientWidth || window.innerWidth;
    var fallbackMaxWidth = 1138;
    var limit =
      typeof maxWidth === "number" && maxWidth > 0
        ? maxWidth
        : fallbackMaxWidth;
    return viewportWidth <= limit;
  }

  function applyDataTableCardLabels(tableSelector) {
    function escapeHtml(value) {
      return String(value)
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/\"/g, "&quot;")
        .replace(/'/g, "&#39;");
    }

    var $table = $(tableSelector);
    if (!$table.length) return;

    var headers = [];
    $table.find("thead th").each(function () {
      var $th = $(this);
      var $clone = $th.clone();
      var $icon = $th.find("i, svg").first();
      var iconClass = "";

      if ($icon.length && $icon.is("i")) {
        iconClass = $icon.attr("class") || "";
      }

      $clone.find("i, svg, .fa, .fas, .far, .fab, .fal, .fad").remove();
      headers.push({
        text: $.trim($clone.text()),
        iconClass: iconClass,
      });
    });

    $table.find("tbody > tr").each(function () {
      var $row = $(this);
      if ($row.find("td[colspan]").length) return;

      $row.children("td").each(function (idx) {
        var $cell = $(this);
        $cell.removeClass(
          "dt-card-actions-cell dt-card-numeric-cell dt-card-labeled-cell dt-card-select-cell",
        );

        if (idx < headers.length && headers[idx] && headers[idx].text) {
          var headerText = headers[idx].text;
          var iconClass = headers[idx].iconClass;
          $cell.attr("data-label", headerText);

          var normalized = headerText
            .toLowerCase()
            .normalize("NFD")
            .replace(/[\u0300-\u036f]/g, "");

          /* ── Selection column: overlay checkbox, no card label ── */
          var hasBulkCheckbox =
            $cell.find(
              "input.dashboard-bulk-row-select, input.dashboard-csv-preview-row-select",
            ).length > 0;

          var isSelectCell =
            $cell.hasClass("dashboard-bulk-select-col") ||
            hasBulkCheckbox ||
            normalized === "sel." ||
            normalized === "sel";

          if (isSelectCell) {
            $cell.addClass("dt-card-select-cell");
            $cell.removeAttr("data-label");
            var $checkbox = $cell.find("input[type='checkbox']").first();
            if ($checkbox.length) {
              $checkbox.detach();
              $cell.html("<span class='dt-card-select-box'></span>");
              $cell.find(".dt-card-select-box").append($checkbox);
            } else if ($cell.children(".dt-card-value").length) {
              $cell.html($cell.children(".dt-card-value").html());
            } else {
              $cell.find(".dt-card-label").remove();
            }
            return; /* continue to next cell */
          }

          var isActionsCell =
            normalized.indexOf("acao") !== -1 ||
            normalized.indexOf("acoes") !== -1 ||
            normalized.indexOf("action") !== -1 ||
            normalized.indexOf("actions") !== -1 ||
            normalized.indexOf("download") !== -1;

          if (isActionsCell) {
            $cell.addClass("dt-card-actions-cell");
            $cell.removeAttr("data-label");

            if ($cell.children(".dt-card-value").length) {
              $cell.html($cell.children(".dt-card-value").html());
            } else {
              $cell.find(".dt-card-label").remove();
            }
          } else {
            $cell.addClass("dt-card-labeled-cell");

            var currentValueHtml = $cell.children(".dt-card-value").length
              ? $cell.children(".dt-card-value").html()
              : $cell.html();

            var iconHtml = iconClass
              ? "<span class='dt-card-label-icon'><i class='" +
                escapeHtml(iconClass) +
                "'></i></span>"
              : "<span class='dt-card-label-icon dt-card-label-icon-empty'></span>";

            var titleHtml =
              "<span class='dt-card-label'>" +
              iconHtml +
              "<span class='dt-card-label-text'>" +
              escapeHtml(headerText) +
              "</span></span>";

            $cell.html(
              titleHtml +
                "<span class='dt-card-value'>" +
                currentValueHtml +
                "</span>",
            );
          }

          if (
            normalized === "qtd" ||
            normalized.indexOf("quantidade") !== -1 ||
            normalized.indexOf("preco") !== -1 ||
            normalized.indexOf("receita") !== -1 ||
            normalized.indexOf("total") !== -1 ||
            normalized.indexOf("tamanho") !== -1
          ) {
            $cell.addClass("dt-card-numeric-cell");
          }
        }
      });
    });
  }

  function getDataTableSortKey(dataTable, tableSelector) {
    var node = dataTable && dataTable.table ? dataTable.table().node() : null;
    var tableId = node ? $(node).attr("id") : "";
    var base = (tableId || tableSelector || "datatable").toString();
    return base.replace(/[^a-zA-Z0-9_\-]/g, "_");
  }

  function getDataTableOrderableColumns(dataTable) {
    var settings = dataTable.settings()[0] || {};
    var columns = settings.aoColumns || [];
    var $headers = $(dataTable.table().header()).find("th");
    var result = [];

    for (var index = 0; index < columns.length; index++) {
      var column = columns[index];
      if (!column || column.bSortable !== true) {
        continue;
      }

      var $th = $headers.eq(index).clone();
      $th.find("i, svg, .fa, .fas, .far, .fab, .fal, .fad").remove();
      var label = $.trim($th.text());
      var normalized = (label || "")
        .toLowerCase()
        .normalize("NFD")
        .replace(/[\u0300-\u036f]/g, "");

      if (
        label === "" ||
        normalized === "sel." ||
        normalized === "sel" ||
        normalized.indexOf("sel. todos") > -1 ||
        normalized === "acoes" ||
        normalized === "acao" ||
        normalized.indexOf("acoes") > -1 ||
        normalized.indexOf("acao") > -1 ||
        normalized.indexOf("action") > -1
      ) {
        continue;
      }

      result.push({
        index: index,
        label: label,
      });
    }

    return result;
  }

  function renderDataTableCardSortToolbar(
    dataTable,
    tableSelector,
    maxWidth,
    tableKey,
  ) {
    var isCard = isCardTableViewport(maxWidth);
    var $wrapper = $(dataTable.table().container());
    var toolbarClass = "dt-card-sort-toolbar";
    var $existingToolbar = $wrapper.children("." + toolbarClass).first();

    if (!isCard) {
      if ($existingToolbar.length) {
        $existingToolbar.remove();
      }
      return;
    }

    var columns = getDataTableOrderableColumns(dataTable);
    if (!columns.length) {
      if ($existingToolbar.length) {
        $existingToolbar.remove();
      }
      return;
    }

    if (!$existingToolbar.length) {
      var html =
        "<div class='" +
        toolbarClass +
        "'>" +
        "<span class='dt-card-sort-label'><i class='fa fa-sort'></i><span>Filtros</span></span>" +
        "<select class='form-control form-control-sm dt-card-sort-column'></select>" +
        "<select class='form-control form-control-sm dt-card-sort-direction'>" +
        "<option value='asc'>Asc &#9650;</option>" +
        "<option value='desc'>Desc &#9660;</option>" +
        "</select>" +
        "</div>";
      $wrapper.prepend(html);
      $existingToolbar = $wrapper.children("." + toolbarClass).first();
    }

    /* Place toolbar right after the DT controls row (Sel. Todos + Procurar).
       Avoid :first-child — if the toolbar was prepended first it breaks the pseudo. */
    var $topControlsRow = $wrapper
      .children(".dt-layout-row:not(.dt-layout-table)")
      .first();
    if (
      $topControlsRow.length &&
      $existingToolbar.prev()[0] !== $topControlsRow[0]
    ) {
      $existingToolbar.insertAfter($topControlsRow);
    }

    var $columnSelect = $existingToolbar.find(".dt-card-sort-column");
    var $directionSelect = $existingToolbar.find(".dt-card-sort-direction");

    var currentOrder = dataTable.order();
    var currentColumn = columns[0].index;
    var currentDirection = "asc";

    if (Array.isArray(currentOrder) && currentOrder.length > 0) {
      var firstOrder = currentOrder[0];
      var orderColumn = parseInt(firstOrder[0], 10);
      var orderDirection = (firstOrder[1] || "asc").toString().toLowerCase();
      var existsInOptions = columns.some(function (item) {
        return item.index === orderColumn;
      });
      if (existsInOptions) {
        currentColumn = orderColumn;
      }
      if (orderDirection === "asc" || orderDirection === "desc") {
        currentDirection = orderDirection;
      }
    }

    var optionsHtml = "";
    for (var i = 0; i < columns.length; i++) {
      var col = columns[i];
      optionsHtml +=
        "<option value='" + col.index + "'>" + col.label + "</option>";
    }

    if ($columnSelect.html() !== optionsHtml) {
      $columnSelect.html(optionsHtml);
    }
    $columnSelect.val(String(currentColumn));
    $directionSelect.val(currentDirection);

    var eventNamespace = ".dtCardSort_" + tableKey;
    $columnSelect.off("change" + eventNamespace);
    $directionSelect.off("change" + eventNamespace);

    var applySort = function () {
      var selectedColumn = parseInt($columnSelect.val(), 10);
      var selectedDirection = ($directionSelect.val() || "asc")
        .toString()
        .toLowerCase();
      if (isNaN(selectedColumn)) {
        return;
      }
      if (selectedDirection !== "asc" && selectedDirection !== "desc") {
        selectedDirection = "asc";
      }

      dataTable.order([[selectedColumn, selectedDirection]]).draw(false);
    };

    $columnSelect.on("change" + eventNamespace, applySort);
    $directionSelect.on("change" + eventNamespace, applySort);
  }

  function syncDataTableCardLayout(
    dataTable,
    tableSelector,
    maxWidth,
    desktopLimit,
  ) {
    var isCard = isCardTableViewport(maxWidth);
    var $table = $(tableSelector);

    if (!$table.length || !dataTable) {
      return;
    }

    if (isCard) {
      $table.addClass("dt-card-table");
      applyDataTableCardLabels(tableSelector);
      if (dataTable.page && dataTable.page.len && dataTable.page.len() !== 4) {
        dataTable.page.len(4).draw(false);
      }
    } else {
      $table.removeClass("dt-card-table");
      if (dataTable.page && dataTable.page.len && dataTable.page.len() === 4) {
        var nextDesktopLimit =
          typeof desktopLimit === "number" && desktopLimit > 0
            ? desktopLimit
            : 10;
        dataTable.page.len(nextDesktopLimit).draw(false);
      }
    }
  }

  function bindDataTableCardSortResize(
    dataTable,
    tableSelector,
    maxWidth,
    tableKey,
    desktopLimit,
  ) {
    var resizeNamespace = "resize.dtCardSort_" + tableKey;
    var timerVarName = "_dtCardSortResizeTimer_" + tableKey;

    $(window)
      .off(resizeNamespace)
      .on(resizeNamespace, function () {
        clearTimeout(window[timerVarName]);
        window[timerVarName] = setTimeout(function () {
          syncDataTableCardLayout(
            dataTable,
            tableSelector,
            maxWidth,
            desktopLimit,
          );
          renderDataTableCardSortToolbar(
            dataTable,
            tableSelector,
            maxWidth,
            tableKey,
          );
        }, 220);
      });
  }

  return new Promise((resolve, reject) => {
    let table = id != null ? "#" + id : ".table";
    $(table).addClass("table table-hover table-compact table-order-column");

    // Destroi a DataTable existente, se houver
    if ($.fn.DataTable.isDataTable(table)) {
      $(table).DataTable().destroy();
    }

    $(document).ready(function () {
      $(table).addClass("table table-hover table-compact table-order-column");
      let dataTableOptions = "";

      if (id == "tabLoadTablesMarcacao2") {
        dataTableOptions = {
          destroy: true,
          lengthMenu: [
            [limit, 25, 50, 100, -1],
            [10, 25, 50, 100, "Todos"],
          ],
          language: {
            lengthMenu: "Mostrar _MENU_ registos por página",
            zeroRecords: "Nenhum registo - desculpe",
            emptyTable: "Sem registos disponíveis.",
            info: "Página _PAGE_ de _PAGES_",
            infoEmpty: "Sem registos disponíveis",
            infoFiltered: "(filtrados de _MAX_ registos totais)",
            search: "Procurar",
            zeroRecords: "Nenhum registo encontrado",
            paginate: {
              first: "Primeira",
              last: "Última",
              next: "Próxima",
              previous: "Anterior",
            },
          },
          order: [], // Nenhuma coluna será ordenada por padrão
          ordering: filters,
          responsive: false,
          scrollX: true, // Enable horizontal scrolling
          fixedColumns: {
            leftColumns: 4, // Fix the first four columns
          },
        };
      } else {
        dataTableOptions = {
          destroy: true,
          lengthMenu: [
            [10, 25, 50, 100, -1],
            [10, 25, 50, 100, "Todos"],
          ],
          language: {
            lengthMenu: "Mostrar _MENU_ registos por página",
            zeroRecords: "Nenhum registo encontrado", // Use apenas uma definição de zeroRecords
            emptyTable: "Sem registos disponíveis.",
            info: "Página _PAGE_ de _PAGES_",
            infoEmpty: "Sem registos disponíveis",
            infoFiltered: "(filtrados de _MAX_ registos totais)",
            search: "Procurar",
            paginate: {
              first: "Primeira",
              last: "Última",
              next: "Próxima",
              previous: "Anterior",
            },
          },
          order: [], // Nenhuma coluna será ordenada por padrão
          ordering: filters,
          responsive: true,
        };
      }

      if (data.length > 0) dataTableOptions.data = data;

      if (buttons != false) {
        dataTableOptions.buttons = [
          {
            extend: "excel",
            text: 'Excel <i class="fas fa-file-excel"></i>',
            className: "btn btn-success btn-sm mb-2",
            title: title,
            functionExcel: true, // true para usar a função personalizada
            action: function (e, dt, button, config) {
              if (typeof buttons.functionExcel === "function") {
                let dataFormat = [];
                dt.rows({ filter: "applied" }).every(function () {
                  var rowData = this.data(); // Obtém os dados da linha
                  var rowToAdd = { data: rowData, info: {} };
                  var additionalInfo = $(this.node()).data("info"); // Captura o data-info
                  if (additionalInfo) rowToAdd.info = additionalInfo; // Adiciona caso exista
                  dataFormat.push(rowToAdd);
                });
                buttons.functionExcel(dataFormat);
              } else {
                $.fn.dataTable.ext.buttons.excelHtml5.action.call(
                  this,
                  e,
                  dt,
                  button,
                  config,
                );
              }
            },
          },
          {
            extend: "pdfHtml5",
            text: 'PDF <i class="fas fa-file-pdf"></i>',
            className: "btn btn-danger btn-sm mb-2",
            title: title,
            orientation: horizontal ? "landscape" : "portrait",
            functionPdf: true, // true para usar a função personalizada
            action: function (e, dt, button, config) {
              if (typeof buttons.functionPdf === "function") {
                let dataFormat = [];
                dt.rows({ filter: "applied" }).every(function () {
                  var rowData = this.data(); // Obtém os dados da linha
                  var rowToAdd = { data: rowData, info: {} };
                  var additionalInfo = $(this.node()).data("info"); // Captura o data-info
                  if (additionalInfo) rowToAdd.info = additionalInfo; // Adiciona caso exista
                  dataFormat.push(rowToAdd);
                });
                buttons.functionPdf(dataFormat);
              } else {
                $.fn.dataTable.ext.buttons.pdfHtml5.action.call(
                  this,
                  e,
                  dt,
                  button,
                  config,
                );
              }
            },
          },
        ];
        dataTableOptions.dom = "Bfrtip";
      }

      if (cache != false) {
        dataTableOptions.bStateSave = true;
      }

      if (customOptions && typeof customOptions === "object") {
        dataTableOptions = $.extend(true, {}, dataTableOptions, customOptions);
      }

      var cardViewportMax =
        typeof dataTableOptions.cardViewportMax === "number" &&
        dataTableOptions.cardViewportMax > 0
          ? dataTableOptions.cardViewportMax
          : 991;

      if (
        Object.prototype.hasOwnProperty.call(
          dataTableOptions,
          "cardViewportMax",
        )
      ) {
        delete dataTableOptions.cardViewportMax;
      }

      if (id == "tabListMulti1") {
        dataTableOptions.scrollX = true;
        dataTableOptions.lengthMenu = [10, 25, 50, 75, 100];
        dataTableOptions.pageLength = 50;
      } else if (id == "tabList2" || id == "tabList3" || id == "tabList4") {
        dataTableOptions.lengthMenu = [10, 25, 50, 75, 100];
      }

      var isCardViewport = isCardTableViewport(cardViewportMax);

      if (isCardViewport) {
        $(table).addClass("dt-card-table");

        dataTableOptions.responsive = false;
        dataTableOptions.scrollX = false;
        if (dataTableOptions.fixedColumns) {
          delete dataTableOptions.fixedColumns;
        }

        dataTableOptions.pageLength = 4;
        dataTableOptions.lengthChange = false;
        dataTableOptions.lengthMenu = [[4], [4]];

        var existingDrawCallback = dataTableOptions.drawCallback;
        dataTableOptions.drawCallback = function (settings) {
          if (typeof existingDrawCallback === "function") {
            existingDrawCallback.call(this, settings);
          }
          applyDataTableCardLabels(table);
        };
      } else {
        $(table).removeClass("dt-card-table");
      }

      let dataTable = $(table).DataTable(dataTableOptions);

      var desktopLimit = typeof limit === "number" && limit > 0 ? limit : 10;

      syncDataTableCardLayout(dataTable, table, cardViewportMax, desktopLimit);

      var tableSortKey = getDataTableSortKey(dataTable, table);
      renderDataTableCardSortToolbar(
        dataTable,
        table,
        cardViewportMax,
        tableSortKey,
      );
      bindDataTableCardSortResize(
        dataTable,
        table,
        cardViewportMax,
        tableSortKey,
        desktopLimit,
      );

      $("button").removeClass(
        "dt-button buttons-excel buttons-html5 buttons-pdf",
      );
      resolve(dataTable);
    });
  });
}

function destroyDataTable(id = 0) {
  if (id == 0) {
    if ($.fn.DataTable.isDataTable(".table")) {
      $(".table").DataTable().destroy();
    }
  } else {
    if ($.fn.DataTable.isDataTable(`#${id}`)) {
      $(`#${id}`).DataTable().destroy();
    }
  }
}

// VALIDAÇÕES DE TIPOS DE INPUT
//EMAIL
function validateEmail(email) {
  try {
    let array = email.split("@");
    if (array.length != 2) {
      toaster("Erro na validação de Email - verifique o formato", "warning");
      return false;
    }

    let array2 = array[1].split(".");
    if (array2.length != 2) {
      toaster("Erro na validação de Email - verifique o formato", "warning");
      return false;
    }

    if (
      array[0].length == 0 ||
      array2[0].length == 0 ||
      array2[1].length == 0
    ) {
      toaster("Erro na validação de Email - verifique o formato", "warning");
      return false;
    }
  } catch (error) {
    toaster("Erro na validação de Email - verifique o formato", "warning");
  }

  return true;
}

//DATE
function validadeDate(date, today = null) {
  let comparacao = false;
  // Create a date object from the input date string
  const inputDate = new Date(date);

  // Check if the date is valid
  if (isNaN(inputDate.getTime())) {
    toaster("Data inválida", "warning");
    return false;
  }

  // Get the current date without the time
  if (today != null) {
    comparacao = true;
    today = new Date(today);
    if (isNaN(today.getTime())) {
      toaster("Data inválida", "warning");
      return false;
    }
    today = today;
  } else {
    today = new Date();
  }
  today.setHours(0, 0, 0, 0); // Set the time to midnight to compare only the date part

  // Check if the input date is in the future or today
  if (inputDate >= today) {
    return true;
  } else {
    if (comparacao) {
      toaster("Data de Fim antes de Data de Inicio", "warning");
    } else {
      toaster("Data inválida", "warning");
    }
    return false;
  }
}

async function formreg(id, classe) {
  var dados = []; // Array para armazenar os objetos de dados
  var files = []; // Array para armazenar os ficheiros
  var error = false;

  var currentDataObject = {}; // Objeto temporário para armazenar campos atuais

  $(`#${id}`)
    .find(`.${classe}`)
    .each(function () {
      var fieldName = $(this).attr("name");
      var fieldValue = $(this).val();
      var inputId = $(this).attr("id");

      if ($(this).hasClass("required")) {
        var isNumber = $(this).attr("type") === "number";
        var min = $(this).attr("min");
        var max = $(this).attr("max");

        if (isNumber) {
          var numericValue = parseFloat(fieldValue);
          if (fieldValue === "" || isNaN(numericValue)) {
            var labelElement = $("label[for='" + inputId + "']");
            var labelText = labelElement.text();
            toaster(
              `O campo ${labelText} encontra-se vazio ou inválido`,
              "warning",
            );
            error = true;
          } else if (
            (min !== undefined && numericValue < parseFloat(min)) ||
            (max !== undefined && numericValue > parseFloat(max))
          ) {
            var labelElement = $("label[for='" + inputId + "']");
            var labelText = labelElement.text();
            toaster(
              `O campo ${labelText} deve estar entre ${min} e ${max}`,
              "warning",
            );
            error = true;
          }
        } else if ($(this).is("select")) {
          if (fieldValue === "" || fieldValue <= 0) {
            // Supondo que "0" é a opção inválida
            var labelElement = $("label[for='" + inputId + "']");
            var labelText = labelElement.text();
            toaster(
              `O campo ${labelText} deve ter uma opção válida selecionada`,
              "warning",
            );
            error = true;
          }
        } else if (fieldValue === "") {
          var labelElement = $("label[for='" + inputId + "']");
          var labelText = labelElement.text();
          toaster(
            `O campo ${labelText} encontra-se vazio ou inválido`,
            "warning",
          );
          error = true;
        }
      }

      if ($(this).attr("type") === "file" && this.files.length > 0) {
        var acceptedTypes = $(this)
          .attr("accept")
          .split(",")
          .map(function (type) {
            return type.trim();
          });
        var valid = true;

        $.each(this.files, function (index, file) {
          var ext = "." + file.name.split(".").pop();
          if (acceptedTypes.indexOf(ext) === -1) {
            valid = false;
            toaster(
              "O arquivo " + file.name + " não é um tipo válido.",
              "warning",
            );
            error = true;
            return false;
          }
          files.push({
            file: file,
            index: index,
            name: file.name,
            field: fieldName,
          });
        });

        if (!valid) {
          files = [];
          error = true;
        }
      } else if ($(this).attr("type") === "checkbox") {
        currentDataObject[fieldName] = $(this).is(":checked") ? 1 : 0;
      } else {
        if (fieldName && fieldValue) {
          if ($(this).is("textarea")) {
            fieldValue = encodeURIComponent(fieldValue);
          }
          currentDataObject[fieldName] = fieldValue; // Adiciona o campo ao objeto atual
        }
      }
    });

  // Adiciona o objeto atual ao array de dados se não estiver vazio
  if (Object.keys(currentDataObject).length > 0) {
    dados.push(currentDataObject);
  }
  if (error) {
    return { result: false };
  } else {
    return { result: true, dados: dados, files: files };
  }
}

function stripAccents(string) {
  const map = {
    Š: "S",
    š: "s",
    Đ: "Dj",
    đ: "dj",
    Ž: "Z",
    ž: "z",
    Č: "C",
    č: "c",
    Ć: "C",
    ć: "c",
    À: "A",
    Á: "A",
    Â: "A",
    Ã: "A",
    Ä: "A",
    Å: "A",
    Æ: "A",
    Ç: "C",
    È: "E",
    É: "E",
    Ê: "E",
    Ë: "E",
    Ì: "I",
    Í: "I",
    Î: "I",
    Ï: "I",
    Ñ: "N",
    Ò: "O",
    Ó: "O",
    Ô: "O",
    Õ: "O",
    Ö: "O",
    Ø: "O",
    Ù: "U",
    Ú: "U",
    Û: "U",
    Ü: "U",
    Ý: "Y",
    Þ: "B",
    ß: "Ss",
    à: "a",
    á: "a",
    â: "a",
    ã: "a",
    ä: "a",
    å: "a",
    æ: "a",
    ç: "c",
    è: "e",
    é: "e",
    ê: "e",
    ë: "e",
    ì: "i",
    í: "i",
    î: "i",
    ï: "i",
    ð: "o",
    ñ: "n",
    ò: "o",
    ó: "o",
    ô: "o",
    õ: "o",
    ö: "o",
    ø: "o",
    ù: "u",
    ú: "u",
    û: "u",
    ý: "y",
    þ: "b",
    ÿ: "y",
    Ŕ: "R",
    ŕ: "r",
  };

  return string != null
    ? string.replace(/[^A-Za-z0-9\s]/g, function (a) {
        return map[a] || a; // Substitui o caractere se estiver no map, caso contrário mantém o original
      })
    : "";
}

// Função global para uploads de ficheiros
function uploadFiles(
  inputId,
  targetPath = "uploads/geral/",
  packageConfig = null,
  fileFieldName = "files[]",
) {
  return new Promise((resolve, reject) => {
    let files;

    // Verifica o tipo do inputId
    if (typeof inputId === "string") {
      // Captura o elemento de input pelo ID e os arquivos
      let input = $(`${inputId.includes("#") ? inputId : `#${inputId}`}`)[0];
      if (!input || !input.files) {
        return reject("Elemento de input inválido ou sem arquivos.");
      }
      files = input.files;
    } else if (inputId instanceof File) {
      // Se for um único arquivo
      files = [inputId];
    } else {
      return reject(
        "O parâmetro inputId deve ser uma string ou um objeto File.",
      );
    }

    // Cria um FormData e adiciona os arquivos e o caminho alvo
    let formData = new FormData();
    for (let i = 0; i < files.length; i++) {
      formData.append(fileFieldName, files[i]);
    }

    if (packageConfig != null) {
      formData.append("package", overal(packageConfig));
    } else {
      formData.append("origin", "php/checkdb.php");
      formData.append("function", "uploadFiles");
      formData.append("attr", JSON.stringify({ targetPath }));
      formData.append(
        "package",
        overal({
          origin: "php/checkdb.php",
          function: "uploadFiles",
          attr: JSON.stringify({ targetPath }),
        }),
      );
    }
    $.ajax({
      type: "POST",
      url: "connect.php",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: formData,
      contentType: false,
      processData: false,
      success: async function (response) {
        try {
          let result = await JSON.parse(response);
          resolve(result);
        } catch (e) {
          reject(e); // Rejeita a promessa em caso de error
        }
      },
      error: function (xhr, status, error) {
        reject(error); // Rejeita a promessa em caso de erro
      },
    });
  });
}

function formatDate() {
  let date = new Date();

  let year = date.getFullYear();
  let month = String(date.getMonth() + 1).padStart(2, "0"); // Meses começam do 0
  let day = String(date.getDate()).padStart(2, "0");
  let hours = String(date.getHours()).padStart(2, "0");
  let minutes = String(date.getMinutes()).padStart(2, "0");
  let seconds = String(date.getSeconds()).padStart(2, "0");

  return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
}
