tableextension 90893 "SEW Sales Setup Ext" extends "Sales & Receivables Setup"
{
    fields
    {
        field(90800; "SEW Calc Nos."; Code[20])
        {
            Caption = 'Calculation Nos.';
            ToolTip = 'Specifies the number series for calculations.';
            TableRelation = "No. Series";
        }
    }
}
