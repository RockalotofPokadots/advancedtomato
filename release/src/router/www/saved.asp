<!DOCTYPE html>
<html lang="en">
    <!--
    Tomato GUI
    Copyright (C) 2006-2010 Jonathan Zarate
    http://www.polarcloud.com/tomato/

    For use with Tomato Firmware only.
    No part of this file may be used without permission.
    -->
    <head>
        <meta http-equiv="content-type" content="text/html;charset=utf-8">
        <meta name="robots" content="noindex,nofollow">
        <title>[<% ident(); %>] Tomato</title>

        <link href="css/bootstrap.min.css" rel="stylesheet">

        <style>
            body {
                font-family: Verdana;
                font-size: 12px;
            }

            #loader {
                width:95%;
                max-width: 200px;
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
        <script language="javascript">
            wait = parseInt('<% cgi_get("_nextwait"); %>', 10);
            if (isNaN(wait)) wait = 5;
            function tick()
            {
                clock.innerHTML = wait;

                if (--wait >= 0) setTimeout(tick, 1000);
                else go();
            }
            function go()
            {
                clock.style.visibility = 'hidden';
                window.location.replace('<% cgi_get("_nextpage"); %>');
            }
            function setSpin(x)
            {
                document.getElementById('spin').style.visibility = x ? 'visible' : 'hidden';
                spun = x;
            }
            function init()
            {
                if (wait > 0) {
                    spin = document.getElementById('spin');
                    opacity = 1;
                    step = 1 / wait;
                    clock = document.getElementById('xclock');
                    clock.style.visibility = 'visible';
                    tick();
                    if (!spun) setSpin(0);	// http may be down after this page gets sent
                }
            }
        </script>
    </head>
    <body onload="init()" style="background: url('img/bg.jpg')" onclick="go()">
        <div id="loader">
            <script type='text/javascript'>
                if (wait <= 0) s = '<b>Changes Saved...</b> &nbsp; <button onclick="go()" class="btn">Continue...</button>';
                else s = '<b>Please wait... (<span id="xclock" style="visibility:hidden">&nbsp;</span>)</b> &nbsp; <img align="right" src="spin.gif" id="spin" onload="setSpin(1)">';
                document.write(s);
            </script>
        </div>
    </body>
</html>