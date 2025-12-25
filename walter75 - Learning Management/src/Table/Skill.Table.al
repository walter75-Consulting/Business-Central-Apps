/// <summary>
/// Table SEW Skill (ID 91840).
/// Defines skills that can be acquired through training.
/// </summary>
table 91840 "SEW Skill"
{
    Caption = 'Skill';
    DataClassification = CustomerContent;
    LookupPageId = "SEW Skill List";
    DrillDownPageId = "SEW Skill List";
    Extensible = true;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            ToolTip = 'Specifies the skill code.';
            NotBlank = true;
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the skill description.';
        }
        field(20; "Skill Category"; Enum "SEW Skill Category")
        {
            Caption = 'Skill Category';
            ToolTip = 'Specifies the skill category.';
        }
        field(30; "Required for Roles"; Text[250])
        {
            Caption = 'Required for Roles';
            ToolTip = 'Specifies comma-separated role codes that require this skill.';
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}
