/// <summary>
/// Package Material Table
/// This table stores information about different types of package materials including their dimensions and weight.
/// </summary>
table 90700 "SEW Package Material"
{
    Caption = 'Package Material';
    DataClassification = CustomerContent;
    LookupPageId = "SEW Package Material List";
    DrillDownPageId = "SEW Package Material List";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            ToolTip = 'Specifies the code for the package material.';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the description for the package material.';
        }
        field(7300; "Length cm"; Decimal)
        {
            Caption = 'Length cm';
            ToolTip = 'Specifies the length of the package material in centimeters.';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            AllowInCustomizations = Never;

            trigger OnValidate()
            begin
                CalcCubage();
            end;
        }
        field(7301; "Width cm"; Decimal)
        {
            Caption = 'Width cm';
            ToolTip = 'Specifies the width of the package material in centimeters.';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            AllowInCustomizations = Never;

            trigger OnValidate()
            begin
                CalcCubage();
            end;
        }
        field(7302; "Height cm"; Decimal)
        {
            Caption = 'Height cm';
            ToolTip = 'Specifies the height of the package material in centimeters.';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            AllowInCustomizations = Never;

            trigger OnValidate()
            begin
                CalcCubage();
            end;
        }
        field(7303; "Cubage cm3"; Decimal)
        {
            Caption = 'Cubage cm3';
            ToolTip = 'Specifies the cubage of the package material in cubic centimeters.';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            AllowInCustomizations = Never;
        }
        field(7304; "Weight kg"; Decimal)
        {
            Caption = 'Weight in kg';
            ToolTip = 'Specifies the weight of the package material in kilograms.';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            AllowInCustomizations = Never;
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", "Description")
        {
        }
        fieldgroup(Brick; "Code", "Description")
        {
        }
    }

    local procedure CalcCubage()
    begin
        "Cubage cm3" := ("Length cm" * "Width cm" * "Height cm");
    end;

}