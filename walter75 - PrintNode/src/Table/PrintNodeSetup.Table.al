table 92704 "SEW PrintNode Setup"
{
    Caption = 'PrintNode Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            ToolTip = 'Specifies the primary key.';
            NotBlank = true;
            AllowInCustomizations = Never;
        }

        field(2; "API Key"; Text[255])
        {
            Caption = 'API Key';
            ToolTip = 'Specifies the API key.';
        }
        field(3; "PrintNode Base URL"; Text[255])
        {
            Caption = 'PrintNode Base URL';
            ToolTip = 'Specifies the PrintNode API base URL.';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure InsertIfNotExists()
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert(true);
        end;
    end;


}