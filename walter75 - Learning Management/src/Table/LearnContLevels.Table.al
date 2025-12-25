/// <summary>
/// Table SEW Level (ID 91814).
/// Master table for learning difficulty levels from Microsoft Learn API.
/// </summary>
table 91814 "SEW Learn Cont Levels"
{
    Caption = 'Learning Level';
    DataClassification = CustomerContent;
    Extensible = true;
    LookupPageId = "SEW Learn Cont Levels";
    DrillDownPageId = "SEW Learn Cont Levels";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            ToolTip = 'Specifies the level code (e.g., beginner, intermediate, advanced).';
            NotBlank = true;
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
            ToolTip = 'Specifies the display name of the level.';
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
