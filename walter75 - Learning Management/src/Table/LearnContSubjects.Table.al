/// <summary>
/// Table SEW Subject (ID 91815).
/// Master table for subject areas from Microsoft Learn API.
/// </summary>
table 91815 "SEW Learn Cont Subjects"
{
    Caption = 'Subject';
    DataClassification = CustomerContent;
    Extensible = true;
    LookupPageId = "SEW Learn Cont Subjects";
    DrillDownPageId = "SEW Learn Cont Subjects";

    fields
    {
        field(1; "Code"; Code[50])
        {
            Caption = 'Code';
            ToolTip = 'Specifies the subject code (e.g., finance-accounting, supply-chain, development).';
            NotBlank = true;
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
            ToolTip = 'Specifies the display name of the subject.';
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
