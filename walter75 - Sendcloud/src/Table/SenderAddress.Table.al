table 95704 "SEW Sender Address"
{
    Caption = 'SEW Sender Address';
    DataClassification = CustomerContent;
    DrillDownPageId = "SEW Sender Address";
    LookupPageId = "SEW Sender Address";
    Extensible = false;

    fields
    {
        field(1; ID; Integer)
        {
            Caption = 'ID';
            ToolTip = 'Specifies the unique identifier for the sender address as defined in Sendcloud.';
        }
        field(2; "Company Name"; Text[255])
        {
            Caption = 'Company Name';
            ToolTip = 'Specifies the name of the company.';
        }
        field(3; "Contact Name"; Text[255])
        {
            Caption = 'Contact Name';
            ToolTip = 'Specifies the name of the contact person.';
        }
        field(4; eMail; Text[255])
        {
            Caption = 'eMail';
            ToolTip = 'Specifies the email address.';
        }
        field(5; Phone; Text[255])
        {
            Caption = 'Phone';
            ToolTip = 'Specifies the phone number.';
        }
        field(6; Street; Text[255])
        {
            Caption = 'Street';
            ToolTip = 'Specifies the street name.';
        }
        field(7; "House Nbr"; Text[50])
        {
            Caption = 'House Number';
            ToolTip = 'Specifies the house number.';
        }
        field(8; "Postal Box"; Text[50])
        {
            Caption = 'Postal Box';
            ToolTip = 'Specifies the postal box.';
        }
        field(9; "Postal Code"; Text[50])
        {
            Caption = 'Postal Code';
            ToolTip = 'Specifies the postal code.';
        }
        field(10; City; Text[50])
        {
            Caption = 'City';
            ToolTip = 'Specifies the city.';
        }
        field(11; Country; Code[2])
        {
            Caption = 'Country';
            ToolTip = 'Specifies the country code in ISO 3166-1 alpha-2 format.';
        }
        field(12; "Country State"; Text[50])
        {
            Caption = 'Country State';
            ToolTip = 'Specifies the state or province.';
        }
        field(13; "VAT Number"; Text[50])
        {
            Caption = 'VAT Number';
            ToolTip = 'Specifies the VAT number.';
        }
        field(14; "EORI Number"; Text[50])
        {
            Caption = 'EORI Number';
            ToolTip = 'Specifies the EORI number.';
        }
        field(15; "UKIMS Number"; Text[50])
        {
            Caption = 'UKIMS Number';
            ToolTip = 'Specifies the UKIMS number.';
        }
        field(16; "Label"; Text[50])
        {
            Caption = 'Label';
            ToolTip = 'Specifies a label for the sender address.';
        }
        field(17; brandID; Integer)
        {
            Caption = 'brandID';
            ToolTip = 'Specifies the brand ID.';
        }
        field(18; "Signature full Name"; Text[50])
        {
            Caption = 'Signature full Name';
            ToolTip = 'Specifies the full name for the signature.';
        }
        field(19; "Signature Initials"; Text[10])
        {
            Caption = 'Signature Initials';
            ToolTip = 'Specifies the initials for the signature.';
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
        fieldgroup(DropDown; ID, "Company Name") { }
        fieldgroup(Brick; ID, "Company Name") { }
    }
}
