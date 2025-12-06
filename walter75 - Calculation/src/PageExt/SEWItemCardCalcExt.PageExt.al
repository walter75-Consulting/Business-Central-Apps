pageextension 90896 "SEW Item Card Calc Ext" extends "Item Card"
{
    layout
    {
        addafter("Costing Method")
        {
            field("SEW Default Template Code"; Rec."SEW Default Template Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the default calculation template for this item.';
            }
            field("SEW Last Calc No."; Rec."SEW Last Calc No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the most recent calculation for this item.';

                trigger OnDrillDown()
                var
                    CalcHeader: Record "SEW Calc Header";
                begin
                    if Rec."SEW Last Calc No." <> '' then begin
                        CalcHeader.Get(Rec."SEW Last Calc No.");
                        Page.Run(Page::"SEW Calc Card", CalcHeader);
                    end;
                end;
            }
        }
    }

    actions
    {
        addafter(Approve)
        {
            group(SEWCalculation)
            {
                Caption = 'Calculation';
                Image = CalculateLines;

                action(SEWNewCalculation)
                {
                    ApplicationArea = All;
                    Caption = 'New Calculation';
                    ToolTip = 'Create a new calculation for this item.';
                    Image = NewDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        CalcHeader: Record "SEW Calc Header";
                    begin
                        CalcHeader.Init();
                        CalcHeader.Insert(true);
                        CalcHeader."Item No." := Rec."No.";
                        CalcHeader.Validate("Item No.");
                        
                        if Rec."SEW Default Template Code" <> '' then
                            CalcHeader."Template Code" := Rec."SEW Default Template Code";
                        
                        CalcHeader.Modify(true);
                        
                        Rec."SEW Last Calc No." := CalcHeader."No.";
                        Rec.Modify(true);
                        
                        Page.Run(Page::"SEW Calc Card", CalcHeader);
                    end;
                }

                action(SEWCalculations)
                {
                    ApplicationArea = All;
                    Caption = 'Calculations';
                    ToolTip = 'Show all calculations for this item.';
                    Image = List;
                    RunObject = page "SEW Calc Headers";
                    RunPageLink = "Item No." = field("No.");
                }

                action(SEWLastCalculation)
                {
                    ApplicationArea = All;
                    Caption = 'Last Calculation';
                    ToolTip = 'Open the most recent calculation for this item.';
                    Image = ShowSelected;
                    Enabled = Rec."SEW Last Calc No." <> '';

                    trigger OnAction()
                    var
                        CalcHeader: Record "SEW Calc Header";
                    begin
                        if Rec."SEW Last Calc No." <> '' then begin
                            CalcHeader.Get(Rec."SEW Last Calc No.");
                            Page.Run(Page::"SEW Calc Card", CalcHeader);
                        end;
                    end;
                }
            }
        }
    }
}
