page 91714 "SEW Lost Reasons"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "SEW Lost Reason";
    Caption = 'Lost Reasons';

    layout
    {
        area(Content)
        {
            repeater(ReasonRows)
            {
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = All;
                    Caption = 'Reason Code';
                    ToolTip = 'Specifies the unique code for the lost reason.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    ToolTip = 'Specifies the description of the lost reason.';
                }
            }
        }
    }
}
