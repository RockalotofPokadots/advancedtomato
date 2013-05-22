<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.0//EN'>
<!--
Tomato GUI
Copyright (C) 2007-2011 Shibby
http://openlinksys.info
For use with Tomato Firmware only.
No part of this file may be used without permission.
-->
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="content-type" content="text/html;charset=utf-8">
        <meta name="robots" content="noindex,nofollow">
        <title>[<% ident(); %>] Admin: NFS Server</title>

        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="css/bootstrap-responsive.min.css" rel="stylesheet">
        <link href="css/tomato.css" rel="stylesheet">
        <% css(); %>


        <script type="text/javascript" src="js/jquery.lite.min.js"></script>
        <script type="text/javascript" src="tomato.js"></script>
        <script type='text/javascript'>
            //	<% nvram("at_update,tomatoanon_answer,nfs_enable,nfs_exports"); %>
            var access = [['rw', 'Read/Write'], ['ro', 'Read only']];
            var sync = [['sync', 'Yes'], ['async', 'No']];
            var subtree = [['subtree_check', 'Yes'], ['no_subtree_check', 'No']];
            var nfsg = new TomatoGrid();
            nfsg.exist = function(f, v)
            {
                var data = this.getAllData();
                for (var i = 0; i < data.length; ++i) {
                    if (data[i][f] == v) return true;
                }
                return false;
            }
            nfsg.dataToView = function(data) {
                return [data[0], data[1], data[2],data[3], data[4], data[5]];
            }
            nfsg.verifyFields = function(row, quiet)
            {
                var ok = 1;
                return ok;
            }
            nfsg.resetNewEditor = function() {
                var f;
                f = fields.getAll(this.newEditor);
                ferror.clearAll(f);
                f[0].value = '';
                f[1].value = '';
                f[2].selectedIndex = 0;
                f[3].selectedIndex = 0;
                f[4].selectedIndex = 1;
                f[5].value = 'no_root_squash';
            }
            nfsg.setup = function()
            {
                this.init('nfsg-grid', '', 50, [
                        { type: 'text', maxlen: 50 },
                        { type: 'text', maxlen: 30 },
                        { type: 'select', options: access },
                        { type: 'select', options: sync },
                        { type: 'select', options: subtree },
                        { type: 'text', maxlen: 50 }
                    ]);
                this.headerSet(['Directory', 'IP Address/Subnet', 'Access', 'Sync', 'Subtree Check', 'Other Options']);
                var s = nvram.nfs_exports.split('>');
                for (var i = 0; i < s.length; ++i) {
                    var t = s[i].split('<');
                    if (t.length == 6) this.insertData(-1, t);
                }
                this.showNewEditor();
                this.resetNewEditor();
            }
            function save()
            {
                var data = nfsg.getAllData();
                var exports = '';
                var i;
                if (data.length != 0) exports += data[0].join('<');
                for (i = 1; i < data.length; ++i) {
                    exports += '>' + data[i].join('<');
                }
                var fom = E('_fom');
                fom.nfs_enable.value = E('_f_nfs_enable').checked ? 1 : 0;
                fom.nfs_exports.value = exports;
                form.submit(fom, 1);
            }
            function init()
            {
                nfsg.recolor();
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

                    <form id="_fom" method="post" action="tomato.cgi">
                        <input type="hidden" name="_nextpage" value="admin-nfs.asp">
                        <input type="hidden" name="_service" value="nfs-start">
                        <input type="hidden" name="nfs_enable">
                        <input type="hidden" name="nfs_exports">

                        <h3>NFS Server</h3>
                        <div class="section">
                            <script type="text/javascript">
                                createFieldTable('', [
                                        { title: 'Enable NFS Server', name: 'f_nfs_enable', type: 'checkbox', value: nvram.nfs_enable != '0' }
                                    ]);
                            </script>

                            <h3>Exports</h3>
                            <div class="section">
                                <table class='table table-striped table-condensed table-bordered langrid' cellspacing=1 id='nfsg-grid'></table>
                                <script type='text/javascript'>nfsg.setup();</script>
                                <ul>
                                    <li>You can find more information on proper NFS configuration at the following website: <a href="http://nfs.sourceforge.net/nfs-howto/" target="_blanc"><b>http://nfs.sourceforge.net</b></a>.
                                </ul>
                            </div>
                        </div>
                        <br />
                        <h3>NFS Client</h3>
                        
                        <div class='section'>
                            <ul>
                                <li>If you want to mount an NFS share from other NFS Server, you can use the mount.nfs tool via telnet/ssh.
                            </ul>
                        </div>

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
        <script type='text/javascript'>verifyFields(null, 1);</script>
    </body>
</html>
