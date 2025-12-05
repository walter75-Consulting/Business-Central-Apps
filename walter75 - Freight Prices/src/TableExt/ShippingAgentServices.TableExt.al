tableextension 91402 "SEW Shipping Agent Services" extends "Shipping Agent Services"
{
    fields
    {
        field(91400; "SEW Freight Charge"; Decimal)
        {
            Caption = 'Freight Charge';
            ToolTip = 'Specifies the freight charge for this shipping agent service.';
            DataClassification = CustomerContent;
        }
    }
}
