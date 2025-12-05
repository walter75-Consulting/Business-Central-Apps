pageextension 80060 "SEW AS Item List" extends "Item List"
{
    layout
    {
        addafter("Vendor No.")
        {
            field("SEW Date last Invoice"; Rec."SEW Date last Invoice")
            {
                ApplicationArea = All;
            }
        }
    }
}

