/// <summary>
/// Page SEW Learning Path Card (ID 91853).
/// Detailed view of a learning path.
/// </summary>
page 91853 "SEW Learn Cont Card"
{
    PageType = Card;
    SourceTable = "SEW Learn Cont";
    Caption = 'Learning Content Card';
    ApplicationArea = All;
    Editable = false;
    UsageCategory = None;


    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General Information';
                field(UID; Rec.UID) { }
                field("Content Type"; Rec."Content Type") { }
                field(Title; Rec.Title) { }
                field(URL; Rec.URL) { }
                field("Duration in Minutes"; Rec."Duration in Minutes") { }
                field("Number of Modules"; Rec."Number of Modules") { }
                field("Number of Learning Paths"; Rec."Number of Learning Paths") { }
                field("Last Modified"; Rec."Last Modified") { }
            }
            group(Details)
            {
                Caption = 'Details';
                field(Summary; Rec.Summary)
                {
                    MultiLine = true;
                }

            }
            part(Modules; "SEW Learn Cont Path Mod")
            {
                Caption = 'Modules';
                SubPageLink = "Learning Path UID" = field(UID);
                Visible = Rec."Content Type" = Rec."Content Type"::"Learning Path";
            }
            part(ParentPaths; "SEW Module Parent Paths")
            {
                Caption = 'Learning Paths';
                SubPageLink = "Module UID" = field(UID);
                Visible = Rec."Content Type" = Rec."Content Type"::Module;
            }
        }
        area(FactBoxes)
        {
            part(Icon; "SEW Learn Cont Icon FB")
            {
                Caption = 'Icon';
                SubPageLink = UID = field(UID);
            }
            part(Levels; "SEW Learn Cont Levels FB")
            {
                Caption = 'Levels';
                SubPageLink = "Content UID" = field(UID);
            }
            part(Roles; "SEW Learn Cont Roles FB")
            {
                Caption = 'Roles';
                SubPageLink = "Content UID" = field(UID);
            }
            part(Subjects; "SEW Learn Cont Subjects FB")
            {
                Caption = 'Subjects';
                SubPageLink = "Content UID" = field(UID);
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(OpenInBrowser)
            {
                Caption = 'View on Microsoft Learn';
                ToolTip = 'Open this learning content in the Microsoft Learn website.';
                Image = Link;

                trigger OnAction()
                begin
                    Rec.OpenInBrowser();
                end;
            }
        }
    }
}
