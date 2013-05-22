<!DOCTYPE html>
<!--
Tomato GUI
Copyright (C) 2006-2007 Jonathan Zarate
http://www.polarcloud.com/tomato/
For use with Tomato Firmware only.
No part of this file may be used without permission.
LAN Access admin module by Augusto Bott
-->
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="content-type" content="text/html;charset=utf-8">
        <meta name="robots" content="noindex,nofollow">
        <title>[<% ident(); %>] IP Traffic: View Graphs</title>

        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="css/bootstrap-responsive.min.css" rel="stylesheet">
        <link href="css/tomato.css" rel="stylesheet">
        <% css(); %>


        <script type="text/javascript" src="js/jquery.lite.min.js"></script>
        <script type="text/javascript" src="tomato.js"></script>
        <style type="text/css">
            .color {
                width: 12px;
                height: 25px;
            }
            .title {
            }
            .count {
                text-align: right;
            }
            .pct {
                width:55px;
                text-align: right;
            }
            .thead {
                font-size: 90%;
                font-weight: bold;
            }
            .total {
                border-top: 1px dashed #bbb;
                font-weight: bold;
                margin-top: 5px;
            }

            h4 {
                border-bottom: 1px solid #E6E6E6;
                padding-bottom: 3px;
            }
        </style>
        <script type="text/javascript">
            //	<% nvram('at_update,tomatoanon_answer,cstats_enable,lan_ipaddr,lan1_ipaddr,lan2_ipaddr,lan3_ipaddr,lan_netmask,lan1_netmask,lan2_netmask,lan3_netmask,dhcpd_static,web_svg'); %>
            // <% iptraffic(); %>
            nfmarks = [];
            irates = [];
            orates = [];
            var svgReady = 0;
            var abc = ['', '', '', '', '', '', '', '', '', '', ''];
            var colors = [
                'c6e2ff',
                'b0c4de',
                '9ACD32',
                '3cb371',
                '6495ed',
                '8FBC8F',
                'a0522d',
                'deb887',
                'F08080',
                'ffa500',
                'ffd700'
            ];
            var lock = 0;
            var prevtimestamp = new Date().getTime();
            var thistimestamp;
            var difftimestamp;
            var avgiptraffic = [];
            var lastiptraffic = iptraffic;
            function updateLabels() {
                var i = 0;
                while ((i < abc.length) && (i < iptraffic.length)) {
                    abc[i] = iptraffic[i][0]; // IP address
                    i++;
                }
            }
            updateLabels();
            i = 0;
            while (i < 11){
                if (iptraffic[i] != null) {
                    nfmarks[i] = iptraffic[i][9] + iptraffic[i][10]; // TCP + UDP connections
                } else {
                    nfmarks[i] = 0;
                }
                irates[i] = 0;
                orates[i] = 0;
                i++;
            }
            function mClick(n) {
                location.href = '/bwm-ipt-details.asp?ipt_filterip=' + abc[n];
            }
            function showData() {
                var i, n, p;
                var ct, rt, ort;
                ct = rt = ort = 0;
                for (i = 0; i < 11; ++i) {
                    if (!nfmarks[i]) nfmarks[i] = 0;
                    ct += nfmarks[i];
                    if (!irates[i]) irates[i] = 0;
                    rt += irates[i];
                    if (!orates[i]) orates[i] = 0;
                    ort += orates[i];
                }
                for (i = 0; i < 11; ++i) {
                    n = nfmarks[i];
                    E('ccnt' + i).innerHTML = (abc[i] != '') ? n : '';
                    if (ct > 0) p = (n / ct) * 100;
                    else p = 0;
                    E('cpct' + i).innerHTML = (abc[i] != '') ? p.toFixed(2) + '%' : '';
                }
                E('ccnt-total').innerHTML = ct;
                for (i = 0; i < 11; ++i) {
                    n = irates[i];
                    E('bcnt' + i).innerHTML = (abc[i] != '') ? (n / 125).toFixed(2) : '';
                    E('bcntx' + i).innerHTML = (abc[i] != '') ? (n / 1024).toFixed(2) : '';
                    if (rt > 0) p = (n / rt) * 100;
                    else p = 0;
                    E('bpct' + i).innerHTML = (abc[i] != '') ? p.toFixed(2) + '%' : '';
                }
                E('bcnt-total').innerHTML = (rt / 125).toFixed(2);
                E('bcntx-total').innerHTML = (rt / 1024).toFixed(2);
                for (i = 0; i < 11; ++i) {
                    n = orates[i];
                    E('obcnt' + i).innerHTML = (abc[i] != '') ? (n / 125).toFixed(2) : '';
                    E('obcntx' + i).innerHTML = (abc[i] != '') ? (n / 1024).toFixed(2) : '';
                    if (ort > 0) p = (n / ort) * 100;
                    else p = 0;
                    E('obpct' + i).innerHTML = (abc[i] != '') ? p.toFixed(2) + '%' : '';
                }
                E('obcnt-total').innerHTML = (ort / 125).toFixed(2);
                E('obcntx-total').innerHTML = (ort / 1024).toFixed(2);
            }
            function getArrayPosByElement(haystack, needle, index) {
                for (var i = 0; i < haystack.length; ++i) {
                    if (haystack[i][index] == needle) {
                        return i;
                    }
                }
                return -1;
            }
            var ref = new TomatoRefresh('update.cgi', 'exec=iptraffic', 2, 'ipt_graphs');
            ref.refresh = function(text) {
                var b, i, j, k, l;
                ++lock;
                thistimestamp = new Date().getTime();
                nfmarks = [];
                irates = [];
                orates = [];
                iptraffic = [];
                try {
                    eval(text);
                }
                catch (ex) {
                    nfmarks = [];
                    irates = [];
                    orates = [];
                    iptraffic = [];
                }
                difftimestamp = thistimestamp - prevtimestamp;
                prevtimestamp = thistimestamp;
                for (i = 0; i < iptraffic.length; ++i) {
                    b = iptraffic[i];
                    j = getArrayPosByElement(avgiptraffic, b[0], 0);
                    if (j == -1) {
                        j = avgiptraffic.length;
                        avgiptraffic[j] = [ b[0], 0, 0, 0, 0, 0, 0, 0, 0, b[9], b[10] ];
                    }
                    k = getArrayPosByElement(lastiptraffic, b[0], 0);
                    if (k == -1) {
                        k = lastiptraffic.length;
                        lastiptraffic[k] = b;
                    }
                    for (l = 1; l <= 8; ++l) {
                        avgiptraffic[j][l] = ((b[l] - lastiptraffic[k][l]) / difftimestamp * 1000);
                        lastiptraffic[k][l] = b[l];
                    }
                    avgiptraffic[j][9] = b[9];
                    avgiptraffic[j][10] = b[10];
                    lastiptraffic[k][9] = b[9];
                    lastiptraffic[k][10] = b[10];
                }
                -- lock;
                i = 0;
                while (i < 11){
                    if (iptraffic[i] != null) {
                        nfmarks[i] = avgiptraffic[i][9] + avgiptraffic[i][10]; // TCP + UDP connections
                        irates[i] = avgiptraffic[i][1]; // RX bytes
                        orates[i] = avgiptraffic[i][2]; // TX bytes
                    } else {
                        nfmarks[i] = 0;
                        irates[i] = 0;
                        orates[i] = 0;
                    }
                    ++i;
                }
                showData();
                if (svgReady == 1) {
                    updateCD(nfmarks, abc);
                    updateBD(irates, abc);
                    updateOB(orates, abc);
                }
            }
            function checkSVG() {
                var i, e, d, w;
                try {
                    for (i = 2; i >= 0; --i) {
                        e = E('svg' + i);
                        d = e.getSVGDocument();
                        if (d.defaultView) w = d.defaultView;
                        else w = e.getWindow();
                        if (!w.ready) break;
                        if (i == 0) updateCD = w.updateSVG;
                        if (i == 1)	updateBD = w.updateSVG;
                        if (i == 2)	updateOB = w.updateSVG;
                    }
                }
                catch (ex) {
                }
                if (i < 0) {
                    svgReady = 1;
                    updateCD(nfmarks, abc);
                    updateBD(irates, abc);
                    updateOB(orates, abc);
                }
                else if (--svgReady > -5) {
                    setTimeout(checkSVG, 500);
                }
            }
            function init() {
                showData();
                checkSVG();
                ref.initPage(2000, 3);
                if (!ref.running) ref.once = 1;
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

                    <script type='text/javascript'>
                        if (nvram.cstats_enable != '1') {
                            W('<div class="note-disabled alert alert-info"><b>IP Traffic monitoring disabled.</b> <a href="admin-iptraffic.asp">Enable&nbsp;&raquo;</a></div>');
                        }
                    </script>

                    <h4>Connections Distribution (TCP/UDP)</h4>
                    <div class="section">
                        <table border=0 width="100%"><tr><td>
                                    <table style="width:100%">
                                        <script type="text/javascript">
                                            for (i = 0; i < 11; ++i) {
                                                W('<tr>' +
                                                    '<td class="color" style="background:#' + colors[i] + '" onclick="mClick(' + i + ')">&nbsp;</td>' +
                                                    '<td class="title" style="padding-left: 8px;"><a href="bwm-ipt-details.asp?ipt_filterip=' + abc[i] + '">' + abc[i] + '</a></td>' +
                                                    '<td id="ccnt' + i + '" class="count"></td>' +
                                                    '<td id="cpct' + i + '" class="pct"></td></tr>');
                                            }
                                        </script>
                                        <tr><td>&nbsp;</td><td class="total">Total</td><td id="ccnt-total" class="total count"></td><td class="total pct">100%</td></tr>
                                    </table>
                                </td><td>
                                    <script type="text/javascript">
                                        if (nvram.web_svg != '0') {
                                            W('<embed src="img/ipt-graph.svg?n=0&v=<% version(); %>" style="width:310px;height:310px; float: right;" id="svg0" type="image/svg+xml" pluginspage="http://www.adobe.com/svg/viewer/install/"></embed>');
                                        }
                                    </script>
                                </td></tr>
                        </table>
                    </div>
                    <br />
                    <h4>Bandwidth Distribution (Inbound)</h4>
                    <div class="section">
                        <table border=0 width="100%"><tr><td>
                                    <table style="width:100%">
                                        <tr><td class='color' style="height:1em"></td><td class='title' style="width:45px">&nbsp;</td><td class='thead count'>kbit/s</td><td class='thead count'>KB/s</td><td class='pct'>&nbsp;</td></tr>
                                        <script type='text/javascript'>
                                            for (i = 0; i < 11; ++i) {
                                                W('<tr>' +
                                                    '<td class="color" style="background:#' + colors[i] + '" onclick="mClick(' + i + ')">&nbsp;</td>' +
                                                    '<td class="title" style="padding-left: 8px;"><a href="bwm-ipt-details.asp?ipt_filterip=' + abc[i] + '">' + abc[i] + '</a></td>' +
                                                    '<td id="bcnt' + i + '" class="count"></td>' +
                                                    '<td id="bcntx' + i + '" class="count"></td>' +
                                                    '<td id="bpct' + i + '" class="pct"></td></tr>');
                                            }
                                        </script>
                                        <tr><td>&nbsp;</td><td class="total">Total</td><td id="bcnt-total" class="total count"></td><td id="bcntx-total" class="total count"></td><td class="total pct">100%</td></tr>
                                    </table>
                                </td><td style="margin-right:150px">
                                    <script type='text/javascript'>
                                        if (nvram.web_svg != '0') {
                                            W('<embed src="img/ipt-graph.svg?n=1&v=<% version(); %>" style="width:310px;height:310px;float: right;" id="svg1" type="image/svg+xml" pluginspage="http://www.adobe.com/svg/viewer/install/"></embed>');
                                        }
                                    </script>
                                </td></tr>
                        </table>
                    </div>
                    <br />
                    <h4>Distribution (Outbound)</h4> 
                    <div class="section">
                        <table border=0 width="100%"><tr><td>
                                    <table style="width:100%">
                                        <tr><td class='color' style="height:1em"></td><td class='title' style="width:45px">&nbsp;</td><td class='thead count'>kbit/s</td><td class='thead count'>KB/s</td><td class='pct'>&nbsp;</td></tr>
                                        <script type='text/javascript'>
                                            for (i = 0; i < 11; ++i) {
                                                W('<tr>' +
                                                    '<td class="color" style="background:#' + colors[i] + '" onclick="mClick(' + i + ')">&nbsp;</td>' +
                                                    '<td class="title" style="padding-left: 8px;"><a href="bwm-ipt-details.asp?ipt_filterip=' + abc[i] + '">' + abc[i] + '</a></td>' +
                                                    '<td id="obcnt' + i + '" class="count"></td>' +
                                                    '<td id="obcntx' + i + '" class="count"></td>' +
                                                    '<td id="obpct' + i + '" class="pct"></td></tr>');
                                            }
                                        </script>
                                        <tr><td>&nbsp;</td><td class="total">Total</td><td id="obcnt-total" class="total count"></td><td id="obcntx-total" class="total count"></td><td class="total pct">100%</td></tr>
                                    </table>
                                </td><td style="margin-right:150px">
                                    <script type='text/javascript'>
                                        if (nvram.web_svg != '0') {
                                            W('<embed src="img/ipt-graph.svg?n=2&v=<% version(); %>" style="width:310px;height:310px;float: right;" id="svg2" type="image/svg+xml" pluginspage="http://www.adobe.com/svg/viewer/install/"></embed>');
                                        }
                                    </script>
                                </td></tr>
                        </table>
                    </div>
                    </td></tr>
                    </table>
                    <!-- / / / -->

                    <br />                    
                    <script type='text/javascript'>genStdRefresh(1,1,'ref.toggle()');</script>

                </div><!--/span-->
            </div><!--/row-->
            <hr>
<div class="footer">
                <p><a href="about.asp">&copy; AdvancedTomato 2013</a> <span style="padding: 0 15px; float:right; text-align:right;">Version: <b><% version(1); %></b></span></p> 
            </div>
        </div><!--/.fluid-container-->
    </body>
</html>