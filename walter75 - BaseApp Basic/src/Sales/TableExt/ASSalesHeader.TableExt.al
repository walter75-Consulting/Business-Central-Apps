tableextension 80044 "SEW AS Sales Header" extends "Sales Header"
{
    fields
    {
        field(80300; "SEW Blanket Order No."; Code[20])
        {
            Caption = 'Blanket Order No.';
            ToolTip = 'Blanket Order No.';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = max("Sales Line"."Blanket Order No." where("Document No." = field("No."), "Document Type" = field("Document Type")));
        }
    }

}