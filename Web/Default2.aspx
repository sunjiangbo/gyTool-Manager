<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default2.aspx.cs" Inherits="Default2" %>


<!doctype html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="keywords" content="jquery,ui,easy,easyui,web">
    <meta name="description" content="easyui help you build your web page easily!">
    <title>DataGrid Card View - jQuery EasyUI Demo</title>
    <link rel="stylesheet" type="text/css" href="http://www.jeasyui.com/easyui/themes/default/easyui.css">
    <link rel="stylesheet" type="text/css" href="http://www.jeasyui.com/easyui/themes/icon.css">
    <link rel="stylesheet" type="text/css" href="http://www.jeasyui.com/easyui/demo/demo.css">
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.6.1.min.js"></script>
    <script type="text/javascript" src="http://www.jeasyui.com/easyui/jquery.easyui.min.js"></script>
</head>
<body>
   
    <table id="tt" style="width:700px;"
            title="DataGrid - CardView" singleSelect="true" fitColumns="true" remoteSort="false"
            url="AJAX/test.ashx"sortOrder="asc" sortName="ClassID">
        <thead>
            <tr>
                <th field="itemid" width="80" sortable="true">Item ID</th>
                <th field="listprice" width="120" sortable="true">List Price</th>
                <th field="unitcost" width="80" sortable="true">Unit Cost</th>
                <th field="attr1" width="250" sortable="true">Attribute</th>
                <th field="status" width="60" sortable="true">Status</th>
            </tr>
        </thead>
    </table>    
    <script>
        var cardview = $.extend({}, $.fn.datagrid.defaults.view, {
            renderRow: function (target, fields, frozen, rowIndex, rowData) {
                var cc = [];
               cc.push('<table><tr><td colspan=' + fields.length + ' style="padding:10px 5px;border:0;">');
               /* if (!frozen && rowData.itemid){
                    var aa = rowData.itemid.split('-');
                    var img = 'shirt' + aa[1] + '.gif';
                    cc.push('<img src="images/' + img + '" style="width:150px;float:left">');
                    cc.push('<div style="float:left;margin-left:20px;">');
                    for(var i=0; i<fields.length; i++){
                        var copts = $(target).datagrid('getColumnOption', fields[i]);
                        cc.push('<p><span class="c-label">' + copts.title + ':</span> ' + rowData[fields[i]] ) + '<p>';
                     }
                    cc.push('</div>');
                }*/
                cc.push(JSON.stringify(rowData) + '</td></tr></table>');
                return cc.join('');
 
            }
        });
        $(function () {
            $('#tt').datagrid({
                view: cardview
            });
        });
    </script>
</body>
</html>