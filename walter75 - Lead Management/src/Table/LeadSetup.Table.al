table 91701 "SEW Lead Setup"
{
    Caption = 'Lead Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            ToolTip = 'Specifies the primary key for the setup record.';
            DataClassification = SystemMetadata;
            NotBlank = true;
        }
        field(10; "Lead No. Series"; Code[20])
        {
            Caption = 'Lead No. Series';
            ToolTip = 'Specifies the number series used for creating new leads.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(30; "Auto Create Contact On Working"; Boolean)
        {
            Caption = 'Auto Create Contact On Working';
            ToolTip = 'Specifies whether a contact should be automatically created when lead status changes to Working.';
            DataClassification = CustomerContent;
            InitValue = true;
        }
        field(40; "Consent Required"; Boolean)
        {
            Caption = 'Consent Required';
            ToolTip = 'Specifies whether marketing consent is required for leads.';
            DataClassification = CustomerContent;
        }
        field(41; "SLA First Response (h)"; Integer)
        {
            Caption = 'SLA First Response (hours)';
            ToolTip = 'Specifies the service level agreement for first response in hours.';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(50; "Enable Quick Capture"; Boolean)
        {
            Caption = 'Enable Quick Capture';
            ToolTip = 'Specifies whether leads can be created without an associated contact.';
            DataClassification = CustomerContent;
            InitValue = true;
        }
        field(51; "Default Stage Code"; Code[20])
        {
            Caption = 'Default Stage Code';
            ToolTip = 'Specifies the default stage assigned to new leads.';
            TableRelation = "SEW Lead Stage";
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        "Primary Key" := '';
    end;
}
