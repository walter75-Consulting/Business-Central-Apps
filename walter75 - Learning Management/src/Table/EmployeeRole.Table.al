/// <summary>
/// Table SEW Employee Role (ID 91844).
/// Assigns employees to roles (many-to-many relationship).
/// </summary>
table 91844 "SEW Employee Role"
{
    Caption = 'Employee Role';
    DataClassification = CustomerContent;
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
        field(2; "Role Code"; Code[20])
        {
            Caption = 'Role Code';
            ToolTip = 'Specifies the role code.';
            NotBlank = true;
        }
        field(10; "Primary Role"; Boolean)
        {
            Caption = 'Primary Role';
            ToolTip = 'Specifies whether this is the employee primary role.';
        }
        field(20; "Effective Date"; Date)
        {
            Caption = 'Effective Date';
            ToolTip = 'Specifies when this role assignment became effective.';
        }
    }

    keys
    {
        key(PK; "Employee No.", "Role Code")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if Rec."Effective Date" = 0D then
            Rec."Effective Date" := Today;
    end;
}
