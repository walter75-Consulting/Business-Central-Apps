pageextension 80064 "SEW AS Blanket Sales Order S" extends "Blanket Sales Order Subform"
{
    layout
    {
        addafter("Allow Invoice Disc.")
        {
            field("SEW Qty in Blanket Order"; Rec."SEW Qty in Blanket Order")
            {
                ApplicationArea = All;
            }
        }
    }
}
