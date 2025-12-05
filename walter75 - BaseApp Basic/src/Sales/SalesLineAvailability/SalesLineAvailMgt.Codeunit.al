/// <summary>
/// Codeunit zur Berechnung der Artikelverfügbarkeit für Verkaufszeilen
/// Ermöglicht farbige Markierung von Verkaufszeilen basierend auf Bestandsprüfungen
/// </summary>
codeunit 80039 "SEW Sales Line Avail Mgt."
{
    /// <summary>
    /// Berechnet die verfügbare Menge für eine Verkaufszeile
    /// </summary>
    /// <param name="SalesLine">Die zu prüfende Verkaufszeile</param>
    /// <returns>Verfügbare Menge (negativ = nicht ausreichend verfügbar)</returns>
    procedure CalcAvailability(var SalesLine: Record "Sales Line"): Decimal
    var
        Item: Record Item;
        AvailableToPromise: Codeunit "Available to Promise";
        LookaheadDateformula: DateFormula;
        GrossRequirement: Decimal;
        ScheduledReceipt: Decimal;
        AnalysisPeriodType: Enum "Analysis Period Type";
    begin
        if GetItem(SalesLine, Item) then begin
            SetItemFilter(Item, SalesLine);
            // Standard BC: Kein zusätzlicher Lookahead-Zeitraum
            Evaluate(LookaheadDateformula, '<0D>');

            exit(
              ConvertQty(
                AvailableToPromise.CalcQtyAvailableToPromise(
                  Item,
                  GrossRequirement,
                  ScheduledReceipt,
                  CalcAvailabilityDate(SalesLine),
                  AnalysisPeriodType,
                  LookaheadDateformula),
                SalesLine."Qty. per Unit of Measure"));
        end;
    end;

    /// <summary>
    /// Berechnet den StyleExpr für die farbige Darstellung der Verkaufszeile
    /// basierend auf verschiedenen Bestandsprüfungen
    /// </summary>
    /// <param name="SalesLine">Die zu prüfende Verkaufszeile</param>
    /// <returns>StyleExpr-Text für die Zeile (None, Unfavorable, Favorable, AttentionAccent, Ambiguous)</returns>
    procedure CalcLineStyle(var SalesLine: Record "Sales Line"): Text
    var
        Item: Record Item;
        StyleText: Text;
    begin
        // Nur bei Artikeln Prüfung durchführen
        if SalesLine.Type <> SalesLine.Type::Item then
            exit(Format(PageStyle::None));

        // Prüfung auf negative Verfügbarkeit (ROT)
        if CalcAvailability(SalesLine) < 0 then
            exit(Format(PageStyle::Unfavorable));

        if not Item.Get(SalesLine."No.") then
            Item.Init();

        StyleText := Format(PageStyle::None);

        // Prüfung ob Lagerbestand unter Meldebestand (GRÜN + FETT)
        if InventoryBelowReorderPoint(Item) then
            StyleText := Format(PageStyle::Favorable);

        // Prüfung ob Lagerbestand geringer als benötigte Menge (ORANGE)
        Item.CalcFields(Inventory);
        if (StyleText = Format(PageStyle::None)) and (Item.Inventory < SalesLine."Outstanding Quantity") then
            StyleText := Format(PageStyle::AttentionAccent);

        // Prüfung ob Maximalbestand überschritten würde (GRAU)
        Item.CalcFields(Inventory, Item."Qty. on Sales Order", Item."Qty. on Purch. Order");
        if (StyleText = Format(PageStyle::None)) and (SalesLine.Type = SalesLine.Type::Item) and
           (CopyStr(SalesLine."No.", 1, 1) = '1') then
            if (Item.Inventory + Item."Qty. on Purch. Order" - Item."Qty. on Sales Order" > Item."Maximum Inventory") then
                StyleText := Format(PageStyle::Ambiguous);

        exit(StyleText);
    end;

    local procedure GetItem(var SalesLine: Record "Sales Line"; var Item: Record Item): Boolean
    begin
        if (SalesLine.Type <> SalesLine.Type::Item) or (SalesLine."No." = '') then
            exit(false);

        if SalesLine."No." <> Item."No." then
            Item.Get(SalesLine."No.");

        exit(true);
    end;

    local procedure SetItemFilter(var Item: Record Item; var SalesLine: Record "Sales Line")
    begin
        Item.Reset();
        Item.SetRange("Date Filter", 0D, CalcAvailabilityDate(SalesLine));
        Item.SetRange("Variant Filter", SalesLine."Variant Code");
        Item.SetRange("Location Filter", SalesLine."Location Code");
        Item.SetRange("Drop Shipment Filter", SalesLine."Drop Shipment");
    end;

    local procedure CalcAvailabilityDate(var SalesLine: Record "Sales Line"): Date
    begin
        if SalesLine."Shipment Date" <> 0D then
            exit(SalesLine."Shipment Date");
        exit(WorkDate());
    end;

    local procedure ConvertQty(Qty: Decimal; PerUoMQty: Decimal): Decimal
    var
        UnitOfMeasureManagement: Codeunit "Unit of Measure Management";
    begin
        if PerUoMQty = 0 then
            PerUoMQty := 1;
        exit(Round(Qty / PerUoMQty, UnitOfMeasureManagement.QtyRndPrecision()));
    end;

    local procedure InventoryBelowReorderPoint(var Item: Record Item): Boolean
    var
        AvailableQty: Decimal;
    begin
        // Standard BC: Berechnung der verfügbaren Menge ohne Vendor-spezifische Date Filter
        Item.CalcFields(
            Item.Inventory,
            Item."Qty. on Sales Order",
            Item."Scheduled Receipt (Qty.)",
            Item."Qty. on Component Lines",
            "Qty. on Assembly Order",
            "Qty. on Asm. Component",
            "Qty. on Purch. Order");

        AvailableQty :=
            Item.Inventory +
            Item."Qty. on Purch. Order" -
            Item."Qty. on Sales Order" +
            Item."Scheduled Receipt (Qty.)" -
            Item."Qty. on Assembly Order" -
            Item."Qty. on Component Lines" -
            Item."Qty. on Asm. Component";

        exit(AvailableQty < Item."Reorder Point");
    end;
}
