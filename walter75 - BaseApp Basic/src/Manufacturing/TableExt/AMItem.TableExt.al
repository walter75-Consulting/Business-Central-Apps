tableextension 80003 "SEW AM Item" extends Item
{
    fields
    {
        field(80001; "SEW Date last Production"; Date)
        {
            Caption = 'Date last Production';
            ToolTip = 'Specifies the last Production Date.';
            FieldClass = FlowField;
            CalcFormula = max("Prod. Order Line"."Due Date" where("Item No." = field("No.")));
            Editable = false;
            AllowInCustomizations = Never;
        }

        modify("Replenishment System")
        {
            trigger OnAfterValidate()
            var
                SEWMAMActionsTable: Codeunit "SEW AM Actions Table";
            begin
                case "Replenishment System" of
                    "Replenishment System"::"Prod. Order":
                        begin
                            if SEWMAMActionsTable.CheckItemBOMHeader(Rec) then
                                Rec."Production BOM No." := Rec."No.";

                            if SEWMAMActionsTable.CheckItemRoutingHeader(Rec) then
                                Rec."Routing No." := Rec."No.";
                        end;
                end;
            end;
        }

    }
}
