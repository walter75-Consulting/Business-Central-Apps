tableextension 90892 "SEW Sales Line Ext" extends "Sales Line"
{
    fields
    {
        field(90800; "SEW Calc No."; Code[20])
        {
            Caption = 'Calc No.';
            ToolTip = 'Specifies the calculation number linked to this sales line.';
            TableRelation = "SEW Calc Header";

            trigger OnValidate()
            var
                CalcHeader: Record "SEW Calc Header";
            begin
                if "SEW Calc No." <> '' then begin
                    CalcHeader.Get("SEW Calc No.");
                    "SEW Calculated Cost" := CalcHeader."Total Cost";
                    UpdateMargin();
                end else begin
                    "SEW Calculated Cost" := 0;
                    "SEW Calculated Margin %" := 0;
                end;
            end;
        }
        field(90801; "SEW Calculated Cost"; Decimal)
        {
            Caption = 'Calculated Cost';
            ToolTip = 'Specifies the calculated cost from the linked calculation.';
            Editable = false;
            DecimalPlaces = 2 : 5;

            trigger OnValidate()
            begin
                UpdateMargin();
            end;
        }
        field(90802; "SEW Calculated Margin %"; Decimal)
        {
            Caption = 'Calculated Margin %';
            ToolTip = 'Specifies the calculated margin percentage based on calculated cost and unit price.';
            Editable = false;
            DecimalPlaces = 0 : 2;
        }
        field(90803; "SEW Target Price"; Decimal)
        {
            Caption = 'Target Price';
            ToolTip = 'Specifies the suggested selling price based on calculated cost and target margin.';
            Editable = false;
            DecimalPlaces = 2 : 5;
        }
        field(90804; "SEW Material Cost"; Decimal)
        {
            Caption = 'Material Cost';
            ToolTip = 'Specifies the material cost component from the calculation.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("SEW Calc Header"."Total Material Cost" where("No." = field("SEW Calc No.")));
            AllowInCustomizations = AsReadOnly;
        }
        field(90805; "SEW Labor Cost"; Decimal)
        {
            Caption = 'Labor Cost';
            ToolTip = 'Specifies the labor cost component from the calculation.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("SEW Calc Header"."Total Labor Cost" where("No." = field("SEW Calc No.")));
            AllowInCustomizations = AsReadOnly;
        }
        field(90806; "SEW Overhead Cost"; Decimal)
        {
            Caption = 'Overhead Cost';
            ToolTip = 'Specifies the overhead cost component from the calculation.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("SEW Calc Header"."Total Overhead Cost" where("No." = field("SEW Calc No.")));
            AllowInCustomizations = AsReadOnly;
        }
    }

    local procedure UpdateMargin()
    begin
        if ("Unit Price" <> 0) and ("SEW Calculated Cost" <> 0) then
            "SEW Calculated Margin %" := Round((("Unit Price" - "SEW Calculated Cost") / "Unit Price") * 100, 0.01)
        else
            "SEW Calculated Margin %" := 0;
    end;
}
