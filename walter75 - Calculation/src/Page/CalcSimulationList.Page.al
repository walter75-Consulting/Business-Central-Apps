page 90834 "SEW Calc Simulation List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "SEW Calc Simulation Header";
    Caption = 'Lot Size Simulations';
    CardPageId = "SEW Calc Simulation Card";
    Editable = false;
    Extensible = true;
    Permissions = tabledata "SEW Calc Header" = r;

    layout
    {
        area(Content)
        {
            repeater(Simulations)
            {
                field("No."; Rec."No.")
                {
                }
                field("Calc No."; Rec."Calc No.")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Simulation Date"; Rec."Simulation Date")
                {
                }
                field("No. of Scenarios"; Rec."No. of Scenarios")
                {
                }
                field("Recommended Scenario Code"; Rec."Recommended Scenario Code")
                {
                    Style = Favorable;
                    StyleExpr = Rec."Recommended Scenario Code" <> '';
                }
                field("Target Sales Price"; Rec."Target Sales Price")
                {
                }
                field("Target Margin %"; Rec."Target Margin %")
                {
                }
            }
        }
        area(FactBoxes)
        {
            part(SimulationFactBox; "SEW Calc Simulation FactBox")
            {
                SubPageLink = "Simulation No." = field("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(OpenCard)
            {
                ApplicationArea = All;
                Caption = 'Open';
                ToolTip = 'Open the simulation card.';
                Image = Card;

                trigger OnAction()
                begin
                    Page.Run(Page::"SEW Calc Simulation Card", Rec);
                end;
            }
            action(OpenCalculation)
            {
                ApplicationArea = All;
                Caption = 'Open Calculation';
                ToolTip = 'Open the source calculation.';
                Image = Card;

                trigger OnAction()
                var
                    CalcHeader: Record "SEW Calc Header";
                begin
                    if CalcHeader.Get(Rec."Calc No.") then
                        Page.Run(Page::"SEW Calc Card", CalcHeader);
                end;
            }
            action("Delete")
            {
                ApplicationArea = All;
                Caption = 'Delete';
                ToolTip = 'Delete this simulation.';
                Image = Delete;

                trigger OnAction()
                var
                    ConfirmManagement: Codeunit "Confirm Management";
                    DeleteSimulationQst: Label 'Delete simulation %1?', Comment = 'DE="Simulation %1 löschen?"';
                begin
                    if ConfirmManagement.GetResponseOrDefault(StrSubstNo(DeleteSimulationQst, Rec."No."), false) then
                        Rec.Delete(true);
                end;
            }
        }

        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(OpenCard_Promoted; OpenCard)
                {
                }
                actionref(Delete_Promoted; "Delete")
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Navigate';

                actionref(OpenCalculation_Promoted; OpenCalculation)
                {
                }
            }
        }
    }
}
