tableextension 91403 "SEW Sales Header" extends "Sales Header"
{
    fields
    {
        field(91400; "SEW Freight manually"; Boolean)
        {
            Caption = 'Freight manually';
            ToolTip = 'Specifies whether freight charges are calculated manually for this sales document.';
            DataClassification = CustomerContent;
        }
    }
}
