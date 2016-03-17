<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TaskComments.aspx.cs" Inherits="TakeComments" %>

<!DOCTYPE HTML> 
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
  
<script src="artDialog/artDialog.js?skin=green"></script>
<script src="artDialog/plugins/iframeTools.js"></script>
<script language="javascript">
    function tDialog() {

        art.dialog({
            title: '提示',
            lock: true,
            background: '#600',
            opacity: 0.87,
            content: 'fuck',
            window: 'top'
        });
    }
    function CloseArtDialog() {

        art.dialog({ id: 'dg_test34243' }).close();
    }
    function showDialogByUrl(newURL, oldURL) {
        /* art.dialog({
        title: stitle,
        lock: true,
        content: '<iframe ID="i1" runat="server" src = "'+URL+'"></iframe>',
        window: 'top',
        ok:false,
        padding: 0,
        width:400,
        height:400
        });*/

        art.dialog.open(newURL, {
            lock: true,
            id: 'dg_test34243',
            padding: 0,
            width:800,
            height:500,
            close: function() {
                art.dialog.open.origin.location.href = oldURL;
            }
        });
    }
    function showDlg(Msg) {
        art.dialog({
            title: '提示',
            content: Msg,
            cancel: false,
            ok: function() { }
        });
    }
</script>

    <style>
               .post{
                     border: #6e8bde 1px solid ;
                     background-color:  #f0eedf;
                    }
                     
        .postTitle {
                    padding-left: 3px;
                    font-weight: bolder;
                    padding-bottom: 3px;
                    padding-top: 3px;
                    border-bottom: #6e8bde 1px dashed;
                    background-color: #d6dff7;
                    text-align:left;
                    
        		}
                    
          .postText {
                    padding-right: 10px;
                    padding-left: 10px;
                    padding-bottom: 5px;
                    padding-top: 1px;
                    background-color: #f5f5f5;
                    margin-top: 10px;
                    margin-bottom: 10px;
                    line-height: 1.8;
                    text-align:left;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
            
        <asp:Button ID="Button3" runat="server" onclick="Button3_Click" Text="发表" />
        
       </div>     
 
    </form>
</body>
</html>
