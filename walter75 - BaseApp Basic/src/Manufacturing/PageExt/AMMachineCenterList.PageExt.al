pageextension 80013 "SEW AM Machine Center List" extends "Machine Center List"
{
    layout
    {
        addafter(Capacity)
        {
            field("SEW No. of Opera. Planned"; Rec."SEW No. of Opera. Planned")
            {
                ApplicationArea = All;
                DrillDownPageId = "SEW Production Operation Lis";
            }
            field("SEW No. of Opera. Firm Plan"; Rec."SEW No. of Opera. Firm Plan")
            {
                ApplicationArea = All;
                DrillDownPageId = "SEW Production Operation Lis";
            }
            field("SEW No. of Opera. Released"; Rec."SEW No. of Opera. Released")
            {
                ApplicationArea = All;
                DrillDownPageId = "SEW Production Operation Lis";
            }
            field("SEW Blocked"; Rec.Blocked)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addafter(Statistics)
        {
            action("SEW Blocked Machines")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Blocked Machines';
                Image = Filter;
                ToolTip = 'Shows Blocked Machines.';
                ShortcutKey = 'Ctrl+G';

                trigger OnAction()
                begin
                    Rec.FilterGroup(100);
                    Rec.SetRange(Blocked, true);
                    Rec.FilterGroup(0);
                end;
            }
            action("SEW Non Blocked Machines")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Non Blocked Machines';
                Image = ClearFilter;
                ToolTip = 'Shows Non Blocked Machines.';
                ShortcutKey = 'Ctrl+B';

                trigger OnAction()
                begin
                    Rec.FilterGroup(100);
                    Rec.SetRange(Blocked, false);
                    Rec.FilterGroup(0);
                end;
            }
        }


        addafter("Ta&sk List_Promoted")
        {
            actionref(SEWBlockedMachines_Promoted; "SEW Blocked Machines")
            {
            }
            actionref(SEWNonBlockedMachines_Promoted; "SEW Non Blocked Machines")
            {
            }
        }
    }

    trigger OnOpenPage()
    begin

        Rec.FilterGroup(100);
        Rec.SetRange(Blocked, false);
        Rec.FilterGroup(0);

    end;
}
