/// <summary>
/// Codeunit SEW Content Change Detector (ID 91863).
/// Detects when Microsoft Learn content is updated and notifies employees.
/// </summary>
codeunit 91863 "SEW Content Change Detector"
{
    Permissions =
    tabledata "SEW Learn Cont" = r,
    tabledata "SEW Empl. Learning Assign." = rm,
    tabledata "User Task" = ri;

    /// <summary>
    /// Main entry point for change detection.
    /// </summary>
    procedure DetectChanges()
    var
        Setup: Record "SEW Learning Mgmt Setup";
    begin
        if not Setup.Get() then
            exit;

        if not Setup."Notify on Content Update" then
            exit;

        CheckModuleChanges();
        CheckLearningPathChanges();
    end;

    local procedure CheckModuleChanges()
    var
        Assignment: Record "SEW Empl. Learning Assign.";
        LearningContent: Record "SEW Learn Cont";
        AssignmentsToNotify: List of [Integer];
    begin
        Assignment.SetRange("Assignment Type", Assignment."Assignment Type"::Module);
        Assignment.SetRange(Status, Assignment.Status::Completed);
        if Assignment.FindSet() then
            repeat
                LearningContent.SetRange(UID, Assignment."Learn Cont UID");
                LearningContent.SetRange("Content Type", LearningContent."Content Type"::Module);
                if LearningContent.FindFirst() then
                    if Assignment."Content Version" <> LearningContent."Catalog Hash" then
                        if Assignment."Content Version" <> '' then begin
                            AssignmentsToNotify.Add(Assignment."Entry No.");
                            OnContentUpdateDetected(Assignment."Entry No.", Assignment."Content Version", LearningContent."Catalog Hash");
                        end;
            until Assignment.Next() = 0;

        if AssignmentsToNotify.Count > 0 then begin
            MarkAssignmentsOutdated(AssignmentsToNotify);
            NotifyEmployees(AssignmentsToNotify);
        end;
    end;

    local procedure CheckLearningPathChanges()
    var
        Assignment: Record "SEW Empl. Learning Assign.";
        LearningContent: Record "SEW Learn Cont";
        AssignmentsToNotify: List of [Integer];
    begin
        Assignment.SetRange("Assignment Type", Assignment."Assignment Type"::"Learning Path");
        Assignment.SetRange(Status, Assignment.Status::Completed);
        if Assignment.FindSet() then
            repeat
                LearningContent.SetRange(UID, Assignment."Learn Cont UID");
                LearningContent.SetRange("Content Type", LearningContent."Content Type"::"Learning Path");
                if LearningContent.FindFirst() then
                    if Assignment."Content Version" <> LearningContent."Catalog Hash" then
                        if Assignment."Content Version" <> '' then begin
                            AssignmentsToNotify.Add(Assignment."Entry No.");
                            OnContentUpdateDetected(Assignment."Entry No.", Assignment."Content Version", LearningContent."Catalog Hash");
                        end;
            until Assignment.Next() = 0;

        if AssignmentsToNotify.Count > 0 then begin
            MarkAssignmentsOutdated(AssignmentsToNotify);
            NotifyEmployees(AssignmentsToNotify);
        end;
    end;

    /// <summary>
    /// Notifies employees about updated content.
    /// </summary>
    /// <param name="AssignmentList">List of assignment entry numbers.</param>
    procedure NotifyEmployees(AssignmentList: List of [Integer])
    var
        AssignmentMgr: Codeunit "SEW Assignment Manager";
        AssignmentNo: Integer;
    begin
        foreach AssignmentNo in AssignmentList do
            AssignmentMgr.NotifyContentUpdate(AssignmentNo);
    end;

    /// <summary>
    /// Marks assignments as outdated.
    /// </summary>
    /// <param name="AssignmentList">List of assignment entry numbers.</param>
    procedure MarkAssignmentsOutdated(AssignmentList: List of [Integer])
    var
        Assignment: Record "SEW Empl. Learning Assign.";
        AssignmentNo: Integer;
    begin
        foreach AssignmentNo in AssignmentList do
            if Assignment.Get(AssignmentNo) then begin
                Assignment.Status := Assignment.Status::Outdated;
                Assignment."Version Outdated" := true;
                Assignment.Modify(true);
            end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnContentUpdateDetected(AssignmentEntryNo: Integer; OldHash: Code[50]; NewHash: Code[50])
    begin
    end;
}
