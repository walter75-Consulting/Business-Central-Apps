page 80013 "SEW Document Text Sales"
{
    ApplicationArea = All;
    Caption = 'Document Text Sales';
    PageType = List;
    SourceTable = "SEW Document Text Sales";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document Type Sales"; Rec."Document Type Sales")
                {
                }
                field("Language Code"; Rec."Language Code")
                {
                }
                field("All Language Codes"; Rec."All Language Codes")
                {
                }
                field("for eMail"; Rec."for eMail")
                {
                }
                field(Position; Rec.Position)
                {
                }
                field(Sortorder; Rec.Sortorder)
                {
                }
                field("Starting Date"; Rec."Starting Date")
                {
                }
                field("Ending Date"; Rec."Ending Date")
                {
                }
                field("Document Text"; Rec."Document Text")
                {
                }
            }
        }
    }
}
