table 90804 "SEW Calc Line"
{
    Caption = 'Calculation Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Calc No."; Code[20])
        {
            Caption = 'Calc No.';
            ToolTip = 'Specifies the calculation number this line belongs to.';
            TableRelation = "SEW Calc Header"."No.";
            NotBlank = true;
            ValidateTableRelation = true;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            ToolTip = 'Specifies the line number.';
        }
        field(10; Type; Enum "SEW Calc Line Type")
        {
            Caption = 'Type';
            ToolTip = 'Specifies the type of calculation line (Header, Material, Labor, Overhead, Sum, Formula).';
        }
        field(11; Description; Text[100])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the description of the calculation line.';
        }
        field(12; "Source Type"; Option)
        {
            Caption = 'Source Type';
            ToolTip = 'Specifies the source type (Item, Resource, Work Center, Machine Center, Formula).';
            OptionMembers = " ",Item,Resource,"Work Center","Machine Center",Formula;
        }
        field(13; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            ToolTip = 'Specifies the source number (Item No., Resource No., etc.).';
            TableRelation = if ("Source Type" = const(Item)) Item."No."
            else
            if ("Source Type" = const(Resource)) Resource."No."
            else
            if ("Source Type" = const("Work Center")) "Work Center"."No."
            else
            if ("Source Type" = const("Machine Center")) "Machine Center"."No.";
            ValidateTableRelation = true;
        }
        field(20; Formula; Text[250])
        {
            Caption = 'Formula';
            ToolTip = 'Specifies the formula for calculation (e.g., MATERIAL * (1 + VAR001)).';
        }
        field(21; "Variable Code"; Code[20])
        {
            Caption = 'Variable Code';
            ToolTip = 'Specifies the variable code used in the formula.';
            TableRelation = "SEW Calc Variable".Code;
            ValidateTableRelation = true;
            AllowInCustomizations = AsReadOnly;
        }
        field(30; "Base Value"; Decimal)
        {
            Caption = 'Base Value';
            ToolTip = 'Specifies the base value for calculation (e.g., Material Cost from BOM).';
            DecimalPlaces = 2 : 5;
        }
        field(31; "Factor / Percentage"; Decimal)
        {
            Caption = 'Factor / Percentage';
            ToolTip = 'Specifies the factor or percentage applied to the base value.';
            DecimalPlaces = 2 : 5;
        }
        field(32; "Calculated Value"; Decimal)
        {
            Caption = 'Calculated Value';
            ToolTip = 'Specifies the calculated result value.';
            DecimalPlaces = 2 : 5;
        }
        field(33; Amount; Decimal)
        {
            Caption = 'Amount';
            ToolTip = 'Specifies the amount for this line.';
            DecimalPlaces = 2 : 5;
        }
        field(40; Quantity; Decimal)
        {
            Caption = 'Quantity';
            ToolTip = 'Specifies the quantity (for material lines).';
            DecimalPlaces = 0 : 5;
            AllowInCustomizations = AsReadOnly;
        }
        field(41; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
            ToolTip = 'Specifies the unit cost (for material/resource lines).';
            DecimalPlaces = 2 : 5;
            AllowInCustomizations = AsReadOnly;
        }
        field(50; Indentation; Integer)
        {
            Caption = 'Indentation';
            ToolTip = 'Specifies the indentation level for display.';
            MinValue = 0;
            MaxValue = 10;
            AllowInCustomizations = AsReadOnly;
        }
        field(51; Bold; Boolean)
        {
            Caption = 'Bold';
            ToolTip = 'Specifies whether to display the line in bold.';
            AllowInCustomizations = AsReadOnly;
        }
        field(52; "Show in Report"; Boolean)
        {
            Caption = 'Show in Report';
            ToolTip = 'Specifies whether to show this line in reports.';
            InitValue = true;
            AllowInCustomizations = AsReadOnly;
        }
    }

    keys
    {
        key(PK; "Calc No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Calc No.", "Line No.", Type, Description)
        {
        }
        fieldgroup(Brick; "Calc No.", "Line No.", Type, Description)
        {
        }
    }
}
