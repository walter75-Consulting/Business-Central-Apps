table 95703 "SEW Carrier Ship Met Cntry Pri"
{
    Caption = 'SEW Shippping Met Cntry Price';
    DataClassification = CustomerContent;
    DrillDownPageId = "SEW Carrier Ship Met Ctry Pri";
    LookupPageId = "SEW Carrier Ship Met Ctry Pri";
    Extensible = false;

    fields
    {
        field(1; "Shipping Method ID"; Integer)
        {
            Caption = 'Shipping Method ID';
            ToolTip = 'Specifies the shipping method ID as defined in Sendcloud.';
        }
        field(2; "Shipping Met Cntry ID"; Integer)
        {
            Caption = 'Shipping Met Cntry ID';
            ToolTip = 'Specifies the shipping method country ID as defined in Sendcloud.';
        }
        field(3; Type; Text[255])
        {
            Caption = 'Type';
            ToolTip = 'Specifies the type of price, e.g. fixed or per weight unit.';
            Description = 'Type of the price. It is an identifier of category of the price.';
        }
        field(4; "Label"; Code[50])
        {
            Caption = 'Label';
            ToolTip = 'Specifies the label of the price, e.g. EUR.';
            Description = 'This label is a friendly name for type of the price type and can be used to represent it.';
        }
        field(5; Value; Decimal)
        {
            Caption = 'Value';
            ToolTip = 'Specifies the value of the price.';
            Description = 'TPrice amount of the breakdown item.';
        }
    }
    keys
    {
        key(PK; "Shipping Method ID", "Shipping Met Cntry ID", Type)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Shipping Method ID", "Shipping Met Cntry ID", Type, "Label", Value) { }
        fieldgroup(Brick; "Shipping Method ID", "Shipping Met Cntry ID", Type, "Label", Value) { }
    }
}
