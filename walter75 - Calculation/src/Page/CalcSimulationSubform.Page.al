page 90835 "SEW Calc Simulation Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "SEW Calc Simulation Line";
    Caption = 'Simulation Scenarios';
    Extensible = true;
    AutoSplitKey = true;
    DelayedInsert = true;
    Permissions = tabledata "SEW Calc Simulation Header" = r,
                  tabledata "SEW Calc Header" = r;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Scenario Code"; Rec."Scenario Code")
                {
                }
                field("Lot Size"; Rec."Lot Size")
                {
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
                    Editable = false;
                    Style = Subordinate;
                }
                field("Labor Cost"; Rec."Labor Cost")
                {
                    Editable = false;
                    Style = Subordinate;
                }
                field("Overhead Cost"; Rec."Overhead Cost")
                {
                    Editable = false;
                    Style = Subordinate;
                }
                field("Total Cost"; Rec."Total Cost")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = true;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field("Suggested Sales Price"; Rec."Suggested Sales Price")
                {
                }
                field("Margin %"; Rec."Margin %")
                {
                    Editable = false;
                    Style = Favorable;
                    StyleExpr = Rec."Margin %" > 0;
                }
                field("Break-Even Quantity"; Rec."Break-Even Quantity")
                {
                    Editable = false;
                }
                field("Is Recommended"; Rec."Is Recommended")
                {
                    Editable = false;
                    Style = Favorable;
                    StyleExpr = Rec."Is Recommended";
                }
                field("Recommendation Score"; Rec."Recommendation Score")
                {
                    Editable = false;
                    Visible = false;
                }
            }
        }
    }
}
