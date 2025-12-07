codeunit 90950 "SEW Calc Formula Parser Test"
{
    Subtype = Test;
    Permissions = tabledata "SEW Calc Header" = RMID,
                  tabledata "SEW Calc Line" = RMID,
                  tabledata "SEW Calc Variable" = RMID;

    /// <summary>
    /// Test codeunit for SEW Calc Formula Parser.
    /// Tests arithmetic operations, operator precedence, parentheses, and variable substitution.
    /// </summary>

    var
        SEWTestAssert: Codeunit "SEW Test Assert";
        SEWCalcFormulaParser: Codeunit "SEW Calc Formula Parser";
        SEWCalcTestHelper: Codeunit "SEW Calc Test Helper";

    [Test]
    procedure TestBasicAddition()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        Result: Decimal;
    begin
        // [GIVEN] Formula "10 + 5"
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader);

        // [WHEN] Evaluating formula
        Result := SEWCalcFormulaParser.EvaluateFormula('10 + 5', SEWCalcHeader);

        // [THEN] Result should be 15
        SEWTestAssert.AreEqual(15, Result, 'Basic addition 10 + 5 should equal 15');

        // [CLEANUP]
        SEWCalcHeader.Delete(true);
    end;

    [Test]
    procedure TestBasicSubtraction()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        Result: Decimal;
    begin
        // [GIVEN] Formula "20 - 8"
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader);

        // [WHEN] Evaluating formula
        Result := SEWCalcFormulaParser.EvaluateFormula('20 - 8', SEWCalcHeader);

        // [THEN] Result should be 12
        SEWTestAssert.AreEqual(12, Result, 'Basic subtraction 20 - 8 should equal 12');

        // [CLEANUP]
        SEWCalcHeader.Delete(true);
    end;

    [Test]
    procedure TestBasicMultiplication()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        Result: Decimal;
    begin
        // [GIVEN] Formula "6 * 7"
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader);

        // [WHEN] Evaluating formula
        Result := SEWCalcFormulaParser.EvaluateFormula('6 * 7', SEWCalcHeader);

        // [THEN] Result should be 42
        SEWTestAssert.AreEqual(42, Result, 'Basic multiplication 6 * 7 should equal 42');

        // [CLEANUP]
        SEWCalcHeader.Delete(true);
    end;

    [Test]
    procedure TestBasicDivision()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        Result: Decimal;
    begin
        // [GIVEN] Formula "100 / 4"
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader);

        // [WHEN] Evaluating formula
        Result := SEWCalcFormulaParser.EvaluateFormula('100 / 4', SEWCalcHeader);

        // [THEN] Result should be 25
        SEWTestAssert.AreEqual(25, Result, 'Basic division 100 / 4 should equal 25');

        // [CLEANUP]
        SEWCalcHeader.Delete(true);
    end;

    [Test]
    procedure TestOperatorPrecedenceMultiplicationFirst()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        Result: Decimal;
    begin
        // [GIVEN] Formula "10 + 5 * 2"
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader);

        // [WHEN] Evaluating formula
        Result := SEWCalcFormulaParser.EvaluateFormula('10 + 5 * 2', SEWCalcHeader);

        // [THEN] Result should be 20 (not 30), because multiplication has higher precedence
        SEWTestAssert.AreEqual(20, Result, 'Operator precedence: 10 + 5 * 2 should equal 20, not 30');

        // [CLEANUP]
        SEWCalcHeader.Delete(true);
    end;

    [Test]
    procedure TestOperatorPrecedenceDivisionFirst()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        Result: Decimal;
    begin
        // [GIVEN] Formula "100 - 20 / 4"
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader);

        // [WHEN] Evaluating formula
        Result := SEWCalcFormulaParser.EvaluateFormula('100 - 20 / 4', SEWCalcHeader);

        // [THEN] Result should be 95 (not 20), because division has higher precedence
        SEWTestAssert.AreEqual(95, Result, 'Operator precedence: 100 - 20 / 4 should equal 95, not 20');

        // [CLEANUP]
        SEWCalcHeader.Delete(true);
    end;

    [Test]
    procedure TestParenthesesOverridePrecedence()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        Result: Decimal;
    begin
        // [GIVEN] Formula "(10 + 5) * 2"
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader);

        // [WHEN] Evaluating formula
        Result := SEWCalcFormulaParser.EvaluateFormula('(10 + 5) * 2', SEWCalcHeader);

        // [THEN] Result should be 30, parentheses force addition first
        SEWTestAssert.AreEqual(30, Result, 'Parentheses: (10 + 5) * 2 should equal 30');

        // [CLEANUP]
        SEWCalcHeader.Delete(true);
    end;

    [Test]
    procedure TestNestedParentheses()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        Result: Decimal;
    begin
        // [GIVEN] Formula "((10 + 5) * 2) - 3"
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader);

        // [WHEN] Evaluating formula
        Result := SEWCalcFormulaParser.EvaluateFormula('((10 + 5) * 2) - 3', SEWCalcHeader);

        // [THEN] Result should be 27
        SEWTestAssert.AreEqual(27, Result, 'Nested parentheses: ((10 + 5) * 2) - 3 should equal 27');

        // [CLEANUP]
        SEWCalcHeader.Delete(true);
    end;

    [Test]
    procedure TestComplexFormula()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        Result: Decimal;
    begin
        // [GIVEN] Formula "100 + (50 - 10) * 2 / 4"
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader);

        // [WHEN] Evaluating formula
        Result := SEWCalcFormulaParser.EvaluateFormula('100 + (50 - 10) * 2 / 4', SEWCalcHeader);

        // [THEN] Result should be 120
        // Calculation: (50-10)=40, 40*2=80, 80/4=20, 100+20=120
        SEWTestAssert.AreEqual(120, Result, 'Complex formula: 100 + (50 - 10) * 2 / 4 should equal 120');

        // [CLEANUP]
        SEWCalcHeader.Delete(true);
    end;

    [Test]
    procedure TestDecimalNumbers()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        Result: Decimal;
    begin
        // [GIVEN] Formula "10.5 + 2.3"
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader);

        // [WHEN] Evaluating formula
        Result := SEWCalcFormulaParser.EvaluateFormula('10.5 + 2.3', SEWCalcHeader);

        // [THEN] Result should be 12.8
        SEWTestAssert.AreEqual(12.8, Result, 'Decimal numbers: 10.5 + 2.3 should equal 12.8');

        // [CLEANUP]
        SEWCalcHeader.Delete(true);
    end;

    [Test]
    procedure TestPercentageVariable()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        SEWCalcVariable: Record "SEW Calc Variable";
        Result: Decimal;
    begin
        // [GIVEN] Variable MARGIN-1 = 20% and formula "100 * {MARGIN-1}"
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader);
        SEWCalcTestHelper.CreateTestVariable(SEWCalcVariable, 'MARGIN-1', SEWCalcVariable.Type::Percentage, 20, SEWCalcHeader."Calculation Date");

        // [WHEN] Evaluating formula
        Result := SEWCalcFormulaParser.EvaluateFormula('100 * {MARGIN-1}', SEWCalcHeader);

        // [THEN] Result should be 20 (100 * 0.20)
        SEWTestAssert.AreEqual(20, Result, 'Percentage variable: 100 * {MARGIN-1} should equal 20');

        // [CLEANUP]
        SEWCalcHeader.Delete(true);
        SEWCalcVariable.Delete(true);
    end;

    [Test]
    procedure TestAbsoluteVariable()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        SEWCalcVariable: Record "SEW Calc Variable";
        Result: Decimal;
    begin
        // [GIVEN] Variable SETUP-FEE = 50.00 (absolute) and formula "100 + {SETUP-FEE}"
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader);
        SEWCalcTestHelper.CreateTestVariable(SEWCalcVariable, 'SETUP-FEE', SEWCalcVariable.Type::"Absolute Value", 50, SEWCalcHeader."Calculation Date");

        // [WHEN] Evaluating formula
        Result := SEWCalcFormulaParser.EvaluateFormula('100 + {SETUP-FEE}', SEWCalcHeader);

        // [THEN] Result should be 150
        SEWTestAssert.AreEqual(150, Result, 'Absolute variable: 100 + {SETUP-FEE} should equal 150');

        // [CLEANUP]
        SEWCalcHeader.Delete(true);
        SEWCalcVariable.Delete(true);
    end;

    [Test]
    procedure TestFactorVariable()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        SEWCalcVariable: Record "SEW Calc Variable";
        Result: Decimal;
    begin
        // [GIVEN] Variable MULTIPLIER = 1.5 (factor) and formula "100 * {MULTIPLIER}"
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader);
        SEWCalcTestHelper.CreateTestVariable(SEWCalcVariable, 'MULTIPLIER', SEWCalcVariable.Type::Factor, 1.5, SEWCalcHeader."Calculation Date");

        // [WHEN] Evaluating formula
        Result := SEWCalcFormulaParser.EvaluateFormula('100 * {MULTIPLIER}', SEWCalcHeader);

        // [THEN] Result should be 150
        SEWTestAssert.AreEqual(150, Result, 'Factor variable: 100 * {MULTIPLIER} should equal 150');

        // [CLEANUP]
        SEWCalcHeader.Delete(true);
        SEWCalcVariable.Delete(true);
    end;

    [Test]
    procedure TestMultipleVariables()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        SEWCalcVariable1: Record "SEW Calc Variable";
        SEWCalcVariable2: Record "SEW Calc Variable";
        Result: Decimal;
    begin
        // [GIVEN] Variable VAR1 = 10 (absolute) and VAR2 = 20% (percentage)
        // [GIVEN] Formula "100 + {VAR1} * {VAR2}"
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader);
        SEWCalcTestHelper.CreateTestVariable(SEWCalcVariable1, 'VAR1', SEWCalcVariable1.Type::"Absolute Value", 10, SEWCalcHeader."Calculation Date");
        SEWCalcTestHelper.CreateTestVariable(SEWCalcVariable2, 'VAR2', SEWCalcVariable2.Type::Percentage, 20, SEWCalcHeader."Calculation Date");

        // [WHEN] Evaluating formula
        Result := SEWCalcFormulaParser.EvaluateFormula('100 + {VAR1} * {VAR2}', SEWCalcHeader);

        // [THEN] Result should be 102 (100 + 10 * 0.20 = 100 + 2 = 102)
        SEWTestAssert.AreEqual(102, Result, 'Multiple variables: 100 + {VAR1} * {VAR2} should equal 102');

        // [CLEANUP]
        SEWCalcHeader.Delete(true);
        SEWCalcVariable1.Delete(true);
        SEWCalcVariable2.Delete(true);
    end;

    [Test]
    procedure TestNegativeNumbers()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        Result: Decimal;
    begin
        // [GIVEN] Formula with negative number "100 + (-25)"
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader);

        // [WHEN] Evaluating formula
        Result := SEWCalcFormulaParser.EvaluateFormula('100 + (-25)', SEWCalcHeader);

        // [THEN] Result should be 75
        SEWTestAssert.AreEqual(75, Result, 'Negative numbers: 100 + (-25) should equal 75');

        // [CLEANUP]
        SEWCalcHeader.Delete(true);
    end;

    [Test]
    procedure TestZeroValues()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        Result: Decimal;
    begin
        // [GIVEN] Formula "0 + 0 * 100"
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader);

        // [WHEN] Evaluating formula
        Result := SEWCalcFormulaParser.EvaluateFormula('0 + 0 * 100', SEWCalcHeader);

        // [THEN] Result should be 0
        SEWTestAssert.AreEqual(0, Result, 'Zero values: 0 + 0 * 100 should equal 0');

        // [CLEANUP]
        SEWCalcHeader.Delete(true);
    end;
}
