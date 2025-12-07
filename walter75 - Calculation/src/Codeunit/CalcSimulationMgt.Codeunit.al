codeunit 90854 "SEW Calc Simulation Mgt."
{
    Permissions = tabledata "SEW Calc Simulation Header" = rimd,
                  tabledata "SEW Calc Simulation Line" = rimd,
                  tabledata "SEW Calc Header" = r;



    procedure CreateSimulation(CalcNo: Code[20]; LotSizes: List of [Decimal]; TargetSalesPrice: Decimal; TargetMargin: Decimal): Code[20]
    var
        SEWCalcSimulationHeader: Record "SEW Calc Simulation Header";
        SEWCalcSimulationLine: Record "SEW Calc Simulation Line";
        SEWCalcHeader: Record "SEW Calc Header";
        LineNo: Integer;
        LotSize: Decimal;
    begin
        if not SEWCalcHeader.Get(CalcNo) then
            Error('Calculation %1 not found', CalcNo);

        // Create simulation header
        SEWCalcSimulationHeader.Init();
        SEWCalcSimulationHeader."No." := GetNextSimulationNo();
        SEWCalcSimulationHeader."Calc No." := CalcNo;
        SEWCalcSimulationHeader.Validate("Calc No.");
        SEWCalcSimulationHeader."Target Sales Price" := TargetSalesPrice;
        SEWCalcSimulationHeader."Target Margin %" := TargetMargin;
        SEWCalcSimulationHeader.Insert(true);

        // Create simulation lines for each lot size
        LineNo := 10000;
        foreach LotSize in LotSizes do begin
            SEWCalcSimulationLine.Init();
            SEWCalcSimulationLine."Simulation No." := SEWCalcSimulationHeader."No.";
            SEWCalcSimulationLine."Line No." := LineNo;
            SEWCalcSimulationLine."Scenario Code" := GetScenarioCode(LineNo div 10000);
            SEWCalcSimulationLine."Lot Size" := LotSize;
            SEWCalcSimulationLine.Insert(true);

            // Calculate costs for this scenario
            CalculateScenario(SEWCalcSimulationLine, SEWCalcHeader);
            SEWCalcSimulationLine.Modify(true);

            LineNo += 10000;
        end;

        // Determine recommended scenario
        RecommendBestScenario(SEWCalcSimulationHeader."No.", TargetMargin);

        exit(SEWCalcSimulationHeader."No.");
    end;

    procedure CalculateScenario(var SEWCalcSimulationLine: Record "SEW Calc Simulation Line"; SEWCalcHeader: Record "SEW Calc Header")
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
        if SEWCalcHeader."Lot Size" > 0 then begin
            UnitMaterialCost := SEWCalcHeader."Total Material Cost" / SEWCalcHeader."Lot Size";
            UnitLaborCost := SEWCalcHeader."Total Labor Cost" / SEWCalcHeader."Lot Size";
            UnitOverheadCost := SEWCalcHeader."Total Overhead Cost" / SEWCalcHeader."Lot Size";
        end;

        // Calculate total costs for new lot size
        MaterialCost := UnitMaterialCost * SEWCalcSimulationLine."Lot Size";
        LaborCost := UnitLaborCost * SEWCalcSimulationLine."Lot Size";
        OverheadCost := UnitOverheadCost * SEWCalcSimulationLine."Lot Size";

        // Apply setup cost (fixed cost per lot)
        SEWCalcSimulationLine."Material Cost" := MaterialCost;
        SEWCalcSimulationLine."Labor Cost" := LaborCost;
        SEWCalcSimulationLine."Overhead Cost" := OverheadCost;
        SEWCalcSimulationLine."Total Cost" := MaterialCost + LaborCost + OverheadCost + SEWCalcSimulationLine."Setup Cost";

        // Calculate unit cost
        if SEWCalcSimulationLine."Lot Size" > 0 then
            SEWCalcSimulationLine."Unit Cost" := SEWCalcSimulationLine."Total Cost" / SEWCalcSimulationLine."Lot Size"
        else
            SEWCalcSimulationLine."Unit Cost" := 0;

        // Calculate suggested sales price based on target margin
        CalculateSuggestedPrice(SEWCalcSimulationLine);

        // Calculate break-even quantity
        CalculateBreakEven(SEWCalcSimulationLine, UnitMaterialCost, UnitLaborCost, UnitOverheadCost);
    end;

    local procedure CalculateSuggestedPrice(var SEWCalcSimulationLine: Record "SEW Calc Simulation Line")
    var
        SEWCalcSimulationHeader: Record "SEW Calc Simulation Header";
    begin
        if not SEWCalcSimulationHeader.Get(SEWCalcSimulationLine."Simulation No.") then
            exit;

        if SEWCalcSimulationHeader."Target Sales Price" > 0 then
            // Use predefined target price
            SEWCalcSimulationLine."Suggested Sales Price" := SEWCalcSimulationHeader."Target Sales Price"
        else
            if SEWCalcSimulationHeader."Target Margin %" > 0 then
                // Calculate price from target margin: Price = Cost / (1 - Margin%)
                SEWCalcSimulationLine."Suggested Sales Price" := SEWCalcSimulationLine."Unit Cost" / (1 - (SEWCalcSimulationHeader."Target Margin %" / 100))
            else
                // No target defined, use cost + 25% markup
                SEWCalcSimulationLine."Suggested Sales Price" := SEWCalcSimulationLine."Unit Cost" * 1.25;

        SEWCalcSimulationLine.Validate("Suggested Sales Price");
    end;

    local procedure CalculateBreakEven(var SEWCalcSimulationLine: Record "SEW Calc Simulation Line"; UnitMaterialCost: Decimal; UnitLaborCost: Decimal; UnitOverheadCost: Decimal)
    var
        UnitVariableCost: Decimal;
        ContributionMargin: Decimal;
    begin
        // Break-even: Fixed Costs / (Sales Price - Variable Cost per Unit)
        UnitVariableCost := UnitMaterialCost + UnitLaborCost + UnitOverheadCost;

        if SEWCalcSimulationLine."Suggested Sales Price" > UnitVariableCost then begin
            ContributionMargin := SEWCalcSimulationLine."Suggested Sales Price" - UnitVariableCost;
            if ContributionMargin > 0 then
                SEWCalcSimulationLine."Break-Even Quantity" := SEWCalcSimulationLine."Setup Cost" / ContributionMargin;
        end else
            SEWCalcSimulationLine."Break-Even Quantity" := 0;
    end;

    procedure RecommendBestScenario(SimulationNo: Code[20]; TargetMargin: Decimal)
    var
        SEWCalcSimulationLine: Record "SEW Calc Simulation Line";
        SEWCalcSimulationLineBest: Record "SEW Calc Simulation Line";
        SEWCalcSimulationHeader: Record "SEW Calc Simulation Header";
        BestScore: Decimal;
        CurrentScore: Decimal;
    begin
        SEWCalcSimulationLine.SetRange("Simulation No.", SimulationNo);
        if not SEWCalcSimulationLine.FindSet() then
            exit;

        BestScore := -9999;

        repeat
            // Calculate recommendation score
            // Factors: Margin %, proximity to break-even, unit cost
            CurrentScore := 0;

            // +100 points for each percentage point of margin above target
            if SEWCalcSimulationLine."Margin %" > TargetMargin then
                CurrentScore += (SEWCalcSimulationLine."Margin %" - TargetMargin) * 100;

            // -50 points for each percentage point of margin below target
            if SEWCalcSimulationLine."Margin %" < TargetMargin then
                CurrentScore -= (TargetMargin - SEWCalcSimulationLine."Margin %") * 50;

            // +10 points if lot size is above break-even
            if (SEWCalcSimulationLine."Break-Even Quantity" > 0) and (SEWCalcSimulationLine."Lot Size" >= SEWCalcSimulationLine."Break-Even Quantity") then
                CurrentScore += 10;

            // Prefer lower unit costs (normalized score)
            if SEWCalcSimulationLine."Unit Cost" > 0 then
                CurrentScore += (1000 / SEWCalcSimulationLine."Unit Cost");

            SEWCalcSimulationLine."Recommendation Score" := CurrentScore;
            SEWCalcSimulationLine.Modify();

            if CurrentScore > BestScore then begin
                BestScore := CurrentScore;
                SEWCalcSimulationLineBest := SEWCalcSimulationLine;
            end;
        until SEWCalcSimulationLine.Next() = 0;

        // Mark the best scenario as recommended
        if SEWCalcSimulationLineBest."Line No." > 0 then begin
            SEWCalcSimulationLine.SetRange("Simulation No.", SimulationNo);
            SEWCalcSimulationLine.ModifyAll("Is Recommended", false);

            // Reload BestLine to ensure database connection
            if SEWCalcSimulationLine.Get(SEWCalcSimulationLineBest."Simulation No.", SEWCalcSimulationLineBest."Line No.") then begin
                SEWCalcSimulationLine."Is Recommended" := true;
                SEWCalcSimulationLine.Modify();
            end;

            if SEWCalcSimulationHeader.Get(SimulationNo) then begin
                SEWCalcSimulationHeader."Recommended Scenario Code" := SEWCalcSimulationLineBest."Scenario Code";
                SEWCalcSimulationHeader.Modify();
            end;
        end;
    end;

    local procedure GetNextSimulationNo(): Code[20]
    var
        SEWCalcSimulationHeader: Record "SEW Calc Simulation Header";
    begin
        // For now, use simple counter-based numbering
        // TODO: Implement proper number series
        SEWCalcSimulationHeader.SetCurrentKey("No.");
        if SEWCalcSimulationHeader.FindLast() then
            exit(IncStr(SEWCalcSimulationHeader."No."))
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
        SEWCalcSimulationLine: Record "SEW Calc Simulation Line";
    begin
        // This will be used by the UI to display comparison matrix
        SEWCalcSimulationLine.SetRange("Simulation No.", SimulationNo);
        SEWCalcSimulationLine.SetCurrentKey("Simulation No.", "Line No.");
        if SEWCalcSimulationLine.FindSet() then
            repeat
            // UI will handle display
            until SEWCalcSimulationLine.Next() = 0;
    end;
}
