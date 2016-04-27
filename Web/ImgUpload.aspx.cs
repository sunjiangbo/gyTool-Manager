using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

public partial class ImgUpload : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.Files.Count == 0)
        {
            
            Response.Write("error");
            Response.End();
        }

        HttpPostedFile file = Request.Files[0];
        file.SaveAs(MapPath("\\upload\\") + file.FileName);
        Response.Write("http://"  + Request.Url.Host + ":" + Request.Url.Port + "/upload/"+file.FileName);
    }
}
