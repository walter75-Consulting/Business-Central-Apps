page 91722 "SEW Lead Scoring Models"
{
    Caption = 'Lead Scoring Models';
    PageType = List;
    SourceTable = "SEW Lead Scoring Model";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Model Code"; Rec."Model Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique code for the scoring model.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the scoring model.';
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this is the active scoring model. Only one model can be active.';
                }
                field("Decay Per Day"; Rec."Decay Per Day")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the points to subtract from intent score per day of inactivity.';
                }
                field("Band Hot Threshold"; Rec."Band Hot Threshold")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the minimum score for Hot band classification.';
                }
                field("Band Warm Threshold"; Rec."Band Warm Threshold")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the minimum score for Warm band classification.';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(ScoringRules)
            {
                Caption = 'Scoring Rules';
                Image = Setup;
                ToolTip = 'View and edit the scoring rules for this model.';
                ApplicationArea = All;
                RunObject = page "SEW Lead Scoring Rules";
                RunPageLink = "Model Code" = field("Model Code");
            }
        }
        area(Processing)
        {
            action(RecalculateAllScores)
            {
                Caption = 'Recalculate All Scores';
                Image = Calculate;
                ToolTip = 'Recalculate scores for all leads using this model.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    SEWLeadRec: Record "SEW Lead";
                    SEWScoringEngine: Codeunit "SEW Scoring Engine";
                    RecalcCountInt: Integer;
                begin
                    if not Confirm(RecalcConfirmQst) then
                        exit;

                    RecalcCountInt := 0;
                    if SEWLeadRec.FindSet(true) then
                        repeat
                            SEWScoringEngine.CalculateLeadScore(SEWLeadRec);
                            SEWLeadRec.Modify(true);
                            RecalcCountInt += 1;
                        until SEWLeadRec.Next() = 0;

                    Message(RecalcCompleteMsg, RecalcCountInt);
                end;
            }
        }
    }

    var
        RecalcConfirmQst: Label 'Recalculate scores for all leads? This may take several minutes.', Comment = 'DE="Bewertungen für alle Leads neu berechnen? Dies kann mehrere Minuten dauern."';
        RecalcCompleteMsg: Label 'Recalculated scores for %1 leads.', Comment = 'DE="Bewertungen für %1 Leads neu berechnet."';
}
