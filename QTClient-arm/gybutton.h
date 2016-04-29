#ifndef GYBUTTON_H
#define GYBUTTON_H

#include<QPushButton>

class gyButton : public QPushButton
{
    Q_OBJECT
public:
    explicit gyButton(int i);
    int index;
    long AppState;
    long ToolAppID;
signals:
    void BorowseClicked(int i);
    void BorrowClicked (gyButton* btn);

public slots:
    void Borowse_Clicked_slot();
    void Borrow_Clicked_slot();
};

#endif // GYBUTTON_H
