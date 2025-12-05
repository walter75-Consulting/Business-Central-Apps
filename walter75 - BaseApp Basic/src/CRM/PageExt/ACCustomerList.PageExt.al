pageextension 80049 "SEW AC Customer List" extends "Customer List"
{
    layout
    {
        addafter("Responsibility Center")
        {
            field("SEW Territory Code"; Rec."Territory Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Territory Code.';
            }
            field("SEW Territory manually"; Rec."SEW Territory manually")
            {
                ApplicationArea = All;
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