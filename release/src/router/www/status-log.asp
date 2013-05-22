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
        <meta charset="utf-8">

        <meta http-equiv='content-type' content='text/html;charset=utf-8'>
        <meta name='robots' content='noindex,nofollow'>
        <title>[<% ident(); %>] Status: Logs</title>

        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="css/bootstrap-responsive.min.css" rel="stylesheet">
        <link href="css/tomato.css" rel="stylesheet">
        <% css(); %>


        <script type="text/javascript" src="js/jquery.lite.min.js"></script>


        <script type='text/javascript' src='tomato.js'></script>

        <script type='text/javascript'>

            <% nvram("at_update,tomatoanon_answer,log_file"); %>

            function find()
            {
                var s = E('find-text').value;
                if (s.length) document.location = 'logs/view.cgi?find=' + escapeCGI(s) + '&_http_id=' + nvram.http_id;
            }

            function init()
            {
                var e = E('find-text');
                if (e) e.onkeypress = function(ev) {
                    if (checkEvent(ev).keyCode == 13) find();
                }
            }
        </script>

    </head>
    <body onload='init()'>
        <div id="navigation">
            <div class="container">
                <div class="logo"><a href="/">AdvancedTomato</a></div>
                <div class="navi">
                    <ul>
                        <script type="text/javascript">navi()</script>
                    </ul>
                </div>
            </div>
        </div>
        <div id="main" class="container">
            <div class="row">
                <div class="span12">

                    <!-- / / / -->

                    <div id='logging'>
                        <h3>Logs</h3>
                        <div class='section'>
                            <a href="logs/view.cgi?which=25&_http_id=<% nv(http_id) %>">View Last 25 Lines</a><br>
                            <a href="logs/view.cgi?which=50&_http_id=<% nv(http_id) %>">View Last 50 Lines</a><br>
                            <a href="logs/view.cgi?which=100&_http_id=<% nv(http_id) %>">View Last 100 Lines</a><br>
                            <a href="logs/view.cgi?which=all&_http_id=<% nv(http_id) %>">View All</a><br><br>
                            <a href="logs/syslog.txt?_http_id=<% nv(http_id) %>">Download Log File</a><br><br>
                            <div class="input-append"><input class="span3" type="text" maxsize="32" id="find-text"> <button value="Find" onclick="find()" class='btn'>Find</button></div>
                            &raquo; <a href="admin-log.asp">Logging Configuration</a><br><br>
                        </div>
                    </div>

                    <script type='text/javascript'>
                        if (nvram.log_file != '1') {
                            W('<div class="note-disabled alert alert-info">Internal logging disabled.</b><br><br><a href="admin-log.asp">Enable &raquo;</a></div>');
                            E('logging').style.display = 'none';
                        }
                    </script>

                    <!-- / / / -->

                </div><!--/span-->
            </div><!--/row-->

            <hr>

<div class="footer">
                <p><a href="about.asp">&copy; AdvancedTomato 2013</a> <span style="padding: 0 15px; float:right; text-align:right;">Version: <b><% version(1); %></b></span></p> 
            </div>

        </div><!--/.fluid-container-->
    </body>
</html>