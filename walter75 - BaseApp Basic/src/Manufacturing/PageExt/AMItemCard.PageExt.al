pageextension 80061 "SEW AM Item Card" extends "Item Card"
{
    layout
    {
        addafter("Vendor No.")
        {
            field("SEW Date last Production"; Rec."SEW Date last Production")
            {
                ApplicationArea = All;
            }
        }
    }
}