tableextension 80033 "SEW AC Post Code" extends "Post Code"
{
    fields
    {
        field(80200; "SEW Territory Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Territory Code';
            ToolTip = 'Specifies the Territory Code.';
            TableRelation = "Territory";
        }
        field(80201; "SEW Service Zone"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Service Zone';
            ToolTip = 'Specifies the Service Zone.';
            TableRelation = "Service Zone";
        }
    }

}