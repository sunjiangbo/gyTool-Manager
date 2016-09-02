<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ToolQuery.aspx.cs" Inherits="Query" %>

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
    var IsManager = '<%= IsManager %>';
    $(function(){
      // if(IsManager =="0")
        //$(".MClass").remove();
    });
        var Filter = { range: -1, name: "所有", ret: "all", specific: [] };
        var IsInitial = true; /*表明修改搜索条件*/
        var initColumnBefore = [{ field: 'ck', checkbox: true },
                         { field: 'rkid', title: '入库编号', width: 20, sortable: true },
                        { field: 'toolid', title: '识别号', width: 20, sortable: true },
                        { field: 'name', title: '名称', width: 60, sortable: true, tooltip: true, formatter:
                function (val, row, index) {
                    Str = '<div style="padding:10px 200px"><p><a  href="javascript:void(0)" class="easyui-tooltip" data-options="hideEvent: \'none\',content: function(){return $("<div>' + val + '</div>");},onShow: function(){var t = $(this);t.tooltip(\'tip\').focus().unbind().bind(\'blur\',function(){tooltip(\'hide\');});}">Hover me</a> to display toolbar.</p>	</div>';

                    // return val;
                    return '<a  class = "myCell" id="tip' + row.id + '">' + val + '</a>';
                }
                        }
    
            ];
             initColumnAfter = [
                { field: 'toolstate', title: '理论状态', width: 25, sortable: true },
                { field: 'lastseen', title: '最后发现时间', width: 50 },
                { field: 'posx', title: '所在货架', width: 25, sortable: true },
                { field: 'posy', title: '所在层', width: 20, sortable: true },
                { field: 'realtoolstate', title: '实际状态', width: 25, sortable: true },
                { field: 'modifytime', title: '最后修改时间', width: 80, sortable: true },
                { field: 'look', title: '借用记录', width: 80, sortable: true,formatter: formatLook}
            ];
           
      
   
  
          
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
        
        function LookBorrowHistory(ToolID) {
            $('#Win').window({
                width: 800,
                height: 400,
                modal: true,
                inline:false,                
            });            
            
            $("#BorrowHS").attr("src","BorrowHistory.aspx?ToolID=" + ToolID);
            $("#Win").window({ title: "工具借用历史", closed: false});
            $("#Win").window({ closed: false });
        }
         function formatLook(val, row, index) {
            if (row.toolstate != undefined ){
                return '<a href= "#" onclick="LookBorrowHistory(\''+row.toolid+'\')">查看</a>'; 
            }                 
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
                        },timeout:9999999,
                        error: function(xhr, s, e) {
                        $.messager.progress('close');
                            if (ErrorFun == undefined || ErrorFun == null) {                                
                                $.messager.alert('数据加载错误', e +s);
                            } else {                               
                                 ErrorFun(xhr, s, e);
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
        $(function () {

            var json = {};
            json.cmd = "GetToolBagList";

            MyAjax(json, function (data) {
                if (data.status == "success") {
                    data.data.push({ "name": "所有", "id": "-1" });
                    $("#ToolBagList").combobox({ editable: false, data: data.data, valueField: "id", textField: "name", onSelect: function (record) { record.isInit = false; ToolBagClassChange(record); } });
                    $("#ToolBagList").combobox('setValue', '-1');

                } else {
                    $.messager.alert('错误', '工具包列表加载失败！');
                }
            }, null);

            json.cmd = "GetClassList";

            MyAjax(json, function (data) {
                if (data.status == "success") {
                    data.data.push({ "name": "所有", "id": "-1" });
                    $("#ToolList").combobox({ editable: false, data: data.data, valueField: "id", textField: "name", onSelect: function (record) { record.isInit = false; ToolClassChange(record); } });
                    $("#ToolList").combobox('setValue', '-1');
                } else {
                    $.messager.alert('错误', '工具包列表加载失败！');
                }
            }, null);




            function fixWidth(percent) {
                return document.body.clientWidth * percent; //这里你可以自己做调整
            }
          

            function AddTooltip(id, type/*0 普通tooltip 1 工具包tooltip*/, dat/*属性集合[{name:'大',value:'5/8'}…………]  当type=1时为toolbag.aspx?type=1&bagid=XXX*/) {

                $('#tip' + id).tooltip({
                    position: 'right',
                    content: function () {
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
            
         function GridSet(newColumns)
            {
               $("#t1").treegrid({
                    title: '',
                    width: document.body.clientWidth * 2.5,
                    height: 1200,
                    idField: 'id',
                    treeField: 'name',
                     toolbar: '#tb',
                     striped:true,
                    rownumbers: true,
                    fitColumns:true,
                    onLoadSuccess: function (row, data) {
                    
                    return;
                        for (i = 0; i < data.length; i++) {                            
                            $("#btn"+data[i].id).linkbutton();
                            if (data[i].children != null && data[i].children.length != 0) {
                                AddTooltip(data[i].id, 1, 'ToolBag.aspx?Type=1&BagID=' + data[i].id);
                                for (j = 0; j < data[i].children.length; j++) {
                                    AddTooltip(data[i].children[j].id, 0, data[i].children[j].sx);
                                    $("#btn"+data[i].children[j].id).linkbutton();
                                }
                            } else {
                                AddTooltip(data[i].id, 0, data[i].sx);
                            }
                        }

                    },
                    columns: [initColumnBefore.concat(newColumns).concat(initColumnAfter)],
                    enableHeaderClickMenu: false,
                    enableHeaderContextMenu: false,
                    enableRowContextMenu: false
                });
            }
           
            
             $(function () {

                $("#Radio1").bind("click", function () {
                    Filter.range = -1;
                    Filter.name = "所有";
                    Filter.ret = "all";
                    $("#ToolBagList").combobox("setValue", "-1");
                    ParseFilters();
                });
                
               GridSet([]);
          
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

            /*{ range: -1, name: "所有", ret: "all", specific:[
            *                                                  { tid: ToolClassID, name: ToolClassName, vals: [
            *                                                                                                  { name: PropertyName, pid: PropertyID, val: Value }
            * ] }
            * ] };*/
            
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
                //开始在specific中查找该ToolClassID
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
        
        function AfterSearch(data)
        {
             
                    //alert(JSON.stringify(data.data));
                   var newColumns = data.newcolumns;
                   oo = [];
                   ss="";
                   for(i=0;i<newColumns.length;i++)
                   {                   
                     oo.push({field: ""+newColumns[i]+ "", title:"" +newColumns[i]+"", sortable: true});
                   }        
                   $("#t1").treegrid({columns: [initColumnBefore.concat(oo).concat(initColumnAfter)]});       
        }
        
        function doSearch() {
            var json = {};
            json.cmd = "ToolSearch";
            json.Filter = Filter;
            json.name = $("#sName").val();
            json.rkid = $("#srkID").val();
            json.toolid = $("#sToolID").val();
            MyAjax(json, function(data) {
            $.messager.progress('close');
             if (data.status == "success") {
                    
                    AfterSearch(data);  //增加属性列               
                   //
                   //$("#t1").treegrid("loading");
                    $("#t1").treegrid({data:data.data});
                    // $("#t1").treegrid("load",data);
                    $("#ExcelReport").attr("href",data.url);
                    //alert(data.url);
                    //$("#t1").treegrid("loaded");

                } else {
                    $.messager.alert('错误', data.msg);
                }
            }, function Err(xhr,s,e){
                    alert(xhr.responseText+s+e);
            });
        }
       
       function ModifyTool()
       {
            var row = $('#t1').datagrid('getSelected');
                  
            if(row == null || row.tooltype == '5')
            {
                $.messager.alert('错误', '请选择要修改的工具!');
                return;
            }
            var Type = row.tooltype;                
            var ClassID =row.classid;
            var ToolID = row.toolid;
            var fakeType ;
            var BagID="";
            var BagName="";
            var ToolName = row.name;
            var rkID=row.rkid;
            if(Type == 0){//独立工具，可修改属性，进包
                fakeType = 8; 
            }else if(Type ==1)//工具箱本体 可修改属性
            {
                fakeType = 7; 
                BagName = row.bagname;
                BagID = row.bagid;
            }else if(Type==3)//包内工具 可修改属性 可独立 可改包
            {
                fakeType = 6;   
                BagName = row.bagname;
                BagID = row.bagid;
            }else if(Type==3)//包内工具 可修改属性 可独立 可改包
            {
                fakeType = 6;   
                BagName = row.bagname;
                BagID = row.bagid;
            }
            
             $("#fr1").attr("src","ToolContentManage.aspx?rkID="+rkID+"&Type="+fakeType+"&ToolID="+ToolID+"&ClassID="+ClassID+"&ToolName="+ToolName + "&BagID="+BagID+"&BagName="+BagName);
             $("#Win1").window({ title: "工具修改", modal: true, closed: false, onClose:function(){doSearch(); }});
          
       }
       
       function DePackBag()
       {
             var row = $('#t1').datagrid('getSelected');
                  
            if(row == null || row.tooltype != '5')
            {
                $.messager.alert('错误', '请选择要拆分的工具包!');
                return;
            }
            

            $.messager.confirm('确认对话框', '确定要拆包吗?这样的话，该工具包内所有工具将变成独立工具。', function(r){
	            if (r){
	                var ClassID =row.classid;
                    var fakeType ;
                    var BagID=row.toolid;
                    var BagName=row.name;
                    oo = {};
                    oo.cmd = "DePackBag";
                    oo.bagid = BagID;
                    oo.bagname = BagName;
                    MyAjax(oo,function(data){
                       $.messager.alert('提示',data.msg);
                       doSearch();
                    });
	            }
            });

           
            
       }
       
       function CreateBagContentExcel()
       {
             var row = $('#t1').datagrid('getSelected');
                  
            if(row == null || row.tooltype != '5')
            {
                $.messager.alert('错误', '请选择工具包!');
                return;
            }
            


                    var BagID=row.id;

                    oo = {};
                    oo.cmd = "CreateBagContentExcel";
                    oo.coreid = BagID;
                    MyAjax(oo,function(data){
                        $.messager.alert('提示',data.msg);
                        $("#BagContent").attr("href",data.url);
                    });
	        
        

           
       }
       
       function AddToolBag()//加包按钮
       {
              var row = $('#t1').datagrid('getSelected');
                  
            if(row == null || row.tooltype != '0')
            {
                $.messager.alert('错误', '请选择作为新工具包的工具箱。');
                return;
            }


            $.messager.prompt('提示信息', '请输入新工具包的名称', function(r){
	            if (r){
		            oo = {};
		            oo.cmd = "ManualAddToolBag";
		            oo.toolid = row.toolid;//工具箱本体的ID;
		            oo.bagname = r;
		            MyAjax(oo,function(data){
		                 $.messager.alert('提示',data.msg);
		            });
		            doSearch();
	            }
            });


       }
            
</script>
</head>
<body id = "cc" class="easyui-layout">

    <form id="form1" runat="server">
   <div id= "MContent" title = "工具查询与管理" region="center"">
    <div title="库存查询" >
       <div style="min-height:5px;height:auto;" class="btnbartitle" >
           <div style="padding:5px;">范围:&nbsp;&nbsp;<select id ="ToolBagList" class="easyui-combobox" style = "width:150px; " ></select>&nbsp;&nbsp;名称: <input id="sName" style=" width:115px;"/>&nbsp;&nbsp;入库编号: <input id="srkID" style=" width:45px;"/>&nbsp;识别号: <input id="sToolID" style=" width:50px;"/>&nbsp;&nbsp;<a id="A2" class="easyui-linkbutton" onclick = "doSearch();">搜索</a></div>
           <div style="padding:0px 5px 5px 5px;">条件:&nbsp;&nbsp;<select id ="ToolList" class="easyui-combobox" style = "width:150px; "  ></select>&nbsp;&nbsp;<select id ="PropertyList" class="easyui-combobox" style = "width:150px; "  ></select>&nbsp;&nbsp;<select id ="ValueList" class="easyui-combobox" style = "width:150px; "  ></select>&nbsp;&nbsp; <a id="opBtn" class="easyui-linkbutton" onclick = "FilterModify();">增加</a>&nbsp;&nbsp;<a id="A1" class="easyui-linkbutton" onclick = "">清空</a>&nbsp;&nbsp;</div>
           <div style="padding:0px 5px 5px 5px;">筛选:
               <input name = "rg"  id="Radio1" type="radio" checked= "checked">显示所有</input>
               <input name = "rg"  id="Radio2" type="radio" >工具包</input>
               <input name = "rg"  id="Radio3" type="radio" >独立工具</input>
               
           </div> 
       <div id = "FiltersDiv" style="">
       
        </div>
       
        </div>

      <div>
            <table id="t1"></table>
        </div>
        </div>
        
       
        
    </div>
    
    </div>
          
             
      <div id="Win" class="easyui-window"  style = "padding:0px; width:300px; height:500px;" data-options="maximizable:false,minimizable:false,collapsible:false,closed:true" >
                <iframe id ="BorrowHS"  width="97%" height="97%" frameborder="0"></iframe>
            </div>
       
 <div id = "tb"     >
 
 
        <span style="margin-left:460px;">操作:</span>
       
        <a href="#"   class="easyui-linkbutton" style=" margin-right:5px;" onclick = "ModifyTool();">工具修改</a>
        <a href="#"  class="easyui-linkbutton" style=" margin-right:5px;" onclick = "DePackBag();">拆包</a>
        <a href="#"  class="easyui-linkbutton"  style=" margin-right:5px;" onclick = "AddToolBag();">手工加包</a>
        <a href="#"  class="easyui-linkbutton"  style=" margin-right:5px;" onclick = "CreateBagContentExcel();">生成包内清单</a>
        <a href="#"  id="ExcelReport">结果导出(Excel)</a>
        &nbsp
        <a href="#"  id="BagContent">包内清单</a>
    </div>
      <div id="Win1" class="easyui-window"  style = "padding:0px;width:550px;height:600px;" data-options="maximizable:false,minimizable:false,collapsible:false,closed:true,modal:true,title:'工具管理'" >
               <iframe id ="fr1"  width="97%" height="97%" frameborder="0"></iframe>
       </div>
    </form>
</body>
</html>
