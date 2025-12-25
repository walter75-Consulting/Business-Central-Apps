/// <summary>
/// List page for viewing and filtering error log entries.
/// </summary>
page 71100 "SEW Error Log List"
{
    Caption = 'Error Log';
    PageType = List;
    SourceTable = "SEW Error Log";
    CardPageId = "SEW Error Log Card";
    UsageCategory = Administration;
    ApplicationArea = All;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Entries)
            {
                field("Entry No."; Rec."Entry No.") { }
                field("Error Timestamp"; Rec."Error Timestamp") { }
                field(Severity; Rec.Severity)
                {
                    StyleExpr = SeverityStyle;
                }
                field("Error Message"; Rec."Error Message") { }
                field("Context Info"; Rec."Context Info")
                {
                    Visible = false;
                }
                field("User ID"; Rec."User ID") { }
                field("Object ID"; Rec."Object ID")
                {
                    Visible = false;
                }
                field("Company Name"; Rec."Company Name")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ShowDetails)
            {
                Caption = 'Show Details';
                ToolTip = 'Open the error log card to view full details including stack trace.';
                Image = ViewDetails;

                trigger OnAction()
                begin
                    Page.Run(Page::"SEW Error Log Card", Rec);
                end;
            }
            action(DeleteOldEntries)
            {
                Caption = 'Delete Old Entries';
                ToolTip = 'Manually delete old error log entries. This is normally handled automatically by retention policy.';
                Image = Delete;

                trigger OnAction()
                var
                    ErrorLogRec: Record "SEW Error Log";
                    DaysToKeep: Integer;
                    CutoffDate: DateTime;
                    DeletedCount: Integer;
                begin
                    if not Confirm('Delete entries older than 30 days?', false) then
                        exit;

                    DaysToKeep := 30;
                    CutoffDate := CreateDateTime(Today() - DaysToKeep, 0T);

                    ErrorLogRec.SetFilter("Error Timestamp", '<%1', CutoffDate);
                    if ErrorLogRec.FindSet() then begin
                        DeletedCount := ErrorLogRec.Count();
                        ErrorLogRec.DeleteAll(true);
                        Message('%1 old entries deleted.', DeletedCount);
                    end else
                        Message('No old entries found.');
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(ShowDetails_Promoted; ShowDetails) { }
                actionref(DeleteOldEntries_Promoted; DeleteOldEntries) { }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetSeverityStyle();
    end;

    local procedure SetSeverityStyle()
    begin
        case Rec.Severity of
            Rec.Severity::Critical:
                SeverityStyle := Format(PageStyle::Unfavorable);
            Rec.Severity::Error:
                SeverityStyle := Format(PageStyle::Attention);
            Rec.Severity::Warning:
                SeverityStyle := Format(PageStyle::AttentionAccent);
            Rec.Severity::Info:
                SeverityStyle := Format(PageStyle::Standard);
        end;
    end;

    var
        SeverityStyle: Text;
}
