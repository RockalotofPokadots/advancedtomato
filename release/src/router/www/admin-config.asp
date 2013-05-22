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
        <meta http-equiv="content-type" content="text/html;charset=utf-8">
        <meta name="robots" content="noindex,nofollow">
        <title>[<% ident(); %>] Admin: Configuration</title>

        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="css/bootstrap-responsive.min.css" rel="stylesheet">
        <link href="css/tomato.css" rel="stylesheet">
        <% css(); %>


        <script type="text/javascript" src="js/jquery.lite.min.js"></script>
        <script type="text/javascript" src="tomato.js"></script>
        <script type="text/javascript">

            //	<% nvram("at_update,tomatoanon_answer,et0macaddr,t_features,t_model_name"); %>
            //	<% nvstat(); %>

            function backupNameChanged()
            {
                var name = fixFile(E('backup-name').value);

                /* Not required
                if (name.length > 1) {
                E('backup-link').href = 'cfg/' + name + '.cfg?_http_id=' + nvram.http_id;
                }
                else {
                E('backup-link').href = '?';
                }
                */
            }

            function backupButton()
            {
                var name = fixFile(E('backup-name').value);
                if (name.length <= 1) {
                    alert('Invalid filename');
                    return;
                }
                location.href = 'cfg/' + name + '.cfg?_http_id=' + nvram.http_id;
            }

            function restoreButton()
            {
                var name, i, f;

                name = fixFile(E('restore-name').value);
                name = name.toLowerCase();
                if ((name.indexOf('.cfg') != (name.length - 4)) && (name.indexOf('.cfg.gz') != (name.length - 7))) {
                    alert('Incorrect filename. Expecting a ".cfg" file.');
                    return;
                }
                if (!confirm('Are you sure?')) return;
                E('restore-button').disabled = 1;

                f = E('restore-form');
                form.addIdAction(f);
                f.submit();
            }

            function resetButton()
            {
                var i;

                i = E('restore-mode').value;
                if (i == 0) return;
                if ((i == 2) && (features('!nve'))) {
                    if (!confirm('WARNING: Erasing the NVRAM on a ' + nvram.t_model_name + ' router may be harmful. It may not be able to re-setup the NVRAM correctly after a complete erase. Proceeed anyway?')) return;
                }
                if (!confirm('Are you sure?')) return;
                E('reset-button').disabled = 1;
                form.submit('aco-reset-form');
            }
        </script>
    </head>
    <body onload="backupNameChanged()">
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

                    <h3>Backup Configuration</h3>
                    <div class="section">
                        <div class="input-append">
                            <script type="text/javascript">
                                W("<input type='text' size='40' maxlength='64' id='backup-name' onchange='backupNameChanged()' value='tomato_v" + ('<% version(); %>'.replace(/\./g, '')) + "_m" + nvram.et0macaddr.replace(/:/g, '').substring(6, 12) + "'>");
                            </script>
                            <span class="add-on">.cfg</span>
                            <button name="f_backup_button" onclick="backupButton()" value="Backup" class="btn">Backup</button>
                        </div>
                    </div>
                    <br />
                    <h3>Restore Configuration</h3>
                    <div class="section">
                        <form id="restore-form" method="post" action="cfg/restore.cgi" encType="multipart/form-data">
                            Select the configuration file to restore:<br>
                            <input type="file" size="40" id="restore-name" name="filename">
                            <button name="f_restore_button" id="restore-button" value="Restore" onclick="restoreButton()" class="btn">Restore</button>
                            <br>
                        </form>
                    </div>
                    <br />
                    <h3>Restore Default Configuration</h3>
                    <div class="section">
                        <form id="aco-reset-form" method="post" action="cfg/defaults.cgi">
                            <div class="input-append"><select name="mode" id="restore-mode">
                                    <option value=0>Select...</option>
                                    <option value=1>Restore default router settings (normal)</option>
                                    <option value=2>Erase all data in NVRAM memory (thorough)</option>
                                </select>
                                <button value="OK" onclick="resetButton()" id="reset-button" class="btn">OK</button>
                            </div>
                        </form>
                    </div>

                    <br />
                    <div class="section">
                        <script type="text/javascript">
                            var a = nvstat.free / nvstat.size * 100.0;
                            createFieldTable('', [
                                    { title: 'Total / Free NVRAM:', text: scaleSize(nvstat.size) + ' / ' + scaleSize(nvstat.free) + ' <small>(' + (a).toFixed(2) + '%)</small>' }
                                ]);

                            if (a <= 5) {
                                document.write('<br><div id="notice1">' +
                                    'The NVRAM free space is very low. It is strongly recommended to ' +
                                    'erase all data in NVRAM memory, and reconfigure the router manually ' +
                                    'in order to clean up all unused and obsolete entries.' +
                                    '</div><br style="clear:both">');
                            }
                        </script>
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