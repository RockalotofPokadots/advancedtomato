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
        <title>[<% ident(); %>] Bandwidth: Real-Time</title>

        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="css/bootstrap-responsive.min.css" rel="stylesheet">
        <link href="css/tomato.css" rel="stylesheet">
        <% css(); %>


        <script type="text/javascript" src="js/jquery.lite.min.js"></script>


        <script type='text/javascript' src='tomato.js'></script>

        <style type='text/css'>
            #txt {
                width: 100%;
                white-space: nowrap;
            }
            #bwm-controls {
                margin-right: 5px;
                margin-top: 5px;
            }
        </style>

        <script type='text/javascript' src='js/wireless.jsx?_http_id=<% nv(http_id); %>'></script>
        <script type='text/javascript' src='js/bwm-common.js'></script>

        <script type='text/javascript'>
            //	<% nvram("at_update,tomatoanon_answer,wan_ifname,lan_ifname,wl_ifname,wan_proto,wan_iface,web_svg,rstats_colors"); %>

            var cprefix = 'bw_r';
            var updateInt = 2;
            var updateDiv = updateInt;
            var updateMaxL = 300;
            var updateReTotal = 1;
            var prev = [];
            var debugTime = 0;
            var avgMode = 0;
            var wdog = null;
            var wdogWarn = null;


            var ref = new TomatoRefresh('/update.cgi', 'exec=netdev', 1);

            ref.stop = function() {
                this.timer.start(1000);
            }

            ref.refresh = function(text) {
                var c, i, h, n, j, k;

                watchdogReset();

                ++updating;
                try {
                    netdev = null;
                    eval(text);

                    n = (new Date()).getTime();
                    if (this.timeExpect) {
                        if (debugTime) E('dtime').innerHTML = (this.timeExpect - n) + ' ' + ((this.timeExpect + 2000) - n);
                        this.timeExpect += 2000;
                        this.refreshTime = MAX(this.timeExpect - n, 500);
                    }
                    else {
                        this.timeExpect = n + 2000;
                    }

                    for (i in netdev) {
                        c = netdev[i];
                        if ((p = prev[i]) != null) {
                            h = speed_history[i];

                            h.rx.splice(0, 1);
                            h.rx.push((c.rx < p.rx) ? (c.rx + (0xFFFFFFFF - p.rx)) : (c.rx - p.rx));

                            h.tx.splice(0, 1);
                            h.tx.push((c.tx < p.tx) ? (c.tx + (0xFFFFFFFF - p.tx)) : (c.tx - p.tx));
                        }
                        else if (!speed_history[i]) {
                            speed_history[i] = {};
                            h = speed_history[i];
                            h.rx = [];
                            h.tx = [];
                            for (j = 300; j > 0; --j) {
                                h.rx.push(0);
                                h.tx.push(0);
                            }
                            h.count = 0;
                        }
                        prev[i] = c;
                    }
                    loadData();
                }
                catch (ex) {
                }
                --updating;
            }

            function watchdog()
            {
                watchdogReset();
                ref.stop();
                wdogWarn.style.display = '';
            }

            function watchdogReset()
            {
                if (wdog) clearTimeout(wdog)
                wdog = setTimeout(watchdog, 10000);
                wdogWarn.style.display = 'none';
            }

            function init()
            {
                speed_history = [];

                initCommon(2, 1, 1);

                wdogWarn = E('warnwd');
                watchdogReset();

                ref.start();
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

                    <div id='rstats'>
                        <div id='tab-area' class="btn-toolbar"></div>

                        <script type='text/javascript'>
                            if (nvram.web_svg != '0') {
                                // without a div, Opera 9 moves svgdoc several pixels outside of <embed> (?)
                                W("<div style='border-top:1px solid #f0f0f0;border-bottom:1px solid #f0f0f0;visibility:hidden;padding:0;margin:0; overflow-x: auto; overflow-y: hidden; max-width: 960px;' id='graph'><embed src='img/bwm-graph.svg?<% version(); %>' style='height: 300px; width:940px;margin:0;padding:0' type='image/svg+xml' pluginspage='http://www.adobe.com/svg/viewer/install/'></embed></div>");
                            }
                        </script>

                        <div id='bwm-controls'>
                            <small>(10 minute window, 2 second interval)</small> - 
                            <b>Avg</b>: 
                            <a href='javascript:switchAvg(1)' id='avg1'>Off</a>,
                            <a href='javascript:switchAvg(2)' id='avg2'>2x</a>,
                            <a href='javascript:switchAvg(4)' id='avg4'>4x</a>,
                            <a href='javascript:switchAvg(6)' id='avg6'>6x</a>,
                            <a href='javascript:switchAvg(8)' id='avg8'>8x</a>
                            | <b>Max</b>:
                            <a href='javascript:switchScale(0)' id='scale0'>Uniform</a> or
                            <a href='javascript:switchScale(1)' id='scale1'>Per IF</a>
                            | <b>Display</b>:
                            <a href='javascript:switchDraw(0)' id='draw0'>Solid</a> or
                            <a href='javascript:switchDraw(1)' id='draw1'>Line</a>
                            | <b>Color</b>: <a href='javascript:switchColor()' id='drawcolor'>-</a>
                            <small><a href='javascript:switchColor(1)' id='drawrev'>[reverse]</a></small>
                            | <a href="admin-bwm.asp"><b>Configure</b></a>
                        </div>
                        <br>
                        <table id='txt' class="table-striped">
                            <tr>
                                <td><b style='border-bottom:blue 1px solid' id='rx-name'>RX</b></td>
                                <td><span id='rx-current'></span></td>
                                <td><b>Avg</b></td>
                                <td id='rx-avg'></td>
                                <td><b>Peak</b></td>
                                <td id='rx-max'></td>
                                <td><b>Total</b></td>
                                <td id='rx-total'></td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td><b style='border-bottom:blue 1px solid' id='tx-name'>TX</b></td>
                                <td><span id='tx-current'></span></td>
                                <td><b>Avg</b></td>
                                <td id='tx-avg'></td>
                                <td><b>Peak</b></td>
                                <td id='tx-max'></td>
                                <td><b>Total</b></td>
                                <td id='tx-total'></td>
                                <td>&nbsp;</td>
                            </tr>
                        </table>
                    </div>
                    <br>
                    <br>

                    <!-- / / / -->


                    <div id='footer'>
                        <span id='warnwd' class="alert alert-info" style='display:none'>Warning: 10 second session timeout, restarting...&nbsp;</span>
                        <span id='dtime'></span>
                        <img src='spin.gif' id='refresh-spinner' onclick='javascript:debugTime=1'>
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