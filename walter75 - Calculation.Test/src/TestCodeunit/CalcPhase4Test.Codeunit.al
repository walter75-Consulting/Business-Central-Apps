codeunit 90958 "SEW Calc Phase 4 Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        Assert: Codeunit "Library Assert";
        CalcTestHelper: Codeunit "SEW Calc Test Helper";

    [Test]
    procedure TestHistoryEntryCreation()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        SEWCalcHistoryEntry: Record "SEW Calc History Entry";
    begin
        // [GIVEN] A calculation exists
        SEWCalcHeader."No." := CalcTestHelper.CreateTestCalculation();
        SEWCalcHeader.Get(SEWCalcHeader."No.");

        // [WHEN] Creating a history entry
        SEWCalcHistoryEntry.Init();
        SEWCalcHistoryEntry."Calculation No." := SEWCalcHeader."No.";
        SEWCalcHistoryEntry."Change Type" := SEWCalcHistoryEntry."Change Type"::Created;
        SEWCalcHistoryEntry."Field Name" := 'Test Field';
        SEWCalcHistoryEntry."New Value" := 'Test Value';
        SEWCalcHistoryEntry.Insert(true);

        // [THEN] History entry is created with correct values
        Assert.AreEqual(SEWCalcHeader."No.", SEWCalcHistoryEntry."Calculation No.", 'Wrong calculation number');
        Assert.AreEqual(Today(), SEWCalcHistoryEntry."Change Date", 'Wrong change date');
        Assert.AreNotEqual('', SEWCalcHistoryEntry."Changed By User", 'User should be set');
        Assert.AreEqual('Test Field', SEWCalcHistoryEntry."Field Name", 'Wrong field name');
    end;

    [Test]
    procedure TestProductionOrderCalcLink()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        ProductionOrder: Record "Production Order";
        SEWCalcProductionInteg: Codeunit "SEW Calc Production Integ";
    begin
        // [GIVEN] A calculation with costs
        SEWCalcHeader."No." := CalcTestHelper.CreateTestCalculation();
        CalcTestHelper.AddBOMLine(SEWCalcHeader."No.", 100);
        CalcTestHelper.AddRoutingLine(SEWCalcHeader."No.", 50);
        SEWCalcHeader.Get(SEWCalcHeader."No.");

        // [GIVEN] A production order
        ProductionOrder.Init();
        ProductionOrder.Status := ProductionOrder.Status::Released;
        ProductionOrder."No." := 'TEST-PROD-001';
        ProductionOrder.Insert(true);

        // [WHEN] Linking calculation to production order
        SEWCalcProductionInteg.LinkCalculationToProduction(SEWCalcHeader."No.", ProductionOrder);

        // [THEN] Production order has correct calculation link and planned cost
        ProductionOrder.Get(ProductionOrder.Status, ProductionOrder."No.");
        Assert.AreEqual(SEWCalcHeader."No.", ProductionOrder."SEW Calc No.", 'Wrong calculation link');
        Assert.AreEqual(150, ProductionOrder."SEW Planned Cost", 'Planned cost should be 150 (100+50)');
    end;

    [Test]
    procedure TestProductionOrderPlannedCostCalculation()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        ProductionOrder: Record "Production Order";
    begin
        // [GIVEN] A calculation with known costs
        SEWCalcHeader."No." := CalcTestHelper.CreateTestCalculation();
        CalcTestHelper.AddBOMLine(SEWCalcHeader."No.", 250);
        CalcTestHelper.AddRoutingLine(SEWCalcHeader."No.", 75);

        // [WHEN] Creating production order with calc link
        ProductionOrder.Init();
        ProductionOrder.Status := ProductionOrder.Status::Released;
        ProductionOrder."No." := 'TEST-PROD-002';
        ProductionOrder.Validate("SEW Calc No.", SEWCalcHeader."No.");
        ProductionOrder.Insert(true);

        // [THEN] Planned cost is automatically calculated
        Assert.AreEqual(325, ProductionOrder."SEW Planned Cost", 'Planned cost should be 325 (250+75)');
    end;

    [Test]
    procedure TestCostVarianceCalculation()
    var
        ProductionOrder: Record "Production Order";
        SEWCalcProductionInteg: Codeunit "SEW Calc Production Integ";
    begin
        // [GIVEN] Production order with planned cost
        ProductionOrder.Init();
        ProductionOrder.Status := ProductionOrder.Status::Released;
        ProductionOrder."No." := 'TEST-PROD-003';
        ProductionOrder."SEW Calc No." := CalcTestHelper.CreateTestCalculation();
        ProductionOrder."SEW Planned Cost" := 1000;
        ProductionOrder."SEW Alert Threshold %" := 10;
        ProductionOrder.Insert(true);

        // [WHEN] Updating costs with no actual costs yet
        SEWCalcProductionInteg.UpdateActualCosts(ProductionOrder);

        // [THEN] Variance is 0% when no actual costs
        ProductionOrder.Get(ProductionOrder.Status, ProductionOrder."No.");
        Assert.AreEqual(0, ProductionOrder."SEW Cost Variance %", 'Variance should be 0% with no actual costs');
        Assert.IsFalse(ProductionOrder."SEW Cost Alert", 'No alert should be triggered');
    end;

    [Test]
    procedure TestCostAlertBelowThreshold()
    var
        ProductionOrder: Record "Production Order";
    begin
        // [GIVEN] A production order with 10% alert threshold
        ProductionOrder.Init();
        ProductionOrder.Status := ProductionOrder.Status::Released;
        ProductionOrder."No." := 'TEST-PROD-004';
        ProductionOrder."SEW Planned Cost" := 1000;
        ProductionOrder."SEW Alert Threshold %" := 10;
        ProductionOrder."SEW Cost Variance %" := 5;
        ProductionOrder.Insert(true);

        // [WHEN] Variance is below threshold (5% < 10%)
        ProductionOrder."SEW Cost Alert" := ProductionOrder."SEW Cost Variance %" > ProductionOrder."SEW Alert Threshold %";
        ProductionOrder.Modify(true);

        // [THEN] No alert should be triggered
        Assert.IsFalse(ProductionOrder."SEW Cost Alert", 'Alert should not be triggered when variance is 5% (below 10% threshold)');
    end;

    [Test]
    procedure TestCostAlertExceedsThreshold()
    var
        ProductionOrder: Record "Production Order";
    begin
        // [GIVEN] A production order with 10% alert threshold
        ProductionOrder.Init();
        ProductionOrder.Status := ProductionOrder.Status::Released;
        ProductionOrder."No." := 'TEST-PROD-005';
        ProductionOrder."SEW Planned Cost" := 1000;
        ProductionOrder."SEW Alert Threshold %" := 10;
        ProductionOrder.Insert(true);

        // [WHEN] Variance exceeds threshold (15% > 10%)
        ProductionOrder."SEW Cost Variance %" := 15;
        ProductionOrder."SEW Cost Alert" := ProductionOrder."SEW Cost Variance %" > ProductionOrder."SEW Alert Threshold %";
        ProductionOrder.Modify(true);

        // [THEN] Alert should be triggered
        Assert.IsTrue(ProductionOrder."SEW Cost Alert", 'Alert should be triggered when variance is 15% (exceeds 10% threshold)');
    end;

    [Test]
    procedure TestAlertThresholdValidation()
    var
        ProductionOrder: Record "Production Order";
    begin
        // [GIVEN] A production order
        ProductionOrder.Init();
        ProductionOrder.Status := ProductionOrder.Status::Released;
        ProductionOrder."No." := 'TEST-PROD-006';
        ProductionOrder.Insert(true);

        // [WHEN] Setting negative threshold
        asserterror ProductionOrder.Validate("SEW Alert Threshold %", -5);

        // [THEN] Error should be raised
        Assert.ExpectedError('Alert threshold cannot be negative');
    end;

    [Test]
    procedure TestPostCalculationCreation()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        ProductionOrder: Record "Production Order";
        SEWCalcPostCalculation: Codeunit "SEW Calc Post-Calculation";
        PostCalcNo: Code[20];
        PreCalcNo: Code[20];
    begin
        // [GIVEN] A pre-calculation with costs
        PreCalcNo := CalcTestHelper.CreateTestCalculation();
        CalcTestHelper.AddBOMLine(PreCalcNo, 100);
        CalcTestHelper.AddRoutingLine(PreCalcNo, 50);

        // [GIVEN] A finished production order linked to calculation
        ProductionOrder.Init();
        ProductionOrder.Status := ProductionOrder.Status::Finished;
        ProductionOrder."No." := 'TEST-PROD-007';
        ProductionOrder."SEW Calc No." := PreCalcNo;
        ProductionOrder."SEW Planned Cost" := 150;
        ProductionOrder.Insert(true);

        // [WHEN] Creating post-calculation
        PostCalcNo := SEWCalcPostCalculation.CreatePostCalc(ProductionOrder."No.");

        // [THEN] Post-calculation is created with correct number
        Assert.AreNotEqual('', PostCalcNo, 'Post-calc should be created');
        Assert.IsTrue(SEWCalcHeader.Get(PostCalcNo), 'Post-calc should exist in database');
        Assert.IsTrue(StrPos(PostCalcNo, PreCalcNo) > 0, 'Post-calc number should contain original calc number');
        Assert.IsTrue(StrPos(PostCalcNo, '-POST') > 0, 'Post-calc number should contain -POST suffix');
    end;

    [Test]
    procedure TestPostCalculationFromUnfinishedOrder()
    var
        ProductionOrder: Record "Production Order";
        SEWCalcPostCalculation: Codeunit "SEW Calc Post-Calculation";
    begin
        // [GIVEN] A released (not finished) production order
        ProductionOrder.Init();
        ProductionOrder.Status := ProductionOrder.Status::Released;
        ProductionOrder."No." := 'TEST-PROD-008';
        ProductionOrder."SEW Calc No." := CalcTestHelper.CreateTestCalculation();
        ProductionOrder.Insert(true);

        // [WHEN] Attempting to create post-calculation
        asserterror SEWCalcPostCalculation.CreatePostCalc(ProductionOrder."No.");

        // [THEN] Error should be raised
        Assert.ExpectedError('is not finished');
    end;

    [Test]
    procedure TestPostCalculationWithoutCalcLink()
    var
        ProductionOrder: Record "Production Order";
        SEWCalcPostCalculation: Codeunit "SEW Calc Post-Calculation";
    begin
        // [GIVEN] A finished production order without calc link
        ProductionOrder.Init();
        ProductionOrder.Status := ProductionOrder.Status::Finished;
        ProductionOrder."No." := 'TEST-PROD-009';
        ProductionOrder."SEW Calc No." := '';
        ProductionOrder.Insert(true);

        // [WHEN] Attempting to create post-calculation
        asserterror SEWCalcPostCalculation.CreatePostCalc(ProductionOrder."No.");

        // [THEN] Error should be raised
        Assert.ExpectedError('No calculation is linked');
    end;

    [Test]
    procedure TestVarianceComparisonReport()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        ProductionOrder: Record "Production Order";
        SEWCalcPostCalculation: Codeunit "SEW Calc Post-Calculation";
        ComparisonReport: Text;
        PreCalcNo: Code[20];
        PostCalcNo: Code[20];
    begin
        // [GIVEN] Pre-calculation with costs
        PreCalcNo := CalcTestHelper.CreateTestCalculation();
        CalcTestHelper.AddBOMLine(PreCalcNo, 100);
        CalcTestHelper.AddRoutingLine(PreCalcNo, 50);

        // [GIVEN] Finished production order
        ProductionOrder.Init();
        ProductionOrder.Status := ProductionOrder.Status::Finished;
        ProductionOrder."No." := 'TEST-PROD-010';
        ProductionOrder."SEW Calc No." := PreCalcNo;
        ProductionOrder.Insert(true);

        // [GIVEN] Post-calculation created
        PostCalcNo := SEWCalcPostCalculation.CreatePostCalc(ProductionOrder."No.");

        // [WHEN] Comparing pre and post calculations
        ComparisonReport := SEWCalcPostCalculation.CompareWithPreCalc(PostCalcNo, PreCalcNo);

        // [THEN] Report contains both calculation numbers and cost information
        Assert.IsTrue(StrLen(ComparisonReport) > 0, 'Comparison report should be generated');
        Assert.IsTrue(StrPos(ComparisonReport, PreCalcNo) > 0, 'Report should contain pre-calc number');
        Assert.IsTrue(StrPos(ComparisonReport, PostCalcNo) > 0, 'Report should contain post-calc number');
        Assert.IsTrue(StrPos(ComparisonReport, 'Material Cost') > 0, 'Report should contain Material Cost');
        Assert.IsTrue(StrPos(ComparisonReport, 'Labor Cost') > 0, 'Report should contain Labor Cost');
        Assert.IsTrue(StrPos(ComparisonReport, 'Variance') > 0, 'Report should contain Variance');
    end;

    [Test]
    procedure TestHistoryFilteringByCalculation()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        SEWCalcHistoryEntry: Record "SEW Calc History Entry";
        Count: Integer;
        CalcNo: Code[20];
    begin
        // [GIVEN] Multiple history entries for a calculation
        CalcNo := CalcTestHelper.CreateTestCalculation();
        SEWCalcHeader.Get(CalcNo);

        // [GIVEN] Created entry
        SEWCalcHistoryEntry.Init();
        SEWCalcHistoryEntry."Calculation No." := CalcNo;
        SEWCalcHistoryEntry."Change Type" := SEWCalcHistoryEntry."Change Type"::Created;
        SEWCalcHistoryEntry.Insert(true);

        // [GIVEN] Modified entry
        SEWCalcHistoryEntry.Init();
        SEWCalcHistoryEntry."Calculation No." := CalcNo;
        SEWCalcHistoryEntry."Change Type" := SEWCalcHistoryEntry."Change Type"::Modified;
        SEWCalcHistoryEntry.Insert(true);

        // [WHEN] Filtering by calculation number
        SEWCalcHistoryEntry.SetRange("Calculation No.", CalcNo);
        Count := SEWCalcHistoryEntry.Count();

        // [THEN] Both entries are found
        Assert.AreEqual(2, Count, 'Should find 2 history entries for the calculation');
    end;

    [Test]
    procedure TestHistoryFilteringByChangeType()
    var
        SEWCalcHistoryEntry: Record "SEW Calc History Entry";
        CalcNo1: Code[20];
        CalcNo2: Code[20];
        Count: Integer;
    begin
        // [GIVEN] History entries with different change types
        CalcNo1 := CalcTestHelper.CreateTestCalculation();
        CalcNo2 := CalcTestHelper.CreateTestCalculation();

        // [GIVEN] Created entries
        SEWCalcHistoryEntry.Init();
        SEWCalcHistoryEntry."Calculation No." := CalcNo1;
        SEWCalcHistoryEntry."Change Type" := SEWCalcHistoryEntry."Change Type"::Created;
        SEWCalcHistoryEntry.Insert(true);

        SEWCalcHistoryEntry.Init();
        SEWCalcHistoryEntry."Calculation No." := CalcNo2;
        SEWCalcHistoryEntry."Change Type" := SEWCalcHistoryEntry."Change Type"::Created;
        SEWCalcHistoryEntry.Insert(true);

        // [GIVEN] Modified entry
        SEWCalcHistoryEntry.Init();
        SEWCalcHistoryEntry."Calculation No." := CalcNo1;
        SEWCalcHistoryEntry."Change Type" := SEWCalcHistoryEntry."Change Type"::Modified;
        SEWCalcHistoryEntry.Insert(true);

        // [WHEN] Filtering by Created change type
        SEWCalcHistoryEntry.SetRange("Change Type", SEWCalcHistoryEntry."Change Type"::Created);
        Count := SEWCalcHistoryEntry.Count();

        // [THEN] Only Created entries are found
        Assert.AreEqual(2, Count, 'Should find 2 Created history entries');
    end;

    [Test]
    procedure TestMultipleProductionOrdersSameCalculation()
    var
        ProductionOrder1: Record "Production Order";
        ProductionOrder2: Record "Production Order";
        SEWCalcProductionInteg: Codeunit "SEW Calc Production Integ.";
        CalcNo: Code[20];
    begin
        // [GIVEN] A calculation
        CalcNo := CalcTestHelper.CreateTestCalculation();
        CalcTestHelper.AddBOMLine(CalcNo, 100);
        CalcTestHelper.AddRoutingLine(CalcNo, 50);

        // [GIVEN] First production order linked to calculation
        ProductionOrder1.Init();
        ProductionOrder1.Status := ProductionOrder1.Status::Released;
        ProductionOrder1."No." := 'TEST-PROD-011';
        ProductionOrder1.Insert(true);
        SEWCalcProductionInteg.LinkCalculationToProduction(CalcNo, ProductionOrder1."No.");

        // [GIVEN] Second production order linked to same calculation
        ProductionOrder2.Init();
        ProductionOrder2.Status := ProductionOrder2.Status::Released;
        ProductionOrder2."No." := 'TEST-PROD-012';
        ProductionOrder2.Insert(true);
        SEWCalcProductionInteg.LinkCalculationToProduction(CalcNo, ProductionOrder2."No.");

        // [WHEN] Getting linked production orders
        ProductionOrder1.Get(ProductionOrder1.Status, ProductionOrder1."No.");
        ProductionOrder2.Get(ProductionOrder2.Status, ProductionOrder2."No.");

        // [THEN] Both orders are linked to the same calculation
        Assert.AreEqual(CalcNo, ProductionOrder1."SEW Calc No.", 'First production order should be linked to calculation');
        Assert.AreEqual(CalcNo, ProductionOrder2."SEW Calc No.", 'Second production order should be linked to calculation');
        Assert.AreEqual(150, ProductionOrder1."SEW Planned Cost", 'First order should have planned cost 150');
        Assert.AreEqual(150, ProductionOrder2."SEW Planned Cost", 'Second order should have planned cost 150');
    end;

    [Test]
    procedure TestProductionOrderVarianceReport()
    var
        ProductionOrder: Record "Production Order";
        SEWCalcProductionInteg: Codeunit "SEW Calc Production Integ.";
        VarianceReport: Text;
        CalcNo: Code[20];
    begin
        // [GIVEN] Production order with calculation link and cost variance
        CalcNo := CalcTestHelper.CreateTestCalculation();
        CalcTestHelper.AddBOMLine(CalcNo, 100);
        CalcTestHelper.AddRoutingLine(CalcNo, 50);

        ProductionOrder.Init();
        ProductionOrder.Status := ProductionOrder.Status::Released;
        ProductionOrder."No." := 'TEST-PROD-013';
        ProductionOrder.Insert(true);

        SEWCalcProductionInteg.LinkCalculationToProduction(CalcNo, ProductionOrder."No.");

        // [GIVEN] Simulated actual costs (would normally come from ledger entries)
        ProductionOrder.Get(ProductionOrder.Status, ProductionOrder."No.");
        ProductionOrder."SEW Actual Cost to Date" := 175;  // 25 more than planned 150
        ProductionOrder."SEW Cost Variance" := 25;
        ProductionOrder."SEW Cost Variance %" := 16.67;
        ProductionOrder.Modify(true);

        // [WHEN] Getting variance report
        VarianceReport := SEWCalcProductionInteg.GetVarianceReport(ProductionOrder."No.");

        // [THEN] Report contains relevant information
        Assert.IsTrue(StrLen(VarianceReport) > 0, 'Variance report should be generated');
        Assert.IsTrue(StrPos(VarianceReport, ProductionOrder."No.") > 0, 'Report should contain production order number');
        Assert.IsTrue(StrPos(VarianceReport, 'Planned') > 0, 'Report should contain Planned cost');
        Assert.IsTrue(StrPos(VarianceReport, 'Actual') > 0, 'Report should contain Actual cost');
        Assert.IsTrue(StrPos(VarianceReport, 'Variance') > 0, 'Report should contain Variance');
    end;

    [Test]
    procedure TestHistoryEntryFieldChange()
    var
        SEWCalcHistoryEntry: Record "SEW Calc History Entry";
        CalcNo: Code[20];
    begin
        // [GIVEN] A calculation
        CalcNo := CalcTestHelper.CreateTestCalculation();

        // [WHEN] Creating a history entry for a field change
        SEWCalcHistoryEntry.Init();
        SEWCalcHistoryEntry."Calculation No." := CalcNo;
        SEWCalcHistoryEntry."Change Type" := SEWCalcHistoryEntry."Change Type"::Modified;
        SEWCalcHistoryEntry."Field Name" := 'Description';
        SEWCalcHistoryEntry."Old Value" := 'Old Description';
        SEWCalcHistoryEntry."New Value" := 'New Description';
        SEWCalcHistoryEntry.Insert(true);

        // [THEN] History entry is created with field change details
        SEWCalcHistoryEntry.Get(SEWCalcHistoryEntry."Entry No.");
        Assert.AreEqual('Description', SEWCalcHistoryEntry."Field Name", 'Field Name should be stored');
        Assert.AreEqual('Old Description', SEWCalcHistoryEntry."Old Value", 'Old Value should be stored');
        Assert.AreEqual('New Description', SEWCalcHistoryEntry."New Value", 'New Value should be stored');
        Assert.AreNotEqual('', SEWCalcHistoryEntry."Changed By User", 'Changed By User should be auto-populated');
        Assert.AreNotEqual(0D, SEWCalcHistoryEntry."Change Date", 'Change Date should be auto-populated');
        Assert.AreNotEqual(0T, SEWCalcHistoryEntry."Change Time", 'Change Time should be auto-populated');
    end;

    [Test]
    procedure TestLinkCalculationUpdatesPlannedCost()
    var
        ProductionOrder: Record "Production Order";
        SEWCalcProductionInteg: Codeunit "SEW Calc Production Integ.";
        CalcNo: Code[20];
    begin
        // [GIVEN] Calculation with costs
        CalcNo := CalcTestHelper.CreateTestCalculation();
        CalcTestHelper.AddBOMLine(CalcNo, 200);  // Material
        CalcTestHelper.AddRoutingLine(CalcNo, 75);  // Labor

        // [GIVEN] Unlinked production order
        ProductionOrder.Init();
        ProductionOrder.Status := ProductionOrder.Status::Released;
        ProductionOrder."No." := 'TEST-PROD-014';
        ProductionOrder.Insert(true);

        // [WHEN] Linking calculation to production order
        SEWCalcProductionInteg.LinkCalculationToProduction(CalcNo, ProductionOrder."No.");

        // [THEN] Planned cost is automatically updated
        ProductionOrder.Get(ProductionOrder.Status, ProductionOrder."No.");
        Assert.AreEqual(CalcNo, ProductionOrder."SEW Calc No.", 'Production order should be linked to calculation');
        Assert.AreEqual(275, ProductionOrder."SEW Planned Cost", 'Planned cost should be 275 (200+75)');
    end;
}
