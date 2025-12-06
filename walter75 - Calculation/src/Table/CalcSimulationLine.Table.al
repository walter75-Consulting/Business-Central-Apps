table 90806 "SEW Calc Simulation Line"
{
    Caption = 'Calculation Simulation Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Simulation No."; Code[20])
        {
            Caption = 'Simulation No.';
            DataClassification = CustomerContent;
            TableRelation = "SEW Calc Simulation Header"."No.";
            ToolTip = 'Specifies the simulation header this line belongs to';
        }
        field(2; "Scenario Code"; Code[20])
        {
            Caption = 'Scenario Code';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the scenario code (e.g., SMALL, MEDIUM, LARGE)';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the line number';
        }
        field(10; "Lot Size"; Decimal)
        {
            Caption = 'Lot Size';
            DataClassification = CustomerContent;
            MinValue = 0;
            DecimalPlaces = 0 : 5;
            ToolTip = 'Specifies the production lot size for this scenario';
        }
        field(11; "Setup Cost"; Decimal)
        {
            Caption = 'Setup Cost';
            DataClassification = CustomerContent;
            MinValue = 0;
            ToolTip = 'Specifies fixed setup costs that apply once per lot';
        }
        field(20; "Material Cost"; Decimal)
        {
            Caption = 'Material Cost';
            DataClassification = CustomerContent;
            Editable = false;
            ToolTip = 'Specifies total material costs for this lot size';
        }
        field(21; "Labor Cost"; Decimal)
        {
            Caption = 'Labor Cost';
            DataClassification = CustomerContent;
            Editable = false;
            ToolTip = 'Specifies total labor costs for this lot size';
        }
        field(22; "Overhead Cost"; Decimal)
        {
            Caption = 'Overhead Cost';
            DataClassification = CustomerContent;
            Editable = false;
            ToolTip = 'Specifies total overhead costs for this lot size';
        }
        field(23; "Total Cost"; Decimal)
        {
            Caption = 'Total Cost';
            DataClassification = CustomerContent;
            Editable = false;
            ToolTip = 'Specifies the total cost including setup for this lot size';
        }
        field(24; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
            DataClassification = CustomerContent;
            Editable = false;
            DecimalPlaces = 2 : 5;
            ToolTip = 'Specifies the cost per unit (Total Cost / Lot Size)';
        }
        field(30; "Suggested Sales Price"; Decimal)
        {
            Caption = 'Suggested Sales Price';
            DataClassification = CustomerContent;
            MinValue = 0;
            ToolTip = 'Specifies the suggested sales price based on target margin';

            trigger OnValidate()
            begin
                UpdateMargin();
            end;
        }
        field(31; "Margin %"; Decimal)
        {
            Caption = 'Margin %';
            DataClassification = CustomerContent;
            Editable = false;
            DecimalPlaces = 0 : 2;
            ToolTip = 'Specifies the margin percentage at suggested sales price';
        }
        field(32; "Break-Even Quantity"; Decimal)
        {
            Caption = 'Break-Even Quantity';
            DataClassification = CustomerContent;
            Editable = false;
            DecimalPlaces = 0 : 5;
            ToolTip = 'Specifies the minimum quantity needed to break even';
        }
        field(40; "Is Recommended"; Boolean)
        {
            Caption = 'Is Recommended';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies whether this is the recommended scenario';
        }
        field(41; "Recommendation Score"; Decimal)
        {
            Caption = 'Recommendation Score';
            DataClassification = CustomerContent;
            Editable = false;
            ToolTip = 'Specifies the calculated score used for recommendation';
        }
    }

    keys
    {
        key(PK; "Simulation No.", "Line No.")
        {
            Clustered = true;
        }
        key(Scenario; "Simulation No.", "Scenario Code")
        {
        }
        key(Recommended; "Simulation No.", "Is Recommended")
        {
        }
    }

    local procedure UpdateMargin()
    begin
        if ("Suggested Sales Price" > 0) and ("Unit Cost" > 0) then
            "Margin %" := (("Suggested Sales Price" - "Unit Cost") / "Suggested Sales Price") * 100
        else
            "Margin %" := 0;
    end;
}
