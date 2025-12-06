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

    procedure CreatePostCalc(ProdOrderNo: Code[20]): Code[20]
    var
        ProdOrder: Record "Production Order";
        PreCalcHeader: Record "SEW Calc Header";
        PostCalcHeader: Record "SEW Calc Header";
        CalcHistoryEntry: Record "SEW Calc History Entry";
        NewCalcNo: Code[20];
    begin
        // Validate production order
        if not ProdOrder.Get(ProdOrder.Status::Finished, ProdOrderNo) then
            Error(ProdOrderNotFinishedErr, ProdOrderNo);

        if ProdOrder."SEW Calc No." = '' then
            Error(NoLinkedCalcErr, ProdOrderNo);

        // Get pre-calculation
        if not PreCalcHeader.Get(ProdOrder."SEW Calc No.") then
            Error('Pre-calculation %1 not found', ProdOrder."SEW Calc No.");

        // Create post-calculation header
        NewCalcNo := GetNextPostCalcNo(ProdOrder."SEW Calc No.");
        PostCalcHeader.Init();
        PostCalcHeader."No." := NewCalcNo;
        PostCalcHeader.Validate("Item No.", PreCalcHeader."Item No.");
        PostCalcHeader."Template Code" := PreCalcHeader."Template Code";
        PostCalcHeader."Lot Size" := PreCalcHeader."Lot Size";
        PostCalcHeader.Status := PostCalcHeader.Status::Released;
        PostCalcHeader.Insert(true);

        // Copy lines and update with actual costs
        CopyLinesWithActuals(PreCalcHeader, PostCalcHeader, ProdOrderNo);

        // Log history entry
        CalcHistoryEntry.Init();
        CalcHistoryEntry."Calculation No." := PostCalcHeader."No.";
        CalcHistoryEntry."Change Type" := CalcHistoryEntry."Change Type"::Created;
        CalcHistoryEntry."Field Name" := 'Post-Calculation';
        CalcHistoryEntry."New Value" := 'Created from Production Order ' + ProdOrderNo;
        CalcHistoryEntry.Insert(true);

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
        PreCalcHeader: Record "SEW Calc Header";
        PostCalcHeader: Record "SEW Calc Header";
        Report: Text;
        MaterialVar: Decimal;
        LaborVar: Decimal;
        OverheadVar: Decimal;
        TotalVar: Decimal;
    begin
        if not PreCalcHeader.Get(PreCalcNo) then
            Error('Pre-calculation %1 not found', PreCalcNo);

        if not PostCalcHeader.Get(PostCalcNo) then
            Error('Post-calculation %1 not found', PostCalcNo);

        PreCalcHeader.CalcFields("Total Material Cost", "Total Labor Cost", "Total Overhead Cost", "Total Cost");
        PostCalcHeader.CalcFields("Total Material Cost", "Total Labor Cost", "Total Overhead Cost", "Total Cost");

        MaterialVar := PostCalcHeader."Total Material Cost" - PreCalcHeader."Total Material Cost";
        LaborVar := PostCalcHeader."Total Labor Cost" - PreCalcHeader."Total Labor Cost";
        OverheadVar := PostCalcHeader."Total Overhead Cost" - PreCalcHeader."Total Overhead Cost";
        TotalVar := PostCalcHeader."Total Cost" - PreCalcHeader."Total Cost";

        Report := 'Cost Comparison Report\';
        Report += '========================\';
        Report += '\';
        Report += 'Pre-Calculation: ' + PreCalcNo + '\';
        Report += 'Post-Calculation: ' + PostCalcNo + '\';
        Report += '\';
        Report += 'Material Cost:\';
        Report += '  Planned: ' + Format(PreCalcHeader."Total Material Cost", 0, '<Precision,2:5><Standard Format,0>') + '\';
        Report += '  Actual:  ' + Format(PostCalcHeader."Total Material Cost", 0, '<Precision,2:5><Standard Format,0>') + '\';
        Report += '  Variance: ' + Format(MaterialVar, 0, '<Precision,2:5><Standard Format,0>') + '\';
        Report += '\';
        Report += 'Labor Cost:\';
        Report += '  Planned: ' + Format(PreCalcHeader."Total Labor Cost", 0, '<Precision,2:5><Standard Format,0>') + '\';
        Report += '  Actual:  ' + Format(PostCalcHeader."Total Labor Cost", 0, '<Precision,2:5><Standard Format,0>') + '\';
        Report += '  Variance: ' + Format(LaborVar, 0, '<Precision,2:5><Standard Format,0>') + '\';
        Report += '\';
        Report += 'Overhead Cost:\';
        Report += '  Planned: ' + Format(PreCalcHeader."Total Overhead Cost", 0, '<Precision,2:5><Standard Format,0>') + '\';
        Report += '  Actual:  ' + Format(PostCalcHeader."Total Overhead Cost", 0, '<Precision,2:5><Standard Format,0>') + '\';
        Report += '  Variance: ' + Format(OverheadVar, 0, '<Precision,2:5><Standard Format,0>') + '\';
        Report += '\';
        Report += 'Total Cost:\';
        Report += '  Planned: ' + Format(PreCalcHeader."Total Cost", 0, '<Precision,2:5><Standard Format,0>') + '\';
        Report += '  Actual:  ' + Format(PostCalcHeader."Total Cost", 0, '<Precision,2:5><Standard Format,0>') + '\';
        Report += '  Variance: ' + Format(TotalVar, 0, '<Precision,2:5><Standard Format,0>');

        exit(Report);
    end;

    local procedure GetNextPostCalcNo(PreCalcNo: Code[20]): Code[20]
    var
        CalcHeader: Record "SEW Calc Header";
        BaseNo: Code[20];
        Counter: Integer;
        NewNo: Code[20];
    begin
        BaseNo := PreCalcNo + '-POST';

        // Find next available post-calc number
        Counter := 1;
        repeat
            if Counter = 1 then
                NewNo := BaseNo
            else
                NewNo := BaseNo + Format(Counter);

            Counter += 1;
        until not CalcHeader.Get(NewNo);

        exit(NewNo);
    end;

    local procedure CopyLinesWithActuals(var PreCalcHeader: Record "SEW Calc Header"; var PostCalcHeader: Record "SEW Calc Header"; ProdOrderNo: Code[20])
    var
        PreCalcLine: Record "SEW Calc Line";
        PostCalcLine: Record "SEW Calc Line";
        ActualMaterial: Decimal;
        ActualLabor: Decimal;
        ActualOverhead: Decimal;
    begin
        // Get actual costs
        ActualMaterial := GetActualMaterialCost(ProdOrderNo);
        ActualLabor := GetActualLaborCost(ProdOrderNo);
        ActualOverhead := GetActualOverhead(ProdOrderNo);

        // Copy lines from pre-calculation
        PreCalcLine.SetRange("Calc No.", PreCalcHeader."No.");
        if PreCalcLine.FindSet() then
            repeat
                PostCalcLine.Init();
                PostCalcLine.TransferFields(PreCalcLine);
                PostCalcLine."Calc No." := PostCalcHeader."No.";

                // Update with actual values based on line type
                case PreCalcLine.Type of
                    PreCalcLine.Type::Material:
                        PostCalcLine."Base Value" := ActualMaterial;
                    PreCalcLine.Type::Labor:
                        PostCalcLine."Base Value" := ActualLabor;
                    PreCalcLine.Type::Overhead:
                        PostCalcLine."Base Value" := ActualOverhead;
                end;

                PostCalcLine.Insert(true);
            until PreCalcLine.Next() = 0;
    end;
}
