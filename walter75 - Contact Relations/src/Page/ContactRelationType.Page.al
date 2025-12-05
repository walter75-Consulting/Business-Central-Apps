page 91300 "SEW Contact Relation Type"
{
    ApplicationArea = All;
    Caption = 'Contact Relation Types';
    PageType = List;
    SourceTable = "SEW Contact Relation Type";
    UsageCategory = Administration;
    DelayedInsert = true;

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
                field("Description from"; Rec."Reverse Entry Code")
                {
                    ShowMandatory = true;
                }
            }
        }
    }
}
