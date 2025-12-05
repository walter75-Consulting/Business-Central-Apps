tableextension 80007 "SEW Toolbox Appl Area Setup" extends "Application Area Setup"
{
    fields
    {
        //crs-al disable

        // Spaces in field name are omitted in the ApplicationArea attribute
        // e.g. ApplicationArea = ExampleAppArea;

        field(80000; "SEWCRMFeatures"; Boolean)
        {
            Caption = 'Contact Features';
            ToolTip = 'Specifies whether contact features are enabled.';
            DataClassification = CustomerContent;
        }
        field(80001; "SEWFinanceFeatures"; Boolean)
        {
            Caption = 'Contact Title';
            ToolTip = 'Specifies whether Contact Titles are enabled.';
            DataClassification = CustomerContent;
        }
        field(80002; "SEWInventoryFeatures"; Boolean)
        {
            Caption = 'Customer Warntext';
            ToolTip = 'Specifies whether to show a warning text on Customers.';
            AllowInCustomizations = Never;
        }
        field(80003; "SEWManufacturingFeatures"; Boolean)
        {
            Caption = 'Vendor Warntext';
            ToolTip = 'Specifies whether to show a warning text on Vendors.';
            AllowInCustomizations = Never;
        }
        field(80004; "SEWPurchaseFeatures"; Boolean)
        {
            Caption = 'Customer Group';
            ToolTip = 'Specifies whether Customer Groups are enabled.';
            AllowInCustomizations = Never;
        }
        field(80005; "SEWSalesFeatures"; Boolean)
        {
            Caption = 'Production';
            ToolTip = 'Specifies whether Production is enabled.';
            AllowInCustomizations = Never;
        }

        //crs-al enable
    }
}