page 90836 "SEW Calc Cost Breakdown FB"
{
    Caption = 'Cost Calculation';
    PageType = CardPart;
    SourceTable = "Sales Line";
    Editable = false;

    layout
    {
        area(Content)
        {
            group(Calculation)
            {
                Caption = 'Calculation';
                Visible = CalcExists;

                field("SEW Calc No."; Rec."SEW Calc No.")
                {
                    ApplicationArea = All;
                    Caption = 'Calc No.';
                    ToolTip = 'Specifies the calculation number linked to this line';

                    trigger OnDrillDown()
                    var
                        CalcHeader: Record "SEW Calc Header";
                        CalcCard: Page "SEW Calc Card";
                    begin
                        if CalcHeader.Get(Rec."SEW Calc No.") then begin
                            CalcCard.SetRecord(CalcHeader);
                            CalcCard.Run();
                        end;
                    end;
                }
            }

            group(CostBreakdown)
            {
                Caption = 'Cost Breakdown';
                Visible = CalcExists;

                field("Material Cost"; MaterialCost)
                {
                    ApplicationArea = All;
                    Caption = 'Material Cost';
                    ToolTip = 'Specifies the material cost component';
                    StyleExpr = 'Standard';
                }

                field("Labor Cost"; LaborCost)
                {
                    ApplicationArea = All;
                    Caption = 'Labor Cost';
                    ToolTip = 'Specifies the labor cost component';
                    StyleExpr = 'Standard';
                }

                field("Overhead Cost"; OverheadCost)
                {
                    ApplicationArea = All;
                    Caption = 'Overhead Cost';
                    ToolTip = 'Specifies the overhead cost component';
                    StyleExpr = 'Standard';
                }

                field("Total Cost"; Rec."SEW Calculated Cost")
                {
                    ApplicationArea = All;
                    Caption = 'Total Cost';
                    ToolTip = 'Specifies the total calculated cost';
                    Style = Strong;
                }
            }

            group(Pricing)
            {
                Caption = 'Pricing Analysis';
                Visible = CalcExists;

                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Price';
                    ToolTip = 'Specifies the unit price';
                }

                field("Target Price"; Rec."SEW Target Price")
                {
                    ApplicationArea = All;
                    Caption = 'Target Price';
                    ToolTip = 'Specifies the suggested target price';
                    Style = Attention;
                }

                field("Margin %"; Rec."SEW Calculated Margin %")
                {
                    ApplicationArea = All;
                    Caption = 'Margin %';
                    ToolTip = 'Specifies the calculated margin percentage';
                    StyleExpr = MarginStyle;
                }

                field("Target Margin"; TargetMargin)
                {
                    ApplicationArea = All;
                    Caption = 'Target Margin %';
                    ToolTip = 'Specifies the target margin percentage';
                    Editable = false;
                }

                field(MarginStatus; MarginStatusText)
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                    ToolTip = 'Specifies whether the margin meets the target';
                    StyleExpr = MarginStatusStyle;
                    ShowCaption = false;
                }
            }
        }
    }

    var
        MaterialCost: Decimal;
        LaborCost: Decimal;
        OverheadCost: Decimal;
        TargetMargin: Decimal;
        MarginStatusText: Text[50];
        MarginStyle: Text;
        MarginStatusStyle: Text;
        CalcExists: Boolean;

    trigger OnAfterGetRecord()
    begin
        UpdateCostBreakdown();
        UpdateMarginStatus();
    end;

    local procedure UpdateCostBreakdown()
    var
        CalcHeader: Record "SEW Calc Header";
    begin
        CalcExists := Rec."SEW Calc No." <> '';

        if CalcExists and CalcHeader.Get(Rec."SEW Calc No.") then begin
            MaterialCost := CalcHeader."Total Material Cost";
            LaborCost := CalcHeader."Total Labor Cost";
            OverheadCost := CalcHeader."Total Overhead Cost";
        end else begin
            MaterialCost := 0;
            LaborCost := 0;
            OverheadCost := 0;
        end;
    end;

    local procedure UpdateMarginStatus()
    begin
        TargetMargin := 25.0; // Default target margin

        if not CalcExists then begin
            MarginStatusText := 'No calculation';
            MarginStatusStyle := 'Standard';
            MarginStyle := 'Standard';
            exit;
        end;

        if Rec."SEW Calculated Margin %" >= TargetMargin then begin
            MarginStatusText := '✓ Above Target';
            MarginStatusStyle := 'Favorable';
            MarginStyle := 'Favorable';
        end else
            if Rec."SEW Calculated Margin %" >= 15.0 then begin
                MarginStatusText := '⚠ Below Target';
                MarginStatusStyle := 'Attention';
                MarginStyle := 'Attention';
            end else begin
                MarginStatusText := '⚠ Critical';
                MarginStatusStyle := 'Unfavorable';
                MarginStyle := 'Unfavorable';
            end;
    end;
}
