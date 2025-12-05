tableextension 80000 "SEW AC Contact" extends Contact
{
    fields
    {
        field(80050; "SEW Contact Title"; Code[20])
        {
            Caption = 'Title';
            ToolTip = 'Specifies the value of the Title field.';
            TableRelation = "SEW Contact Title";
        }
        field(80001; "SEW Customer No."; Code[20])
        {
            FieldClass = FlowField;
            Caption = 'Customer No.';
            ToolTip = 'Specifies the customer number linked to the contact.';
            CalcFormula = lookup("Contact Business Relation"."No." where("Contact No." = field("Company No."),
            "Link to Table" = const(Customer)));
            Editable = false;
            TableRelation = Customer;
        }
        field(80002; "SEW Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            ToolTip = 'Specifies the vendor number linked to the contact.';
            FieldClass = FlowField;
            CalcFormula = lookup("Contact Business Relation"."No." where("Contact No." = field("Company No."),
            "Link to Table" = const(Vendor)));
            Editable = false;
        }
        field(80200; "SEW Service Zone Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Service Zone';
            ToolTip = 'Specifies the Service Zone.';
            TableRelation = "Service Zone";

            trigger OnValidate()
            var
                SEWACEventSubs: Codeunit "SEW AC Event Subs";
            begin
                SEWACEventSubs.SEWUpdateContact(Rec);
            end;
        }
        field(80201; "SEW Salesperson manually"; Boolean)
        {
            Caption = 'Salesperson manually';
            ToolTip = 'Specifies whether the Salesperson Code is set manually.';
            DataClassification = CustomerContent;
        }
        field(80202; "SEW Territory manually"; Boolean)
        {
            Caption = 'Territory manually';
            ToolTip = 'Specifies whether the Territory Code is set manually.';
            DataClassification = CustomerContent;
        }
        field(80203; "SEW Service Zone manually"; Boolean)
        {
            Caption = 'Service Zone manually';
            ToolTip = 'Specifies whether the Service Zone is set manually.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(SEWKey01; "Surname")
        {
        }
    }
}
