#ifndef GYBUTTON_H
#define GYBUTTON_H

#include<QPushButton>

class gyButton : public QPushButton
{
    Q_OBJECT
public:
    explicit gyButton(int i);
    int index;
    int AppState;
signals:
    void BorowseClicked(int i);
    void BorrowClicked (int i);

public slots:
    void Borowse_Clicked_slot();
    void Borrow_Clicked_slot();
};

#endif // GYBUTTON_H
