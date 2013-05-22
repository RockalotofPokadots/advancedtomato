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
        <title>[<% ident(); %>] Set QOS Class Names</title>


        <link href="css/bootstrap.min.css" rel="stylesheet">
        <style type="text/css">
            body {
                padding-top: 60px;
                padding-bottom: 40px;
            }
            .sidebar-nav {
                padding: 9px 0;
            }
        </style>
        <link href="css/bootstrap-responsive.min.css" rel="stylesheet">


        <script type="text/javascript" src="js/jquery.lite.min.js"></script>
        <script type="text/javascript" src="tomato.js"></script>

        <script type="text/javascript">

            //	<% nvram("at_update,tomatoanon_answer,qos_classnames"); %>

            var checker = null;
            var timer = new TomatoTimer(check);
            var running = 0;



            function verifyFields(focused, quiet)
            {
                return 1;
            }


            function save()
            {
                var i, qos, fom;

                if (!verifyFields(null, false)) return;

                qos = [];
                for (i = 1; i < 11; ++i) {
                    qos.push(E('_f_qos_' + (i - 1)).value);
                }

                fom = E('_fom');
                fom.qos_classnames.value = qos.join(' ');
                form.submit(fom, 1);
            }
        </script>

    </head>
    <body>
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

        <div class="container">
            <div class="row">
                <div class="span3">
                    <div class="well sidebar-nav">
                        <ul class="nav nav-list">
                            <script type="text/javascript">navi()</script>
                        </ul>
                    </div><!--/.well -->
                </div><!--/span-->

                <div class="span9">

                    <!-- / / / -->
                    <form id='_fom' method='post' action='tomato.cgi'>
                        <input type='hidden' name='_nextpage' value='qos-classnames.asp'>
                        <input type='hidden' name='_service' value='qos-restart'>
                        <input type='hidden' name='qos_classnames' value=''>


                        <h3>Set QOS Class Names</h3>
                        <div class='section'>
                            <script type='text/javascript'>
                                if ((v = nvram.qos_classnames.match(/^(\w+)\s+(\w+)\s+(\w+)\s+(\w+)\s+(\w+)\s+(\w+)\s+(\w+)\s+(\w+)\s+(\w+)\s+(\w+)$/)) == null) {
                                    v = ["-","Highest","High","Medium","Low","Lowest","A","B","C","D","E"];
                                }
                                titles = ['-','Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5', 'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10'];
                                f = [{ title: ' ', text: '<small>(seconds)</small>' }];
                                for (i = 1; i < 11; ++i) {
                                    f.push({ title: titles[i], name: ('f_qos_' + (i - 1)),
                                            type: 'text', maxlen: 9, size: 9, value: v[i],
                                            suffix: '<span id="count' + i + '"></span>' });
                                }
                                createFieldTable('', f);
                            </script>
                        </div>

                        <span id='footer-msg'></span>
                        <div class='form-actions'>
                            <input type='button' value='Save' id='save-button' onclick='save()' class='btn'>
                            <input type='button' value='Cancel' id='cancel-button' onclick='reloadPage();' class='btn'>
                        </div>
                    </form>

                    <!-- / / / -->

                </div><!--/span-->
            </div><!--/row-->
            <hr>
            <div class="footer">
                <p>&copy; Tomato 2012</p>
            </div>
        </div><!--/.fluid-container-->
        <script type='text/javascript'>verifyFields(null, 1);</script>
    </body>
</html>