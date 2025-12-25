/// <summary>
/// Codeunit SEW Assignment Manager (ID 91861).
/// Creates and manages employee learning assignments.
/// </summary>
codeunit 91861 "SEW Assignment Manager"
{
    Permissions =
    tabledata "SEW Empl. Learning Assign." = rimd,
    tabledata "SEW Assignment Module Progress" = rimd,
    tabledata "User Task" = ri;

    /// <summary>
    /// Assigns a module to an employee.
    /// </summary>
    /// <param name="EmployeeNo">Employee number.</param>
    /// <param name="ModuleUID">Module UID.</param>
    /// <param name="DueDate">Due date for completion.</param>
    /// <returns>Assignment Entry No.</returns>
    procedure AssignModuleToEmployee(EmployeeNo: Code[20]; ModuleUID: Code[100]; DueDate: Date): Integer
    var
        Assignment: Record "SEW Empl. Learning Assign.";
        LearningContent: Record "SEW Learn Cont";
    begin
        // Validate module exists
        LearningContent.SetRange(UID, ModuleUID);
        LearningContent.SetRange("Content Type", LearningContent."Content Type"::Module);
        if not LearningContent.FindFirst() then
            Error(ModuleNotFoundErr, ModuleUID);

        // Check for duplicate assignment
        Assignment.SetRange("Employee No.", EmployeeNo);
        Assignment.SetRange("Assignment Type", Assignment."Assignment Type"::Module);
        Assignment.SetRange("Learn Cont UID", ModuleUID);
        if not Assignment.IsEmpty() then
            Error(DuplicateAssignmentErr, LearningContent.Title, EmployeeNo);

        // Create assignment
        Assignment.Init();
        Assignment."Assignment Type" := Assignment."Assignment Type"::Module;
        Assignment."Employee No." := EmployeeNo;
        Assignment."Learn Cont UID" := ModuleUID;
        Assignment."Due Date" := DueDate;
        Assignment.Insert(true);

        // Create User Task if enabled
        CreateUserTaskIfEnabled(Assignment."Entry No.");

        OnAfterAssignmentCreated(Assignment);

        exit(Assignment."Entry No.");
    end;

    /// <summary>
    /// Assigns a learning path to an employee.
    /// </summary>
    /// <param name="EmployeeNo">Employee number.</param>
    /// <param name="PathUID">Learning Path UID.</param>
    /// <param name="DueDate">Due date for completion.</param>
    /// <returns>Assignment Entry No.</returns>
    procedure AssignLearningPathToEmployee(EmployeeNo: Code[20]; PathUID: Code[100]; DueDate: Date): Integer
    var
        Assignment: Record "SEW Empl. Learning Assign.";
        LearningContent: Record "SEW Learn Cont";
    begin
        // Validate path exists
        LearningContent.SetRange(UID, PathUID);
        LearningContent.SetRange("Content Type", LearningContent."Content Type"::"Learning Path");
        if not LearningContent.FindFirst() then
            Error(PathNotFoundErr, PathUID);

        // Check for duplicate assignment
        Assignment.SetRange("Employee No.", EmployeeNo);
        Assignment.SetRange("Assignment Type", Assignment."Assignment Type"::"Learning Path");
        Assignment.SetRange("Learn Cont UID", PathUID);
        if not Assignment.IsEmpty() then
            Error(DuplicateAssignmentErr, LearningContent.Title, EmployeeNo);

        // Create assignment
        Assignment.Init();
        Assignment."Assignment Type" := Assignment."Assignment Type"::"Learning Path";
        Assignment."Employee No." := EmployeeNo;
        Assignment."Learn Cont UID" := PathUID;
        Assignment."Due Date" := DueDate;
        Assignment.Insert(true);

        // Create progress records for all modules in path
        CreatePathProgressRecords(Assignment."Entry No.", PathUID);

        // Create User Task if enabled
        CreateUserTaskIfEnabled(Assignment."Entry No.");

        OnAfterAssignmentCreated(Assignment);

        exit(Assignment."Entry No.");
    end;

    /// <summary>
    /// Creates a user task for an assignment.
    /// </summary>
    /// <param name="AssignmentEntryNo">Assignment Entry No.</param>
    /// <returns>User Task ID.</returns>
    procedure CreateUserTask(AssignmentEntryNo: Integer): Integer
    var
        Assignment: Record "SEW Empl. Learning Assign.";
        Employee: Record Employee;
        UserTask: Record "User Task";
        LearningContent: Record "SEW Learn Cont";
        Title: Text[250];
    begin
        if not Assignment.Get(AssignmentEntryNo) then
            exit(0);

        if not Employee.Get(Assignment."Employee No.") then
            exit(0);

        // Get title
        case Assignment."Assignment Type" of
            Assignment."Assignment Type"::Module:
                begin
                    LearningContent.SetRange(UID, Assignment."Learn Cont UID");
                    LearningContent.SetRange("Content Type", LearningContent."Content Type"::Module);
                    if LearningContent.FindFirst() then
                        Title := CopyStr(StrSubstNo(TaskTitleModuleTxt, LearningContent.Title), 1, MaxStrLen(UserTask.Title));
                end;
            Assignment."Assignment Type"::"Learning Path":
                begin
                    LearningContent.SetRange(UID, Assignment."Learn Cont UID");
                    LearningContent.SetRange("Content Type", LearningContent."Content Type"::"Learning Path");
                    if LearningContent.FindFirst() then
                        Title := CopyStr(StrSubstNo(TaskTitlePathTxt, LearningContent.Title), 1, MaxStrLen(UserTask.Title));
                end;
        end;

        // Create user task
        UserTask.Init();
        UserTask.Title := Title;
        UserTask."Assigned To" := UserSecurityId();
        UserTask."Created By" := UserId;
        UserTask."Due DateTime" := CreateDateTime(Assignment."Due Date", 120000T);
        UserTask."Percent Complete" := 0;
        UserTask.Insert(true);

        // Update assignment
        Assignment."User Task No." := UserTask.ID;
        Assignment.Modify(true);

        exit(UserTask.ID);
    end;

    /// <summary>
    /// Marks a module assignment as started.
    /// </summary>
    /// <param name="AssignmentEntryNo">Assignment Entry No.</param>
    procedure MarkModuleStarted(AssignmentEntryNo: Integer)
    var
        Assignment: Record "SEW Empl. Learning Assign.";
    begin
        if Assignment.Get(AssignmentEntryNo) then
            Assignment.MarkStarted();
    end;

    /// <summary>
    /// Marks a module assignment as completed.
    /// </summary>
    /// <param name="AssignmentEntryNo">Assignment Entry No.</param>
    /// <param name="CompletionNotes">Completion notes.</param>
    procedure MarkModuleCompleted(AssignmentEntryNo: Integer; CompletionNotes: Text[250])
    var
        Assignment: Record "SEW Empl. Learning Assign.";
        SkillMatrixMgr: Codeunit "SEW Skill Matrix Manager";
    begin
        if not Assignment.Get(AssignmentEntryNo) then
            exit;

        Assignment.MarkCompleted(CompletionNotes);

        // Update skills
        SkillMatrixMgr.ProcessCompletedAssignment(AssignmentEntryNo);

        OnAfterModuleCompleted(Assignment);
    end;

    /// <summary>
    /// Marks a module within a learning path as completed.
    /// </summary>
    /// <param name="AssignmentEntryNo">Assignment Entry No.</param>
    /// <param name="ModuleUID">Module UID.</param>
    procedure MarkPathModuleCompleted(AssignmentEntryNo: Integer; ModuleUID: Code[100])
    var
        Assignment: Record "SEW Empl. Learning Assign.";
        ModuleProgress: Record "SEW Assignment Module Progress";
    begin
        if not Assignment.Get(AssignmentEntryNo) then
            exit;

        if ModuleProgress.Get(AssignmentEntryNo, ModuleUID) then begin
            ModuleProgress.MarkCompleted();

            // Check if all modules completed
            if CheckPathCompletion(AssignmentEntryNo) then begin
                Assignment.Get(AssignmentEntryNo);
                MarkModuleCompleted(AssignmentEntryNo, '');
                OnAfterPathCompleted(Assignment);
            end;
        end;
    end;

    /// <summary>
    /// Checks if all modules in a learning path are completed.
    /// </summary>
    /// <param name="AssignmentEntryNo">Assignment Entry No.</param>
    /// <returns>True if path is complete.</returns>
    procedure CheckPathCompletion(AssignmentEntryNo: Integer): Boolean
    var
        ModuleProgress: Record "SEW Assignment Module Progress";
    begin
        ModuleProgress.SetRange("Assignment Entry No.", AssignmentEntryNo);
        ModuleProgress.SetFilter(Status, '<>%1', ModuleProgress.Status::Completed);
        exit(ModuleProgress.IsEmpty());
    end;

    /// <summary>
    /// Gets the completion progress percentage for an assignment.
    /// </summary>
    /// <param name="AssignmentEntryNo">Assignment Entry No.</param>
    /// <returns>Progress percentage (0-100).</returns>
    procedure GetAssignmentProgress(AssignmentEntryNo: Integer): Decimal
    var
        Assignment: Record "SEW Empl. Learning Assign.";
    begin
        if Assignment.Get(AssignmentEntryNo) then
            exit(Assignment."Progress Percentage");
        exit(0);
    end;

    /// <summary>
    /// Notifies employee when content is updated.
    /// </summary>
    /// <param name="AssignmentEntryNo">Assignment Entry No.</param>
    procedure NotifyContentUpdate(AssignmentEntryNo: Integer)
    var
        Assignment: Record "SEW Empl. Learning Assign.";
        Employee: Record Employee;
        UserTask: Record "User Task";
        Title: Text[250];
    begin
        if not Assignment.Get(AssignmentEntryNo) then
            exit;

        if not Employee.Get(Assignment."Employee No.") then
            exit;

        Title := CopyStr(StrSubstNo(ContentUpdatedTxt, Assignment.GetContentUID()), 1, MaxStrLen(UserTask.Title));

        UserTask.Init();
        UserTask.Title := Title;
        UserTask."Assigned To" := UserSecurityId();
        UserTask."Created By" := UserId;
        UserTask."Due DateTime" := CreateDateTime(Today, 120000T);
        UserTask.Insert(true);
    end;

    local procedure CreateUserTaskIfEnabled(AssignmentEntryNo: Integer)
    var
        Setup: Record "SEW Learning Mgmt Setup";
    begin
        if Setup.Get() then
            if Setup."Auto Create User Tasks" then
                CreateUserTask(AssignmentEntryNo);
    end;

    local procedure CreatePathProgressRecords(AssignmentEntryNo: Integer; PathUID: Code[100])
    var
        PathModule: Record "SEW Learn Cont Path Mod";
        ModuleProgress: Record "SEW Assignment Module Progress";
    begin
        PathModule.SetRange("Learning Path UID", PathUID);
        PathModule.SetCurrentKey("Learning Path UID", Sequence);
        if PathModule.FindSet() then
            repeat
                ModuleProgress.Init();
                ModuleProgress."Assignment Entry No." := AssignmentEntryNo;
                ModuleProgress."Module UID" := PathModule."Module UID";
                ModuleProgress.Status := ModuleProgress.Status::"Not Started";
                ModuleProgress.Insert(true);
            until PathModule.Next() = 0;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAssignmentCreated(AssignmentRec: Record "SEW Empl. Learning Assign.")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterModuleCompleted(AssignmentRec: Record "SEW Empl. Learning Assign.")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPathCompleted(AssignmentRec: Record "SEW Empl. Learning Assign.")
    begin
    end;

    var
        ModuleNotFoundErr: Label 'Module %1 not found in catalog.';
        PathNotFoundErr: Label 'Learning Path %1 not found in catalog.';
        DuplicateAssignmentErr: Label 'Employee %2 already has an assignment for %1.';
        TaskTitleModuleTxt: Label 'Complete Learning Module: %1';
        TaskTitlePathTxt: Label 'Complete Learning Path: %1';
        ContentUpdatedTxt: Label 'Learning Content Updated: %1';
}
