page 80002 "SEW Contact Title"
{
    ApplicationArea = All;
    Caption = 'Contact Titles';
    PageType = List;
    SourceTable = "SEW Contact Title";
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
