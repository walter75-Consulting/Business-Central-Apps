/// <summary>
/// Table SEW Assignment Module Progress (ID 91831).
/// Tracks completion of individual modules within assigned learning paths.
/// </summary>
table 91831 "SEW Assignment Module Progress"
{
    Caption = 'Assignment Module Progress';
    DataClassification = CustomerContent;
    Extensible = true;

    fields
    {
        field(1; "Assignment Entry No."; Integer)
        {
            Caption = 'Assignment Entry No.';
            ToolTip = 'Specifies the assignment entry number.';
            TableRelation = "SEW Empl. Learning Assign."."Entry No.";
            NotBlank = true;
        }
        field(2; "Module UID"; Code[100])
        {
            Caption = 'Module UID';
            ToolTip = 'Specifies the module unique identifier.';
            TableRelation = "SEW Learn Cont".UID where("Content Type" = const(Module));
            NotBlank = true;
        }
        field(10; "Module Title"; Text[250])
        {
            Caption = 'Module Title';
            ToolTip = 'Specifies the module title.';
            FieldClass = FlowField;
            CalcFormula = lookup("SEW Learn Cont".Title where(UID = field("Module UID"), "Content Type" = const(Module)));
            Editable = false;
        }
        field(20; Status; Enum "SEW Assignment Status")
        {
            Caption = 'Status';
            ToolTip = 'Specifies the current status of this module.';
        }
        field(21; "Started Date"; Date)
        {
            Caption = 'Started Date';
            ToolTip = 'Specifies when work started on this module.';
        }
        field(22; "Completed Date"; Date)
        {
            Caption = 'Completed Date';
            ToolTip = 'Specifies when this module was completed.';
        }
    }

    keys
    {
        key(PK; "Assignment Entry No.", "Module UID")
        {
            Clustered = true;
        }
    }

    /// <summary>
    /// Marks this module as completed.
    /// </summary>
    procedure MarkCompleted()
    begin
        Rec.Status := Rec.Status::Completed;
        Rec."Completed Date" := Today;
        if Rec."Started Date" = 0D then
            Rec."Started Date" := Today;
        Rec.Modify(true);

        // Update parent assignment progress
        UpdateParentProgress();
    end;

    local procedure UpdateParentProgress()
    var
        Assignment: Record "SEW Empl. Learning Assign.";
        ModuleProgress: Record "SEW Assignment Module Progress";
        TotalModules: Integer;
        CompletedModules: Integer;
    begin
        if not Assignment.Get(Rec."Assignment Entry No.") then
            exit;

        ModuleProgress.SetRange("Assignment Entry No.", Rec."Assignment Entry No.");
        TotalModules := ModuleProgress.Count;
        if TotalModules = 0 then
            exit;

        ModuleProgress.SetRange(Status, ModuleProgress.Status::Completed);
        CompletedModules := ModuleProgress.Count;

        Assignment."Progress Percentage" := Round(CompletedModules / TotalModules * 100, 1);

        // Auto-complete assignment if all modules done
        if CompletedModules = TotalModules then
            Assignment.Status := Assignment.Status::Completed;

        Assignment.Modify(true);
    end;
}
