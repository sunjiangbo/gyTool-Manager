<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ClassManage.aspx.cs" Inherits="ClassManage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
 <link id="easyuiTheme" rel="stylesheet" type="text/css" href="themes/gray/easyui.css"/>
	<link rel="stylesheet" type="text/css" href="themes/icon.css">
	<link rel="stylesheet" type="text/css" href="demo/demo.css">
	<script type="text/javascript" src="jquery.min.js"></script>
	<script type="text/javascript" src="jquery.easyui.min.js"></script>
    <script type="text/javascript" src="JS/MyJS.js"></script>
    <link href="Css/MyCSS.css" rel="stylesheet" type="text/css" />
    
</head>
<body>
<script>
    var isPostBack = false;
    var jsondat;
    var CID = '<%= CID %>';  /* 即ClassID */

    function AddProperty() {
        var necessary = 0,Compare = 1 ;

        if ($.trim($("#nameInput").val()) == "") {
            $.messager.alert('提示', '请输入属性名哦！');
            return;
        }

        if ($("#ckadd").is(":checked")) {
            necessary = 1;
        }
        if ($("#pckadd").is(":checked")) {
            Compare = 0;
        }
        $.messager.progress({ title: '提示', msg: '正在处理，请稍候……' });
        $.ajax({
            url: 'AJAX/Handler.ashx',
            type: "POST",
            data: JSON.stringify({ "cmd": "addProperty", "name": $.trim($("#nameInput").val()), "compare": Compare, "necessary": necessary, "classid": CID }),
            dataType: 'json',
            success: function (data) {

                if (data.status == "success") {
                    $.messager.alert('提示', '成功！');
                    $.messager.progress('close');
                    window.location.href = "ClassManage.aspx?ClassID=" + CID;
                } else {
                    $.messager.progress('close');
                    $.messager.show({
                        title: '提示',
                        msg: data.msg,
                        timeout: 3000,
                        showType: 'fade'
                    });
                }
            },
            error: function (xhr, s, e) {
                $.messager.progress('close');
                $.messager.alert('数据加载错误', e);
            }
        });
    }

    function ckxClick() { //checkbox点击
        var $ck = $(this);
        var info = "确定设为 [非必要] 属性吗？";
        var necessary = 0;
        if ($(this).is(":checked")) {
            info = "确定设为 [必要] 属性吗？" ;
            necessary = 1;
        }
        $.messager.confirm('属性改变提醒', info, function (r) {
            if (r) {
                $.messager.progress({ title: '提示', msg: '正在处理，请稍候!' });
                $.ajax(
                {
                    url: 'AJAX/Handler.ashx',
                    type: "POST",
                    data: JSON.stringify({ "cmd": "ChangePropertyNecessary", "necessary": necessary, "propertyid": $($ck).data("PropertyID") }),
                    dataType: 'json',
                    success: function (data) {

                        if (data.status == "success") {
                            $.messager.alert('提示', '成功！');
                            $.messager.progress('close');

                        } else {
                            $.messager.progress('close');
                            $ck[0].checked = !$ck[0].checked;
                            $.messager.show({
                                title: '提示',
                                msg: data.msg,
                                timeout: 3000,
                                showType: 'fade'
                            });
                        }

                        // window.location.href = "ClassManage.aspx?ClassID=" + CID; //不管成功与否都要重新加载，为了保证数据一致性。
                    },
                    error: function (xhr, s, e) {
                        $.messager.progress('close');
                        $.messager.alert('数据加载错误', e);
                        //window.location.href = "ClassManage.aspx?ClassID=" + CID;
                        $ck[0].checked = !$ck[0].checked;
                    }
                });
            } else {
                $ck[0].checked = !$ck[0].checked;
                //checkbox 反转，因为用户选择不改变.
            }
        });
    }

    function pckxClick() { //checkbox点击
        var $ck = $(this);
        var info = "确定设为 [非匹配] 属性吗？";
        var compare = 1;
        if ($(this).is(":checked")) {
            info = "确定设为 [匹配] 属性吗？";
            compare = 0;
        }
        $.messager.confirm('属性改变提醒', info, function(r) {
            if (r) {
                $.messager.progress({ title: '提示', msg: '正在处理，请稍候!' });
                $.ajax(
                {
                    url: 'AJAX/Handler.ashx',
                    type: "POST",
                    data: JSON.stringify({ "cmd": "ChangePropertyCompare", "compare": compare, "propertyid": $($ck).data("PropertyID") }),
                    dataType: 'json',
                    success: function(data) {

                        if (data.status == "success") {
                            $.messager.alert('提示', '成功！');
                            $.messager.progress('close');

                        } else {
                            $.messager.progress('close');
                            $ck[0].checked = !$ck[0].checked;
                            $.messager.show({
                                title: '提示',
                                msg: data.msg,
                                timeout: 3000,
                                showType: 'fade'
                            });
                        }

                        // window.location.href = "ClassManage.aspx?ClassID=" + CID; //不管成功与否都要重新加载，为了保证数据一致性。
                    },
                    error: function(xhr, s, e) {
                        $.messager.progress('close');
                        $.messager.alert('数据加载错误', e);
                        //window.location.href = "ClassManage.aspx?ClassID=" + CID;
                        $ck[0].checked = !$ck[0].checked;
                    }
                });
            } else {
                $ck[0].checked = !$ck[0].checked;
                //checkbox 反转，因为用户选择不改变.
            }
        });
    }

    function AddValue(PropertyID, ComboxID/*对应 ID*/) 
    {
        // alert(PropertyID + "->" + cmid);
        value = $("#cm" + ComboxID).combo('getText');

        if (value == "") {
            $.messager.alert("提示","请输入取值");
            return;
        }
        $.messager.progress({ title: '提示', msg: '正在处理，请稍候!' });

        $.ajax({
            url: 'AJAX/Handler.ashx',
            type: "POST",
            data: JSON.stringify({ "cmd": "addPropertyValue", "value": $("#cm" + ComboxID).combo("getText"), "PropertyID": PropertyID }),
            dataType: 'json',
            success: function (data) {
                
                if (data.status == "success") {
                    $.messager.alert('提示', '成功！');
                    $.messager.progress('close');
                    window.location.href = "ClassManage.aspx?ClassID=" + CID;
                } else {
                    $.messager.progress('close');
                    $.messager.show({
                        title: '提示',
                        msg: data.msg,
                        timeout: 3000,
                        showType: 'fade'
                    });
                }
            },
            error: function (xhr, s, e) {
                $.messager.progress('close');
                $.messager.show({
                    title: '提示',
                    msg: data.msg,
                    timeout: 3000,
                    showType: 'fade'
                });
            }
        });

    
    }

    $(function() {

        if (isPostBack) return;
        isPostBack = true;
        try {

            dat = eval("(" + '<%= JSON %>' + ")");
            // alert(dat.data);
            //document.write(dat.data);
            jsondat = dat.data;
            for (i = 0; i < jsondat.length; i++) {

                tr = '<tr><td>' + jsondat[i].valuename + '</td>';
                cmid = "cm" + jsondat[i].id; /*即combox的id*/

                ck = "";
                if (jsondat[i].necessary == 1) {
                    ck = 'checked = "true"';
                }

                tr += '<td><input name = "property" id = "ck' + jsondat[i].id + '"type="checkbox" ' + ck + '/></td>';
                cm = '<div style="float:left;margin-right:5px;"><select id = "' + cmid + '"class="easyui-combobox" name="state" style = "width:150px;" ><option value=""></option>';

                for (j = 0; j < jsondat[i].values.length; j++) {
                    cm += '<option value="' + jsondat[i].values[j] + '">' + jsondat[i].values[j] + '</option>';

                }

                if (jsondat[i].ptype == 0) {
                    ck = 'checked = "true"';
                } else { ck = ''; }

                tr += '<td>' + cm + '</select></div></td>' + '<td><input name = "property" id = "pck' + jsondat[i].id + '"type="checkbox" ' + ck + '/></td>' + '<td><a id="add' + cmid + '"  class="easyui-linkbutton" data-options="iconCls:\'icon-add\'" onclick = "AddValue(' + jsondat[i].id + ',' + jsondat[i].id + ');">增加取值</a></td></tr>';
                $(".MyTable").append($(tr));
                $("#" + cmid).combobox({ editable: true });
                $("#" + cmid).combobox('setText', '');
                $("#add" + cmid).linkbutton();     /*解析 增加取值按钮*/

                $("#ck" + jsondat[i].id).data("PropertyID", jsondat[i].id); //在每行checkbox上绑定数据 PropertyID
                $("#ck" + jsondat[i].id).change(ckxClick);

                $("#pck" + jsondat[i].id).data("PropertyID", jsondat[i].id); //在每行checkbox上绑定数据 PropertyID
                $("#pck" + jsondat[i].id).change(pckxClick);
            }

        } catch (e) {
            $.messager.alert('提示', '发生错误,请联系李光耀!');
        }

        lastrow = '<tr><td>新属性名:</td><td><input id = "ckadd" type="checkbox" /></td><td><input id="nameInput" type= "text"/></td><td><input id = "pckadd" checked = "true" type="checkbox" /></td><td><a id="add" href="#" onclick = "AddProperty();" class="easyui-linkbutton" data-options="iconCls:\'icon-ok\'">增加属性</a></td></tr>';
        $(".MyTable").append($(lastrow));
        $("#tool").css("width", $(".MyTable").width());
        $("#add").linkbutton();
    });
    </script>
    <form id="form1" runat="server">
 <table class = "MyTable"id="table1" border="0" cellpadding="0" cellspacing="0">
          
       <tr>
                <td>
                    属性名称
                </td>
                <td>
                    必要属性
                </td>
                <td>
                    取值范围
                </td>
                <td>
                    匹配
                </td>
                 <td>
                    操作
                </td>
            </tr>
     
        </table>

        	

    


    </form>

        
    <p>


        
</body>
</html>
