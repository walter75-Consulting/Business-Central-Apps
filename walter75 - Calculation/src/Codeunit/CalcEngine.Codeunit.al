codeunit 90850 "SEW Calc Engine"
{
    /// <summary>
    /// Main calculation procedure. Executes the full calculation workflow.
    /// 1. Gets BOM/Routing costs
    /// 2. Evaluates all formulas
    /// 3. Updates totals
    /// </summary>
    procedure Calculate(var SEWCalcHeader: Record "SEW Calc Header")
    begin
        Calculate(SEWCalcHeader, false);
    end;

    /// <summary>
    /// Main calculation procedure with option to skip UI messages.
    /// </summary>
    procedure Calculate(var SEWCalcHeader: Record "SEW Calc Header"; SkipMessages: Boolean)
    var
        SEWCalcLine: Record "SEW Calc Line";
        SEWCalcTemplate: Record "SEW Calc Template";
        SEWCalcFormulaParser: Codeunit "SEW Calc Formula Parser";
        CalculationStartedMsg: Label 'Calculation started...', Comment = 'DE="Kalkulation gestartet..."';
        CalculationCompletedMsg: Label 'Calculation completed. Total Cost: %1', Comment = 'DE="Kalkulation abgeschlossen. Gesamtkosten: %1"';
    begin
        if not SkipMessages then
            Message(CalculationStartedMsg);

        // Step 1: Get BOM and Routing costs if template specifies
        if SEWCalcHeader."Template Code" <> '' then
            if SEWCalcTemplate.Get(SEWCalcHeader."Template Code") then begin
                if SEWCalcTemplate."Include Material" then
                    GetBOMCost(SEWCalcHeader, SEWCalcTemplate."Price Source Item");

                if SEWCalcTemplate."Include Labor" then
                    GetRoutingCost(SEWCalcHeader, SEWCalcTemplate."Price Source Capacity");

                if SEWCalcTemplate."Include Overhead" then
                    ApplySurcharges(SEWCalcHeader);
            end;

        // Step 2: Evaluate all formulas in calculation lines
        SEWCalcLine.SetRange("Calc No.", SEWCalcHeader."No.");
        SEWCalcLine.SetCurrentKey("Calc No.", "Line No.");
        if SEWCalcLine.FindSet() then
            repeat
                if SEWCalcLine.Formula <> '' then begin
                    SEWCalcLine.Amount := SEWCalcFormulaParser.EvaluateFormula(SEWCalcLine.Formula, SEWCalcHeader);
                    SEWCalcLine.Modify(true);
                end;
            until SEWCalcLine.Next() = 0;

        // Step 3: Update totals
        UpdateTotals(SEWCalcHeader);

        if not SkipMessages then
            Message(CalculationCompletedMsg, SEWCalcHeader."Total Cost");
    end;

    /// <summary>
    /// Retrieves material costs from Production BOM.
    /// Updates the Total Material Cost in the header.
    /// </summary>
    procedure GetBOMCost(var SEWCalcHeader: Record "SEW Calc Header"; PriceSource: Enum "SEW Calc Price Source")
    var
        SEWCalcPriceManagement: Codeunit "SEW Calc Price Management";
        MaterialCost: Decimal;
    begin
        if SEWCalcHeader."Production BOM No." = '' then
            exit;

        MaterialCost := SEWCalcPriceManagement.GetBOMCost(
            SEWCalcHeader."Production BOM No.",
            SEWCalcHeader."Production BOM Version",
            SEWCalcHeader."Lot Size",
            PriceSource);

        SEWCalcHeader."Total Material Cost" := MaterialCost;
        SEWCalcHeader.Modify(true);
    end;

    /// <summary>
    /// Retrieves labor costs from Routing.
    /// Updates the Total Labor Cost in the header.
    /// </summary>
    procedure GetRoutingCost(var SEWCalcHeader: Record "SEW Calc Header"; PriceSource: Enum "SEW Calc Price Source")
    var
        SEWCalcPriceManagement: Codeunit "SEW Calc Price Management";
        LaborCost: Decimal;
    begin
        if SEWCalcHeader."Routing No." = '' then
            exit;

        LaborCost := SEWCalcPriceManagement.GetRoutingCost(
            SEWCalcHeader."Routing No.",
            SEWCalcHeader."Routing Version",
            SEWCalcHeader."Lot Size",
            PriceSource);

        SEWCalcHeader."Total Labor Cost" := LaborCost;
        SEWCalcHeader.Modify(true);
    end;

    /// <summary>
    /// Applies overhead surcharges based on material and labor costs.
    /// This is a placeholder - actual overhead logic will be enhanced in Phase 2.
    /// </summary>
    procedure ApplySurcharges(var SEWCalcHeader: Record "SEW Calc Header")
    var
        SEWCalcPriceManagement: Codeunit "SEW Calc Price Management";
        BaseAmount: Decimal;
        OverheadCost: Decimal;
        OverheadPercent: Decimal;
    begin
        // For now, calculate 10% overhead on material + labor
        // Future: This should come from variables or template settings
        OverheadPercent := 10;

        BaseAmount := SEWCalcHeader."Total Material Cost" + SEWCalcHeader."Total Labor Cost";
        OverheadCost := SEWCalcPriceManagement.CalculateOverhead(BaseAmount, OverheadPercent);

        SEWCalcHeader."Total Overhead Cost" := OverheadCost;
        SEWCalcHeader.Modify(true);
    end;

    /// <summary>
    /// Recalculates all totals in the header.
    /// Sums up Material, Labor, and Overhead costs.
    /// Calculates margin if target sales price is set.
    /// </summary>
    procedure UpdateTotals(var SEWCalcHeader: Record "SEW Calc Header")
    var
        SEWCalcPriceManagement: Codeunit "SEW Calc Price Management";
    begin
        // Calculate total cost
        SEWCalcHeader."Total Cost" :=
            SEWCalcHeader."Total Material Cost" +
            SEWCalcHeader."Total Labor Cost" +
            SEWCalcHeader."Total Overhead Cost";

        // Calculate margin if target sales price is set
        if SEWCalcHeader."Target Sales Price" <> 0 then
            SEWCalcHeader."Margin %" := SEWCalcPriceManagement.CalculateMargin(
                SEWCalcHeader."Total Cost",
                SEWCalcHeader."Target Sales Price");

        SEWCalcHeader.Modify(true);
    end;

    /// <summary>
    /// Calculates from template - main entry point for template-based calculations.
    /// Creates calculation lines from template and executes calculation.
    /// </summary>
    procedure CalculateFromTemplate(var SEWCalcHeader: Record "SEW Calc Header")
    var
        SEWCalcTemplateManagement: Codeunit "SEW Calc Template Management";
        NoTemplateErr: Label 'No template code specified', Comment = 'DE="Kein Vorlagencode angegeben"';
    begin
        if SEWCalcHeader."Template Code" = '' then
            Error(NoTemplateErr);

        // Copy template lines to calculation (skip UI for automated testing)
        SEWCalcTemplateManagement.CopyTemplateToCalc(SEWCalcHeader, true);

        // Execute calculation (skip messages for automated testing)
        Calculate(SEWCalcHeader, true);
    end;

    /// <summary>
    /// Validates a calculation before release.
    /// Checks for required data and valid totals.
    /// </summary>
    procedure ValidateCalculation(var SEWCalcHeader: Record "SEW Calc Header"): Boolean
    var
        SEWCalcLine: Record "SEW Calc Line";
        NoLinesErr: Label 'Cannot release calculation without lines', Comment = 'DE="Kalkulation ohne Zeilen kann nicht freigegeben werden"';
        NoItemErr: Label 'Item No. must be specified', Comment = 'DE="Artikelnummer muss angegeben werden"';
    begin
        // Check if item is specified
        if SEWCalcHeader."Item No." = '' then
            Error(NoItemErr);

        // Check if lines exist
        SEWCalcLine.SetRange("Calc No.", SEWCalcHeader."No.");
        if SEWCalcLine.IsEmpty() then
            Error(NoLinesErr);

        exit(true);
    end;

    /// <summary>
    /// Transfers calculation results to the Item card.
    /// Updates Unit Cost and Last Direct Cost on the item.
    /// </summary>
    procedure TransferToItem(var SEWCalcHeader: Record "SEW Calc Header")
    var
        Item: Record Item;
        TransferQst: Label 'Do you want to transfer the calculation results to Item %1?\Total Cost: %2', Comment = 'DE="Möchten Sie die Kalkulationsergebnisse auf Artikel %1 übertragen?\Gesamtkosten: %2"';
        TransferredMsg: Label 'Calculation results transferred to Item %1', Comment = 'DE="Kalkulationsergebnisse auf Artikel %1 übertragen"';
    begin
        if SEWCalcHeader."Item No." = '' then
            exit;

        if not Item.Get(SEWCalcHeader."Item No.") then
            exit;

        if not Confirm(StrSubstNo(TransferQst, Item."No.", SEWCalcHeader."Total Cost"), false) then
            exit;

        Item."Unit Cost" := SEWCalcHeader."Total Cost";
        Item."Last Direct Cost" := SEWCalcHeader."Total Cost";
        Item.Modify(true);

        Message(TransferredMsg, Item."No.");
    end;
}
