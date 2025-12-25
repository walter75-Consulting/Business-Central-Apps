/// <summary>
/// Table SEW Content Level Mapping (ID 91817).
/// Junction table linking learning content to difficulty levels.
/// </summary>
table 91817 "SEW Learn Cont Levels Map"
{
    Caption = 'Content Level Mapping';
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
        field(2; "Level Code"; Code[20])
        {
            Caption = 'Level Code';
            ToolTip = 'Specifies the level code.';
            TableRelation = "SEW Learn Cont Levels".Code;
            NotBlank = true;
        }
    }

    keys
    {
        key(PK; "Content UID", "Level Code")
        {
            Clustered = true;
        }
        key(Level; "Level Code")
        {
        }
    }
}
