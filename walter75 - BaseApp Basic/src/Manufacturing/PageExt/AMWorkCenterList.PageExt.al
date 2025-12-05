pageextension 80012 "SEW AM Work Center List" extends "Work Center List"
{
    layout
    {
        addafter(Capacity)
        {
            field("SEW No. of Maschine Center"; Rec."SEW No. of Maschine Center")
            {
                ApplicationArea = All;
                DrillDownPageId = "Machine Center List";
            }
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
            action("SEW Blocked Workcenter")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Blocked Workcenter';
                Image = Filter;
                ToolTip = 'Shows Blocked Workcenter.';
                ShortcutKey = 'Ctrl+G';

                trigger OnAction()
                begin
                    Rec.FilterGroup(100);
                    Rec.SetRange(Blocked, true);
                    Rec.FilterGroup(0);
                end;
            }
            action("SEW Non Blocked Workcenter")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Non Blocked Workcenter';
                Image = ClearFilter;
                ToolTip = 'Shows Non Blocked Workcenter.';
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
            actionref(SEWBlockedWorkcenter_Promoted; "SEW Blocked Workcenter")
            {
            }
            actionref(SEWNonBlockedWorkcenters_Promoted; "SEW Non Blocked Workcenter")
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
