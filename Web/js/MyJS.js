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