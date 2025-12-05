table 90000 "SEW OAuth Application"
{
    Caption = 'OAuth 2.0 Application';
    DrillDownPageId = "SEW OAuth Applications";
    LookupPageId = "SEW OAuth Applications";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            ToolTip = 'Specifies the unique code for the OAuth 2.0 application.';
            NotBlank = true;
        }
        field(2; Description; Text[250])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the description of the OAuth 2.0 application.';
        }
        field(3; "Client ID"; Text[250])
        {
            Caption = 'Client ID';
            ToolTip = 'Specifies the unique identifier for the OAuth 2.0 client.';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(4; "Client Secret"; Text[250])
        {
            Caption = 'Client Secret';
            ToolTip = 'Specifies the secret key for the OAuth 2.0 client.';
            DataClassification = EndUserIdentifiableInformation;
            ExtendedDatatype = Masked;
        }
        field(5; "Redirect URL"; Text[250])
        {
            Caption = 'Redirect URL';
            ToolTip = 'Specifies the URL to which the authorization server will redirect the user after granting authorization.';
        }
        field(6; "Auth. URL Parms"; Text[250])
        {
            Caption = 'Auth. URL Parms';
            ToolTip = 'Specifies the parameters to include in the authorization URL.';
        }
        field(7; Scope; Text[250])
        {
            Caption = 'Scope';
            ToolTip = 'Specifies the scope of access requested by the application.';
        }
        field(8; "Authorization URL"; Text[250])
        {
            Caption = 'Authorization URL';
            ToolTip = 'Specifies the URL used for user authorization.';

            trigger OnValidate()
            var
                WebRequestHelper: Codeunit "Web Request Helper";
            begin
                if "Authorization URL" <> '' then
                    WebRequestHelper.IsSecureHttpUrl("Authorization URL");
            end;
        }
        field(9; "Access Token URL"; Text[250])
        {
            Caption = 'Access Token URL';
            ToolTip = 'Specifies the URL used to obtain the access token.';

            trigger OnValidate()
            var
                WebRequestHelper: Codeunit "Web Request Helper";
            begin
                if "Access Token URL" <> '' then
                    WebRequestHelper.IsSecureHttpUrl("Access Token URL");
            end;
        }
        field(10; Status; Enum "SEW Auth App Status")
        {
            Caption = 'Status';
            ToolTip = 'Specifies the current status of the OAuth 2.0 application.';
        }
        field(11; "Access Token"; Blob)
        {
            Caption = 'Access Token';
            ToolTip = 'Specifies the access token used for authentication.';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(12; "Refresh Token"; Blob)
        {
            Caption = 'Refresh Token';
            ToolTip = 'Specifies the refresh token used to obtain a new access token.';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(13; "Authorization Time"; DateTime)
        {
            Caption = 'Authorization Time';
            ToolTip = 'Specifies the time when the authorization was granted.';
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
            AllowInCustomizations = Never;
        }
        field(14; "Expires In"; Integer)
        {
            Caption = 'Expires In';
            ToolTip = 'Specifies the duration in seconds before the access token expires.';
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
            AllowInCustomizations = Never;
        }
        field(15; "Ext. Expires In"; Integer)
        {
            Caption = 'Ext. Expires In';
            ToolTip = 'Specifies the extended duration in seconds before the access token expires.';
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
            AllowInCustomizations = Never;
        }
        field(16; "Grant Type"; Enum "SEW Auth Grant Type")
        {
            Caption = 'Grant Type';
            ToolTip = 'Specifies the OAuth 2.0 grant type used for authorization.';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(17; "User Name"; Text[80])
        {
            Caption = 'User Name';
            ToolTip = 'Specifies the user name for resource owner password credentials grant type.';
        }
        field(18; Password; Text[20])
        {
            Caption = 'Password';
            ToolTip = 'Specifies the password for resource owner password credentials grant type.';
            ExtendedDatatype = Masked;
        }
        field(19; "App API URL"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Base API URL';
            ToolTip = 'Specifies the base URL for the API endpoints of the application.';
        }
        field(20; "API Key Name"; Text[255])
        {
            DataClassification = CustomerContent;
            Caption = 'API Key Name';
            ToolTip = 'Specifies the name of the API key used for authentication.';
        }
        field(21; "API Key Value"; Text[255])
        {
            DataClassification = CustomerContent;
            ExtendedDatatype = Masked;
            Caption = 'API Key Value';
            ToolTip = 'Specifies the value of the API key used for authentication.';
        }
        field(22; "App API Header"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'App API Header';
            ToolTip = 'Specifies whether to include the API key in the request header.';
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Code", "Description")
        {
        }
        fieldgroup(Brick; "Code", "Description")
        {
        }
    }

    trigger OnModify()
    begin
        Clear(Status);
        Clear("Access Token");
        Clear("Refresh Token");
        "Expires In" := 0;
        "Ext. Expires In" := 0;
        "Authorization Time" := 0DT;
    end;
}