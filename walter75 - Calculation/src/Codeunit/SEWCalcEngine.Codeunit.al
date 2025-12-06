codeunit 90850 "SEW Calc Engine"
{
    /// <summary>
    /// Main calculation procedure. Executes the full calculation workflow.
    /// 1. Gets BOM/Routing costs
    /// 2. Evaluates all formulas
    /// 3. Updates totals
    /// </summary>
    procedure Calculate(var CalcHeader: Record "SEW Calc Header")
    var
        CalcLine: Record "SEW Calc Line";
        PriceManagement: Codeunit "SEW Calc Price Management";
        FormulaParser: Codeunit "SEW Calc Formula Parser";
        Template: Record "SEW Calc Template";
        CalculationStartedMsg: Label 'Calculation started...', Comment = 'DE="Kalkulation gestartet..."';
        CalculationCompletedMsg: Label 'Calculation completed. Total Cost: %1', Comment = 'DE="Kalkulation abgeschlossen. Gesamtkosten: %1"';
    begin
        Message(CalculationStartedMsg);

        // Step 1: Get BOM and Routing costs if template specifies
        if CalcHeader."Template Code" <> '' then
            if Template.Get(CalcHeader."Template Code") then begin
                if Template."Include Material" then
                    GetBOMCost(CalcHeader, Template."Price Source Item");

                if Template."Include Labor" then
                    GetRoutingCost(CalcHeader, Template."Price Source Capacity");

                if Template."Include Overhead" then
                    ApplySurcharges(CalcHeader);
            end;

        // Step 2: Evaluate all formulas in calculation lines
        CalcLine.SetRange("Calc No.", CalcHeader."No.");
        CalcLine.SetCurrentKey("Calc No.", "Line No.");
        if CalcLine.FindSet() then
            repeat
                if CalcLine.Formula <> '' then begin
                    CalcLine.Amount := FormulaParser.EvaluateFormula(CalcLine.Formula, CalcHeader);
                    CalcLine.Modify(true);
                end;
            until CalcLine.Next() = 0;

        // Step 3: Update totals
        UpdateTotals(CalcHeader);

        Message(CalculationCompletedMsg, CalcHeader."Total Cost");
    end;

    /// <summary>
    /// Retrieves material costs from Production BOM.
    /// Updates the Total Material Cost in the header.
    /// </summary>
    procedure GetBOMCost(var CalcHeader: Record "SEW Calc Header"; PriceSource: Enum "SEW Calc Price Source")
    var
        PriceManagement: Codeunit "SEW Calc Price Management";
        MaterialCost: Decimal;
    begin
        if CalcHeader."Production BOM No." = '' then
            exit;

        MaterialCost := PriceManagement.GetBOMCost(
            CalcHeader."Production BOM No.",
            CalcHeader."Production BOM Version",
            CalcHeader."Lot Size",
            PriceSource);

        CalcHeader."Total Material Cost" := MaterialCost;
        CalcHeader.Modify(true);
    end;

    /// <summary>
    /// Retrieves labor costs from Routing.
    /// Updates the Total Labor Cost in the header.
    /// </summary>
    procedure GetRoutingCost(var CalcHeader: Record "SEW Calc Header"; PriceSource: Enum "SEW Calc Price Source")
    var
        PriceManagement: Codeunit "SEW Calc Price Management";
        LaborCost: Decimal;
    begin
        if CalcHeader."Routing No." = '' then
            exit;

        LaborCost := PriceManagement.GetRoutingCost(
            CalcHeader."Routing No.",
            CalcHeader."Routing Version",
            CalcHeader."Lot Size",
            PriceSource);

        CalcHeader."Total Labor Cost" := LaborCost;
        CalcHeader.Modify(true);
    end;

    /// <summary>
    /// Applies overhead surcharges based on material and labor costs.
    /// This is a placeholder - actual overhead logic will be enhanced in Phase 2.
    /// </summary>
    procedure ApplySurcharges(var CalcHeader: Record "SEW Calc Header")
    var
        PriceManagement: Codeunit "SEW Calc Price Management";
        BaseAmount: Decimal;
        OverheadCost: Decimal;
        OverheadPercent: Decimal;
    begin
        // For now, calculate 10% overhead on material + labor
        // Future: This should come from variables or template settings
        OverheadPercent := 10;

        BaseAmount := CalcHeader."Total Material Cost" + CalcHeader."Total Labor Cost";
        OverheadCost := PriceManagement.CalculateOverhead(BaseAmount, OverheadPercent);

        CalcHeader."Total Overhead Cost" := OverheadCost;
        CalcHeader.Modify(true);
    end;

    /// <summary>
    /// Recalculates all totals in the header.
    /// Sums up Material, Labor, and Overhead costs.
    /// Calculates margin if target sales price is set.
    /// </summary>
    procedure UpdateTotals(var CalcHeader: Record "SEW Calc Header")
    var
        PriceManagement: Codeunit "SEW Calc Price Management";
    begin
        // Calculate total cost
        CalcHeader."Total Cost" :=
            CalcHeader."Total Material Cost" +
            CalcHeader."Total Labor Cost" +
            CalcHeader."Total Overhead Cost";

        // Calculate margin if target sales price is set
        if CalcHeader."Target Sales Price" <> 0 then
            CalcHeader."Margin %" := PriceManagement.CalculateMargin(
                CalcHeader."Total Cost",
                CalcHeader."Target Sales Price");

        CalcHeader.Modify(true);
    end;

    /// <summary>
    /// Calculates from template - main entry point for template-based calculations.
    /// Creates calculation lines from template and executes calculation.
    /// </summary>
    procedure CalculateFromTemplate(var CalcHeader: Record "SEW Calc Header")
    var
        TemplateManagement: Codeunit "SEW Calc Template Management";
        NoTemplateErr: Label 'No template code specified', Comment = 'DE="Kein Vorlagencode angegeben"';
    begin
        if CalcHeader."Template Code" = '' then
            Error(NoTemplateErr);

        // Copy template lines to calculation
        TemplateManagement.CopyTemplateToCalc(CalcHeader);

        // Execute calculation
        Calculate(CalcHeader);
    end;

    /// <summary>
    /// Validates a calculation before release.
    /// Checks for required data and valid totals.
    /// </summary>
    procedure ValidateCalculation(var CalcHeader: Record "SEW Calc Header"): Boolean
    var
        CalcLine: Record "SEW Calc Line";
        NoLinesErr: Label 'Cannot release calculation without lines', Comment = 'DE="Kalkulation ohne Zeilen kann nicht freigegeben werden"';
        NoItemErr: Label 'Item No. must be specified', Comment = 'DE="Artikelnummer muss angegeben werden"';
    begin
        // Check if item is specified
        if CalcHeader."Item No." = '' then begin
            Error(NoItemErr);
            exit(false);
        end;

        // Check if lines exist
        CalcLine.SetRange("Calc No.", CalcHeader."No.");
        if CalcLine.IsEmpty() then begin
            Error(NoLinesErr);
            exit(false);
        end;

        exit(true);
    end;

    /// <summary>
    /// Transfers calculation results to the Item card.
    /// Updates Unit Cost and Last Direct Cost on the item.
    /// </summary>
    procedure TransferToItem(var CalcHeader: Record "SEW Calc Header")
    var
        Item: Record Item;
        TransferQst: Label 'Do you want to transfer the calculation results to Item %1?\Total Cost: %2', Comment = 'DE="Möchten Sie die Kalkulationsergebnisse auf Artikel %1 übertragen?\Gesamtkosten: %2"';
        TransferredMsg: Label 'Calculation results transferred to Item %1', Comment = 'DE="Kalkulationsergebnisse auf Artikel %1 übertragen"';
    begin
        if CalcHeader."Item No." = '' then
            exit;

        if not Item.Get(CalcHeader."Item No.") then
            exit;

        if not Confirm(StrSubstNo(TransferQst, Item."No.", CalcHeader."Total Cost"), false) then
            exit;

        Item."Unit Cost" := CalcHeader."Total Cost";
        Item."Last Direct Cost" := CalcHeader."Total Cost";
        Item.Modify(true);

        Message(TransferredMsg, Item."No.");
    end;
}
