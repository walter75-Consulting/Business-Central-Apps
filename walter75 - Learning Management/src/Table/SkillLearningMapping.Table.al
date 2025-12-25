/// <summary>
/// Table SEW Skill Learning Mapping (ID 91841).
/// Maps modules/paths to skills they teach and proficiency level gained.
/// </summary>
table 91841 "SEW Skill Learning Mapping"
{
    Caption = 'Skill Learning Mapping';
    DataClassification = CustomerContent;
    Extensible = true;

    fields
    {
        field(1; "Skill Code"; Code[20])
        {
            Caption = 'Skill Code';
            ToolTip = 'Specifies the skill code.';
            TableRelation = "SEW Skill".Code;
            NotBlank = true;
        }
        field(2; "Content Type"; Enum "SEW Assignment Type")
        {
            Caption = 'Content Type';
            ToolTip = 'Specifies whether this is a module or learning path.';
        }
        field(3; "Content UID"; Code[100])
        {
            Caption = 'Content UID';
            ToolTip = 'Specifies the module or learning path UID.';
            NotBlank = true;
        }
        field(10; "Proficiency Level Gained"; Enum "SEW Proficiency Level")
        {
            Caption = 'Proficiency Level Gained';
            ToolTip = 'Specifies what proficiency level completing this content grants.';
        }
    }

    keys
    {
        key(PK; "Skill Code", "Content Type", "Content UID")
        {
            Clustered = true;
        }
    }
}
