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

    procedure UpdateActualCosts(var ProdOrder: Record "Production Order")
    var
        MaterialCost: Decimal;
        LaborCost: Decimal;
        TotalActual: Decimal;
        OldVariance: Decimal;
    begin
        if ProdOrder."SEW Calc No." = '' then
            exit;

        MaterialCost := GetActualMaterialCost(ProdOrder."No.");
        LaborCost := GetActualLaborCost(ProdOrder."No.");
        TotalActual := MaterialCost + LaborCost;

        OldVariance := ProdOrder."SEW Cost Variance %";

        ProdOrder.CalcFields("SEW Actual Cost to Date");
        if ProdOrder."SEW Planned Cost" <> 0 then
            ProdOrder."SEW Cost Variance %" := Round((TotalActual - ProdOrder."SEW Planned Cost") / ProdOrder."SEW Planned Cost" * 100, 0.01);

        ProdOrder."SEW Cost Alert" := ProdOrder."SEW Cost Variance %" > ProdOrder."SEW Alert Threshold %";
        ProdOrder.Modify(true);

        // Log history entry if variance crosses threshold
        if (OldVariance <= ProdOrder."SEW Alert Threshold %") and
           (ProdOrder."SEW Cost Variance %" > ProdOrder."SEW Alert Threshold %")
        then
            LogCostAlert(ProdOrder);

        // Show notification if alert is triggered
        if ProdOrder."SEW Cost Alert" then
            ShowCostAlert(ProdOrder, TotalActual);
    end;

    procedure CompareTargetVsActual(CalcNo: Code[20]; ProdOrderNo: Code[20]): Boolean
    var
        CalcHeader: Record "SEW Calc Header";
        ProdOrder: Record "Production Order";
        ActualMaterial: Decimal;
        ActualLabor: Decimal;
        PlannedMaterial: Decimal;
        PlannedLabor: Decimal;
    begin
        if not CalcHeader.Get(CalcNo) then
            exit(false);

        if not ProdOrder.Get(ProdOrder.Status::Released, ProdOrderNo) then
            if not ProdOrder.Get(ProdOrder.Status::"Firm Planned", ProdOrderNo) then
                exit(false);

        CalcHeader.CalcFields("Total Material Cost", "Total Labor Cost");
        PlannedMaterial := CalcHeader."Total Material Cost";
        PlannedLabor := CalcHeader."Total Labor Cost";

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

    local procedure LogCostAlert(ProdOrder: Record "Production Order")
    var
        CalcHistoryEntry: Record "SEW Calc History Entry";
    begin
        CalcHistoryEntry.Init();
        CalcHistoryEntry."Calculation No." := ProdOrder."SEW Calc No.";
        CalcHistoryEntry."Change Type" := CalcHistoryEntry."Change Type"::Modified;
        CalcHistoryEntry."Field Name" := 'Cost Variance Alert';
        CalcHistoryEntry."Old Value" := Format(false);
        CalcHistoryEntry."New Value" := Format(true);
        CalcHistoryEntry.Insert(true);
    end;

    local procedure ShowCostAlert(ProdOrder: Record "Production Order"; ActualCost: Decimal)
    var
        AlertNotification: Notification;
    begin
        AlertNotification.Message := StrSubstNo(AlertMsg,
            ProdOrder."No.",
            Format(ActualCost, 0, '<Precision,2:5><Standard Format,0>'),
            Format(ProdOrder."SEW Planned Cost", 0, '<Precision,2:5><Standard Format,0>'),
            Format(ProdOrder."SEW Cost Variance %", 0, '<Precision,0:2><Standard Format,0>'));
        AlertNotification.Scope := NotificationScope::LocalScope;
        AlertNotification.Send();
    end;

    procedure LinkCalculationToProduction(CalcNo: Code[20]; var ProdOrder: Record "Production Order")
    var
        CalcHeader: Record "SEW Calc Header";
        CalcHistoryEntry: Record "SEW Calc History Entry";
    begin
        if not CalcHeader.Get(CalcNo) then
            Error('Calculation %1 not found', CalcNo);

        ProdOrder.Validate("SEW Calc No.", CalcNo);
        ProdOrder.Modify(true);

        // Log history
        CalcHistoryEntry.Init();
        CalcHistoryEntry."Calculation No." := CalcNo;
        CalcHistoryEntry."Change Type" := CalcHistoryEntry."Change Type"::Modified;
        CalcHistoryEntry."Field Name" := 'Production Order Link';
        CalcHistoryEntry."New Value" := ProdOrder."No.";
        CalcHistoryEntry.Insert(true);
    end;

    procedure GetVarianceReport(ProdOrderNo: Code[20]): Text
    var
        ProdOrder: Record "Production Order";
        Report: Text;
    begin
        if not ProdOrder.Get(ProdOrder.Status::Released, ProdOrderNo) then
            if not ProdOrder.Get(ProdOrder.Status::"Firm Planned", ProdOrderNo) then
                Error('Production Order %1 not found', ProdOrderNo);

        if ProdOrder."SEW Calc No." = '' then
            Error(NoCalcLinkedErr);

        ProdOrder.CalcFields("SEW Actual Cost to Date");

        Report := 'Production Order: ' + ProdOrder."No." + '\';
        Report += 'Planned Cost: ' + Format(ProdOrder."SEW Planned Cost") + '\';
        Report += 'Actual Cost: ' + Format(ProdOrder."SEW Actual Cost to Date") + '\';
        Report += 'Variance: ' + Format(ProdOrder."SEW Cost Variance %") + '%';

        exit(Report);
    end;
}
