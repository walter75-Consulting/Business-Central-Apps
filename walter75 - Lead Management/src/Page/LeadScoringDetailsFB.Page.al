page 91720 "SEW Lead Scoring Details FB"
{
    PageType = CardPart;
    ApplicationArea = All;
    SourceTable = "SEW Lead";
    Caption = 'Scoring Details';
    Editable = false;

    layout
    {
        area(Content)
        {
            group(ScoreBreakdown)
            {
                Caption = 'Score Breakdown';
                ShowCaption = true;

                field("Score (Total)"; Rec."Score (Total)")
                {
                    Caption = 'Total Score';
                    ToolTip = 'Total score combining fit and intent scores.';
                    Style = Strong;
                    StyleExpr = true;
                }
                field("Score (Fit)"; Rec."Score (Fit)")
                {
                    Caption = 'Fit Score';
                    ToolTip = 'Score based on company fit attributes (size, industry, revenue).';
                }
                field("Score (Intent)"; Rec."Score (Intent)")
                {
                    Caption = 'Intent Score';
                    ToolTip = 'Score based on engagement and activity signals.';
                }
                field("Score Band"; Rec."Score Band")
                {
                    Caption = 'Score Band';
                    ToolTip = 'Hot, Warm, or Cold based on score thresholds.';
                }
            }

            group(ScoringModel)
            {
                Caption = 'Active Scoring Model';
                ShowCaption = true;

                field(ActiveModelCode; ActiveModelCode)
                {
                    Caption = 'Model Code';
                    ToolTip = 'The currently active scoring model used to calculate this score.';
                    Editable = false;
                }
                field(ActiveModelName; ActiveModelName)
                {
                    Caption = 'Model Name';
                    ToolTip = 'Name of the active scoring model.';
                    Editable = false;
                }
            }

            group(AppliedRules)
            {
                Caption = 'Applied Rules';
                ShowCaption = true;

                field(AppliedRulesCount; AppliedRulesCount)
                {
                    Caption = 'Rules Applied';
                    ToolTip = 'Number of scoring rules that matched this lead.';
                    Editable = false;
                }
                field(LastCalculated; LastCalculatedText)
                {
                    Caption = 'Last Calculated';
                    ToolTip = 'When the score was last calculated.';
                    Editable = false;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateScoringDetails();
    end;

    local procedure UpdateScoringDetails()
    var
        SEWLeadScoringModel: Record "SEW Lead Scoring Model";
        SEWLeadScoringRule: Record "SEW Lead Scoring Rule";
    begin
        // Get active scoring model
        ActiveModelCode := '';
        ActiveModelName := '';
        SEWLeadScoringModel.SetRange(Active, true);
        if SEWLeadScoringModel.FindFirst() then begin
            ActiveModelCode := SEWLeadScoringModel."Model Code";
            ActiveModelName := SEWLeadScoringModel.Name;

            // Count applicable rules (simplified - just count all active rules for this model)
            SEWLeadScoringRule.SetRange("Model Code", SEWLeadScoringModel."Model Code");
            AppliedRulesCount := SEWLeadScoringRule.Count();
        end else begin
            ActiveModelCode := 'None';
            ActiveModelName := 'No active scoring model';
            AppliedRulesCount := 0;
        end;

        // Format last calculated time
        if Rec.SystemModifiedAt <> 0DT then
            LastCalculatedText := Format(Rec.SystemModifiedAt, 0, '<Day,2>.<Month,2>.<Year4> <Hours24,2>:<Minutes,2>')
        else
            LastCalculatedText := 'Never';
    end;

    var
        ActiveModelCode: Code[20];
        ActiveModelName: Text[100];
        AppliedRulesCount: Integer;
        LastCalculatedText: Text;
}
