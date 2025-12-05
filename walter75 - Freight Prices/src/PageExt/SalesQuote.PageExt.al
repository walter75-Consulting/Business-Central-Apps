pageextension 91404 "SEW Sales Quote" extends "Sales Quote"
{
    layout
    {
        addafter("Shipping Agent Service Code")
        {
            field("SEW Freight manually"; Rec."SEW Freight manually")
            {
                ApplicationArea = All;
            }
        }
    }
}
