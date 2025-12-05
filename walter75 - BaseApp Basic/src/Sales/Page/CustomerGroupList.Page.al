page 80005 "SEW Customer Group List"
{
    ApplicationArea = All;
    Caption = 'Customer Groups';
    PageType = List;
    SourceTable = "SEW Customer Group";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                }
                field(Description; Rec.Description)
                {
                }
            }
        }
    }
}
