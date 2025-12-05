table 95700 "SEW Carrier Ship Met"
{
    Caption = 'Carrier Shipping Methods';
    DataClassification = CustomerContent;
    DrillDownPageId = "SEW Carrier Ship Met";
    LookupPageId = "SEW Carrier Ship Met";
    Extensible = false;

    fields
    {
        field(1; ID; Integer)
        {
            Caption = 'ID';
            ToolTip = 'Specifies the unique identifier for the shipping method as defined in Sendcloud.';
        }
        field(2; "Shipment Method Name"; Text[255])
        {
            Caption = 'Shipment Method Name';
            ToolTip = 'Specifies the name of the shipping method as defined in Sendcloud.';
            Description = 'Name of the shipping method, it should give an idea what the shipping method can be used for.';
        }
        field(3; "Carrier Code"; Code[50])
        {
            Caption = 'Carrier Code';
            ToolTip = 'Specifies the carrier code of the shipping method as defined in Sendcloud.';
            Description = 'A carrier_code which will indicate which carrier provides the shipping method.';
            TableRelation = "SEW Carrier".Code;
        }
        field(4; "Weight min"; Decimal)
        {
            Caption = 'Weight min';
            ToolTip = 'Specifies the minimum weight for the shipping method as defined in Sendcloud.';
            Description = 'Minimum allowed weight of the parcel for this shipping method.';
        }
        field(5; "Weight max"; Decimal)
        {
            Caption = 'Weight max';
            ToolTip = 'Specifies the maximum weight for the shipping method as defined in Sendcloud.';
            Description = 'Maximum allowed weight of the parcel for this shipping method.';
        }
        field(6; "Service Point Input"; Text[255])
        {
            Caption = 'Service Point Input';
            ToolTip = 'Specifies whether the shipping method requires service point input as defined in Sendcloud.';
            Description = 'Will be either required when the shipping method is meant to ship a parcel to a service point, or none when this is not the case.';
        }
        field(7; "Nbr of Countries"; Integer)
        {
            Caption = 'Nbr of Countries';
            ToolTip = 'Specifies the number of countries this shipping method is available for.';
            FieldClass = FlowField;
            CalcFormula = count("SEW Carrier Ship Met Cntry" where("Shipping Method ID" = field(ID)));
            Editable = false;
        }

    }
    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; ID, "Shipment Method Name", "Carrier Code")
        {
        }
        fieldgroup(Brick; ID, "Shipment Method Name", "Carrier Code")
        {
        }
    }
}
