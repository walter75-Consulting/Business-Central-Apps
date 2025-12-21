table 91721 "SEW UTM Attribution"
{
    Caption = 'UTM Attribution';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Lead No."; Code[20])
        {
            Caption = 'Lead No.';
            ToolTip = 'Specifies the lead number for this attribution data.';
            DataClassification = CustomerContent;
            TableRelation = "SEW Lead"."No.";
            NotBlank = true;
        }
        field(10; "UTM Source"; Text[50])
        {
            Caption = 'UTM Source';
            ToolTip = 'Specifies the referrer (e.g., google, facebook, newsletter).';
            DataClassification = CustomerContent;
        }
        field(11; "UTM Medium"; Text[50])
        {
            Caption = 'UTM Medium';
            ToolTip = 'Specifies the marketing medium (e.g., cpc, email, social).';
            DataClassification = CustomerContent;
        }
        field(12; "UTM Campaign"; Text[50])
        {
            Caption = 'UTM Campaign';
            ToolTip = 'Specifies the campaign name (e.g., spring-promo-2024).';
            DataClassification = CustomerContent;
        }
        field(13; "UTM Term"; Text[50])
        {
            Caption = 'UTM Term';
            ToolTip = 'Specifies the paid search keywords.';
            DataClassification = CustomerContent;
        }
        field(14; "UTM Content"; Text[50])
        {
            Caption = 'UTM Content';
            ToolTip = 'Specifies the ad variant or content identifier.';
            DataClassification = CustomerContent;
        }
        field(20; "Landing Page URL"; Text[250])
        {
            Caption = 'Landing Page URL';
            ToolTip = 'Specifies the page where the lead landed.';
            DataClassification = CustomerContent;
        }
        field(21; "Referrer URL"; Text[250])
        {
            Caption = 'Referrer URL';
            ToolTip = 'Specifies the referring page URL.';
            DataClassification = CustomerContent;
        }
        field(30; "IP Address"; Text[45])
        {
            Caption = 'IP Address';
            ToolTip = 'Specifies the IP address of the visitor.';
            DataClassification = EndUserPseudonymousIdentifiers;
        }
        field(31; "User Agent"; Text[250])
        {
            Caption = 'User Agent';
            ToolTip = 'Specifies the browser user agent string.';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "Lead No.")
        {
            Clustered = true;
        }
        key(SK1; "UTM Source", "UTM Medium", "UTM Campaign")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Lead No.", "UTM Source", "UTM Medium", "UTM Campaign")
        {
        }
    }
}
