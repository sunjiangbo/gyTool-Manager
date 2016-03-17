<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ToolBag.aspx.cs" Inherits="ToolBag"
 %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link rel="stylesheet" type="text/css" href="themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="themes/icon.css">
	<link rel="stylesheet" type="text/css" href="demo/demo.css">
	<script type="text/javascript" src="jquery.min.js"></script>
	<script type="text/javascript" src="jquery.easyui.min.js"></script>
    <script type="text/javascript" src="JS/MyJS.js"></script>
        <link href="Css/MyCSS.css" rel="stylesheet" type="text/css" />
    <script>
     
    </script>
   
</head>
 <style>
*{
    font-family: 微软雅黑, 宋体, Arial;  
  }
.Ctable{
    padding: 0px;
    margin: 0px;   
    border-collapse:collapse;
    
}

.Ctable td.attrtd {
 border: 1px solid #C1DAD7;  
    background: #ECF1EF;
    font-size:11px;
    padding: 6px 6px 6px 12px;
    color: blue;
    text-align:left;
    width:120px;
}
.Ctable td.pattrtd {
 border: 1px solid #C1DAD7;  
    background: #ECF1EF;
    font-size:11px;
    padding: 6px 6px 6px 12px;
    color: balck;
    text-align:left;
    width:120px;
}
.Ctable td.valuetd {
border: 1px solid #C1DAD7;  
    font-size:11px;
    padding: 6px 6px 6px 12px;
    color: #4f6b72;
    text-align:left;
     width:170px;
}
.Ctable td.tool
{
    border: 1px solid #C1DAD7;  
   background: #ffffcc;
    font-size:12px;
    padding: 6px 6px 6px 12px;
    color: #4f6b72;
    text-align:left;
    font-weight:bold;
    
}
.Ctable td.toolbag
{
    border: 1px solid #C1DAD7;  
   background: #66ff00;
    font-size:12px;
    padding: 6px 6px 6px 12px;
    color: #4f6b72;
    text-align:left;
    font-weight:bold;
}
        .style1
        {
            height: 29px;
        }
    </style>
 <body id ="cc">

              <div id="Win1" class="easyui-window"  style = "padding:0px;width:550px;height:450px;" data-options="maximizable:false,minimizable:false,collapsible:false,closed:true,modal:true,title:'Test Window'" >
               <iframe id ="fr1"  width="97%" height="97%" frameborder="0"></iframe>
            </div>
 <script>
     var gJSON = ""; //eval("(" + '<%= JSON %>' + ")");
     var gBagID = eval("(" + '<%= gID %>' + ")");
     var Type = eval("(" + '<%= Type %>' + ")");
     var WorkType = eval("(" + '<%= WorkType %>' + ")"); //如果WorkType = 1则证明是工具入编
     var BagName = "";
     function tbClick(id) {//点击工具箱前面的加号，显示工具箱内工具和箱子属性
        // alert(id);
         if ($("td[Childlb=Childlb" + id + "]").css("display") == "none") {
             $("td[Childlb=Childlb" + id + "]").show();
             $(this).css("background", "url('img/jj.png') no-repeat -32px center;");
         } else {
             $("td[gID=gID" + id + "]").hide();
             $(this).css("background", "url('img/jj.png') no-repeat -48px center;");
         }
     }
     function RankTool(Direction, CurRank,BagID) 
     {
         $.messager.progress({ title: '提示', msg: '正在处理，请稍候……' });
         $.ajax({
             url: 'AJAX/Handler.ashx',
             type: "POST",
             data: JSON.stringify({ "cmd": "RankTool", "direction": Direction, "currank": CurRank, "bagid": BagID }),
             dataType: 'json',
             success: function (data) {
                 $.messager.progress('close');
                 if (data.status == "success") {
                     location.reload();
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
     function mouseover() {
         currentcolor = this.style.backgroundColor; this.style.backgroundColor = 'yellow'; this.style.fontWeight = 'bold';
     }

     function mouseout() {
         this.style.backgroundColor = currentcolor; this.style.fontWeight = '';
     }

     function tClick(id,rk) {//点击工具前面的加号，显示工具属性
         id = id + "_" + rk;
         if ($("td[tpID=tpID" + id + "]").css("display") == "none") {  //tpID tool property 缩写 即工具的属性
             $("td[tpID=tpID" + id + "]").show();
             $(this).css("background", "url('img/jj.png') no-repeat -32px center;");
         } else {
             $("td[tpID=tpID" + id + "]").hide();
             $(this).css("background", "url('img/jj.png') no-repeat -48px center;");
         }
     }

     function Add(BagID, BagName) {
        $("#fr1").attr("src", "ToolContentManage.aspx?Type=2&BagID=" + BagID + "&BagName=" + BagName);
        $("#Win1").window({ title: "添加包内工具", modal: true, closed: false, onClose: function () { parent.window.LoadTree(); location.reload(); } });
        
     }


     function MakeToolBagTableByJSON (jdat)
     {
         var i = 0, j = 0, k = 0;
         var tb = '<table  border="0" cellpadding="0" cellspacing="0" class = "Ctable">';
         var bagID = ''/**/;
         jdat = jdat.data;
         //alert(jdat);
         rank = String(jdat[0].rank).split("|"); //rank为[0,505,44,22]等 工具箱为首，子工具按照用户指定顺序排列的数组
        

        // alert(rank.length);
         for (i = 0; i < jdat.length; i++) {//jdat.length 一般都是为1
             BagName = jdat[i].name; 
             bagID = jdat[i].id;  /*除工具箱本身外都具有 gID = "gIDX"*/
                                /*工具箱属性和工具包内工具具有 Childlb = "ChildlbX"*/
             tb += '<tr>'
             tb += '<td onclick ="tbClick(' + bagID + ')" style=" text-align:center; width:20px;background:url(\'img/jj.png\') no-repeat -48px center;"></td>'
             tb += '<td gID ="123" colspan="6" class="toolbag">' + jdat[i].name + '&nbsp;->&nbsp;(<span style = "color:blue;font-weigh:bold;">' + (jdat[i].toolid == "" ? '1' : jdat[i].toolid) + '</span>)'+(WorkType==1? '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;匹配模式:<input id="Radio1" checked="true" name = "pipei" type="radio" value="0" />缺省 <input id="Radio2" name = "pipei"   type="radio" value="1" />完全&nbsp;&nbsp;负责人:&nbsp;&nbsp;<input style="width:80px" ID = "CorePerson"></input>&nbsp;&nbsp;&nbsp;&nbsp;<a id="opBtn" class="easyui-linkbutton" onclick = "zbrb();">组包入编</a>':'') + '</td><td  class="toolbag" style="text-align:' + (WorkType == 1 ? 'left' : 'right') + ';">' + ((Type == 0 && WorkType == 0) ? '<a id="add"  class="easyui-linkbutton" data-options="iconCls:\'icon-add\'" onclick = "Add(' + bagID + ',\'' + jdat[i].name + '\');">添加子工具</a>' : '序号:&nbsp;<input pid = "' + jdat[i].id + '" style = "width:80px" id = gjrb' + jdat[i].id + '></input>') + '<td>';
             tb += '</tr>';


             for (j = 0, sign = 1; j < jdat[i].propertys.length ; j++, sign = -sign) {
                 
                 if (sign == 1) {
                     tb += '<tr>';
                     tb += '<td Childlb = "Childlb' + bagID +   '" gID = "gID' + bagID + '"></td><td Childlb = "Childlb' + bagID + '" gID = "gID' + bagID + '"></td><td Childlb = "Childlb' + bagID + '" gID = "gID' + bagID + '">&nbsp;&nbsp;&nbsp;&nbsp;</td><td Childlb = "Childlb' + bagID + '" gID = "gID' + bagID + '">&nbsp;&nbsp;&nbsp;&nbsp;</td>';
                 }
                 pclass = 'class="attrtd"';
                 if(jdat[i].propertys[j].compare == 1){pclass = 'class="pattrtd"';}
                 tb += '<td  Childlb = "Childlb' + bagID + '" gID = "gID' + bagID + '" ' + pclass + ' >';
                 tb += jdat[i].propertys[j].name  + '</td>';
                 tb += '<td  Childlb = "Childlb' + bagID + '" gID = "gID' + bagID + '" class="valuetd" >';
                 tb += jdat[i].propertys[j].value + '</td>';
                 if (sign == -1) { tb += '</tr>' };
            }

             if (j != 0 && sign == 1) {tb += '</tr>'; }
             //开始按照rank写子工具
             for (rk = 1; rk < rank.length; rk++) 
             {
             //把要写的子工具序号放入j即可
                 for (j = -1, next = 0; next < jdat[i].children.length; next++) 
                 {
                     if (jdat[i].children[next].id == rank[rk]) 
                     {
                         j = next;                     
                         break;
                     }
                  }   
                     if (j == -1) {continue;}
                     //////////////////////////////真正开始写序号为j子工具
                     tID = jdat[i].children[j].id;
                     tb += '<tr><td  Childlb = "Childlb' + bagID + '" gID = "gID' + bagID + '"style="width:20px;"></td><td Childlb = "Childlb' + bagID + '" gID = "gID' + bagID + '"  style=" text-align:center; width:20px;background:url(\'img/jj.png\') no-repeat -48px center;" onclick ="tClick(' + jdat[i].children[j].id + ',' + (rk + 1) + ');"></td>'
                     tb += '<td   Childlb = "Childlb' + bagID + '" gID = "gID' + bagID + '" colspan="5" class="tool"  >' + jdat[i].children[j].name + '&nbsp;->&nbsp;(<span style = "color:blue;font-weigh:bold;">' + (jdat[i].children[j].toolid == "" ? (rk + 1) : jdat[i].children[j].toolid) + '</span>)</td><td  Childlb = "Childlb' + bagID + '" gID = "gID' + bagID + '"  class="tool" style = "text-align:' + (WorkType == 1 ? 'left' : 'right') + ';">' + ((Type == 0 && WorkType == 0) ? '<a id="up' + tID + '"  class="easyui-linkbutton"  onclick = "RankTool(\'' + 'up' + '\',' + rk + ',' + bagID + ');">↑</a>&nbsp;&nbsp;<a id="down' + tID + '"  class="easyui-linkbutton"  onclick = "RankTool(\'' + 'down' + '\',' + rk + ',' + bagID + ');">↓</a>&nbsp;' : '序号:&nbsp<input pid = "' + jdat[i].children[j].id + '" style="width:80px" id = gjrb' + jdat[i].children[j].id + '></input>') + '</td></tr>';
                     //子工具属性

                     for (k = 0, sign = 1; k < jdat[i].children[j].propertys.length; k++, sign = -sign) {
                         if (sign == 1) {
                             tb += '<tr>';
                             tb += '<td tpID = "tpID' + tID + '_'+(rk+1) +    '" gID = "gID' + bagID + '"></td><td tpID = "tpID' + tID + '_'+(rk+1) +    '" gID = "gID' + bagID + '"></td><td tpID = "tpID' + tID+ '_'+(rk+1) +    '" gID = "gID' + bagID + '">&nbsp;&nbsp;&nbsp;&nbsp;</td><td tpID = "tpID' + tID + '_'+(rk+1) +    '" gID = "gID' + bagID + '">&nbsp;&nbsp;&nbsp;&nbsp;</td>';
                         }
                         pclass = 'class="attrtd"';
                         if (jdat[i].children[j].propertys[k].compare == 1) { pclass = 'class="pattrtd"'; }
                         tb += '<td  tpID = "tpID' + tID + '_'+(rk+1) +    '" gID = "gID' + bagID + '"' + pclass + '>';
                         tb += jdat[i].children[j].propertys[k].name + '</td>';
                         tb += '<td  tpID = "tpID' + tID + '_'+(rk+1) +    '" gID = "gID' + bagID + '" class="valuetd" >';
                         tb += jdat[i].children[j].propertys[k].value + '</td>';
                         if (sign == -1) { tb += '</tr>' };
                     }
                     /////////////////////////////////////////////
                 
             }

        }

         tb += '</table>';
         $("body").append($(tb));
         $("a[id^=up]").linkbutton().data("BagID", bagID);
         $("a[id^=down]").linkbutton().data("BagID", bagID);
         $("tr td[gID]").mouseenter(function () {

             $(this).data("color", $(this).css("background-color"));
             $(this).css("background-color", "yellow");
             $(this).css("font-weight", "bold");
             //$("body").append($(this).clone());
         });
         $("tr td[gID]").mouseleave(function () {

             $(this).css("background-color", $(this).data("color"));
             $(this).css("font-weight", "");
         });
         $("#opBtn").linkbutton();
         $("#add").linkbutton();
     }

     function zbrb() {
        // $.messager.alert('提示', '请输入所有工具的序列号!');
         var gjrb = $("input[id^=gjrb]");
         var i;
         var list = [];
         if ($.trim($("#CorePerson").val()) == '') {
             $.messager.alert('提示', '请输入打号负责人!');
             return;
         }
         for (i = 0; i < gjrb.length; i++) {
             if ($.trim($(gjrb[i]).val()) == '') {
                 $.messager.alert('提示', '请输入所有工具的序列号!');
                 return;
             }
             var obj = {};
             obj.pid = $(gjrb[i]).attr('pid');//工具包模型内 各工具在propertyvalues表中的id
             obj.sn = $(gjrb[i]).val(); //序列号
             list.push(obj);
         }

        // alert(JSON.stringify(list));
         var o = {};
         o.cmd = "AddToCoreTool";
         o.bagid = gBagID;
         o.list = list;
         o.comoption = 0;
         o.bagname = BagName;
         o.coreperson = $.trim($("#CorePerson").val());
         if ($("#Radio2").is(":checked")) 
         { o.comoption = 1; }
         $.messager.progress({ title: '提示', msg: '正在处理，请稍候……' });
         $.ajax({
             url: 'AJAX/Handler.ashx',
             type: "POST",
             data: JSON.stringify(o),
             dataType: 'json',
             success: function (data) {
                 $.messager.progress('close');
                 if (data.status == "success") {
                     $.messager.alert('提示', data.msg);
                     window.location.href = "HitTask.aspx?TaskID=" + data.taskid;
                 } else {
                     $.messager.alert('工具匹配错误', data.msg);
                 }
             },
             error: function (xhr, s, e) {
                 $.messager.progress('close');
                 $.messager.alert('数据加载错误', e);
             }
         });

     }

     $(function () {
         $.messager.progress({ title: '提示', msg: '正在处理，请稍候……' });
         $.ajax({
             url: 'AJAX/Handler.ashx',
             type: "POST",
             data: JSON.stringify({ "cmd": "getToolBagModel", "type": Type, "bagid": gBagID }),
             dataType: 'json',
             success: function (data) {
                 $.messager.progress('close');

                 if (data.status == "success") {
                     MakeToolBagTableByJSON(data);
                     if (Type != "0") { $("#add").hide(); }
                     if (WorkType == "1") { $("#table1").css("display", ""); }
                 } else {
                     $.messager.alert('数据加载错误', data.msg);
                 }
             },
             error: function (xhr, s, e) {
                 $.messager.progress('close');
                 $.messager.alert('数据加载错误', e);
             }
         });

     });
</script>

</body>
   

</html>

