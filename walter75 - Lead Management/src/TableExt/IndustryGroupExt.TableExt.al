tableextension 91717 "SEW Industry Group Ext" extends "Industry Group"
{
    fields
    {
        field(91700; "SEW Lead Score"; Integer)
        {
            Caption = 'Lead Score';
            ToolTip = 'Specifies the score points awarded when a lead belongs to this industry group.';
            DataClassification = CustomerContent;
            AllowInCustomizations = Never;
        }
    }
}
