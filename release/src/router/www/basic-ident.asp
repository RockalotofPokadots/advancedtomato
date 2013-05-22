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
        <title>[<% ident(); %>] Basic: Identification</title>


        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="css/bootstrap-responsive.min.css" rel="stylesheet">
        <link href="css/tomato.css" rel="stylesheet">
        <% css(); %>


        <script type="text/javascript" src="js/jquery.lite.min.js"></script>
        <script type="text/javascript" src="tomato.js"></script>

        <!-- / / / -->

        <script type="text/javascript">

            //	<% nvram("at_update,tomatoanon_answer,router_name,wan_hostname,wan_domain"); %>


            function verifyFields(focused, quiet)
            {
                if (!v_hostname('_wan_hostname', quiet)) return 0;
                return v_length('_router_name', quiet, 1) && v_length('_wan_hostname', quiet, 0) && v_length('_wan_domain', quiet, 0);
            }

            function save()
            {
                if (!verifyFields(null, false)) return;
                form.submit('_fom', 1);
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

        <div id="main" class="container">
            <div class="row">
                <div class="span12">

                    <!-- / / / -->

                    <form id="_fom" method="post" action="tomato.cgi">

                        <input type="hidden" name="_nextpage" value="basic.asp">
                        <input type="hidden" name="_service" value="*">


                        <h3>Router Identification</h3>
                        <div class="section">
                            <script type="text/javascript">
                                createFieldTable('', [
                                        { title: 'Router Name', name: 'router_name', type: 'text', maxlen: 32, size: 34, value: nvram.router_name },
                                        { title: 'Hostname', name: 'wan_hostname', type: 'text', maxlen: 63, size: 34, value: nvram.wan_hostname },
                                        { title: 'Domain Name', name: 'wan_domain', type: 'text', maxlen: 32, size: 34, value: nvram.wan_domain }
                                    ]);
                            </script>
                        </div>

                        <button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">Save</button>
                        <button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">Cancel</button>
                        &nbsp; <span id="footer-msg" class="alert warning" style="visibility: hidden;"></span>
                    </form>
                    <script type="text/javascript">verifyFields(null, true);</script>

                    <!-- / / / -->

                    <div id="footer"></div>
                </div><!--/span-->
            </div><!--/row-->
            <hr>
<div class="footer">
                <p><a href="about.asp">&copy; AdvancedTomato 2013</a> <span style="padding: 0 15px; float:right; text-align:right;">Version: <b><% version(1); %></b></span></p> 
            </div>
        </div><!--/.fluid-container-->
    </body>
</html>