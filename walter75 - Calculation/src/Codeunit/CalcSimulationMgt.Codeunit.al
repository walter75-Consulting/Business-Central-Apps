codeunit 90854 "SEW Calc Simulation Mgt."
{
    Permissions = tabledata "SEW Calc Simulation Header" = rimd,
                  tabledata "SEW Calc Simulation Line" = rimd,
                  tabledata "SEW Calc Header" = r;



    procedure CreateSimulation(CalcNo: Code[20]; LotSizes: List of [Decimal]; TargetSalesPrice: Decimal; TargetMargin: Decimal): Code[20]
    var
        SimHeader: Record "SEW Calc Simulation Header";
        SimLine: Record "SEW Calc Simulation Line";
        CalcHeader: Record "SEW Calc Header";
        LineNo: Integer;
        LotSize: Decimal;
    begin
        if not CalcHeader.Get(CalcNo) then
            Error('Calculation %1 not found', CalcNo);

        // Create simulation header
        SimHeader.Init();
        SimHeader."No." := GetNextSimulationNo();
        SimHeader."Calc No." := CalcNo;
        SimHeader.Validate("Calc No.");
        SimHeader."Target Sales Price" := TargetSalesPrice;
        SimHeader."Target Margin %" := TargetMargin;
        SimHeader.Insert(true);

        // Create simulation lines for each lot size
        LineNo := 10000;
        foreach LotSize in LotSizes do begin
            SimLine.Init();
            SimLine."Simulation No." := SimHeader."No.";
            SimLine."Line No." := LineNo;
            SimLine."Scenario Code" := GetScenarioCode(LineNo div 10000);
            SimLine."Lot Size" := LotSize;
            SimLine.Insert(true);

            // Calculate costs for this scenario
            CalculateScenario(SimLine, CalcHeader);
            SimLine.Modify(true);

            LineNo += 10000;
        end;

        // Determine recommended scenario
        RecommendBestScenario(SimHeader."No.", TargetMargin);

        exit(SimHeader."No.");
    end;

    procedure CalculateScenario(var SimLine: Record "SEW Calc Simulation Line"; CalcHeader: Record "SEW Calc Header")
    var
        MaterialCost: Decimal;
        LaborCost: Decimal;
        OverheadCost: Decimal;
        UnitMaterialCost: Decimal;
        UnitLaborCost: Decimal;
        UnitOverheadCost: Decimal;
    begin
        // Get base costs from calculation (these are regular fields, not FlowFields)
        // Base unit costs (from original calculation lot size)
        if CalcHeader."Lot Size" > 0 then begin
            UnitMaterialCost := CalcHeader."Total Material Cost" / CalcHeader."Lot Size";
            UnitLaborCost := CalcHeader."Total Labor Cost" / CalcHeader."Lot Size";
            UnitOverheadCost := CalcHeader."Total Overhead Cost" / CalcHeader."Lot Size";
        end;

        // Calculate total costs for new lot size
        MaterialCost := UnitMaterialCost * SimLine."Lot Size";
        LaborCost := UnitLaborCost * SimLine."Lot Size";
        OverheadCost := UnitOverheadCost * SimLine."Lot Size";

        // Apply setup cost (fixed cost per lot)
        SimLine."Material Cost" := MaterialCost;
        SimLine."Labor Cost" := LaborCost;
        SimLine."Overhead Cost" := OverheadCost;
        SimLine."Total Cost" := MaterialCost + LaborCost + OverheadCost + SimLine."Setup Cost";

        // Calculate unit cost
        if SimLine."Lot Size" > 0 then
            SimLine."Unit Cost" := SimLine."Total Cost" / SimLine."Lot Size"
        else
            SimLine."Unit Cost" := 0;

        // Calculate suggested sales price based on target margin
        CalculateSuggestedPrice(SimLine);

        // Calculate break-even quantity
        CalculateBreakEven(SimLine, UnitMaterialCost, UnitLaborCost, UnitOverheadCost);
    end;

    local procedure CalculateSuggestedPrice(var SimLine: Record "SEW Calc Simulation Line")
    var
        SimHeader: Record "SEW Calc Simulation Header";
    begin
        if not SimHeader.Get(SimLine."Simulation No.") then
            exit;

        if SimHeader."Target Sales Price" > 0 then
            // Use predefined target price
            SimLine."Suggested Sales Price" := SimHeader."Target Sales Price"
        else
            if SimHeader."Target Margin %" > 0 then
                // Calculate price from target margin: Price = Cost / (1 - Margin%)
                SimLine."Suggested Sales Price" := SimLine."Unit Cost" / (1 - (SimHeader."Target Margin %" / 100))
            else
                // No target defined, use cost + 25% markup
                SimLine."Suggested Sales Price" := SimLine."Unit Cost" * 1.25;

        SimLine.Validate("Suggested Sales Price");
    end;

    local procedure CalculateBreakEven(var SimLine: Record "SEW Calc Simulation Line"; UnitMaterialCost: Decimal; UnitLaborCost: Decimal; UnitOverheadCost: Decimal)
    var
        UnitVariableCost: Decimal;
        ContributionMargin: Decimal;
    begin
        // Break-even: Fixed Costs / (Sales Price - Variable Cost per Unit)
        UnitVariableCost := UnitMaterialCost + UnitLaborCost + UnitOverheadCost;

        if SimLine."Suggested Sales Price" > UnitVariableCost then begin
            ContributionMargin := SimLine."Suggested Sales Price" - UnitVariableCost;
            if ContributionMargin > 0 then
                SimLine."Break-Even Quantity" := SimLine."Setup Cost" / ContributionMargin;
        end else
            SimLine."Break-Even Quantity" := 0;
    end;

    procedure RecommendBestScenario(SimulationNo: Code[20]; TargetMargin: Decimal)
    var
        SimLine: Record "SEW Calc Simulation Line";
        BestLine: Record "SEW Calc Simulation Line";
        SimHeader: Record "SEW Calc Simulation Header";
        BestScore: Decimal;
        CurrentScore: Decimal;
    begin
        SimLine.SetRange("Simulation No.", SimulationNo);
        if not SimLine.FindSet() then
            exit;

        BestScore := -9999;

        repeat
            // Calculate recommendation score
            // Factors: Margin %, proximity to break-even, unit cost
            CurrentScore := 0;

            // +100 points for each percentage point of margin above target
            if SimLine."Margin %" > TargetMargin then
                CurrentScore += (SimLine."Margin %" - TargetMargin) * 100;

            // -50 points for each percentage point of margin below target
            if SimLine."Margin %" < TargetMargin then
                CurrentScore -= (TargetMargin - SimLine."Margin %") * 50;

            // +10 points if lot size is above break-even
            if (SimLine."Break-Even Quantity" > 0) and (SimLine."Lot Size" >= SimLine."Break-Even Quantity") then
                CurrentScore += 10;

            // Prefer lower unit costs (normalized score)
            if SimLine."Unit Cost" > 0 then
                CurrentScore += (1000 / SimLine."Unit Cost");

            SimLine."Recommendation Score" := CurrentScore;
            SimLine.Modify();

            if CurrentScore > BestScore then begin
                BestScore := CurrentScore;
                BestLine := SimLine;
            end;
        until SimLine.Next() = 0;

        // Mark the best scenario as recommended
        if BestLine."Line No." > 0 then begin
            SimLine.SetRange("Simulation No.", SimulationNo);
            SimLine.ModifyAll("Is Recommended", false);

            // Reload BestLine to ensure database connection
            if SimLine.Get(BestLine."Simulation No.", BestLine."Line No.") then begin
                SimLine."Is Recommended" := true;
                SimLine.Modify();
            end;

            if SimHeader.Get(SimulationNo) then begin
                SimHeader."Recommended Scenario Code" := BestLine."Scenario Code";
                SimHeader.Modify();
            end;
        end;
    end;

    local procedure GetNextSimulationNo(): Code[20]
    var
        SimHeader: Record "SEW Calc Simulation Header";
    begin
        // For now, use simple counter-based numbering
        // TODO: Implement proper number series
        SimHeader.SetCurrentKey("No.");
        if SimHeader.FindLast() then
            exit(IncStr(SimHeader."No."))
        else
            exit('SIM-00001');
    end;

    local procedure GetScenarioCode(Index: Integer): Code[20]
    begin
        case Index of
            1:
                exit('SMALL');
            2:
                exit('MEDIUM');
            3:
                exit('LARGE');
            4:
                exit('X-LARGE');
            5:
                exit('XX-LARGE');
            else
                exit('SCENARIO-' + Format(Index));
        end;
    end;

    procedure CompareScenarios(SimulationNo: Code[20])
    var
        SimLine: Record "SEW Calc Simulation Line";
    begin
        // This will be used by the UI to display comparison matrix
        SimLine.SetRange("Simulation No.", SimulationNo);
        SimLine.SetCurrentKey("Simulation No.", "Line No.");
        if SimLine.FindSet() then
            repeat
            // UI will handle display
            until SimLine.Next() = 0;
    end;
}
