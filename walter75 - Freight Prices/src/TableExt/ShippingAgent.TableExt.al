tableextension 91400 "SEW Shipping Agent" extends "Shipping Agent"
{
    fields
    {
        field(91400; "SEW Freight Billing Type"; Enum "Sales Line Type")
        {
            Caption = 'Freight Billing Type';
            ToolTip = 'Specifies the type of billing for freight charges (G/L Account, Resource, Charge (Item), or Item).';
            DataClassification = CustomerContent;
        }
        field(91401; "SEW Freight Billing No."; Code[20])
        {
            Caption = 'Freight Billing No.';
            ToolTip = 'Specifies the number of the billing account, resource, item charge, or item for freight charges.';
            DataClassification = CustomerContent;

            TableRelation = if ("SEW Freight Billing Type" = const("G/L Account")) "G/L Account" where("Direct Posting" = const(true), "Account Type" = const(Posting), Blocked = const(false))
            else
            if ("SEW Freight Billing Type" = const(Resource)) Resource
            else
            if ("SEW Freight Billing Type" = const("Charge (Item)")) "Item Charge"
            else
            if ("SEW Freight Billing Type" = const(Item)) Item where(Blocked = const(false), "Sales Blocked" = const(false));
            ValidateTableRelation = false;
        }
    }
}
