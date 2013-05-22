<!DOCTYPE html>
<!--
Tomato GUI
Copyright (C) 2006-2008 Jonathan Zarate
http://www.polarcloud.com/tomato/

Copyright (C) 2011 Deon 'PrinceAMD' Thomas 
rate limit & connection limit from Conanxu, 
adapted by Victek, Shibby, PrinceAMD, Phykris

For use with Tomato Firmware only.
No part of this file may be used without permission.
-->
<html lang="en">
    <head>
        <meta charset="utf-8">

        <meta http-equiv='content-type' content='text/html;charset=utf-8'>
        <meta name='robots' content='noindex,nofollow'>
        <title>[<% ident(); %>] QoS - Bandwidth Limiter</title>

        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="css/bootstrap-responsive.min.css" rel="stylesheet">
        <link href="css/tomato.css" rel="stylesheet">
        <% css(); %>


        <script type="text/javascript" src="js/jquery.lite.min.js"></script>
        <script type="text/javascript" src="tomato.js"></script>

        <!-- / / / -->
        <script type="text/javascript">
            // <% nvram("qosl_enable,qos_ibw,qos_obw,qosl_rules,lan_ipaddr,lan_netmask"); %>

            var class_prio = [['0','Highest'],['1','High'],['2','Normal'],['3','Low'],['4','Lowest']];
            var class_tcp = [['0','nolimit']];
            var class_udp = [['0','nolimit']];
            for (var i = 1; i <= 100; ++i) {
                class_tcp.push([i*10, i*10+'']);
                class_udp.push([i, i + '/s']);
            }
            var qosg = new TomatoGrid();

            qosg.setup = function() {
                this.init('qosg-grid', '', 80, [
                        { type: 'text', maxlen: 31 },
                        { type: 'text', maxlen: 6 },
                        { type: 'text', maxlen: 6 },
                        { type: 'text', maxlen: 6 },
                        { type: 'text', maxlen: 6 },
                        { type: 'select', options: class_prio },
                        { type: 'select', options: class_tcp },
                        { type: 'select', options: class_udp }]);
                this.headerSet(['IP | IP Range | MAC Address', 'DLRate', 'DLCeil', 'ULRate', 'ULCeil', 'Priority', 'TCP Limit', 'UDP Limit']);
                var qoslimitrules = nvram.qosl_rules.split('>');
                for (var i = 0; i < qoslimitrules.length; ++i) {
                    var t = qoslimitrules[i].split('<');
                    if (t.length == 8) this.insertData(-1, t);
                }
                this.showNewEditor();
                this.resetNewEditor();
            }

            qosg.dataToView = function(data) {
                return [data[0],data[1]+'kbps',data[2]+'kbps',data[3]+'kbps',data[4]+'kbps',class_prio[data[5]*1][1],class_tcp[data[6]*1/10][1],class_udp[data[7]*1][1]];
            }

            qosg.resetNewEditor = function() {
                var f, c, n;

                var f = fields.getAll(this.newEditor);
                ferror.clearAll(f);
                if ((c = cookie.get('addqoslimit')) != null) {
                    cookie.set('addqoslimit', '', 0);
                    c = c.split(',');
                    if (c.length == 2) {
                        f[0].value = c[0];
                        f[1].value = '';
                        f[2].value = '';
                        f[3].value = '';
                        f[4].value = '';
                        f[5].selectedIndex = '2';
                        f[6].selectedIndex = '0';
                        f[7].selectedIndex = '0';
                        return;
                    }
                }

                f[0].value = '';
                f[1].value = '';
                f[2].value = '';
                f[3].value = '';
                f[4].value = '';
                f[5].selectedIndex = '2';
                f[6].selectedIndex = '0';
                f[7].selectedIndex = '0';

            }

            qosg.exist = function(f, v)
            {
                var data = this.getAllData();
                for (var i = 0; i < data.length; ++i) {
                    if (data[i][f] == v) return true;
                }
                return false;
            }

            qosg.existID = function(id)
            {
                return this.exist(0, id);
            }

            qosg.existIP = function(ip)
            {
                if (ip == "0.0.0.0") return true;
                return this.exist(1, ip);
            }

            qosg.checkRate = function(rate)
            {
                var s = parseInt(rate, 10);
                if( isNaN(s) || s <= 0 || a >= 100000 ) return true;
                return false;
            }

            qosg.checkRateCeil = function(rate, ceil)
            {
                var r = parseInt(rate, 10);
                var c = parseInt(ceil, 10);
                if( r > c ) return true;
                return false;
            }

            qosg.verifyFields = function(row, quiet)
            {
                var ok = 1;
                var f = fields.getAll(row);
                var s;

                if(v_macip(f[0], quiet, 0, nvram.lan_ipaddr, nvram.lan_netmask)) {
                    if(this.existIP(f[0].value)) {
                        ferror.set(f[0], 'duplicate IP or MAC address', quiet);
                        ok = 0;
                    }
                }

                if( this.checkRate(f[1].value)) {
                    ferror.set(f[1], 'DLRate must between 1 and 99999', quiet);
                    ok = 0;
                }

                if( this.checkRate(f[2].value)) {
                    ferror.set(f[2], 'DLCeil must between 1 and 99999', quiet);
                    ok = 0;
                }

                if( this.checkRateCeil(f[1].value, f[2].value)) {
                    ferror.set(f[2], 'DLCeil must be greater than DLRate', quiet);
                    ok = 0;
                }

                if( this.checkRate(f[3].value)) {
                    ferror.set(f[3], 'ULRate must between 1 and 99999', quiet);
                    ok = 0;
                }

                if( this.checkRate(f[4].value)) {
                    ferror.set(f[4], 'ULCeil must between 1 and 99999', quiet);
                    ok = 0;
                }

                if( this.checkRateCeil(f[3].value, f[4].value)) {
                    ferror.set(f[4], 'ULCeil must be greater than ULRate', quiet);
                    ok = 0;
                }

                return ok;
            }

            function verifyFields(focused, quiet)
            {
                var a = !E('_f_qosl_enable').checked;

                E('_qos_ibw').disabled = a;
                E('_qos_obw').disabled = a;

                elem.display(PR('_qos_ibw'), PR('_qos_obw'), !a);

                return 1;
            }

            function save()
            {
                if (qosg.isEditing()) return;

                var data = qosg.getAllData();
                var qoslimitrules = '';
                var i;

                if (data.length != 0) qoslimitrules += data[0].join('<');	
                for (i = 1; i < data.length; ++i) {
                    qoslimitrules += '>' + data[i].join('<');
                }

                var fom = E('_fom');
                fom.qosl_enable.value = E('_f_qosl_enable').checked ? 1 : 0;
                fom.qosl_rules.value = qoslimitrules;
                form.submit(fom, 1);
            }

            function init()
            {
                qosg.recolor();
            }
        </script>
    </head>
    <body onload="init()">
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
                        <input type="hidden" name="_nextpage" value="qos-qoslimit.asp">
                        <input type="hidden" name="_nextwait" value="10">
                        <input type="hidden" name="_service" value="qoslimit-restart">

                        <input type="hidden" name="qosl_enable">
                        <input type="hidden" name="qosl_rules">

                        <div id="qoslimit">
                            <h3>Bandwidth Limiter - QOS</h3>
                            <div class="section">
                                <script type="text/javascript">
                                    createFieldTable('', [
                                            { title: 'Enable Limiter', name: 'f_qosl_enable', type: 'checkbox', value: nvram.qosl_enable != '0' },
                                            { title: 'Max Download Bandwidth <small>(also used by QOS)', name: 'qos_ibw', type: 'text', maxlen: 6, size: 8, suffix: ' <small>kbit/s</small>', value: nvram.qos_ibw },
                                            { title: 'Max Upload Bandwidth <small>(also used by QOS)', name: 'qos_obw', type: 'text', maxlen: 6, size: 8, suffix: ' <small>kbit/s</small>', value: nvram.qos_obw }
                                        ]);
                                </script>
                                <br>
                                <table class="table table-striped table-condensed table-bordered langrid" id="qosg-grid"></table>
                                <div>
                                    <ul>
                                        <li><b>IP Address / IP Range</b> - e.g. 192.168.1.5 or 192.168.1.45-57 or 45-57 -  A range of IP's will <b>share</b> the bandwidth.<br>
                                    </ul>
                                </div>
                            </div>

                            <br />
                            <button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">Save</button>
                            <button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">Cancel</button>
                            &nbsp; <span id="footer-msg" class="alert warning" style="visibility: hidden;"></span>

                        </div>
                    </form>


                </div><!--/span-->
            </div><!--/row-->
            <hr>
<div class="footer">
                <p><a href="about.asp">&copy; AdvancedTomato 2013</a> <span style="padding: 0 15px; float:right; text-align:right;">Version: <b><% version(1); %></b></span></p> 
            </div>
        </div><!--/.fluid-container-->
        <script type="text/javascript">qosg.setup(); verifyFields(null, 1);</script>
    </body>
</html>
