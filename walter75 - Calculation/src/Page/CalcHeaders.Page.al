page 90830 "SEW Calc Headers"
{
    Caption = 'Calculations';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "SEW Calc Header";
    CardPageId = "SEW Calc Card";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Template Code"; Rec."Template Code")
                {
                }
                field("Lot Size"; Rec."Lot Size")
                {
                }
                field("Total Cost"; Rec."Total Cost")
                {
                }
                field("Target Sales Price"; Rec."Target Sales Price")
                {
                }
                field("Margin %"; Rec."Margin %")
                {
                }
                field("Calculation Date"; Rec."Calculation Date")
                {
                }
            }
        }
    }
}
