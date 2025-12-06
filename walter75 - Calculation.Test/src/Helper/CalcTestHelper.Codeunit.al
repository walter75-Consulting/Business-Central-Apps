codeunit 90970 "SEW Calc Test Helper"
{
    /// <summary>
    /// Helper codeunit for creating test data and providing common utilities for calculation tests.
    /// All test data is created with TEST prefix for easy identification and cleanup.
    /// </summary>



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
        Item.Insert(true);
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
    /// </summary>
    procedure CreateTestVariable(var SEWCalcVariable: Record "SEW Calc Variable"; VariableCode: Code[20]; VariableType: Enum "SEW Calc Variable Type"; Value: Decimal)
    begin
        SEWCalcVariable.Init();
        SEWCalcVariable.Code := VariableCode;
        SEWCalcVariable.Description := 'Test Variable ' + VariableCode;
        SEWCalcVariable.Type := VariableType;
        SEWCalcVariable.Value := Value;
        SEWCalcVariable.Global := true;
        SEWCalcVariable."Valid From Date" := WorkDate();
        SEWCalcVariable."Valid To Date" := CalcDate('<1Y>', WorkDate());
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

        // Line 1: Material
        SEWCalcTemplateLine.Init();
        SEWCalcTemplateLine."Template Code" := SEWCalcTemplate.Code;
        SEWCalcTemplateLine."Line No." := 10000;
        SEWCalcTemplateLine.Description := 'Material Cost';
        SEWCalcTemplateLine.Formula := '{MATERIAL}';
        SEWCalcTemplateLine."Show in Report" := true;
        SEWCalcTemplateLine.Insert(true);

        // Line 2: Labor
        SEWCalcTemplateLine.Init();
        SEWCalcTemplateLine."Template Code" := SEWCalcTemplate.Code;
        SEWCalcTemplateLine."Line No." := 20000;
        SEWCalcTemplateLine.Description := 'Labor Cost';
        SEWCalcTemplateLine.Formula := '{LABOR}';
        SEWCalcTemplateLine."Show in Report" := true;
        SEWCalcTemplateLine.Insert(true);

        // Line 3: Total
        SEWCalcTemplateLine.Init();
        SEWCalcTemplateLine."Template Code" := SEWCalcTemplate.Code;
        SEWCalcTemplateLine."Line No." := 30000;
        SEWCalcTemplateLine.Description := 'Total Cost';
        SEWCalcTemplateLine.Formula := '{MATERIAL} + {LABOR}';
        SEWCalcTemplateLine.Bold := true;
        SEWCalcTemplateLine."Show in Report" := true;
        SEWCalcTemplateLine.Insert(true);

        exit(SEWCalcTemplate.Code);
    end;

    /// <summary>
    /// Creates a test calculation header.
    /// </summary>
    procedure CreateTestCalculation(var SEWCalcHeader: Record "SEW Calc Header")
    begin
        SEWCalcHeader.Init();
        SEWCalcHeader."No." := 'CALC-TEST-' + Format(Random(9999));
        SEWCalcHeader.Description := 'Test Calculation';
        SEWCalcHeader.Status := SEWCalcHeader.Status::Draft;
        SEWCalcHeader.Insert(true);
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
    begin
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
    /// Creates a test variable for formula parser testing.
    /// </summary>
    procedure CreateTestVariable(var CalcVariable: Record "SEW Calc Variable"; VarCode: Code[20]; VarType: Enum "SEW Calc Variable Type"; VarValue: Decimal)
    begin
        CalcVariable.Init();
        CalcVariable.Code := VarCode;
        CalcVariable."Valid From Date" := 0D; // Valid from beginning of time
        CalcVariable."Valid To Date" := 0D;   // Valid forever
        CalcVariable.Type := VarType;
        CalcVariable.Value := VarValue;
        CalcVariable.Description := 'Test Variable ' + VarCode;
        CalcVariable.Global := true;
        CalcVariable.Insert(true);
    end;
}
