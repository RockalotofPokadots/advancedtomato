<!DOCTYPE html>
<!--
Tomato GUI
Copyright (C) 2006-2010 Jonathan Zarate
http://www.polarcloud.com/tomato/

For use with Tomato Firmware only.
No part of this file may be used without permission.
-->
<html lang="en">
    <head>
        <meta http-equiv='content-type' content='text/html;charset=utf-8'>
        <meta name='robots' content='noindex,nofollow'>
        <title>[<% ident(); %>] Restarting...</title>

        <link href="css/bootstrap.min.css" rel="stylesheet">

        <style>
            body {
                font-family: Verdana;
                font-size: 12px;
            }

            #loader {
                width:95%;
                max-width: 600px;
                background: #fff;
                border: 1px solid #E6E6E6;
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
            var n = 20;
            function tick()
            {
                var e = document.getElementById('continue');
                e.innerHTML = n;
                if (n == 10) {
                    e.disabled = false;
                }
                if (n == 0) {
                    e.innerHTML = 'Continue';
                }
                else {
                    --n;
                    setTimeout(tick, 1000);
                }
            }
            function go()
            {
                window.location = window.location.protocol + '//<% nv("lan_ipaddr"); %>/';
            }
        </script>
    </head>
    <body onload="tick()" style="background: url('img/bg.jpg')" onclick='go()'>
        <div id="loader">
        <img src="spin.gif" align="left">
            The router's new IP address is <% nv("lan_ipaddr"); %>.<br /> You may need to release then renew your computer's DHCP lease before continuing.
            <br /><br />
            Please wait while the router restarts... &nbsp;
            <button class="btn" id="continue" onclick="go()" disabled>Continue</button>
        </div>
    </body>
</html>