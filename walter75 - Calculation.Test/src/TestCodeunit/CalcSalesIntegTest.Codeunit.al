codeunit 90956 "SEW Calc Sales Integ. Test"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        SEWTestAssert: Codeunit "SEW Test Assert";
        SEWCalcTestHelper: Codeunit "SEW Calc Test Helper";

    [Test]
    procedure TestSalesHeaderExtensionFields()
    var
        SalesHeaderRec: Record "Sales Header";
        SEWCalcTemplateRec: Record "SEW Calc Template";
    begin
        // [GIVEN] A calculation template
        SEWCalcTestHelper.CreateTestTemplate(SEWCalcTemplateRec);

        // [GIVEN] A sales quote
        SalesHeaderRec.Init();
        SalesHeaderRec."Document Type" := SalesHeaderRec."Document Type"::Quote;
        SalesHeaderRec.Insert(true);

        // [WHEN] Setting default calc template and auto calculate
        SalesHeaderRec."SEW Default Calc Template" := SEWCalcTemplateRec.Code;
        SalesHeaderRec."SEW Auto Calculate" := true;
        SalesHeaderRec.Modify();

        // [THEN] Fields should be stored correctly
        SalesHeaderRec.Get(SalesHeaderRec."Document Type", SalesHeaderRec."No.");
        SEWTestAssert.AreEqual(SEWCalcTemplateRec.Code, SalesHeaderRec."SEW Default Calc Template", 'Default template not set');
        SEWTestAssert.IsTrue(SalesHeaderRec."SEW Auto Calculate", 'Auto calculate not enabled');
    end;

    [Test]
    procedure TestSalesLineExtensionFields()
    var
        SalesHeaderRec: Record "Sales Header";
        SalesLineRec: Record "Sales Line";
        ItemRec: Record Item;
        SEWCalcHeaderRec: Record "SEW Calc Header";
    begin
        // [GIVEN] A calculation
        SEWCalcHeaderRec := SEWCalcTestHelper.CreateTestCalcWithCosts(100, 50, 30); // Material, Labor, Overhead

        // [GIVEN] An item and sales quote
        SEWCalcTestHelper.CreateTestItem(ItemRec, 'TEST-ITEM-' + Format(Random(999)), 100);
        SalesHeaderRec.Init();
        SalesHeaderRec."Document Type" := SalesHeaderRec."Document Type"::Quote;
        SalesHeaderRec.Insert(true);
        SalesLineRec.Init();
        SalesLineRec."Document Type" := SalesHeaderRec."Document Type";
        SalesLineRec."Document No." := SalesHeaderRec."No.";
        SalesLineRec."Line No." := 10000;
        SalesLineRec.Type := SalesLineRec.Type::Item;
        SalesLineRec."No." := ItemRec."No.";
        SalesLineRec.Quantity := 1;
        SalesLineRec.Insert(true);

        // [WHEN] Linking calculation to sales line
        SalesLineRec."SEW Calc No." := SEWCalcHeaderRec."No.";
        SalesLineRec.Validate("SEW Calc No.");
        SalesLineRec.Modify();

        // [THEN] Calculated cost should be updated
        SEWTestAssert.AreEqual(180, SalesLineRec."SEW Calculated Cost", 'Calculated cost incorrect');
    end;

    [Test]
    procedure TestMarginCalculation()
    var
        SalesHeaderRec: Record "Sales Header";
        SalesLineRec: Record "Sales Line";
        ItemRec: Record Item;
        SEWCalcHeaderRec: Record "SEW Calc Header";
    begin
        // [GIVEN] A calculation with total cost 180
        SEWCalcHeaderRec := SEWCalcTestHelper.CreateTestCalcWithCosts(100, 50, 30);

        // [GIVEN] A sales line with unit price 240
        SEWCalcTestHelper.CreateTestItem(ItemRec, 'TEST-ITEM-' + Format(Random(999)), 100);
        SalesHeaderRec.Init();
        SalesHeaderRec."Document Type" := SalesHeaderRec."Document Type"::Quote;
        SalesHeaderRec.Insert(true);
        SalesLineRec.Init();
        SalesLineRec."Document Type" := SalesHeaderRec."Document Type";
        SalesLineRec."Document No." := SalesHeaderRec."No.";
        SalesLineRec."Line No." := 10000;
        SalesLineRec.Type := SalesLineRec.Type::Item;
        SalesLineRec."No." := ItemRec."No.";
        SalesLineRec.Quantity := 1;
        SalesLineRec.Insert(true);
        SalesLineRec."SEW Calc No." := SEWCalcHeaderRec."No.";
        SalesLineRec.Validate("SEW Calc No.");
        SalesLineRec.Validate("Unit Price", 240);
        SalesLineRec.Modify();

        // [THEN] Margin should be calculated correctly
        // Margin = (240 - 180) / 240 * 100 = 25 percent
        SEWTestAssert.AreEqual(25, SalesLineRec."SEW Calculated Margin %", 'Margin calculation incorrect');
    end;

    [Test]
    procedure TestCalculateSalesLinePrice()
    var
        SalesHeaderRec: Record "Sales Header";
        SalesLineRec: Record "Sales Line";
        ItemRec: Record Item;
        SEWCalcTemplateRec: Record "SEW Calc Template";
        SEWCalcIntegMgmtCU: Codeunit "SEW Calc Integration Mgt.";
    begin
        // [GIVEN] Setup is initialized with number series
        SEWCalcTestHelper.InitializeSetup();

        // [GIVEN] A template and item with BOM
        SEWCalcTestHelper.CreateTestTemplate(SEWCalcTemplateRec);
        ItemRec := SEWCalcTestHelper.CreateItemWithSimpleBOM();

        // [GIVEN] A sales quote with template
        SalesHeaderRec.Init();
        SalesHeaderRec."Document Type" := SalesHeaderRec."Document Type"::Quote;
        SalesHeaderRec.Insert(true);
        SalesHeaderRec."SEW Default Calc Template" := SEWCalcTemplateRec.Code;
        SalesHeaderRec.Modify();

        // [GIVEN] A sales line
        SalesLineRec.Init();
        SalesLineRec."Document Type" := SalesHeaderRec."Document Type";
        SalesLineRec."Document No." := SalesHeaderRec."No.";
        SalesLineRec."Line No." := 10000;
        SalesLineRec.Type := SalesLineRec.Type::Item;
        SalesLineRec."No." := ItemRec."No.";
        SalesLineRec.Quantity := 1;
        SalesLineRec.Insert(true);

        // [WHEN] Calculating sales line price
        SEWCalcIntegMgmtCU.CalculateSalesLinePrice(SalesLineRec);

        // [THEN] Calculation should be created and linked
        SalesLineRec.Get(SalesLineRec."Document Type", SalesLineRec."Document No.", SalesLineRec."Line No.");
        SEWTestAssert.AreNotEqual('', SalesLineRec."SEW Calc No.", 'Calculation not created');
        SEWTestAssert.IsTrue(SalesLineRec."SEW Calculated Cost" > 0, 'Cost not calculated');
        SEWTestAssert.IsTrue(SalesLineRec."SEW Target Price" > 0, 'Target price not set');
    end;

    [Test]
    procedure TestAutoCalculateOnItemSelection()
    var
        SalesHeaderRec: Record "Sales Header";
        SalesLineRec: Record "Sales Line";
        ItemRec: Record Item;
        SEWCalcTemplateRec: Record "SEW Calc Template";
        Customer: Record Customer;
    begin
        // [GIVEN] Setup is initialized with number series
        SEWCalcTestHelper.InitializeSetup();

        // [GIVEN] A template and item
        SEWCalcTestHelper.CreateTestTemplate(SEWCalcTemplateRec);
        ItemRec := SEWCalcTestHelper.CreateItemWithSimpleBOM();

        // [GIVEN] A sales quote with auto calculate enabled
        SalesHeaderRec.Init();
        SalesHeaderRec."Document Type" := SalesHeaderRec."Document Type"::Quote;
        SalesHeaderRec."Sell-to Customer No." := SEWCalcTestHelper.CreateTestCustomer(Customer);
        SalesHeaderRec."Bill-to Customer No." := SalesHeaderRec."Sell-to Customer No.";
        SalesHeaderRec.Insert(true);
        SalesHeaderRec."SEW Default Calc Template" := SEWCalcTemplateRec.Code;
        SalesHeaderRec."SEW Auto Calculate" := true;
        SalesHeaderRec.Modify();

        // [WHEN] Adding an item to a line (must use Validate to trigger EventSubscriber)
        SalesLineRec.Init();
        SalesLineRec."Document Type" := SalesHeaderRec."Document Type";
        SalesLineRec."Document No." := SalesHeaderRec."No.";
        SalesLineRec."Line No." := 10000;
        SalesLineRec.Insert(true);
        SalesLineRec.Type := SalesLineRec.Type::Item;
        SalesLineRec.Validate("No.", ItemRec."No.");
        SalesLineRec.Quantity := 1;
        SalesLineRec.Modify(true);

        // [THEN] Calculation should be created automatically
        SalesLineRec.Get(SalesLineRec."Document Type", SalesLineRec."Document No.", SalesLineRec."Line No.");
        SEWTestAssert.AreNotEqual('', SalesLineRec."SEW Calc No.", 'Auto calculation not triggered');
    end;

    [Test]
    procedure TestValidateMarginAboveTarget()
    var
        SalesHeaderRec: Record "Sales Header";
        SalesLineRec: Record "Sales Line";
        ItemRec: Record Item;
        SEWCalcHeaderRec: Record "SEW Calc Header";
        SEWCalcIntegMgmtCU: Codeunit "SEW Calc Integration Mgt.";
        IsValid: Boolean;
    begin
        // [GIVEN] A calculation with cost 100
        SEWCalcHeaderRec := SEWCalcTestHelper.CreateTestCalcWithCosts(60, 30, 10);

        // [GIVEN] A sales line with 30 percent margin (price 143, cost 100)
        SEWCalcTestHelper.CreateTestItem(ItemRec, 'TEST-ITEM-' + Format(Random(999)), 100);
        SalesHeaderRec.Init();
        SalesHeaderRec."Document Type" := SalesHeaderRec."Document Type"::Quote;
        SalesHeaderRec.Insert(true);
        SalesLineRec.Init();
        SalesLineRec."Document Type" := SalesHeaderRec."Document Type";
        SalesLineRec."Document No." := SalesHeaderRec."No.";
        SalesLineRec."Line No." := 10000;
        SalesLineRec.Type := SalesLineRec.Type::Item;
        SalesLineRec."No." := ItemRec."No.";
        SalesLineRec.Quantity := 1;
        SalesLineRec.Insert(true);
        SalesLineRec."SEW Calc No." := SEWCalcHeaderRec."No.";
        SalesLineRec.Validate("SEW Calc No.");
        SalesLineRec.Validate("Unit Price", 143);
        SalesLineRec.Modify();

        // [WHEN] Validating margin
        IsValid := SEWCalcIntegMgmtCU.ValidateMargin(SalesLineRec);

        // [THEN] Margin should be valid (above 15 percent minimum)
        SEWTestAssert.IsTrue(IsValid, 'Margin should be valid');
    end;

    [Test]
    procedure TestValidateMarginBelowTarget()
    var
        SalesHeaderRec: Record "Sales Header";
        SalesLineRec: Record "Sales Line";
        ItemRec: Record Item;
        SEWCalcHeaderRec: Record "SEW Calc Header";
        SEWCalcIntegMgmtCU: Codeunit "SEW Calc Integration Mgt.";
        IsValid: Boolean;
    begin
        // [GIVEN] A calculation with cost 100
        SEWCalcHeaderRec := SEWCalcTestHelper.CreateTestCalcWithCosts(60, 30, 10);

        // [GIVEN] A sales line with 10 percent margin (price 111, cost 100)
        SEWCalcTestHelper.CreateTestItem(ItemRec, 'TEST-ITEM-' + Format(Random(999)), 100);
        SalesHeaderRec.Init();
        SalesHeaderRec."Document Type" := SalesHeaderRec."Document Type"::Quote;
        SalesHeaderRec.Insert(true);
        SalesLineRec.Init();
        SalesLineRec."Document Type" := SalesHeaderRec."Document Type";
        SalesLineRec."Document No." := SalesHeaderRec."No.";
        SalesLineRec."Line No." := 10000;
        SalesLineRec.Type := SalesLineRec.Type::Item;
        SalesLineRec."No." := ItemRec."No.";
        SalesLineRec.Quantity := 1;
        SalesLineRec.Insert(true);
        SalesLineRec."SEW Calc No." := SEWCalcHeaderRec."No.";
        SalesLineRec.Validate("SEW Calc No.");
        SalesLineRec.Validate("Unit Price", 111);
        SalesLineRec.Modify();

        // [WHEN] Validating margin
        IsValid := SEWCalcIntegMgmtCU.ValidateMargin(SalesLineRec);

        // [THEN] Margin should be invalid (below 15 percent minimum)
        SEWTestAssert.IsFalse(IsValid, 'Margin should be invalid');
    end;

    [Test]
    procedure TestCostBreakdownFlowFields()
    var
        SalesHeaderRec: Record "Sales Header";
        SalesLineRec: Record "Sales Line";
        ItemRec: Record Item;
        SEWCalcHeaderRec: Record "SEW Calc Header";
    begin
        // [GIVEN] A calculation with specific cost components
        SEWCalcHeaderRec := SEWCalcTestHelper.CreateTestCalcWithCosts(150, 75, 45);

        // [GIVEN] A sales line linked to calculation
        SEWCalcTestHelper.CreateTestItem(ItemRec, 'TEST-ITEM-' + Format(Random(999)), 100);
        SalesHeaderRec.Init();
        SalesHeaderRec."Document Type" := SalesHeaderRec."Document Type"::Quote;
        SalesHeaderRec.Insert(true);
        SalesLineRec.Init();
        SalesLineRec."Document Type" := SalesHeaderRec."Document Type";
        SalesLineRec."Document No." := SalesHeaderRec."No.";
        SalesLineRec."Line No." := 10000;
        SalesLineRec.Type := SalesLineRec.Type::Item;
        SalesLineRec."No." := ItemRec."No.";
        SalesLineRec.Quantity := 1;
        SalesLineRec.Insert(true);
        SalesLineRec."SEW Calc No." := SEWCalcHeaderRec."No.";
        SalesLineRec.Validate("SEW Calc No.");
        SalesLineRec.Modify();

        // [WHEN] Calculating flow fields
        SalesLineRec.CalcFields("SEW Material Cost", "SEW Labor Cost", "SEW Overhead Cost");

        // [THEN] Flow fields should show correct breakdown
        SEWTestAssert.AreEqual(150, SalesLineRec."SEW Material Cost", 'Material cost incorrect');
        SEWTestAssert.AreEqual(75, SalesLineRec."SEW Labor Cost", 'Labor cost incorrect');
        SEWTestAssert.AreEqual(45, SalesLineRec."SEW Overhead Cost", 'Overhead cost incorrect');
    end;
}




