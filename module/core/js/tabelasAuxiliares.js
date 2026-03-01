// ON LOAD ==============================================================================================================================
$(document).ready(async function () {
  await loadPage();
  await toggleTablesBackoffice();
  $("#list-tab-tabAuxMenu a").on("shown.bs.tab", function (event) {
    toggleMenus();
  });
  $("#list-tab-tabAuxTablesBackoffice a").on("shown.bs.tab", function (event) {
    toggleTablesBackoffice();
  });
});
// ======================================================================================================================================
// TOGGLE ===============================================================================================================================
async function toggleMenus() {
  if ($("#list-backoffice-list").hasClass("active")) {
    $("#tablesBackofficeDiv").show("fast");
    $("#tabAuxBackofficeTables").show("fast");
  } else {
    $("#tablesBackofficeDiv").hide("fast");
    $("#tabAuxBackofficeTables").hide("fast");
  }
}

async function toggleTablesBackoffice() {
  if ($("#list-tiposcolaborador-list").hasClass("active")) {
    await loadTableTiposcolaborador();
  } else if ($("#list-funcoes-list").hasClass("active")) {
    await loadTableFuncoes();
  } else if ($("#list-departamentos-list").hasClass("active")) {
    await loadTableDepartamentos();
  }
}

async function toggleTablesMarcacao() {
  if ($("#list-tipo-list").hasClass("active")) {
    await loadTableTipo();
  } else if ($("#list-vouchertema-list").hasClass("active")) {
    await loadTableVoucherTema();
  } else if ($("#list-piloto-list").hasClass("active")) {
    await loadTablePiloto();
  } else if ($("#list-aviao-list").hasClass("active")) {
    await loadTableAviao();
  } else if ($("#list-extra-list").hasClass("active")) {
    await loadTableExtra();
  } else if ($("#list-produto-list").hasClass("active")) {
    await loadTableProduto();
  }
}

