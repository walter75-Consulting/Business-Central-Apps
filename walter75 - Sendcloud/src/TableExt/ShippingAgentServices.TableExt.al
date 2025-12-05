tableextension 95701 "SEW Shipping Agent Services" extends "Shipping Agent Services"
{
    fields
    {
        field(95700; "SEW sendCloudID"; Integer)
        {
            Caption = 'SendCloud ID';
            ToolTip = 'Specifies the SendCloud ID.';
            DataClassification = CustomerContent;
            TableRelation = "SEW Carrier Ship Met".ID where("Carrier Code" = field("Shipping Agent Code"));
            trigger OnValidate()
            var
                SEWSCPageActions: Codeunit "SEW SC Page Actions";
            begin
                SEWSCPageActions.GetShippingMethDesc(Rec);
            end;
        }
    }
}
