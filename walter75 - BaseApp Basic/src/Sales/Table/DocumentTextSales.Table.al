table 80007 "SEW Document Text Sales"
{
    Caption = 'Document Texts Sales';
    DataClassification = CustomerContent;
    LookupPageId = "SEW Document Text Sales";
    DrillDownPageId = "SEW Document Text Sales";
    Permissions = tabledata "SEW Document Text Sales" = rimd;

    fields
    {
        field(1; "Document Type Sales"; Enum "Sales Document Type")
        {
            Caption = 'Code';
            ToolTip = 'Specifies the Code.';
        }
        field(2; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            ToolTip = 'Specifies the Language Code.';
            TableRelation = Language;

            trigger OnValidate()
            begin
                if "Language Code" <> '' then
                    "All Language Codes" := false;
            end;
        }
        field(3; "All Language Codes"; Boolean)
        {
            Caption = 'All Language Codes';
            ToolTip = 'Specifies the  All Language Codes.';
            InitValue = true;

            trigger OnValidate()
            begin
                if "All Language Codes" then
                    "Language Code" := ''
            end;
        }
        field(4; "Text No."; Integer)
        {
            Caption = 'Text No.';
            ToolTip = 'Specifies the Text No.';
            Editable = false;
            AllowInCustomizations = Never;
        }
        field(5; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            ToolTip = 'Specifies the Starting Date.';
        }
        field(6; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
            ToolTip = 'Specifies the Ending Date.';
        }
        field(7; Position; Enum "SEW Document Text Position")
        {
            Caption = 'Position';
            ToolTip = 'Specifies the Position.';
        }
        field(8; Sortorder; Enum "SEW Document Text SortOrder")
        {
            Caption = 'SortOrder';
            ToolTip = 'Specifies the SortOrder.';
        }
        field(9; "Document Text"; Text[255])
        {
            Caption = 'Document Text';
            ToolTip = 'Specifies the Document Text.';
        }
        field(10; "for eMail"; Boolean)
        {
            Caption = 'eMail';
            ToolTip = 'Specifies whether the document text is used in eMail.';
        }




    }
    keys
    {
        key(PK; "Document Type Sales", "Language Code", "for eMail", "Text No.")
        {
            Clustered = true;
        }
        key(Key2; "Document Type Sales", "Language Code", "for eMail", "All Language Codes", "Starting Date", "Ending Date")
        {
        }
        key(Key3; Sortorder)
        {
        }


    }
    fieldgroups
    {
        fieldgroup(DropDown; "Document Type Sales", "Language Code", "Document Text") { }
        fieldgroup(Brick; "Document Type Sales", "Language Code", "Document Text") { }
    }


    trigger OnInsert()
    begin
        IncrementTextNo();
    end;


    procedure IncrementTextNo()
    var
        SEWDocumentTextSales: Record "SEW Document Text Sales";
    begin
        SEWDocumentTextSales.SetRange("Document Type Sales", Rec."Document Type Sales");
        SEWDocumentTextSales.SetRange("Language Code", Rec."Language Code");

        if SEWDocumentTextSales.FindLast() then
            "Text No." := SEWDocumentTextSales."Text No." + 1
        else
            "Text No." := 1;
    end;
}
