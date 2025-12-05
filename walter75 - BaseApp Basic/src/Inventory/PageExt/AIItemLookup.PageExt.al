pageextension 80069 "SEW AI Item Lookup" extends "Item Lookup"
{
    layout
    {
        addafter(Description)
        {
            field("SEW Description 2"; Rec."Description 2")
            {
                ToolTip = 'Specifies a secondary description of the item.';
                ApplicationArea = All;
            }
            field("SEW Inventory"; Rec.Inventory)
            {
                ToolTip = 'Specifies the current inventory level of the item.';
                ApplicationArea = All;
            }
        }
    }
}
