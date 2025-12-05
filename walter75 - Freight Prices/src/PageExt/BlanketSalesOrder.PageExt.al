pageextension 91403 "SEW Blanket Sales Order" extends "Blanket Sales Order"
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
