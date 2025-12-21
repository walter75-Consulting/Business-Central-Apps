page 91719 "SEW Lead Activity ListPart"
{
    Caption = 'Activities';
    PageType = ListPart;
    SourceTable = "SEW Lead Activity";
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
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
                field(Completed; Rec.Completed)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the activity is completed.';
                }
                field(Outcome; Rec.Outcome)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the outcome of the activity.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(NewActivity)
            {
                Caption = 'New Activity';
                Image = New;
                ToolTip = 'Create a new activity for this lead.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    SEWLeadActivityRec: Record "SEW Lead Activity";
                    LeadNoFilter: Code[20];
                begin
                    SEWLeadActivityRec.Init();
                    Evaluate(LeadNoFilter, Rec.GetFilter("Lead No."));
                    SEWLeadActivityRec."Lead No." := LeadNoFilter;
                    SEWLeadActivityRec.Insert(true);

                    if Page.RunModal(Page::"SEW Lead Activity Card", SEWLeadActivityRec) = Action::LookupOK then begin
                        CurrPage.Update(false);
                    end else begin
                        // User cancelled - delete the empty record
                        if SEWLeadActivityRec.Get(SEWLeadActivityRec."Entry No.") then
                            SEWLeadActivityRec.Delete(true);
                    end;
                end;
            }
            action(ViewActivity)
            {
                Caption = 'View';
                Image = View;
                ToolTip = 'View the selected activity details.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Page.Run(Page::"SEW Lead Activity Card", Rec);
                end;
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
