page 91301 "SEW Contact Relation"
{
    ApplicationArea = All;
    Caption = 'Contact Relations';
    PageType = List;
    SourceTable = "SEW Contact Relations";
    UsageCategory = Lists;
    DelayedInsert = true;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Contact No. from"; Rec."Contact No. from")
                {
                }
                field("Contact from"; Rec."Contact from")
                {
                }
                field("Relation Type"; Rec."Relation Type")
                {
                }
                field("Relation Description"; Rec."Relation Description")
                {
                }
                field("Contact No. to"; Rec."Contact No. to")
                {
                }
                field("Contact to"; Rec."Contact to")
                {
                }
            }
        }
    }
}
