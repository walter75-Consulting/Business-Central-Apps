pageextension 80048 "SEW AC Customer Card" extends "Customer Card"
{
    layout
    {
        addafter("SEW Territory Code")
        {
            field("SEW Territory manually"; Rec."SEW Territory manually")
            {
                ApplicationArea = All;
            }
        }
        addafter("Service Zone Code")
        {
            field("SEW Service Zone manually"; Rec."SEW Service Zone manually")
            {
                ApplicationArea = Service;
            }
        }
        addafter("Salesperson Code")
        {
            field("SEW Salesperson manually"; Rec."SEW Salesperson manually")
            {
                ApplicationArea = All;
            }
        }
    }
}