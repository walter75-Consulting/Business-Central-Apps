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

    layout
    {
        area(Content)
        {
            repeater(Simulations)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'Simulation No.';
                    ToolTip = 'Specifies the simulation number';
                }
                field("Calc No."; Rec."Calc No.")
                {
                    ApplicationArea = All;
                    Caption = 'Calculation No.';
                    ToolTip = 'Specifies the calculation this simulation is based on';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Caption = 'Item No.';
                    ToolTip = 'Specifies the item number';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    ToolTip = 'Specifies the description';
                }
                field("Simulation Date"; Rec."Simulation Date")
                {
                    ApplicationArea = All;
                    Caption = 'Simulation Date';
                    ToolTip = 'Specifies when this simulation was created';
                }
                field("No. of Scenarios"; Rec."No. of Scenarios")
                {
                    ApplicationArea = All;
                    Caption = 'No. of Scenarios';
                    ToolTip = 'Specifies the number of scenarios in this simulation';
                }
                field("Recommended Scenario Code"; Rec."Recommended Scenario Code")
                {
                    ApplicationArea = All;
                    Caption = 'Recommended Scenario';
                    ToolTip = 'Specifies the recommended scenario code';
                    Style = Favorable;
                    StyleExpr = Rec."Recommended Scenario Code" <> '';
                }
                field("Target Sales Price"; Rec."Target Sales Price")
                {
                    ApplicationArea = All;
                    Caption = 'Target Sales Price';
                    ToolTip = 'Specifies the target sales price';
                }
                field("Target Margin %"; Rec."Target Margin %")
                {
                    ApplicationArea = All;
                    Caption = 'Target Margin %';
                    ToolTip = 'Specifies the target margin percentage';
                }
            }
        }
        area(FactBoxes)
        {
            part(SimulationFactBox; "SEW Calc Simulation FactBox")
            {
                ApplicationArea = All;
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
                ToolTip = 'Open the simulation card';
                Image = Card;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Page.Run(Page::"SEW Calc Simulation Card", Rec);
                end;
            }
            action(OpenCalculation)
            {
                ApplicationArea = All;
                Caption = 'Open Calculation';
                ToolTip = 'Open the source calculation';
                Image = Card;
                Promoted = true;
                PromotedCategory = Category4;

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
                ToolTip = 'Delete this simulation';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Confirm('Delete simulation %1?', false, Rec."No.") then
                        Rec.Delete(true);
                end;
            }
        }
    }
}
