<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv='content-type' content='text/html;charset=utf-8'>
        <meta name='robots' content='noindex,nofollow'>
        <title>[<% ident(); %>] Rebooting...</title>
        <link href="css/bootstrap.min.css" rel="stylesheet">

        <style>
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
        <script type="text/javascript" src="js/jquery.lite.min.js"></script>
        <script type="text/javascript">
            var Max = 50 + parseInt('0<% nv("wait_time"); %>');
            var n = 0;
            function tick()
            {

                var e = document.getElementById('prog');
                var d = document.getElementById('progTXT');
                var c = document.getElementById('continue');

                e.style.width = (((n++) / Max) * 100) + '%';
                d.innerHTML = (Max - n) + 's';

                if (n == (Max+1)) {
                    d.innerHTML = '0s';
                    $('.off').fadeOut(250);
                    $('#re').html('Router should be rebooted now...');
                    return;
                }

                if (n == (Max-15)) $(c).fadeIn(250);
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
    <body style="background: url('img/bg.jpg')" onload="init()">
        <div style="width:100%; max-width: 600px; margin: 10% auto; text-align: center; font: 14px Verdana;">
            <img src="spin.gif" class="off">
            <div style='width:90%; margin:5px auto;padding:5px 5%;font-size:13px;'>
                <b id="re">Router is rebooting, please wait...</b><br /><span id="msg"></span>
                <div class="progress off">
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