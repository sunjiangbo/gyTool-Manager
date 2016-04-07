#include "gybutton.h"

gyButton::gyButton(int i)
{
    index = i;
}

void gyButton::Borowse_Clicked_slot()
{
        emit BorowseClicked(index);
}

void gyButton::Borrow_Clicked_slot()
{
        emit BorrowClicked(index);
}
