<%@ Page Language="C#" AutoEventWireup="true" CodeFile="HitTool.aspx.cs" Inherits="HitTool" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link id="easyuiTheme" rel="stylesheet" type="text/css" href="themes/gray/easyui.css"/>
	<link rel="stylesheet" type="text/css" href="themes/icon.css"/>
	<link rel="stylesheet" type="text/css" href="demo/demo.css"/>
	<script type="text/javascript" src="jquery.min.js"></script>
	<script type="text/javascript" src="jquery.easyui.min.js"></script>
    <link href="Css/MyCSS.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="JS/MyJS.js"></script>
</head>
<script>
    var BagID = '<%= BagID %>';
    function MyAjax(jsondat, SuccessFun, ErrorFun) {
        $.messager.progress({ title: '提示', msg: '正在处理，请稍候!' });
        $.ajax(
                    {
                        url: 'AJAX/Handler.ashx',
                        type: "POST",
                        data: JSON.stringify(jsondat),
                        dataType: 'json',
                        success: function(data) {
                            SuccessFun(data);
                            $.messager.progress('close');
                        },
                        error: function(xhr, s, e) {
                            if (ErrorFun == undefined || ErrorFun == null) {
                                ErrorFun(xhr, s, e);
                            } else {
                                $.messager.progress('close');
                                $.messager.alert('数据加载错误', e);
                            }
                        }
                    });
    }
    function HitTool() {
        if ($("#HitNum").val() == ""   ) {
            $.messager.alert('提示', '请输入小于库存的数字!');
            return;
        }
        if (isNaN($("#HitNum").val()) || $("#HitNum").val() <=0) {
            $.messager.alert('提示', '请输入大于0小于库存的数字!');
            return;
        }
        if ($("#HitNum").val() > $("#iNum").text()) {
            $.messager.alert('提示', '请输入小于库存的数字!');
            return;
        }
        if ($("#People").val()=="") {
            $.messager.alert('提示', '请输入打号任务责任人!');
            return;
        }

        json = {};
        json.cmd = "HitTool";
        json.bagid = BagID;
        json.hitnum = $("#HitNum").val();
        json.coreperson = $("#People").val();
        json.taskid = $("#TaskID").text();
        json.taskname = $("#iName").text() + " X " + $("#HitNum").val() + " - 打号";
        MyAjax(json, function(jsondat) {
            if (jsondat.status = "success") {
                $.messager.alert('提示', '编号成功!!');
                window.location.href = "HitTask.aspx?TaskID=" + $("#TaskID").text();
            } else {
                $.messager.alert('失败', jsondat.msg);
            }
        });
        
    }
         
Date.prototype.pattern=function(fmt) {         
    var o = {         
    "M+" : this.getMonth()+1, //月份         
    "d+" : this.getDate(), //日         
    "h+" : this.getHours()%12 == 0 ? 12 : this.getHours()%12, //小时         
    "H+" : this.getHours(), //小时         
    "m+" : this.getMinutes(), //分         
    "s+" : this.getSeconds(), //秒         
    "q+" : Math.floor((this.getMonth()+3)/3), //季度         
    "S" : this.getMilliseconds() //毫秒         
    };         
    var week = {         
    "0" : "/u65e5",         
    "1" : "/u4e00",         
    "2" : "/u4e8c",         
    "3" : "/u4e09",         
    "4" : "/u56db",         
    "5" : "/u4e94",         
    "6" : "/u516d"        
    };         
    if(/(y+)/.test(fmt)){         
        fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));         
    }         
    if(/(E+)/.test(fmt)){         
        fmt=fmt.replace(RegExp.$1, ((RegExp.$1.length>1) ? (RegExp.$1.length>2 ? "/u661f/u671f" : "/u5468") : "")+week[this.getDay()+""]);         
    }         
    for(var k in o){         
        if(new RegExp("("+ k +")").test(fmt)){         
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));         
        }         
    }         
    return fmt;         
}       
     
$(function() {

$.messager.progress({ title: '提示', msg: '数据加载中……' });
    var date = new Date();
    $("#TaskID").text("BH-" + date.pattern("yyyyMMddhhmmss"));
    $("#ifm").attr("src", "ToolBag.aspx?Type=1&BagID=" + BagID);
    json = {};
    json.cmd = "GetStoreBagInfo";
    json.bagid = BagID;
    MyAjax(json, function(data) {
        if (data.status != "success") { $.messager.alert('AJAX', 'AJAX请求错误!'); return; }
        $("#iName").text(data.data.name);
        $("#iNum").text(data.data.num);
    });
});
</script>
 <body id = "cc" class="easyui-layout">
    <form id="form1" runat="server">
   <div id= "MContent" title = "入编" region="center">
    <div id="tt" class="easyui-tabs" style="width:99%;"  data-options="border:false,fit:true">
    <div title="工具包入编" style="padding:10px;">
        <table class = "MyTable"id="table1" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                任务编号
                </td>                
                <td colspan="3"><span style = "color:Red;" id = "TaskID"></span></td>
            </tr>
            <tr>
                <td>名称</td>
                <td><span style = "color:black;" id = "iName"></span></td>
                <td>当前库存</td>
                <td><span style = "color:Red;" id = "iNum"></span></td>
                
            </tr>
            <tr>
                <td>预编数量</td>
                <td><input style=" text-align:center; font-weight:bold;" id= "HitNum"/></td>
                 <td>责任人</td>
                <td><input  style=" text-align:center; font-weight:bold;" id= "People"/></td>
            </tr>
            <tr>
                <td colspan ="4"><a href = "#"  id = "Btn" class ="easyui-linkbutton" onclick = "HitTool();">开始编号</a></td>
            </tr>
        </table>
                <iframe  id =  "ifm" frameborder="no" border="0" style="width:100%;height:1200px;" ></iframe>
      </div>
      </div>
      </div>
    </form>
</body>
</html>
