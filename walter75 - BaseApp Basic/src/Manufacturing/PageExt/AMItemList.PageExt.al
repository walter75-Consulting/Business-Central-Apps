pageextension 80059 "SEW AM Item List" extends "Item List"
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

