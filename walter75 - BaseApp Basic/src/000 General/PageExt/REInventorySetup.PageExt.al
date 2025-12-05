pageextension 80053 "SEW RE Inventory Setup" extends "Inventory Setup"
{
    layout
    {
        addafter("Location Mandatory")
        {
            field("SEW Use Shelf No."; Rec."SEW Use Shelf No.")
            {
                ApplicationArea = All;
            }
        }
    }
}