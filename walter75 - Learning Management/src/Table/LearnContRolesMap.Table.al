/// <summary>
/// Table SEW Content Role Mapping (ID 91816).
/// Junction table linking learning content to target roles.
/// </summary>
table 91816 "SEW Learn Cont Roles Map"
{
    Caption = 'Content Role Mapping';
    DataClassification = CustomerContent;
    Extensible = true;

    fields
    {
        field(1; "Content UID"; Code[100])
        {
            Caption = 'Content UID';
            ToolTip = 'Specifies the unique identifier of the learning content.';
            TableRelation = "SEW Learn Cont".UID;
            NotBlank = true;
        }
        field(2; "Role Code"; Code[50])
        {
            Caption = 'Role Code';
            ToolTip = 'Specifies the role code.';
            TableRelation = "SEW Learn Cont Roles".Code;
            NotBlank = true;
        }
    }

    keys
    {
        key(PK; "Content UID", "Role Code")
        {
            Clustered = true;
        }
        key(Role; "Role Code")
        {
        }
    }
}
