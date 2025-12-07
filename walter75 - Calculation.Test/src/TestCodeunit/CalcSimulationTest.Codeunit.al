codeunit 90957 "SEW Calc Simulation Test"
{
    Subtype = Test;
    Permissions = tabledata "SEW Calc Header" = RMID,
                  tabledata "SEW Calc Line" = RMID,
                  tabledata "SEW Calc Simulation Header" = RMID,
                  tabledata "SEW Calc Simulation Line" = RMID;
    TestPermissions = Disabled;

    var
        LibraryAssert: Codeunit "Library Assert";
        SEWCalcTestHelper: Codeunit "SEW Calc Test Helper";

    [Test]
    procedure TestCreateSimulation()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        SEWCalcSimulationHeader: Record "SEW Calc Simulation Header";
        SEWCalcSimulationLine: Record "SEW Calc Simulation Line";
        SEWCalcSimulationMgt: Codeunit "SEW Calc Simulation Mgt.";
        LotSizes: List of [Decimal];
        CalcNo: Code[20];
        SimNo: Code[20];
    begin
        // [GIVEN] A calculation with costs
        CalcNo := SEWCalcTestHelper.CreateTestCalculation();
        SEWCalcTestHelper.AddBOMLine(CalcNo, 100);
        SEWCalcTestHelper.AddRoutingLine(CalcNo, 50);
        SEWCalcHeader.Get(CalcNo);

        // [GIVEN] Lot sizes to simulate
        LotSizes.Add(10);
        LotSizes.Add(50);
        LotSizes.Add(100);

        // [WHEN] Creating a simulation
        SimNo := SEWCalcSimulationMgt.CreateSimulation(CalcNo, LotSizes, 0, 25);

        // [THEN] Simulation header is created
        LibraryAssert.IsTrue(SEWCalcSimulationHeader.Get(SimNo), 'Simulation header should be created');
        LibraryAssert.AreEqual(CalcNo, SEWCalcSimulationHeader."Calc No.", 'Calc No. should match');

        // [THEN] Three simulation lines are created
        SEWCalcSimulationLine.SetRange("Simulation No.", SimNo);
        LibraryAssert.AreEqual(3, SEWCalcSimulationLine.Count, 'Should have 3 simulation lines');

        // [THEN] Each line has correct lot size
        SEWCalcSimulationLine.FindSet();
        LibraryAssert.AreEqual(10, SEWCalcSimulationLine."Lot Size", 'First line should have lot size 10');
        SEWCalcSimulationLine.Next();
        LibraryAssert.AreEqual(50, SEWCalcSimulationLine."Lot Size", 'Second line should have lot size 50');
        SEWCalcSimulationLine.Next();
        LibraryAssert.AreEqual(100, SEWCalcSimulationLine."Lot Size", 'Third line should have lot size 100');
    end;

    [Test]
    procedure TestCalculateScenario()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        SEWCalcSimulationLine: Record "SEW Calc Simulation Line";
        SEWCalcSimulationMgt: Codeunit "SEW Calc Simulation Mgt.";
        LotSizes: List of [Decimal];
        CalcNo: Code[20];
        SimNo: Code[20];
        ExpectedMaterialCost: Decimal;
    begin
        // [GIVEN] A calculation with material cost = 100 for lot size 10 (unit cost = 10)
        CalcNo := SEWCalcTestHelper.CreateTestCalculation();
        SEWCalcHeader.Get(CalcNo);
        SEWCalcHeader."Lot Size" := 10;
        SEWCalcHeader.Modify();
        SEWCalcTestHelper.AddBOMLine(CalcNo, 100);
        SEWCalcHeader.Get(CalcNo);

        // [GIVEN] A simulation with lot size 50 and setup cost 200
        LotSizes.Add(50);
        SimNo := SEWCalcSimulationMgt.CreateSimulation(CalcNo, LotSizes, 0, 25);

        SEWCalcSimulationLine.SetRange("Simulation No.", SimNo);
        SEWCalcSimulationLine.FindFirst();
        SEWCalcSimulationLine."Setup Cost" := 200;
        SEWCalcSimulationLine.Modify();

        // [WHEN] Recalculating the scenario with new setup cost
        SEWCalcSimulationMgt.CalculateScenario(SEWCalcSimulationLine, SEWCalcHeader);
        SEWCalcSimulationLine.Modify();

        // [THEN] Material cost = unit cost * lot size = 10 * 50 = 500
        ExpectedMaterialCost := 500;
        LibraryAssert.AreEqual(ExpectedMaterialCost, SEWCalcSimulationLine."Material Cost", 'Material cost should be 500');

        // [THEN] Total cost = material cost + setup cost = 500 + 200 = 700
        LibraryAssert.AreEqual(700, SEWCalcSimulationLine."Total Cost", 'Total cost should be 700');

        // [THEN] Unit cost = total cost / lot size = 700 / 50 = 14
        LibraryAssert.AreEqual(14, SEWCalcSimulationLine."Unit Cost", 'Unit cost should be 14');
    end;

    [Test]
    procedure TestRecommendationAlgorithm()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        SEWCalcSimulationHeader: Record "SEW Calc Simulation Header";
        SEWCalcSimulationLine: Record "SEW Calc Simulation Line";
        RecommendedSEWCalcSimulationLine: Record "SEW Calc Simulation Line";
        SEWCalcSimulationMgt: Codeunit "SEW Calc Simulation Mgt.";
        CalcNo: Code[20];
        LotSizes: List of [Decimal];
        SimNo: Code[20];
    begin
        // [GIVEN] A calculation with costs
        CalcNo := SEWCalcTestHelper.CreateTestCalculation();
        SEWCalcTestHelper.AddBOMLine(CalcNo, 100);
        SEWCalcHeader.Get(CalcNo);

        // [GIVEN] Three scenarios: Small (10), Medium (50), Large (100)
        LotSizes.Add(10);
        LotSizes.Add(50);
        LotSizes.Add(100);
        SimNo := SEWCalcSimulationMgt.CreateSimulation(CalcNo, LotSizes, 0, 25);

        // [GIVEN] Setup costs: Small=50, Medium=100, Large=150
        SEWCalcSimulationLine.SetRange("Simulation No.", SimNo);
        SEWCalcSimulationLine.FindSet(true);
        SEWCalcSimulationLine."Setup Cost" := 50;
        SEWCalcSimulationMgt.CalculateScenario(SEWCalcSimulationLine, SEWCalcHeader);
        SEWCalcSimulationLine.Modify();

        SEWCalcSimulationLine.Next();
        SEWCalcSimulationLine."Setup Cost" := 100;
        SEWCalcSimulationMgt.CalculateScenario(SEWCalcSimulationLine, SEWCalcHeader);
        SEWCalcSimulationLine.Modify();

        SEWCalcSimulationLine.Next();
        SEWCalcSimulationLine."Setup Cost" := 150;
        SEWCalcSimulationMgt.CalculateScenario(SEWCalcSimulationLine, SEWCalcHeader);
        SEWCalcSimulationLine.Modify();

        // [WHEN] Running recommendation algorithm
        SEWCalcSimulationMgt.RecommendBestScenario(SimNo, 25);

        // [THEN] One scenario is marked as recommended
        SEWCalcSimulationLine.SetRange("Simulation No.", SimNo);
        SEWCalcSimulationLine.SetRange("Is Recommended", true);
        LibraryAssert.AreEqual(1, SEWCalcSimulationLine.Count, 'Exactly one scenario should be recommended');

        // [THEN] Simulation header shows recommended scenario code
        LibraryAssert.IsTrue(SEWCalcSimulationHeader.Get(SimNo), 'Simulation header should exist');
        LibraryAssert.AreNotEqual('', SEWCalcSimulationHeader."Recommended Scenario Code", 'Recommended scenario code should be set');

        // [THEN] Recommended line has highest score
        SEWCalcSimulationLine.FindFirst();
        RecommendedSEWCalcSimulationLine := SEWCalcSimulationLine;
        SEWCalcSimulationLine.SetRange("Is Recommended");
        SEWCalcSimulationLine.FindSet();
        repeat
            LibraryAssert.IsTrue(RecommendedSEWCalcSimulationLine."Recommendation Score" >= SEWCalcSimulationLine."Recommendation Score",
                'Recommended line should have highest or equal score');
        until SEWCalcSimulationLine.Next() = 0;
    end;

    [Test]
    procedure TestBreakEvenCalculation()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        SEWCalcSimulationLine: Record "SEW Calc Simulation Line";
        SEWCalcSimulationMgt: Codeunit "SEW Calc Simulation Mgt.";
        LotSizes: List of [Decimal];
        CalcNo: Code[20];
        SimNo: Code[20];
    begin
        // [GIVEN] A calculation with unit cost = 10 (material cost 1000 for lot size 100)
        CalcNo := SEWCalcTestHelper.CreateTestCalculation();
        SEWCalcTestHelper.AddBOMLine(CalcNo, 1000);
        SEWCalcHeader.Get(CalcNo);

        // [GIVEN] A simulation with setup cost = 200
        LotSizes.Add(100);
        SimNo := SEWCalcSimulationMgt.CreateSimulation(CalcNo, LotSizes, 20, 0);

        SEWCalcSimulationLine.SetRange("Simulation No.", SimNo);
        SEWCalcSimulationLine.FindFirst();
        SEWCalcSimulationLine."Setup Cost" := 200;
        SEWCalcSimulationLine.Modify();

        // [WHEN] Recalculating with new setup cost (sales price from target = 20)
        SEWCalcSimulationMgt.CalculateScenario(SEWCalcSimulationLine, SEWCalcHeader);
        SEWCalcSimulationLine.Modify();

        // [THEN] Break-even = Setup Cost / (Price - Variable Cost) = 200 / (20 - 10) = 20
        LibraryAssert.AreEqual(20.0, SEWCalcSimulationLine."Break-Even Quantity", 'Break-even quantity should be 20');
    end;

    [Test]
    procedure TestMultipleSimulations()
    var
        SEWCalcSimulationHeader: Record "SEW Calc Simulation Header";
        SEWCalcSimulationMgt: Codeunit "SEW Calc Simulation Mgt.";
        LotSizes: List of [Decimal];
        CalcNo: Code[20];
        SimNo1: Code[20];
        SimNo2: Code[20];
    begin
        // [GIVEN] A calculation
        CalcNo := SEWCalcTestHelper.CreateTestCalculation();
        SEWCalcTestHelper.AddBOMLine(CalcNo, 100);

        // [GIVEN] Lot sizes
        LotSizes.Add(10);
        LotSizes.Add(50);

        // [WHEN] Creating two simulations for the same calculation
        SimNo1 := SEWCalcSimulationMgt.CreateSimulation(CalcNo, LotSizes, 0, 20);
        SimNo2 := SEWCalcSimulationMgt.CreateSimulation(CalcNo, LotSizes, 0, 30);

        // [THEN] Both simulations exist
        LibraryAssert.IsTrue(SEWCalcSimulationHeader.Get(SimNo1), 'First simulation should exist');
        LibraryAssert.IsTrue(SEWCalcSimulationHeader.Get(SimNo2), 'Second simulation should exist');
        LibraryAssert.AreNotEqual(SimNo1, SimNo2, 'Simulation numbers should be different');

        // [THEN] Both linked to same calculation
        SEWCalcSimulationHeader.Get(SimNo1);
        LibraryAssert.AreEqual(CalcNo, SEWCalcSimulationHeader."Calc No.", 'First simulation linked to calc');
        SEWCalcSimulationHeader.Get(SimNo2);
        LibraryAssert.AreEqual(CalcNo, SEWCalcSimulationHeader."Calc No.", 'Second simulation linked to calc');
    end;

    [Test]
    procedure TestIntegrationWithCalc()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        SEWCalcSimulationLine: Record "SEW Calc Simulation Line";
        SEWCalcSimulationMgt: Codeunit "SEW Calc Simulation Mgt.";
        LotSizes: List of [Decimal];
        CalcNo: Code[20];
        SimNo: Code[20];
    begin
        // [GIVEN] A fully configured calculation with BOM and Routing
        CalcNo := SEWCalcTestHelper.CreateTestCalculation();
        SEWCalcHeader.Get(CalcNo);
        SEWCalcHeader."Lot Size" := 100;
        SEWCalcHeader.Modify();
        SEWCalcTestHelper.AddBOMLine(CalcNo, 500);
        SEWCalcTestHelper.AddRoutingLine(CalcNo, 200);

        // [GIVEN] Various lot sizes
        LotSizes.Add(50);
        LotSizes.Add(100);
        LotSizes.Add(200);

        // [WHEN] Creating simulation
        SimNo := SEWCalcSimulationMgt.CreateSimulation(CalcNo, LotSizes, 0, 25);

        // [THEN] All scenarios have costs calculated
        SEWCalcSimulationLine.SetRange("Simulation No.", SimNo);
        SEWCalcSimulationLine.FindSet();
        repeat
            LibraryAssert.IsTrue(SEWCalcSimulationLine."Material Cost" > 0, 'Material cost should be calculated');
            LibraryAssert.IsTrue(SEWCalcSimulationLine."Labor Cost" > 0, 'Labor cost should be calculated');
            LibraryAssert.IsTrue(SEWCalcSimulationLine."Total Cost" > 0, 'Total cost should be calculated');
            LibraryAssert.IsTrue(SEWCalcSimulationLine."Unit Cost" > 0, 'Unit cost should be calculated');
            LibraryAssert.IsTrue(SEWCalcSimulationLine."Suggested Sales Price" > 0, 'Sales price should be suggested');
        until SEWCalcSimulationLine.Next() = 0;
    end;

    [Test]
    procedure TestMarginCalculation()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        SEWCalcSimulationLine: Record "SEW Calc Simulation Line";
        SEWCalcSimulationMgt: Codeunit "SEW Calc Simulation Mgt.";
        LotSizes: List of [Decimal];
        CalcNo: Code[20];
        SimNo: Code[20];
        ExpectedMargin: Decimal;
    begin
        // [GIVEN] A calculation with unit cost = 10
        CalcNo := SEWCalcTestHelper.CreateTestCalculation();
        SEWCalcHeader.Get(CalcNo);
        SEWCalcHeader."Lot Size" := 1;
        SEWCalcHeader.Modify();
        SEWCalcTestHelper.AddBOMLine(CalcNo, 10);

        // [GIVEN] A simulation scenario
        LotSizes.Add(100);
        SimNo := SEWCalcSimulationMgt.CreateSimulation(CalcNo, LotSizes, 0, 0);

        // [WHEN] Setting sales price to 20 (cost is 10)
        SEWCalcSimulationLine.SetRange("Simulation No.", SimNo);
        SEWCalcSimulationLine.FindFirst();
        SEWCalcSimulationLine."Suggested Sales Price" := 20;
        SEWCalcSimulationLine.Validate("Suggested Sales Price");

        // [THEN] Margin % = (20 - 10) / 20 * 100 = 50%
        ExpectedMargin := 50;
        LibraryAssert.AreEqual(ExpectedMargin, SEWCalcSimulationLine."Margin %", 'Margin should be 50%');
    end;

    [Test]
    procedure TestScenarioCodes()
    var
        SEWCalcSimulationLine: Record "SEW Calc Simulation Line";
        SEWCalcSimulationMgt: Codeunit "SEW Calc Simulation Mgt.";
        LotSizes: List of [Decimal];
        CalcNo: Code[20];
        SimNo: Code[20];
    begin
        // [GIVEN] Five lot sizes
        LotSizes.Add(10);
        LotSizes.Add(50);
        LotSizes.Add(100);
        LotSizes.Add(500);
        LotSizes.Add(1000);

        // [GIVEN] A calculation
        CalcNo := SEWCalcTestHelper.CreateTestCalculation();
        SEWCalcTestHelper.AddBOMLine(CalcNo, 100);

        // [WHEN] Creating simulation
        SimNo := SEWCalcSimulationMgt.CreateSimulation(CalcNo, LotSizes, 0, 25);

        // [THEN] Scenario codes are assigned correctly
        SEWCalcSimulationLine.SetRange("Simulation No.", SimNo);
        SEWCalcSimulationLine.SetCurrentKey("Simulation No.", "Line No.");
        SEWCalcSimulationLine.FindSet();

        LibraryAssert.AreEqual('SMALL', SEWCalcSimulationLine."Scenario Code", 'First scenario should be SMALL');
        SEWCalcSimulationLine.Next();
        LibraryAssert.AreEqual('MEDIUM', SEWCalcSimulationLine."Scenario Code", 'Second scenario should be MEDIUM');
        SEWCalcSimulationLine.Next();
        LibraryAssert.AreEqual('LARGE', SEWCalcSimulationLine."Scenario Code", 'Third scenario should be LARGE');
        SEWCalcSimulationLine.Next();
        LibraryAssert.AreEqual('X-LARGE', SEWCalcSimulationLine."Scenario Code", 'Fourth scenario should be X-LARGE');
        SEWCalcSimulationLine.Next();
        LibraryAssert.AreEqual('XX-LARGE', SEWCalcSimulationLine."Scenario Code", 'Fifth scenario should be XX-LARGE');
    end;
}
