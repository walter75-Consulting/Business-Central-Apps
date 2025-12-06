page 90833 "SEW Calc Simulation Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "SEW Calc Simulation Header";
    Caption = 'Lot Size Simulation';
    UsageCategory = None;
    Extensible = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'Simulation No.';
                    ToolTip = 'Specifies the simulation number';
                    Editable = false;
                }
                field("Calc No."; Rec."Calc No.")
                {
                    ApplicationArea = All;
                    Caption = 'Calculation No.';
                    ToolTip = 'Specifies the calculation this simulation is based on';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Caption = 'Item No.';
                    ToolTip = 'Specifies the item number';
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    ToolTip = 'Specifies the description';
                }
                field("Simulation Date"; Rec."Simulation Date")
                {
                    ApplicationArea = All;
                    Caption = 'Simulation Date';
                    ToolTip = 'Specifies when this simulation was created';
                    Editable = false;
                }
            }
            group(Parameters)
            {
                Caption = 'Simulation Parameters';

                field("Target Sales Price"; Rec."Target Sales Price")
                {
                    ApplicationArea = All;
                    Caption = 'Target Sales Price';
                    ToolTip = 'Specifies the target sales price to aim for. Leave blank to use target margin instead.';
                }
                field("Target Margin %"; Rec."Target Margin %")
                {
                    ApplicationArea = All;
                    Caption = 'Target Margin %';
                    ToolTip = 'Specifies the target margin percentage. Used if Target Sales Price is blank.';
                }
            }
            group(Results)
            {
                Caption = 'Results';

                field("No. of Scenarios"; Rec."No. of Scenarios")
                {
                    ApplicationArea = All;
                    Caption = 'No. of Scenarios';
                    ToolTip = 'Specifies the number of scenarios in this simulation';
                    Editable = false;
                    Style = Strong;
                }
                field("Recommended Scenario Code"; Rec."Recommended Scenario Code")
                {
                    ApplicationArea = All;
                    Caption = 'Recommended Scenario';
                    ToolTip = 'Specifies the recommended scenario code based on the optimization algorithm';
                    Editable = false;
                    Style = Favorable;
                    StyleExpr = Rec."Recommended Scenario Code" <> '';
                }
            }
            part(SimulationLines; "SEW Calc Simulation Subform")
            {
                ApplicationArea = All;
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
                ToolTip = 'Generate simulation scenarios with different lot sizes';
                Image = CreateDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SimMgt: Codeunit "SEW Calc Simulation Mgt.";
                    LotSizes: List of [Decimal];
                begin
                    if Rec."Calc No." = '' then
                        Error('Please select a calculation first');

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
                ToolTip = 'Recalculate all scenarios and update recommendations';
                Image = CalculateCalendar;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    SimLine: Record "SEW Calc Simulation Line";
                    CalcHeader: Record "SEW Calc Header";
                    SimMgt: Codeunit "SEW Calc Simulation Mgt.";
                begin
                    if not CalcHeader.Get(Rec."Calc No.") then
                        Error('Calculation %1 not found', Rec."Calc No.");

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
                ToolTip = 'Open the source calculation card';
                Image = Card;
                Promoted = true;
                PromotedCategory = Category4;

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
    }
}
