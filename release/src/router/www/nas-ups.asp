<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.0//EN'>
<!--
Tomato GUI
For use with Tomato Firmware only.
No part of this file may be used without permission.
-->
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="content-type" content="text/html;charset=utf-8">
        <meta name="robots" content="noindex,nofollow">
        <title>[<% ident(); %>] NAS: UPS Monitor</title>

        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="css/bootstrap-responsive.min.css" rel="stylesheet">
        <link href="css/tomato.css" rel="stylesheet">
        <% css(); %>


        <script type="text/javascript" src="js/jquery.lite.min.js"></script>
        <script type="text/javascript" src="tomato.js"></script>
        <style type="text/css">
            textarea {
                width: 98%;
                height: 15em;
            }
        </style>
        <script type="text/javascript">
            //      <% nvram("at_update,tomatoanon_answer"); %>
            function init()
            {
                clientSideInclude('ups-status', '/ext/cgi-bin/tomatoups.cgi');
                clientSideInclude('ups-data', '/ext/cgi-bin/tomatodata.cgi');
            }
            function clientSideInclude(id, url) {
                var req = false;
                // For Safari, Firefox, and other non-MS browsers
                if (window.XMLHttpRequest) {
                    try {
                        req = new XMLHttpRequest();
                    } catch (e) {
                        req = false;
                    }
                } else if (window.ActiveXObject) {
                    // For Internet Explorer on Windows
                    try {
                        req = new ActiveXObject("Msxml2.XMLHTTP");
                    } catch (e) {
                        try {
                            req = new ActiveXObject("Microsoft.XMLHTTP");
                        } catch (e) {
                            req = false;
                        }
                    }
                }
                var element = document.getElementById(id);
                if (!element) {
                    alert("Bad id " + id + 
                        "passed to clientSideInclude." +
                        "You need a div or span element " +
                        "with this id in your page.");
                    return;
                }
                if (req) {
                    // Synchronous request, wait till we have it all
                    req.open('GET', url, false);
                    req.send(null);
                    element.innerHTML = req.responseText;
                    $('.tomato-grid').addClass('table table-striped table-condensed table-bordered langrid');
                } else {
                    element.innerHTML =
                    "Sorry, your browser does not support " +
                    "XMLHTTPRequest objects. This page requires " +
                    "Internet Explorer 5 or better for Windows, " +
                    "or Firefox for any system, or Safari. Other " +
                    "compatible browsers may also exist.";
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
                
                    <input type="hidden" name="_nextpage" value="nas-ups.asp">
                    <h3>APC UPS Status</h3>
                    <div class="section">
                    <span id="ups-status"></span>
                    </div>
                    
                    <h3>UPS Response</h3>
                    <div class="section">
                        <span id="ups-data"></span>
                    </div>

                </div><!--/span-->
            </div><!--/row-->
            <hr>
<div class="footer">
                <p><a href="about.asp">&copy; AdvancedTomato 2013</a> <span style="padding: 0 15px; float:right; text-align:right;">Version: <b><% version(1); %></b></span></p> 
            </div>
        </div><!--/.fluid-container-->
    </body>
</html>
