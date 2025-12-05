table 95705 "SEW Parcel Status"
{
    Caption = 'SEW Parcel Status';
    DataClassification = CustomerContent;
    DrillDownPageId = "SEW Parcel Status";
    LookupPageId = "SEW Parcel Status";
    Extensible = false;

    fields
    {
        field(1; "SC Status ID"; Integer)
        {
            Caption = 'SendCloud Status ID';
            ToolTip = 'Specifies the unique identifier for the parcel status as defined in Sendcloud.';
            AllowInCustomizations = Never;
        }
        field(2; "Message"; Text[250])
        {
            Caption = 'Message';
            ToolTip = 'Specifies the message of the parcel status as defined in Sendcloud.';
        }
    }
    keys
    {
        key(PK; "SC Status ID")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "SC Status ID", Message) { }
        fieldgroup(Brick; "SC Status ID", Message) { }
    }
}
