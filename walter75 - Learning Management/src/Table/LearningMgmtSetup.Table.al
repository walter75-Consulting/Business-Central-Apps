/// <summary>
/// Table SEW Learning Mgmt Setup (ID 91800).
/// Single-record configuration table for Learning Management system.
/// </summary>
table 91800 "SEW Learning Mgmt Setup"
{
    Caption = 'Learning Management Setup';
    DataClassification = CustomerContent;
    LookupPageId = "SEW Learning Mgmt Setup";
    DrillDownPageId = "SEW Learning Mgmt Setup";
    Extensible = true;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            ToolTip = 'Specifies the primary key.';
        }
        field(10; "API URL"; Text[250])
        {
            Caption = 'API URL';
            ToolTip = 'Specifies the Microsoft Learn API endpoint.';
            InitValue = 'https://learn.microsoft.com/api/catalog/';
        }
        field(11; "API Locale"; Code[10])
        {
            Caption = 'API Locale';
            ToolTip = 'Specifies the locale for API requests (e.g., de-de, en-us).';
            InitValue = 'de-de';
        }
        field(12; "API Product Filter"; Code[50])
        {
            Caption = 'API Product Filter';
            ToolTip = 'Specifies the product filter for API requests.';
            InitValue = 'dynamics-business-central';
        }
        field(20; "Last Sync Date Time"; DateTime)
        {
            Caption = 'Last Sync Date Time';
            ToolTip = 'Specifies when the catalog was last synchronized.';
            Editable = false;
        }
        field(21; "Sync Frequency"; Option)
        {
            Caption = 'Sync Frequency';
            ToolTip = 'Specifies how often the catalog should be synchronized.';
            OptionMembers = "Daily","Weekly","Manual";
            OptionCaption = 'Daily,Weekly,Manual';
            InitValue = "Daily";
        }
        field(30; "Default Assignment Due Days"; Integer)
        {
            Caption = 'Default Assignment Due Days';
            ToolTip = 'Specifies the default number of days until an assignment is due.';
            InitValue = 30;
            MinValue = 1;
        }
        field(31; "Auto Create User Tasks"; Boolean)
        {
            Caption = 'Auto Create User Tasks';
            ToolTip = 'Specifies whether user tasks are automatically created for new assignments.';
            InitValue = true;
        }
        field(32; "Notify on Content Update"; Boolean)
        {
            Caption = 'Notify on Content Update';
            ToolTip = 'Specifies whether employees are notified when assigned content is updated.';
            InitValue = true;
        }
        field(40; "Sync Job Queue Entry ID"; Guid)
        {
            Caption = 'Sync Job Queue Entry ID';
            ToolTip = 'Specifies the ID of the job queue entry for automatic synchronization.';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    /// <summary>
    /// Ensures a setup record exists in the table by creating one if it doesn't exist.
    /// Called during installation or first-time setup.
    /// </summary>
    procedure InsertIfNotExists()
    begin
        Reset();
        if not Get() then begin
            Init();
            "Primary Key" := '';
            Insert(true);
        end;
    end;

    /// <summary>
    /// Gets the full API URL with locale and product filter parameters.
    /// </summary>
    /// <returns>The complete API URL for catalog synchronization.</returns>
    procedure GetFullAPIUrl(): Text
    var
        FullUrl: Text;
    begin
        FullUrl := Rec."API URL";
        if not FullUrl.EndsWith('/') then
            FullUrl += '/';
        FullUrl += StrSubstNo('?locale=%1&product=%2', Rec."API Locale", Rec."API Product Filter");
        exit(FullUrl);
    end;
}
