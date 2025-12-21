table 91702 "SEW Lead Source"
{
    Caption = 'Lead Source';
    DataClassification = CustomerContent;
    LookupPageId = "SEW Lead Sources";
    DrillDownPageId = "SEW Lead Sources";

    fields
    {
        field(1; "Source Code"; Code[20])
        {
            Caption = 'Source Code';
            ToolTip = 'Specifies the unique code for this lead source.';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the description of this lead source.';
            DataClassification = CustomerContent;
        }
        field(10; Channel; Enum "SEW Lead Source Channel")
        {
            Caption = 'Channel';
            ToolTip = 'Specifies the channel type for this lead source.';
            DataClassification = CustomerContent;
        }
        field(20; "Default Campaign No."; Code[20])
        {
            Caption = 'Default Campaign No.';
            ToolTip = 'Specifies the default campaign associated with this lead source.';
            TableRelation = Campaign;
            DataClassification = CustomerContent;
        }
        field(30; Active; Boolean)
        {
            Caption = 'Active';
            ToolTip = 'Specifies whether this lead source is active.';
            DataClassification = CustomerContent;
            InitValue = true;
        }
    }

    keys
    {
        key(PK; "Source Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Source Code", Description, Channel)
        {
        }
    }
}
