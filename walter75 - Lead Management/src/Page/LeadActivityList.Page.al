page 91717 "SEW Lead Activity List"
{
    Caption = 'Lead Activities';
    PageType = List;
    SourceTable = "SEW Lead Activity";
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
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
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of activity.';
                }
                field(Subject; Rec.Subject)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the subject or title of the activity.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the activity is due.';
                    StyleExpr = DueDateStyle;
                }
                field("Start DateTime"; Rec."Start DateTime")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the start date and time for meetings.';
                    Visible = false;
                }
                field("End DateTime"; Rec."End DateTime")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the end date and time for meetings.';
                    Visible = false;
                }
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
                field("User Name"; Rec."User Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the user assigned to this activity.';
                }
                field("Duration (Minutes)"; Rec."Duration (Minutes)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the duration of the activity in minutes.';
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
            action(MarkCompleted)
            {
                Caption = 'Mark Completed';
                Image = Approve;
                ToolTip = 'Mark the selected activity as completed.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.Completed := true;
                    Rec."Completed Date" := Today();
                    Rec.Modify(true);
                    CurrPage.Update(false);
                end;
            }
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
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(MarkCompleted_Promoted; MarkCompleted)
                {
                }
                actionref(ViewLead_Promoted; ViewLead)
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetDueDateStyle();
    end;

    local procedure SetDueDateStyle()
    begin
        DueDateStyle := 'Standard';

        if not Rec.Completed then
            if Rec."Due Date" < Today() then
                DueDateStyle := 'Unfavorable'
            else
                if Rec."Due Date" = Today() then
                    DueDateStyle := 'Attention';
    end;

    var
        DueDateStyle: Text;
}
