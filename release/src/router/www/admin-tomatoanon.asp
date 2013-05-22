<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.0//EN'>
<!--
Tomato GUI
Copyright (C) 2012 Shibby
http://openlinksys.info
For use with Tomato Firmware only.
No part of this file may be used without permission.
-->
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="content-type" content="text/html;charset=utf-8">
        <meta name="robots" content="noindex,nofollow">
        <title>[<% ident(); %>] Admin: TomatoAnon Project</title>

        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="css/bootstrap-responsive.min.css" rel="stylesheet">
        <link href="css/tomato.css" rel="stylesheet">
        <% css(); %>


        <script type="text/javascript" src="js/jquery.lite.min.js"></script>
        <script type="text/javascript" src="tomato.js"></script>
        <script type="text/javascript">
            //	<% nvram("tomatoanon_enable,tomatoanon_answer,tomatoanon_cru,tomatoanon_id"); %>
            var anon_link = '&nbsp;&nbsp;<a href="http://tomato.groov.pl/tomatoanon.php?search=9&routerid=<% nv('tomatoanon_id'); %>" target="_blank"><i>[Checkout my router]</i></a>';
            function verifyFields(focused, quiet)
            {
                var o = (E('_tomatoanon_answer').value == '1');
                E('_tomatoanon_enable').disabled = !o;
                var s = (E('_tomatoanon_enable').value == '1');
                E('_tomatoanon_cru').disabled = !o || !s;
                return 1;
            }
            function save()
            {
                if (verifyFields(null, 0)==0) return;
                var fom = E('_fom');
                fom._service.value = 'tomatoanon-restart';
                form.submit('_fom', 1);
            }
            function init()
            {
                var anon = true;
            }
        </script>
    </head>
    <body onLoad="init()">
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
                    <form id="_fom" method="post" action="tomato.cgi">
                        <input type="hidden" name="_nextpage" value="admin-tomatoanon.asp">
                        <input type="hidden" name="_service" value="tomatoanon-restart">
                        <div style="float: left; width: 49%; margin-right: 1%; margin-top: -15px;"> 
                            <h3>TomatoAnon Project</h3>
                            I would like to present you with a new project I've been working on, called TomatoAnon.<br>
                            The TomatoAnon script will send (to a database) information about your router's model and installed version of Tomato.<br>
                            The information submitted is 100% anonymous and will ONLY be used for statistical purposes.<br>
                            <b>This script does NOT send any private or personal information whatsoever (like MAC`s, IP`s etc)!</b><br>
                            Script is fully open, and written in bash. Anyone is free to look at the content that is submitted to the database.<br>
                            <br>
                            The submitted results can be viewed on the <a href=http://tomato.groov.pl/tomatoanon.php target=_blanc><b>http://tomato.groov.pl/tomatoanon.php</b></a> page.<br>
                            This information may help you when choosing the best and most popular router available in your country.<br>
                            You can check which version of Tomato is most commonly used and which one is the most stable.<br>
                            <br>
                            If you don't agree with this script, or do not wish to use it, you can simply disable it.<br>
                            You can always re-enable it at any time.<br>
                            <br>
                            The following data is sent by TomatoAnon:<br>
                            - MD5SUM of WAN+LAN MAC addresses - this will identify a router. Ex: 1c1dbd4202d794251ec1acf1211bb2c8<br>
                            - Model of router. Ex: Asus RT-N66U<br>
                        </div>
                        <div style="float: left; width: 49%; padding-top: 40px; margin-top: -15px;">
                            - Installed version of Tomato. Ex: 102 K26 USB<br>
                            - Builtype. Ex: Mega-VPN-64K<br>
                            - Country. Ex: POLAND<br>
                            - ISO Country code. Ex: PL<br>
                            - Uptime of your router. Ex: 3 days<br>
                            That`s it !!<br>
                            <br>
                            Thank you for reading and please make the right choice to help this project.<br>

                            <h3>Tomato Update Notifications</h3>
                            I've given my self permission to use Shibby's TomatoAnon project to implement auto update checker.
                            This script is embeded into TomatoAnon script and it only checks if there is available update for your router.
                            Since its embeded into TomatoAnon script its truly open to every one. The only thing that it does is check ur router version and
                            server replies with response to your version. <br>
                            <br>
                            <h4>How it works?</h4>
                            TomatoAnon's checks for version of your router and creates link like this: <b><a target="_blank" href="http://at.prahec.com/update.php?v=1.06.08">http://at.prahec.com/update.php?v=1.06.08</a></b>.
                            If update is available, server will respond with message that its available. If not, server will reply with empty result. <br>
                            Thats it! 
                        </div>
                        <div class="clearfix"></div>
                        <h3>TomatoAnon Settings <small><script>W(anon_link);</script></small></h3>
                        <div class='section'>
                            <script type='text/javascript'>
                                createFieldTable('', [
                                        { title: 'Do you know what TomatoAnon doing ?', name: 'tomatoanon_answer', type: 'select', options: [ ['0','No, i don`t. Have to read all information, before i will make a choice'], ['1','Yes, i do and want to make a choice'] ], value: nvram.tomatoanon_answer, suffix: ' '},
                                        { title: 'Do you want enable TomatoAnon ?', name: 'tomatoanon_enable', type: 'select', options: [ ['-1','I`m not sure right now'], ['1','Yes, i`m sure i do'], ['0','No, i definitely wont enable it'] ], value: nvram.tomatoanon_enable, suffix: ' '},
                                        { title: 'Send every', indent: 2, name: 'tomatoanon_cru', type: 'text', maxlen: 5, size: 7, value: nvram.tomatoanon_cru, suffix: ' <small>hours (range: 1 - 12; default: 6)</small>' }
                                    ]);
                            </script>
                        </div>
                    </form>

                    <br />
                    <button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">Save</button>
                    <button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">Cancel</button>
                    &nbsp; <span id="footer-msg" class="alert warning" style="visibility: hidden;"></span>

                    </form>

                </div><!--/span-->
            </div><!--/row-->
            <hr>
<div class="footer">
                <p><a href="about.asp">&copy; AdvancedTomato 2013</a> <span style="padding: 0 15px; float:right; text-align:right;">Version: <b><% version(1); %></b></span></p> 
            </div>
        </div><!--/.fluid-container-->
        <script type="text/javascript">verifyFields(null, 1);</script>
    </body>
</html>
