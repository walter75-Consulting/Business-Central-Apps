table 91301 "SEW Contact Relation Type"
{
    Caption = 'Contact Relation Type';
    DataClassification = CustomerContent;
    LookupPageId = "SEW Contact Relation Type";
    DrillDownPageId = "SEW Contact Relation Type";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            ToolTip = 'Specifies the code for the contact relation type.';
            NotBlank = true;
        }
        field(2; Description; Text[150])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the description of the contact relation type.';
        }
        field(3; "Description from"; Text[150])
        {
            Caption = 'Description from';
            ToolTip = 'Specifies the description from the source contact perspective.';
        }
        field(4; "Description to"; Text[150])
        {
            Caption = 'Description to';
            ToolTip = 'Specifies the description from the target contact perspective.';
        }
        field(5; "Reverse Entry Code"; Code[20])
        {
            Caption = 'Reverse Entry Code';
            ToolTip = 'Specifies the code for the reverse relation type.';
            NotBlank = true;
            TableRelation = "SEW Contact Relation Type";
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }



    fieldgroups
    {
        fieldgroup(DropDown; Code, Description)
        {
        }
        fieldgroup(Brick; Code, Description)
        {
        }
    }
}
