pageextension 91402 "SEW Sales Order" extends "Sales Order"
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
