tableextension 80039 "SEW RE Inventory Setup" extends "Inventory Setup"
{
    fields
    {
        field(80800; "SEW Use Shelf No."; Boolean)
        {
            Caption = 'Use Shelf No.';
            ToolTip = 'Specifies whether to use shelf numbers.';
            DataClassification = CustomerContent;
        }
    }
}
