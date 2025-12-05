pageextension 80001 "SEW AI Item List" extends "Item List"
{
    layout
    {
        addafter("Vendor No.")
        {
            field("SEW Blocked"; Rec.Blocked)
            {
                Visible = false;
                ApplicationArea = All;
                ToolTip = 'Specifies whether the item is blocked.';
            }
            field("SEW Manufacturer Code"; Rec."Manufacturer Code")
            {
                Visible = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the Manufacturer Code.';
            }
        }
    }


    actions
    {
        addafter(CopyItem)
        {
            action("SEW Blocked Items")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Blocked Items';
                Image = Filter;
                ToolTip = 'Shows Blocked Items.';
                ShortcutKey = 'Ctrl+G';

                trigger OnAction()
                begin
                    Rec.FilterGroup(100);
                    Rec.SetRange(Blocked, true);
                    Rec.FilterGroup(0);
                end;
            }
            action("SEW Non Blocked Items")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Non Blocked Items';
                Image = ClearFilter;
                ToolTip = 'Shows Non Blocked Items.';
                ShortcutKey = 'Ctrl+B';

                trigger OnAction()
                begin
                    Rec.FilterGroup(100);
                    Rec.SetRange(Blocked, false);
                    Rec.FilterGroup(0);
                end;
            }
        }


        addafter(CopyItem_Promoted)
        {
            actionref(SEWBlockedItems_Promoted; "SEW Blocked Items")
            {
            }
            actionref(SEWNonBlockedItems_Promoted; "SEW Non Blocked Items")
            {
            }
        }
    }

    views
    {
        // addlast
        // {
        //     view(SEWBlockedItems)
        //     {
        //         Caption = 'Blocked Items';
        //         Filters = where(Blocked = const(true));
        //     }
        //     view(SEWNonBlockedItems)
        //     {
        //         Caption = 'Not Blocked Items';
        //         Filters = where(Blocked = const(false));
        //     }
        // }
    }



    trigger OnOpenPage()
    begin

        Rec.FilterGroup(100);
        Rec.SetRange(Blocked, false);
        Rec.FilterGroup(0);

    end;
}

