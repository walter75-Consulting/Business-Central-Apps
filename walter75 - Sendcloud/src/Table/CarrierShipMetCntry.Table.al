table 95702 "SEW Carrier Ship Met Cntry"
{
    Caption = 'SEW Shipping Method Country';
    DataClassification = CustomerContent;
    DrillDownPageId = "SEW Carrier Ship Met Cntry";
    LookupPageId = "SEW Carrier Ship Met Cntry";
    Extensible = false;

    fields
    {
        field(1; ID; Integer)
        {
            Caption = 'ID';
            ToolTip = 'Specifies the unique identifier for the shipping method country as defined in Sendcloud.';
            Description = 'Unique identifier for the shipping method country as defined in Sendcloud.';
        }
        field(2; "Shipping Method ID"; Integer)
        {
            Caption = 'Shipping Mehthod ID';
            ToolTip = 'Specifies the unique identifier for the shipping method as defined in Sendcloud.';
        }
        field(3; Name; Text[255])
        {
            Caption = 'Name';
            ToolTip = 'Specifies the name of the country as defined in Sendcloud.';
            Description = 'Name of the country.';
        }
        field(4; Price; Decimal)
        {
            Caption = 'Price';
            ToolTip = 'Specifies the price for the shipping method in the country as defined in Sendcloud.';
            Description = 'Indicates what it will cost to use the shipping method. Will be 0 if the user has enabled a direct contract for corresponding the carrier.';
        }
        field(5; "ISO 2"; Code[2])
        {
            Caption = 'ISO 2';
            ToolTip = 'Specifies the ISO 2 code of the country as defined in Sendcloud.';
            Description = 'ISO 3166-1 alpha-2 code of the country.';
        }
        field(6; "ISO 3"; Code[3])
        {
            Caption = 'ISO 3';
            ToolTip = 'Specifies the ISO 3 code of the country as defined in Sendcloud.';
            Description = 'ISO 3166-1 alpha-3 code of the country.';
        }
        field(7; "Lead Time_Hours"; Integer)
        {
            Caption = 'Lead Time_Hours';
            ToolTip = 'Specifies the lead time in hours for the shipping method in the country as defined in Sendcloud.';
            Description = 'Lead time of the shipping method in hours';
        }
        field(8; "Nbr of Prices"; Integer)
        {
            Caption = 'Nbr of Prices';
            ToolTip = 'Specifies the number of prices for this country.';
            FieldClass = FlowField;
            CalcFormula = count("SEW Carrier Ship Met Cntry Pri" where("Shipping Met Cntry ID" = field(ID), "Shipping Method ID" = field("Shipping Method ID")));
            Editable = false;
        }
    }
    keys
    {
        key(PK; ID, "Shipping Method ID")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; ID, Name) { }
        fieldgroup(Brick; ID, Name) { }
    }
}
