/// <summary>
/// Card page for viewing detailed error log entry including stack trace.
/// </summary>
page 71101 "SEW Error Log Card"
{
    PageType = Card;
    SourceTable = "SEW Error Log";
    Caption = 'Error Log Details';
    ApplicationArea = All;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Error Timestamp"; Rec."Error Timestamp")
                {
                }
                field(Severity; Rec.Severity)
                {
                    StyleExpr = SeverityStyle;
                }
                field("Error Message"; Rec."Error Message")
                {
                    MultiLine = true;
                }
                field("Context Info"; Rec."Context Info")
                {
                    MultiLine = true;
                }
            }
            group(Details)
            {
                Caption = 'Details';

                field("User ID"; Rec."User ID")
                {
                }
                field("Session ID"; Rec."Session ID")
                {
                }
                field("Company Name"; Rec."Company Name")
                {
                }
                field("Object ID"; Rec."Object ID")
                {
                }
            }
            group(StackTrace)
            {
                Caption = 'Stack Trace';

                field(StackTraceText; StackTraceText)
                {
                    Caption = 'Stack Trace';
                    ToolTip = 'Specifies the full call stack at the time of error.';
                    MultiLine = true;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CopyToClipboard)
            {
                Caption = 'Copy to Clipboard';
                ToolTip = 'Copy error details to clipboard.';
                Image = Copy;

                trigger OnAction()
                begin
                    Message('Copy functionality: Entry No. %1, Timestamp: %2, Severity: %3', Rec."Entry No.", Rec."Error Timestamp", Rec.Severity);
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(CopyToClipboard_Promoted; CopyToClipboard) { }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        StackTraceText := Rec.GetStackTrace();
        SetSeverityStyle();
    end;

    local procedure SetSeverityStyle()
    begin
        case Rec.Severity of
            Rec.Severity::Critical:
                SeverityStyle := Format(Pagestyle::Unfavorable);
            Rec.Severity::Error:
                SeverityStyle := Format(Pagestyle::Attention);
            Rec.Severity::Warning:
                SeverityStyle := Format(Pagestyle::AttentionAccent);
            Rec.Severity::Info:
                SeverityStyle := Format(Pagestyle::Standard);
        end;
    end;


    var
        StackTraceText: Text;
        SeverityStyle: Text;
}
