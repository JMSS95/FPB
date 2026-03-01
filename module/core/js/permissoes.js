function loadTipo() {
    $.ajax({
        type: 'POST',
        url: 'connect.php',
        headers: {
            "Authorization": "Bearer " + md5(localStorage.getItem('sessionObject'))
        },
        data: { package: overal({ origin: 'module/core/php/permissoesdb.php', function: "loadTipo", attr: "" }) },
        success: function (response) {
            var res = JSON.parse(response);
            document.getElementById('jja_tabela1').innerHTML = res['msg'];
            $("#jja_tabela1").show("slow");
            $("#jja_tabela2").hide("slow");
            $("#currenttitle").html("Tipos de Utilizador");
            $("#currentbtn").html("");
            createDataTable("tabl1");
        }
    });
}

var arrperm = [];
var permissoes = [];
function loadPerm(id) {
    arrperm = [];
    permissoes = [];
    $.ajax({
        type: 'POST',
        url: 'connect.php',
        headers: {
            "Authorization": "Bearer " + md5(localStorage.getItem('sessionObject'))
        },
        data: { package: overal({ origin: 'module/core/php/permissoesdb.php', function: "loadPerm", attr: id }) },
        success: function (response) {
            var res = JSON.parse(response);
            document.getElementById('accordion').innerHTML = res['msg'];
            $("#jja_tabela1").hide("slow");
            $("#jja_tabela2").show("slow");
            $("#currenttitle").html(res['titulo']);
            $("#currentbtn").html(res['btn']);
            if (perm['core']['permissoes']['Editar']) {
                $("#mudarperm").show();
            } else {
                $("#mudarperm").hide();
            }
            for (var i = 0; i < res['arr'].length; i++) {
                arrperm[i] = res['arr'][i];
            }
            loadtab(0);
        }
    });
}


function changePerm(id) {
    $.ajax({
        type: 'POST',
        url: 'connect.php',
        headers: {
            "Authorization": "Bearer " + md5(localStorage.getItem('sessionObject'))
        },
        data: { package: overal({ origin: 'module/core/php/permissoesdb.php', function: "changePerm", attr: JSON.stringify({ arr: permissoes, id: id }) }) },
        success: function (response) {
            var obj = JSON.parse(response);
            if (obj.val == 1) {
                loadPerm(id);
                toaster(obj.msg, "success");
            } else {
                toaster(obj.msg, "error");
            }
        }
    });
}

