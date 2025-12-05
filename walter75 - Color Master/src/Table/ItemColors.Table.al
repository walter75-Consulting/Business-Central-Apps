table 91600 "SEW Item Colors"
{
    Caption = 'Item Colors';
    DataClassification = CustomerContent;
    LookupPageId = "SEW Item Colors";
    DrillDownPageId = "SEW Item Colors";


    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            ToolTip = 'Specifies the color code.';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the description of the color.';
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