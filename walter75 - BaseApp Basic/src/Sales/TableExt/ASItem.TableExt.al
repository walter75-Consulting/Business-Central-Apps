tableextension 80042 "SEW AS Item" extends Item
{
    fields
    {
        field(80000; "SEW Auto-Explode AssemblyBOM"; Boolean)
        {
            Caption = 'Auto-Explode BOM';
            ToolTip = 'Specifies whether the assembly BOM should be auto-exploded when the item is added to a production order.';
            DataClassification = CustomerContent;
        }
        field(80002; "SEW Date last Invoice"; Date)
        {
            Caption = 'Date last Invoice';
            ToolTip = 'Specifies the last Sales Invoice Date.';
            FieldClass = FlowField;
            CalcFormula = max("Sales Invoice Line"."Posting Date" where("Type" = const("Sales Line Type"::Item), "No." = field("No.")));
            Editable = false;
            AllowInCustomizations = Never;
        }



    }
}
