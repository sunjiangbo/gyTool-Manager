﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Query.aspx.cs" Inherits="Query" %>

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
    <title></title>
    <style>
        .myfwSpan
        {
            min-width:50px;
            max-width:100px;
            width:auto;
            padding:2px;
            color:Green;
            border:solid 1px #a8a6a6;
            background:white;
            font-weight:bolder;
        }
        .myfwSpan:hover
        {
           
            border:solid 2px red;
            cursor:pointer;

        }
        .mytlSpan
        {
            min-width:50px;
            max-width:100px;
            color:blue;
            font-weight:bold;
            width:auto;
            padding:2px;
            border:solid 1px #a8a6a6;
            background:white;
        }
        .mytlSpan:hover
        {
            border:solid 2px red;
            cursor:pointer;
        }
        .mylbSpan
        {
            min-width:50px;
            max-width:100px;
            width:auto;
            padding:2px;
            margin-left:2px;
            border:solid 1px #a8a6a6;
            background:white;
        }
        .mylbSpan:hover
        {
            border:solid 2px red;
            cursor:pointer;
        }
        .myImg
        {
            margin-left:4px; 
            width:9px;
            height:9px;
        }
        .topDivStyle
        {
            float:left;
            white-space:nowrap;
        }
        .btnbartitle
        {
           /* border-top: #ccc 1px solid;
            border-left: #ccc 1px solid;
            border-right: #ccc 1px solid;
            background-image: url('img/datagrid_header_bg.gif');
            background-repeat: repeat-x repeat-y;*/
             /*background-color: #f3f3f3;
              background: -webkit-linear-gradient(top,#F8F8F8 0,#eeeeee 100%);
              background: -moz-linear-gradient(top,#F8F8F8 0,#eeeeee 100%);
              background: -o-linear-gradient(top,#F8F8F8 0,#eeeeee 100%);
              background: linear-gradient(to bottom,#F8F8F8 0,#eeeeee 100%);
              background-repeat: repeat-x repeat-y;
              filter: progid:DXImageTransform.Microsoft.gradient(startColorstr=#F8F8F8,endColorstr=#eeeeee,GradientType=0); 
          */
        }
        .pDivFliter
        {
           float:left;
           white-space:nowrap;
           margin-top:5px;
           margin-bottom:7px;
           margin-right:5px;
           margin-left:2px;
        }
        .myCell:hover
        {
            cursor:pointer;
            font-weight:bold;
            text-decoration:underline;
        }
        .myCell
        {
        }
    </style>
    
    <script type="text/javascript">
        var Filter = { range: -1, name: "所有", ret: "all", specific: [] };
        var IsInitial = true; /*表明修改搜索条件*/
        var TaskID = '<%= TaskID %>';

        Date.prototype.pattern = function(fmt) {
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
     
        function PropertyChange(record) {
            if (record.id == -1) {
                $("#ValueList").combobox('loadData', []);
                $("#ValueList").combobox('clear');
                return; //-1代表所有
            }
            var json = {};
            json.cmd = "GetValuesByPropertyID";
            json.propertyid = record.id;
            MyAjax(json, function(data) {
                if (data.status == "success") {
                    data.data.push({ "name": "所有", "id": "-1" });
                    $("#ValueList").combobox('clear');
                    $("#ValueList").combobox({ editable: false, data: data.data, valueField: "id", textField: "name" });
                    $("#ValueList").combobox('setValue', '-1');

                } else {
                    $.messager.alert('错误', '属性取值范围加载失败！');
                }
            }, null);

        }

        function ToolClassChange(record) {

            $("#PropertyList").combobox('loadData', []);
            $("#PropertyList").combobox('clear');
            $("#ValueList").combobox('loadData', []);
            $("#ValueList").combobox('clear');

            var json = {};
            json.cmd = "GetPropertysByClassID";
            json.classid = record.id;
            MyAjax(json, function(data) {
                if (data.status == "success") {
                    data.data.push({ "name": "所有", "id": "-1" });
                    $("#PropertyList").combobox('clear');
                    $("#PropertyList").combobox({ editable: false, data: data.data, valueField: "id", textField: "name", onSelect: function(record) { record.isInit = false; PropertyChange(record); } });
                    $("#PropertyList").combobox('setValue', '-1');

                } else {
                    $.messager.alert('错误', '属性列表加载失败！');
                }
            }, null);

        }

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
        function ToolBagClassChange(record) {
            if ($("#ToolBagList").combobox('getValue') != '-1') {
                $("#Radio2").attr("checked", "true");
                Filter.ret = "bag";
            } else {
                $("#Radio1").attr("checked", "true");
                Filter.ret = "all";
            }
        }
        $(function() {

            var json = {};
            json.cmd = "GetToolBagList";

            MyAjax(json, function(data) {
                if (data.status == "success") {
                    data.data.push({ "name": "所有", "id": "-1" });
                    $("#ToolBagList").combobox({ editable: false, data: data.data, valueField: "id", textField: "name", onSelect: function(record) { record.isInit = false; ToolBagClassChange(record); } });
                    $("#ToolBagList").combobox('setValue', '-1');

                } else {
                    $.messager.alert('错误', '工具包列表加载失败！');
                }
            }, null);

            json.cmd = "GetClassList";

            MyAjax(json, function(data) {
                if (data.status == "success") {
                    data.data.push({ "name": "所有", "id": "-1" });
                    $("#ToolList").combobox({ editable: false, data: data.data, valueField: "id", textField: "name", onSelect: function(record) { record.isInit = false; ToolClassChange(record); } });
                    $("#ToolList").combobox('setValue', '-1');
                } else {
                    $.messager.alert('错误', '工具包列表加载失败！');
                }
            }, null);




            function fixWidth(percent) {
                return document.body.clientWidth * percent; //这里你可以自己做调整
            }
            function fun() {
                alert("123");
            }

            function AddTooltip(id, type/*0 普通tooltip 1 工具包tooltip*/, dat/*属性集合[{name:'大',value:'5/8'}…………]  当type=1时为toolbag.aspx?type=1&bagid=XXX*/) {

                $('#tip' + id).tooltip({
                    position: 'right',
                    content: function() {
                        if (type == 0) {
                            sx = JSON.parse(JSON.stringify(dat));
                            var table = $('<table class = "MyTable"  border="0" cellpadding="0" cellspacing="0">');
                            var tr = $("<tr></tr>");
                            tr.appendTo(table);
                            var td = $('<td style="color:red;font-weight:bold;">属性</td><td  style="color:red;font-weight:bold;">取值</td>');
                            td.appendTo(tr);
                            for (var i = 0; i < sx.length; i++) {
                                var tr = $("<tr></tr>");
                                tr.appendTo(table);
                                var td = $('<td style="color:blue;">' + sx[i].name + '</td><td>' + sx[i].value + '</td>');
                                td.appendTo(tr);
                            }
                            return table;
                        } else {
                            //return $("<iframe></iframe>").load(dat);
                            return dat;
                        }

                    }
                });

            }
            
             function JumpBorrowInfo() {
                location.href = "Tmp_HitTool.aspx?TaskID=" + TaskID + "&reBack=Query.aspx?TaskID="+TaskID;
            }
  
            $(function() {
                var date = new Date();
               
                if (TaskID==""){
                    TaskID = "BH-" + date.pattern("yyyyMMddhhmmss");}
                else{
                     json = {};
                     json.cmd = "GetTmpHitToolCountByTaskID";
                     json.taskid = TaskID;
                     MyAjax(json, function (data) {
                        if (data.status == "success") {
                            $("#brCount").text("(" + data.count + ")");
                        }
                    }, null);
                }
                $("#brCount").bind("click", function () { JumpBorrowInfo(); });
                $("#Radio1").bind("click", function() {
                    Filter.range = -1;
                    Filter.name = "所有";
                    Filter.ret = "all";
                    $("#ToolBagList").combobox("setValue", "-1");
                    ParseFilters();
                })

                $("#t1").treegrid({
                    title: '',
                    width: fixWidth(0.99),
                    height: 1200,
                    method: "get",
                    fitColumns: true,
                    idField: 'id',
                    treeField: 'name',
                    remoteSort: false,
                    rownumbers: true,
                    toolbar: '#tb',
                        onLoadSuccess: function(row, data) {
                            for (i = 0; i < data.length; i++) {
                                if (data[i].children != null && data[i].children.length != 0) {
                                    AddTooltip(data[i].id, 1, 'ToolBag.aspx?Type=1&BagID=' + data[i].id);
                                    for (j = 0; j < data[i].children.length; j++) {
                                        AddTooltip(data[i].children[j].id, 0, data[i].children[j].sx);
                                    }
                                } else {
                                    AddTooltip(data[i].id, 0, data[i].sx);
                                }
                            }

                        },
                        columns: [
                        [{ field: 'ck', checkbox: true },
                        { field: 'rkid', title: '入库编号', width: 80, sortable: true },
                        { field: 'name', title: '名称', width: 100, sortable: true, tooltip: true, formatter:
                function(val, row, index) {
                    Str = '<div style="padding:10px 200px"><p><a  href="javascript:void(0)" class="easyui-tooltip" data-options="hideEvent: \'none\',content: function(){return $("<div>' + val + '</div>");},onShow: function(){var t = $(this);t.tooltip(\'tip\').focus().unbind().bind(\'blur\',function(){tooltip(\'hide\');});}">Hover me</a> to display toolbar.</p>	</div>';

                    // return val;
                    return '<a  class = "myCell" id="tip' + row.id + '">' + val + '</a>';
                }
                        },
                { field: 'statename', title: '状态', width: 80, sortable: true },
                { field: 'storetime', title: '入库时间', width: 120, sortable: true },
            ]],
                        enableHeaderClickMenu: false,
                        enableHeaderContextMenu: false,
                        enableRowContextMenu: false
                    });
                });

            });
        function FiltersParse() {

            $("#FiltersDiv").children().remove();

            var $mFDIV = $("#FiltersDiv");
            var $fwDiv = $('<div class = "pDivFliter"> <div>');

            //范围
            $fwDiv.append($('<span class= "myfwSpan" rangeID = "' + Filter.range + '">' + Filter.name + '<img class = "myImg" src = "img/17.gif"></img></span>'));
            $mFDIV.append($fwDiv);

            var tListAr = JSON.parse(JSON.stringify(Filter.specific));

            for (i = 0; i < tListAr.length; i++) {
                var ToolClassID = tListAr[i].tid;
                var $tDiv = $('<div class = "pDivFliter"><div>');
                var $tSpan = $('<span class= "mytlSpan" TClassID = "' + ToolClassID + '">' + tListAr[i].name + '<img class = "myImg" src = "img/17.gif"></img></span>');
                var pListAr = JSON.parse(JSON.stringify(Filter.specific[i].vals));

                $tDiv.append($tSpan);
                for (j = 0; j < pListAr.length; j++) {
                    var $pSpan = $('<span class= "mylbSpan" PropretyID = "' + pListAr[j].pid + '"TClassID = "' + ToolClassID + '">' + pListAr[j].name + '：' + (pListAr[j].val == 'zkgy-1' ? '所有' : pListAr[j].val) + '<img class = "myImg" src = "img/17.gif"></img></span>');
                    $tDiv.append($pSpan);
                }
                //$tDiv = $("<div>123</div>").append($tDiv)
                $mFDIV.append($tDiv);
            }

            $(".myfwSpan .myImg").bind("click", function() {
                id = $(this).parent("span").attr("rangeID");
                if (id != -1) {
                    Filter.range = -1;
                    Filter.ret = "all";
                    Filter.name = "所有";
                    $("#Radio1").attr("checked", "true");
                    $("#ToolBagList").combobox('setValue', '-1');
                    $(this).parent().text("所有").attr("rangeID", "-1");

                } else {
                    Filter = { range: -1, name: "所有", ret: "all", specific: [] };
                    $("#FiltersDiv").children().remove();
                }

            });

            $(".mytlSpan .myImg").bind("click", function() {
                id = $(this).parent("span").attr("TClassID");

                var tListAr = JSON.parse(JSON.stringify(Filter.specific));
                var iFind;

                for (i = 0, iFind = -1; i < tListAr.length; i++) {
                    if (tListAr[i].tid == id) {
                        Filter.specific.splice(i, 1);
                        break;
                    }
                }

                FiltersParse();

            });

            $(".mylbSpan .myImg").bind("click", function() {

                tid = $(this).parent("span").attr("TClassID");

                var tListAr = JSON.parse(JSON.stringify(Filter.specific));
                var iFind = -1;

                for (i = 0, iFind = -1; i < tListAr.length; i++) {
                    if (tListAr[i].tid == tid) {
                        iFind = i;
                        break;
                    }
                }
                pid = $(this).parent("span").attr("PropretyID");
                var pListAr = JSON.parse(JSON.stringify(Filter.specific[iFind].vals));
                for (j = 0; j < pListAr.length; j++) {
                    if (pListAr[j].pid == pid) {
                        Filter.specific[iFind].vals.splice(j, 1);
                        break;
                    }
                }
                $(this).parent().remove();
            });

            $("span[class$=Span]").bind("mouseenter", function() {
                $(this).children("img").attr("src", "img/9.gif");

            });

            $("span[class$=Span]").bind("mouseleave", function() {
                $(this).children("img").attr("src", "img/17.gif");

            });

        }
        function FilterModify() {
            var ToolBagClassID = -2, ToolClassID = -1, PropertyID = -1, Value = null, ValueID = -1;
            var ToolBagClassName = '', ToolClassName = '', PropertyName = '';
            var bContinue = true;

            ToolBagClassID = $("#ToolBagList").combobox("getValue");
            ToolClassID = $("#ToolList").combobox("getValue");
            PropertyID = $("#PropertyList").combobox("getValue");
            ValueID = $("#ValueList").combobox("getValue");

            ToolBagClassName = $("#ToolBagList").combobox("getText");
            ToolClassName = $("#ToolList").combobox("getText");
            PropertyName = $("#PropertyList").combobox("getText");
            Value = $("#ValueList").combobox("getText");

            // alert("PropertyID:" + PropertyID + "  " + Value);

            if (Filter.range != ToolBagClassID) {/*搜索范围不同*/

                if (IsInitial == false) {/*首次修改，不给用户提示，提升体验。*/
                    /*$.messager.confirm('提示', '搜索范围改变，将清空之前搜索条件并重建，是否继续呢？', function(r) {
                    if (!r) { bContinue = false; }
                    });*/
                }

                if (bContinue) {
                    Filter = { range: ToolBagClassID, name: ToolBagClassName, specific: [] };
                    IsInitial = false;

                    if (ToolClassID != "-1") {//工具选项若为所有，则表示筛选到某工具包类。


                        Filter.specific.push({ tid: ToolClassID, name: ToolClassName, vals: [] });

                        if (PropertyID != "-1" && PropertyID != "") {//属性不为空  若属性为空,表示筛选到该工具类，包含所有属性和取值可能

                            if (Value != "" && Value != "所有") {//属性取值不为空
                                Filter.specific[0].vals.push({ name: PropertyName, pid: PropertyID, val: Value });
                            } else {
                                Filter.specific[0].vals.push({ name: PropertyName, pid: PropertyID, val: "zkgy-1" });
                            }

                        }
                    }

                }

            } else {   /*搜索范围和之前一致*/


                var tListAr = JSON.parse(JSON.stringify(Filter.specific));
                var iFind;

                for (i = 0, iFind = -1; i < tListAr.length; i++) {
                    if (tListAr[i].tid == ToolClassID) {
                        iFind = i;
                        break;
                    }
                }
                if (iFind == -1) {//之前没有该工具类

                    if (ToolClassID != "-1") {//工具选项若为所有，则表示筛选到某工具包类

                        var t = { tid: ToolClassID, name: ToolClassName, vals: [] };

                        if (PropertyID != "-1" && PropertyID != "") {//属性不为空  若属性为空,表示筛选到该工具类，包含所有属性和取值可能
                            t.vals.push({ name: PropertyName, pid: PropertyID, val: Value == "" || Value == "所有" ? "zkgy-1" : Value });
                        }

                        Filter.specific.push(t);
                    } else {//若ToolClassID=-1则表示搜索工具包 只需将Filter.specific置空
                        Filter.specific = [];
                    }
                } else {//找到该工具类,开始查找属性类

                    var ToolIndex = iFind; //保存specific的索引
                    if (PropertyID != "-1" && PropertyID != "") {

                        var pListAr = JSON.parse(JSON.stringify(Filter.specific[ToolIndex].vals));
                        for (i = 0, iFind = -1; i < pListAr.length; i++) {
                            if (pListAr[i].pid == PropertyID) {
                                iFind = i;
                                break;
                            }
                        }

                        if (iFind != -1) {//找到该属性，直接修改即可;
                            Filter.specific[ToolIndex].vals[iFind].val = Value == "" || Value == "所有" ? "zkgy-1" : Value;
                            // alert('找到:' + PropertyName);
                        } else {
                            // alert('没找到:' + PropertyName);
                            Filter.specific[ToolIndex].vals.push({ name: PropertyName, pid: PropertyID, val: Value == "" || Value == "所有" ? "zkgy-1" : Value });
                        }

                    } else {
                        Filter.specific[ToolIndex].vals = [];
                    }
                }

            }


            // alert(JSON.stringify(Filter));
            FiltersParse();

            /*此处清空所有搜索条件，并删除展示板*/

            //Filter = {};
            /*{ range: -1, specific: [{ tool: -1}]};*/
            //Filter.range = ToolBagClassID;

        }
        function doSearch() {
            var json = {};
            json.cmd = "StoreSearch";
            json.Filter = Filter;
            MyAjax(json, function(data) {
                $.messager.progress('close');
                if (data.status == "success") {
                    //alert(JSON.stringify(data.data));
                    $("#t1").treegrid({data:data.data});
                } else {
                    $.messager.alert('错误', '属性取值范围加载失败！');
                }
            }, null);
        }
        function AddToHit() {
            var row = $('#t1').datagrid('getSelected');
            if (row) {
                if (row.type == 'bntool') { $.messager.alert("提示", "包内工具不能单独入库!"); }
                else {
                    $.messager.progress({ title: '提示', msg: '正在处理，请稍候!' });
                    json = {};
                    json.cmd = "AddToTmpHitTool";
                    json.taskid = TaskID;
                    json.rkid = row.rkid;
                    MyAjax(json, function(data) {
                    $.messager.progress('close');
                    if (data.status == "success") {
                        json = {};
                        json.cmd = "GetTmpHitToolCountByTaskID";
                        json.taskid = TaskID;
                        MyAjax(json, function(data) {
                            if (data.status == "success") {
                                $("#brCount").text("(" + data.count + ")");
                            }
                        }, null);
                            $.messager.alert("提示", data.msg);
                        }
                    }, null);
                }
                //$('#t1').datagrid('deleteRow', index);
            } else {
                $.messager.alert("提示", "请选择要入编的工具包!");
            }
            
        }
</script>
</head>
<body id = "cc" class="easyui-layout">

    <form id="form1" runat="server">
   <div id= "MContent" title = "查询" region="center"">
    <div title="库存查询" >
       <div style="min-height:5px;height:auto;" class="btnbartitle" >
           <div style="padding:5px;">范围:&nbsp;&nbsp;<select id ="ToolBagList" class="easyui-combobox" style = "width:150px; " ></select></div>
           <div style="padding:0px 5px 5px 5px;">包含:&nbsp;&nbsp;<select id ="ToolList" class="easyui-combobox" style = "width:150px; "  ></select>&nbsp;&nbsp;<select id ="PropertyList" class="easyui-combobox" style = "width:150px; "  ></select>&nbsp;&nbsp;<select id ="ValueList" class="easyui-combobox" style = "width:150px; "  ></select>&nbsp;&nbsp; <a id="opBtn" class="easyui-linkbutton" onclick = "FilterModify();">增加</a>&nbsp;&nbsp;<a id="A1" class="easyui-linkbutton" onclick = "StoreToolBag();">清空</a>&nbsp;&nbsp;<a id="A2" class="easyui-linkbutton" onclick = "doSearch();">搜索</a></div>
           <div style="padding:0px 5px 5px 5px;">筛选:
               <input name = "rg"  id="Radio1" type="radio" checked= "checked">显示所有</input>
               <input name = "rg"  id="Radio2" type="radio" >工具包</input>
               <input name = "rg"  id="Radio3" type="radio" >工具</input>
           </div> 
       <div id = "FiltersDiv" style="">
       
        </div>
       
        </div>

      
        </div>
        <div>
            <table id="t1"></table>
        </div>
       
        
    </div>
    <div id = "tb" >
        <span style="margin-left:460px;">当前数量:</span>
        <a id = "brCount" style = "cursor:pointer;text-decoration:underline; color:Blue;font-weight:bold; margin-right:20px;margin-left:5px;">(0)</a>
        <a href="#"  class="easyui-linkbutton" iconCls="icon-add" onclick = "AddToHit();">添加</a>
    </div>
    
          
                

    </form>
</body>
</html>
