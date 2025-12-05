tableextension 80045 "SEW AS Sales Line" extends "Sales Line"
{
    fields
    {
        field(80300; "SEW Qty in Blanket Order"; Decimal)
        {
            Caption = 'Quantity in Orders';
            ToolTip = 'Shows the total quantity in all orders for this sales order line.';
            BlankZero = true;
            Editable = false;
            FieldClass = FlowField;
            DecimalPlaces = 0 : 5;
            CalcFormula = sum("Sales Line"."Outstanding Qty. (Base)" where("Document Type" = const(Order), "Blanket Order No." = field("Document No."),
                                                                            "Blanket Order Line No." = field("Line No.")));
        }
    }
}
