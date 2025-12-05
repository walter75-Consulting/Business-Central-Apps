table 95712 "SEW Recipient Address"
{
    Caption = 'Recipient Address';
    DataClassification = CustomerContent;
    DrillDownPageId = "SEW Recipient Address Card";
    LookupPageId = "SEW Recipient Address List";

    Permissions = tabledata "SEW SendCloud Setup" = r;

    fields
    {
        field(1; "Recipient No."; Code[20])
        {
            Caption = 'Recipient ID';
            ToolTip = 'Specifies the unique identifier for the recipient address.';
            DataClassification = ToBeClassified;
            AllowInCustomizations = Never;
            NotBlank = true;

            trigger OnValidate()
            begin
                CheckRecipientNo();
            end;
        }
        field(2; "Name 1"; Text[100])
        {
            Caption = 'Name 1';
            ToolTip = 'Specifies the name of the recipient.';
        }
        field(3; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
            ToolTip = 'Specifies the additional name of the recipient.';
        }
        field(4; Street; Text[100])
        {
            Caption = 'Street';
            ToolTip = 'Specifies the street for the recipient.';
        }
        field(5; "House Nbr."; Text[250])
        {
            Caption = 'House Nbr.';
            ToolTip = 'Specifies the house number for the recipient.';
        }
        field(6; CountryCode; Code[10])
        {
            Caption = 'Country';
            ToolTip = 'Specifies the country code for the recipient.';
            TableRelation = "Country/Region".Code;
        }
        field(7; PostalCode; Text[20])
        {
            Caption = 'Postal Code';
            ToolTip = 'Spedifies the postal code for the recipient.';
            TableRelation = "Country/Region".Code where(Code = field(CountryCode));
        }
        field(8; City; Text[30])
        {
            Caption = 'City';
            ToolTip = 'Specifies the city for the recipient.';
        }
        field(9; CountryState; Text[30])
        {
            Caption = 'CountryState';
            ToolTip = 'Specifies the state for the recipient.';
        }
        field(10; ContactName; Text[100])
        {
            Caption = 'Contact Name';
            ToolTip = 'Specifies the contact name for the recipient.';
        }
        field(11; Phone; Text[30])
        {
            Caption = 'Phone';
            ToolTip = 'Specifies the phone number for the recipient.';
        }
        field(12; Email; Text[80])
        {
            Caption = 'Email';
            ToolTip = 'Specifies the email address for the recipient.';
        }
    }

    keys
    {
        key(PK; "Recipient No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Recipient No.", "Name 1", Street, PostalCode, City, CountryCode)
        {
        }
        fieldgroup(Brick; "Recipient No.", "Name 1", Street, PostalCode, City, CountryCode)
        {
        }
    }

    trigger OnInsert()
    begin
        CheckRecipientNo();
    end;

    local procedure CheckRecipientNo()
    var
        SEWSendCloudSetup: Record "SEW SendCloud Setup";
        SEWNoSeriesCU: Codeunit "No. Series";
        ErrMsgSetupLbl: Label 'No. Series for Recipient No. is not setup in SendCloud Setup.';
    begin
        if not SEWSendCloudSetup.Get() then
            Error(ErrMsgSetupLbl);
        if Rec."Recipient No." = '' then
            Rec."Recipient No." := SEWNoSeriesCU.GetNextNo(SEWSendCloudSetup."Recipient No. Series");
    end;



}