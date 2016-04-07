#include "mycombox.h"

myComBox::myComBox()
{

}

QString myComBox::get_coreid()
{
            return coreidmap.value(currentIndex());
}


void myComBox::insert_coreid(int i, QString coreid)
{
      if (!coreidmap.contains(i)){
            coreidmap[i] = coreid;
      }
}