// ======================================================================================================================================
async function loadPage() {
  await $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: {
      package: overal({
        origin: "module/core/php/tabelasAuxiliaresdb.php",
        function: "loadPage",
        attr: "",
      }),
    },
  })
    .done(function (response) {
      var obj = pars(JSON.parse(response));
      if (obj.status == 1) {
        $("#tabAuxRoot").html(obj["page"]);
      } else {
        toaster(obj.msg, "error");
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}

// BACKOFFICE - Tipos Colaboradores =================================================================================================================
async function loadTableTiposcolaborador() {
  await $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: {
      package: overal({
        origin: "module/core/php/tabelasAuxiliaresdb.php",
        function: "loadTableTiposcolaborador",
        attr: "",
      }),
    },
  })
    .done(async function (response) {
      let obj = JSON.parse(response);
      if (obj["status"] == 1) {
        $("#tabAuxBackofficeTables").html(obj["msg"]);
        $("#tabAuxAddBtn").html(obj["btn"]);
        createDataTable("tblTiposcolaborador");
      } else {
        toaster(obj["msg"], "error");
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}
async function drawerTiposcolaborador() {
  let msg = /*html*/ `
        <div class="row">
            <div class="col-12 mb-3">
                <label class="form-label">Descrição *</label>
                <input type="text" class="form-control" id="tiposcolaboradorDescricao" required>
            </div>
        </div>
    `;
  drawer("right", msg, "Adicionar tipo de utilizador");
  $("#drawerFooterBtn").attr("onclick", "addTiposcolaborador()");
}
async function addTiposcolaborador() {
  let info = {};
  let vazio = false;

  let descricao = $("#tiposcolaboradorDescricao").val();

  if (descricao) {
    info["descricao"] = descricao;
  } else {
    vazio = true;
    toaster("Descrição é obrigatória", "warning");
  }

  if (!vazio) {
    await $.ajax({
      type: "POST",
      url: "connect.php",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: {
        package: overal({
          origin: "module/core/php/tabelasAuxiliaresdb.php",
          function: "addTiposcolaborador",
          attr: JSON.stringify(info),
        }),
      },
    })
      .done(function (response) {
        var obj = pars(JSON.parse(response));
        if (obj.val == 1) {
          toaster("Tipo de utilizador registado com sucesso", "success");
          loadTableTiposcolaborador();
          Swal.close();
        } else {
          moderr(obj.msg, "error");
        }
      })
      .fail(function (jqXHR, textStatus) {
        moderr("Request failed: " + textStatus);
      });
  }
}
async function editTiposcolaborador(id) {
  let info = {};
  info["id"] = id;

  await $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: {
      package: overal({
        origin: "module/core/php/tabelasAuxiliaresdb.php",
        function: "editTiposcolaborador",
        attr: JSON.stringify(info),
      }),
    },
  })
    .done(async function (response) {
      let obj = JSON.parse(response);
      if (obj["status"] == 1) {
        let actDesactString =
          obj["get"]["is_active"] == 1
            ? "<i class='fa fa-trash'></i> Desativar"
            : "<i class='fa fa-check'></i> Ativar";
        let msg = /*html*/ `
                <ul class='nav nav-tabs'>
                    <li class='nav-items'>
                        <a href='#tab1' id='btntab1' data-toggle='tab' class='nav-link active'>
                            <span class='d-sm-none' id='util2'>Detalhes</span>
                            <span class='d-sm-block d-none' id='util3'>Detalhes</span>
                        </a>
                    </li>
                    <li class='nav-items'>
                        <a href='#tab2' id='btntab2' data-toggle='tab' class='nav-link'>
                            <span class='d-sm-none' id='util4'>Histórico</span>
                            <span class='d-sm-block d-none' id='util5'>Histórico</span>
                        </a>
                    </li>
                </ul>
                <div class='tab-content'>
                    <div class='tab-pane fade active show' id='tab1'>
                        <div class="row">
                            <div class="col-12 mb-3">
                                <label class="form-label">Descrição *</label>
                                <input type="text" value="${obj["get"]["descricao"]}" class="form-control" id="tiposcolaboradorDescricao" required>
                            </div>
                        </div>
                    </div>
                    <div class='tab-pane fade' id='tab2'>
                        ${obj["responseLog"]["html"]}
                    </div>
                </div>
            `;
        let footer = /*html*/ `
             <div class='mt-4 drawer-footer' style='width: 100%'>
                ${perm["core"]["tabelasAuxiliares"]["Gerir"] ? `<a class='btn btn-white' style='color: ${obj["get"]["is_active"] == 1 ? "red" : "green"}' onclick="modconf('Tem a certeza que deseja ${obj["get"]["is_active"] == 1 ? "desativar" : "ativar"} este tipo de utilizador?', () => actDesactTiposcolaborador(${id}, ${obj["get"]["is_active"]}))">${actDesactString}</a>` : ""}
                ${perm["core"]["tabelasAuxiliares"]["Editar"] ? `<a class='btn btn-success' style='color: white; float:right;' onclick='guardarEditTiposcolaborador(${id})'>Guardar</a>` : ""}
            </div>
            `;
        drawer("right", msg, "Editar tipo de utilizador", "33%", footer);
      } else {
        toaster(obj["msg"], "error");
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}
async function guardarEditTiposcolaborador(id) {
  let info = {};
  let vazio = false;
  info["id"] = id;

  let descricao = $("#tiposcolaboradorDescricao").val();

  if (descricao) {
    info["descricao"] = descricao;
  } else {
    vazio = true;
    toaster("Descrição é obrigatória", "warning");
  }

  if (!vazio) {
    var formData = new FormData();
    formData.append(
      "package",
      overal({
        origin: "module/core/php/tabelasAuxiliaresdb.php",
        function: "guardarEditTiposcolaborador",
        attr: JSON.stringify(info),
      }),
    );
    await $.ajax({
      type: "POST",
      url: "connect.php",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: formData,
      processData: false,
      contentType: false,
    })
      .done(function (response) {
        var obj = JSON.parse(response);
        if (obj.val == 1) {
          toaster("Tipo de utilizador editado com sucesso", "success");
          loadTableTiposcolaborador();
          Swal.close();
        } else {
          moderr(obj["msg"], "error");
        }
      })
      .fail(function (jqXHR, textStatus) {
        moderr("Request failed: " + textStatus);
      });
  }
}
async function actDesactTiposcolaborador(id, is_active) {
  let info = {};
  info["id"] = id;
  info["is_active"] = is_active == 1 ? 0 : 1;

  var formData = new FormData();
  formData.append(
    "package",
    overal({
      origin: "module/core/php/tabelasAuxiliaresdb.php",
      function: "guardarEditTiposcolaborador",
      attr: JSON.stringify(info),
    }),
  );
  await $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: formData,
    processData: false,
    contentType: false,
  })
    .done(function (response) {
      var obj = JSON.parse(response);
      if (obj.val == 1) {
        toaster(
          "Tipo de utilizador " +
            (is_active == 1 ? "desativado" : "ativado") +
            " com sucesso",
          "success",
        );
        loadTableTiposcolaborador();
        Swal.close();
      } else {
        moderr(obj.msg, "error");
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}

// BACKOFFICE - Funções =================================================================================================================
async function loadTableFuncoes() {
  await $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: {
      package: overal({
        origin: "module/core/php/tabelasAuxiliaresdb.php",
        function: "loadTableFuncoes",
        attr: "",
      }),
    },
  })
    .done(async function (response) {
      let obj = JSON.parse(response);
      if (obj["status"] == 1) {
        $("#tabAuxBackofficeTables").html(obj["msg"]);
        $("#tabAuxAddBtn").html(obj["btn"]);
        createDataTable("tblFuncoes");
      } else {
        toaster(obj["msg"], "error");
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}
async function drawerFuncoes() {
  await $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: {
      package: overal({
        origin: "module/core/php/tabelasAuxiliaresdb.php",
        function: "drawerFuncoes",
        attr: JSON.stringify({}),
      }),
    },
  })
    .done(function (response) {
      var obj = pars(JSON.parse(response));
      if (obj.val == 1) {
        let msg = /*html*/ `
                <div class="row" id="formFuncoes">
                    <div class="col-8 mb-3">
                        <label class="form-label">Descrição *</label>
                        <input type="text" class="form-control" id="funcoesDescricao" required>
                    </div>
                    <div class="col-4 mb-3">
                        <label class="form-label">Ordem *</label>
                        <input type="number" class="form-control" id="funcoesOrdem" value="0">
                    </div>
                    <div class="col-12 mb-3">
                        <label class="form-label">Departamento *</label>
                        <select class="form-control" id="funcoesDepartamento" required>
                        </select>
                    </div>
                </div>
            `;
        drawer("right", msg, "Adicionar função");
        $("#drawerFooterBtn").attr("onclick", "addFuncoes()");
        let htmlSelectDepartamentos = obj.departamentos.map(
          (item) => `<option value='${item.id}'>${item.descricao}</option>`,
        );
        $("#funcoesDepartamento").html(htmlSelectDepartamentos);
        $("#funcoesDepartamento").select2({
          closeOnSelect: false,
          width: "100%",
          dropdownParent: $("#formFuncoes"),
        });
      } else {
        moderr(obj.msg, "error");
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}
async function addFuncoes() {
  let info = {};
  let vazio = false;

  let descricao = $("#funcoesDescricao").val();
  let ordem = $("#funcoesOrdem").val();
  let id_depart = $("#funcoesDepartamento").val();

  if (descricao) {
    info["descricao"] = descricao;
  } else {
    vazio = true;
    toaster("Descrição é obrigatória", "warning");
  }

  console.log("ordem: ", ordem);
  if (ordem && ordem != 0) {
    info["ordem"] = ordem;
  } else {
    vazio = true;
    toaster("Ordem é obrigatória", "warning");
  }

  if (id_depart) {
    info["id_depart"] = id_depart;
  } else {
    vazio = true;
    toaster("Departamento é obrigatório", "warning");
  }

  if (!vazio) {
    await $.ajax({
      type: "POST",
      url: "connect.php",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: {
        package: overal({
          origin: "module/core/php/tabelasAuxiliaresdb.php",
          function: "addFuncoes",
          attr: JSON.stringify(info),
        }),
      },
    })
      .done(function (response) {
        var obj = pars(JSON.parse(response));
        if (obj.val == 1) {
          toaster("Função registada com sucesso", "success");
          loadTableFuncoes();
          Swal.close();
        } else {
          moderr(obj.msg, "error");
        }
      })
      .fail(function (jqXHR, textStatus) {
        moderr("Request failed: " + textStatus);
      });
  }
}
async function editFuncoes(id) {
  let info = {};
  info["id"] = id;

  await $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: {
      package: overal({
        origin: "module/core/php/tabelasAuxiliaresdb.php",
        function: "editFuncoes",
        attr: JSON.stringify(info),
      }),
    },
  })
    .done(async function (response) {
      let obj = JSON.parse(response);
      if (obj.val == 1) {
        let actDesactString =
          obj["get"]["is_active"] == 1
            ? "<i class='fa fa-trash'></i> Desativar"
            : "<i class='fa fa-check'></i> Ativar";
        let msg = /*html*/ `
                <ul class='nav nav-tabs'>
                    <li class='nav-items'>
                        <a href='#tab1' id='btntab1' data-toggle='tab' class='nav-link active'>
                            <span class='d-sm-none' id='util2'>Detalhes</span>
                            <span class='d-sm-block d-none' id='util3'>Detalhes</span>
                        </a>
                    </li>
                    <li class='nav-items'>
                        <a href='#tab2' id='btntab2' data-toggle='tab' class='nav-link'>
                            <span class='d-sm-none' id='util4'>Histórico</span>
                            <span class='d-sm-block d-none' id='util5'>Histórico</span>
                        </a>
                    </li>
                </ul>
                <div class='tab-content'>
                    <div class='tab-pane fade active show' id='tab1'>
                        <div class="row" id="formFuncoes">
                            <div class="col-8 mb-3">
                                <label class="form-label">Descrição *</label>
                                <input type="text" class="form-control" value="${obj["get"]["descricao"]}" id="funcoesDescricao" required>
                            </div>
                            <div class="col-4 mb-3">
                                <label class="form-label">Ordem *</label>
                                <input type="number" class="form-control" value="${obj["get"]["ordem"]}" id="funcoesOrdem" value="0">
                            </div>
                            <div class="col-12 mb-3">
                                <label class="form-label">Departamento *</label>
                                <select class="form-control" id="funcoesDepartamento" required>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class='tab-pane fade' id='tab2'>
                        ${obj["responseLog"]["html"]}
                    </div>
                </div>
            `;
        let footer = /*html*/ `
             <div class='mt-4 drawer-footer' style='width: 100%'>
                ${perm["core"]["tabelasAuxiliares"]["Gerir"] ? `<a class='btn btn-white' style='color: ${obj["get"]["is_active"] == 1 ? "red" : "green"}' onclick="modconf('Tem a certeza que deseja ${obj["get"]["is_active"] == 1 ? "desativar" : "ativar"} esta função?', () => actDesactFuncoes(${id}, ${obj["get"]["is_active"]}))">${actDesactString}</a>` : ""}
                ${perm["core"]["tabelasAuxiliares"]["Editar"] ? `<a class='btn btn-success' style='color: white; float:right;' onclick='guardarEditFuncoes(${id})'>Guardar</a>` : ""}
            </div>
            `;
        drawer("right", msg, "Editar função", "33%", footer);
        let htmlSelectDepartamentos = obj.departamentos.map(
          (item) =>
            ((item.is_active == 0 &&
              Number(item.id) == Number(obj["get"]["id_depart"])) ||
              item.is_active == 1) &&
            `<option value='${item.id}' ${Number(item.id) == Number(obj["get"]["id_depart"]) && "selected"}>${item.descricao}</option>`,
        );
        $("#funcoesDepartamento").html(htmlSelectDepartamentos);
        $("#funcoesDepartamento").select2({
          closeOnSelect: false,
          width: "100%",
          dropdownParent: $("#formFuncoes"),
        });
      } else {
        toaster(obj["msg"], "error");
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}
async function guardarEditFuncoes(id) {
  let info = {};
  let vazio = false;
  info["id"] = id;

  let descricao = $("#funcoesDescricao").val();
  let ordem = $("#funcoesOrdem").val();
  let id_depart = $("#funcoesDepartamento").val();

  if (descricao) {
    info["descricao"] = descricao;
  } else {
    vazio = true;
    toaster("Descrição é obrigatória", "warning");
  }

  if (ordem && ordem != 0) {
    info["ordem"] = ordem;
  } else {
    vazio = true;
    toaster("Ordem é obrigatória", "warning");
  }

  if (id_depart) {
    info["id_depart"] = id_depart;
  } else {
    vazio = true;
    toaster("Departamento é obrigatório", "warning");
  }

  if (!vazio) {
    var formData = new FormData();
    formData.append(
      "package",
      overal({
        origin: "module/core/php/tabelasAuxiliaresdb.php",
        function: "guardarEditFuncoes",
        attr: JSON.stringify(info),
      }),
    );
    await $.ajax({
      type: "POST",
      url: "connect.php",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: formData,
      processData: false,
      contentType: false,
    })
      .done(function (response) {
        var obj = JSON.parse(response);
        if (obj.val == 1) {
          toaster("Função editada com sucesso", "success");
          loadTableFuncoes();
          Swal.close();
        } else {
          moderr(obj["msg"], "error");
        }
      })
      .fail(function (jqXHR, textStatus) {
        moderr("Request failed: " + textStatus);
      });
  }
}
async function actDesactFuncoes(id, is_active) {
  let info = {};
  info["id"] = id;
  info["is_active"] = is_active == 1 ? 0 : 1;

  var formData = new FormData();
  formData.append(
    "package",
    overal({
      origin: "module/core/php/tabelasAuxiliaresdb.php",
      function: "guardarEditFuncoes",
      attr: JSON.stringify(info),
    }),
  );
  await $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: formData,
    processData: false,
    contentType: false,
  })
    .done(function (response) {
      var obj = JSON.parse(response);
      if (obj.val == 1) {
        toaster(
          "Função " +
            (is_active == 1 ? "desativada" : "ativada") +
            " com sucesso",
          "success",
        );
        loadTableFuncoes();
        Swal.close();
      } else {
        moderr(obj.msg, "error");
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}

// BACKOFFICE - Departamentos =================================================================================================================
async function loadTableDepartamentos() {
  await $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: {
      package: overal({
        origin: "module/core/php/tabelasAuxiliaresdb.php",
        function: "loadTableDepartamentos",
        attr: "",
      }),
    },
  })
    .done(async function (response) {
      let obj = JSON.parse(response);
      if (obj["status"] == 1) {
        $("#tabAuxBackofficeTables").html(obj["msg"]);
        $("#tabAuxAddBtn").html(obj["btn"]);
        createDataTable("tblDepartamentos");
      } else {
        toaster(obj["msg"], "error");
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}
async function drawerDepartamentos() {
  let msg = /*html*/ `
        <div class="row" id="formDepartamentos">
            <div class="col-4 mb-3">
                <label class="form-label">Cod *</label>
                <input type="text" class="form-control" id="departamentosCod" required>
            </div>
            <div class="col-8 mb-3">
                <label class="form-label">Descição *</label>
                <input type="text" class="form-control" id="departamentosDescricao" required>
            </div>
        </div>
    `;
  drawer("right", msg, "Adicionar Departamento");
  $("#drawerFooterBtn").attr("onclick", "addDepartamentos()");
}
async function addDepartamentos() {
  let info = {};
  let vazio = false;

  let cod = $("#departamentosCod").val();
  let descricao = $("#departamentosDescricao").val();

  if (descricao) {
    info["descricao"] = descricao;
  } else {
    vazio = true;
    toaster("Descrição é obrigatória", "warning");
  }

  if (cod) {
    info["cod"] = cod;
  } else {
    vazio = true;
    toaster("Cod é obrigatório", "warning");
  }

  if (!vazio) {
    await $.ajax({
      type: "POST",
      url: "connect.php",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: {
        package: overal({
          origin: "module/core/php/tabelasAuxiliaresdb.php",
          function: "addDepartamentos",
          attr: JSON.stringify(info),
        }),
      },
    })
      .done(function (response) {
        var obj = pars(JSON.parse(response));
        if (obj.val == 1) {
          toaster("Departamento registado com sucesso", "success");
          loadTableDepartamentos();
          Swal.close();
        } else {
          moderr(obj.msg, "error");
        }
      })
      .fail(function (jqXHR, textStatus) {
        moderr("Request failed: " + textStatus);
      });
  }
}
async function editDepartamentos(id) {
  let info = {};
  info["id"] = id;

  await $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: {
      package: overal({
        origin: "module/core/php/tabelasAuxiliaresdb.php",
        function: "editDepartamentos",
        attr: JSON.stringify(info),
      }),
    },
  })
    .done(async function (response) {
      let obj = JSON.parse(response);
      if (obj.val == 1) {
        let actDesactString =
          obj["get"]["is_active"] == 1
            ? "<i class='fa fa-trash'></i> Desativar"
            : "<i class='fa fa-check'></i> Ativar";
        let msg = /*html*/ `
                <ul class='nav nav-tabs'>
                    <li class='nav-items'>
                        <a href='#tab1' id='btntab1' data-toggle='tab' class='nav-link active'>
                            <span class='d-sm-none' id='util2'>Detalhes</span>
                            <span class='d-sm-block d-none' id='util3'>Detalhes</span>
                        </a>
                    </li>
                    <li class='nav-items'>
                        <a href='#tab2' id='btntab2' data-toggle='tab' class='nav-link'>
                            <span class='d-sm-none' id='util4'>Histórico</span>
                            <span class='d-sm-block d-none' id='util5'>Histórico</span>
                        </a>
                    </li>
                </ul>
                <div class='tab-content'>
                    <div class='tab-pane fade active show' id='tab1'>
                        <div class="row">
                            <div class="col-4 mb-3">
                                <label class="form-label">Cod *</label>
                                <input type="text" class="form-control" id="departamentosCod" value="${obj["get"]["cod"]}" required>
                            </div>
                            <div class="col-8 mb-3">
                                <label class="form-label">Descição *</label>
                                <input type="text" class="form-control" id="departamentosDescricao" value="${obj["get"]["descricao"]}" required>
                            </div>
                        </div>
                    </div>
                    <div class='tab-pane fade' id='tab2'>
                        ${obj["responseLog"]["html"]}
                    </div>
                </div>
            `;
        let footer = /*html*/ `
             <div class='mt-4 drawer-footer' style='width: 100%'>
                ${perm["core"]["tabelasAuxiliares"]["Gerir"] ? `<a class='btn btn-white' style='color: ${obj["get"]["is_active"] == 1 ? "red" : "green"}' onclick="modconf('Tem a certeza que deseja ${obj["get"]["is_active"] == 1 ? "desativar" : "ativar"} este departamento?', () => actDesactDepartamentos(${id}, ${obj["get"]["is_active"]}))">${actDesactString}</a>` : ""}
                ${perm["core"]["tabelasAuxiliares"]["Editar"] ? `<a class='btn btn-success' style='color: white; float:right;' onclick='guardarEditDepartamentos(${id})'>Guardar</a>` : ""}
            </div>
            `;
        drawer("right", msg, "Editar Departamento", "33%", footer);
      } else {
        toaster(obj["msg"], "error");
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}
async function guardarEditDepartamentos(id) {
  let info = {};
  let vazio = false;
  info["id"] = id;

  let cod = $("#departamentosCod").val();
  let descricao = $("#departamentosDescricao").val();

  if (descricao) {
    info["descricao"] = descricao;
  } else {
    vazio = true;
    toaster("Descrição é obrigatória", "warning");
  }

  if (cod) {
    info["cod"] = cod;
  } else {
    vazio = true;
    toaster("Cod é obrigatório", "warning");
  }

  if (!vazio) {
    var formData = new FormData();
    formData.append(
      "package",
      overal({
        origin: "module/core/php/tabelasAuxiliaresdb.php",
        function: "guardarEditDepartamentos",
        attr: JSON.stringify(info),
      }),
    );
    await $.ajax({
      type: "POST",
      url: "connect.php",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: formData,
      processData: false,
      contentType: false,
    })
      .done(function (response) {
        var obj = JSON.parse(response);
        if (obj.val == 1) {
          toaster("Departamento editado com sucesso", "success");
          loadTableDepartamentos();
          Swal.close();
        } else {
          moderr(obj["msg"], "error");
        }
      })
      .fail(function (jqXHR, textStatus) {
        moderr("Request failed: " + textStatus);
      });
  }
}
async function actDesactDepartamentos(id, is_active) {
  let info = {};
  info["id"] = id;
  info["is_active"] = is_active == 1 ? 0 : 1;

  var formData = new FormData();
  formData.append(
    "package",
    overal({
      origin: "module/core/php/tabelasAuxiliaresdb.php",
      function: "guardarEditDepartamentos",
      attr: JSON.stringify(info),
    }),
  );
  await $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: formData,
    processData: false,
    contentType: false,
  })
    .done(function (response) {
      var obj = JSON.parse(response);
      if (obj.val == 1) {
        toaster(
          "Departamento " +
            (is_active == 1 ? "desativado" : "ativado") +
            " com sucesso",
          "success",
        );
        loadTableDepartamentos();
        Swal.close();
      } else {
        moderr(obj.msg, "error");
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}

// Marcações - Tipo =================================================================================================================
async function loadTableTipo() {
  await $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: {
      package: overal({
        origin: "module/core/php/tabelasAuxiliaresdb.php",
        function: "loadTableTipo",
        attr: "",
      }),
    },
  })
    .done(async function (response) {
      let obj = JSON.parse(response);
      if (obj["status"] == 1) {
        $("#tabAuxMarcacaoTables").html(obj["msg"]);
        $("#tabAuxAddBtn").html(obj["btn"]);
        createDataTable("tblTipo");
      } else {
        toaster(obj["msg"], "error");
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}
async function drawerTipo() {
  let msg = /*html*/ `
        <div class="row">
            <div class="col-12 mb-3">
                <label class="form-label">Descrição *</label>
                <input type="text" class="form-control" id="tipoDescricao" required>
            </div>
            <div class="col-12 mb-3">
                <label class="form-label">Observações</label>
                <input type="text" class="form-control" id="tipoObservacoes">
            </div>
            <div class="col-12 mb-3">
                <label class="form-label">Preço</label>
                <input type="text" class="form-control" id="tipoPreco" required value="0">
            </div>
            <div class="col-12 mb-3">
                <label class="form-label">Altura</label>
                <input type="text" class="form-control" id="tipoAltura" value="0">
            </div>
            <div class="col-12 mb-3">
                <label class="form-label">Duração de salto</label>
                <input type="text" class="form-control" id="tipoDuracao" value="0">
            </div>

            <div class="col-12 mb-3">
                <div class="form-check mb-2 ml-1">
                    <input class="form-check-input" type="checkbox" value="" id="tipoUpgrade" style='transform: scale(1.5);'>
                    <label class="form-check-label" for="tipoUpgrade">Upgrade</label>
                </div>
            </div>
            <div class="col-12 mb-3">
                <div class="form-check mb-2 ml-1">
                    <input class="form-check-input" type="checkbox" value="" id="tipoExtras" style='transform: scale(1.5);'>
                    <label class="form-check-label" for="tipoExtras">Permite Extras</label>
                </div>
            </div>
            <div class="col-12 mb-3">
                <div class="form-check mb-2 ml-1">
                    <input class="form-check-input" type="checkbox" value="" id="tipoVoucher" style='transform: scale(1.5);'>
                    <label class="form-check-label" for="tipoVoucher">Disponivel em Voucher</label>
                </div>
            </div>
            <div class="col-12 mb-3">
                <div class="form-check mb-2 ml-1">
                    <input class="form-check-input" type="checkbox" value="" id="tipoMarcacao" style='transform: scale(1.5);'>
                    <label class="form-check-label" for="tipoMarcacao">Disponivel em Marcação</label>
                </div>
            </div>
        </div>
    `;
  drawer("right", msg, "Adicionar tipo");
  $("#drawerFooterBtn").attr("onclick", "addTipo()");
}
async function addTipo() {
  let info = {};
  let vazio = false;

  let descricao = $("#tipoDescricao").val();
  let observacoes = $("#tipoObservacoes").val();
  let preco = $("#tipoPreco").val();
  let altura = $("#tipoAltura").val();
  let duracao = $("#tipoDuracao").val();
  let upgrade = $("#tipoUpgrade").is(":checked") ? 1 : 0;
  let extras = $("#tipoExtras").is(":checked") ? 1 : 0;
  let voucher = $("#tipoVoucher").is(":checked") ? 1 : 0;
  let marcacao = $("#tipoMarcacao").is(":checked") ? 1 : 0;

  if (descricao) {
    info["descricao"] = descricao;
  } else {
    vazio = true;
    toaster("Descrição é obrigatória", "warning");
  }

  if (preco) {
    info["preco"] = preco;
  } else {
    vazio = true;
    toaster("Preço é obrigatório", "warning");
  }

  info["observacoes"] = observacoes;
  info["altura"] = altura;
  info["duracao"] = duracao;
  info["nivel"] = upgrade;
  info["extras"] = extras;
  info["voucher"] = voucher;
  info["marcacao"] = marcacao;

  if (!vazio) {
    await $.ajax({
      type: "POST",
      url: "connect.php",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: {
        package: overal({
          origin: "module/core/php/tabelasAuxiliaresdb.php",
          function: "addTipo",
          attr: JSON.stringify(info),
        }),
      },
    })
      .done(function (response) {
        var obj = pars(JSON.parse(response));
        if (obj.val == 1) {
          toaster("Tipo registado com sucesso", "success");
          loadTableTipo();
          Swal.close();
        } else {
          moderr(obj.msg, "error");
        }
      })
      .fail(function (jqXHR, textStatus) {
        moderr("Request failed: " + textStatus);
      });
  }
}
async function editTipo(id) {
  let info = {};
  info["id"] = id;

  await $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: {
      package: overal({
        origin: "module/core/php/tabelasAuxiliaresdb.php",
        function: "editTipo",
        attr: JSON.stringify(info),
      }),
    },
  })
    .done(async function (response) {
      let obj = JSON.parse(response);
      if (obj["status"] == 1) {
        let actDesactString =
          obj["get"]["is_active"] == 1
            ? "<i class='fa fa-trash'></i> Desativar"
            : "<i class='fa fa-check'></i> Ativar";
        let msg = /*html*/ `
                <ul class='nav nav-tabs'>
                    <li class='nav-items'>
                        <a href='#tab1' id='btntab1' data-toggle='tab' class='nav-link active'>
                            <span class='d-sm-none' id='util2'>Detalhes</span>
                            <span class='d-sm-block d-none' id='util3'>Detalhes</span>
                        </a>
                    </li>
                    <li class='nav-items'>
                        <a href='#tab2' id='btntab2' data-toggle='tab' class='nav-link'>
                            <span class='d-sm-none' id='util4'>Histórico</span>
                            <span class='d-sm-block d-none' id='util5'>Histórico</span>
                        </a>
                    </li>
                </ul>
                <div class='tab-content'>
                    <div class='tab-pane fade active show' id='tab1'>
                        <div class="row">
                            <div class="col-12 mb-3">
                                <label class="form-label">Descrição *</label>
                                <input type="text" class="form-control" id="tipoDescricao" value="${obj["get"]["descricao"]}" required>
                            </div>
                            <div class="col-12 mb-3">
                                <label class="form-label">Observações</label>
                                <input type="text" class="form-control" id="tipoObservacoes" value="${obj["get"]["observacoes"]}">
                            </div>
                            <div class="col-12 mb-3">
                                <label class="form-label">Preço *</label>
                                <input type="text" class="form-control" id="tipoPreco" value="${obj["get"]["preco"]}" required>
                            </div>
                            <div class="col-12 mb-3">
                                <label class="form-label">Altura</label>
                                <input type="text" class="form-control" id="tipoAltura" value="${obj["get"]["altura"]}">
                            </div>
                            <div class="col-12 mb-3">
                                <label class="form-label">Duração de salto</label>
                                <input type="text" class="form-control" id="tipoDuracao" value="${obj["get"]["duracao"]}">
                            </div>

                            <div class="col-12 mb-3">
                                <div class="form-check mb-2 ml-1">
                                    <input class="form-check-input" type="checkbox" id="tipoUpgrade" ${obj["get"]["nivel"] != 0 ? "checked" : ""} style='transform: scale(1.5);'>
                                    <label class="form-check-label" for="tipoUpgrade">Upgrade</label>
                                </div>
                            </div>
                            <div class="col-12 mb-3">
                                <div class="form-check mb-2 ml-1">
                                    <input class="form-check-input" type="checkbox" id="tipoExtras" ${obj["get"]["extras"] != 0 ? "checked" : ""} style='transform: scale(1.5);'>
                                    <label class="form-check-label" for="tipoExtras">Permite Extras</label>
                                </div>
                            </div>
                            <div class="col-12 mb-3">
                                <div class="form-check mb-2 ml-1">
                                    <input class="form-check-input" type="checkbox" id="tipoVoucher" ${obj["get"]["voucher"] != 0 ? "checked" : ""} style='transform: scale(1.5);'>
                                    <label class="form-check-label" for="tipoVoucher">Disponivel em Voucher</label>
                                </div>
                            </div>
                            <div class="col-12 mb-3">
                                <div class="form-check mb-2 ml-1">
                                    <input class="form-check-input" type="checkbox" id="tipoMarcacao" ${obj["get"]["marcacao"] != 0 ? "checked" : ""} style='transform: scale(1.5);'>
                                    <label class="form-check-label" for="tipoMarcacao"> Disponivel em Marcação</label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class='tab-pane fade' id='tab2'>
                        ${obj["responseLog"]["html"]}
                    </div>
                </div>
            `;
        let footer = /*html*/ `
             <div class='mt-4 drawer-footer' style='width: 100%'>
                ${perm["core"]["tabelasAuxiliares"]["Gerir"] ? `<a class='btn btn-white' style='color: ${obj["get"]["is_active"] == 1 ? "red" : "green"}' onclick="modconf('Tem a certeza que deseja ${obj["get"]["is_active"] == 1 ? "desativar" : "ativar"} este tipo?', () => actDesactTipo(${id}, ${obj["get"]["is_active"]}))">${actDesactString}</a>` : ""}
                ${perm["core"]["tabelasAuxiliares"]["Editar"] ? `<a class='btn btn-success' style='color: white; float:right;' onclick='guardarEditTipo(${id})'>Guardar</a>` : ""}
            </div>
            `;
        drawer("right", msg, "Editar tipo", "33%", footer);
      } else {
        toaster(obj["msg"], "error");
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}
async function guardarEditTipo(id) {
  let info = {};
  let vazio = false;
  info["id"] = id;

  let descricao = $("#tipoDescricao").val();
  let observacoes = $("#tipoObservacoes").val();
  let preco = $("#tipoPreco").val();
  let altura = $("#tipoAltura").val();
  let duracao = $("#tipoDuracao").val();
  let upgrade = $("#tipoUpgrade").is(":checked") ? 1 : 0;
  let extras = $("#tipoExtras").is(":checked") ? 1 : 0;
  let voucher = $("#tipoVoucher").is(":checked") ? 1 : 0;
  let marcacao = $("#tipoMarcacao").is(":checked") ? 1 : 0;

  if (descricao) {
    info["descricao"] = descricao;
  } else {
    vazio = true;
    toaster("Descrição é obrigatória", "warning");
  }

  if (preco) {
    info["preco"] = preco;
  } else {
    vazio = true;
    toaster("Preço é obrigatório", "warning");
  }

  info["observacoes"] = observacoes;
  info["altura"] = altura;
  info["duracao"] = duracao;
  info["nivel"] = upgrade;
  info["extras"] = extras;
  info["voucher"] = voucher;
  info["marcacao"] = marcacao;

  if (!vazio) {
    var formData = new FormData();
    formData.append(
      "package",
      overal({
        origin: "module/core/php/tabelasAuxiliaresdb.php",
        function: "guardarEditTipo",
        attr: JSON.stringify(info),
      }),
    );
    await $.ajax({
      type: "POST",
      url: "connect.php",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: formData,
      processData: false,
      contentType: false,
    })
      .done(function (response) {
        var obj = JSON.parse(response);
        if (obj.val == 1) {
          toaster("Tipo editado com sucesso", "success");
          loadTableTipo();
          Swal.close();
        } else {
          moderr(obj["msg"], "error");
        }
      })
      .fail(function (jqXHR, textStatus) {
        moderr("Request failed: " + textStatus);
      });
  }
}
async function actDesactTipo(id, is_active) {
  let info = {};
  info["id"] = id;
  info["is_active"] = is_active == 1 ? 0 : 1;

  var formData = new FormData();
  formData.append(
    "package",
    overal({
      origin: "module/core/php/tabelasAuxiliaresdb.php",
      function: "guardarEditTipo",
      attr: JSON.stringify(info),
    }),
  );
  await $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: formData,
    processData: false,
    contentType: false,
  })
    .done(function (response) {
      var obj = JSON.parse(response);
      if (obj.val == 1) {
        toaster(
          "Tipo " +
            (is_active == 1 ? "desativado" : "ativado") +
            " com sucesso",
          "success",
        );
        loadTableTipo();
        Swal.close();
      } else {
        moderr(obj.msg, "error");
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}

// Marcações - Voucher Tema =================================================================================================================
async function loadTableVoucherTema() {
  await $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: {
      package: overal({
        origin: "module/core/php/tabelasAuxiliaresdb.php",
        function: "loadTableVoucherTema",
        attr: "",
      }),
    },
  })
    .done(async function (response) {
      let obj = JSON.parse(response);
      if (obj["status"] == 1) {
        $("#tabAuxMarcacaoTables").html(obj["msg"]);
        $("#tabAuxAddBtn").html(obj["btn"]);
        createDataTable("tblVoucherTema");
      } else {
        toaster(obj["msg"], "error");
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}
async function drawerVoucherTema() {
  let msg = /*html*/ `
        <div class="row">
            <div class="col-12 mb-3">
                <label class="form-label">Descrição *</label>
                <input type="text" class="form-control" id="vouchertemaDescricao" required>
            </div>
            <div class="col-12 mb-3">
                <label class="form-label">Observações</label>
                <input type="text" class="form-control" id="vouchertemaObservacoes">
            </div>
        </div>
    `;
  drawer("right", msg, "Adicionar voucher tema");
  $("#drawerFooterBtn").attr("onclick", "addVoucherTema()");
}
async function addVoucherTema() {
  let info = {};
  let vazio = false;

  let descricao = $("#vouchertemaDescricao").val();
  let observacoes = $("#vouchertemaObservacoes").val();

  if (descricao) {
    info["descricao"] = descricao;
  } else {
    vazio = true;
    toaster("Descrição é obrigatória", "warning");
  }

  info["observacoes"] = observacoes;

  if (!vazio) {
    await $.ajax({
      type: "POST",
      url: "connect.php",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: {
        package: overal({
          origin: "module/core/php/tabelasAuxiliaresdb.php",
          function: "addVoucherTema",
          attr: JSON.stringify(info),
        }),
      },
    })
      .done(function (response) {
        var obj = pars(JSON.parse(response));
        if (obj.val == 1) {
          toaster("Voucher tema registado com sucesso", "success");
          loadTableVoucherTema();
          Swal.close();
        } else {
          moderr(obj.msg, "error");
        }
      })
      .fail(function (jqXHR, textStatus) {
        moderr("Request failed: " + textStatus);
      });
  }
}
async function editVoucherTema(id) {
  let info = {};
  info["id"] = id;

  await $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: {
      package: overal({
        origin: "module/core/php/tabelasAuxiliaresdb.php",
        function: "editVoucherTema",
        attr: JSON.stringify(info),
      }),
    },
  })
    .done(async function (response) {
      let obj = JSON.parse(response);
      if (obj["status"] == 1) {
        let actDesactString =
          obj["get"]["is_active"] == 1
            ? "<i class='fa fa-trash'></i> Desativar"
            : "<i class='fa fa-check'></i> Ativar";
        let msg = /*html*/ `
                <ul class='nav nav-tabs'>
                    <li class='nav-items'>
                        <a href='#tab1' id='btntab1' data-toggle='tab' class='nav-link active'>
                            <span class='d-sm-none' id='util2'>Detalhes</span>
                            <span class='d-sm-block d-none' id='util3'>Detalhes</span>
                        </a>
                    </li>
                    <li class='nav-items'>
                        <a href='#tab2' id='btntab2' data-toggle='tab' class='nav-link'>
                            <span class='d-sm-none' id='util4'>Histórico</span>
                            <span class='d-sm-block d-none' id='util5'>Histórico</span>
                        </a>
                    </li>
                </ul>
                <div class='tab-content'>
                    <div class='tab-pane fade active show' id='tab1'>
                        <div class="row">
                            <div class="col-12 mb-3">
                                <label class="form-label">Descrição *</label>
                                <input type="text" class="form-control" id="vouchertemaDescricao" value="${obj["get"]["descricao"]}" required>
                            </div>
                            <div class="col-12 mb-3">
                                <label class="form-label">Observações</label>
                                <input type="text" class="form-control" id="vouchertemaObservacoes" value="${obj["get"]["observacoes"]}">
                            </div>
                        </div>
                    </div>
                    <div class='tab-pane fade' id='tab2'>
                        ${obj["responseLog"]["html"]}
                    </div>
                </div>
            `;
        let footer = /*html*/ `
             <div class='mt-4 drawer-footer' style='width: 100%'>
                ${perm["core"]["tabelasAuxiliares"]["Gerir"] ? `<a class='btn btn-white' style='color: ${obj["get"]["is_active"] == 1 ? "red" : "green"}' onclick="modconf('Tem a certeza que deseja ${obj["get"]["is_active"] == 1 ? "desativar" : "ativar"} este voucher tema?', () => actDesactVoucherTema(${id}, ${obj["get"]["is_active"]}))">${actDesactString}</a>` : ""}
                ${perm["core"]["tabelasAuxiliares"]["Editar"] ? `<a class='btn btn-success' style='color: white; float:right;' onclick='guardarEditVoucherTema(${id})'>Guardar</a>` : ""}
            </div>
            `;
        drawer("right", msg, "Editar voucher tema", "33%", footer);
      } else {
        toaster(obj["msg"], "error");
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}
async function guardarEditVoucherTema(id) {
  let info = {};
  let vazio = false;
  info["id"] = id;

  let descricao = $("#vouchertemaDescricao").val();
  let observacoes = $("#vouchertemaObservacoes").val();

  if (descricao) {
    info["descricao"] = descricao;
  } else {
    vazio = true;
    toaster("Descrição é obrigatória", "warning");
  }

  info["observacoes"] = observacoes;

  if (!vazio) {
    var formData = new FormData();
    formData.append(
      "package",
      overal({
        origin: "module/core/php/tabelasAuxiliaresdb.php",
        function: "guardarEditVoucherTema",
        attr: JSON.stringify(info),
      }),
    );
    await $.ajax({
      type: "POST",
      url: "connect.php",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: formData,
      processData: false,
      contentType: false,
    })
      .done(function (response) {
        var obj = JSON.parse(response);
        if (obj.val == 1) {
          toaster("Voucher tema editado com sucesso", "success");
          loadTableVoucherTema();
          Swal.close();
        } else {
          moderr(obj["msg"], "error");
        }
      })
      .fail(function (jqXHR, textStatus) {
        moderr("Request failed: " + textStatus);
      });
  }
}
async function actDesactVoucherTema(id, is_active) {
  let info = {};
  info["id"] = id;
  info["is_active"] = is_active == 1 ? 0 : 1;

  var formData = new FormData();
  formData.append(
    "package",
    overal({
      origin: "module/core/php/tabelasAuxiliaresdb.php",
      function: "guardarEditVoucherTema",
      attr: JSON.stringify(info),
    }),
  );
  await $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: formData,
    processData: false,
    contentType: false,
  })
    .done(function (response) {
      var obj = JSON.parse(response);
      if (obj.val == 1) {
        toaster(
          "Voucher tema " +
            (is_active == 1 ? "desativado" : "ativado") +
            " com sucesso",
          "success",
        );
        loadTableVoucherTema();
        Swal.close();
      } else {
        moderr(obj.msg, "error");
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}

// Marcações - Piloto =================================================================================================================
async function loadTablePiloto() {
  await $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: {
      package: overal({
        origin: "module/core/php/tabelasAuxiliaresdb.php",
        function: "loadTablePiloto",
        attr: "",
      }),
    },
  })
    .done(async function (response) {
      let obj = JSON.parse(response);
      if (obj["status"] == 1) {
        $("#tabAuxMarcacaoTables").html(obj["msg"]);
        $("#tabAuxAddBtn").html(obj["btn"]);
        createDataTable("tblPiloto");
      } else {
        toaster(obj["msg"], "error");
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}
async function drawerPiloto() {
  let msg = /*html*/ `
        <div class="row">
            <div class="col-12 mb-3">
                <label class="form-label">Nome *</label>
                <input type="text" class="form-control" id="pilotoNome" required>
            </div>
        </div>
    `;
  drawer("right", msg, "Adicionar piloto");
  $("#drawerFooterBtn").attr("onclick", "addPiloto()");
}
async function addPiloto() {
  let info = {};
  let vazio = false;

  let nome = $("#pilotoNome").val();

  if (nome) {
    info["nome"] = nome;
  } else {
    vazio = true;
    toaster("Nome é obrigatório", "warning");
  }

  if (!vazio) {
    await $.ajax({
      type: "POST",
      url: "connect.php",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: {
        package: overal({
          origin: "module/core/php/tabelasAuxiliaresdb.php",
          function: "addPiloto",
          attr: JSON.stringify(info),
        }),
      },
    })
      .done(function (response) {
        var obj = pars(JSON.parse(response));
        if (obj.val == 1) {
          toaster("Piloto registado com sucesso", "success");
          loadTablePiloto();
          Swal.close();
        } else {
          moderr(obj.msg, "error");
        }
      })
      .fail(function (jqXHR, textStatus) {
        moderr("Request failed: " + textStatus);
      });
  }
}
async function editPiloto(id) {
  let info = {};
  info["id"] = id;

  await $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: {
      package: overal({
        origin: "module/core/php/tabelasAuxiliaresdb.php",
        function: "editPiloto",
        attr: JSON.stringify(info),
      }),
    },
  })
    .done(async function (response) {
      let obj = JSON.parse(response);
      if (obj["status"] == 1) {
        let actDesactString =
          obj["get"]["is_active"] == 1
            ? "<i class='fa fa-trash'></i> Desativar"
            : "<i class='fa fa-check'></i> Ativar";
        let msg = /*html*/ `
                <ul class='nav nav-tabs'>
                    <li class='nav-items'>
                        <a href='#tab1' id='btntab1' data-toggle='tab' class='nav-link active'>
                            <span class='d-sm-none' id='util2'>Detalhes</span>
                            <span class='d-sm-block d-none' id='util3'>Detalhes</span>
                        </a>
                    </li>
                    <li class='nav-items'>
                        <a href='#tab2' id='btntab2' data-toggle='tab' class='nav-link'>
                            <span class='d-sm-none' id='util4'>Histórico</span>
                            <span class='d-sm-block d-none' id='util5'>Histórico</span>
                        </a>
                    </li>
                </ul>
                <div class='tab-content'>
                    <div class='tab-pane fade active show' id='tab1'>
                        <div class="row">
                            <div class="col-12 mb-3">
                                <label class="form-label">Nome *</label>
                                <input type="text" class="form-control" id="pilotoNome" value="${obj["get"]["nome"]}" required>
                            </div>
                        </div>
                    </div>
                    <div class='tab-pane fade' id='tab2'>
                        ${obj["responseLog"]["html"]}
                    </div>
                </div>
            `;
        let footer = /*html*/ `
             <div class='mt-4 drawer-footer' style='width: 100%'>
                ${perm["core"]["tabelasAuxiliares"]["Gerir"] ? `<a class='btn btn-white' style='color: ${obj["get"]["is_active"] == 1 ? "red" : "green"}' onclick="modconf('Tem a certeza que deseja ${obj["get"]["is_active"] == 1 ? "desativar" : "ativar"} este piloto?', () => actDesactPiloto(${id}, ${obj["get"]["is_active"]}))">${actDesactString}</a>` : ""}
                ${perm["core"]["tabelasAuxiliares"]["Editar"] ? `<a class='btn btn-success' style='color: white; float:right;' onclick='guardarEditPiloto(${id})'>Guardar</a>` : ""}
            </div>
            `;
        drawer("right", msg, "Editar piloto", "33%", footer);
      } else {
        toaster(obj["msg"], "error");
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}
async function guardarEditPiloto(id) {
  let info = {};
  let vazio = false;
  info["id"] = id;

  let nome = $("#pilotoNome").val();

  if (nome) {
    info["nome"] = nome;
  } else {
    vazio = true;
    toaster("Nome é obrigatório", "warning");
  }

  if (!vazio) {
    var formData = new FormData();
    formData.append(
      "package",
      overal({
        origin: "module/core/php/tabelasAuxiliaresdb.php",
        function: "guardarEditPiloto",
        attr: JSON.stringify(info),
      }),
    );
    await $.ajax({
      type: "POST",
      url: "connect.php",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: formData,
      processData: false,
      contentType: false,
    })
      .done(function (response) {
        var obj = JSON.parse(response);
        if (obj.val == 1) {
          toaster("Piloto editado com sucesso", "success");
          loadTablePiloto();
          Swal.close();
        } else {
          moderr(obj["msg"], "error");
        }
      })
      .fail(function (jqXHR, textStatus) {
        moderr("Request failed: " + textStatus);
      });
  }
}
async function actDesactPiloto(id, is_active) {
  let info = {};
  info["id"] = id;
  info["is_active"] = is_active == 1 ? 0 : 1;

  var formData = new FormData();
  formData.append(
    "package",
    overal({
      origin: "module/core/php/tabelasAuxiliaresdb.php",
      function: "guardarEditPiloto",
      attr: JSON.stringify(info),
    }),
  );
  await $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: formData,
    processData: false,
    contentType: false,
  })
    .done(function (response) {
      var obj = JSON.parse(response);
      if (obj.val == 1) {
        toaster(
          "Piloto " +
            (is_active == 1 ? "desativado" : "ativado") +
            " com sucesso",
          "success",
        );
        loadTablePiloto();
        Swal.close();
      } else {
        moderr(obj.msg, "error");
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}

// Marcações - Avião =================================================================================================================
async function loadTableAviao() {
  await $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: {
      package: overal({
        origin: "module/core/php/tabelasAuxiliaresdb.php",
        function: "loadTableAviao",
        attr: "",
      }),
    },
  })
    .done(async function (response) {
      let obj = JSON.parse(response);
      if (obj["status"] == 1) {
        $("#tabAuxMarcacaoTables").html(obj["msg"]);
        $("#tabAuxAddBtn").html(obj["btn"]);
        createDataTable("tblAviao");
      } else {
        toaster(obj["msg"], "error");
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}
async function drawerAviao() {
  let msg = /*html*/ `
        <div class="row">
            <div class="col-8 mb-3">
                <label class="form-label">Descrição *</label>
                <input type="text" class="form-control" id="aviaoDescricao" required>
            </div>
            <div class="col-4 mb-3">
                <label class="form-label">Nº Lugares *</label>
                <input type="number" value="0" class="form-control" id="aviaoLugares" required>
            </div>
        </div>
    `;
  drawer("right", msg, "Adicionar avião");
  $("#drawerFooterBtn").attr("onclick", "addAviao()");
}
async function addAviao() {
  let info = {};
  let vazio = false;

  let descricao = $("#aviaoDescricao").val();

  if (descricao) {
    info["descricao"] = descricao;
  } else {
    vazio = true;
    toaster("Descrição é obrigatório", "warning");
  }

  let lugares = $("#aviaoLugares").val();

  if (lugares && lugares > 0) {
    info["lugares"] = lugares;
  } else {
    vazio = true;
    toaster("Nº de Lugares é obrigatório", "warning");
  }

  if (!vazio) {
    await $.ajax({
      type: "POST",
      url: "connect.php",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: {
        package: overal({
          origin: "module/core/php/tabelasAuxiliaresdb.php",
          function: "addAviao",
          attr: JSON.stringify(info),
        }),
      },
    })
      .done(function (response) {
        var obj = pars(JSON.parse(response));
        if (obj.val == 1) {
          toaster("Avião registado com sucesso", "success");
          loadTableAviao();
          Swal.close();
        } else {
          moderr(obj.msg, "error");
        }
      })
      .fail(function (jqXHR, textStatus) {
        moderr("Request failed: " + textStatus);
      });
  }
}
async function editAviao(id) {
  let info = {};
  info["id"] = id;

  await $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: {
      package: overal({
        origin: "module/core/php/tabelasAuxiliaresdb.php",
        function: "editAviao",
        attr: JSON.stringify(info),
      }),
    },
  })
    .done(async function (response) {
      let obj = JSON.parse(response);
      if (obj["status"] == 1) {
        let actDesactString =
          obj["get"]["is_active"] == 1
            ? "<i class='fa fa-trash'></i> Desativar"
            : "<i class='fa fa-check'></i> Ativar";
        let msg = /*html*/ `
                <ul class='nav nav-tabs'>
                    <li class='nav-items'>
                        <a href='#tab1' id='btntab1' data-toggle='tab' class='nav-link active'>
                            <span class='d-sm-none' id='util2'>Detalhes</span>
                            <span class='d-sm-block d-none' id='util3'>Detalhes</span>
                        </a>
                    </li>
                    <li class='nav-items'>
                        <a href='#tab2' id='btntab2' data-toggle='tab' class='nav-link'>
                            <span class='d-sm-none' id='util4'>Histórico</span>
                            <span class='d-sm-block d-none' id='util5'>Histórico</span>
                        </a>
                    </li>
                </ul>
                <div class='tab-content'>
                    <div class='tab-pane fade active show' id='tab1'>
                        <div class="row">
                            <div class="col-8 mb-3">
                                <label class="form-label">Descrição *</label>
                                <input type="text" class="form-control" id="aviaoDescricao" value="${obj["get"]["descricao"]}" required>
                            </div>
                            <div class="col-4 mb-3">
                                <label class="form-label">Nº Lugares *</label>
                                <input type="number" class="form-control" id="aviaoLugares" value="${obj["get"]["lugares"]}" required>
                            </div>
                        </div>
                    </div>
                    <div class='tab-pane fade' id='tab2'>
                        ${obj["responseLog"]["html"]}
                    </div>
                </div>
            `;
        let footer = /*html*/ `
             <div class='mt-4 drawer-footer' style='width: 100%'>
                ${perm["core"]["tabelasAuxiliares"]["Gerir"] ? `<a class='btn btn-white' style='color: ${obj["get"]["is_active"] == 1 ? "red" : "green"}' onclick="modconf('Tem a certeza que deseja ${obj["get"]["is_active"] == 1 ? "desativar" : "ativar"} este avião?', () => actDesactAviao(${id}, ${obj["get"]["is_active"]}))">${actDesactString}</a>` : ""}
                ${perm["core"]["tabelasAuxiliares"]["Editar"] ? `<a class='btn btn-success' style='color: white; float:right;' onclick='guardarEditAviao(${id})'>Guardar</a>` : ""}
            </div>
            `;
        drawer("right", msg, "Editar avião", "33%", footer);
      } else {
        toaster(obj["msg"], "error");
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}
async function guardarEditAviao(id) {
  let info = {};
  let vazio = false;
  info["id"] = id;

  let descricao = $("#aviaoDescricao").val();

  if (descricao) {
    info["descricao"] = descricao;
  } else {
    vazio = true;
    toaster("Descrição é obrigatório", "warning");
  }

  let lugares = $("#aviaoLugares").val();

  if (lugares && lugares > 0) {
    info["lugares"] = lugares;
  } else {
    vazio = true;
    toaster("Nº de Lugares é obrigatório", "warning");
  }

  if (!vazio) {
    var formData = new FormData();
    formData.append(
      "package",
      overal({
        origin: "module/core/php/tabelasAuxiliaresdb.php",
        function: "guardarEditAviao",
        attr: JSON.stringify(info),
      }),
    );
    await $.ajax({
      type: "POST",
      url: "connect.php",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: formData,
      processData: false,
      contentType: false,
    })
      .done(function (response) {
        var obj = JSON.parse(response);
        if (obj.val == 1) {
          toaster("Avião editado com sucesso", "success");
          loadTableAviao();
          Swal.close();
        } else {
          moderr(obj["msg"], "error");
        }
      })
      .fail(function (jqXHR, textStatus) {
        moderr("Request failed: " + textStatus);
      });
  }
}
async function actDesactAviao(id, is_active) {
  let info = {};
  info["id"] = id;
  info["is_active"] = is_active == 1 ? 0 : 1;

  var formData = new FormData();
  formData.append(
    "package",
    overal({
      origin: "module/core/php/tabelasAuxiliaresdb.php",
      function: "guardarEditAviao",
      attr: JSON.stringify(info),
    }),
  );
  await $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: formData,
    processData: false,
    contentType: false,
  })
    .done(function (response) {
      var obj = JSON.parse(response);
      if (obj.val == 1) {
        toaster(
          "Avião " +
            (is_active == 1 ? "desativado" : "ativado") +
            " com sucesso",
          "success",
        );
        loadTableAviao();
        Swal.close();
      } else {
        moderr(obj.msg, "error");
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}

// Marcações - Extra =================================================================================================================
async function loadTableExtra() {
  await $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: {
      package: overal({
        origin: "module/core/php/tabelasAuxiliaresdb.php",
        function: "loadTableExtra",
        attr: "",
      }),
    },
  })
    .done(async function (response) {
      let obj = JSON.parse(response);
      if (obj["status"] == 1) {
        $("#tabAuxMarcacaoTables").html(obj["msg"]);
        $("#tabAuxAddBtn").html(obj["btn"]);
        createDataTable("tblExtra");
      } else {
        toaster(obj["msg"], "error");
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}
async function drawerExtra() {
  let msg = /*html*/ `
        <div class="row">
            <div class="col-12 mb-3">
                <label class="form-label">Descrição *</label>
                <input type="text" class="form-control" id="extraDescricao" required>
            </div>
            <div class="col-12 mb-3">
                <label class="form-label">Observações</label>
                <input type="text" class="form-control" id="extraObservacoes" required>
            </div>
            <div class="col-12 mb-3">
                <label class="form-label">Preço</label>
                <input type="number" class="form-control" id="extraPreco" required>
            </div>
        </div>
    `;
  drawer("right", msg, "Adicionar extra");
  $("#drawerFooterBtn").attr("onclick", "addExtra()");
}
async function addExtra() {
  let info = {};
  let vazio = false;

  let descricao = $("#extraDescricao").val();
  let observacoes = $("#extraObservacoes").val();
  let preco = $("#extraPreco").val();

  if (descricao) {
    info["descricao"] = descricao;
  } else {
    vazio = true;
    toaster("Descrição é obrigatório", "warning");
  }

  info["observacoes"] = observacoes;
  info["preco"] = preco;

  if (!vazio) {
    await $.ajax({
      type: "POST",
      url: "connect.php",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: {
        package: overal({
          origin: "module/core/php/tabelasAuxiliaresdb.php",
          function: "addExtra",
          attr: JSON.stringify(info),
        }),
      },
    })
      .done(function (response) {
        var obj = pars(JSON.parse(response));
        if (obj.val == 1) {
          toaster("Extra registado com sucesso", "success");
          loadTableExtra();
          Swal.close();
        } else {
          moderr(obj.msg, "error");
        }
      })
      .fail(function (jqXHR, textStatus) {
        moderr("Request failed: " + textStatus);
      });
  }
}
async function editExtra(id) {
  let info = {};
  info["id"] = id;

  await $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: {
      package: overal({
        origin: "module/core/php/tabelasAuxiliaresdb.php",
        function: "editExtra",
        attr: JSON.stringify(info),
      }),
    },
  })
    .done(async function (response) {
      let obj = JSON.parse(response);
      if (obj["status"] == 1) {
        let actDesactString =
          obj["get"]["is_active"] == 1
            ? "<i class='fa fa-trash'></i> Desativar"
            : "<i class='fa fa-check'></i> Ativar";
        let msg = /*html*/ `
                <ul class='nav nav-tabs'>
                    <li class='nav-items'>
                        <a href='#tab1' id='btntab1' data-toggle='tab' class='nav-link active'>
                            <span class='d-sm-none' id='util2'>Detalhes</span>
                            <span class='d-sm-block d-none' id='util3'>Detalhes</span>
                        </a>
                    </li>
                    <li class='nav-items'>
                        <a href='#tab2' id='btntab2' data-toggle='tab' class='nav-link'>
                            <span class='d-sm-none' id='util4'>Histórico</span>
                            <span class='d-sm-block d-none' id='util5'>Histórico</span>
                        </a>
                    </li>
                </ul>
                <div class='tab-content'>
                    <div class='tab-pane fade active show' id='tab1'>
                        <div class="row">
                            <div class="col-12 mb-3">
                                <label class="form-label">Descrição *</label>
                                <input type="text" class="form-control" id="extraDescricao" value="${obj["get"]["descricao"]}" required>
                            </div>
                            <div class="col-12 mb-3">
                                <label class="form-label">Observações</label>
                                <input type="text" class="form-control" id="extraObservacoes" value="${obj["get"]["observacoes"]}">
                            </div>
                            <div class="col-12 mb-3">
                                <label class="form-label">Preço</label>
                                <input type="number" class="form-control" id="extraPreco" value="${obj["get"]["preco"]}">
                            </div>
                        </div>
                    </div>
                    <div class='tab-pane fade' id='tab2'>
                        ${obj["responseLog"]["html"]}
                    </div>
                </div>
            `;
        let footer = /*html*/ `
             <div class='mt-4 drawer-footer' style='width: 100%'>
                ${perm["core"]["tabelasAuxiliares"]["Gerir"] ? `<a class='btn btn-white' style='color: ${obj["get"]["is_active"] == 1 ? "red" : "green"}' onclick="modconf('Tem a certeza que deseja ${obj["get"]["is_active"] == 1 ? "desativar" : "ativar"} este extra?', () => actDesactExtra(${id}, ${obj["get"]["is_active"]}))">${actDesactString}</a>` : ""}
                ${perm["core"]["tabelasAuxiliares"]["Editar"] ? `<a class='btn btn-success' style='color: white; float:right;' onclick='guardarEditExtra(${id})'>Guardar</a>` : ""}
            </div>
            `;
        drawer("right", msg, "Editar extra", "33%", footer);
      } else {
        toaster(obj["msg"], "error");
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}
async function guardarEditExtra(id) {
  let info = {};
  let vazio = false;
  info["id"] = id;

  let descricao = $("#extraDescricao").val();
  let observacoes = $("#extraObservacoes").val();
  let preco = $("#extraPreco").val();

  if (descricao) {
    info["descricao"] = descricao;
  } else {
    vazio = true;
    toaster("Descrição é obrigatório", "warning");
  }

  info["observacoes"] = observacoes;
  info["preco"] = preco;

  if (!vazio) {
    var formData = new FormData();
    formData.append(
      "package",
      overal({
        origin: "module/core/php/tabelasAuxiliaresdb.php",
        function: "guardarEditExtra",
        attr: JSON.stringify(info),
      }),
    );
    await $.ajax({
      type: "POST",
      url: "connect.php",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: formData,
      processData: false,
      contentType: false,
    })
      .done(function (response) {
        var obj = JSON.parse(response);
        if (obj.val == 1) {
          toaster("Extra editado com sucesso", "success");
          loadTableExtra();
          Swal.close();
        } else {
          moderr(obj["msg"], "error");
        }
      })
      .fail(function (jqXHR, textStatus) {
        moderr("Request failed: " + textStatus);
      });
  }
}
async function actDesactExtra(id, is_active) {
  let info = {};
  info["id"] = id;
  info["is_active"] = is_active == 1 ? 0 : 1;

  var formData = new FormData();
  formData.append(
    "package",
    overal({
      origin: "module/core/php/tabelasAuxiliaresdb.php",
      function: "guardarEditExtra",
      attr: JSON.stringify(info),
    }),
  );
  await $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: formData,
    processData: false,
    contentType: false,
  })
    .done(function (response) {
      var obj = JSON.parse(response);
      if (obj.val == 1) {
        toaster(
          "Extra " +
            (is_active == 1 ? "desativado" : "ativado") +
            " com sucesso",
          "success",
        );
        loadTableExtra();
        Swal.close();
      } else {
        moderr(obj.msg, "error");
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}

// Marcações - Produto =================================================================================================================
async function loadTableProduto() {
  await $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: {
      package: overal({
        origin: "module/core/php/tabelasAuxiliaresdb.php",
        function: "loadTableProduto",
        attr: "",
      }),
    },
  })
    .done(async function (response) {
      let obj = JSON.parse(response);
      if (obj["status"] == 1) {
        $("#tabAuxMarcacaoTables").html(obj["msg"]);
        $("#tabAuxAddBtn").html(obj["btn"]);
        createDataTable("tblProduto");
      } else {
        toaster(obj["msg"], "error");
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}
async function drawerProduto() {
  await $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: {
      package: overal({
        origin: "module/core/php/tabelasAuxiliaresdb.php",
        function: "drawerProduto",
        attr: JSON.stringify({}),
      }),
    },
  })
    .done(function (response) {
      var obj = pars(JSON.parse(response));
      if (obj.val == 1) {
        let msg = /*html*/ `
                <div class="row" id="formProduto">
                    <div class="col-12 mb-3">
                        <label class="form-label">Cod *</label>
                        <input type="text" class="form-control" id="produtoCod" required>
                    </div>
                    <div class="col-12 mb-3">
                        <label class="form-label">Descrição *</label>
                        <input type="text" class="form-control" id="produtoDescricao" required>
                    </div>
                    <div class="col-12 mb-3">
                        <label class="form-label">Tipo</label>
                        <select class="form-control" id="produtoTipo">
                        </select>
                    </div>
                    <div class="col-12 mb-3">
                        <label class="form-label">Extra</label>
                        <select class="form-control" id="produtoExtra">
                        </select>
                    </div>
                </div>
            `;
        drawer("right", msg, "Adicionar produto");
        $("#drawerFooterBtn").attr("onclick", "addProduto()");
        let htmlSelectTipo =
          `<option value='0'>Selecione uma opção...</option>` +
          obj.sky_tipo.map(
            (item) => `<option value='${item.id}'>${item.descricao}</option>`,
          );
        $("#produtoTipo").html(htmlSelectTipo);
        $("#produtoTipo").select2({
          closeOnSelect: false,
          width: "100%",
          dropdownParent: $("#formProduto"),
        });
        let htmlSelectExtra =
          `<option value='0'>Selecione uma opção...</option>` +
          obj.sky_extra.map(
            (item) => `<option value='${item.id}'>${item.descricao}</option>`,
          );
        $("#produtoExtra").html(htmlSelectExtra);
        $("#produtoExtra").select2({
          closeOnSelect: false,
          width: "100%",
          dropdownParent: $("#formProduto"),
        });
      } else {
        moderr(obj.msg, "error");
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}
async function addProduto() {
  let info = {};
  let vazio = false;

  let cod = $("#produtoCod").val();
  let descricao = $("#produtoDescricao").val();

  if (cod) {
    info["cod"] = cod;
  } else {
    vazio = true;
    toaster("Cod é obrigatório", "warning");
  }

  info["descricao"] = descricao;

  if (!vazio) {
    await $.ajax({
      type: "POST",
      url: "connect.php",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: {
        package: overal({
          origin: "module/core/php/tabelasAuxiliaresdb.php",
          function: "addProduto",
          attr: JSON.stringify(info),
        }),
      },
    })
      .done(function (response) {
        var obj = pars(JSON.parse(response));
        if (obj.val == 1) {
          toaster("Produto registado com sucesso", "success");
          loadTableProduto();
          Swal.close();
        } else {
          moderr(obj.msg, "error");
        }
      })
      .fail(function (jqXHR, textStatus) {
        moderr("Request failed: " + textStatus);
      });
  }
}
async function editProduto(id) {
  let info = {};
  info["id"] = id;

  await $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: {
      package: overal({
        origin: "module/core/php/tabelasAuxiliaresdb.php",
        function: "editProduto",
        attr: JSON.stringify(info),
      }),
    },
  })
    .done(async function (response) {
      let obj = JSON.parse(response);
      if (obj["status"] == 1) {
        let actDesactString =
          obj["get"]["is_active"] == 1
            ? "<i class='fa fa-trash'></i> Desativar"
            : "<i class='fa fa-check'></i> Ativar";
        let msg = /*html*/ `
                <ul class='nav nav-tabs'>
                    <li class='nav-items'>
                        <a href='#tab1' id='btntab1' data-toggle='tab' class='nav-link active'>
                            <span class='d-sm-none' id='util2'>Detalhes</span>
                            <span class='d-sm-block d-none' id='util3'>Detalhes</span>
                        </a>
                    </li>
                    <li class='nav-items'>
                        <a href='#tab2' id='btntab2' data-toggle='tab' class='nav-link'>
                            <span class='d-sm-none' id='util4'>Histórico</span>
                            <span class='d-sm-block d-none' id='util5'>Histórico</span>
                        </a>
                    </li>
                </ul>
                <div class='tab-content' id="formProduto">
                    <div class='tab-pane fade active show' id='tab1'>
                        <div class="row">
                            <div class="col-12 mb-3">
                                <label class="form-label">Cod *</label>
                                <input type="text" class="form-control" id="produtoCod" value="${obj["get"]["cod"]}" required>
                            </div>
                            <div class="col-12 mb-3">
                                <label class="form-label">Observações</label>
                                <input type="text" class="form-control" id="produtoDescricao" value="${obj["get"]["descricao"]}">
                            </div>
                            <div class="col-12 mb-3">
                                <label class="form-label">Tipo</label>
                                <select class="form-control" id="produtoTipo" ${obj["get"]["id_extra"] != null ? "disabled" : ""}>
                                </select>
                            </div>
                            <div class="col-12 mb-3">
                                <label class="form-label">Extra</label>
                                <select class="form-control" id="produtoExtra" ${obj["get"]["id_tipo"] != null ? "disabled" : ""}>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class='tab-pane fade' id='tab2'>
                        ${obj["responseLog"]["html"]}
                    </div>
                </div>
            `;
        let footer = /*html*/ `
             <div class='mt-4 drawer-footer' style='width: 100%'>
                <!-- ${perm["core"]["tabelasAuxiliares"]["Gerir"] ? `<a class='btn btn-white' style='color: ${obj["get"]["is_active"] == 1 ? "red" : "green"}' onclick="modconf('Tem a certeza que deseja ${obj["get"]["is_active"] == 1 ? "desativar" : "ativar"} este produto?', () => actDesactProduto(${id}, ${obj["get"]["is_active"]}))">${actDesactString}</a>` : ""} -->
                ${perm["core"]["tabelasAuxiliares"]["Editar"] ? `<a class='btn btn-success' style='color: white; float:right;' onclick='guardarEditProduto(${id})'>Guardar</a>` : ""}
            </div>
            `;
        drawer("right", msg, "Editar produto", "33%", footer);
        let htmlSelectTipo =
          `<option value='0'>Selecione uma opção...</option>` +
          obj.sky_tipo.map(
            (item) =>
              `<option ${obj["get"]["id_tipo"] != null && obj["get"]["id_tipo"] == item.id ? "selected" : ""} value='${item.id}'>${item.descricao}</option>`,
          );
        $("#produtoTipo").html(htmlSelectTipo);
        $("#produtoTipo").select2({
          closeOnSelect: false,
          width: "100%",
          dropdownParent: $("#formProduto"),
        });
        let htmlSelectExtra =
          `<option value='0'>Selecione uma opção...</option>` +
          obj.sky_extra.map(
            (item) =>
              `<option ${obj["get"]["id_extra"] != null && obj["get"]["id_extra"] == item.id ? "selected" : ""} value='${item.id}'>${item.descricao}</option>`,
          );
        $("#produtoExtra").html(htmlSelectExtra);
        $("#produtoExtra").select2({
          closeOnSelect: false,
          width: "100%",
          dropdownParent: $("#formProduto"),
        });
        $("#produtoExtra").on("change", function () {
          if (
            $(this).val() == null ||
            $(this).val() == "null" ||
            $(this).val() == 0
          ) {
            $("#produtoExtra").removeAttr("disabled");
            $("#produtoTipo").removeAttr("disabled");
          } else {
            $("#produtoTipo").prop("disabled", true);
          }
        });
        $("#produtoTipo").on("change", function () {
          if (
            $(this).val() == null ||
            $(this).val() == "null" ||
            $(this).val() == 0
          ) {
            $("#produtoExtra").removeAttr("disabled");
            $("#produtoTipo").removeAttr("disabled");
          } else {
            $("#produtoExtra").prop("disabled", true);
          }
        });
      } else {
        toaster(obj["msg"], "error");
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}
async function guardarEditProduto(id) {
  let info = {};
  let vazio = false;
  info["id"] = id;

  let cod = $("#produtoCod").val();
  let descricao = $("#produtoDescricao").val();
  let id_tipo = $("#produtoTipo").val();
  let id_extra = $("#produtoExtra").val();

  if (cod) {
    info["cod"] = cod;
  } else {
    vazio = true;
    toaster("Cod é obrigatório", "warning");
  }

  info["descricao"] = descricao;

  if (id_tipo != 0) {
    info["id_tipo"] = id_tipo;
  } else if (id_extra != 0) {
    info["id_extra"] = id_extra;
  }

  if (!vazio) {
    var formData = new FormData();
    formData.append(
      "package",
      overal({
        origin: "module/core/php/tabelasAuxiliaresdb.php",
        function: "guardarEditProduto",
        attr: JSON.stringify(info),
      }),
    );
    await $.ajax({
      type: "POST",
      url: "connect.php",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: formData,
      processData: false,
      contentType: false,
    })
      .done(function (response) {
        var obj = JSON.parse(response);
        if (obj.val == 1) {
          toaster("Produto editado com sucesso", "success");
          loadTableProduto();
          Swal.close();
        } else {
          moderr(obj["msg"], "error");
        }
      })
      .fail(function (jqXHR, textStatus) {
        moderr("Request failed: " + textStatus);
      });
  }
}
async function actDesactProduto(id, is_active) {
  let info = {};
  info["id"] = id;
  info["is_active"] = is_active == 1 ? 0 : 1;

  var formData = new FormData();
  formData.append(
    "package",
    overal({
      origin: "module/core/php/tabelasAuxiliaresdb.php",
      function: "guardarEditProduto",
      attr: JSON.stringify(info),
    }),
  );
  await $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: formData,
    processData: false,
    contentType: false,
  })
    .done(function (response) {
      var obj = JSON.parse(response);
      if (obj.val == 1) {
        toaster(
          "Produto " +
            (is_active == 1 ? "desativado" : "ativado") +
            " com sucesso",
          "success",
        );
        loadTableProduto();
        Swal.close();
      } else {
        moderr(obj.msg, "error");
      }
    })
    .fail(function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    });
}
