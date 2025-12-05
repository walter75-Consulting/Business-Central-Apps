pageextension 80008 "SEW AI Item Card" extends "Item Card"
{
    layout
    {
        addafter(Blocked)
        {
            field("SEW Block Reason"; Rec."Block Reason")
            {
                ToolTip = 'Specifies the reason why the item is blocked.';
                ApplicationArea = All;
            }
        }

        modify("Description 2")
        {
            Visible = true;
        }

        modify("Manufacturer Code")
        {
            Visible = true;
        }
    }
}
