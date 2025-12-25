/// <summary>
/// Feature toggle configuration for all SEW applications.
/// Allows admins to enable/disable features dynamically.
/// </summary>
table 71300 "SEW Feature"
{
    Caption = 'Feature';
    DataClassification = SystemMetadata;
    LookupPageId = "SEW Feature Management";
    DrillDownPageId = "SEW Feature Management";

    fields
    {
        field(1; "Code"; Code[50])
        {
            Caption = 'Code';
            ToolTip = 'Specifies the unique feature code.';
            NotBlank = true;
        }
        field(2; "App Name"; Text[100])
        {
            Caption = 'App Name';
            ToolTip = 'Specifies the name of the application this feature belongs to.';
        }
        field(3; "Feature Name"; Text[100])
        {
            Caption = 'Feature Name';
            ToolTip = 'Specifies the name of the feature.';
        }
        field(4; Description; Text[250])
        {
            Caption = 'Description';
            ToolTip = 'Specifies a description of the feature.';
        }
        field(5; Enabled; Boolean)
        {
            Caption = 'Enabled';
            ToolTip = 'Specifies whether the feature is enabled or disabled.';

            trigger OnValidate()
            var
                FeatureMgmt: Codeunit "SEW Feature Management";
            begin
                if Enabled then begin
                    Rec."Activation Date" := CurrentDateTime();
                    Rec."Activation User" := CopyStr(UserId(), 1, MaxStrLen(Rec."Activation User"));
                end;

                // Clear cache immediately
                FeatureMgmt.RefreshCache();
            end;
        }
        field(10; "Requires License"; Boolean)
        {
            Caption = 'Requires License';
            ToolTip = 'Specifies whether the feature requires a valid license to be enabled.';
            InitValue = false;
        }
        field(11; "License Feature Code"; Code[50])
        {
            Caption = 'License Feature Code';
            ToolTip = 'Specifies the license feature code associated with this feature.';
        }
        field(12; "Default State"; Boolean)
        {
            Caption = 'Default State';
            ToolTip = 'Specifies the default state of the feature (enabled/disabled) when first installed.';
            InitValue = false;
        }
        field(20; "Activation Date"; DateTime)
        {
            Caption = 'Activation Date';
            ToolTip = 'Specifies the date and time when the feature was activated.';
            Editable = false;
        }
        field(21; "Activation User"; Code[50])
        {
            Caption = 'Activation User';
            ToolTip = 'Specifies the user who activated the feature.';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
            Editable = false;
        }
        field(30; "Last Modified Date"; DateTime)
        {
            Caption = 'Last Modified Date';
            ToolTip = 'Specifies the date and time when the feature was last modified.';
            Editable = false;
        }
        field(31; "Last Modified User"; Code[50])
        {
            Caption = 'Last Modified User';
            ToolTip = 'Specifies the user who last modified the feature.';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
            Editable = false;
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
        key(AppIdx; "App Name", Code)
        {
        }
        key(EnabledIdx; Enabled)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Code, "Feature Name", Enabled)
        {
        }
        fieldgroup(Brick; Code, "Feature Name", Enabled, "App Name", "Requires License", "Activation Date", "Activation User")
        {
        }
    }

    trigger OnInsert()
    begin
        Rec."Last Modified Date" := CurrentDateTime();
        Rec."Last Modified User" := CopyStr(UserId(), 1, MaxStrLen(Rec."Last Modified User"));
    end;

    trigger OnModify()
    begin
        Rec."Last Modified Date" := CurrentDateTime();
        Rec."Last Modified User" := CopyStr(UserId(), 1, MaxStrLen(Rec."Last Modified User"));
    end;
}
