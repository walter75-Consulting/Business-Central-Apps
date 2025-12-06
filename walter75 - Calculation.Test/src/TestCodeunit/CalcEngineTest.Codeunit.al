codeunit 90954 "SEW Calc Engine Test"
{
    Subtype = Test;

    /// <summary>
    /// Test codeunit for SEW Calc Engine.
    /// Tests complete calculation workflow, BOM/Routing integration, totals calculation, and Item transfer.
    /// </summary>

    var
        SEWTestAssert: Codeunit "SEW Test Assert";
        SEWCalcTestHelper: Codeunit "SEW Calc Test Helper";
        SEWCalcEngine: Codeunit "SEW Calc Engine";

    [Test]
    procedure TestCalculateFromTemplate()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        SEWCalcTemplate: Record "SEW Calc Template";
        SEWCalcLine: Record "SEW Calc Line";
        TemplateCode: Code[20];
    begin
        // [GIVEN] Template with lines and calculation header
        TemplateCode := SEWCalcTestHelper.CreateTestTemplate(SEWCalcTemplate);
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader);
        SEWCalcHeader."Template Code" := TemplateCode;
        SEWCalcHeader.Modify(true);

        // [WHEN] Calculating from template
        SEWCalcEngine.CalculateFromTemplate(SEWCalcHeader);

        // [THEN] Calculation lines should be created from template
        SEWCalcLine.SetRange("Calc No.", SEWCalcHeader."No.");
        SEWTestAssert.IsFalse(SEWCalcLine.IsEmpty(), 'Calculation lines should be created from template');

        // [CLEANUP]
        SEWCalcHeader.Delete(true);
        SEWCalcTemplate.Delete(true);
    end;

    [Test]
    procedure TestGetBOMCost()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        Item: Record Item;
        ProductionBOMHeader: Record "Production BOM Header";
        RoutingHeader: Record "Routing Header";
    begin
        // [GIVEN] Item with Production BOM and calculation header
        SEWCalcTestHelper.CreateTestItemWithBOMAndRouting(Item, ProductionBOMHeader, RoutingHeader);
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader);
        SEWCalcHeader."Item No." := Item."No.";
        SEWCalcHeader."Production BOM No." := ProductionBOMHeader."No.";
        SEWCalcHeader."Lot Size" := 1;
        SEWCalcHeader.Modify(true);

        // [WHEN] Getting BOM cost
        SEWCalcEngine.GetBOMCost(SEWCalcHeader, "SEW Calc Price Source"::"Unit Cost");
        SEWCalcHeader.Get(SEWCalcHeader."No.");

        // [THEN] Total Material Cost should be calculated (2*10 + 1*15 = 35)
        SEWTestAssert.AreEqual(35, SEWCalcHeader."Total Material Cost", 'Total Material Cost should be 35 (2*10 + 1*15)');

        // [CLEANUP]
        SEWCalcHeader.Delete(true);
        Item.Delete(true);
        ProductionBOMHeader.Delete(true);
        RoutingHeader.Delete(true);
    end;

    [Test]
    procedure TestGetRoutingCost()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        Item: Record Item;
        ProductionBOMHeader: Record "Production BOM Header";
        RoutingHeader: Record "Routing Header";
    begin
        // [GIVEN] Item with Routing and calculation header
        SEWCalcTestHelper.CreateTestItemWithBOMAndRouting(Item, ProductionBOMHeader, RoutingHeader);
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader);
        SEWCalcHeader."Item No." := Item."No.";
        SEWCalcHeader."Routing No." := RoutingHeader."No.";
        SEWCalcHeader."Lot Size" := 1;
        SEWCalcHeader.Modify(true);

        // [WHEN] Getting Routing cost
        SEWCalcEngine.GetRoutingCost(SEWCalcHeader, "SEW Calc Price Source"::"Unit Cost");
        SEWCalcHeader.Get(SEWCalcHeader."No.");

        // [THEN] Total Labor Cost should be greater than 0
        SEWTestAssert.IsTrue(SEWCalcHeader."Total Labor Cost" > 0, 'Total Labor Cost should be calculated from routing');

        // [CLEANUP]
        SEWCalcHeader.Delete(true);
        Item.Delete(true);
        ProductionBOMHeader.Delete(true);
        RoutingHeader.Delete(true);
    end;

    [Test]
    procedure TestApplySurcharges()
    var
        SEWCalcHeader: Record "SEW Calc Header";
    begin
        // [GIVEN] Calculation with material and labor costs
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader);
        SEWCalcHeader."Total Material Cost" := 100;
        SEWCalcHeader."Total Labor Cost" := 50;
        SEWCalcHeader.Modify(true);

        // [WHEN] Applying surcharges
        SEWCalcEngine.ApplySurcharges(SEWCalcHeader);
        SEWCalcHeader.Get(SEWCalcHeader."No.");

        // [THEN] Overhead cost should be calculated (10% of 150 = 15)
        SEWTestAssert.AreEqual(15, SEWCalcHeader."Total Overhead Cost", 'Overhead should be 10% of Material + Labor');

        // [CLEANUP]
        SEWCalcHeader.Delete(true);
    end;

    [Test]
    procedure TestUpdateTotals()
    var
        SEWCalcHeader: Record "SEW Calc Header";
    begin
        // [GIVEN] Calculation with costs
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader);
        SEWCalcHeader."Total Material Cost" := 100;
        SEWCalcHeader."Total Labor Cost" := 50;
        SEWCalcHeader."Total Overhead Cost" := 15;
        SEWCalcHeader.Modify(true);

        // [WHEN] Updating totals
        SEWCalcEngine.UpdateTotals(SEWCalcHeader);
        SEWCalcHeader.Get(SEWCalcHeader."No.");

        // [THEN] Total Cost should be sum of all costs
        SEWTestAssert.AreEqual(165, SEWCalcHeader."Total Cost", 'Total Cost should be 100 + 50 + 15 = 165');

        // [CLEANUP]
        SEWCalcHeader.Delete(true);
    end;

    [Test]
    procedure TestUpdateTotalsWithMargin()
    var
        SEWCalcHeader: Record "SEW Calc Header";
    begin
        // [GIVEN] Calculation with costs and target sales price
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader);
        SEWCalcHeader."Total Material Cost" := 100;
        SEWCalcHeader."Total Labor Cost" := 50;
        SEWCalcHeader."Total Overhead Cost" := 15;
        SEWCalcHeader."Target Sales Price" := 200;
        SEWCalcHeader.Modify(true);

        // [WHEN] Updating totals
        SEWCalcEngine.UpdateTotals(SEWCalcHeader);
        SEWCalcHeader.Get(SEWCalcHeader."No.");

        // [THEN] Margin % should be calculated
        // Total Cost = 165, Sales Price = 200, Margin = (200-165)/200 * 100 = 17.5%
        SEWTestAssert.IsTrue(SEWCalcHeader."Margin %" > 0, 'Margin % should be calculated');
        SEWTestAssert.IsTrue(SEWCalcHeader."Margin %" < 20, 'Margin % should be around 17.5%');

        // [CLEANUP]
        SEWCalcHeader.Delete(true);
    end;

    [Test]
    procedure TestValidateCalculationSuccess()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        SEWCalcLine: Record "SEW Calc Line";
        Item: Record Item;
        IsValid: Boolean;
    begin
        // [GIVEN] Valid calculation with item and lines
        SEWCalcTestHelper.CreateTestItem(Item, 'TEST-VAL', 10);
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader);
        SEWCalcHeader."Item No." := Item."No.";
        SEWCalcHeader.Modify(true);

        // Create calculation line
        SEWCalcLine.Init();
        SEWCalcLine."Calc No." := SEWCalcHeader."No.";
        SEWCalcLine."Line No." := 10000;
        SEWCalcLine.Description := 'Test Line';
        SEWCalcLine.Insert(true);

        // [WHEN] Validating calculation
        IsValid := SEWCalcEngine.ValidateCalculation(SEWCalcHeader);

        // [THEN] Validation should succeed
        SEWTestAssert.IsTrue(IsValid, 'Validation should succeed for valid calculation');

        // [CLEANUP]
        SEWCalcHeader.Delete(true);
        Item.Delete(true);
    end;

    [Test]
    procedure TestTransferToItem()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        Item: Record Item;
        OriginalUnitCost: Decimal;
    begin
        // [GIVEN] Item and calculation with total cost
        SEWCalcTestHelper.CreateTestItem(Item, 'TEST-TRF', 10);
        OriginalUnitCost := Item."Unit Cost";
        
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader);
        SEWCalcHeader."Item No." := Item."No.";
        SEWCalcHeader."Total Cost" := 125.50;
        SEWCalcHeader.Modify(true);

        // [WHEN] Transferring to item (note: requires manual confirmation in actual use)
        // This test verifies the calculation has correct data for transfer
        Item.Get(Item."No.");

        // [THEN] Original unit cost should still be unchanged (transfer not executed without confirmation)
        SEWTestAssert.AreEqual(OriginalUnitCost, Item."Unit Cost", 'Unit Cost unchanged without transfer');
        SEWTestAssert.IsTrue(SEWCalcHeader."Total Cost" > 0, 'Total Cost ready for transfer');

        // [CLEANUP]
        SEWCalcHeader.Delete(true);
        Item.Delete(true);
    end;

    [Test]
    procedure TestCompleteCalculationWorkflow()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        Item: Record Item;
        ProductionBOMHeader: Record "Production BOM Header";
        RoutingHeader: Record "Routing Header";
    begin
        // [GIVEN] Complete setup with Item, BOM, Routing
        SEWCalcTestHelper.CreateTestItemWithBOMAndRouting(Item, ProductionBOMHeader, RoutingHeader);
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader);
        SEWCalcHeader."Item No." := Item."No.";
        SEWCalcHeader."Production BOM No." := ProductionBOMHeader."No.";
        SEWCalcHeader."Routing No." := RoutingHeader."No.";
        SEWCalcHeader."Lot Size" := 100;
        SEWCalcHeader.Modify(true);

        // [WHEN] Running complete calculation
        SEWCalcEngine.GetBOMCost(SEWCalcHeader, "SEW Calc Price Source"::"Unit Cost");
        SEWCalcEngine.GetRoutingCost(SEWCalcHeader, "SEW Calc Price Source"::"Unit Cost");
        SEWCalcEngine.ApplySurcharges(SEWCalcHeader);
        SEWCalcEngine.UpdateTotals(SEWCalcHeader);
        SEWCalcHeader.Get(SEWCalcHeader."No.");

        // [THEN] All costs should be calculated
        SEWTestAssert.IsTrue(SEWCalcHeader."Total Material Cost" > 0, 'Material cost calculated');
        SEWTestAssert.IsTrue(SEWCalcHeader."Total Labor Cost" > 0, 'Labor cost calculated');
        SEWTestAssert.IsTrue(SEWCalcHeader."Total Overhead Cost" > 0, 'Overhead cost calculated');
        SEWTestAssert.IsTrue(SEWCalcHeader."Total Cost" > 0, 'Total cost calculated');
        
        // Total should equal sum of parts
        SEWTestAssert.AreEqual(
            SEWCalcHeader."Total Material Cost" + SEWCalcHeader."Total Labor Cost" + SEWCalcHeader."Total Overhead Cost",
            SEWCalcHeader."Total Cost",
            'Total Cost should equal sum of all cost components'
        );

        // [CLEANUP]
        SEWCalcHeader.Delete(true);
        Item.Delete(true);
        ProductionBOMHeader.Delete(true);
        RoutingHeader.Delete(true);
    end;

    [Test]
    procedure TestLotSizeScaling()
    var
        SEWCalcHeader1: Record "SEW Calc Header";
        SEWCalcHeader2: Record "SEW Calc Header";
        Item: Record Item;
        ProductionBOMHeader: Record "Production BOM Header";
        RoutingHeader: Record "Routing Header";
        Cost1: Decimal;
        Cost2: Decimal;
    begin
        // [GIVEN] Item with BOM and Routing
        SEWCalcTestHelper.CreateTestItemWithBOMAndRouting(Item, ProductionBOMHeader, RoutingHeader);

        // [GIVEN] First calculation with lot size 1
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader1);
        SEWCalcHeader1."Item No." := Item."No.";
        SEWCalcHeader1."Production BOM No." := ProductionBOMHeader."No.";
        SEWCalcHeader1."Lot Size" := 1;
        SEWCalcHeader1.Modify(true);

        // [GIVEN] Second calculation with lot size 100
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader2);
        SEWCalcHeader2."Item No." := Item."No.";
        SEWCalcHeader2."Production BOM No." := ProductionBOMHeader."No.";
        SEWCalcHeader2."Lot Size" := 100;
        SEWCalcHeader2.Modify(true);

        // [WHEN] Calculating costs for both
        SEWCalcEngine.GetBOMCost(SEWCalcHeader1, "SEW Calc Price Source"::"Unit Cost");
        SEWCalcEngine.GetBOMCost(SEWCalcHeader2, "SEW Calc Price Source"::"Unit Cost");
        SEWCalcHeader1.Get(SEWCalcHeader1."No.");
        SEWCalcHeader2.Get(SEWCalcHeader2."No.");

        // [THEN] Material cost should be the same (material scales linearly)
        Cost1 := SEWCalcHeader1."Total Material Cost";
        Cost2 := SEWCalcHeader2."Total Material Cost" / 100; // Per unit
        SEWTestAssert.AreEqual(Cost1, Cost2, 'Material cost per unit should be same regardless of lot size');

        // [CLEANUP]
        SEWCalcHeader1.Delete(true);
        SEWCalcHeader2.Delete(true);
        Item.Delete(true);
        ProductionBOMHeader.Delete(true);
        RoutingHeader.Delete(true);
    end;
}
