page 91718 "SEW Lead Activity Card"
{
    Caption = 'Lead Activity';
    PageType = Card;
    SourceTable = "SEW Lead Activity";
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
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique entry number for the activity.';
                    Editable = false;
                }
                field("Lead No."; Rec."Lead No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the lead this activity is associated with.';
                    Importance = Promoted;
                }
                field("Contact No."; Rec."Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the contact associated with the lead.';
                    Editable = false;
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of activity.';
                    Importance = Promoted;
                }
                field(Subject; Rec.Subject)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the subject or title of the activity.';
                    Importance = Promoted;
                }
                field("User Name"; Rec."User Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the user assigned to this activity.';
                }
            }
            group(Details)
            {
                Caption = 'Details';

                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the activity is due.';
                }
                field("Start DateTime"; Rec."Start DateTime")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the start date and time for meetings.';
                }
                field("End DateTime"; Rec."End DateTime")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the end date and time for meetings.';
                }
                field("Duration (Minutes)"; Rec."Duration (Minutes)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the duration of the activity in minutes.';
                }
                field(Notes; Rec.Notes)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies additional notes about the activity.';
                    MultiLine = true;
                }
            }
            group(Completion)
            {
                Caption = 'Completion';

                field(Completed; Rec.Completed)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the activity is completed.';
                }
                field("Completed Date"; Rec."Completed Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the activity was completed.';
                    Editable = false;
                }
                field(Outcome; Rec.Outcome)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the outcome of the activity.';
                }
            }
            group(Integration)
            {
                Caption = 'Integration';

                field("External Item ID"; Rec."External Item ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the external reference ID for Outlook/Teams integration.';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(ViewLead)
            {
                Caption = 'View Lead';
                Image = List;
                ToolTip = 'View the associated lead.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    SEWLeadRec: Record "SEW Lead";
                begin
                    if SEWLeadRec.Get(Rec."Lead No.") then
                        Page.Run(Page::"SEW Lead Card", SEWLeadRec);
                end;
            }
        }
    }
}
