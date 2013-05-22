<!DOCTYPE html>
<!--
Tomato GUI
Copyright (C) 2006-2010 Jonathan Zarate
http://www.polarcloud.com/tomato/
Tomato VLAN GUI
Copyright (C) 2011 Augusto Bott
http://code.google.com/p/tomato-sdhc-vlan/
For use with Tomato Firmware only.
No part of this file may be used without permission.
-->
<html>
    <head>
        <meta http-equiv="content-type" content="text/html;charset=utf-8">
        <meta name="robots" content="noindex,nofollow">
        <title>[<% ident(); %>]: Mobile Access</title>
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/mobile.css">
        <script type="text/javascript" src="js/jquery.lite.min.js"></script>
        <script type="text/javascript" src="tomato.js"></script>
        <script type="text/javascript" src="js/interfaces.js"></script>
        <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=0.5, maximum-scale=1">
        <script type="text/javascript">
            //<% nvstat(); %>
            //<% nvram('at_update,lan_ifname,wl_ifname,wl_mode,wl_radio'); %>
            wmo = {'ap':'Access Point','sta':'Wireless Client','wet':'Wireless Ethernet Bridge','wds':'WDS'};
            auth = {'disabled':'-','wep':'WEP','wpa_personal':'WPA Personal (PSK)','wpa_enterprise':'WPA Enterprise','wpa2_personal':'WPA2 Personal (PSK)','wpa2_enterprise':'WPA2 Enterprise','wpaX_personal':'WPA / WPA2 Personal','wpaX_enterprise':'WPA / WPA2 Enterprise','radius':'Radius'};
            enc = {'tkip':'TKIP','aes':'AES','tkip+aes':'TKIP / AES'};
            bgmo = {'disabled':'-','mixed':'Auto','b-only':'B Only','g-only':'G Only','bg-mixed':'B/G Mixed','lrs':'LRS','n-only':'N Only'};
        </script>
        <script type='text/javascript' src='js/wireless.jsx?_http_id=<% nv(http_id); %>'></script>
        <script type='text/javascript' src='js/status-data.jsx?_http_id=<% nv(http_id); %>'></script>
        <script type='text/javascript'>
            show_dhcpc = ((nvram.wan_proto == 'dhcp') || (((nvram.wan_proto == 'l2tp') || (nvram.wan_proto == 'pptp')) && (nvram.pptp_dhcp == '1')));
            show_codi = ((nvram.wan_proto == 'pppoe') || (nvram.wan_proto == 'l2tp') || (nvram.wan_proto == 'pptp') || (nvram.wan_proto == 'ppp3g'));
            show_radio = [];

            nphy = features('11n');
            function dhcpc(what)
            {
                form.submitHidden('dhcpc.cgi', { exec: what, _redirect: 'status-overview.asp' });
            }
            function serv(service, sleep)
            {
                form.submitHidden('/service.cgi', { _service: service, _redirect: '/ext/mobile.asp', _sleep: sleep });
            }
            function wan_connect()
            {
                serv('wan-restart', 5);
            }
            function wan_disconnect()
            {
                serv('wan-stop', 2);
            }

            var ref = new TomatoRefresh('/status-data.jsx', '', 0, 'status_overview_refresh');
            ref.refresh = function(text)
            {
                stats = {};
                try {
                    eval(text);
                }
                catch (ex) {
                    stats = {};
                }
                show();
            }
            function c(id, htm)
            {
                document.getElementById(id).innerHTML = htm;
            }

            function reboots()
            {
                if (confirm("Reboot?")) form.submitHidden('/tomato.cgi', { _reboot: 1, _commit: 0, _nvset: 0 });
            }

            function show()
            {
                c('cpu', stats.cpuload);
                c('uptime', stats.uptime);
                c('time', stats.time);
                c('wanip', stats.wanip);
                c('wanstatus', stats.wanstatus);
                c('wanuptime', stats.wanuptime);
                c('wannetmask', stats.wannetmask);
                c('wangateway', stats.wangateway);
                c('dns', stats.dns);

            }

            function displayData() {

                var a = nvstat.free / nvstat.size * 100.0;
                var div = document.getElementById('routerInfo');

                switch(nvram.wan_proto)
                {
                    case 'dhcp':
                        nvram.wan_proto = 'DHCP';
                        break;

                    case 'pppoe':
                        nvram.wan_proto = 'PPPoE';
                        break;

                    case 'static':
                        nvram.wan_proto = 'Static IP';
                        break;

                    case 'pptp':
                        nvram.wan_proto = 'PPTP';
                        break;

                    case 'l2tp':
                        nvram.wan_proto = 'L2TP';
                        break;

                    case 'ppp3g':
                        nvram.wan_proto = '3G Modem';
                        break;                        

                }

                // Lets create stuff :)
                div.innerHTML = '<div class="fluid"><h2>System Info <span class="toggle"><a href="javascript: Toggle(\'sys\')"><i id="s_sys" class="icon-chevron-down icon-black"></i></a></span></h2>' +
                '<div id="sys">' +
                '<div class="fieldname">Name:</div> <div class="fieldvalue">' + nvram.router_name + '</div> <br />' +
                '<div class="fieldname">Model:</div> <div class="fieldvalue">' + nvram.t_model_name + '</div> <br />' +
                '<div class="fieldname">Chipset:</div> <div class="fieldvalue">' + stats.systemtype + '</div> <br />' +
                '<div class="fieldname">CPU Freq:</div> <div class="fieldvalue">' + stats.cpumhz + '</div> <br />' +
                '<div class="fieldname">Flash Size:</div> <div class="fieldvalue">' + stats.flashsize + '</div> <br /><br />' +

                '<div class="fieldname">Time:</div> <div id="time" class="fieldvalue">' + stats.time + '</div> <br />' +
                '<div class="fieldname">Uptime:</div> <div id="uptime" class="fieldvalue">' + stats.uptime + '</div> <br />' +
                '<div class="fieldname">CPU load:</div> <div class="fieldvalue"><span id="cpu">' + stats.cpuload + ' </span> <b>(1 / 5 / 10 min)</b></div> <br /><br />' +

                '<div class="fieldname">Memory:</div> <div class="fieldvalue"><span id="memory">' + stats.memory + ' </span> </div> <br />' + 
                ((stats.swap != "") ? '<div class="fieldname">Swap:</div> <div class="fieldvalue"><span id="swap">' + stats.swap + ' </span> </div> <br />' : '') +  // Don't display SWAP field if there is no swap used.
                '<div class="fieldname">NVRAM:</div> <div class="fieldvalue"><span id="nvram">' + scaleSize(nvstat.size) + ' / ' + scaleSize(nvstat.free) + ' <small>(' + (a).toFixed(2) + '%)</small>' + ' </span> </div> <br />' +
                '</div></div>' +

                // Second Fluid Table
                '<div class="fluid"><h2>WAN <span class="toggle"><a href="javascript: Toggle(\'wan\')"><i id="s_wan" class="icon-chevron-down icon-black"></i></a></span></h2>' +
                '<div id="wan">' +
                '<div class="fieldname">MAC Address:</div> <div class="fieldvalue">' + nvram.wan_hwaddr + '</div> <br />' +
                '<div class="fieldname">Connection Type:</div> <div class="fieldvalue">' + nvram.wan_proto + '</div> <br />' +
                '<div class="fieldname">IP Address:</div> <div id="wanip" class="fieldvalue">' + stats.wanip + '</div> <br />' +
                '<div class="fieldname">Prev IP Address:</div> <div id="wanprebuf" class="fieldvalue">' + stats.wanprebuf + '</div> <br />' +
                '<div class="fieldname">Subnet Mask:</div> <div id="wannetmask" class="fieldvalue">' + stats.wannetmask + '</div> <br />' +
                '<div class="fieldname">Gateway:</div> <div id="wangateway" class="fieldvalue">' + stats.wangateway + '</div> <br />' +
                '<div class="fieldname">DNS:</div> <div id="dns" class="fieldvalue">' + stats.dns + '</div> <br />' +
                '<div class="fieldname">MTU:</div> <div id="" class="fieldvalue">' + nvram.wan_run_mtu + '</div> <br /><br />' +

                '<div class="fieldname">Status:</div> <div id="wanstatus" class="fieldvalue">' + stats.wanstatus + '</div> <br />' +
                '<div class="fieldname">Link Uptime:</div> <div id="wanuptime" class="fieldvalue">' + stats.wanuptime + '</div> <br />' +

                '</div></div>' +

                // Third Fluid Table
                '<div class="fluid"><h2>LAN <span class="toggle"><a href="javascript: Toggle(\'lan\')"><i id="s_lan" class="icon-chevron-down icon-black"></i></a></span></h2>' +
                '<div id="lan">' +
                '<div class="fieldname">MAC Address:</div> <div class="fieldvalue">' + nvram.et0macaddr + '</div> <br />' +
                '<div class="fieldname">IP Address:</div> <div class="fieldvalue">' + nvram.lan_ifname + ' - ' + nvram.lan_ipaddr + '</div> <br />' +
                '<div class="fieldname">DHCP:</div> <div class="fieldvalue">' + nvram.lan_ifname + ' - ' + nvram.dhcpd_startip + ' - ' + nvram.dhcpd_endip + '</div> <br />' +

                '</div></div>'

            }

            var xob = null;
            function deleteLease(a, ip) {
                if (xob) return;
                if ((xob = new XmlHttp()) == null) {
                    _deleteLease(ip);
                    return;
                }
                a = E(a);
                a.innerHTML = 'deleting...';
                xob.onCompleted = function(text, xml) {
                    a.innerHTML = '...';
                    xob = null;
                }
                xob.onError = function() {
                    _deleteLease(ip);
                }
                xob.post('/dhcpd.cgi', 'remove=' + ip);
            }

            function init()
            {

                displayData();

                var c;
                if (((c = cookie.get('mobile_nav-settings_vis')) != null) && (c != '1')) Toggle("nav-settings");
                if (((c = cookie.get('mobile_sys_vis')) != null) && (c != '1')) Toggle("sys");
                if (((c = cookie.get('mobile_wan_vis')) != null) && (c != '1')) Toggle("wan");
                if (((c = cookie.get('mobile_rcontrol_vis')) != null) && (c != '1')) Toggle("rcontrol");
                if (((c = cookie.get('mobile_lan_vis')) != null) && (c != '1')) Toggle("lan");

                for (var uidx = 0; uidx < wl_ifaces.length; ++uidx) {
                    u = wl_unit(uidx);
                    if (((c = cookie.get('mobile_wifi'+u+'_vis')) != null) && (c != '1')) Toggle("wifi"+u);
                }

                // ref.initPage(5000, 3);

            }

            function save() {
                fom = E("_fom");
                form.submit(fom, 1);   
            }

            function Toggle(Elm) {

                if (E(Elm).style.display == '') {
                    E(Elm).style.display = 'none';
                    E('s_' + Elm).className = 'icon-chevron-up icon-black';
                    cookie.set('mobile_' + Elm + '_vis', 0);
                } else {
                    E(Elm).style.display='';
                    E('s_' + Elm).className = 'icon-chevron-down icon-black';
                    cookie.set('mobile_' + Elm + '_vis', 1);
                }
            }    
        </script>
    </head>
    <body onload="init()">

    <div id="container">
    <div id="head">
        <div class="right"><% ident(); %></div>
        <div class="title">AdvancedTomato</div>
        <div class="version"><% version(0); %></div>
    </div>

    <div class="content">

        <div id="main"><div class="span12"></div></div>

        <div id="routerInfo"></div>
        <script type="text/javascript">
            for (var uidx = 0; uidx < wl_ifaces.length; ++uidx) {
                u = wl_fface(uidx);
                W('<div class="fluid"><h2>Wireless');
                if (wl_ifaces.length > 0)
                    W(' (' + wl_display_ifname(uidx) + ')');

                W('&nbsp;<span class="toggle"><a href="javascript: Toggle(\'wifi' + uidx + '\')"><i id="s_wifi' + uidx + '" class="icon-chevron-down icon-black"></i></a></span></h2>'+
                    '<div id="wifi' + uidx + '">');

                sec = auth[nvram['wl'+u+'_security_mode']] + '';
                if (sec.indexOf('WPA') != -1) sec += ' + ' + enc[nvram['wl'+u+'_crypto']];
                wmode = wmo[nvram['wl'+u+'_mode']] + '';
                if ((nvram['wl'+u+'_mode'] == 'ap') && (nvram['wl'+u+'_wds_enable'] * 1)) wmode += ' + WDS';

                W('<div class="fieldname">MAC Address:</div> <div class="fieldvalue">' +  nvram['wl'+u+'_hwaddr'] + '</div> <br />');
                W('<div class="fieldname">Mode:</div> <div class="fieldvalue">' +  wmode + '</div> <br />');

                if (wl_sunit(uidx) <= 0) { 
                    W('<div class="fieldname">Network Mode:</div> <div class="fieldvalue">' +  bgmo[nvram['wl'+u+'_net_mode']] + '</div> <br />');
                }

                W('<div class="fieldname">Interface Status:</div> <div class="fieldvalue">' +  wlstats[uidx].ifstatus + '</div> <br />');

                if (wl_sunit(uidx)<=0) {
                    W('<div class="fieldname">Radio:</div> <div class="fieldvalue">' + ((wlstats[uidx].radio == 0) ? '<b>Disabled</b>' : 'Enabled') + '</div> <br />');
                }

                W('<div class="fieldname">SSID:</div> <div class="fieldvalue">' +  nvram['wl'+u+'_ssid'] + '</div> <br />');

                if (nvram['wl'+u+'_mode'] == 'ap') { 
                    W('<div class="fieldname">Broadcast:</div> <div class="fieldvalue">' + ((nvram['wl'+u+'_closed'] == 0) ? 'Enabled' : '<b>Disabled</b>') + '</div> <br />');
                }

                W('<div class="fieldname">Security:</div> <div class="fieldvalue">' +  sec + '</div> <br />');

                if (wl_sunit(uidx)<=0) {
                    W('<div class="fieldname">Channel:</div> <div class="fieldvalue">' +  stats.channel[uidx].replace(/<a(.*?)>(.*)<\/a>/gi, '$2') + '</div> <br />');
                }

                if ((!nphy) || (wl_sunit(uidx)<=0)) {
                    W('<div class="fieldname">Channel Width:</div> <div class="fieldvalue">' +  wlstats[uidx].nbw + '</div> <br />');
                }

                if ((stats.interference[uidx] != '') || (wl_sunit(uidx)<=0)) {
                    W('<div class="fieldname">Interference:</div> <div class="fieldvalue">' +  stats.interference[uidx] + '</div> <br />');
                }

                if (wl_sunit(uidx)<=0) { W('<div class="fieldname">Rate:</div> <div class="fieldvalue">' +  wlstats[uidx].rate + '</div> <br />'); }
                if ((!wlstats[uidx].client) || (wl_sunit(uidx)>=0)) { W('<div class="fieldname">Noise:</div> <div class="fieldvalue">' +  wlstats[uidx].noise + '</div> <br />'); }


                W('</div></div>');
            }
        </script>

        <div class="nofluid">
            <h2>Change Navigation <span class="toggle"><a href="javascript: Toggle('nav-settings')"><i id="s_nav-settings" class="icon-chevron-down icon-black"></i></a></span></h2>
            <div id="nav-settings">
                This is not settings page of Tomato! This will just allow you to switch theme/navigation to allow you to access responsive UI instead of mobile (Case of bug or Metro Navigation) <br /><br />
                <div class="input-append">
                    <div class="btn-group">
                        <form id="_fom" method="post" action="tomato.cgi">
                            <input type="hidden" name="_nextpage" value="status-mobile.asp">
                            <label for="_at_navigation">Navigation Style:</label>
                            <select name="at_navigation" id="_at_navigation">
                                <option value="nav-top" selected="">Top (Drop-down)</option>
                                <option value="nav-left">Metro Left Side</option>
                            </select>
                            <button id="save-button" class="btn" value="Save" type="button" onclick="save();">Save</button>
                        </form>
                    </div>
                </div>
                <br /><span id="footer-msg" class="alert warning" style="visibility: hidden; margin-bottom: 5px; padding-bottom: 8px;"></span>
            </div>

            <div class="nofluid center">
                <h2>Router Control <span class="toggle"><a href="javascript: Toggle('rcontrol')"><i id="s_rcontrol" class="icon-chevron-down icon-black"></i></a></span></h2>
                <div id="rcontrol">
                <b>Connect</b>: Will attempt to connect to WAN. | <b>Disconnect</b>: Will attempt to disconnect your WAN. | <b>Reboot</b> will reboot your router<br />
                    <a href="javascript:wan_connect()" class="but"><i class="icon-home icon-white"></i> Connect</a>
                    <a href="javascript:wan_disconnect()" class="but"><i class="icon-remove icon-white"></i> Disconnect</a>
                    <a href="javascript:reboots()" class="but"><i class="icon-off icon-white"></i> Restart</a>
                </div>
            </div>
            <br /><div style="width: 100%; text-align: center"><a href="/">Switch to Destkop UI</a></div>
        </div>

        <div class="footer">
            CopyRight &copy; 2013 <a href="http://tomatousb.org">Tomato USB Project</a> <br />
            This page is part of AdvancedTomato - <a href="http://at.prahec.com/">AT Home Page</a>
        </div>
    </div>
</html>
