page 90606 "SEW BDE Terminals Center"
{
    Caption = 'BDE Terminals Center';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "SEW BDE Terminal Center";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                    
                }
                field(No; Rec."No.")
                {
                    
                }
                field(Name; Rec.Name)
                {
                    
                }
                field("Terminal Code"; Rec."Terminal Code")
                {
                    
                }
                field("Work Center Group Code"; Rec."Work Center Group Code")
                {
                    
                }
                field(Enabled; Rec.Enabled)
                {
                    
                }
                field("Nbr Routings Planned"; Rec."Nbr Routings Planned")
                {
                    
                    trigger OnDrillDown()
                    var
                        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
                    begin
                        ProdOrderRoutingLine.Reset();
                        ProdOrderRoutingLine.SetRange("No.", Rec."No.");
                        ProdOrderRoutingLine.SetRange("Status", "Production Order Status"::"Firm Planned");
                        Page.RunModal(Page::"SEW Routing Lines List", ProdOrderRoutingLine);
                    end;
                }
                field("Nbr Routing Released"; Rec."Nbr Routing Released")
                {
                    
                    trigger OnDrillDown()
                    var
                        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
                    begin
                        ProdOrderRoutingLine.Reset();
                        ProdOrderRoutingLine.SetRange("No.", Rec."No.");
                        ProdOrderRoutingLine.SetRange("Status", "Production Order Status"::Released);
                        Page.RunModal(Page::"SEW Routing Lines List", ProdOrderRoutingLine);
                    end;
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

                trigger OnAction()
                var
                    SEWBDETerminal: Codeunit "SEW BDE Terminal";
                begin
                    SEWBDETerminal.BDETerminalToRoutingLine();
                end;
            }
        }
    }
}