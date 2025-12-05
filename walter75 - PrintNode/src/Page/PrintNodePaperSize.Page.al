page 92705 "SEW PrintNode Paper Size"
{
    ApplicationArea = All;
    Caption = 'PrintNode Paper Size';
    PageType = List;
    SourceTable = "SEW PrintNode Paper Size";
    UsageCategory = Administration;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Printer ID"; Rec."Printer ID")
                {
                    Visible = false;
                }
                field("Code"; Rec."Code")
                {
                    Visible = false;
                }
                field("Paper Name"; Rec."Paper Name")
                {
                }
                field("Paper Dimension"; Rec."Paper Dimension")
                {
                }
                field("Printer Name"; Rec."Printer Name")
                {
                    Visible = false;
                }
                field("Paper Width"; Rec."Paper Width")
                {
                }
                field("Paper Height"; Rec."Paper Height")
                {
                }
                field("System Paper Kind"; Rec."System Paper Kind")
                {
                }

            }
        }
    }
}
