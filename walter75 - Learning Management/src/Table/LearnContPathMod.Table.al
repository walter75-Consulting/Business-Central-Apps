/// <summary>
/// Table SEW Learning Path Module (ID 91812).
/// Many-to-many relationship between learning paths and modules.
/// </summary>
table 91812 "SEW Learn Cont Path Mod"
{
    Caption = 'Learning Path Module';
    DataClassification = ToBeClassified;
    Extensible = true;

    fields
    {
        field(1; "Learning Path UID"; Code[100])
        {
            Caption = 'Learning Path UID';
            ToolTip = 'Specifies the learning path unique identifier.';
            TableRelation = "SEW Learn Cont".UID where("Content Type" = const("Learning Path"));
            NotBlank = true;
        }
        field(2; Sequence; Integer)
        {
            Caption = 'Sequence';
            ToolTip = 'Specifies the order of modules within the learning path.';
            MinValue = 1;
        }
        field(10; "Module UID"; Code[100])
        {
            Caption = 'Module UID';
            ToolTip = 'Specifies the module unique identifier.';
            TableRelation = "SEW Learn Cont".UID where("Content Type" = const(Module));
            NotBlank = true;
        }
        field(11; "Module Title"; Text[250])
        {
            Caption = 'Module Title';
            ToolTip = 'Specifies the module title.';
            FieldClass = FlowField;
            CalcFormula = lookup("SEW Learn Cont".Title where(UID = field("Module UID"), "Content Type" = const(Module)));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Learning Path UID", Sequence)
        {
            Clustered = true;
        }
        key(ModuleUID; "Module UID")
        {
        }
    }
}
