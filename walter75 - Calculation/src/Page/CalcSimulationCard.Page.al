page 90833 "SEW Calc Simulation Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "SEW Calc Simulation Header";
    Caption = 'Lot Size Simulation';
    UsageCategory = None;
    Extensible = true;
    Permissions = tabledata "SEW Calc Header" = r,
                  tabledata "SEW Calc Simulation Line" = rm;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field("Calc No."; Rec."Calc No.")
                {

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Item No."; Rec."Item No.")
                {
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                }
                field("Simulation Date"; Rec."Simulation Date")
                {
                    Editable = false;
                }
            }
            group(Parameters)
            {
                Caption = 'Simulation Parameters';

                field("Target Sales Price"; Rec."Target Sales Price")
                {
                }
                field("Target Margin %"; Rec."Target Margin %")
                {
                }
            }
            group(Results)
            {
                Caption = 'Results';

                field("No. of Scenarios"; Rec."No. of Scenarios")
                {
                    Editable = false;
                    Style = Strong;
                }
                field("Recommended Scenario Code"; Rec."Recommended Scenario Code")
                {
                    Editable = false;
                    Style = Favorable;
                    StyleExpr = Rec."Recommended Scenario Code" <> '';
                }
            }
            part(SimulationLines; "SEW Calc Simulation Subform")
            {
                SubPageLink = "Simulation No." = field("No.");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GenerateScenarios)
            {
                ApplicationArea = All;
                Caption = 'Generate Scenarios';
                ToolTip = 'Generate simulation scenarios with different lot sizes.';
                Image = CreateDocument;


                trigger OnAction()
                var
                    SimMgt: Codeunit "SEW Calc Simulation Mgt.";
                    LotSizes: List of [Decimal];
                begin
                    if Rec."Calc No." = '' then
                        Error(SelectCalcFirstErr);

                    // Generate default scenarios: Small (10), Medium (50), Large (100), X-Large (500), XX-Large (1000)
                    LotSizes.Add(10);
                    LotSizes.Add(50);
                    LotSizes.Add(100);
                    LotSizes.Add(500);
                    LotSizes.Add(1000);

                    SimMgt.CreateSimulation(Rec."Calc No.", LotSizes, Rec."Target Sales Price", Rec."Target Margin %");
                    CurrPage.Update(false);
                    Message('Simulation scenarios generated successfully');
                end;
            }
            action(RecalculateAll)
            {
                ApplicationArea = All;
                Caption = 'Recalculate All';
                ToolTip = 'Recalculate all scenarios and update recommendations.';
                Image = CalculateCalendar;

                trigger OnAction()
                var
                    SimLine: Record "SEW Calc Simulation Line";
                    CalcHeader: Record "SEW Calc Header";
                    SimMgt: Codeunit "SEW Calc Simulation Mgt.";
                begin
                    if not CalcHeader.Get(Rec."Calc No.") then
                        Error(CalcNotFoundErr, Rec."Calc No.");

                    SimLine.SetRange("Simulation No.", Rec."No.");
                    if SimLine.FindSet(true) then
                        repeat
                            SimMgt.CalculateScenario(SimLine, CalcHeader);
                            SimLine.Modify(true);
                        until SimLine.Next() = 0;

                    SimMgt.RecommendBestScenario(Rec."No.", Rec."Target Margin %");
                    CurrPage.Update(false);
                    Message('All scenarios recalculated');
                end;
            }
            action(OpenCalculation)
            {
                ApplicationArea = All;
                Caption = 'Open Calculation';
                ToolTip = 'Open the source calculation card.';
                Image = Card;

                trigger OnAction()
                var
                    CalcHeader: Record "SEW Calc Header";
                    CalcCardPage: Page "SEW Calc Card";
                begin
                    if CalcHeader.Get(Rec."Calc No.") then begin
                        CalcCardPage.SetRecord(CalcHeader);
                        CalcCardPage.Run();
                    end;
                end;
            }
        }

        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(GenerateScenarios_Promoted; GenerateScenarios)
                {
                }
                actionref(RecalculateAll_Promoted; RecalculateAll)
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Navigate';

                actionref(OpenCalculation_Promoted; OpenCalculation)
                {
                }
            }
        }
    }

    var
        SelectCalcFirstErr: Label 'Please select a calculation first', Comment = 'DE="Bitte wählen Sie zuerst eine Kalkulation"';
        CalcNotFoundErr: Label 'Calculation %1 not found', Comment = 'DE="Kalkulation %1 nicht gefunden"';
}
