<!DOCTYPE html>
<!--
Tomato GUI

For use with Tomato Firmware only.
No part of this file may be used without permission.
-->
<html lang="en">
    <head>
        <meta charset="utf-8">

        <meta http-equiv='content-type' content='text/html;charset=utf-8'>
        <meta name='robots' content='noindex,nofollow'>
        <title>[<% ident(); %>] Tools: System Commands</title>

        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="css/bootstrap-responsive.min.css" rel="stylesheet">
        <link href="css/tomato.css" rel="stylesheet">
        <% css(); %>


        <script type="text/javascript" src="js/jquery.lite.min.js"></script>



        <!-- / / / -->

        <script type='text/javascript' src='tomato.js'></script>

        <!-- / / / -->

        <style type='text/css'>

            textarea {

                font: 12px monospace;
                width: 90%;
                height: 12em;

            }

        </style>

        <script type='text/javascript'>

            //	<% nvram('at_update,tomatoanon_answer'); %>	// http_id

            var cmdresult = '';
            var cmd = null;

            var ref = new TomatoRefresh('/update.cgi', '', 0, 'tools-shell_refresh');

            ref.refresh = function(text)
            {
                execute();
            }


            function verifyFields(focused, quiet)
            {
                return 1;
            }

            function escapeText(s)
            {
                function esc(c) {
                    return '&#' + c.charCodeAt(0) + ';';
                }
                return s.replace(/[&"'<>]/g, esc).replace(/\n/g, ' <br>').replace(/ /g, '&nbsp;');
            }

            function spin(x)
            {
                E('execb').disabled = x;
                E('_f_cmd').disabled = x;
                E('wait').style.visibility = x ? 'visible' : 'hidden';
                if (!x) cmd = null;
            }

            function updateResult()
            {
                E('result').innerHTML = '<tt>' + escapeText(cmdresult) + '</tt>';
                cmdresult = '';
                spin(0);
            }

            function execute()
            {
                // Opera 8 sometimes sends 2 clicks
                if (cmd) return;
                spin(1);

                cmd = new XmlHttp();
                cmd.onCompleted = function(text, xml) {
                    eval(text);
                    updateResult();
                }
                cmd.onError = function(x) {
                    cmdresult = 'ERROR: ' + x;
                    updateResult();
                }

                var s = E('_f_cmd').value;
                cmd.post('shell.cgi', 'action=execute&command=' + escapeCGI(s.replace(/\r/g, '')));
                cookie.set('shellcmd', escape(s));
            }

            function init()
            {
                var s;
                if ((s = cookie.get('shellcmd')) != null) E('_f_cmd').value = unescape(s);

                if (((s = cookie.get('tools_shell_notes_vis')) != null) && (s == '1')) {
                    toggleVisibility("notes");
                }
            }

            function toggleVisibility(whichone) {
                if (E('sesdiv_' + whichone).style.display == '') {
                    E('sesdiv_' + whichone).style.display = 'none';
                    E('sesdiv_' + whichone + '_showhide').innerHTML = '(Click here to show)';
                    cookie.set('status_overview_' + whichone + '_vis', 0);
                } else {
                    E('sesdiv_' + whichone).style.display='';
                    E('sesdiv_' + whichone + '_showhide').innerHTML = '(Click here to hide)';
                    cookie.set('status_overview_' + whichone + '_vis', 1);
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

                    <h3>Execute System Commands</h3>
                    <div class='section'>
                        <script type='text/javascript'>
                            createFieldTable('', [
                                    { title: 'Command', name: 'f_cmd', type: 'textarea', wrap: 'off', value: '' }
                                ]);
                        </script>
                        <div><input type='button' value='Execute' onclick='execute()' id='execb' class='btn'></div>
                        <script type='text/javascript'>genStdRefresh(1,1,'ref.toggle()');</script>
                    </div>

                    <h3>Notes <small><i><a href='javascript:toggleVisibility("notes");'><span id='sesdiv_notes_showhide'>(Click here to show)</span></a></i></small></h3>
                    <div class='section' id='sesdiv_notes' style='display:none'>
                        <ul>
                            <li><b>TIP</b> - Use the command "nvram export --set" or "nvram export --set | grep qos" to cut and paste configuration
                        </ul>
                    </div>


                    <div style="visibility:hidden;text-align:right" id="wait">Please wait... <img src='spin.gif'></div>
                    <pre id='result'></pre>

                    <!-- / / / -->

                    <div id='footer'>&nbsp;</div>
                </div><!--/span-->
            </div><!--/row-->
            <hr>
<div class="footer">
                <p><a href="about.asp">&copy; AdvancedTomato 2013</a> <span style="padding: 0 15px; float:right; text-align:right;">Version: <b><% version(1); %></b></span></p> 
            </div>
        </div><!--/.fluid-container-->
    </body>
</html>