function loadtab(esc) {
    if (esc == 0) {
        for (var i = 0; i < arrperm.length; i++) {
            var tab = "";
            for (var j = 0; j < arrperm[i]['arr'].length; j++) {

                tab += "<tr><th colspan='4'><h5>" + arrperm[i]['arr'][j]['page'] + "</h5></th></tr>";
                for (var k = 0; k < arrperm[i]['arr'][j]['arr'].length; k++) {
                    permissoes[arrperm[i]['arr'][j]['arr'][k]['id']] = { id: arrperm[i]['arr'][j]['arr'][k]['id'], check: arrperm[i]['arr'][j]['arr'][k]['check'] };
                    if (perm['core']['permissoes']['Editar']) {
                        if (k % 2 != 0) {

                            if (arrperm[i]['arr'][j]['arr'][k]['check'] == 1) {
                                tab += "<td id='permtd1" + arrperm[i]['arr'][j]['arr'][k]['id'] + "' onclick='changeEst(" + i + "," + j + "," + k + ",0," + arrperm[i]['arr'][j]['arr'][k]['id'] + ")' style='background-color:rgba(0, 128, 0, 0.5);color:white;cursor:pointer;'>" + arrperm[i]['arr'][j]['arr'][k]['descricao'] + "</td>";
                                tab += "<td id='permtd2" + arrperm[i]['arr'][j]['arr'][k]['id'] + "' onclick='changeEst(" + i + "," + j + "," + k + ",0," + arrperm[i]['arr'][j]['arr'][k]['id'] + ")' style='background-color:rgba(0, 128, 0, 0.5);color:white;cursor:pointer;'><center><i class='fa fa-check'></i></center></td>";
                            } else {
                                tab += "<td id='permtd1" + arrperm[i]['arr'][j]['arr'][k]['id'] + "' onclick='changeEst(" + i + "," + j + "," + k + ",1," + arrperm[i]['arr'][j]['arr'][k]['id'] + ")' style='background-color:rgba(255, 0, 0, 0.5);color:white;cursor:pointer;'>" + arrperm[i]['arr'][j]['arr'][k]['descricao'] + "</td>";
                                tab += "<td id='permtd2" + arrperm[i]['arr'][j]['arr'][k]['id'] + "' onclick='changeEst(" + i + "," + j + "," + k + ",1," + arrperm[i]['arr'][j]['arr'][k]['id'] + ")' style='background-color:rgba(255, 0, 0, 0.5);color:white;cursor:pointer;'><center><i class='fa fa-times'></i></center></td>";
                            }
                            tab += "</tr>";
                        } else {
                            if (arrperm[i]['arr'][j]['arr'][k]['check'] == 1) {
                                tab += "<td id='permtd1" + arrperm[i]['arr'][j]['arr'][k]['id'] + "' onclick='changeEst(" + i + "," + j + "," + k + ",0," + arrperm[i]['arr'][j]['arr'][k]['id'] + ")' style='background-color:rgba(0, 128, 0, 0.5);color:white;cursor:pointer;'>" + arrperm[i]['arr'][j]['arr'][k]['descricao'] + "</td>";
                                tab += "<td id='permtd2" + arrperm[i]['arr'][j]['arr'][k]['id'] + "' onclick='changeEst(" + i + "," + j + "," + k + ",0," + arrperm[i]['arr'][j]['arr'][k]['id'] + ")' style='background-color:rgba(0, 128, 0, 0.5);color:white;cursor:pointer;'><center><i class='fa fa-check'></i></center></td>";
                            } else {
                                tab += "<td id='permtd1" + arrperm[i]['arr'][j]['arr'][k]['id'] + "' onclick='changeEst(" + i + "," + j + "," + k + ",1," + arrperm[i]['arr'][j]['arr'][k]['id'] + ")' style='background-color:rgba(255, 0, 0, 0.5);color:white;cursor:pointer;'>" + arrperm[i]['arr'][j]['arr'][k]['descricao'] + "</td>";
                                tab += "<td id='permtd2" + arrperm[i]['arr'][j]['arr'][k]['id'] + "' onclick='changeEst(" + i + "," + j + "," + k + ",1," + arrperm[i]['arr'][j]['arr'][k]['id'] + ")' style='background-color:rgba(255, 0, 0, 0.5);color:white;cursor:pointer;'><center><i class='fa fa-times'></i></center></td>";
                            }
                        }
                    } else {
                        if (k % 2 != 0) {
                            tab += "<td>" + arrperm[i]['arr'][j]['arr'][k]['descricao'] + "</td>";
                            if (arrperm[i]['arr'][j]['arr'][k]['check'] == 1) {
                                tab += "<td style='background-color:rgba(0, 128, 0, 0.5);color:white;'>" + arrperm[i]['arr'][j]['arr'][k]['descricao'] + "</td>";
                                tab += "<td style='background-color:rgba(0, 128, 0, 0.5);color:white;'><center><i class='fa fa-check'></i></center></td>";
                            } else {
                                tab += "<td style='background-color:rgba(255, 0, 0, 0.5);color:white;'>" + arrperm[i]['arr'][j]['arr'][k]['descricao'] + "</td>";
                                tab += "<td style='background-color:rgba(255, 0, 0, 0.5);color:white;'><center><i class='fa fa-times'></i></center></td>";
                            }
                            tab += "</tr>";
                        } else {
                            tab += "<tr><td>" + arrperm[i]['arr'][j]['arr'][k]['descricao'] + "</td>";
                            if (arrperm[i]['arr'][j]['arr'][k]['check'] == 1) {
                                tab += "<td style='background-color:rgba(0, 128, 0, 0.5);color:white;'>" + arrperm[i]['arr'][j]['arr'][k]['descricao'] + "</td>";
                                tab += "<td style='background-color:rgba(0, 128, 0, 0.5);color:white;'><center><i class='fa fa-check'></i></center></td>";
                            } else {
                                tab += "<td style='background-color:rgba(255, 0, 0, 0.5);color:white;'>" + arrperm[i]['arr'][j]['arr'][k]['descricao'] + "</td>";
                                tab += "<td style='background-color:rgba(255, 0, 0, 0.5);color:white;'><center><i class='fa fa-times'></i></center></td>";
                            }
                        }
                    }
                }
                if (k % 2 != 0) {
                    tab += "<td colspan='2'></td></tr>";
                }
            }
            $("#tabacc" + arrperm[i]['id']).html(tab);
        }
    } else {
        var tab = "";
        for (var j = 0; j < arrperm[esc]['arr'].length; j++) {

            tab += "<tr><th colspan='4'><h5>" + arrperm[esc]['arr'][j]['page'] + "</h5></th></tr>";
            for (var k = 0; k < arrperm[esc]['arr'][j]['arr'].length; k++) {
                if (perm['core']['permissoes']['Editar']) {
                    if (k % 2 != 0) {
                        if (arrperm[esc]['arr'][j]['arr'][k]['check'] == 1) {
                            tab += "<td id='permtd1" + arrperm[esc]['arr'][j]['arr'][k]['id'] + "' onclick='changeEst(" + esc + "," + j + "," + k + ",0," + arrperm[esc]['arr'][j]['arr'][k]['id'] + ")' style='background-color:rgba(0, 128, 0, 0.5);color:white;cursor:pointer;'>" + arrperm[esc]['arr'][j]['arr'][k]['descricao'] + "</td>";
                            tab += "<td id='permtd2" + arrperm[esc]['arr'][j]['arr'][k]['id'] + "' onclick='changeEst(" + esc + "," + j + "," + k + ",0," + arrperm[esc]['arr'][j]['arr'][k]['id'] + ")' style='background-color:rgba(0, 128, 0, 0.5);color:white;cursor:pointer;'><center><i class='fa fa-check'></i></center></td>";
                        } else {
                            tab += "<td id='permtd1" + arrperm[esc]['arr'][j]['arr'][k]['id'] + "' onclick='changeEst(" + esc + "," + j + "," + k + ",1," + arrperm[esc]['arr'][j]['arr'][k]['id'] + ")' style='background-color:rgba(255, 0, 0, 0.5);color:white;cursor:pointer;'>" + arrperm[esc]['arr'][j]['arr'][k]['descricao'] + "</td>";
                            tab += "<td id='permtd2" + arrperm[esc]['arr'][j]['arr'][k]['id'] + "' onclick='changeEst(" + esc + "," + j + "," + k + ",1," + arrperm[esc]['arr'][j]['arr'][k]['id'] + ")' style='background-color:rgba(255, 0, 0, 0.5);color:white;cursor:pointer;'><center><i class='fa fa-times'></i></center></td>";
                        }
                        tab += "</tr>";
                    } else {
                        if (arrperm[esc]['arr'][j]['arr'][k]['check'] == 1) {
                            tab += "<tr><td id='permtd1" + arrperm[esc]['arr'][j]['arr'][k]['id'] + "' onclick='changeEst(" + esc + "," + j + "," + k + ",0," + arrperm[esc]['arr'][j]['arr'][k]['id'] + ")' style='background-color:rgba(0, 128, 0, 0.5);color:white;cursor:pointer;'>" + arrperm[esc]['arr'][j]['arr'][k]['descricao'] + "</td>";
                            tab += "<td id='permtd1" + arrperm[esc]['arr'][j]['arr'][k]['id'] + "' onclick='changeEst(" + esc + "," + j + "," + k + ",0," + arrperm[esc]['arr'][j]['arr'][k]['id'] + ")' style='background-color:rgba(0, 128, 0, 0.5);color:white;cursor:pointer;'><center><i class='fa fa-check'></i></center></td>";
                        } else {
                            tab += "<tr><td id='permtd1" + arrperm[esc]['arr'][j]['arr'][k]['id'] + "' onclick='changeEst(" + esc + "," + j + "," + k + ",1," + arrperm[esc]['arr'][j]['arr'][k]['id'] + ")' style='background-color:rgba(255, 0, 0, 0.5);color:white;cursor:pointer;'>" + arrperm[esc]['arr'][j]['arr'][k]['descricao'] + "</td>";
                            tab += "<td id='permtd1" + arrperm[esc]['arr'][j]['arr'][k]['id'] + "' onclick='changeEst(" + esc + "," + j + "," + k + ",1," + arrperm[esc]['arr'][j]['arr'][k]['id'] + ")' style='background-color:rgba(255, 0, 0, 0.5);color:white;cursor:pointer;'><center><i class='fa fa-times'></i></center></td>";
                        }
                    }
                } else {
                    if (k % 2 != 0) {

                        if (arrperm[esc]['arr'][j]['arr'][k]['check'] == 1) {
                            tab += "<td style='background-color:rgba(0, 128, 0, 0.5);color:white;'>" + arrperm[esc]['arr'][j]['arr'][k]['descricao'] + "</td>";
                            tab += "<td style='background-color:rgba(0, 128, 0, 0.5);olor:white;'><center><i class='fa fa-check'></i></center></td>";
                        } else {
                            tab += "<td style='background-color:rgba(255, 0, 0, 0.5);color:white;'>" + arrperm[esc]['arr'][j]['arr'][k]['descricao'] + "</td>";
                            tab += "<td style='background-color:rgba(255, 0, 0, 0.5);olor:white;'><center><i class='fa fa-times'></i></center><td>";
                        }
                        tab += "</tr>";
                    } else {

                        if (arrperm[esc]['arr'][j]['arr'][k]['check'] == 1) {
                            tab += "<tr><td style='background-color:rgba(0, 128, 0, 0.5);color:white;'>" + arrperm[esc]['arr'][j]['arr'][k]['descricao'] + "</td>";
                            tab += "<td style='background-color:rgba(0, 128, 0, 0.5);olor:white;'><center><i class='fa fa-check'></i></center></td>";
                        } else {
                            tab += "<tr><td style='background-color:rgba(255, 0, 0, 0.5);color:white;'>" + arrperm[esc]['arr'][j]['arr'][k]['descricao'] + "</td>";
                            tab += "<td style='background-color:rgba(255, 0, 0, 0.5);olor:white;'><center><i class='fa fa-times'></i></center><td>";
                        }
                    }
                }

            }
            if (k % 2 != 0) {
                tab += "<td colspan='2'></td></tr>";
            }
        }
        $("#tabacc" + arrperm[esc]['id']).html(tab);
    }
}

