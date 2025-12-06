codeunit 90971 "SEW Test Assert"
{
    /// <summary>
    /// Simple assertion helper for tests without test libraries.
    /// </summary>

    procedure AreEqual(Expected: Decimal; Actual: Decimal; Message: Text)
    begin
        if Expected <> Actual then
            Error('Assertion failed: %1. Expected: %2, Actual: %3', Message, Expected, Actual);
    end;

    procedure AreEqual(Expected: Integer; Actual: Integer; Message: Text)
    begin
        if Expected <> Actual then
            Error('Assertion failed: %1. Expected: %2, Actual: %3', Message, Expected, Actual);
    end;

    procedure AreEqual(Expected: Text; Actual: Text; Message: Text)
    begin
        if Expected <> Actual then
            Error('Assertion failed: %1. Expected: %2, Actual: %3', Message, Expected, Actual);
    end;

    procedure AreEqual(Expected: Boolean; Actual: Boolean; Message: Text)
    begin
        if Expected <> Actual then
            Error('Assertion failed: %1. Expected: %2, Actual: %3', Message, Expected, Actual);
    end;

    procedure IsTrue(Condition: Boolean; Message: Text)
    begin
        if not Condition then
            Error('Assertion failed: %1', Message);
    end;

    procedure IsFalse(Condition: Boolean; Message: Text)
    begin
        if Condition then
            Error('Assertion failed: %1', Message);
    end;

    procedure Fail(Message: Text)
    begin
        Error('Test failed: %1', Message);
    end;
}
