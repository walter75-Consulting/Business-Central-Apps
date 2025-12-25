/// <summary>
/// Table SEW Empl. Learning Assignment (ID 91830).
/// Assigns learning paths/modules to employees and tracks completion status.
/// </summary>
table 91830 "SEW Empl. Learning Assign."
{
    Caption = 'Employee Learning Assignment';
    DataClassification = CustomerContent;
    LookupPageId = "SEW Empl. Learning Assigns.";
    DrillDownPageId = "SEW Empl. Learning Assigns.";
    Extensible = true;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            ToolTip = 'Specifies the entry number.';
            AutoIncrement = true;
        }
        field(10; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            ToolTip = 'Specifies the employee number.';
            TableRelation = Employee."No.";
            NotBlank = true;
        }
        field(11; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            ToolTip = 'Specifies the employee name.';
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."First Name" where("No." = field("Employee No.")));
            Editable = false;
        }
        field(20; "Assignment Type"; Enum "SEW Assignment Type")
        {
            Caption = 'Assignment Type';
            ToolTip = 'Specifies whether this is a module or learning path assignment.';
        }
        field(21; "Learn Cont UID"; Code[100])
        {
            Caption = 'Learn Cont UID';
            ToolTip = 'Specifies the learning content unique identifier (module or learning path).';
            TableRelation = if ("Assignment Type" = const(Module)) "SEW Learn Cont".UID where("Content Type" = const(Module)) else
            if ("Assignment Type" = const("Learning Path")) "SEW Learn Cont".UID where("Content Type" = const("Learning Path"));
        }
        field(23; "Content Title"; Text[250])
        {
            Caption = 'Content Title';
            ToolTip = 'Specifies the title of the assigned content.';
            FieldClass = FlowField;
            CalcFormula = lookup("SEW Learn Cont".Title where(UID = field("Learn Cont UID")));
            Editable = false;
        }
        field(30; "Assigned By User ID"; Code[50])
        {
            Caption = 'Assigned By';
            ToolTip = 'Specifies who assigned this training.';
            TableRelation = User."User Name";
        }
        field(31; "Assigned Date"; Date)
        {
            Caption = 'Assigned Date';
            ToolTip = 'Specifies when the assignment was created.';
        }
        field(32; "Due Date"; Date)
        {
            Caption = 'Due Date';
            ToolTip = 'Specifies when the assignment should be completed.';
        }
        field(40; Status; Enum "SEW Assignment Status")
        {
            Caption = 'Status';
            ToolTip = 'Specifies the current status of the assignment.';
        }
        field(41; "Started Date"; Date)
        {
            Caption = 'Started Date';
            ToolTip = 'Specifies when the employee started working on this assignment.';
        }
        field(42; "Completed Date"; Date)
        {
            Caption = 'Completed Date';
            ToolTip = 'Specifies when the employee completed this assignment.';
        }
        field(43; "Completion Notes"; Text[250])
        {
            Caption = 'Completion Notes';
            ToolTip = 'Specifies optional notes from the employee about the completion.';
        }
        field(50; "User Task No."; Integer)
        {
            Caption = 'User Task No.';
            ToolTip = 'Specifies the related user task number.';
            TableRelation = "User Task".ID;
        }
        field(60; "Content Version"; Code[50])
        {
            Caption = 'Content Version';
            ToolTip = 'Specifies the content hash at assignment time.';
        }
        field(61; "Current Content Version"; Code[50])
        {
            Caption = 'Current Content Version';
            ToolTip = 'Specifies the current content hash from catalog.';
            FieldClass = FlowField;
            CalcFormula =
        lookup("SEW Learn Cont"."Catalog Hash" where(UID = field("Learn Cont UID")));
            Editable = false;
        }
        field(62; "Version Outdated"; Boolean)
        {
            Caption = 'Version Outdated';
            ToolTip = 'Specifies whether the content has been updated since assignment.';
        }
        field(70; "Progress Percentage"; Decimal)
        {
            Caption = 'Progress %';
            ToolTip = 'Specifies the completion progress for learning paths.';
            DecimalPlaces = 0 : 0;
            MinValue = 0;
            MaxValue = 100;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(EmployeeStatus; "Employee No.", Status)
        {
        }
        key(DueDate; "Due Date")
        {
        }
        key(LearnContEmployee; "Learn Cont UID", "Employee No.")
        {
        }

    }

    trigger OnInsert()
    begin
        if Rec."Assigned Date" = 0D then
            Rec."Assigned Date" := Today;

        if Rec."Assigned By User ID" = '' then
            Rec."Assigned By User ID" := UserId;

        if Rec.Status = Rec.Status::" " then
            Rec.Status := Rec.Status::"Not Started";

        // Capture content version at assignment time
        CaptureContentVersion();
    end;

    /// <summary>
    /// Marks the assignment as started.
    /// </summary>
    procedure MarkStarted()
    begin
        if Rec.Status = Rec.Status::" " then begin
            Rec.Status := Rec.Status::"In Progress";
            Rec."Started Date" := Today;
            Rec.Modify(true);
        end;
    end;

    /// <summary>
    /// Marks the assignment as completed.
    /// </summary>
    /// <param name="CompletionNotes">Optional notes from employee.</param>
    procedure MarkCompleted(CompletionNotes: Text[250])
    begin
        Rec.Status := Rec.Status::Completed;
        Rec."Completed Date" := Today;
        Rec."Completion Notes" := CompletionNotes;
        Rec."Progress Percentage" := 100;
        Rec.Modify(true);

        // Close related User Task
        CloseUserTask();
    end;

    /// <summary>
    /// Gets the content UID based on assignment type.
    /// </summary>
    /// <returns>Module UID or Learning Path UID.</returns>
    procedure GetContentUID(): Code[100]
    begin
        case Rec."Assignment Type" of
            Rec."Assignment Type"::Module:
                exit(Rec."Learn Cont UID");
            Rec."Assignment Type"::"Learning Path":
                exit(Rec."Learn Cont UID");
        end;
    end;

    local procedure CaptureContentVersion()
    var
        LearningContent: Record "SEW Learn Cont";
    begin
        case Rec."Assignment Type" of
            Rec."Assignment Type"::Module:
                begin
                    LearningContent.SetRange(UID, Rec."Learn Cont UID");
                    LearningContent.SetRange("Content Type", LearningContent."Content Type"::Module);
                    if LearningContent.FindFirst() then
                        Rec."Content Version" := LearningContent."Catalog Hash";
                end;
            Rec."Assignment Type"::"Learning Path":
                begin
                    LearningContent.SetRange(UID, Rec."Learn Cont UID");
                    LearningContent.SetRange("Content Type", LearningContent."Content Type"::"Learning Path");
                    if LearningContent.FindFirst() then
                        Rec."Content Version" := LearningContent."Catalog Hash";
                end;
        end;
    end;

    local procedure CloseUserTask()
    var
        UserTask: Record "User Task";
    begin
        if Rec."User Task No." = 0 then
            exit;

        if UserTask.Get(Rec."User Task No.") then
            if UserTask."Percent Complete" < 100 then begin
                UserTask."Percent Complete" := 100;
                UserTask.Modify(true);
            end;
    end;
}
