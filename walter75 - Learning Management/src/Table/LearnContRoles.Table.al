/// <summary>
/// Table SEW Role (ID 91813).
/// Master table for target roles from Microsoft Learn API.
/// </summary>
table 91813 "SEW Learn Cont Roles"
{
    Caption = 'Role';
    DataClassification = CustomerContent;
    Extensible = true;
    LookupPageId = "SEW Learn Cont Roles";
    DrillDownPageId = "SEW Learn Cont Roles";

    fields
    {
        field(1; "Code"; Code[50])
        {
            Caption = 'Code';
            ToolTip = 'Specifies the role code (e.g., developer, administrator, functional-consultant).';
            NotBlank = true;
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
            ToolTip = 'Specifies the display name of the role.';
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
