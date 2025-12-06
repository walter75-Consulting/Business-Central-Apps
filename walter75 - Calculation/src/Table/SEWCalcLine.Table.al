table 90804 "SEW Calc Line"
{
    Caption = 'Calculation Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Calc No."; Code[20])
        {
            Caption = 'Calc No.';
            ToolTip = 'Specifies the calculation number this line belongs to';
            DataClassification = CustomerContent;
            TableRelation = "SEW Calc Header"."No.";
            NotBlank = true;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            ToolTip = 'Specifies the line number';
            DataClassification = CustomerContent;
        }
        field(10; Type; Enum "SEW Calc Line Type")
        {
            Caption = 'Type';
            ToolTip = 'Specifies the type of calculation line (Header, Material, Labor, Overhead, Sum, Formula)';
            DataClassification = CustomerContent;
        }
        field(11; Description; Text[100])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the description of the calculation line';
            DataClassification = CustomerContent;
        }
        field(12; "Source Type"; Option)
        {
            Caption = 'Source Type';
            ToolTip = 'Specifies the source type (Item, Resource, Work Center, Machine Center, Formula)';
            DataClassification = CustomerContent;
            OptionMembers = " ",Item,Resource,"Work Center","Machine Center",Formula;
        }
        field(13; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            ToolTip = 'Specifies the source number (Item No., Resource No., etc.)';
            DataClassification = CustomerContent;
            TableRelation = if ("Source Type" = const(Item)) Item."No."
            else
            if ("Source Type" = const(Resource)) Resource."No."
            else
            if ("Source Type" = const("Work Center")) "Work Center"."No."
            else
            if ("Source Type" = const("Machine Center")) "Machine Center"."No.";
        }
        field(20; Formula; Text[250])
        {
            Caption = 'Formula';
            ToolTip = 'Specifies the formula for calculation (e.g., MATERIAL * (1 + VAR001))';
            DataClassification = CustomerContent;
        }
        field(21; "Variable Code"; Code[20])
        {
            Caption = 'Variable Code';
            ToolTip = 'Specifies the variable code used in the formula';
            DataClassification = CustomerContent;
            TableRelation = "SEW Calc Variable".Code;
        }
        field(30; "Base Value"; Decimal)
        {
            Caption = 'Base Value';
            ToolTip = 'Specifies the base value for calculation (e.g., Material Cost from BOM)';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 5;
        }
        field(31; "Factor / Percentage"; Decimal)
        {
            Caption = 'Factor / Percentage';
            ToolTip = 'Specifies the factor or percentage applied to the base value';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 5;
        }
        field(32; "Calculated Value"; Decimal)
        {
            Caption = 'Calculated Value';
            ToolTip = 'Specifies the calculated result value';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 5;
        }
        field(33; Amount; Decimal)
        {
            Caption = 'Amount';
            ToolTip = 'Specifies the amount for this line';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 5;
        }
        field(40; Quantity; Decimal)
        {
            Caption = 'Quantity';
            ToolTip = 'Specifies the quantity (for material lines)';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(41; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
            ToolTip = 'Specifies the unit cost (for material/resource lines)';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 5;
        }
        field(50; Indentation; Integer)
        {
            Caption = 'Indentation';
            ToolTip = 'Specifies the indentation level for display';
            DataClassification = CustomerContent;
            MinValue = 0;
            MaxValue = 10;
        }
        field(51; Bold; Boolean)
        {
            Caption = 'Bold';
            ToolTip = 'Specifies whether to display the line in bold';
            DataClassification = CustomerContent;
        }
        field(52; "Show in Report"; Boolean)
        {
            Caption = 'Show in Report';
            ToolTip = 'Specifies whether to show this line in reports';
            DataClassification = CustomerContent;
            InitValue = true;
        }
    }

    keys
    {
        key(PK; "Calc No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
