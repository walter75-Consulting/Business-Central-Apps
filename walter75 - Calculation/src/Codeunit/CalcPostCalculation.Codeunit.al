codeunit 90857 "SEW Calc Post-Calculation"
{
    Permissions = tabledata "Production Order" = r,
                  tabledata "Capacity Ledger Entry" = r,
                  tabledata "Item Ledger Entry" = r,
                  tabledata "SEW Calc Header" = rim,
                  tabledata "SEW Calc Line" = rim,
                  tabledata "SEW Calc History Entry" = rim;

    var
        NoLinkedCalcErr: Label 'No calculation is linked to production order %1', Comment = 'DE="Fertigungsauftrag %1 hat keine verknüpfte Kalkulation"';
        ProdOrderNotFinishedErr: Label 'Production order %1 is not finished', Comment = 'DE="Fertigungsauftrag %1 ist nicht abgeschlossen"';
        PostCalcCreatedMsg: Label 'Post-calculation %1 created from production order %2', Comment = 'DE="Nachkalkulation %1 erstellt von Fertigungsauftrag %2"';
        PreCalcNotFoundErr: Label 'Pre-calculation %1 not found', Comment = 'DE="Vorkalkulation %1 nicht gefunden"';
        PostCalcNotFoundErr: Label 'Post-calculation %1 not found', Comment = 'DE="Nachkalkulation %1 nicht gefunden"';

    procedure CreatePostCalc(ProdOrderNo: Code[20]): Code[20]
    var
        ProductionOrder: Record "Production Order";
        SEWCalcHeaderPre: Record "SEW Calc Header";
        SEWCalcHeaderPost: Record "SEW Calc Header";
        SEWCalcHistoryEntry: Record "SEW Calc History Entry";
        NewCalcNo: Code[20];
    begin
        // Validate production order
        if not ProductionOrder.Get(ProductionOrder.Status::Finished, ProdOrderNo) then
            Error(ProdOrderNotFinishedErr, ProdOrderNo);

        if ProductionOrder."SEW Calc No." = '' then
            Error(NoLinkedCalcErr, ProdOrderNo);

        // Get pre-calculation
        if not SEWCalcHeaderPre.Get(ProductionOrder."SEW Calc No.") then
            Error(PreCalcNotFoundErr, ProductionOrder."SEW Calc No.");

        // Create post-calculation header
        NewCalcNo := GetNextPostCalcNo(ProductionOrder."SEW Calc No.");
        SEWCalcHeaderPost.Init();
        SEWCalcHeaderPost."No." := NewCalcNo;
        SEWCalcHeaderPost.Validate("Item No.", SEWCalcHeaderPre."Item No.");
        SEWCalcHeaderPost."Template Code" := SEWCalcHeaderPre."Template Code";
        SEWCalcHeaderPost."Lot Size" := SEWCalcHeaderPre."Lot Size";
        SEWCalcHeaderPost.Status := SEWCalcHeaderPost.Status::Released;
        SEWCalcHeaderPost.Insert(true);

        // Copy lines and update with actual costs
        CopyLinesWithActuals(SEWCalcHeaderPre, SEWCalcHeaderPost, ProdOrderNo);

        // Log history entry
        SEWCalcHistoryEntry.Init();
        SEWCalcHistoryEntry."Calculation No." := SEWCalcHeaderPost."No.";
        SEWCalcHistoryEntry."Change Type" := SEWCalcHistoryEntry."Change Type"::Created;
        SEWCalcHistoryEntry."Field Name" := 'Post-Calculation';
        SEWCalcHistoryEntry."New Value" := 'Created from Production Order ' + ProdOrderNo;
        SEWCalcHistoryEntry.Insert(true);

        if GuiAllowed() then
            Message(PostCalcCreatedMsg, NewCalcNo, ProdOrderNo);
        exit(NewCalcNo);
    end;

    procedure GetActualMaterialCost(ProdOrderNo: Code[20]): Decimal
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

    procedure GetActualLaborCost(ProdOrderNo: Code[20]): Decimal
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

    procedure GetActualOverhead(ProdOrderNo: Code[20]): Decimal
    var
        CapacityLedgerEntry: Record "Capacity Ledger Entry";
        TotalOverhead: Decimal;
    begin
        CapacityLedgerEntry.SetRange("Order Type", CapacityLedgerEntry."Order Type"::Production);
        CapacityLedgerEntry.SetRange("Order No.", ProdOrderNo);

        if CapacityLedgerEntry.FindSet() then
            repeat
                TotalOverhead += CapacityLedgerEntry."Overhead Cost";
            until CapacityLedgerEntry.Next() = 0;

        exit(TotalOverhead);
    end;

    procedure CompareWithPreCalc(PostCalcNo: Code[20]; PreCalcNo: Code[20]): Text
    var
        SEWCalcHeaderPre: Record "SEW Calc Header";
        SEWCalcHeaderPost: Record "SEW Calc Header";
        Report: Text;
        MaterialVar: Decimal;
        LaborVar: Decimal;
        OverheadVar: Decimal;
        TotalVar: Decimal;
    begin
        if not SEWCalcHeaderPre.Get(PreCalcNo) then
            Error(PreCalcNotFoundErr, PreCalcNo);

        if not SEWCalcHeaderPost.Get(PostCalcNo) then
            Error(PostCalcNotFoundErr, PostCalcNo);

        // Total Cost fields are regular fields, not FlowFields
        MaterialVar := SEWCalcHeaderPost."Total Material Cost" - SEWCalcHeaderPre."Total Material Cost";
        LaborVar := SEWCalcHeaderPost."Total Labor Cost" - SEWCalcHeaderPre."Total Labor Cost";
        OverheadVar := SEWCalcHeaderPost."Total Overhead Cost" - SEWCalcHeaderPre."Total Overhead Cost";
        TotalVar := SEWCalcHeaderPost."Total Cost" - SEWCalcHeaderPre."Total Cost";

        Report := 'Cost Comparison Report\';
        Report += '========================\';
        Report += '\';
        Report += 'Pre-Calculation: ' + PreCalcNo + '\';
        Report += 'Post-Calculation: ' + PostCalcNo + '\';
        Report += '\';
        Report += 'Material Cost:\';
        Report += '  Planned: ' + Format(SEWCalcHeaderPre."Total Material Cost", 0, '<Precision,2:5><Standard Format,0>') + '\';
        Report += '  Actual:  ' + Format(SEWCalcHeaderPost."Total Material Cost", 0, '<Precision,2:5><Standard Format,0>') + '\';
        Report += '  Variance: ' + Format(MaterialVar, 0, '<Precision,2:5><Standard Format,0>') + '\';
        Report += '\';
        Report += 'Labor Cost:\';
        Report += '  Planned: ' + Format(SEWCalcHeaderPre."Total Labor Cost", 0, '<Precision,2:5><Standard Format,0>') + '\';
        Report += '  Actual:  ' + Format(SEWCalcHeaderPost."Total Labor Cost", 0, '<Precision,2:5><Standard Format,0>') + '\';
        Report += '  Variance: ' + Format(LaborVar, 0, '<Precision,2:5><Standard Format,0>') + '\';
        Report += '\';
        Report += 'Overhead Cost:\';
        Report += '  Planned: ' + Format(SEWCalcHeaderPre."Total Overhead Cost", 0, '<Precision,2:5><Standard Format,0>') + '\';
        Report += '  Actual:  ' + Format(SEWCalcHeaderPost."Total Overhead Cost", 0, '<Precision,2:5><Standard Format,0>') + '\';
        Report += '  Variance: ' + Format(OverheadVar, 0, '<Precision,2:5><Standard Format,0>') + '\';
        Report += '\';
        Report += 'Total Cost:\';
        Report += '  Planned: ' + Format(SEWCalcHeaderPre."Total Cost", 0, '<Precision,2:5><Standard Format,0>') + '\';
        Report += '  Actual:  ' + Format(SEWCalcHeaderPost."Total Cost", 0, '<Precision,2:5><Standard Format,0>') + '\';
        Report += '  Variance: ' + Format(TotalVar, 0, '<Precision,2:5><Standard Format,0>');

        exit(Report);
    end;

    local procedure GetNextPostCalcNo(PreCalcNo: Code[20]): Code[20]
    var
        SEWCalcHeader: Record "SEW Calc Header";
        BaseNo: Code[20];
        Counter: Integer;
        NewNo: Code[20];
    begin
        BaseNo := CopyStr(PreCalcNo + '-POST', 1, MaxStrLen(BaseNo));

        // Find next available post-calc number
        Counter := 1;
        repeat
            if Counter = 1 then
                NewNo := BaseNo
            else
                NewNo := BaseNo + Format(Counter);

            Counter += 1;
        until not SEWCalcHeader.Get(NewNo);

        exit(NewNo);
    end;

    local procedure CopyLinesWithActuals(var SEWCalcHeaderPre: Record "SEW Calc Header"; var SEWCalcHeaderPost: Record "SEW Calc Header"; ProdOrderNo: Code[20])
    var
        SEWCalcLinePre: Record "SEW Calc Line";
        SEWCalcLinePost: Record "SEW Calc Line";
        ActualMaterial: Decimal;
        ActualLabor: Decimal;
        ActualOverhead: Decimal;
    begin
        // Get actual costs
        ActualMaterial := GetActualMaterialCost(ProdOrderNo);
        ActualLabor := GetActualLaborCost(ProdOrderNo);
        ActualOverhead := GetActualOverhead(ProdOrderNo);

        // Copy lines from pre-calculation
        SEWCalcLinePre.SetRange("Calc No.", SEWCalcHeaderPre."No.");
        if SEWCalcLinePre.FindSet() then
            repeat
                SEWCalcLinePost.Init();
                SEWCalcLinePost.TransferFields(SEWCalcLinePre);
                SEWCalcLinePost."Calc No." := SEWCalcHeaderPost."No.";

                // Update with actual values based on line type
                case SEWCalcLinePre.Type of
                    SEWCalcLinePre.Type::Material:
                        SEWCalcLinePost."Base Value" := ActualMaterial;
                    SEWCalcLinePre.Type::Labor:
                        SEWCalcLinePost."Base Value" := ActualLabor;
                    SEWCalcLinePre.Type::Overhead:
                        SEWCalcLinePost."Base Value" := ActualOverhead;
                end;

                SEWCalcLinePost.Insert(true);
            until SEWCalcLinePre.Next() = 0;
    end;
}
