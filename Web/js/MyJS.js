/**
 *  页面加载等待页面
 *
 * @author gxjiang
 * @date 2010/7/24
 *
 */
/* function loading()
 {
	 var height = window.screen.height-250;
	 var width = window.screen.width;
	 var leftW = 300;
	 if(width>1200){
		leftW = 500;
	 }else if(width>1000){
		leftW = 350;
	 }else {
		leftW = 100;
	 }
	 
	 var _html = "<div id='loading' style='position:absolute;left:0;width:100%;height:"+height+"px;top:0;background:#E0ECFF;opacity:0.8;filter:alpha(opacity=80);'>\
	 <div style='position:absolute;	cursor1:wait;left:"+leftW+"px;top:200px;width:auto;height:16px;padding:12px 5px 10px 30px;\
	 background:#fff url(../img/loading.gif) no-repeat scroll 5px 10px;border:2px solid #ccc;color:#000;'>\
	 loading...\
	 </div></div>";
	 
	 window.onload = function(){
		var _mask = document.getElementById('loading');
		_mask.parentNode.removeChild(_mask);
	 }

	 
 document.write(_html);
 }
 */
   String.prototype.trim = function()  
        {  
            return this.replace(/(^\s*)|(\s*$)/g, "");  
        }  
 
function MyAjax(jsondat, SuccessFun, ErrorFun) {
    $.messager.progress({ title: '提示', msg: '正在处理，请稍候!' });
    $.ajax(
                    {
                        url: 'AJAX/Handler.ashx',
                        type: "POST",
                        data: JSON.stringify(jsondat),
                        dataType: 'json',
                        success: function (data) {
                            SuccessFun(data);
                            $.messager.progress('close');
                        },
                        error: function (xhr, s, e) {
                            if (ErrorFun != undefined && ErrorFun != null) {
                                ErrorFun(xhr, s, e);
                            } else {
                                $.messager.progress('close');
                                $.messager.alert('数据加载错误', e);
                            }
                        }
                    });
}
 function  ChangeTheme(themeName) {/*更换主题扩展*/
    var $easyuiTheme = $('#easyuiTheme');
    var url = $easyuiTheme.attr('href');
    var href = url.substring(0, url.indexOf('theme')) + 'theme/' + themeName + '/easyui.css';

    var $iframe = $('iframe');
    if ($iframe.length > 0) {
        for (var i = 0; i < $iframe.length; i++) {
            var ifr = $iframe[i];
            $(ifr).contains().find('#easyuiTheme').attr('href', href);
        }
    }

    $.cookie('easyuiThemeName', themeName, {
        expires: 7
    });
}

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