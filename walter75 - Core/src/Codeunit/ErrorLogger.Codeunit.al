/// <summary>
/// Centralized error logging API for all SEW applications.
/// Always enabled with no configuration required.
/// </summary>
codeunit 71100 "SEW Error Logger"
{
    Permissions = tabledata "SEW Error Log" = rimd;

    /// <summary>
    /// Log an error message.
    /// </summary>
    /// <param name="ErrorMessage">Error message text.</param>
    /// <param name="ContextInfo">Additional context information.</param>
    procedure LogError(ErrorMessage: Text; ContextInfo: Text)
    begin
        LogErrorInternal(ErrorMessage, ContextInfo, Enum::"SEW Error Severity"::Error, 0);
    end;

    /// <summary>
    /// Log a warning message.
    /// </summary>
    /// <param name="WarningMessage">Warning message text.</param>
    /// <param name="ContextInfo">Additional context information.</param>
    procedure LogWarning(WarningMessage: Text; ContextInfo: Text)
    begin
        LogErrorInternal(WarningMessage, ContextInfo, Enum::"SEW Error Severity"::Warning, 0);
    end;

    /// <summary>
    /// Log an informational message.
    /// </summary>
    /// <param name="InfoMessage">Information message text.</param>
    /// <param name="ContextInfo">Additional context information.</param>
    procedure LogInfo(InfoMessage: Text; ContextInfo: Text)
    begin
        LogErrorInternal(InfoMessage, ContextInfo, Enum::"SEW Error Severity"::Info, 0);
    end;

    /// <summary>
    /// Log a critical error message.
    /// </summary>
    /// <param name="CriticalMessage">Critical error message text.</param>
    /// <param name="ContextInfo">Additional context information.</param>
    procedure LogCritical(CriticalMessage: Text; ContextInfo: Text)
    begin
        LogErrorInternal(CriticalMessage, ContextInfo, Enum::"SEW Error Severity"::Critical, 0);
    end;

    /// <summary>
    /// Log an error with specific object identification.
    /// </summary>
    /// <param name="ErrorMessage">Error message text.</param>
    /// <param name="ContextInfo">Additional context information.</param>
    /// <param name="ObjectID">ID of object where error occurred.</param>
    procedure LogErrorWithObject(ErrorMessage: Text; ContextInfo: Text; ObjectID: Integer)
    begin
        LogErrorInternal(ErrorMessage, ContextInfo, Enum::"SEW Error Severity"::Error, ObjectID);
    end;

    /// <summary>
    /// Log an exception from ErrorInfo.
    /// </summary>
    /// <param name="ErrorInfo">Error information from BC error handling.</param>
    procedure LogException(ErrorInfo: ErrorInfo)
    var
        SEWErrorLog: Record "SEW Error Log";
    begin
        SEWErrorLog.Init();
        SEWErrorLog.Severity := Enum::"SEW Error Severity"::Error;
        SEWErrorLog."Error Message" := CopyStr(ErrorInfo.Message(), 1, MaxStrLen(SEWErrorLog."Error Message"));
        SEWErrorLog."Context Info" := CopyStr(ErrorInfo.DetailedMessage(), 1, MaxStrLen(SEWErrorLog."Context Info"));
        SEWErrorLog.Insert(true);

        if ErrorInfo.Collectible() then
            SEWErrorLog.SetStackTrace(ErrorInfo.Callstack());

        OnAfterErrorLogged(SEWErrorLog);
    end;

    local procedure LogErrorInternal(ErrorMessage: Text; ContextInfo: Text; Severity: Enum "SEW Error Severity"; ObjectID: Integer)
    var
        SEWErrorLog: Record "SEW Error Log";
    begin
        SEWErrorLog.Init();
        SEWErrorLog.Severity := Severity;
        SEWErrorLog."Error Message" := CopyStr(ErrorMessage, 1, MaxStrLen(SEWErrorLog."Error Message"));
        SEWErrorLog."Context Info" := CopyStr(ContextInfo, 1, MaxStrLen(SEWErrorLog."Context Info"));
        SEWErrorLog."Object ID" := ObjectID;
        SEWErrorLog.Insert(true);

        OnAfterErrorLogged(SEWErrorLog);
    end;

    /// <summary>
    /// Integration event fired after error is logged.
    /// </summary>
    /// <param name="SEWErrorLog">The error log entry that was created.</param>
    [IntegrationEvent(false, false)]
    local procedure OnAfterErrorLogged(SEWErrorLog: Record "SEW Error Log")
    begin
    end;
}
