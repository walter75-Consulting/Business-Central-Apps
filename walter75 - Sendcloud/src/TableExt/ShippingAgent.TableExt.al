tableextension 95700 "SEW Shipping Agent" extends "Shipping Agent"
{
    fields
    {
        field(95700; "SEW sendCloudID"; Code[50])
        {
            Caption = 'SendCloud ID';
            ToolTip = 'Specifies the SendCloud ID.';
            DataClassification = CustomerContent;
            TableRelation = "SEW Carrier".Code;
        }
    }
}
