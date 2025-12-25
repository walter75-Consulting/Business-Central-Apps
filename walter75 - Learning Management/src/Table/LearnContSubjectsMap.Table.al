/// <summary>
/// Table SEW Content Subject Mapping (ID 91818).
/// Junction table linking learning content to subject areas.
/// </summary>
table 91818 "SEW Learn Cont Subjects Map"
{
    Caption = 'Content Subject Mapping';
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
        field(2; "Subject Code"; Code[50])
        {
            Caption = 'Subject Code';
            ToolTip = 'Specifies the subject code.';
            TableRelation = "SEW Learn Cont Subjects".Code;
            NotBlank = true;
        }
    }

    keys
    {
        key(PK; "Content UID", "Subject Code")
        {
            Clustered = true;
        }
        key(Subject; "Subject Code")
        {
        }
    }
}
