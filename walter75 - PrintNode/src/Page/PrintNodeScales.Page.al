page 92707 "SEW PrintNode Scales"
{
    ApplicationArea = All;
    Caption = 'SEW PrintNode Scales';
    PageType = List;
    SourceTable = "SEW PrintNode Scale";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Computer ID"; Rec."Computer ID")
                {
                }
                field("Scale Name"; Rec."Scale Name")
                {
                }
                field("Scale No."; Rec."Scale No.")
                {
                }
                field("Scale Vendor"; Rec."Scale Vendor")
                {
                }
            }
        }
    }
}
