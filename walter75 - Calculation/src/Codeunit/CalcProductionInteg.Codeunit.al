codeunit 90856 "SEW Calc Production Integ"
{
    Permissions = tabledata "Production Order" = rim,
                  tabledata "Capacity Ledger Entry" = r,
                  tabledata "Item Ledger Entry" = r,
                  tabledata "SEW Calc Header" = r,
                  tabledata "SEW Calc History Entry" = rim;

    var
        AlertMsg: Label 'Production Order %1: Actual costs (%2) exceed planned costs (%3) by %4%', Comment = 'DE="Fertigungsauftrag %1: Istkosten (%2) überschreiten Plankosten (%3) um %4%"';
        NoCalcLinkedErr: Label 'No calculation is linked to this production order', Comment = 'DE="Diesem Fertigungsauftrag ist keine Kalkulation zugeordnet"';

    [EventSubscriber(ObjectType::Table, Database::"Capacity Ledger Entry", OnAfterInsertEvent, '', false, false)]
    local procedure OnCapacityLedgerEntryInsert(var Rec: Record "Capacity Ledger Entry")
    var
        ProdOrder: Record "Production Order";
    begin
        if Rec.IsTemporary() then
            exit;

        if Rec."Order Type" <> Rec."Order Type"::Production then
            exit;

        if not ProdOrder.Get(ProdOrder.Status::Released, Rec."Order No.") then
            if not ProdOrder.Get(ProdOrder.Status::"Firm Planned", Rec."Order No.") then
                exit;

        UpdateActualCosts(ProdOrder);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Ledger Entry", OnAfterInsertEvent, '', false, false)]
    local procedure OnItemLedgerEntryInsert(var Rec: Record "Item Ledger Entry")
    var
        ProdOrder: Record "Production Order";
    begin
        if Rec.IsTemporary() then
            exit;

        if Rec."Order Type" <> Rec."Order Type"::Production then
            exit;

        if not ProdOrder.Get(ProdOrder.Status::Released, Rec."Order No.") then
            if not ProdOrder.Get(ProdOrder.Status::"Firm Planned", Rec."Order No.") then
                exit;

        UpdateActualCosts(ProdOrder);
    end;

    procedure UpdateActualCosts(var ProductionOrder: Record "Production Order")
    var
        MaterialCost: Decimal;
        LaborCost: Decimal;
        TotalActual: Decimal;
        OldVariance: Decimal;
    begin
        if ProductionOrder."SEW Calc No." = '' then
            exit;

        MaterialCost := GetActualMaterialCost(ProductionOrder."No.");
        LaborCost := GetActualLaborCost(ProductionOrder."No.");
        TotalActual := MaterialCost + LaborCost;

        OldVariance := ProductionOrder."SEW Cost Variance %";

        // Calculate variance based on actual vs planned costs
        if ProductionOrder."SEW Planned Cost" <> 0 then
            if TotalActual = 0 then
                ProductionOrder."SEW Cost Variance %" := 0  // No actual costs yet = 0% variance
            else
                ProductionOrder."SEW Cost Variance %" := Round((TotalActual - ProductionOrder."SEW Planned Cost") / ProductionOrder."SEW Planned Cost" * 100, 0.01);

        ProductionOrder."SEW Cost Alert" := ProductionOrder."SEW Cost Variance %" > ProductionOrder."SEW Alert Threshold %";
        ProductionOrder.Modify(true);

        // Log history entry if variance crosses threshold
        if (OldVariance <= ProductionOrder."SEW Alert Threshold %") and
           (ProductionOrder."SEW Cost Variance %" > ProductionOrder."SEW Alert Threshold %")
        then
            LogCostAlert(ProductionOrder);

        // Show notification if alert is triggered
        if ProductionOrder."SEW Cost Alert" then
            ShowCostAlert(ProductionOrder, TotalActual);
    end;

    procedure CompareTargetVsActual(CalcNo: Code[20]; ProdOrderNo: Code[20]): Boolean
    var
        SEWCalcHeader: Record "SEW Calc Header";
        ProductionOrder: Record "Production Order";
        ActualMaterial: Decimal;
        ActualLabor: Decimal;
        PlannedMaterial: Decimal;
        PlannedLabor: Decimal;
    begin
        if not SEWCalcHeader.Get(CalcNo) then
            exit(false);

        if not ProductionOrder.Get(ProductionOrder.Status::Released, ProdOrderNo) then
            if not ProductionOrder.Get(ProductionOrder.Status::"Firm Planned", ProdOrderNo) then
                exit(false);

        // Total Cost fields are regular fields, not FlowFields
        PlannedMaterial := SEWCalcHeader."Total Material Cost";
        PlannedLabor := SEWCalcHeader."Total Labor Cost";

        ActualMaterial := GetActualMaterialCost(ProdOrderNo);
        ActualLabor := GetActualLaborCost(ProdOrderNo);

        exit((ActualMaterial <> PlannedMaterial) or (ActualLabor <> PlannedLabor));
    end;

    local procedure GetActualMaterialCost(ProdOrderNo: Code[20]): Decimal
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        TotalCost: Decimal;
    begin
        ItemLedgerEntry.SetRange("Order Type", ItemLedgerEntry."Order Type"::Production);
        ItemLedgerEntry.SetRange("Order No.", ProdOrderNo);
        ItemLedgerEntry.SetFilter("Entry Type", '%1|%2',
            ItemLedgerEntry."Entry Type"::"Negative Adjmt.",
            ItemLedgerEntry."Entry Type"::Consumption);

        if ItemLedgerEntry.FindSet() then
            repeat
                TotalCost += Abs(ItemLedgerEntry."Cost Amount (Actual)");
            until ItemLedgerEntry.Next() = 0;

        exit(TotalCost);
    end;

    local procedure GetActualLaborCost(ProdOrderNo: Code[20]): Decimal
    var
        CapacityLedgerEntry: Record "Capacity Ledger Entry";
        TotalCost: Decimal;
    begin
        CapacityLedgerEntry.SetRange("Order Type", CapacityLedgerEntry."Order Type"::Production);
        CapacityLedgerEntry.SetRange("Order No.", ProdOrderNo);

        if CapacityLedgerEntry.FindSet() then
            repeat
                TotalCost += CapacityLedgerEntry."Direct Cost";
            until CapacityLedgerEntry.Next() = 0;

        exit(TotalCost);
    end;

    local procedure LogCostAlert(ProductionOrder: Record "Production Order")
    var
        SEWCalcHistoryEntry: Record "SEW Calc History Entry";
    begin
        SEWCalcHistoryEntry.Init();
        SEWCalcHistoryEntry."Calculation No." := ProductionOrder."SEW Calc No.";
        SEWCalcHistoryEntry."Change Type" := SEWCalcHistoryEntry."Change Type"::Modified;
        SEWCalcHistoryEntry."Field Name" := 'Cost Variance Alert';
        SEWCalcHistoryEntry."Old Value" := Format(false);
        SEWCalcHistoryEntry."New Value" := Format(true);
        SEWCalcHistoryEntry.Insert(true);
    end;

    local procedure ShowCostAlert(ProductionOrder: Record "Production Order"; ActualCost: Decimal)
    var
        AlertNotification: Notification;
    begin
        AlertNotification.Message := StrSubstNo(AlertMsg,
            ProductionOrder."No.",
            Format(ActualCost, 0, '<Precision,2:5><Standard Format,0>'),
            Format(ProductionOrder."SEW Planned Cost", 0, '<Precision,2:5><Standard Format,0>'),
            Format(ProductionOrder."SEW Cost Variance %", 0, '<Precision,0:2><Standard Format,0>'));
        AlertNotification.Scope := NotificationScope::LocalScope;
        AlertNotification.Send();
    end;

    procedure LinkCalculationToProduction(CalcNo: Code[20]; var ProductionOrder: Record "Production Order")
    var
        SEWCalcHeader: Record "SEW Calc Header";
        SEWCalcHistoryEntry: Record "SEW Calc History Entry";
    begin
        if not SEWCalcHeader.Get(CalcNo) then
            Error('Calculation %1 not found', CalcNo);

        ProductionOrder.Validate("SEW Calc No.", CalcNo);
        ProductionOrder.Modify(true);

        // Log history
        SEWCalcHistoryEntry.Init();
        SEWCalcHistoryEntry."Calculation No." := CalcNo;
        SEWCalcHistoryEntry."Change Type" := SEWCalcHistoryEntry."Change Type"::Modified;
        SEWCalcHistoryEntry."Field Name" := 'Production Order Link';
        SEWCalcHistoryEntry."New Value" := ProductionOrder."No.";
        SEWCalcHistoryEntry.Insert(true);
    end;

    procedure GetVarianceReport(ProdOrderNo: Code[20]): Text
    var
        ProductionOrder: Record "Production Order";
        Report: Text;
    begin
        if not ProductionOrder.Get(ProductionOrder.Status::Released, ProdOrderNo) then
            if not ProductionOrder.Get(ProductionOrder.Status::"Firm Planned", ProdOrderNo) then
                Error('Production Order %1 not found', ProdOrderNo);

        if ProductionOrder."SEW Calc No." = '' then
            Error(NoCalcLinkedErr);

        // "SEW Actual Cost to Date" is a regular field, not a FlowField - no CalcFields needed

        Report := 'Production Order: ' + ProductionOrder."No." + '\';
        Report += 'Planned Cost: ' + Format(ProductionOrder."SEW Planned Cost") + '\';
        Report += 'Actual Cost: ' + Format(ProductionOrder."SEW Actual Cost to Date") + '\';
        Report += 'Variance: ' + Format(ProductionOrder."SEW Cost Variance %") + '%';

        exit(Report);
    end;
}
