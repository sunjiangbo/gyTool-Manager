/**
 *  ҳ����صȴ�ҳ��
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
 function  ChangeTheme(themeName) {/*����������չ*/
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