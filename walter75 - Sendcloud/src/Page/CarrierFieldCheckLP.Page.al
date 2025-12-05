page 95708 "SEW Carrier Field Check LP"
{
    Caption = 'SEW Carrier Field Check LP';

    PageType = List;
    ApplicationArea = All;
    UsageCategory = None;

    SourceTable = "Field";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(FieldName; Rec.FieldName)
                {
                    ToolTip = 'Specifies the Field Name.';
                }
                field(Type; Rec."Type")
                {
                    ToolTip = 'Specifies the Type.';
                }
                field(Len; Rec.Len)
                {
                    ToolTip = 'Specifies the Length.';
                }
            }
        }
    }
}
