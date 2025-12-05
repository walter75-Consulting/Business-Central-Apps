tableextension 91600 "SEW Item" extends Item
{
    fields
    {

        field(91600; "SEW Item Color Template"; Boolean)
        {
            Caption = 'Color Template';
            ToolTip = 'Specifies if the item is a color template.';
            DataClassification = CustomerContent;
        }
        field(91601; "SEW Item Color"; Code[10])
        {
            Caption = 'Color Code';
            ToolTip = 'Specifies the color code for the item.';
            DataClassification = CustomerContent;
            TableRelation = "SEW Item Colors";
        }
        field(91602; "SEW Item Color Master"; Code[20])
        {
            Caption = 'Color Master';
            ToolTip = 'Specifies the color master for the item.';
            DataClassification = CustomerContent;
            TableRelation = "Item";
        }

        modify("Replenishment System")
        {
            trigger OnAfterValidate()
            var
                SEWEventTable: Codeunit "SEW Event Table";
            begin
                SEWEventTable.ReplenishmentSystemOnAfterValidate(Rec);
            end;
        }
    }
}