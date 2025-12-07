page 90838 "SEW Calc History List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = "SEW Calc History Entry";
    Caption = 'Calculation History';
    Editable = false;
    CardPageId = "SEW Calc Card";
    Permissions = tabledata "SEW Calc Header" = r;

    layout
    {
        area(Content)
        {
            repeater(HistoryEntries)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Calculation No."; Rec."Calculation No.")
                {
                }
                field("Version No."; Rec."Version No.")
                {
                }
                field("Change Type"; Rec."Change Type")
                {
                    StyleExpr = ChangeTypeStyle;
                }
                field("Change Date"; Rec."Change Date")
                {
                }
                field("Change Time"; Rec."Change Time")
                {
                }
                field("Changed By User"; Rec."Changed By User")
                {
                }
                field("Field Name"; Rec."Field Name")
                {
                }
                field("Old Value"; Rec."Old Value")
                {
                }
                field("New Value"; Rec."New Value")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field("Item Description"; Rec."Item Description")
                {
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Notes; Notes)
            {
            }
            systempart(Links; Links)
            {
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ShowCalculation)
            {
                Caption = 'Show Calculation';
                ToolTip = 'Opens the calculation card for this history entry.';
                Image = Document;
                ApplicationArea = All;

                trigger OnAction()
                var
                    CalcHeader: Record "SEW Calc Header";
                begin
                    if CalcHeader.Get(Rec."Calculation No.") then
                        Page.Run(Page::"SEW Calc Card", CalcHeader);
                end;
            }
            action(RestoreVersion)
            {
                Caption = 'Restore Version';
                ToolTip = 'Restores this version of the calculation.';
                Image = Restore;
                ApplicationArea = All;
                Enabled = Rec."Change Type" = Rec."Change Type"::Archived;

                trigger OnAction()
                begin
                    RestoreArchivedVersion();
                end;
            }
            action(CompareVersions)
            {
                Caption = 'Compare Versions';
                ToolTip = 'Compares this version with the current version.';
                Image = CompareCOA;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CompareWithCurrent();
                end;
            }
        }
        area(Navigation)
        {
            action(FilterByCalculation)
            {
                Caption = 'Filter by Calculation';
                ToolTip = 'Filters history entries for the selected calculation.';
                Image = Filter;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.SetCurrentKey("Calculation No.", "Change Date", "Change Time");
                    Rec.SetRange("Calculation No.", Rec."Calculation No.");
                end;
            }
            action(ClearFilters)
            {
                Caption = 'Clear Filters';
                ToolTip = 'Clears all filters.';
                Image = ClearFilter;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.Reset();
                end;
            }
        }

        area(Promoted)
        {
            group(Category_Category4)
            {
                Caption = 'Navigate';

                actionref(ShowCalculation_Promoted; ShowCalculation)
                {
                }
            }
        }
    }

    var
        ChangeTypeStyle: Text;

    trigger OnAfterGetRecord()
    begin
        UpdateChangeTypeStyle();
    end;

    local procedure UpdateChangeTypeStyle()
    begin
        case Rec."Change Type" of
            Rec."Change Type"::Created:
                ChangeTypeStyle := Format(PageStyle::Favorable);
            Rec."Change Type"::Modified:
                ChangeTypeStyle := Format(PageStyle::Standard);
            Rec."Change Type"::Archived:
                ChangeTypeStyle := Format(PageStyle::Attention);
            Rec."Change Type"::Deleted:
                ChangeTypeStyle := Format(PageStyle::Unfavorable);
            Rec."Change Type"::Released,
            Rec."Change Type"::"Quote Converted",
            Rec."Change Type"::"Production Finished":
                ChangeTypeStyle := Format(PageStyle::Strong);
        end;
    end;

    local procedure RestoreArchivedVersion()
    var
        ConfirmManagement: Codeunit "Confirm Management";
        ConfirmMsg: Label 'Do you want to restore this archived version? This will create a new version based on the archived data.';
    begin
        if not ConfirmManagement.GetResponseOrDefault(ConfirmMsg, false) then
            exit;

        // TODO: Implement restore logic
        Message('Restore functionality will be implemented');
    end;

    local procedure CompareWithCurrent()
    begin
        // TODO: Implement comparison logic
        Message('Compare functionality will be implemented');
    end;
}
