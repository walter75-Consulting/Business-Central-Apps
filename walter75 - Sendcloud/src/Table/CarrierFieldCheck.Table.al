table 95708 "SEW Carrier Field Check"
{
    Caption = 'Carrier Field Check';
    DataClassification = CustomerContent;

    DrillDownPageId = "SEW Carrier Field Check";
    LookupPageId = "SEW Carrier Field Check";

    fields
    {
        field(1; "Carrier Code"; Code[50])
        {
            Caption = 'Carrier Code';
            ToolTip = 'Specifies the carrier code as defined in Sendcloud.';
            NotBlank = true;
            TableRelation = "SEW Carrier".Code;
        }
        field(2; "Field Name"; Text[30])
        {
            Caption = 'Field Name';
            ToolTip = 'Specifies the Field Name.';
            NotBlank = true;
            TableRelation = "Field".FieldName where(TableNo = const(95707));
        }
        field(3; isMandatory; Boolean)
        {
            Caption = 'is Mandatory';
            ToolTip = 'Specifies if the field is mandatory.';
        }
        field(4; "Minimum length"; Integer)
        {
            Caption = 'Minimum length';
            ToolTip = 'Specifies the Minimum length.';
        }
        field(5; "Maximum length"; Integer)
        {
            Caption = 'Maximum length';
            ToolTip = 'Specifies the Maximum length.';
        }
        field(6; "Overflow in Field Name"; Text[30])
        {
            Caption = 'Overflow Field Name';
            ToolTip = 'Specifies the Overflow in Field Name.';
            NotBlank = true;
        }
        field(7; "API property"; Text[100])
        {
            Caption = 'API property';
            ToolTip = 'Specifies the API property.';
        }
        field(8; "Table No."; Integer)
        {
            Caption = 'Table No.';
            ToolTip = 'Specifies the Table No.';
            TableRelation = "Field".TableNo;
        }
        field(9; "Field No."; Integer)
        {
            Caption = 'Field No.';
            ToolTip = 'Specifies the Field No.';
            TableRelation = "Field"."No.";
        }
        field(10; "Overflow in Field No."; Integer)
        {
            Caption = 'Overflow in Field No.';
            ToolTip = 'Specifies the Overflow in Field No..';
            TableRelation = "Field"."No.";
        }

    }
    keys
    {
        key(PK; "Carrier Code", "Table No.", "Field No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Carrier Code", "Field Name") { }
        fieldgroup(Brick; "Carrier Code", "Field Name") { }

    }

}