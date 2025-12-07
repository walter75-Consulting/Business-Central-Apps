tableextension 90898 "SEW Prod Order Calc Ext" extends "Production Order"
{
    fields
    {
        field(90800; "SEW Calc No."; Code[20])
        {
            Caption = 'Calculation No.';
            TableRelation = "SEW Calc Header";
            ToolTip = 'Specifies the calculation number linked to this production order.';
            AllowInCustomizations = AsReadOnly;

            trigger OnValidate()
            var
                CalcHeader: Record "SEW Calc Header";
            begin
                if "SEW Calc No." = '' then begin
                    "SEW Planned Cost" := 0;
                    exit;
                end;

                if CalcHeader.Get("SEW Calc No.") then
                    "SEW Planned Cost" := CalcHeader."Total Cost";
            end;
        }
        field(90801; "SEW Planned Cost"; Decimal)
        {
            Caption = 'Planned Cost';
            Editable = false;
            ToolTip = 'Specifies the planned cost from the pre-calculation.';
            DecimalPlaces = 2 : 5;
            AllowInCustomizations = AsReadOnly;
        }
        field(90802; "SEW Actual Cost to Date"; Decimal)
        {
            Caption = 'Actual Cost to Date';
            FieldClass = FlowField;
            CalcFormula = sum("Capacity Ledger Entry"."Direct Cost" where("Order No." = field("No."), "Order Type" = const(Production)));
            Editable = false;
            ToolTip = 'Specifies the actual costs accumulated to date.';
            DecimalPlaces = 2 : 5;
            AllowInCustomizations = AsReadOnly;
        }
        field(90803; "SEW Cost Variance"; Decimal)
        {
            Caption = 'Cost Variance';
            FieldClass = FlowField;
            CalcFormula = sum("Capacity Ledger Entry"."Direct Cost" where("Order No." = field("No."), "Order Type" = const(Production)));
            Editable = false;
            ToolTip = 'Specifies the variance between planned and actual costs.';
            DecimalPlaces = 2 : 5;
            AllowInCustomizations = AsReadOnly;
        }
        field(90804; "SEW Cost Variance %"; Decimal)
        {
            Caption = 'Cost Variance %';
            Editable = false;
            ToolTip = 'Specifies the cost variance as a percentage of planned cost.';
            DecimalPlaces = 0 : 2;
            AllowInCustomizations = AsReadOnly;
        }
        field(90805; "SEW Alert Threshold %"; Decimal)
        {
            Caption = 'Alert Threshold %';
            ToolTip = 'Specifies the variance threshold for alerts (default 10%).';
            InitValue = 10;
            DecimalPlaces = 0 : 2;
            AllowInCustomizations = AsReadOnly;

            trigger OnValidate()
            begin
                if "SEW Alert Threshold %" < 0 then
                    Error(AlertThresholdErr);
            end;
        }
        field(90806; "SEW Cost Alert"; Boolean)
        {
            Caption = 'Cost Alert';
            Editable = false;
            ToolTip = 'Specifies if actual costs exceed the alert threshold.';
            AllowInCustomizations = AsReadOnly;
        }
    }

    var
        AlertThresholdErr: Label 'Alert threshold cannot be negative';
}
