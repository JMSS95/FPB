function topbar(){
    $.ajax({
        type    : 'POST',
        url     : 'connect.php',
        headers: {
            "Authorization": "Bearer " + md5(localStorage.getItem('sessionObject'))
        },
        data    : {package: overal({origin: 'php/maindb.php', function: "topbar", attr: ""})},
    }).done(function(response){
        var res = pars(JSON.parse(response));
        var divs = "";
        for(var i = 0;i < res['arr'].length;i++){
            divs += "<div class='col-lg-"+(parseInt(res['arr'][i]['espaco'])*6)+" col-md-12 col-12' id='masterdiv"+res['arr'][i]['opcao']+"'>";
            divs += "<div class='panel panel-inverse'>";
            divs += "<div class='panel-heading' id='blackbar_"+res['arr'][i]['opcao']+"'>";
            divs += "<div class='panel-heading-btn' id='content"+res['arr'][i]['opcao']+"btn'>";
            divs += "</div>";
            divs += "<h4 class='panel-title'>"+res['arr'][i]['titulo']+"</h4>";
            divs += "</div>";
            if(res['arr'][i]['opcao'] == 8){
                divs += "<div class='panel-body panel-with-tabs'>";
            }else{
                divs += "<div class='panel-body'>";
            }
            divs += "<div id='content"+res['arr'][i]['opcao']+"'></div>";
            divs += "</div>";
            divs += "<a id='btncontent"+res['arr'][i]['opcao']+"' class='btn btn-xs btn-icon btn-circle btn-default' data-click='panel-refresh' style='visibility:hidden;'><i class='fa fa-sync'></i></a>";
            divs += "</div>";
            divs += "</div>";
        }
        $("#dashrows").html(divs);
        
        for(var i = 0;i < res['arr'].length;i++){
            if(res['arr'][i]['opcao'] == 1){
                var data = new Date();
                cal(Number(data.getMonth()+1),data.getFullYear(),2,res['arr'][i]['user']);    
              }else{
                reworkbar(res['arr'][i]['opcao']);
              }
        }
    }).fail(function( jqXHR, textStatus ) {
        moderr(textStatus);
    });
}

var myChart1="";
var myChart2="";
var myChart3="";
var myChart4="";
var myChart5="";
var myChart6="";
var myChart7="";

//top bar
function reworkbar(esc){
    $.ajax({
        type    : 'POST',
        url     : 'connect.php',
        headers: {
            "Authorization": "Bearer " + md5(localStorage.getItem('sessionObject'))
        },
        data    : {package: overal({origin: 'php/maindb.php',function: "reworkbar", attr: esc})},
    }).done(function(response){
        var res = pars(JSON.parse(response));
        $("#content"+esc).html(res['msg']);
        $("#content"+esc+"btn").html(res['btn']);
    }).fail(function( jqXHR, textStatus ) {
        moderr(textStatus);
    });
}

function abrelink(link){
    function getLocation() {
        if (navigator.geolocation) {
        } else {
            window.open("https://www.google.pt/maps/@"+link+"z",'_blank');
        }
        function showPosition(position) {
          window.open("https://maps.google.com/maps?saddr="+position.coords.latitude+","+position.coords.longitude+"&daddr="+link,'_blank');
        }
    }
    getLocation();
}

function loadbtncontent(iduser){
    $.ajax({
        type    : 'POST',
        url     : 'php/maindb.php',
        data    : {op: 11,id: iduser},
        success : function(response) {
            var res = JSON.parse(response);       
            $("#content1btn").html(res['msg']);
        }
    }); 
}

function cal(mes,ano,tipo,id){
    if(tipo != 2){
        $("#divinfodia").hide("slow");
    }
    let info = {};
    info['mes'] = mes;
    info['ano'] = ano;
    info['tipo'] = tipo;
    info['id'] = id;
    $.ajax({
        type    : 'POST',
        url     : 'connect.php',
        headers: {
            "Authorization": "Bearer " + md5(localStorage.getItem('sessionObject'))
        },
        data    : {package: overal({origin: 'php/maindb.php',function: "cal", attr: JSON.stringify({info: info})})},
    }).done(function(response){
        var info = JSON.parse(response);
        $('#content1').html(info['msg']); 
        $("#divinfodia").html("");
        $("#divcalendario").show("slow");
        loadbtncontent(id);
        
        $("#btncontent1").attr("onclick","cal("+mes+","+ano+","+tipo+","+id+")");
        var options = {
            chart: {
                height: 350,
                type: 'line',
                shadow: {
                    enabled: true,
                    color: COLOR_DARK,
                    top: 18,
                    left: 7,
                    blur: 10,
                    opacity: 1
                },
                toolbar: {
                    show: false
                }
             },
            // title: {
            //     text: 'Assiduidade '+info['title'],
            //     align: 'center'
            // },
            colors: [COLOR_BLUE,  COLOR_GREEN],
            dataLabels: {
                enabled: true,
            },
            stroke: {
                curve: 'smooth',
                width: 3
            },
            series: [{
                name: 'Tempo Previsto',
                data: info['arr']['total']
            },  {
                name: 'Tempo Total',
                data: info['arr']['prod']
            }],
            grid: {
                row: {
                    colors: [COLOR_SILVER_TRANSPARENT_1, 'transparent'], // takes an array which will be repeated on columns
                    opacity: 0.5
                },
            },
            markers: {
                size: 4
            },
            xaxis: {
                categories: info['arr']['datas'],
                axisBorder: {
                    show: true,
                    color: COLOR_SILVER_TRANSPARENT_5,
                    height: 1,
                    width: '100%',
                    offsetX: 0,
                    offsetY: -1
                },
                axisTicks: {
                    show: true,
                    borderType: 'solid',
                    color: COLOR_SILVER,
                    height: 6,
                    offsetX: 0,
                    offsetY: 0
                }
            },
            legend: {
                show: true,
                position: 'bottom',
                offsetY: -10,
                horizontalAlign: 'right',
                floating: true,
            }
        };

        var chart = new ApexCharts(
            document.querySelector('#apex-line-chart'),
            options
        );

        chart.render();
    }).fail(function( jqXHR, textStatus ) {
        moderr(textStatus);
    });  
}

