/// <summary>
/// Simplified API for BC's standard Activity Log (Table 710).
/// Provides dual logging: success to Activity Log, failure to both Activity Log and Error Log.
/// </summary>
codeunit 71200 "SEW Activity Log Helper"
{
    Permissions = tabledata "Activity Log" = rimd;

    /// <summary>
    /// Log successful activity to standard BC Activity Log.
    /// </summary>
    /// <param name="RelatedRecordID">Record ID of related entity.</param>
    /// <param name="Description">Activity description.</param>
    /// <param name="DetailedInfo">Detailed information about the activity.</param>
    procedure LogSuccess(RelatedRecordID: RecordId; Description: Text; DetailedInfo: Text)
    var
        ActivityLogRec: Record "Activity Log";
    begin
        ActivityLogRec.LogActivity(
          RelatedRecordID,
          0, // Success
          'SEW',
          Description,
          DetailedInfo
        );
    end;

    /// <summary>
    /// Log failed activity to both BC Activity Log and SEW Error Log.
    /// </summary>
    /// <param name="RelatedRecordID">Record ID of related entity.</param>
    /// <param name="Description">Activity description.</param>
    /// <param name="DetailedInfo">Detailed error information.</param>
    procedure LogFailure(RelatedRecordID: RecordId; Description: Text; DetailedInfo: Text)
    var
        ActivityLogRec: Record "Activity Log";
        SEWErrorLogger: Codeunit "SEW Error Logger";
    begin
        // Log to standard BC Activity Log
        ActivityLogRec.LogActivity(
          RelatedRecordID,
          1, // Failed
          'SEW',
          Description,
          DetailedInfo
        );

        // Also log to SEW Error Log for analysis
        SEWErrorLogger.LogError(Description, DetailedInfo);
    end;

    /// <summary>
    /// Log integration/API call result.
    /// </summary>
    /// <param name="Source">Integration source name (e.g., "SharePoint", "SendCloud").</param>
    /// <param name="Endpoint">API endpoint or action name.</param>
    /// <param name="Success">Whether the call succeeded.</param>
    /// <param name="ResponseDetails">Response details or error message.</param>
    procedure LogIntegrationCall(Source: Text; Endpoint: Text; Success: Boolean; ResponseDetails: Text)
    var
        ActivityLogRec: Record "Activity Log";
        SEWErrorLogger: Codeunit "SEW Error Logger";
        Description: Text;
        Status: Integer;
        IntegrationCallLbl: Label 'Integration Call: %1 - %2', Comment = 'DE="Integrationsaufruf: %1 - %2"';
    begin
        Description := StrSubstNo(IntegrationCallLbl, Source, Endpoint);

        if Success then
            Status := 0 // Success
        else
            Status := 1; // Failed

        ActivityLogRec.LogActivity(
          Database::"Activity Log", // No specific related record
          Status,
          'SEW',
          Description,
          ResponseDetails
        );

        // Log failures to Error Log as well
        if not Success then
            SEWErrorLogger.LogError(Description, ResponseDetails);
    end;

    /// <summary>
    /// Log workflow process step.
    /// </summary>
    /// <param name="WorkflowCode">Workflow code or name.</param>
    /// <param name="StepDescription">Description of the workflow step.</param>
    /// <param name="Success">Whether the step succeeded.</param>
    /// <param name="Details">Step execution details.</param>
    procedure LogWorkflowStep(WorkflowCode: Code[20]; StepDescription: Text; Success: Boolean; Details: Text)
    var
        ActivityLogRec: Record "Activity Log";
        SEWErrorLogger: Codeunit "SEW Error Logger";
        Description: Text;
        Status: Integer;
        WorkflowStepLbl: Label 'Workflow %1: %2', Comment = 'DE="Workflow %1: %2"';
    begin
        Description := StrSubstNo(WorkflowStepLbl, WorkflowCode, StepDescription);

        if Success then
            Status := 0 // Success
        else
            Status := 1; // Failed

        ActivityLogRec.LogActivity(
          Database::"Activity Log",
          Status,
          'SEW',
          Description,
          Details
        );

        if not Success then
            SEWErrorLogger.LogError(Description, Details);
    end;

    /// <summary>
    /// Log batch job result.
    /// </summary>
    /// <param name="JobName">Name of the batch job.</param>
    /// <param name="RecordsProcessed">Number of records processed.</param>
    /// <param name="Success">Whether the job completed successfully.</param>
    /// <param name="Summary">Job execution summary.</param>
    procedure LogBatchJob(JobName: Text; RecordsProcessed: Integer; Success: Boolean; Summary: Text)
    var
        ActivityLogRec: Record "Activity Log";
        SEWErrorLogger: Codeunit "SEW Error Logger";
        Description: Text;
        DetailedInfo: Text;
        Status: Integer;
        BatchJobLbl: Label 'Batch Job: %1', Comment = 'DE="Batch-Auftrag: %1"';
        RecordsProcessedLbl: Label 'Records Processed: %1\%2', Comment = 'DE="Verarbeitete Datensätze: %1\%2"';
    begin
        Description := StrSubstNo(BatchJobLbl, JobName);
        DetailedInfo := StrSubstNo(RecordsProcessedLbl, RecordsProcessed, Summary);

        if Success then
            Status := 0 // Success
        else
            Status := 1; // Failed

        ActivityLogRec.LogActivity(
          Database::"Activity Log",
          Status,
          'SEW',
          Description,
          DetailedInfo
        );

        if not Success then
            SEWErrorLogger.LogError(Description, DetailedInfo);
    end;
}
