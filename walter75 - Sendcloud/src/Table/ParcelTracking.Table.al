table 95707 "SEW Parcel Tracking"
{
    Caption = 'SEW Parcel Tracking';
    DataClassification = CustomerContent;
    DrillDownPageId = "SEW Parcel Tracking List";
    LookupPageId = "SEW Parcel Tracking List";

    fields
    {
        field(1; "Parcel Status History ID"; Code[30])
        {
            Caption = 'Parcel Status History ID';
            ToolTip = 'Specifies the Parcel Status History ID.';
            NotBlank = true;
            AllowInCustomizations = Never;
        }
        field(2; "SC Parcel ID"; Integer)
        {
            Caption = 'SendCloud Parcel ID';
            ToolTip = 'Specifies the SendCloud Parcel ID.';
            TableRelation = "SEW Parcel"."SC ID";
            AllowInCustomizations = Never;
        }
        field(3; "Carrier Update Timestamp"; DateTime)
        {
            Caption = 'Carrier Update Timestamp';
            ToolTip = 'Specifies the Carrier Update Timestamp.';
            AllowInCustomizations = Never;
        }
        field(4; "Parent Status"; Text[250])
        {
            Caption = 'Parent Status';
            ToolTip = 'Specifies the Parent Status.';
            AllowInCustomizations = Never;
        }
        field(5; "Carrier Message"; Text[250])
        {
            Caption = 'Carrier Message';
            ToolTip = 'Specifies the Carrier Message.';
            AllowInCustomizations = Never;
        }
    }
    keys
    {
        key(PK; "Parcel Status History ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "SC Parcel ID", "Carrier Update Timestamp", "Parent Status", "Carrier Message") { }
        fieldgroup(Brick; "SC Parcel ID", "Carrier Update Timestamp", "Parent Status", "Carrier Message") { }
    }

}
