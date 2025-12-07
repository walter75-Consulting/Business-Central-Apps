page 90838 "SEW Calc History List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = "SEW Calc History Entry";
    Caption = 'Calculation History';
    Editable = false;
    CardPageId = "SEW Calc Card";

    layout
    {
        area(Content)
        {
            repeater(HistoryEntries)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique entry number for the history record';
                }
                field("Calculation No."; Rec."Calculation No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the calculation number this history entry belongs to';
                }
                field("Version No."; Rec."Version No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the version number of the calculation at the time of this change';
                }
                field("Change Type"; Rec."Change Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of change (Created, Modified, Archived, Deleted)';
                    StyleExpr = ChangeTypeStyle;
                }
                field("Change Date"; Rec."Change Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when the change was made';
                }
                field("Change Time"; Rec."Change Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the time when the change was made';
                }
                field("Changed By User"; Rec."Changed By User")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user who made the change';
                }
                field("Field Name"; Rec."Field Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the field that was changed';
                }
                field("Old Value"; Rec."Old Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value before the change';
                }
                field("New Value"; Rec."New Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value after the change';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item number from the calculation';
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item description from the calculation';
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Links; Links)
            {
                ApplicationArea = All;
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
                ToolTip = 'Opens the calculation card for this history entry';
                Image = Document;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Category4;

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
                ToolTip = 'Restores this version of the calculation';
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
                ToolTip = 'Compares this version with the current version';
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
                ToolTip = 'Filters history entries for the selected calculation';
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
                ToolTip = 'Clears all filters';
                Image = ClearFilter;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.Reset();
                end;
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
                ChangeTypeStyle := 'Favorable';
            Rec."Change Type"::Modified:
                ChangeTypeStyle := 'Standard';
            Rec."Change Type"::Archived:
                ChangeTypeStyle := 'Attention';
            Rec."Change Type"::Deleted:
                ChangeTypeStyle := 'Unfavorable';
            Rec."Change Type"::Released,
            Rec."Change Type"::"Quote Converted",
            Rec."Change Type"::"Production Finished":
                ChangeTypeStyle := 'Strong';
        end;
    end;

    local procedure RestoreArchivedVersion()
    var
        ConfirmMsg: Label 'Do you want to restore this archived version? This will create a new version based on the archived data.';
    begin
        if not Confirm(ConfirmMsg, false) then
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