function changeEst(i, j, k, esc, id) {
    arrperm[i]['arr'][j]['arr'][k]['check'] = esc;
    permissoes[id]['check'] = esc;
    // console.log()
    if (esc == 1) {
        $("#permtd1" + id).css("background-color", "rgba(0, 128, 0, 0.5)");
        $("#permtd1" + id).css("color", "white;");
        $("#permtd1" + id).attr("onclick", "changeEst(" + i + "," + j + "," + k + ",0," + id + ")");
        $("#permtd2" + id).css("background-color", "rgba(0, 128, 0, 0.5)");
        $("#permtd2" + id).css("color", "white;");
        $("#permtd2" + id).attr("onclick", "changeEst(" + i + "," + j + "," + k + ",0," + id + ")");
        $("#permtd2" + id).html("<center><i class='fa fa-check'></i></center>");
    } else {
        $("#permtd1" + id).css("background-color", "rgba(255, 0, 0, 0.5)");
        $("#permtd1" + id).css("color", "white;");
        $("#permtd1" + id).attr("onclick", "changeEst(" + i + "," + j + "," + k + ",1," + id + ")");
        $("#permtd2" + id).css("background-color", "rgba(255, 0, 0, 0.5)");
        $("#permtd2" + id).css("color", "white;");
        $("#permtd2" + id).attr("onclick", "changeEst(" + i + "," + j + "," + k + ",1," + id + ")");
        $("#permtd2" + id).html("<center><i class='fa fa-times'></i></center>");
    }
    //loadtab(i);
}