// main_demo.js
var fix = 0;
var lostid = 0;
function getBase64Encode(rawStr) {
    var wordArray = CryptoJS.enc.Utf8.parse(rawStr);
    var result = CryptoJS.enc.Base64.stringify(wordArray);
    return result;
}
function getBase64Decode(encStr) {
    var wordArray = CryptoJS.enc.Base64.parse(encStr);
    var result = wordArray.toString(CryptoJS.enc.Utf8);
    return result;
}
function reverse(s) {
    return s.split("").reverse().join("");
}
function overall(info) {
    var loadTimerUrl = "";
    if (localStorage.getItem('sessionObject')) {
        var missingObject = localStorage.getItem('sessionObject').split(".");
        missingObject = JSON.parse(getBase64Decode(missingObject[1]));
        loadTimerUrl = "uploads/utilizadores/userlog" + missingObject['login'] + "/noti.json";
        fix = missingObject['fix'];
        missingObject = "";
    } else {
        loadTimerUrl = "uploads/utilizadores/userlog" + lostid + "/noti.json";
    }
    var extratxt = "";
    function loadTimer(callback) {
        var newtemporal = new Date().valueOf();
        $.ajax({
            type: 'POST',
            url: loadTimerUrl + "?v=" + newtemporal,
        }).done(function (response) {
            callback(response);
        }).fail(function (jqXHR, textStatus) {
            callback(JSON.stringify({ timer: md5(' '), fix: 0 }));
        });
    }
    loadTimer(function (response) {
        // Parse JSON string into object
        var res = typeof response === 'string' || response instanceof String ? JSON.parse(response) : response;
        extratxt = res['timer'];
        fix = res['fix'];
    });
    var demo_header = '{"typ": "JWT","alg": "HS256"}';
    var demo_payload = JSON.stringify(info);
    var base64Header = getBase64Encode(demo_header);
    var base64Payload = getBase64Encode(demo_payload);
    var signature = CryptoJS.HmacSHA256(base64Header + "." + base64Payload, extratxt);
    var base64sign = CryptoJS.enc.Base64.stringify(signature);
    var jwt = base64Header + "." + base64Payload + "." + base64sign;
    return jwt;
}

function overal(info) {
    var loadTimerUrl = "";
    var extratxt = "";
    if (localStorage.getItem('sessionObject')) {
        var missingObject = localStorage.getItem('sessionObject').split(".");
        missingObject = JSON.parse(getBase64Decode(missingObject[1]));
        extratxt = reverse(missingObject['timer']);
        fix = missingObject['fix'];
        missingObject = "";
    } else {
        loadTimerUrl = "uploads/utilizadores/userlog" + lostid + "/noti.json";
        function loadTimer(callback) {
            var newtemporal = new Date().valueOf();
            $.ajax({
                type: 'POST',
                url: loadTimerUrl + "?v=" + newtemporal,
            }).done(function (response) {
                callback(response);
            }).fail(function (jqXHR, textStatus) {
                callback(JSON.stringify({ timer: md5(' '), fix: 0 }));
            });
        }
        loadTimer(function (response) {
            // Parse JSON string into object
            var res = typeof response === 'string' || response instanceof String ? JSON.parse(response) : response;
            extratxt = res['timer'];
            fix = res['fix'];
        });
    }
    if (parseInt(fix) == 1) {
        return JSON.stringify(info);
    } else {
        // return JSON.stringify(info);
        var demo_header = '{"typ": "JWT","alg": "HS256"}';
        var demo_payload = JSON.stringify(info);
        var base64Header = getBase64Encode(demo_header);
        var base64Payload = getBase64Encode(demo_payload);
        var signature = CryptoJS.HmacSHA256(base64Header + "." + base64Payload, extratxt);
        var base64sign = CryptoJS.enc.Base64.stringify(signature);
        var jwt = reverse(base64Header).replace(/=/g, "") + "." + reverse(base64sign).replace(/=/g, "") + "." + reverse(base64Payload).replace(/=/g, "");
        return jwt;
    }
}

function pars(info) {
    var loadTimerUrl = "";
    var extratxt = "";
    if (localStorage.getItem('sessionObject')) {
        var missingObject = localStorage.getItem('sessionObject').split(".");
        missingObject = JSON.parse(getBase64Decode(missingObject[1]));
        extratxt = reverse(missingObject['timer']);
        fix = missingObject['fix'];
        missingObject = "";
    } else {
        loadTimerUrl = "uploads/utilizadores/userlog" + lostid + "/noti.json";
        function loadTimer(callback) {
            var newtemporal = new Date().valueOf();
            $.ajax({
                type: 'POST',
                url: loadTimerUrl + "?v=" + newtemporal,
            }).done(function (response) {
                callback(response);
            }).fail(function (jqXHR, textStatus) {
                callback(JSON.stringify({ timer: md5(' '), fix: 0 }));
            });
        }
        loadTimer(function (response) {
            // Parse JSON string into object
            var res = typeof response === 'string' || response instanceof String ? JSON.parse(response) : response;
            extratxt = res['timer'];
            fix = res['fix'];
        });
    }
    if (parseInt(fix) == 1) {
        return info;
    } else {
        return JSON.parse(getBase64Decode(reverse(info['package'].split(".")[2])));
    }
}