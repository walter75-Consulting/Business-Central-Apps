codeunit 90851 "SEW Calc Formula Parser"
{
    /// <summary>
    /// Evaluates a formula string and returns the calculated result.
    /// Supports basic math operators: +, -, *, /, ()
    /// Replaces variables before evaluation.
    /// </summary>
    procedure EvaluateFormula(FormulaText: Text; var CalcHeader: Record "SEW Calc Header"): Decimal
    var
        ProcessedFormula: Text;
        Result: Decimal;
    begin
        if FormulaText = '' then
            exit(0);

        // Step 1: Replace all variables with their values
        ProcessedFormula := ReplaceVariables(FormulaText, CalcHeader);

        // Step 2: Validate the formula
        ValidateFormula(ProcessedFormula);

        // Step 3: Evaluate the mathematical expression
        Result := EvaluateMathExpression(ProcessedFormula);

        exit(Result);
    end;

    /// <summary>
    /// Replaces system and custom variables in the formula with their actual values.
    /// System variables: MATERIAL, LABOR, OVERHEAD, TOTALCOST
    /// Custom variables: VAR001, VAR002, etc.
    /// </summary>
    local procedure ReplaceVariables(FormulaText: Text; var CalcHeader: Record "SEW Calc Header"): Text
    var
        Result: Text;
        CalcVariable: Record "SEW Calc Variable";
        CalcTemplateLine: Record "SEW Calc Template Line";
        VariableValue: Decimal;
        StartPos: Integer;
        EndPos: Integer;
        VariableCode: Text;
        VariableFound: Boolean;
    begin
        Result := FormulaText;

        // Replace system variables
        Result := Result.Replace('MATERIAL', Format(CalcHeader."Total Material Cost", 0, 9));
        Result := Result.Replace('LABOR', Format(CalcHeader."Total Labor Cost", 0, 9));
        Result := Result.Replace('OVERHEAD', Format(CalcHeader."Total Overhead Cost", 0, 9));
        Result := Result.Replace('TOTALCOST', Format(CalcHeader."Total Cost", 0, 9));

        // Replace variables in {VARNAME} syntax
        while StrPos(Result, '{') > 0 do begin
            StartPos := StrPos(Result, '{');
            EndPos := StrPos(CopyStr(Result, StartPos + 1), '}');
            if EndPos > 0 then begin
                VariableCode := CopyStr(Result, StartPos + 1, EndPos - 1);
                // Find variable - try with date filter first, then fallback to any match
                CalcVariable.Reset();
                CalcVariable.SetRange(Code, CopyStr(VariableCode, 1, 20));

                VariableFound := false;
                if CalcHeader."Calculation Date" <> 0D then begin
                    // First try: Find variables with 0D (always valid) - keep Code filter!
                    CalcVariable.SetRange("Valid From Date", 0D);
                    CalcVariable.SetRange("Valid To Date", 0D);
                    VariableFound := CalcVariable.FindLast();

                    if not VariableFound then begin
                        // Second try: Find variables within date range - restore Code filter
                        CalcVariable.Reset();
                        CalcVariable.SetRange(Code, CopyStr(VariableCode, 1, 20));
                        CalcVariable.SetFilter("Valid From Date", '<=%1', CalcHeader."Calculation Date");
                        CalcVariable.SetFilter("Valid To Date", '%1|>=%2', 0D, CalcHeader."Calculation Date");
                        VariableFound := CalcVariable.FindLast();
                    end;

                    if not VariableFound then begin
                        // Fallback: try without any date filter - restore Code filter
                        CalcVariable.Reset();
                        CalcVariable.SetRange(Code, CopyStr(VariableCode, 1, 20));
                        VariableFound := CalcVariable.FindLast();
                    end;
                end else
                    VariableFound := CalcVariable.FindLast();

                if VariableFound then begin
                    VariableValue := GetVariableValue(CalcVariable, CalcHeader."Calculation Date");
                    Result := Result.Replace('{' + VariableCode + '}', Format(VariableValue, 0, 9));
                end else
                    // Variable not found - replace with 0
                    Result := Result.Replace('{' + VariableCode + '}', '0');
            end else
                break; // No closing brace found
        end;

        // Replace custom variables from template
        if CalcHeader."Template Code" <> '' then begin
            CalcTemplateLine.SetRange("Template Code", CalcHeader."Template Code");
            CalcTemplateLine.SetFilter("Variable Code", '<>%1', '');
            if CalcTemplateLine.FindSet() then
                repeat
                    if CalcVariable.Get(CalcTemplateLine."Variable Code", 0D) then begin
                        VariableValue := GetVariableValue(CalcVariable, CalcHeader."Calculation Date");
                        Result := Result.Replace(CalcVariable.Code, Format(VariableValue, 0, 9));
                    end;
                until CalcTemplateLine.Next() = 0;
        end;

        exit(Result);
    end;

    /// <summary>
    /// Gets the value of a variable for a specific date.
    /// If the variable has date-specific values, returns the appropriate one.
    /// </summary>
    local procedure GetVariableValue(var CalcVariable: Record "SEW Calc Variable"; CalculationDate: Date): Decimal
    begin
        // For now, return the base value
        // Future enhancement: Date-based variable values
        case CalcVariable.Type of
            CalcVariable.Type::Percentage:
                exit(CalcVariable.Value / 100);
            CalcVariable.Type::"Absolute Value":
                exit(CalcVariable.Value);
            CalcVariable.Type::Factor:
                exit(CalcVariable.Value);
            else
                exit(0);
        end;
    end;

    /// <summary>
    /// Validates a formula for correct syntax.
    /// Checks for balanced parentheses and valid characters.
    /// </summary>
    local procedure ValidateFormula(FormulaText: Text)
    var
        i: Integer;
        ParenthesesCount: Integer;
        CurrentChar: Char;
        InvalidFormulaErr: Label 'Invalid formula: %1', Comment = 'DE="Ungültige Formel: %1"';
        UnbalancedParenthesesErr: Label 'Unbalanced parentheses in formula', Comment = 'DE="Unausgeglichene Klammern in Formel"';
    begin
        ParenthesesCount := 0;

        for i := 1 to StrLen(FormulaText) do begin
            CurrentChar := FormulaText[i];
            case CurrentChar of
                '(':
                    ParenthesesCount += 1;
                ')':
                    begin
                        ParenthesesCount -= 1;
                        if ParenthesesCount < 0 then
                            Error(UnbalancedParenthesesErr);
                    end;
                '0' .. '9', '.', '+', '-', '*', '/', ' ', '{', '}', 'A' .. 'Z', 'a' .. 'z':
                    ; // Valid characters including variable placeholders
                else
                    Error(InvalidFormulaErr, FormulaText);
            end;
        end;

        if ParenthesesCount <> 0 then
            Error(UnbalancedParenthesesErr);
    end;

    /// <summary>
    /// Evaluates a mathematical expression with basic operators.
    /// Supports: +, -, *, /, ()
    /// Respects operator precedence.
    /// </summary>
    local procedure EvaluateMathExpression(Expression: Text): Decimal
    var
        Result: Decimal;
    begin
        Expression := Expression.Replace(' ', ''); // Remove spaces
        Result := ParseExpression(Expression);
        exit(Result);
    end;

    /// <summary>
    /// Parses and evaluates addition and subtraction.
    /// </summary>
    local procedure ParseExpression(var Expression: Text): Decimal
    var
        Result: Decimal;
        Operator: Char;
    begin
        Result := ParseTerm(Expression);

        while (StrLen(Expression) > 0) and ((Expression[1] = '+') or (Expression[1] = '-')) do begin
            Operator := Expression[1];
            Expression := CopyStr(Expression, 2);

            case Operator of
                '+':
                    Result += ParseTerm(Expression);
                '-':
                    Result -= ParseTerm(Expression);
            end;
        end;

        exit(Result);
    end;

    /// <summary>
    /// Parses and evaluates multiplication and division.
    /// </summary>
    local procedure ParseTerm(var Expression: Text): Decimal
    var
        Result: Decimal;
        Operator: Char;
    begin
        Result := ParseFactor(Expression);

        while (StrLen(Expression) > 0) and ((Expression[1] = '*') or (Expression[1] = '/')) do begin
            Operator := Expression[1];
            Expression := CopyStr(Expression, 2);

            case Operator of
                '*':
                    Result *= ParseFactor(Expression);
                '/':
                    Result /= ParseFactor(Expression);
            end;
        end;

        exit(Result);
    end;

    /// <summary>
    /// Parses and evaluates numbers and parenthesized expressions.
    /// </summary>
    local procedure ParseFactor(var Expression: Text): Decimal
    var
        Result: Decimal;
        NumberText: Text;
        i: Integer;
        IsNegative: Boolean;
    begin
        // Handle negative numbers
        if (StrLen(Expression) > 0) and (Expression[1] = '-') then begin
            IsNegative := true;
            Expression := CopyStr(Expression, 2);
        end;

        // Handle parentheses
        if (StrLen(Expression) > 0) and (Expression[1] = '(') then begin
            Expression := CopyStr(Expression, 2); // Remove opening (
            Result := ParseExpression(Expression);
            if (StrLen(Expression) > 0) and (Expression[1] = ')') then
                Expression := CopyStr(Expression, 2) // Remove closing )
            else
                Error('Missing closing parenthesis');
        end else begin
            // Parse number
            NumberText := '';
            i := 1;
            while (i <= StrLen(Expression)) and
                  ((Expression[i] >= '0') and (Expression[i] <= '9') or (Expression[i] = '.')) do begin
                NumberText += Format(Expression[i]);
                i += 1;
            end;

            if NumberText = '' then
                Error('Expected number in expression');

            Expression := CopyStr(Expression, i);
            Evaluate(Result, NumberText);
        end;

        if IsNegative then
            Result := -Result;

        exit(Result);
    end;

    /// <summary>
    /// Tests if a formula is valid without evaluating it.
    /// Returns true if valid, false otherwise.
    /// </summary>
    procedure TestFormula(FormulaText: Text): Boolean
    var
        DummyHeader: Record "SEW Calc Header";
    begin
        if FormulaText = '' then
            exit(true);

        // Try to validate the structure
        if not TryValidateFormulaStructure(FormulaText) then
            exit(false);

        exit(true);
    end;

    [TryFunction]
    local procedure TryValidateFormulaStructure(FormulaText: Text)
    begin
        ValidateFormula(FormulaText);
    end;
}
