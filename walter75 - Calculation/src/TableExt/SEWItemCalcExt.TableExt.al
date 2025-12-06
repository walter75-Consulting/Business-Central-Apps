tableextension 90890 "SEW Item Calc Ext" extends Item
{
    fields
    {
        field(90800; "SEW Last Calc No."; Code[20])
        {
            Caption = 'Last Calculation No.';
            ToolTip = 'Specifies the most recent calculation for this item.';
            DataClassification = CustomerContent;
            TableRelation = "SEW Calc Header"."No." where("Item No." = field("No."));
            Editable = false;
        }
        field(90801; "SEW Default Template Code"; Code[20])
        {
            Caption = 'Default Calculation Template';
            ToolTip = 'Specifies the default calculation template for this item.';
            DataClassification = CustomerContent;
            TableRelation = "SEW Calc Template".Code where(Status = const(Released));
        }
    }
}
