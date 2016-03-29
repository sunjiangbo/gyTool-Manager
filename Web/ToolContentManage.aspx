<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ToolContentManage.aspx.cs" Inherits="ClassManage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
      <link id="easyuiTheme" rel="stylesheet" type="text/css" href="themes/gray/easyui.css"/>
	<link rel="stylesheet" type="text/css" href="themes/icon.css"/>
	<link rel="stylesheet" type="text/css" href="demo/demo.css"/>
	<script type="text/javascript" src="jquery.min.js"></script>
	<script type="text/javascript" src="jquery.easyui.min.js"></script>
    <script type="text/javascript" src="JS/MyJS.js"></script>
    <link href="Css/MyCSS.css" rel="stylesheet" type="text/css" />
</head>
<body>
<script>
    var Type = '<%= Type %>';
    /* 任务类型  1:添加工具包 
                2:添加包内工具 
                3:修改工具箱模型 
                4:修改包内工具模型
                5:独立工具入库
    */
    var BagID = '<%= BagID %>';
    var BagName = '<%= BagName %>';
    var ToolID = '<%= ToolID %>';//要修改的工具ID
    var ClassID = '<%= ClassID %>';
    var ToolName = '<%= ToolName %>';
    var BtnName = '保存'; //按钮名称，根据任务类型调整
    var CurClassID = 0; //当前被选中类的ID
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
   /* function MyAjax(data) {
        $.messager.progress({ title: '提示', msg: '正在卖力执行中…………' });
        $.ajax({
            url: 'AJAX/Handler.ashx',
            type: "POST",
            data: JSON.stringify(data),
            dataType: 'json',
            success: function (data) {
                $.messager.progress('close');
                if (data.status == "success") {
                    $.messager.alert('提示', '操作成功！');
                } else {
                    $.messager.alert('操作失败！', data.msg);
                }


            },
            error: function (xhr, s, e) {
                $.messager.progress('close');
                $.messager.alert('操作失败！', data.msg);
            }
        });
    }*/
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
    
    function BtnClick() {

        var cks = $(".MyTable .tmp input[id^=ck]:checked");
        if (cks.length == 0) {
            $.messager.alert('提示', '没有选择任何属性!!');
            return;
        }
        var date = new Date();
            var t = "";
            var PropertyID = "";
            var ClassID = $("#drClass").combobox('getValue');

            if (ClassID == "") {
                $.messager.alert('提示', '请选择模板类!');
                return;
            }

            if ($("#t_ToolName").val() == "") {
                $.messager.alert('提示', '请输入工具名!');
                return;
            }
            
            for (i = 0; i < cks.length; i++) {
                    PropertyID = $(cks[i]).data('PropertyID');
                    if ($.trim($("#sp" + PropertyID + "cm").combo('getText')) == "") {
                        $.messager.alert('提示','请选为所有您选取属性选择取值！');
                        return;
                    }
            }

           if (Type != 1){
                    if ($("#Count").val() == "") {
                        $.messager.alert('提示', '请填写工具数量！');
                        return;
                    }
                }
                if (Type == 5) {
                    if ($.trim($("#KeyPerson").val()) == "") {
                        $.messager.alert("提示", "请输入打号负责人!");
                        return;
                    }
                }
            ///确定所有被选取属性已经被取值
           if (Type == "") {
               $.messager.alert('提示', '任务类型不完整，请重新打开本页面!');
               return;
           } else if (Type == 1) {//添加工具箱
               var value = [];
               var tv;
               json = {};
               json.cmd = "addToolBag";
               json.type = Type;
               json.classid = ClassID;
               json.toolname = $("#t_ToolName").val();
               json.num = 1;
               for (i = 0; i < cks.length; i++) {
                   tv = new Object();
                   PropertyID = $(cks[i]).data('PropertyID');
                   tv.propertyid = PropertyID;
                   tv.value = $.trim($("#sp" + PropertyID + "cm").combo('getText'));
                   value[i] = tv;
               }
               json.values = value;
               MyAjax(json, function(data) { $.messager.alert('提示', data.msg); });
               record = new Object();
               record.name = "load";
               record.isInit = false;
               record.id = $("#drClass").combobox('getValue');
               ClassChange(record);
           } else if (Type == 2) {
               var value = [];
               var tv;
               json = {};
               json.cmd = "addToolToBag";
               json.parentbagid = BagID;
               json.num = $("#Count").val();
               json.type = Type;
               json.classid = ClassID;
               json.toolname = $("#t_ToolName").val();
               for (i = 0; i < cks.length; i++) {
                   tv = new Object();
                   PropertyID = $(cks[i]).data('PropertyID');
                   tv.propertyid = PropertyID;
                   tv.value = $.trim($("#sp" + PropertyID + "cm").combo('getText'));
                   value[i] = tv;
               }
               json.values = value;
               MyAjax(json, function(data) { $.messager.alert('提示', data.msg);  });
               record = new Object();
               record.name = "load";
               record.isInit = false;
               record.id = $("#drClass").combobox('getValue');
               ClassChange(record);

           } else if (Type == 3 || Type == 4) /*3:修改工具箱模型 4:修改包内工具模型*/
           {
               var value = [];
               var tv;
               json = {};
               json.cmd = "ModifyBagOrTool";
               json.parentbagid = BagID;
               json.num = $("#Count").val();
               json.type = Type;
               json.classid = ClassID;
               json.toolid = ToolID;
               json.toolname = $("#t_ToolName").val();
               for (i = 0; i < cks.length; i++) {
                   tv = new Object();
                   PropertyID = $(cks[i]).data('PropertyID');
                   tv.propertyid = PropertyID;
                   tv.value = $.trim($("#sp" + PropertyID + "cm").combo('getText'));
                   value[i] = tv;
               }
               json.values = value;
               MyAjax(json, function(data) { $.messager.alert('提示', data.msg); });
               record = new Object();
               record.name = "load";
               record.id = $("#drClass").combobox('getValue');
               record.isInit = false;
               ClassChange(record);
           } else if (Type == 5) {
               var value = [];
               var tv;
               var mTaskID ;
               json = {};
               json.cmd = "StoreTool";
               json.hitnum = $("#Count").val();
               json.type = Type;
               json.classid = ClassID;
               json.toolname = $("#t_ToolName").val();
               json.taskid = "rkBH-" + date.pattern("yyyyMMddhhmmss");
               mTaskID = json.taskid ;
               json.coreperson = $("#KeyPerson").val();
               json.taskname = "入库打流水号-" + $("#t_ToolName").val() + "x" + $("#Count").val();
               for (i = 0; i < cks.length; i++) {
                   tv = new Object();
                   PropertyID = $(cks[i]).data('PropertyID');
                   if($("#pck" + PropertyID).is(":checked")){
                       tv.compare = 1;                       
                   }else{
                       tv.compare = 0;
                      // tCount--;
                   }
                   tv.propertyid = PropertyID;
                   tv.value = $.trim($("#sp" + PropertyID + "cm").combo('getText'));
                   value[i] = tv;
               }
               json.valuecount = cks.length;
               json.values = value;
               MyAjax(json, function(data) { if (data.status == "success") { $.messager.alert('提示', data.msg); location.href = "HitTask.aspx?TaskID=" + mTaskID; } });
               record = new Object();
               record.name = "load";
               record.id = $("#drClass").combobox('getValue');
               record.isInit = false;
               ClassChange(record);
           }
    
    }
    function ckClick(obj) {
        var $ck = $(obj)
        if ($ck.is(":checked")) {
            $("#sp" + $ck.data("PropertyID") + "cm").combo({required:true,disabled: false });
        } else {
            $("#sp" + $ck.data("PropertyID") + "cm").combo({ required: false, disabled: true });
        }
    }
    function ipClick(obj) {

        var v = $(obj).val();
        var s = $(obj).next('span').text();
        var id = "#" + $(obj).parent().parent("div[id^='sp']").attr("id") + "cm";

        $(id).combo('setValue', v);
        $(id).combo('setText', s)
        $(id).combo('hidePanel');
    }
    function AddProperty() {
        var necessary = 0, Compare = 1;

        if ($.trim($("#NewAttr").val()) == "") {
            $.messager.alert('提示', '请输入属性名哦！');
            return;
        }
               
        $.messager.progress({ title: '提示', msg: '正在处理，请稍候……' });
        $.ajax({
            url: 'AJAX/Handler.ashx',
            type: "POST",
            data: JSON.stringify({ "cmd": "addProperty", "name": $.trim($("#NewAttr").val()), "compare": Compare, "necessary": necessary, "classid": CurClassID }),
            dataType: 'json',
            success: function (data) {

                if (data.status == "success") {
                    $("tr[name=LastRow]").before('<tr class = "tmp" ><td><input name = "property" id = "ck' + data.propertyid + '"type="checkbox" checked ="true" onclick = "ckClick(this);"/></td><td>' + $("#NewAttr").val() + '</td><td><input name = "property" disabled = "true" type="checkbox"  /></td><td><select id = "sp' + data.propertyid + 'cm" class="easyui-combobox" name="state" style = "width:150px;" ><option value=""></option></select></td></tr>');
                    $("#ck" + data.propertyid).data("PropertyID", data.propertyid); //在每行checkbox上绑定数据 PropertyID  
                    $('#sp' + data.propertyid + 'cm').combobox({ required: true, editable: true });
                    $("#NewAttr").val("");
                    $.messager.progress('close');
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
    function ClassChange(record) {//列出该工具模型下的所有属性
        if (record.name == "") return;

        if (record.isInit == false && record.name != 'load') {//首次加载，无需置空t_ToolName
            
            if (Type != 1) {//Type=1说明是添加工具包模型，不能修改其名称。
                $("#t_ToolName").val($.trim(record.name)); 

            }
        }
        CurClassID = record.id;
        $.messager.progress({ title: '提示', msg: '数据加载中……' });
        $.ajax({
            url: 'AJAX/Handler.ashx',
            type: "POST",
            data: JSON.stringify({ "cmd": "getClassAndProperty", "classid": record.id, 'type': Type, 'toolid': ToolID }),
            dataType: 'json',
            success: function (data) {
                var subs = '4">';
                if (data.status == "success") {

                    $(".MyTable .tmp").remove();

                    $.messager.progress('close');
                    jsondat = data.data;
                    for (i = 0; i < jsondat.length; i++) {
                        ck = "";
                        if (jsondat[i].selected == 1 || jsondat[i].necessary == 1) {
                            ck = 'checked = "true" ';
                        }
                        if (jsondat[i].necessary == 1) {
                            ck += ' disabled ="true" ';
                        }

                        tr = '<tr class = "tmp">' + '<td><input name = "property" id = "ck' + jsondat[i].id + '"type="checkbox" ' + ck + 'onclick = "ckClick(this);"/></td>';
                        cmid = "sp" + jsondat[i].id + "cm"; /*即combox的id*/
                        tr += '<td>' + jsondat[i].valuename + '</td>'; /*属性名*/
                        /*属性取值*/
                        //cm = '<select id = "' + cmid + '"class="easyui-combobox" name="state" style = "width:150px;" ></select><div  id="sp' + jsondat[i].id + '"><div style="color:#99BBE8;background:#fafafa;padding:5px;">请选择</div><div style="padding:10px">';
                        cm = '<select id = "' + cmid + '"class="easyui-combobox" name="state" style = "width:150px;" ><option value=""></option>';

                        /*for (j = 0; j < jsondat[i].values.length; j++) {
                        cm += '<input name = "lang" class = "sp" id = "ip' + jsondat[i].values[j].vid + '" type="radio" value="' + jsondat[i].values[j].vid + '"/><span>' + jsondat[i].values[j].value + '</span><br/>';
                        }*/

                        for (j = 0; j < jsondat[i].values.length; j++) {
                            cm += '<option value="' + jsondat[i].values[j].vid + '">' + jsondat[i].values[j].value + '</option>';

                        }
                        cm += '</select>';
                        pck = ' disabled ="true" ';
                        if (jsondat[i].compare == 0) {
                            pck += ' disabled ="true" checked="true"';
                        }

                        tr += '<td><input name = "property" id = "pck' + jsondat[i].id + '"type="checkbox" ' + pck + '/></td>' + '<td colspan="2">' + cm + '</td></tr>';

                        $(".MyTable").append($(tr));

                        var Sel = jsondat[i].necessary == 1 || jsondat[i].selected == 1 ? true : false;

                        $("#" + cmid).combo({ editable: false, required: Sel, disabled: !Sel });
                        $("#" + cmid).combobox({ required: true, editable: true });
                        if (jsondat[i].curvalue != '') { $("#" + cmid).combobox('setText', jsondat[i].curvalue); }
                        //$('#sp' + jsondat[i].id).appendTo($("#" + cmid).combo('panel'));


                        $('div[id="sp' + jsondat[i].id + '"] input').bind("click", function () {
                            var $obj = $(this);
                            ipClick($obj);
                        });

                        $("#ck" + jsondat[i].id).data("PropertyID", jsondat[i].id); //在每行checkbox上绑定数据 PropertyID                    }
                    }

                    /// if (Type == 5) //如果是独立工具入库
                    {
                        $(".MyTable").append('<tr class ="tmp" name ="LastRow"> ><td>属性名</td><td><input id = "NewAttr"/></td><td>操作</td><td><a id="AddAttrBtn"  class="easyui-linkbutton" data-options="iconCls:\'icon-add\'" onclick = "AddProperty();">添加属性</a></td></tr>');
                        $("#AddAttrBtn").linkbutton();
                    }
                    if (Type == 5) { subs = '1"><span>打号负责人</span></td><td><input ID="KeyPerson" style="text-align:center; font-weight:bolder;"></input></td><td>操作</td><td colspan="1">'; }
                    $(".MyTable").append('<tr class = "tmp"  ><td colspan="'+subs+'<a id="opBtn" href="#" class="easyui-linkbutton" data-options="iconCls:\'icon-add\'" onclick = "BtnClick();">' + BtnName + '</a></td></tr>');
                    $("#opBtn").linkbutton();     /*解析 增加取值按钮*/



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
                    msg: e.toString(),
                    timeout: 3000,
                    showType: 'fade'
                });
            }
        });

    }



    $(function() {

        if (Type == 2 || Type == 4 || Type == 3)//添加工具包内工具 或 修改包及包内工具
        {
            if (
                ((Type == 4 || Type == 2) && (BagID == "" || BagName == ""))
                || ((Type == 3 || Type == 4) && (ToolID == "" || ClassID == "" || ToolName == ""))
                ) {
                $.messager.alert('提示', '参数不全，无父包ID和父包名称!');
                document.write('参数不全，无父包ID和父包名称!');
                return;
            }

            $("#pBagName").text(BagName);
            $("#t_ToolName").attr("value", ToolName);
        } else if (Type == 1) {
            $(".tjzgj").hide();
            $("#Count").attr("disabled", "true");
            $("#t_ToolName").attr("disabled", "true");
            $("#t_ToolName").val(BagName.toString());
            $("#Count").val("不适用。");
        } else if (Type == 5)//独立工具入库
        {
            $(".tjzgj").hide();
            $("#t_ToolName").attr("disabled", "true");
            BtnName = '打流水号';
        }
        else {
            $.messager.alert('提示', '参数不全，无类型!');
            document.write('参数不全，无类型!');
            return;
        }
        $.messager.progress({ title: '提示', msg: '数据加载中……' });
        $.ajax({
            url: 'AJAX/Handler.ashx',
            type: "POST",
            data: JSON.stringify({ "cmd": "GetClassList" }),
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
 <table class = "MyTable"id="table1" border="0" cellpadding="0" cellspacing="0">
         <tr class="tjzgj"><!--父工具包行-->
            <td>工具包</td>
            <td colspan="3" style="text-align:center; color:red;"><span id="pBagName"></span></td>
            
         </tr>
         <tr>
            <td>模板类</td>
            <td colspan="3" style="text-align:left;"><select style = "width:150px; " id ="drClass" ></select></td>
            
         </tr>
         <tr>
             <td>名称</td>
             <td><input id = "t_ToolName" type="text" /></td>
             <td >数量</td>
             <td><input id = "Count" type="text" value ="1"/></td>
         </tr>
       <tr>
                <td>
                    选取
                </td>
                
                <td>
                    属性名
                </td>
                <td>
                    匹配
                </td>
                <td colspan="2">
                    取值
                </td>
               
            </tr>
     
        </table>
 </form>
</body>
</html>
