#include "mycombox.h"

myComBox::myComBox()
{

}

QString myComBox::get_coreid()
{
            if (!coreidmap.contains(currentIndex()))return"";

            return coreidmap.value(currentIndex())->CoreID;
}
QString myComBox::get_toolname()
{
    if (!coreidmap.contains(currentIndex()))return"";
            return coreidmap.value(currentIndex())->Name;
}

void myComBox::insert_coreid(int i, QString  ToolName,QString coreid)
{

      if (!coreidmap.contains(i)){
          ToolNameAndCoreID *ss = new ToolNameAndCoreID();
          ss->Name = ToolName;
          ss->CoreID  = coreid;
          coreidmap[i] = ss;
      }
}
