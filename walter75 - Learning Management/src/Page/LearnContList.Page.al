/// <summary>
/// Page SEW Learning Module List (ID 91850).
/// Browse Microsoft Learn modules catalog.
/// </summary>
page 91850 "SEW Learn Cont List"
{
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "SEW Learn Cont";
    Caption = 'Learning Content List';
    ApplicationArea = All;
    CardPageId = "SEW Learn Cont Card";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(LearningContent)
            {
                field("Content Type"; Rec."Content Type") { }
                field(Title; Rec.Title)
                {
                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"SEW Learn Cont Card", Rec);
                    end;
                }
                field(Summary; Rec.Summary) { }
                field("Duration in Minutes"; Rec."Duration in Minutes") { }
                field("Last Modified"; Rec."Last Modified") { }
                field("Number of Modules"; Rec."Number of Modules") { }
                field("Number of Learning Paths"; Rec."Number of Learning Paths") { }
            }
        }
        area(FactBoxes)
        {
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
            action(ViewOnMicrosoftLearn)
            {
                Caption = 'View on Microsoft Learn';
                ToolTip = 'Open this learning content in the Microsoft Learn website.';
                Image = Link;

                trigger OnAction()
                begin
                    Rec.OpenInBrowser();
                end;
            }
            action(SyncCatalog)
            {
                Caption = 'Sync Catalog';
                ToolTip = 'Synchronize the catalog from Microsoft Learn.';
                Image = Refresh;

                trigger OnAction()
                var
                    CatalogSync: Codeunit "SEW Learn Catalog Sync";
                begin
                    CatalogSync.SyncFullCatalog();
                end;
            }
            action(FilterLearningModules)
            {
                Caption = 'Show Learning Modules';
                ToolTip = 'Filter to show only learning modules.';
                Image = FilterLines;

                trigger OnAction()
                begin
                    Rec.SetRange("Content Type", Rec."Content Type"::Module);
                    CurrPage.Update(false);
                end;
            }
            action(FilterLearningPaths)
            {
                Caption = 'Show Learning Paths';
                ToolTip = 'Filter to show only learning paths.';
                Image = FilterLines;

                trigger OnAction()
                begin
                    Rec.SetRange("Content Type", Rec."Content Type"::"Learning Path");
                    CurrPage.Update(false);
                end;
            }
            action(ResetFilter)
            {
                Caption = 'Show All';
                ToolTip = 'Remove filters and show all learning content.';
                Image = ClearFilter;

                trigger OnAction()
                begin
                    Rec.Reset();
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
