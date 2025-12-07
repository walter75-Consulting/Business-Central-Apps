codeunit 90970 "SEW Calc Test Helper"
{
    /// <summary>
    /// Helper codeunit for creating test data and providing common utilities for calculation tests.
    /// All test data is created with TEST prefix for easy identification and cleanup.
    /// </summary>

    /// <summary>
    /// Initializes test environment by setting up required configuration.
    /// </summary>
    procedure InitializeSetup()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
    begin
        if not SalesReceivablesSetup.Get() then
            SalesReceivablesSetup.Insert(true);

        if SalesReceivablesSetup."SEW Calc Nos." = '' then begin
            // Create Number Series if it doesn't exist
            if not NoSeries.Get('CALC-TEST') then begin
                NoSeries.Init();
                NoSeries.Code := 'CALC-TEST';
                NoSeries.Description := 'Test Calculation Numbers';
                NoSeries."Default Nos." := true;
                NoSeries."Manual Nos." := false;
                NoSeries.Insert(true);
            end;

            // Create Number Series Line
            if not NoSeriesLine.Get('CALC-TEST', 10000) then begin
                NoSeriesLine.Init();
                NoSeriesLine."Series Code" := 'CALC-TEST';
                NoSeriesLine."Line No." := 10000;
                NoSeriesLine."Starting No." := 'CALC-T-000001';
                NoSeriesLine."Ending No." := 'CALC-T-999999';
                NoSeriesLine."Increment-by No." := 1;
                NoSeriesLine.Insert(true);
            end;

            // Set in Sales Setup
            SalesReceivablesSetup."SEW Calc Nos." := 'CALC-TEST';
            SalesReceivablesSetup.Modify(true);
        end;
    end;

    /// <summary>
    /// Creates a test item with Production BOM and Routing for calculation testing.
    /// </summary>
    procedure CreateTestItemWithBOMAndRouting(var Item: Record Item; var ProductionBOMHeader: Record "Production BOM Header"; var RoutingHeader: Record "Routing Header")
    var
        ProductionBOMLine: Record "Production BOM Line";
        RoutingLine: Record "Routing Line";
        WorkCenter: Record "Work Center";
        MachineCenter: Record "Machine Center";
        ComponentItem: Record Item;
    begin
        // Create component items for BOM
        CreateTestItem(ComponentItem, 'COMP1', 10.00); // Component 1: 10 EUR
        CreateTestItem(ComponentItem, 'COMP2', 15.00); // Component 2: 15 EUR

        // Create Production BOM
        ProductionBOMHeader.Init();
        ProductionBOMHeader."No." := 'BOM-TEST-' + Format(Random(9999));
        ProductionBOMHeader.Description := 'Test BOM for Calculation';
        ProductionBOMHeader."Unit of Measure Code" := 'PCS';
        ProductionBOMHeader.Insert(true);

        // BOM Line 1: 2 units of COMP1
        ProductionBOMLine.Init();
        ProductionBOMLine."Production BOM No." := ProductionBOMHeader."No.";
        ProductionBOMLine."Line No." := 10000;
        ProductionBOMLine.Type := ProductionBOMLine.Type::Item;
        ProductionBOMLine."No." := 'COMP1';
        ProductionBOMLine."Quantity per" := 2;
        ProductionBOMLine.Insert(true);

        // BOM Line 2: 1 unit of COMP2
        ProductionBOMLine.Init();
        ProductionBOMLine."Production BOM No." := ProductionBOMHeader."No.";
        ProductionBOMLine."Line No." := 20000;
        ProductionBOMLine.Type := ProductionBOMLine.Type::Item;
        ProductionBOMLine."No." := 'COMP2';
        ProductionBOMLine."Quantity per" := 1;
        ProductionBOMLine.Insert(true);

        // Note: Keep BOM in "Under Development" status for test cleanup
        // Setting to Certified prevents deletion in test cleanup

        // Create Work Center and Machine Center
        CreateTestWorkCenter(WorkCenter, 50.00); // 50 EUR/hour
        CreateTestMachineCenter(MachineCenter, WorkCenter."No.", 75.00); // 75 EUR/hour

        // Create Routing
        RoutingHeader.Init();
        RoutingHeader."No." := 'RTG-TEST-' + Format(Random(9999));
        RoutingHeader.Description := 'Test Routing for Calculation';
        RoutingHeader.Insert(true);

        // Routing Line 1: Work Center operation
        RoutingLine.Init();
        RoutingLine."Routing No." := RoutingHeader."No.";
        RoutingLine."Operation No." := '10';
        RoutingLine.Type := RoutingLine.Type::"Work Center";
        RoutingLine."No." := WorkCenter."No.";
        RoutingLine."Setup Time" := 15; // 15 minutes
        RoutingLine."Run Time" := 5;    // 5 minutes per piece
        RoutingLine.Insert(true);

        // Routing Line 2: Machine Center operation
        RoutingLine.Init();
        RoutingLine."Routing No." := RoutingHeader."No.";
        RoutingLine."Operation No." := '20';
        RoutingLine.Type := RoutingLine.Type::"Machine Center";
        RoutingLine."No." := MachineCenter."No.";
        RoutingLine."Setup Time" := 10; // 10 minutes
        RoutingLine."Run Time" := 3;    // 3 minutes per piece
        RoutingLine.Insert(true);

        // Note: Keep Routing in "Under Development" status for test cleanup
        // Setting to Certified prevents deletion in test cleanup

        // Create main item with BOM and Routing
        Item.Init();
        Item."No." := 'TEST-CALC-' + Format(Random(9999));
        Item.Description := 'Test Item for Calculation';
        Item."Replenishment System" := Item."Replenishment System"::"Prod. Order";
        Item."Production BOM No." := ProductionBOMHeader."No.";
        Item."Routing No." := RoutingHeader."No.";
        Item."Unit Cost" := 0; // Will be calculated
        Item.Insert(true);
    end;

    /// <summary>
    /// Creates a simple test item with specified cost.
    /// </summary>
    procedure CreateTestItem(var Item: Record Item; ItemNo: Code[20]; UnitCost: Decimal)
    begin
        if Item.Get(ItemNo) then
            exit;

        Item.Init();
        Item."No." := ItemNo;
        Item.Description := 'Test Component ' + ItemNo;
        Item."Unit Cost" := UnitCost;
        Item."Last Direct Cost" := UnitCost;
        Item."Standard Cost" := UnitCost;
        Item."Gen. Prod. Posting Group" := GetOrCreateGenProdPostingGroup();
        Item."Inventory Posting Group" := GetOrCreateInvtPostingGroup();
        Item.Insert(true);
    end;

    local procedure GetOrCreateGenProdPostingGroup(): Code[20]
    var
        GenProductPostingGroup: Record "Gen. Product Posting Group";
    begin
        if GenProductPostingGroup.Get('TEST') then
            exit('TEST');

        GenProductPostingGroup.Init();
        GenProductPostingGroup.Code := 'TEST';
        GenProductPostingGroup.Description := 'Test Posting Group';
        GenProductPostingGroup.Insert(true);
        exit('TEST');
    end;

    local procedure GetOrCreateInvtPostingGroup(): Code[20]
    var
        InventoryPostingGroup: Record "Inventory Posting Group";
    begin
        if InventoryPostingGroup.Get('TEST') then
            exit('TEST');

        InventoryPostingGroup.Init();
        InventoryPostingGroup.Code := 'TEST';
        InventoryPostingGroup.Description := 'Test Inventory Posting Group';
        InventoryPostingGroup.Insert(true);
        exit('TEST');
    end;

    /// <summary>
    /// Creates a test Work Center with specified hourly rate.
    /// </summary>
    local procedure CreateTestWorkCenter(var WorkCenter: Record "Work Center"; DirectUnitCost: Decimal)
    begin
        WorkCenter.Init();
        WorkCenter."No." := 'WC-TEST-' + Format(Random(999));
        WorkCenter.Name := 'Test Work Center';
        WorkCenter."Direct Unit Cost" := DirectUnitCost;
        WorkCenter."Indirect Cost %" := 20; // 20% overhead
        WorkCenter."Unit Cost" := DirectUnitCost * 1.2;
        WorkCenter.Insert(true);
    end;

    /// <summary>
    /// Creates a test Machine Center with specified hourly rate.
    /// </summary>
    local procedure CreateTestMachineCenter(var MachineCenter: Record "Machine Center"; WorkCenterNo: Code[20]; DirectUnitCost: Decimal)
    begin
        MachineCenter.Init();
        MachineCenter."No." := 'MC-TEST-' + Format(Random(999));
        MachineCenter.Name := 'Test Machine Center';
        MachineCenter."Work Center No." := WorkCenterNo;
        MachineCenter."Direct Unit Cost" := DirectUnitCost;
        MachineCenter."Indirect Cost %" := 15; // 15% overhead
        MachineCenter."Unit Cost" := DirectUnitCost * 1.15;
        MachineCenter.Insert(true);
    end;

    /// <summary>
    /// Creates a test variable with specified type and value.
    /// Uses WorkDate() for Valid From Date by default.
    /// </summary>
    procedure CreateTestVariable(var SEWCalcVariable: Record "SEW Calc Variable"; VariableCode: Code[20]; VariableType: Enum "SEW Calc Variable Type"; Value: Decimal)
    begin
        CreateTestVariable(SEWCalcVariable, VariableCode, VariableType, Value, WorkDate());
    end;

    /// <summary>
    /// Creates a test variable with specified type, value, and valid from date.
    /// </summary>
    procedure CreateTestVariable(var SEWCalcVariable: Record "SEW Calc Variable"; VariableCode: Code[20]; VariableType: Enum "SEW Calc Variable Type"; Value: Decimal; ValidFromDate: Date)
    begin
        SEWCalcVariable.Init();
        SEWCalcVariable.Code := VariableCode;
        SEWCalcVariable.Description := 'Test Variable ' + VariableCode;
        SEWCalcVariable.Type := VariableType;
        SEWCalcVariable.Value := Value;
        SEWCalcVariable.Global := true;
        SEWCalcVariable."Valid From Date" := ValidFromDate;
        if ValidFromDate <> 0D then
            SEWCalcVariable."Valid To Date" := CalcDate('<1Y>', ValidFromDate)
        else
            SEWCalcVariable."Valid To Date" := 0D;  // No date calculation for 0D
        SEWCalcVariable.Insert(true);
    end;

    /// <summary>
    /// Creates a test template with predefined lines.
    /// </summary>
    procedure CreateTestTemplate(var SEWCalcTemplate: Record "SEW Calc Template"): Code[20]
    var
        SEWCalcTemplateLine: Record "SEW Calc Template Line";
    begin
        SEWCalcTemplate.Init();
        SEWCalcTemplate.Code := 'TPL-TEST-' + Format(Random(999));
        SEWCalcTemplate.Description := 'Test Template';
        SEWCalcTemplate.Insert(true);

        // Line 1: Cost A
        SEWCalcTemplateLine.Init();
        SEWCalcTemplateLine."Template Code" := SEWCalcTemplate.Code;
        SEWCalcTemplateLine."Line No." := 10000;
        SEWCalcTemplateLine.Description := 'Cost A';
        SEWCalcTemplateLine.Formula := '{COST-A}';
        SEWCalcTemplateLine."Show in Report" := true;
        SEWCalcTemplateLine.Insert(true);

        // Line 2: Cost B
        SEWCalcTemplateLine.Init();
        SEWCalcTemplateLine."Template Code" := SEWCalcTemplate.Code;
        SEWCalcTemplateLine."Line No." := 20000;
        SEWCalcTemplateLine.Description := 'Cost B';
        SEWCalcTemplateLine.Formula := '{COST-B}';
        SEWCalcTemplateLine."Show in Report" := true;
        SEWCalcTemplateLine.Insert(true);

        // Line 3: Total
        SEWCalcTemplateLine.Init();
        SEWCalcTemplateLine."Template Code" := SEWCalcTemplate.Code;
        SEWCalcTemplateLine."Line No." := 30000;
        SEWCalcTemplateLine.Description := 'Total Cost';
        SEWCalcTemplateLine.Formula := '{COST-A} + {COST-B}';
        SEWCalcTemplateLine.Bold := true;
        SEWCalcTemplateLine."Show in Report" := true;
        SEWCalcTemplateLine.Insert(true);

        // Set template to Released status so it can be used
        SEWCalcTemplate.Status := SEWCalcTemplate.Status::Released;
        SEWCalcTemplate.Modify(true);

        exit(SEWCalcTemplate.Code);
    end;

    /// <summary>
    /// Creates a test customer for sales documents.
    /// </summary>
    procedure CreateTestCustomer(var Customer: Record Customer): Code[20]
    begin
        Customer.Init();
        Customer."No." := 'CUST-TEST-' + Format(Random(999));
        Customer.Name := 'Test Customer';
        Customer.Insert(true);
        exit(Customer."No.");
    end;

    /// <summary>
    /// Creates a test calculation header.
    /// </summary>
    procedure CreateTestCalculation(var SEWCalcHeader: Record "SEW Calc Header")
    var
        StartOfDay: DateTime;
        TimestampMs: BigInteger;
        UniqueNo: Text[20];
    begin
        SEWCalcHeader.Init();
        // Use milliseconds since midnight to ensure uniqueness across rapid test execution
        StartOfDay := CreateDateTime(Today, 0T);
        TimestampMs := CurrentDateTime - StartOfDay;
        UniqueNo := 'T-' + Format(TimestampMs, 0, '<Integer>');
        SEWCalcHeader."No." := CopyStr(UniqueNo, 1, MaxStrLen(SEWCalcHeader."No."));
        SEWCalcHeader.Description := 'Test Calculation';
        SEWCalcHeader."Calculation Date" := WorkDate(); // Set calculation date for variable lookup
        SEWCalcHeader."Lot Size" := 100; // Default lot size for tests
        SEWCalcHeader.Status := SEWCalcHeader.Status::Draft;
        SEWCalcHeader.Insert(true);
    end;

    /// <summary>
    /// Creates a test calculation header and returns the number.
    /// </summary>
    procedure CreateTestCalculation(): Code[20]
    var
        SEWCalcHeader: Record "SEW Calc Header";
    begin
        CreateTestCalculation(SEWCalcHeader);
        exit(SEWCalcHeader."No.");
    end;

    /// <summary>
    /// Adds a BOM line simulation to a calculation by setting material cost.
    /// </summary>
    procedure AddBOMLine(CalcNo: Code[20]; Description: Text[50]; TotalCost: Decimal; Quantity: Decimal)
    var
        SEWCalcHeader: Record "SEW Calc Header";
    begin
        if SEWCalcHeader.Get(CalcNo) then begin
            SEWCalcHeader."Total Material Cost" += TotalCost;
            SEWCalcHeader."Total Cost" += TotalCost;
            SEWCalcHeader."Lot Size" := Quantity;
            SEWCalcHeader.Modify();
        end;
    end;

    /// <summary>
    /// Simplified BOM line addition with just calc number and cost.
    /// Uses the calculation's current lot size for cost calculation.
    /// </summary>
    procedure AddBOMLine(CalcNo: Code[20]; TotalCost: Decimal)
    var
        SEWCalcHeader: Record "SEW Calc Header";
    begin
        if SEWCalcHeader.Get(CalcNo) and (SEWCalcHeader."Lot Size" > 0) then
            AddBOMLine(CalcNo, 'Test BOM Line', TotalCost, SEWCalcHeader."Lot Size")
        else
            AddBOMLine(CalcNo, 'Test BOM Line', TotalCost, 100);
    end;

    /// <summary>
    /// Adds a Routing line simulation to a calculation by setting labor cost.
    /// </summary>
    procedure AddRoutingLine(CalcNo: Code[20]; Description: Text[50]; TotalCost: Decimal; SetupTime: Decimal)
    var
        SEWCalcHeader: Record "SEW Calc Header";
    begin
        if SEWCalcHeader.Get(CalcNo) then begin
            SEWCalcHeader."Total Labor Cost" += TotalCost;
            SEWCalcHeader."Total Cost" += TotalCost;
            SEWCalcHeader.Modify();
        end;
    end;

    /// <summary>
    /// Simplified Routing line addition with just calc number and cost.
    /// </summary>
    procedure AddRoutingLine(CalcNo: Code[20]; TotalCost: Decimal)
    begin
        AddRoutingLine(CalcNo, 'Test Routing Line', TotalCost, 0);
    end;

    /// <summary>
    /// Creates a calculation line for testing.
    /// </summary>
    procedure CreateTestCalculationLine(var SEWCalcLine: Record "SEW Calc Line"; CalcNo: Code[20]; LineNo: Integer; Description: Text[100]; Formula: Text[250])
    begin
        SEWCalcLine.Init();
        SEWCalcLine."Calc No." := CalcNo;
        SEWCalcLine."Line No." := LineNo;
        SEWCalcLine.Description := Description;
        SEWCalcLine.Formula := Formula;
        SEWCalcLine."Show in Report" := true;
        SEWCalcLine.Insert(true);
    end;

    /// <summary>
    /// Deletes all test data created with TEST prefix.
    /// </summary>
    procedure CleanupTestData()
    var
        Item: Record Item;
        ProductionBOMHeader: Record "Production BOM Header";
        RoutingHeader: Record "Routing Header";
        WorkCenter: Record "Work Center";
        MachineCenter: Record "Machine Center";
        SEWCalcVariable: Record "SEW Calc Variable";
        SEWCalcTemplate: Record "SEW Calc Template";
        SEWCalcHeader: Record "SEW Calc Header";
        SEWCalcHistoryEntry: Record "SEW Calc History Entry";
        ProductionOrder: Record "Production Order";
    begin
        // Delete ALL history entries to prevent Entry No. auto-increment conflicts
        // (not just test entries, as Entry No. is a global sequence)
        SEWCalcHistoryEntry.DeleteAll(true);
        Commit();  // Ensure deletion is committed before continuing

        // Delete test production orders
        ProductionOrder.SetFilter("No.", 'TEST-PROD-*');
        ProductionOrder.DeleteAll(true);

        // Delete test items
        Item.SetFilter("No.", 'TEST-CALC-*|COMP*');
        Item.DeleteAll(true);

        // Delete test BOMs
        ProductionBOMHeader.SetFilter("No.", 'BOM-TEST-*');
        ProductionBOMHeader.DeleteAll(true);

        // Delete test Routings
        RoutingHeader.SetFilter("No.", 'RTG-TEST-*');
        RoutingHeader.DeleteAll(true);

        // Delete test Work Centers
        WorkCenter.SetFilter("No.", 'WC-TEST-*');
        WorkCenter.DeleteAll(true);

        // Delete test Machine Centers
        MachineCenter.SetFilter("No.", 'MC-TEST-*');
        MachineCenter.DeleteAll(true);

        // Delete test variables
        SEWCalcVariable.SetFilter(Code, 'VAR-TEST-*');
        SEWCalcVariable.DeleteAll(true);

        // Delete test templates
        SEWCalcTemplate.SetFilter(Code, 'TPL-TEST-*');
        SEWCalcTemplate.DeleteAll(true);

        // Delete test calculations
        SEWCalcHeader.SetFilter("No.", 'CALC-TEST-*');
        SEWCalcHeader.DeleteAll(true);
    end;

    /// <summary>
    /// Returns a random decimal value for testing.
    /// </summary>
    procedure GetRandomDecimal(MinValue: Decimal; MaxValue: Decimal): Decimal
    begin
        exit(MinValue + (Random(100) / 100 * (MaxValue - MinValue)));
    end;

    /// <summary>
    /// Creates a test calculation with specific cost components for sales integration tests.
    /// </summary>
    procedure CreateTestCalcWithCosts(MaterialCost: Decimal; LaborCost: Decimal; OverheadCost: Decimal): Record "SEW Calc Header"
    var
        SEWCalcHeader: Record "SEW Calc Header";
    begin
        CreateTestCalculation(SEWCalcHeader);
        SEWCalcHeader."Total Material Cost" := MaterialCost;
        SEWCalcHeader."Total Labor Cost" := LaborCost;
        SEWCalcHeader."Total Overhead Cost" := OverheadCost;
        SEWCalcHeader."Total Cost" := MaterialCost + LaborCost + OverheadCost;
        SEWCalcHeader.Modify();
        exit(SEWCalcHeader);
    end;

    /// <summary>
    /// Creates a test item with simple BOM for sales integration tests.
    /// </summary>
    procedure CreateItemWithSimpleBOM(): Record Item
    var
        Item: Record Item;
        ProductionBOMHeader: Record "Production BOM Header";
        ProductionBOMLine: Record "Production BOM Line";
        ComponentItem: Record Item;
    begin
        // Create component item
        CreateTestItem(ComponentItem, 'COMP-SIMPLE-' + Format(Random(999)), 50.00);

        // Create simple BOM
        ProductionBOMHeader.Init();
        ProductionBOMHeader."No." := 'BOM-SIMPLE-' + Format(Random(999));
        ProductionBOMHeader.Description := 'Simple BOM for Sales Test';
        ProductionBOMHeader."Unit of Measure Code" := 'PCS';
        ProductionBOMHeader.Insert(true);

        // BOM Line: 1 unit of component
        ProductionBOMLine.Init();
        ProductionBOMLine."Production BOM No." := ProductionBOMHeader."No.";
        ProductionBOMLine."Line No." := 10000;
        ProductionBOMLine.Type := ProductionBOMLine.Type::Item;
        ProductionBOMLine."No." := ComponentItem."No.";
        ProductionBOMLine."Quantity per" := 1;
        ProductionBOMLine.Insert(true);

        // Create main item
        Item.Init();
        Item."No." := 'TEST-SALES-' + Format(Random(9999));
        Item.Description := 'Test Item for Sales Integration';
        Item."Replenishment System" := Item."Replenishment System"::"Prod. Order";
        Item."Production BOM No." := ProductionBOMHeader."No.";
        Item."Unit Cost" := 0;
        Item."Gen. Prod. Posting Group" := GetOrCreateGenProdPostingGroup();
        Item."Inventory Posting Group" := GetOrCreateInvtPostingGroup();
        Item.Insert(true);

        exit(Item);
    end;
}
