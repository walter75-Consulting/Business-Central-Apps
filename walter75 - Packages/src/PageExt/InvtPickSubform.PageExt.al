pageextension 90701 "SEW Invt. Pick Subform" extends "Invt. Pick Subform"
{
    layout
    {
        addafter("Qty. Handled")
        {
            field("SEW Qty. to Pack"; Rec."SEW Qty. to Pack")
            {
                ApplicationArea = All;
                Caption = 'Qty. to Pack';
                ToolTip = 'Specifies the quantity to be packed.';
            }
            field("SEW Qty. Packed"; Rec."SEW Qty. Packed")
            {
                ApplicationArea = All;
                Caption = 'Qty. Packed';
                ToolTip = 'Specifies the quantity that has been packed.';
            }
        }
    }



}