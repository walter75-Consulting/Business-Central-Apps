/// <summary>
/// Table SEW Employee Skill (ID 91842).
/// Employee skill matrix showing proficiency levels for each skill.
/// </summary>
table 91842 "SEW Employee Skill"
{
    Caption = 'Employee Skill';
    DataClassification = CustomerContent;
    LookupPageId = "SEW Employee Skill Matrix";
    DrillDownPageId = "SEW Employee Skill Matrix";
    Extensible = true;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            ToolTip = 'Specifies the employee number.';
            TableRelation = Employee."No.";
            NotBlank = true;
        }
        field(2; "Skill Code"; Code[20])
        {
            Caption = 'Skill Code';
            ToolTip = 'Specifies the skill code.';
            TableRelation = "SEW Skill".Code;
            NotBlank = true;
        }
        field(10; "Skill Description"; Text[100])
        {
            Caption = 'Skill Description';
            ToolTip = 'Specifies the skill description.';
            FieldClass = FlowField;
            CalcFormula = lookup("SEW Skill".Description where(Code = field("Skill Code")));
            Editable = false;
        }
        field(20; "Proficiency Level"; Enum "SEW Proficiency Level")
        {
            Caption = 'Proficiency Level';
            ToolTip = 'Specifies the employee proficiency level for this skill.';
        }
        field(30; Source; Enum "SEW Skill Source")
        {
            Caption = 'Source';
            ToolTip = 'Specifies how this proficiency was determined.';
        }
        field(40; "Acquired Date"; Date)
        {
            Caption = 'Acquired Date';
            ToolTip = 'Specifies when the skill was first acquired.';
        }
        field(41; "Last Assessed Date"; Date)
        {
            Caption = 'Last Assessed Date';
            ToolTip = 'Specifies when the proficiency was last assessed.';
        }
        field(50; Notes; Text[250])
        {
            Caption = 'Notes';
            ToolTip = 'Specifies additional notes about this skill.';
        }
    }

    keys
    {
        key(PK; "Employee No.", "Skill Code")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if Rec."Acquired Date" = 0D then
            Rec."Acquired Date" := Today;

        if Rec."Last Assessed Date" = 0D then
            Rec."Last Assessed Date" := Today;
    end;
}
