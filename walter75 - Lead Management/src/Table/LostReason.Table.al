table 91703 "SEW Lost Reason"
{
    Caption = 'Lost Reason';
    DataClassification = CustomerContent;
    LookupPageId = "SEW Lost Reasons";
    DrillDownPageId = "SEW Lost Reasons";

    fields
    {
        field(1; "Reason Code"; Code[20])
        {
            Caption = 'Reason Code';
            ToolTip = 'Specifies the unique code for this lost reason.';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the description of this lost reason.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Reason Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Reason Code", Description)
        {
        }
    }
}
