<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv='content-type' content='text/html;charset=utf-8'>
        <meta name='robots' content='noindex,nofollow'>
        <title>[<% ident(); %>] Rebooting...</title>
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <style>
            .progress {
                overflow: hidden;
                height: 20px;
                margin-bottom: 20px;
                background-color: #f7f7f7;
                background-image: -moz-linear-gradient(top, #f5f5f5, #f9f9f9);
                background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#f5f5f5), to(#f9f9f9));
                background-image: -webkit-linear-gradient(top, #f5f5f5, #f9f9f9);
                background-image: -o-linear-gradient(top, #f5f5f5, #f9f9f9);
                background-image: linear-gradient(to bottom, #f5f5f5, #f9f9f9);
                background-repeat: repeat-x;
                filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#fff5f5f5', endColorstr='#fff9f9f9', GradientType=0);
                -webkit-box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.1);
                -moz-box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.1);
                box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.1);
                -webkit-border-radius: 4px;
                -moz-border-radius: 4px;
                border-radius: 4px;
            }
            .progress .bar {
                width: 0%;
                height: 100%;
                color: #ffffff;
                float: left;
                font-size: 12px;
                text-align: center;
                text-shadow: 0 -1px 0 rgba(0, 0, 0, 0.25);
                background-color: #0e90d2;
                background-image: -moz-linear-gradient(top, #149bdf, #0480be);
                background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#149bdf), to(#0480be));
                background-image: -webkit-linear-gradient(top, #149bdf, #0480be);
                background-image: -o-linear-gradient(top, #149bdf, #0480be);
                background-image: linear-gradient(to bottom, #149bdf, #0480be);
                background-repeat: repeat-x;
                filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ff149bdf', endColorstr='#ff0480be', GradientType=0);
                -webkit-box-shadow: inset 0 -1px 0 rgba(0, 0, 0, 0.15);
                -moz-box-shadow: inset 0 -1px 0 rgba(0, 0, 0, 0.15);
                box-shadow: inset 0 -1px 0 rgba(0, 0, 0, 0.15);
                -webkit-box-sizing: border-box;
                -moz-box-sizing: border-box;
                box-sizing: border-box;
                -webkit-transition: width 0.6s ease;
                -moz-transition: width 0.6s ease;
                -o-transition: width 0.6s ease;
                transition: width 0.6s ease;
            }
            .progress .bar + .bar {
                -webkit-box-shadow: inset 1px 0 0 rgba(0,0,0,.15), inset 0 -1px 0 rgba(0,0,0,.15);
                -moz-box-shadow: inset 1px 0 0 rgba(0,0,0,.15), inset 0 -1px 0 rgba(0,0,0,.15);
                box-shadow: inset 1px 0 0 rgba(0,0,0,.15), inset 0 -1px 0 rgba(0,0,0,.15);
            }
            .progress {
                position: relative;
                margin: 5px 0;
            }
            .bar .txt {
                color: #fff;
                text-shadow: 0 0 2px #000;
                position: absolute;
                width: 100%;
                top: 2px;
                left: 0;
                text-align: center;
                font-size: 14px;
                line-height: 14px;
            }
        </style>
        <script type="text/javascript">
            var Max = 50 + parseInt('0<% nv("wait_time"); %>');
            var n = 0;
            function tick()
            {

                var e = document.getElementById('prog');
                var d = document.getElementById('progTXT');
                var c = document.getElementById('continue');
                var o = document.getElementById('off');

                e.style.width = (((n++) / Max) * 100) + '%';
                d.innerHTML = (Max - n) + 's';

                if (n == (Max+1)) {
                    d.innerHTML = '0s';
                    o.style.display = "none";
                    document.getElementById('progbar').style.display = "none";
                    document.getElementById('re').innerHTML = 'Router should be rebooted now !';
                    go();
                    return;
                }

                if (n == (Max-15)) c.style.display = 'block';
                setTimeout(tick, 1000);
            }
            function go()
            {
                window.location.replace('/');
            }
            function init()
            {
                resmsg = '';
                //<% resmsg(); %>
                if (resmsg.length) {
                    e = document.getElementById('msg');
                    e.innerHTML = resmsg;
                    e.style.display = '';
                }
                tick()
            }
        </script>
    </head>
    <body style="background: url('img/bg.png')" onload="init()">
        <div style="width:100%; max-width: 600px; margin: 10% auto; text-align: center; font: 14px Verdana;">
            <img src="spin.gif" id="off">
            <div style='width:90%; margin:5px auto;padding:5px 5%;font-size:13px;'>
                <b id="re">Router is rebooting, please wait...</b><br /><span id="msg"></span>
                <div id="progbar" class="progress">
                    <div class="bar" id="prog">
                        <span class="txt" id="progTXT"></span>
                    </div>
                </div>
                <div id="continue" style="display: none;">
                    <br />
                    <button class="btn" type="button" name="go" onclick="go()">Continue</button>
                </div>
            </div>
        </div>
    </body>
</html>