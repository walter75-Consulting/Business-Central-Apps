page 90837 "SEW Calc Simulation FactBox"
{
    PageType = CardPart;
    SourceTable = "SEW Calc Simulation Line";
    Caption = 'Recommended Scenario';
    Extensible = true;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(Recommendation)
            {
                Caption = 'Recommended Scenario';
                Visible = HasRecommendation;

                field("Scenario Code"; Rec."Scenario Code")
                {
                    Style = Favorable;
                    StyleExpr = true;
                }
                field("Lot Size"; Rec."Lot Size")
                {
                    Style = Strong;
                    StyleExpr = true;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                }
                field("Suggested Sales Price"; Rec."Suggested Sales Price")
                {
                }
                field("Margin %"; Rec."Margin %")
                {
                    Style = Favorable;
                    StyleExpr = Rec."Margin %" > 0;
                }
                field("Break-Even Quantity"; Rec."Break-Even Quantity")
                {
                }
                field("Recommendation Score"; Rec."Recommendation Score")
                {
                }
            }
            group(NoRecommendation)
            {
                Caption = 'No Recommendation';
                Visible = not HasRecommendation;

                field(NoRecommendationText; 'No recommended scenario available')
                {
                    ShowCaption = false;
                    Editable = false;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        HasRecommendation := Rec."Is Recommended";
    end;

    trigger OnOpenPage()
    var
        SEWCalcSimulationLine: Record "SEW Calc Simulation Line";
    begin
        // Find and display the recommended scenario
        SEWCalcSimulationLine.SetRange("Simulation No.", Rec."Simulation No.");
        SEWCalcSimulationLine.SetRange("Is Recommended", true);
        if SEWCalcSimulationLine.FindFirst() then begin
            Rec := SEWCalcSimulationLine;
            HasRecommendation := true;
        end else
            HasRecommendation := false;
    end;

    var
        HasRecommendation: Boolean;
}
