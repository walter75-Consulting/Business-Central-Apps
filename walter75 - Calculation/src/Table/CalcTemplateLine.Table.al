table 90802 "SEW Calc Template Line"
{
    Caption = 'Calculation Template Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Template Code"; Code[20])
        {
            Caption = 'Template Code';
            ToolTip = 'Specifies the template code this line belongs to.';
            TableRelation = "SEW Calc Template".Code;
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

            trigger OnValidate()
            begin
                if Rec.Type in [Type::Header, Type::"Sum Line"] then
                    Rec.Indentation := 0;
            end;
        }
        field(11; Description; Text[100])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the description of the calculation line.';
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
        }
        field(30; Indentation; Integer)
        {
            Caption = 'Indentation';
            ToolTip = 'Specifies the indentation level for display.';
            MinValue = 0;
            MaxValue = 10;
        }
        field(31; Bold; Boolean)
        {
            Caption = 'Bold';
            ToolTip = 'Specifies whether to display the line in bold.';
        }
        field(32; "Show in Report"; Boolean)
        {
            Caption = 'Show in Report';
            ToolTip = 'Specifies whether to show this line in reports.';
            InitValue = true;
        }
    }

    keys
    {
        key(PK; "Template Code", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Template Code", "Line No.", Type, Description)
        {
        }
        fieldgroup(Brick; "Template Code", "Line No.", Type, Description)
        {
        }
    }
}
