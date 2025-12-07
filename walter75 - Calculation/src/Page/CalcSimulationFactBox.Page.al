page 90837 "SEW Calc Simulation FactBox"
{
    PageType = CardPart;
    SourceTable = "SEW Calc Simulation Line";
    Caption = 'Recommended Scenario';
    Extensible = true;

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
                    ApplicationArea = All;
                    Caption = 'Scenario';
                    ToolTip = 'Specifies the recommended scenario code';
                    Style = Favorable;
                    StyleExpr = true;
                }
                field("Lot Size"; Rec."Lot Size")
                {
                    ApplicationArea = All;
                    Caption = 'Lot Size';
                    ToolTip = 'Specifies the recommended lot size';
                    Style = Strong;
                    StyleExpr = true;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Cost';
                    ToolTip = 'Specifies the unit cost for this scenario';
                }
                field("Suggested Sales Price"; Rec."Suggested Sales Price")
                {
                    ApplicationArea = All;
                    Caption = 'Suggested Sales Price';
                    ToolTip = 'Specifies the suggested sales price';
                }
                field("Margin %"; Rec."Margin %")
                {
                    ApplicationArea = All;
                    Caption = 'Margin %';
                    ToolTip = 'Specifies the margin percentage';
                    Style = Favorable;
                    StyleExpr = Rec."Margin %" > 0;
                }
                field("Break-Even Quantity"; Rec."Break-Even Quantity")
                {
                    ApplicationArea = All;
                    Caption = 'Break-Even Qty';
                    ToolTip = 'Specifies the break-even quantity';
                }
                field("Recommendation Score"; Rec."Recommendation Score")
                {
                    ApplicationArea = All;
                    Caption = 'Score';
                    ToolTip = 'Specifies the recommendation score';
                }
            }
            group(NoRecommendation)
            {
                Caption = 'No Recommendation';
                Visible = not HasRecommendation;

                field(NoRecommendationText; 'No recommended scenario available')
                {
                    ApplicationArea = All;
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
