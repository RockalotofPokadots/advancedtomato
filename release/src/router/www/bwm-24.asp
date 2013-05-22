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
        <title>[<% ident(); %>] Bandwidth: Last 24 Hours</title>

        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="css/bootstrap-responsive.min.css" rel="stylesheet">
        <link href="css/tomato.css" rel="stylesheet">
        <% css(); %>


        <script type="text/javascript" src="js/jquery.lite.min.js"></script>


        <script type='text/javascript' src='tomato.js'></script>

        <!-- / / / -->

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

            //	<% nvram("at_update,tomatoanon_answer,wan_ifname,lan_ifname,wl_ifname,wan_proto,wan_iface,web_svg,rstats_enable,rstats_colors"); %>

            var cprefix = 'bw_24';
            var updateInt = 120;
            var updateDiv = updateInt;
            var updateMaxL = 720;
            var updateReTotal = 1;
            var hours = 24;
            var lastHours = 0;
            var debugTime = 0;

            function showHours()
            {
                if (hours == lastHours) return;
                showSelectedOption('hr', lastHours, hours);
                lastHours = hours;
            }

            function switchHours(h)
            {
                if ((!svgReady) || (updating)) return;

                hours = h;
                updateMaxL = (720 / 24) * hours;
                showHours();
                loadData();
                cookie.set(cprefix + 'hrs', hours);
            }

            var ref = new TomatoRefresh('/update.cgi', 'exec=bandwidth&arg0=speed');

            ref.refresh = function(text)
            {
                ++updating;
                try {
                    this.refreshTime = 1500;
                    speed_history = {};
                    try {
                        eval(text);
                        if (rstats_busy) {
                            E('rbusy').style.display = 'none';
                            rstats_busy = 0;
                        }
                        this.refreshTime = (fixInt(speed_history._next, 1, 120, 60) + 2) * 1000;
                    }
                    catch (ex) {
                        speed_history = {};
                    }
                    if (debugTime) E('dtime').innerHTML = (new Date()) + ' ' + (this.refreshTime / 1000);
                    loadData();
                }
                catch (ex) {
                    //		alert('ex=' + ex);
                }
                --updating;
            }

            ref.showState = function()
            {
                E('refresh-button').value = this.running ? 'Stop' : 'Start';
            }

            ref.toggleX = function()
            {
                this.toggle();
                this.showState();
                cookie.set(cprefix + 'refresh', this.running ? 1 : 0);
            }

            ref.initX = function()
            {
                var a;

                a = fixInt(cookie.get(cprefix + 'refresh'), 0, 1, 1);
                if (a) {
                    ref.refreshTime = 100;
                    ref.toggleX();
                }
            }

            function init()
            {
                if (nvram.rstats_enable != '1') return;

                try {
                    //	<% bandwidth("speed"); %>
                }
                catch (ex) {
                    speed_history = {};
                }
                rstats_busy = 0;
                if (typeof(speed_history) == 'undefined') {
                    speed_history = {};
                    rstats_busy = 1;
                    E('rbusy').style.display = '';
                }

                hours = fixInt(cookie.get(cprefix + 'hrs'), 1, 24, 24);
                updateMaxL = (720 / 24) * hours;
                showHours();

                initCommon(1, 0, 0);
                ref.initX();
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
                            if ((nvram.web_svg != '0') && (nvram.rstats_enable == '1')) {
                                // without a div, Opera 9 moves svgdoc several pixels outside of <embed> (?)
                                W("<div style='border-top:1px solid #f0f0f0;border-bottom:1px solid #f0f0f0;visibility:hidden;padding:0;margin:0; overflow-x: auto; overflow-y: hidden; max-width: 960px;' id='graph'><embed src='img/bwm-graph.svg?<% version(); %>' style='height: 300px; width:940px;margin:0;padding:0' type='image/svg+xml' pluginspage='http://www.adobe.com/svg/viewer/install/'></embed></div>");
                            }
                        </script>

                        <div id='bwm-controls'>
                            <small>(2 minute interval)</small> - 
                            <b>Hours</b>:
                            <a href='javascript:switchHours(1);' id='hr1'>1</a>,
                            <a href='javascript:switchHours(2);' id='hr2'>2</a>,
                            <a href='javascript:switchHours(4);' id='hr4'>4</a>,
                            <a href='javascript:switchHours(6);' id='hr6'>6</a>,
                            <a href='javascript:switchHours(12);' id='hr12'>12</a>,
                            <a href='javascript:switchHours(18);' id='hr18'>18</a>,
                            <a href='javascript:switchHours(24);' id='hr24'>24</a>
                            | <b>Avg</b>:
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
                            <small><a href='javascript:switchColor(1)' id='drawrev'>[reverse]</a></small> | 
                            <a href="admin-bwm.asp"><b>Configure</b></a>
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


                    <script type='text/javascript'>
                        if (nvram.rstats_enable != '1') {
                            W('<div class="note-disabled">Bandwidth monitoring disabled.</b><br><br><a href="admin-bwm.asp">Enable &raquo;</a><div>');
                            E('rstats').style.display = 'none';
                        }
                        else {
                            W('<div class="alert alert-info" style="display:none" id="rbusy">The rstats program is not responding or is busy. Try reloading after a few seconds.</div>');
                        }
                    </script>

                    <!-- / / / -->

                    <div id='footer' class="footer">
                        <span id='dtime'></span>
                        <img src='spin.gif' id='refresh-spinner' onclick='debugTime=1'>
                        <input type='button' value='Refresh' id='refresh-button' onclick='ref.toggleX()' class="btn">
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