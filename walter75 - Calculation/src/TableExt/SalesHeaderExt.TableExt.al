tableextension 90891 "SEW Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(90800; "SEW Default Calc Template"; Code[20])
        {
            Caption = 'Default Calc Template';
            ToolTip = 'Specifies the default calculation template to use for all lines in this document';
            TableRelation = "SEW Calc Template";
            DataClassification = CustomerContent;
        }
        field(90801; "SEW Auto Calculate"; Boolean)
        {
            Caption = 'Auto Calculate';
            ToolTip = 'Specifies whether calculations should be created automatically when adding items to lines';
            DataClassification = CustomerContent;
            InitValue = false;
        }
    }
}
