codeunit 91726 "SEW Scoring Engine"
{
    Permissions = tabledata "SEW Lead" = rm,
                  tabledata "SEW Lead Scoring Model" = r,
                  tabledata "SEW Lead Scoring Rule" = r,
                  tabledata "SEW Lead Activity" = r;

    procedure CalculateLeadScore(var SEWLeadRec: Record "SEW Lead")
    var
        SEWLeadScoringModel: Record "SEW Lead Scoring Model";
        FitScore: Integer;
        IntentScore: Integer;
    begin
        if not FindActiveScoringModel(SEWLeadScoringModel) then
            exit;

        FitScore := 0;
        IntentScore := 0;

        CalculateFitScore(SEWLeadRec, SEWLeadScoringModel, FitScore);
        CalculateIntentScore(SEWLeadRec, SEWLeadScoringModel, IntentScore);

        // Apply decay to Intent score based on inactivity
        IntentScore := ApplyDecay(SEWLeadRec, IntentScore, SEWLeadScoringModel."Decay Per Day");

        SEWLeadRec."Score (Fit)" := FitScore;
        SEWLeadRec."Score (Intent)" := IntentScore;
        SEWLeadRec."Score (Total)" := FitScore + IntentScore;

        UpdateScoreBand(SEWLeadRec, SEWLeadScoringModel);

        SEWLeadRec.Modify(true);
    end;

    local procedure FindActiveScoringModel(var SEWLeadScoringModel: Record "SEW Lead Scoring Model"): Boolean
    begin
        SEWLeadScoringModel.SetRange(Active, true);
        exit(SEWLeadScoringModel.FindFirst());
    end;

    local procedure CalculateFitScore(SEWLeadRec: Record "SEW Lead"; SEWLeadScoringModel: Record "SEW Lead Scoring Model"; var FitScore: Integer)
    var
        SEWLeadScoringRule: Record "SEW Lead Scoring Rule";
        IndustryGroup: Record "Industry Group";
    begin
        // Add industry score directly from Industry Group table
        if SEWLeadRec."Industry Group Code" <> '' then
            if IndustryGroup.Get(SEWLeadRec."Industry Group Code") then
                FitScore += IndustryGroup."SEW Lead Score";

        SEWLeadScoringRule.SetRange("Model Code", SEWLeadScoringModel."Model Code");
        SEWLeadScoringRule.SetRange("Is Fit Score", true);
        if SEWLeadScoringRule.FindSet() then
            repeat
                if EvaluateRule(SEWLeadRec, SEWLeadScoringRule) then
                    FitScore += SEWLeadScoringRule."Score Delta";
            until SEWLeadScoringRule.Next() = 0;
    end;

    local procedure CalculateIntentScore(SEWLeadRec: Record "SEW Lead"; SEWLeadScoringModel: Record "SEW Lead Scoring Model"; var IntentScore: Integer)
    var
        SEWLeadScoringRule: Record "SEW Lead Scoring Rule";
    begin
        SEWLeadScoringRule.SetRange("Model Code", SEWLeadScoringModel."Model Code");
        SEWLeadScoringRule.SetRange("Is Fit Score", false);
        if SEWLeadScoringRule.FindSet() then
            repeat
                if EvaluateRule(SEWLeadRec, SEWLeadScoringRule) then
                    IntentScore += SEWLeadScoringRule."Score Delta";
            until SEWLeadScoringRule.Next() = 0;
    end;

    local procedure EvaluateRule(SEWLeadRec: Record "SEW Lead"; SEWLeadScoringRule: Record "SEW Lead Scoring Rule"): Boolean
    var
        ContactRec: Record Contact;
        AttributeValue: Text;
    begin
        case SEWLeadScoringRule.Attribute of
            SEWLeadScoringRule.Attribute::Source:
                AttributeValue := SEWLeadRec."Source Code";
            SEWLeadScoringRule.Attribute::Industry:
                // Industry scoring handled directly in CalculateFitScore via Industry Group table
                exit(false);
            SEWLeadScoringRule.Attribute::Country:
                if SEWLeadRec."Contact No." <> '' then
                    if ContactRec.Get(SEWLeadRec."Contact No.") then
                        AttributeValue := ContactRec."Country/Region Code";
            SEWLeadScoringRule.Attribute::EmployeeCount:
                AttributeValue := Format(SEWLeadRec."Employee Count");
            SEWLeadScoringRule.Attribute::ExpectedRevenue:
                AttributeValue := Format(SEWLeadRec."Expected Revenue", 0, '<Integer>');
            SEWLeadScoringRule.Attribute::EmailOpen:
                if SEWLeadRec."Email Opened" then
                    AttributeValue := 'true'
                else
                    AttributeValue := 'false';
            SEWLeadScoringRule.Attribute::WebsiteVisit:
                if SEWLeadRec."Website Visit" then
                    AttributeValue := 'true'
                else
                    AttributeValue := 'false';
            SEWLeadScoringRule.Attribute::ActivityOutcome:
                exit(EvaluateActivityOutcome(SEWLeadRec, SEWLeadScoringRule));
            else
                exit(false);
        end;

        exit(CompareValues(AttributeValue, SEWLeadScoringRule.Value, SEWLeadScoringRule.Operator));
    end;

    local procedure EvaluateActivityOutcome(SEWLeadRec: Record "SEW Lead"; SEWLeadScoringRule: Record "SEW Lead Scoring Rule"): Boolean
    var
        SEWLeadActivity: Record "SEW Lead Activity";
        OutcomeText: Text;
    begin
        SEWLeadActivity.SetRange("Lead No.", SEWLeadRec."No.");
        SEWLeadActivity.SetRange(Completed, true);
        if SEWLeadActivity.FindLast() then begin
            OutcomeText := Format(SEWLeadActivity.Outcome);
            exit(CompareValues(OutcomeText, SEWLeadScoringRule.Value, SEWLeadScoringRule.Operator));
        end;
        exit(false);
    end;

    local procedure CompareValues(ActualValue: Text; ExpectedValue: Text; OperatorEnum: Enum "SEW Scoring Operator"): Boolean
    var
        ActualInt: Integer;
        ExpectedInt: Integer;
    begin
        case OperatorEnum of
            OperatorEnum::Equals:
                exit(ActualValue = ExpectedValue);
            OperatorEnum::Contains:
                exit(StrPos(UpperCase(ActualValue), UpperCase(ExpectedValue)) > 0);
            OperatorEnum::Greater:
                if Evaluate(ActualInt, ActualValue) and Evaluate(ExpectedInt, ExpectedValue) then
                    exit(ActualInt > ExpectedInt);
            OperatorEnum::Less:
                if Evaluate(ActualInt, ActualValue) and Evaluate(ExpectedInt, ExpectedValue) then
                    exit(ActualInt < ExpectedInt);
        end;
        exit(false);
    end;

    local procedure ApplyDecay(SEWLeadRec: Record "SEW Lead"; IntentScore: Integer; DecayPerDay: Integer): Integer
    var
        DaysSinceLastActivity: Integer;
        CreatedDate: Date;
    begin
        CreatedDate := DT2Date(SEWLeadRec.SystemCreatedAt);

        if SEWLeadRec."Last Activity Date" = 0D then
            DaysSinceLastActivity := Today() - CreatedDate
        else
            DaysSinceLastActivity := Today() - SEWLeadRec."Last Activity Date";

        exit(IntentScore - (DaysSinceLastActivity * DecayPerDay));
    end;

    local procedure UpdateScoreBand(var SEWLeadRec: Record "SEW Lead"; SEWLeadScoringModel: Record "SEW Lead Scoring Model")
    begin
        if SEWLeadRec."Score (Total)" >= SEWLeadScoringModel."Band Hot Threshold" then
            SEWLeadRec."Score Band" := SEWLeadRec."Score Band"::Hot
        else
            if SEWLeadRec."Score (Total)" >= SEWLeadScoringModel."Band Warm Threshold" then
                SEWLeadRec."Score Band" := SEWLeadRec."Score Band"::Warm
            else
                SEWLeadRec."Score Band" := SEWLeadRec."Score Band"::Cold;
    end;
}
