<html lang="en">
    <!--
    Tomato GUI
    Copyright (C) 2006-2010 Jonathan Zarate
    http://www.polarcloud.com/tomato/

    For use with Tomato Firmware only.
    No part of this file may be used without permission.
    -->
    <head>
        <meta http-equiv='content-type' content='text/html;charset=utf-8'>
        <meta name='robots' content='noindex,nofollow'>
        <title>[<% ident(); %>] Measuring Noise...</title>

        <link href="css/bootstrap.min.css" rel="stylesheet">

        <style>
            body {
                font-family: Verdana;
                font-size: 12px;
            }

            #loader {
                width:95%;
                max-width: 400px;
                background: #fff;
                border: 1px solid #E1E1E1;
                margin: 15% auto;
                padding: 15px;
                text-align: center;
                border-radius: 5px;
                -moz-border-radius: 5px;
                -webkit-border-radius: 5px;
                -o-border-radius: 5px;
                box-shadow: 0 0 2px #fff;
                -moz-box-shadow: 0 0 2px #fff;
                -webkit-box-shadow: 0 0 2px #fff;
                -o-box-shadow: 0 0 2px #fff;
            }
        </style>
        <script language='javascript'>
            function tick()
            {
                t.innerHTML = tock + ' second' + ((tock == 1) ? '' : 's');
                if (--tock >= 0) setTimeout(tick, 1000);
                else history.go(-1);
            }
            function init()
            {
                t = document.getElementById('time');
                tock = 15;
                tick();
            }
        </script>
    </head>
    <body onload="init()" style="background: url('img/bg.jpg')" onclick="go()">
        <div id="loader">
            <div style="font-size: 18px; font-weight: bold;padding-bottom: 5px;"><img src="spin.gif"> Measuring radio noise floor...</div>
            Wireless access has been temporarily disabled for <span id='time'>15 seconds</span>.

        </div>
    </body>
</html>