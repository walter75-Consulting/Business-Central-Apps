table 95701 "SEW Carrier"
{
    Caption = 'SendCloud Carrier';
    DataClassification = CustomerContent;
    DrillDownPageId = "SEW Carrier";
    LookupPageId = "SEW Carrier";
    Extensible = false;

    fields
    {
        field(1; "Code"; Code[50])
        {
            Caption = 'Code';
            ToolTip = 'Specifies the carrier code as defined in Sendcloud.';
            NotBlank = true;
        }
        field(2; "Carrier Name"; Text[255])
        {
            Caption = 'Carrier Name';
            ToolTip = 'Specifies the name of the carrier as defined in Sendcloud.';
        }
        field(8; "Nbr of Methods"; Integer)
        {
            Caption = 'Nbr of Methods';
            ToolTip = 'Specifies the number of Methods for the Carrier.';
            FieldClass = FlowField;
            CalcFormula = count("SEW Carrier Ship Met" where("Carrier Code" = field(Code)));
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Code", "Carrier Name")
        {
        }
        fieldgroup(Brick; "Code", "Carrier Name")
        {
        }
    }
}
