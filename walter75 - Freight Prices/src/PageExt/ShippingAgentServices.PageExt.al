pageextension 91401 "SEW Shipping Agent Services" extends "Shipping Agent Services"
{
    layout
    {
        addafter("Shipping Time")
        {
            field("SEW Freight Charge"; Rec."SEW Freight Charge")
            {
                ApplicationArea = All;
            }
        }
    }
}
