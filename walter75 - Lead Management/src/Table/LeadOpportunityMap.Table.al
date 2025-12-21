table 91720 "SEW Lead→Opportunity Map"
{
    Caption = 'Lead→Opportunity Map';
    DataClassification = CustomerContent;
    LookupPageId = "SEW Lead Conversion Log";
    DrillDownPageId = "SEW Lead Conversion Log";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            ToolTip = 'Specifies the unique entry number for this conversion record.';
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
        field(10; "Lead No."; Code[20])
        {
            Caption = 'Lead No.';
            ToolTip = 'Specifies the lead number that was converted.';
            DataClassification = CustomerContent;
            TableRelation = "SEW Lead"."No.";
        }
        field(11; "Lead Source Code"; Code[20])
        {
            Caption = 'Lead Source Code';
            ToolTip = 'Specifies the source code from the converted lead.';
            FieldClass = FlowField;
            CalcFormula = lookup("SEW Lead"."Source Code" where("No." = field("Lead No.")));
            Editable = false;
        }
        field(20; "Opportunity No."; Code[20])
        {
            Caption = 'Opportunity No.';
            ToolTip = 'Specifies the opportunity number created from the lead.';
            DataClassification = CustomerContent;
            TableRelation = Opportunity."No.";
        }
        field(30; "Contact No."; Code[20])
        {
            Caption = 'Contact No.';
            ToolTip = 'Specifies the contact that was created or linked during conversion.';
            DataClassification = CustomerContent;
            TableRelation = Contact."No.";
        }
        field(31; "Contact Name"; Text[100])
        {
            Caption = 'Contact Name';
            ToolTip = 'Specifies the name of the contact.';
            FieldClass = FlowField;
            CalcFormula = lookup(Contact.Name where("No." = field("Contact No.")));
            Editable = false;
        }
        field(40; "Expected Revenue"; Decimal)
        {
            Caption = 'Expected Revenue';
            ToolTip = 'Specifies the expected revenue from the lead at conversion time.';
            DataClassification = CustomerContent;
        }
        field(41; "Actual Revenue"; Decimal)
        {
            Caption = 'Actual Revenue';
            ToolTip = 'Specifies the actual revenue achieved from the opportunity.';
            FieldClass = FlowField;
            CalcFormula = sum("Sales Header"."Amount Including VAT" where("Document Type" = const(Order),
                                                                            "Sell-to Contact No." = field("Contact No."),
                                                                            "Campaign No." = field("Campaign No.")));
            Editable = false;
        }
        field(50; "Campaign No."; Code[20])
        {
            Caption = 'Campaign No.';
            ToolTip = 'Specifies the campaign associated with this conversion.';
            DataClassification = CustomerContent;
            TableRelation = Campaign."No.";
        }
        field(100; "Converted By Name"; Code[50])
        {
            Caption = 'Converted By';
            ToolTip = 'Specifies the user who converted the lead.';
            FieldClass = FlowField;
            CalcFormula = lookup(User."User Name" where("User Security ID" = field(SystemCreatedBy)));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(SK1; "Lead No.")
        {
        }
        key(SK2; "Opportunity No.")
        {
        }
        key(SK3; "Campaign No.", SystemCreatedAt)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Entry No.", "Lead No.", "Opportunity No.", "Contact Name")
        {
        }
    }
}
