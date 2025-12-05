page 90605 "SEW BDE Terminals"
{
    Caption = 'BDE Terminals';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "SEW BDE Terminal";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    
                    DrillDownPageId = "SEW BDE Terminal Card";
                }
                field("Terminal Name"; Rec."Terminal Name")
                {
                    
                }
                field("Allow Fixed User"; Rec."Allow Fixed User")
                {
                    
                }
                field("Allow Malfunction"; Rec."Allow Malfunction")
                {
                    
                }
                field("Allow Call Operator"; Rec."Allow Call Operator")
                {
                    
                }
                field("Days in Advanced"; Rec."Days in Advanced")
                {
                    
                }
                field("Nbr of Centers"; Rec."Nbr of Centers")
                {
                    
                }
                field("Terminal Status"; Rec."Terminal Status")
                {
                    
                }
                field("Current User"; Rec."Current User")
                {
                    
                }
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    
                }
                field("Stop Code Pause"; Rec."Stop Code Pause")
                {
                    
                }
                field("Stop Code Malfunction"; Rec."Stop Code Malfunction")
                {
                    
                }

            }
        }
        area(FactBoxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(TerminalsToRouting)
            {
                Caption = 'assign Terminal to Routing Lines';
                ToolTip = 'assign Terminal to Routing Lines.';
                Image = Tools;
                
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction();
                var
                    SEWBDETerminal: Codeunit "SEW BDE Terminal";
                begin
                    SEWBDETerminal.BDETerminalToRoutingLine();
                end;
            }
        }
    }
}