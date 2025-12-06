codeunit 90951 "SEW Calc Variable Test"
{
    Subtype = Test;

    /// <summary>
    /// Test codeunit for SEW Calc Variable system.
    /// Tests variable types, date ranges, global vs. local variables.
    /// </summary>

    var
        SEWTestAssert: Codeunit "SEW Test Assert";
        SEWCalcTestHelper: Codeunit "SEW Calc Test Helper";

    [Test]
    procedure TestPercentageVariableCreation()
    var
        SEWCalcVariable: Record "SEW Calc Variable";
    begin
        // [GIVEN] Percentage variable with 25%
        SEWCalcTestHelper.CreateTestVariable(SEWCalcVariable, 'TEST-PCT', SEWCalcVariable.Type::Percentage, 25);

        // [THEN] Variable should be created correctly
        SEWTestAssert.AreEqual('TEST-PCT', SEWCalcVariable.Code, 'Variable code should match');
        SEWTestAssert.AreEqual(SEWCalcVariable.Type::Percentage.AsInteger(), SEWCalcVariable.Type.AsInteger(), 'Type should be Percentage');
        SEWTestAssert.AreEqual(25, SEWCalcVariable.Value, 'Value should be 25');

        // [CLEANUP]
        SEWCalcVariable.Delete(true);
    end;

    [Test]
    procedure TestAbsoluteVariableCreation()
    var
        SEWCalcVariable: Record "SEW Calc Variable";
    begin
        // [GIVEN] Absolute value variable with 50.00
        SEWCalcTestHelper.CreateTestVariable(SEWCalcVariable, 'TEST-ABS', SEWCalcVariable.Type::"Absolute Value", 50);

        // [THEN] Variable should be created correctly
        SEWTestAssert.AreEqual('TEST-ABS', SEWCalcVariable.Code, 'Variable code should match');
        SEWTestAssert.AreEqual(SEWCalcVariable.Type::"Absolute Value".AsInteger(), SEWCalcVariable.Type.AsInteger(), 'Type should be Absolute Value');
        SEWTestAssert.AreEqual(50, SEWCalcVariable.Value, 'Value should be 50');

        // [CLEANUP]
        SEWCalcVariable.Delete(true);
    end;

    [Test]
    procedure TestFactorVariableCreation()
    var
        SEWCalcVariable: Record "SEW Calc Variable";
    begin
        // [GIVEN] Factor variable with 1.5
        SEWCalcTestHelper.CreateTestVariable(SEWCalcVariable, 'TEST-FCT', SEWCalcVariable.Type::Factor, 1.5);

        // [THEN] Variable should be created correctly
        SEWTestAssert.AreEqual('TEST-FCT', SEWCalcVariable.Code, 'Variable code should match');
        SEWTestAssert.AreEqual(SEWCalcVariable.Type::Factor.AsInteger(), SEWCalcVariable.Type.AsInteger(), 'Type should be Factor');
        SEWTestAssert.AreEqual(1.5, SEWCalcVariable.Value, 'Value should be 1.5');

        // [CLEANUP]
        SEWCalcVariable.Delete(true);
    end;

    [Test]
    procedure TestGlobalVariable()
    var
        SEWCalcVariable: Record "SEW Calc Variable";
    begin
        // [GIVEN] Global variable
        SEWCalcTestHelper.CreateTestVariable(SEWCalcVariable, 'TEST-GLB', SEWCalcVariable.Type::Percentage, 10);

        // [THEN] Variable should be marked as global
        SEWTestAssert.IsTrue(SEWCalcVariable.Global, 'Variable should be global');

        // [CLEANUP]
        SEWCalcVariable.Delete(true);
    end;

    [Test]
    procedure TestVariableDateRange()
    var
        SEWCalcVariable: Record "SEW Calc Variable";
    begin
        // [GIVEN] Variable with date range
        SEWCalcTestHelper.CreateTestVariable(SEWCalcVariable, 'TEST-DT', SEWCalcVariable.Type::Percentage, 15);

        // [THEN] Date range should be set
        SEWTestAssert.IsTrue(SEWCalcVariable."Valid From Date" <> 0D, 'Valid From Date should be set');
        SEWTestAssert.IsTrue(SEWCalcVariable."Valid To Date" <> 0D, 'Valid To Date should be set');

        // [CLEANUP]
        SEWCalcVariable.Delete(true);
    end;

    [Test]
    procedure TestVariableDescriptionAutoFill()
    var
        SEWCalcVariable: Record "SEW Calc Variable";
    begin
        // [GIVEN] Variable created with code
        SEWCalcTestHelper.CreateTestVariable(SEWCalcVariable, 'TEST-DESC', SEWCalcVariable.Type::Factor, 2);

        // [THEN] Description should be auto-filled
        SEWTestAssert.AreEqual('Test Variable TEST-DESC', SEWCalcVariable.Description, 'Description should be auto-filled');

        // [CLEANUP]
        SEWCalcVariable.Delete(true);
    end;

    [Test]
    procedure TestMultipleVariablesWithSamePrefix()
    var
        SEWCalcVariable1: Record "SEW Calc Variable";
        SEWCalcVariable2: Record "SEW Calc Variable";
        SEWCalcVariable3: Record "SEW Calc Variable";
    begin
        // [GIVEN] Multiple variables with same prefix
        SEWCalcTestHelper.CreateTestVariable(SEWCalcVariable1, 'MARGIN-1', SEWCalcVariable1.Type::Percentage, 10);
        SEWCalcTestHelper.CreateTestVariable(SEWCalcVariable2, 'MARGIN-2', SEWCalcVariable2.Type::Percentage, 15);
        SEWCalcTestHelper.CreateTestVariable(SEWCalcVariable3, 'MARGIN-3', SEWCalcVariable3.Type::Percentage, 20);

        // [THEN] All variables should exist independently
        SEWTestAssert.IsTrue(SEWCalcVariable1.Get('MARGIN-1', WorkDate()), 'MARGIN-1 should exist');
        SEWTestAssert.IsTrue(SEWCalcVariable2.Get('MARGIN-2', WorkDate()), 'MARGIN-2 should exist');
        SEWTestAssert.IsTrue(SEWCalcVariable3.Get('MARGIN-3', WorkDate()), 'MARGIN-3 should exist');

        // [CLEANUP]
        SEWCalcVariable1.Delete(true);
        SEWCalcVariable2.Delete(true);
        SEWCalcVariable3.Delete(true);
    end;

    [Test]
    procedure TestVariableWithZeroValue()
    var
        SEWCalcVariable: Record "SEW Calc Variable";
    begin
        // [GIVEN] Variable with zero value
        SEWCalcTestHelper.CreateTestVariable(SEWCalcVariable, 'TEST-ZERO', SEWCalcVariable.Type::Percentage, 0);

        // [THEN] Zero value should be allowed
        SEWTestAssert.AreEqual(0, SEWCalcVariable.Value, 'Zero value should be allowed');

        // [CLEANUP]
        SEWCalcVariable.Delete(true);
    end;

    [Test]
    procedure TestVariableWithNegativeValue()
    var
        SEWCalcVariable: Record "SEW Calc Variable";
    begin
        // [GIVEN] Variable with negative value
        SEWCalcVariable.Init();
        SEWCalcVariable.Code := 'TEST-NEG';
        SEWCalcVariable.Type := SEWCalcVariable.Type::Factor;
        SEWCalcVariable.Value := -1.5;
        SEWCalcVariable.Global := true;
        SEWCalcVariable.Insert(true);

        // [THEN] Negative value should be allowed (for discounts, etc.)
        SEWTestAssert.AreEqual(-1.5, SEWCalcVariable.Value, 'Negative value should be allowed');

        // [CLEANUP]
        SEWCalcVariable.Delete(true);
    end;

    [Test]
    procedure TestVariableWithLargeValue()
    var
        SEWCalcVariable: Record "SEW Calc Variable";
        LargeValue: Decimal;
    begin
        // [GIVEN] Variable with large value
        LargeValue := 999999.99;
        SEWCalcTestHelper.CreateTestVariable(SEWCalcVariable, 'TEST-LRG', SEWCalcVariable.Type::"Absolute Value", LargeValue);

        // [THEN] Large value should be stored correctly
        SEWTestAssert.AreEqual(LargeValue, SEWCalcVariable.Value, 'Large value should be stored correctly');

        // [CLEANUP]
        SEWCalcVariable.Delete(true);
    end;
}
