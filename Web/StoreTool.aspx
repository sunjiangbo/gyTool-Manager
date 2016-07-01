<%@ Page Language="C#" AutoEventWireup="true" CodeFile="StoreTool.aspx.cs" Inherits="StoreTool" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link id="easyuiTheme" rel="stylesheet" type="text/css" href="themes/gray/easyui.css"/>
	<link rel="stylesheet" type="text/css" href="themes/icon.css"/>
	<link rel="stylesheet" type="text/css" href="demo/demo.css"/>
	<script type="text/javascript" src="jquery.min.js"></script>
	<script type="text/javascript" src="jquery.easyui.min.js"></script>
    <link href="Css/MyCSS.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="JS/MyJS.js"></script>
    
</head>

 <body id = "cc" class="easyui-layout">
 <script type="text/javascript">
     Date.prototype.pattern = function (fmt) {
         var o = {
             "M+": this.getMonth() + 1, //月份         
             "d+": this.getDate(), //日         
             "h+": this.getHours() % 12 == 0 ? 12 : this.getHours() % 12, //小时         
             "H+": this.getHours(), //小时         
             "m+": this.getMinutes(), //分         
             "s+": this.getSeconds(), //秒         
             "q+": Math.floor((this.getMonth() + 3) / 3), //季度         
             "S": this.getMilliseconds() //毫秒         
         };
         var week = {
             "0": "/u65e5",
             "1": "/u4e00",
             "2": "/u4e8c",
             "3": "/u4e09",
             "4": "/u56db",
             "5": "/u4e94",
             "6": "/u516d"
         };
         if (/(y+)/.test(fmt)) {
             fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
         }
         if (/(E+)/.test(fmt)) {
             fmt = fmt.replace(RegExp.$1, ((RegExp.$1.length > 1) ? (RegExp.$1.length > 2 ? "/u661f/u671f" : "/u5468") : "") + week[this.getDay() + ""]);
         }
         for (var k in o) {
             if (new RegExp("(" + k + ")").test(fmt)) {
                 fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
             }
         }
         return fmt;
     }    
     function ClassChange(record)
     {
         $("#tgFrm").attr("src", "ToolBag.aspx?Type=0&BagID=" + record.id);  
     }
     function StoreToolBag() {

         var num = 1;


         if ($("#drClass").combobox("getValue") == "") {
             $.messager.show({
                 title: '提示',
                 msg: '请选择工具包模型!'
             });
             return;
         }
         
         if ($("#Count").val() == "") {
             $.messager.show({
                 title: '提示',
                 msg: '请输入入库数量。'
             });
             return;
         }
         if ($("#KeyPerson").val() == "") {
             $.messager.show({
                 title: '提示',
                 msg: '请输入打号负责人。'
             });
             return;
         }
         num = $("#Count").val();
         var date = new Date();
         var mTask;
               json = {};
               json.cmd = "StoreToolBag";
               json.hitnum = num;
               json.type = 1;
               json.classid = $("#drClass").combobox("getValue");
               //json.toolname = $("#t_ToolName").val();可选工具名
               json.taskid = "rkBH-" + date.pattern("yyyyMMddhhmmss");
               mTask = json.taskid;
               json.coreperson = $("#KeyPerson").val();
               json.taskname = "入库打流水号-" + $("#t_ToolName").val() + "x" + $("#Count").val();
         
         $.messager.progress({ title: '提示', msg: '操作执行中……' });
         $.ajax({
             url: 'AJAX/Handler.ashx',
             type: "POST",
             data: JSON.stringify(json),
             dataType: 'json',
             success: function(data) {
                 $.messager.progress('close');
                 if (data.status == "ok") {
                     $.messager.alert({
                         title: '提示',
                         msg: data.msg
                     });
                     location.href = "HitTask.aspx?TaskID=" + mTask;

                 } else {
                     $.messager.show({
                         title: '提示',
                         msg: data.msg,
                         timeout: 3000,
                         showType: 'fade'
                     });
                 }
             },
             error: function(xhr, s, e) {
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
     
         $.messager.progress({ title: '提示', msg: '数据加载中……' });
         $.ajax({
             url: 'AJAX/Handler.ashx',
             type: "POST",
             data: JSON.stringify({ "cmd": "GetToolBagList" }),
             dataType: 'json',
             success: function(data) {
                 $.messager.progress('close');
                 if (data.status == "success") {
                     $("#drClass").combobox({ editable: false, data: data.data, valueField: "id", textField: "name", onSelect: function(record) { record.isInit = false; ClassChange(record); } });
                     if (Type == 3 || Type == 4) {
                         record = {};
                         record.id = ClassID;
                         record.type = Type;
                         record.toolid = ToolID;
                         record.isInit = true;
                         $("#drClass").combobox('setValue', ClassID);
                         ClassChange(record);
                     }
                 } else {
                     $.messager.show({
                         title: '提示',
                         msg: data.msg,
                         timeout: 3000,
                         showType: 'fade'
                     });
                 }
             },
             error: function(xhr, s, e) {
                 $.messager.progress('close');
                 $.messager.show({
                     title: '提示',
                     msg: data.msg,
                     timeout: 3000,
                     showType: 'fade'
                 });
             }
         });
        

     });
 </script>
    <form id="form1" runat="server">
      <div id= "MContent" title = "入库" region="center">
           <div id="tt" class="easyui-tabs" style="width:99%;"  data-options="border:false,fit:true">
    <div title="独立工具入库" style="padding:10px;">
        <iframe  frameborder="no" border="0" style="width:100%;height:100%;" src="ToolContentManage.aspx?Type=5"></iframe>
    </div>
    <!--
    <div title="工具包入库" data-options="border:false" style="overflow:auto;padding:20px;">
        
         <table class = "MyTable"id="table1" border="0" cellpadding="0" cellspacing="0">
         <tr>
             <td>工具包模板</td>
             <td  style="text-align:left;"><select id ="drClass" class="easyui-combobox" style = "width:150px; " id ="Select1" ></select></td>
             <td >数量</td>
             <td><input id = "Count" type="text" value ="1"/></td>
             <td >打号负责人</td>
             <td><input id = "KeyPerson"  style = " text-align:center; font-weight:bolder;"type="text" value =""/></td>
              <td> <a id="opBtn" class="easyui-linkbutton" onclick = "StoreToolBag();">入库</a></td>
         </tr>
         </table>
         <div style="width:100%;height:1200px;">
            <iframe  id = "tgFrm" frameborder="no" border="0" style="width:100%;height:100%;" src=""></iframe>
         </div>
     </div>
    -->
   
            </div>
                
      </div>
      
    </form>
</body>
</html>
