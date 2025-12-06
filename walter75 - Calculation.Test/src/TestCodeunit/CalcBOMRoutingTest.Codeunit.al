codeunit 90952 "SEW Calc BOM Routing Test"
{
    Subtype = Test;

    var
        SEWTestAssert: Codeunit "SEW Test Assert";
        SEWCalcTestHelper: Codeunit "SEW Calc Test Helper";
        SEWCalcPriceManagement: Codeunit "SEW Calc Price Management";

    [Test]
    procedure TestBOMCostRetrieval()
    var
        Item: Record Item;
        ProductionBOMHeader: Record "Production BOM Header";
        RoutingHeader: Record "Routing Header";
        BOMCost: Decimal;
    begin
        // [GIVEN] Item with Production BOM
        SEWCalcTestHelper.CreateTestItemWithBOMAndRouting(Item, ProductionBOMHeader, RoutingHeader);

        // [WHEN] Getting BOM cost
        BOMCost := SEWCalcPriceManagement.GetBOMCost(ProductionBOMHeader."No.", '', 1, "SEW Calc Price Source"::"Unit Cost");

        // [THEN] BOM cost should be sum of components (2*10 + 1*15 = 35)
        SEWTestAssert.AreEqual(35, BOMCost, 'BOM cost should be 35 (2*10 + 1*15)');

        // [CLEANUP]
        Item.Delete(true);
        ProductionBOMHeader.Delete(true);
        RoutingHeader.Delete(true);
    end;

    [Test]
    procedure TestRoutingCostCalculation()
    var
        Item: Record Item;
        ProductionBOMHeader: Record "Production BOM Header";
        RoutingHeader: Record "Routing Header";
        RoutingCost: Decimal;
    begin
        // [GIVEN] Item with Routing
        SEWCalcTestHelper.CreateTestItemWithBOMAndRouting(Item, ProductionBOMHeader, RoutingHeader);

        // [WHEN] Getting routing cost
        RoutingCost := SEWCalcPriceManagement.GetRoutingCost(RoutingHeader."No.", '', 1, "SEW Calc Price Source"::"Unit Cost");

        // [THEN] Routing cost should include setup and run time costs
        SEWTestAssert.IsTrue(RoutingCost > 0, 'Routing cost should be greater than zero');

        // [CLEANUP]
        Item.Delete(true);
        ProductionBOMHeader.Delete(true);
        RoutingHeader.Delete(true);
    end;

    [Test]
    procedure TestItemPriceRetrieval()
    var
        Item: Record Item;
        UnitCost: Decimal;
    begin
        // [GIVEN] Item with unit cost
        Item.Init();
        Item."No." := 'TEST-ITEM-001';
        Item."Unit Cost" := 100;
        Item.Insert(true);

        // [WHEN] Getting item price
        UnitCost := SEWCalcPriceManagement.GetItemPrice(Item."No.", "SEW Calc Price Source"::"Unit Cost");

        // [THEN] Unit cost should match
        SEWTestAssert.AreEqual(100, UnitCost, 'Unit cost should be 100');

        // [CLEANUP]
        Item.Delete(true);
    end;
}
