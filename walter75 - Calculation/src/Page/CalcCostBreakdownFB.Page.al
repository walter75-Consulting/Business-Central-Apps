page 90836 "SEW Calc Cost Breakdown FB"
{
    Caption = 'Cost Calculation';
    PageType = CardPart;
    SourceTable = "Sales Line";
    Editable = false;
    ApplicationArea = All;
    Permissions = tabledata "SEW Calc Header" = r;

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
                    Caption = 'Material Cost';
                    ToolTip = 'Specifies the material cost component from the calculation.';
                }

                field("Labor Cost"; LaborCost)
                {
                    Caption = 'Labor Cost';
                    ToolTip = 'Specifies the labor cost component from the calculation.';
                }

                field("Overhead Cost"; OverheadCost)
                {
                    Caption = 'Overhead Cost';
                    ToolTip = 'Specifies the overhead cost component from the calculation.';
                }

                field("Total Cost"; Rec."SEW Calculated Cost")
                {
                    Caption = 'Total Cost';
                    ToolTip = 'Specifies the total calculated cost from the linked calculation.';
                    Style = Strong;
                }
            }

            group(Pricing)
            {
                Caption = 'Pricing Analysis';
                Visible = CalcExists;

                field("Unit Price"; Rec."Unit Price")
                {
                    Caption = 'Unit Price';
                    ToolTip = 'Specifies the unit price for the sales line.';
                }

                field("Target Price"; Rec."SEW Target Price")
                {
                    Style = Attention;
                }

                field("Margin %"; Rec."SEW Calculated Margin %")
                {
                    StyleExpr = MarginStyle;
                }

                field("Target Margin"; TargetMargin)
                {
                    Caption = 'Target Margin %';
                    ToolTip = 'Specifies the target margin percentage for this calculation.';
                    Editable = false;
                }

                field(MarginStatus; MarginStatusText)
                {
                    Caption = 'Margin Status';
                    ToolTip = 'Specifies whether the calculated margin meets the target margin.';
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
        SEWCalcHeader: Record "SEW Calc Header";
    begin
        CalcExists := Rec."SEW Calc No." <> '';

        if CalcExists and SEWCalcHeader.Get(Rec."SEW Calc No.") then begin
            MaterialCost := SEWCalcHeader."Total Material Cost";
            LaborCost := SEWCalcHeader."Total Labor Cost";
            OverheadCost := SEWCalcHeader."Total Overhead Cost";
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
            MarginStatusStyle := Format(PageStyle::Standard);
            MarginStyle := Format(PageStyle::Standard);
            exit;
        end;

        if Rec."SEW Calculated Margin %" >= TargetMargin then begin
            MarginStatusText := '✓ Above Target';
            MarginStatusStyle := Format(PageStyle::Favorable);
            MarginStyle := Format(PageStyle::Favorable);
        end else
            if Rec."SEW Calculated Margin %" >= 15.0 then begin
                MarginStatusText := '⚠ Below Target';
                MarginStatusStyle := Format(PageStyle::Attention);
                MarginStyle := Format(PageStyle::Attention);
            end else begin
                MarginStatusText := '⚠ Critical';
                MarginStatusStyle := Format(PageStyle::Unfavorable);
                MarginStyle := Format(PageStyle::Unfavorable);
            end;

    end;
}
