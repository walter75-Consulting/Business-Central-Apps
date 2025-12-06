table 90802 "SEW Calc Variable"
{
    Caption = 'Calculation Variable';
    DataClassification = CustomerContent;
    LookupPageId = "SEW Calc Variables";
    DrillDownPageId = "SEW Calc Variables";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            ToolTip = 'Specifies the unique code for the variable (e.g., VAR001, OVERHEAD)';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(2; "Valid From Date"; Date)
        {
            Caption = 'Valid From Date';
            ToolTip = 'Specifies from which date this variable value is valid';
            DataClassification = CustomerContent;
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the description of the variable';
            DataClassification = CustomerContent;
        }
        field(20; Type; Enum "SEW Calc Variable Type")
        {
            Caption = 'Type';
            ToolTip = 'Specifies the type of variable (Percentage, Absolute Value, Factor)';
            DataClassification = CustomerContent;
        }
        field(21; Value; Decimal)
        {
            Caption = 'Value';
            ToolTip = 'Specifies the value of the variable';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 5;
        }
        field(22; Base; Enum "SEW Calc Variable Base")
        {
            Caption = 'Base';
            ToolTip = 'Specifies what the variable is based on (Material, Labor, Overhead, Total Cost)';
            DataClassification = CustomerContent;
        }
        field(30; "Valid To Date"; Date)
        {
            Caption = 'Valid To Date';
            ToolTip = 'Specifies until which date this variable value is valid';
            DataClassification = CustomerContent;
        }
        field(31; Global; Boolean)
        {
            Caption = 'Global';
            ToolTip = 'Specifies whether this variable is globally available for all templates';
            DataClassification = CustomerContent;
            InitValue = true;
        }
    }

    keys
    {
        key(PK; "Code", "Valid From Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description, Value)
        {
        }
        fieldgroup(Brick; "Code", Description, Type, Value)
        {
        }
    }

    trigger OnDelete()
    var
        SEWCalcTemplateLine: Record "SEW Calc Template Line";
        CannotDeleteErr: Label 'Cannot delete variable %1 because it is used in one or more template lines.', Comment = '%1 = Variable Code';
    begin
        SEWCalcTemplateLine.SetRange("Variable Code", Rec.Code);
        if not SEWCalcTemplateLine.IsEmpty() then
            Error(CannotDeleteErr, Rec.Code);
    end;
}
