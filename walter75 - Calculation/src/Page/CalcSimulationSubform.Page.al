page 90835 "SEW Calc Simulation Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "SEW Calc Simulation Line";
    Caption = 'Simulation Scenarios';
    Extensible = true;
    AutoSplitKey = true;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Scenario Code"; Rec."Scenario Code")
                {
                    ApplicationArea = All;
                    Caption = 'Scenario';
                    ToolTip = 'Specifies the scenario code (e.g., SMALL, MEDIUM, LARGE)';
                }
                field("Lot Size"; Rec."Lot Size")
                {
                    ApplicationArea = All;
                    Caption = 'Lot Size';
                    ToolTip = 'Specifies the production quantity for this scenario';
                    Style = Strong;
                    StyleExpr = true;

                    trigger OnValidate()
                    var
                        CalcHeader: Record "SEW Calc Header";
                        SimHeader: Record "SEW Calc Simulation Header";
                        SimMgt: Codeunit "SEW Calc Simulation Mgt.";
                    begin
                        if SimHeader.Get(Rec."Simulation No.") then
                            if CalcHeader.Get(SimHeader."Calc No.") then begin
                                SimMgt.CalculateScenario(Rec, CalcHeader);
                                CurrPage.Update(false);
                            end;
                    end;
                }
                field("Setup Cost"; Rec."Setup Cost")
                {
                    ApplicationArea = All;
                    Caption = 'Setup Cost';
                    ToolTip = 'Specifies fixed setup costs for this lot size';

                    trigger OnValidate()
                    var
                        CalcHeader: Record "SEW Calc Header";
                        SimHeader: Record "SEW Calc Simulation Header";
                        SimMgt: Codeunit "SEW Calc Simulation Mgt.";
                    begin
                        if SimHeader.Get(Rec."Simulation No.") then
                            if CalcHeader.Get(SimHeader."Calc No.") then begin
                                SimMgt.CalculateScenario(Rec, CalcHeader);
                                CurrPage.Update(false);
                            end;
                    end;
                }
                field("Material Cost"; Rec."Material Cost")
                {
                    ApplicationArea = All;
                    Caption = 'Material Cost';
                    ToolTip = 'Specifies the total material cost for this lot size';
                    Editable = false;
                    Style = Subordinate;
                }
                field("Labor Cost"; Rec."Labor Cost")
                {
                    ApplicationArea = All;
                    Caption = 'Labor Cost';
                    ToolTip = 'Specifies the total labor cost for this lot size';
                    Editable = false;
                    Style = Subordinate;
                }
                field("Overhead Cost"; Rec."Overhead Cost")
                {
                    ApplicationArea = All;
                    Caption = 'Overhead Cost';
                    ToolTip = 'Specifies the total overhead cost for this lot size';
                    Editable = false;
                    Style = Subordinate;
                }
                field("Total Cost"; Rec."Total Cost")
                {
                    ApplicationArea = All;
                    Caption = 'Total Cost';
                    ToolTip = 'Specifies the total cost including setup cost';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = true;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Cost';
                    ToolTip = 'Specifies the cost per unit (Total Cost / Lot Size)';
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field("Suggested Sales Price"; Rec."Suggested Sales Price")
                {
                    ApplicationArea = All;
                    Caption = 'Suggested Sales Price';
                    ToolTip = 'Specifies the suggested sales price based on target margin';
                }
                field("Margin %"; Rec."Margin %")
                {
                    ApplicationArea = All;
                    Caption = 'Margin %';
                    ToolTip = 'Specifies the margin percentage at the suggested sales price';
                    Editable = false;
                    Style = Favorable;
                    StyleExpr = Rec."Margin %" > 0;
                }
                field("Break-Even Quantity"; Rec."Break-Even Quantity")
                {
                    ApplicationArea = All;
                    Caption = 'Break-Even Qty';
                    ToolTip = 'Specifies the quantity needed to break even with setup costs';
                    Editable = false;
                }
                field("Is Recommended"; Rec."Is Recommended")
                {
                    ApplicationArea = All;
                    Caption = 'Recommended';
                    ToolTip = 'Indicates if this is the recommended scenario';
                    Editable = false;
                    Style = Favorable;
                    StyleExpr = Rec."Is Recommended";
                }
                field("Recommendation Score"; Rec."Recommendation Score")
                {
                    ApplicationArea = All;
                    Caption = 'Score';
                    ToolTip = 'Specifies the recommendation score (higher is better)';
                    Editable = false;
                    Visible = false;
                }
            }
        }
    }
}
