<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MyEditor.aspx.cs" Inherits="_Default" validateRequest="false"  %>


<!DOCTYPE HTML>

<html>
<head id="Head1" runat="server">
    <meta charset="utf-8" />
    <title>KindEditor ASP.NET</title>
    <link rel="stylesheet" href="myEditor/themes/default/default.css" />
	<link rel="stylesheet" href="myEditor/plugins/code/prettify.css" />
	<script charset="utf-8" src="myEditor/kindeditor.js"></script>
	<script charset="utf-8" src="myEditor/lang/zh_CN.js"></script>
	<script charset="utf-8" src="myEditor/plugins/code/prettify.js"></script>
	<script src="artDialog/artDialog.js?skin=green"></script>
    <script src="artDialog/plugins/iframeTools.js"></script>
	<script src="MyartDialog.js"></script>
    <script>
        KindEditor.ready(function(K) {
            var editor1 = K.create('#content1', {
                cssPath: 'myEditor/plugins/code/prettify.css',
                uploadJson: 'myEditor/upload_json.ashx',
                fileManagerJson: 'myEditor/file_manager_json.ashx',
                allowFileManager: true,
                afterCreate: function() {
                    var self = this;
                    K.ctrl(document, 13, function() {
                        self.sync();
                        K('form[name=example]')[0].submit();
                    });
                    K.ctrl(self.edit.doc, 13, function() {
                        self.sync();
                        K('form[name=example]')[0].submit();
                    });
                }
            });
            prettyPrint();
        });
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
                    padding-bottom: 5px;
                    padding-top: 1px;
                    background-color: #f5f5f5;
                    margin-top: 10px;
                    line-height: 1.8;
                    text-align:left;
        }
        .person
        {   
            color:Red;          
        }
        .title
        {
             
         }
         .fbPerson
         {
             color:blue;  
             text-align:left;
          }
	</style>
	<!--
	    <link rel="stylesheet" href="css/MyCss.css" />
	    
	     background-color: #f0eedf;
	-->


</head>
<body>
    <form id="example" runat="server">
    
    <div class="post" align="center" >
    
       <div class="postTitle">
         <div> <asp:Label ID="Label2" runat="server" ForeColor="Red"></asp:Label></div>
         <div style="text-align:left;">
              
             标题:<asp:TextBox ID="TextBox1" runat="server" style="width:95%"></asp:TextBox>
              
           </div>
        </div>
        
       <div class="postText">
                内容:<br/>
                <textarea id="content1" rows="8" 
                    style="width:99%; height:400px;visibility:hidden;" runat="server" 
                    name="S1"></textarea><div style="text-align:right;width:100%">
        &nbsp;<asp:Button ID="Button2" runat="server" Text="发表" onclick="Button2_Click1" />
&nbsp;&nbsp;
        <asp:Button ID="Button1" runat="server" Text="取消" onclick="Button1_Click" /> 
        </div>
        </div>
    </div>
    
    </form>
</body>
</html>
