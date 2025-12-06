codeunit 90957 "SEW Calc Simulation Test"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        Assert: Codeunit "SEW Test Assert";
        TestHelper: Codeunit "SEW Calc Test Helper";

    [Test]
    procedure TestCreateSimulation()
    var
        CalcHeader: Record "SEW Calc Header";
        SimHeader: Record "SEW Calc Simulation Header";
        SimLine: Record "SEW Calc Simulation Line";
        SimMgt: Codeunit "SEW Calc Simulation Mgt.";
        LotSizes: List of [Decimal];
        SimNo: Code[20];
    begin
        // [GIVEN] A calculation with costs
        CalcHeader := TestHelper.CreateTestCalculation();
        TestHelper.AddBOMLine(CalcHeader."No.", 'Material', 100, 10);
        TestHelper.AddRoutingLine(CalcHeader."No.", 'Labor', 50, 2);

        // [GIVEN] Lot sizes to simulate
        LotSizes.Add(10);
        LotSizes.Add(50);
        LotSizes.Add(100);

        // [WHEN] Creating a simulation
        SimNo := SimMgt.CreateSimulation(CalcHeader."No.", LotSizes, 0, 25);

        // [THEN] Simulation header is created
        Assert.IsTrue(SimHeader.Get(SimNo), 'Simulation header should be created');
        Assert.AreEqual(CalcHeader."No.", SimHeader."Calc No.", 'Calc No. should match');
        Assert.AreEqual(CalcHeader."Item No.", SimHeader."Item No.", 'Item No. should be populated');

        // [THEN] Three simulation lines are created
        SimLine.SetRange("Simulation No.", SimNo);
        Assert.AreEqual(3, SimLine.Count, 'Should have 3 simulation lines');

        // [THEN] Each line has correct lot size
        SimLine.FindSet();
        Assert.AreEqual(10, SimLine."Lot Size", 'First line should have lot size 10');
        SimLine.Next();
        Assert.AreEqual(50, SimLine."Lot Size", 'Second line should have lot size 50');
        SimLine.Next();
        Assert.AreEqual(100, SimLine."Lot Size", 'Third line should have lot size 100');
    end;

    [Test]
    procedure TestCalculateScenario()
    var
        CalcHeader: Record "SEW Calc Header";
        SimLine: Record "SEW Calc Simulation Line";
        SimMgt: Codeunit "SEW Calc Simulation Mgt.";
        LotSizes: List of [Decimal];
        SimNo: Code[20];
        ExpectedMaterialCost: Decimal;
    begin
        // [GIVEN] A calculation with material cost = 100 for lot size 10 (unit cost = 10)
        CalcHeader := TestHelper.CreateTestCalculation();
        TestHelper.AddBOMLine(CalcHeader."No.", 'Material', 100, 10);
        CalcHeader.Get(CalcHeader."No.");  // Reload to get updated values from DB

        // [GIVEN] A simulation with lot size 50 and setup cost 200
        LotSizes.Add(50);
        SimNo := SimMgt.CreateSimulation(CalcHeader."No.", LotSizes, 0, 25);

        SimLine.SetRange("Simulation No.", SimNo);
        SimLine.FindFirst();
        SimLine."Setup Cost" := 200;
        SimLine.Modify();

        // [WHEN] Recalculating the scenario with new setup cost
        SimMgt.CalculateScenario(SimLine, CalcHeader);
        SimLine.Modify();

        // [THEN] Material cost = unit cost * lot size = 10 * 50 = 500
        ExpectedMaterialCost := 500;
        Assert.AreEqual(ExpectedMaterialCost, SimLine."Material Cost", 'Material cost should be 500');

        // [THEN] Total cost = material cost + setup cost = 500 + 200 = 700
        Assert.AreEqual(700, SimLine."Total Cost", 'Total cost should be 700');

        // [THEN] Unit cost = total cost / lot size = 700 / 50 = 14
        Assert.AreEqual(14, SimLine."Unit Cost", 'Unit cost should be 14');
    end;

    [Test]
    procedure TestRecommendationAlgorithm()
    var
        CalcHeader: Record "SEW Calc Header";
        SimHeader: Record "SEW Calc Simulation Header";
        SimLine: Record "SEW Calc Simulation Line";
        RecommendedLine: Record "SEW Calc Simulation Line";
        SimMgt: Codeunit "SEW Calc Simulation Mgt.";
        LotSizes: List of [Decimal];
        SimNo: Code[20];
    begin
        // [GIVEN] A calculation with costs
        CalcHeader := TestHelper.CreateTestCalculation();
        TestHelper.AddBOMLine(CalcHeader."No.", 'Material', 100, 10);

        // [GIVEN] Three scenarios: Small (10), Medium (50), Large (100)
        LotSizes.Add(10);
        LotSizes.Add(50);
        LotSizes.Add(100);
        SimNo := SimMgt.CreateSimulation(CalcHeader."No.", LotSizes, 0, 25);

        // [GIVEN] Setup costs: Small=50, Medium=100, Large=150
        SimLine.SetRange("Simulation No.", SimNo);
        SimLine.FindSet(true);
        SimLine."Setup Cost" := 50;
        SimMgt.CalculateScenario(SimLine, CalcHeader);
        SimLine.Modify();

        SimLine.Next();
        SimLine."Setup Cost" := 100;
        SimMgt.CalculateScenario(SimLine, CalcHeader);
        SimLine.Modify();

        SimLine.Next();
        SimLine."Setup Cost" := 150;
        SimMgt.CalculateScenario(SimLine, CalcHeader);
        SimLine.Modify();

        // [WHEN] Running recommendation algorithm
        SimMgt.RecommendBestScenario(SimNo, 25);

        // [THEN] One scenario is marked as recommended
        SimLine.SetRange("Simulation No.", SimNo);
        SimLine.SetRange("Is Recommended", true);
        Assert.AreEqual(1, SimLine.Count, 'Exactly one scenario should be recommended');

        // [THEN] Simulation header shows recommended scenario code
        Assert.IsTrue(SimHeader.Get(SimNo), 'Simulation header should exist');
        Assert.AreNotEqual('', SimHeader."Recommended Scenario Code", 'Recommended scenario code should be set');

        // [THEN] Recommended line has highest score
        SimLine.FindFirst();
        RecommendedLine := SimLine;
        SimLine.SetRange("Is Recommended");
        SimLine.FindSet();
        repeat
            Assert.IsTrue(RecommendedLine."Recommendation Score" >= SimLine."Recommendation Score",
                'Recommended line should have highest or equal score');
        until SimLine.Next() = 0;
    end;

    [Test]
    procedure TestBreakEvenCalculation()
    var
        CalcHeader: Record "SEW Calc Header";
        SimLine: Record "SEW Calc Simulation Line";
        SimMgt: Codeunit "SEW Calc Simulation Mgt.";
        LotSizes: List of [Decimal];
        SimNo: Code[20];
    begin
        // [GIVEN] A calculation with unit cost = 10
        CalcHeader := TestHelper.CreateTestCalculation();
        TestHelper.AddBOMLine(CalcHeader."No.", 'Material', 10, 1);
        CalcHeader.Get(CalcHeader."No.");  // Reload to get updated values from DB

        // [GIVEN] A simulation with setup cost = 200
        LotSizes.Add(100);
        SimNo := SimMgt.CreateSimulation(CalcHeader."No.", LotSizes, 20, 0);

        SimLine.SetRange("Simulation No.", SimNo);
        SimLine.FindFirst();
        SimLine."Setup Cost" := 200;
        SimLine.Modify();

        // [WHEN] Recalculating with new setup cost (sales price from target = 20)
        SimMgt.CalculateScenario(SimLine, CalcHeader);
        SimLine.Modify();

        // [THEN] Break-even = Setup Cost / (Price - Variable Cost) = 200 / (20 - 10) = 20
        Assert.AreEqual(20, SimLine."Break-Even Quantity", 'Break-even quantity should be 20');
    end;

    [Test]
    procedure TestMultipleSimulations()
    var
        CalcHeader: Record "SEW Calc Header";
        SimHeader: Record "SEW Calc Simulation Header";
        SimMgt: Codeunit "SEW Calc Simulation Mgt.";
        LotSizes: List of [Decimal];
        SimNo1: Code[20];
        SimNo2: Code[20];
    begin
        // [GIVEN] A calculation
        CalcHeader := TestHelper.CreateTestCalculation();
        TestHelper.AddBOMLine(CalcHeader."No.", 'Material', 100, 10);

        // [GIVEN] Lot sizes
        LotSizes.Add(10);
        LotSizes.Add(50);

        // [WHEN] Creating two simulations for the same calculation
        SimNo1 := SimMgt.CreateSimulation(CalcHeader."No.", LotSizes, 0, 20);
        SimNo2 := SimMgt.CreateSimulation(CalcHeader."No.", LotSizes, 0, 30);

        // [THEN] Both simulations exist
        Assert.IsTrue(SimHeader.Get(SimNo1), 'First simulation should exist');
        Assert.IsTrue(SimHeader.Get(SimNo2), 'Second simulation should exist');
        Assert.AreNotEqual(SimNo1, SimNo2, 'Simulation numbers should be different');

        // [THEN] Both linked to same calculation
        SimHeader.Get(SimNo1);
        Assert.AreEqual(CalcHeader."No.", SimHeader."Calc No.", 'First simulation linked to calc');
        SimHeader.Get(SimNo2);
        Assert.AreEqual(CalcHeader."No.", SimHeader."Calc No.", 'Second simulation linked to calc');
    end;

    [Test]
    procedure TestIntegrationWithCalc()
    var
        CalcHeader: Record "SEW Calc Header";
        SimLine: Record "SEW Calc Simulation Line";
        SimMgt: Codeunit "SEW Calc Simulation Mgt.";
        LotSizes: List of [Decimal];
        SimNo: Code[20];
    begin
        // [GIVEN] A fully configured calculation with BOM and Routing
        CalcHeader := TestHelper.CreateTestCalculation();
        CalcHeader."Lot Size" := 100;
        CalcHeader.Modify();
        TestHelper.AddBOMLine(CalcHeader."No.", 'MAT-001', 500, 100);
        TestHelper.AddRoutingLine(CalcHeader."No.", 'WORK-001', 200, 10);

        // [GIVEN] Various lot sizes
        LotSizes.Add(50);
        LotSizes.Add(100);
        LotSizes.Add(200);

        // [WHEN] Creating simulation
        SimNo := SimMgt.CreateSimulation(CalcHeader."No.", LotSizes, 0, 25);

        // [THEN] All scenarios have costs calculated
        SimLine.SetRange("Simulation No.", SimNo);
        SimLine.FindSet();
        repeat
            Assert.IsTrue(SimLine."Material Cost" > 0, 'Material cost should be calculated');
            Assert.IsTrue(SimLine."Labor Cost" > 0, 'Labor cost should be calculated');
            Assert.IsTrue(SimLine."Total Cost" > 0, 'Total cost should be calculated');
            Assert.IsTrue(SimLine."Unit Cost" > 0, 'Unit cost should be calculated');
            Assert.IsTrue(SimLine."Suggested Sales Price" > 0, 'Sales price should be suggested');
        until SimLine.Next() = 0;
    end;

    [Test]
    procedure TestMarginCalculation()
    var
        CalcHeader: Record "SEW Calc Header";
        SimLine: Record "SEW Calc Simulation Line";
        SimMgt: Codeunit "SEW Calc Simulation Mgt.";
        LotSizes: List of [Decimal];
        SimNo: Code[20];
        ExpectedMargin: Decimal;
    begin
        // [GIVEN] A calculation with unit cost = 10
        CalcHeader := TestHelper.CreateTestCalculation();
        CalcHeader."Lot Size" := 1;
        CalcHeader.Modify();
        TestHelper.AddBOMLine(CalcHeader."No.", 'Material', 10, 1);

        // [GIVEN] A simulation scenario
        LotSizes.Add(100);
        SimNo := SimMgt.CreateSimulation(CalcHeader."No.", LotSizes, 0, 0);

        // [WHEN] Setting sales price to 20 (cost is 10)
        SimLine.SetRange("Simulation No.", SimNo);
        SimLine.FindFirst();
        SimLine."Suggested Sales Price" := 20;
        SimLine.Validate("Suggested Sales Price");

        // [THEN] Margin % = (20 - 10) / 20 * 100 = 50%
        ExpectedMargin := 50;
        Assert.AreEqual(ExpectedMargin, SimLine."Margin %", 'Margin should be 50%');
    end;

    [Test]
    procedure TestScenarioCodes()
    var
        CalcHeader: Record "SEW Calc Header";
        SimLine: Record "SEW Calc Simulation Line";
        SimMgt: Codeunit "SEW Calc Simulation Mgt.";
        LotSizes: List of [Decimal];
        SimNo: Code[20];
    begin
        // [GIVEN] Five lot sizes
        LotSizes.Add(10);
        LotSizes.Add(50);
        LotSizes.Add(100);
        LotSizes.Add(500);
        LotSizes.Add(1000);

        // [GIVEN] A calculation
        CalcHeader := TestHelper.CreateTestCalculation();
        TestHelper.AddBOMLine(CalcHeader."No.", 'Material', 100, 10);

        // [WHEN] Creating simulation
        SimNo := SimMgt.CreateSimulation(CalcHeader."No.", LotSizes, 0, 25);

        // [THEN] Scenario codes are assigned correctly
        SimLine.SetRange("Simulation No.", SimNo);
        SimLine.SetCurrentKey("Simulation No.", "Line No.");
        SimLine.FindSet();

        Assert.AreEqual('SMALL', SimLine."Scenario Code", 'First scenario should be SMALL');
        SimLine.Next();
        Assert.AreEqual('MEDIUM', SimLine."Scenario Code", 'Second scenario should be MEDIUM');
        SimLine.Next();
        Assert.AreEqual('LARGE', SimLine."Scenario Code", 'Third scenario should be LARGE');
        SimLine.Next();
        Assert.AreEqual('X-LARGE', SimLine."Scenario Code", 'Fourth scenario should be X-LARGE');
        SimLine.Next();
        Assert.AreEqual('XX-LARGE', SimLine."Scenario Code", 'Fifth scenario should be XX-LARGE');
    end;
}
