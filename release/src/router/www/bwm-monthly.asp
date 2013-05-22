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
        <title>[<% ident(); %>] Bandwidth: Monthly</title>

        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="css/bootstrap-responsive.min.css" rel="stylesheet">
        <link href="css/tomato.css" rel="stylesheet">
        <% css(); %>


        <script type="text/javascript" src="js/jquery.lite.min.js"></script>


        <script type='text/javascript' src='tomato.js'></script>
        <!-- / / / -->

        <script type='text/javascript' src='js/bwm-hist.js'></script>

        <script type='text/javascript'>

            //	<% nvram("at_update,tomatoanon_answer,wan_ifname,lan_ifname,rstats_enable"); %>
            try {
                //	<% bandwidth("monthly"); %>
            }
            catch (ex) {
                monthly_history = [];
            }
            rstats_busy = 0;
            if (typeof(monthly_history) == 'undefined') {
                monthly_history = [];
                rstats_busy = 1;
            }

            function genData()
            {
                var w, i, h;

                w = window.open('', 'tomato_data_m');
                w.document.writeln('<pre>');
                for (i = 0; i < monthly_history.length; ++i) {
                    h = monthly_history[i];
                    w.document.writeln([(((h[0] >> 16) & 0xFF) + 1900), (((h[0] >>> 8) & 0xFF) + 1), h[1], h[2]].join(','));
                }
                w.document.writeln('</pre>');
                w.document.close();
            }

            function save()
            {
                cookie.set('monthly', scale, 31);
            }

            function redraw()
            {
                var h;
                var grid;
                var rows;
                var yr, mo, da;

                rows = 0;
                block = '';
                gn = 0;

                grid = '<table class="table table-striped table-bordered">';
                grid += '<thead><tr><th>Date</th><th>Download</th><th>Upload</th><th>Total</th></tr></thead>';

                for (i = 0; i < monthly_history.length; ++i) {
                    h = monthly_history[i];
                    yr = (((h[0] >> 16) & 0xFF) + 1900);
                    mo = ((h[0] >>> 8) & 0xFF);

                    grid += makeRow(((rows & 1) ? 'odd' : 'even'), ymText(yr, mo), rescale(h[1]), rescale(h[2]), rescale(h[1] + h[2]));
                    ++rows;
                }

                E('bwm-monthly-grid').innerHTML = grid + '</table>';
            }

            function init()
            {
                var s;

                if (nvram.rstats_enable != '1') return;

                if ((s = cookie.get('monthly')) != null) {
                    if (s.match(/^([0-2])$/)) {
                        E('scale').value = scale = RegExp.$1 * 1;
                    }
                }

                initDate('ym');
                monthly_history.sort(cmpHist);
                redraw();
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

                    <h3>WAN Bandwidth - Monthly</h3>
                    <div id='bwm-monthly-grid'></div>
                    <div>
                        <b>Date</b> <select onchange='changeDate(this, "ym")' id='dafm'><option value=0>yyyy-mm</option><option value=1>mm-yyyy</option><option value=2>mmm yyyy</option><option value=3>mm.yyyy</option></select><br>
                        <b>Scale</b> <select onchange='changeScale(this)' id='scale'><option value=0>KB</option><option value=1>MB</option><option value=2 selected>GB</option></select><br>
                        <br>
                        <a href="javascript:genData()" class="btn">Data</a> 
                        <a href="admin-bwm.asp" class="btn">Configure</a>
                    </div>

                    <script type='text/javascript'>checkRstats();</script>

                    <button style="float: right; margin-top: -31px;" type='button' onclick='reloadPage()' class='btn'>Refresh</button>

                </div>
            </div><!--/row-->
            <hr>
<div class="footer">
                <p><a href="about.asp">&copy; AdvancedTomato 2013</a> <span style="padding: 0 15px; float:right; text-align:right;">Version: <b><% version(1); %></b></span></p> 
            </div>
        </div><!--/.fluid-container-->
    </body>
</html>
