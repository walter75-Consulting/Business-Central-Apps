/// <summary>
/// Table SEW Role Skill Requirement (ID 91843).
/// Defines required skills for each role with minimum proficiency levels.
/// </summary>
table 91843 "SEW Role Skill Requirement"
{
    Caption = 'Role Skill Requirement';
    DataClassification = CustomerContent;
    Extensible = true;

    fields
    {
        field(1; "Role Code"; Code[20])
        {
            Caption = 'Role Code';
            ToolTip = 'Specifies the role code.';
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
        field(20; "Minimum Proficiency"; Enum "SEW Proficiency Level")
        {
            Caption = 'Minimum Proficiency';
            ToolTip = 'Specifies the minimum required proficiency level.';
        }
        field(30; Mandatory; Boolean)
        {
            Caption = 'Mandatory';
            ToolTip = 'Specifies whether this skill is mandatory for the role.';
        }
    }

    keys
    {
        key(PK; "Role Code", "Skill Code")
        {
            Clustered = true;
        }
    }
}
