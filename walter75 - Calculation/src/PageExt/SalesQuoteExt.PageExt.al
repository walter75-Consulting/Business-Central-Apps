pageextension 90897 "SEW Sales Quote Ext" extends "Sales Quote"
{
    layout
    {
        addafter("Shipping and Billing")
        {
            group("SEW Calculation")
            {
                Caption = 'Calculation';

                field("SEW Default Calc Template"; Rec."SEW Default Calc Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default calculation template to use for all lines in this quote';
                }

                field("SEW Auto Calculate"; Rec."SEW Auto Calculate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether calculations should be created automatically when adding items to lines';
                }
            }
        }
    }

    actions
    {
        addafter("F&unctions")
        {
            group("SEW Calc Actions")
            {
                Caption = 'Calculation';
                Image = Calculate;

                action("SEW Calculate Line")
                {
                    ApplicationArea = All;
                    Caption = 'Calculate Line';
                    ToolTip = 'Create or update calculation for the current line';
                    Image = Calculate;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        SalesLine: Record "Sales Line";
                        CalcIntegrationMgmt: Codeunit "SEW Calc Integration Mgt.";
                    begin
                        CurrPage.SalesLines.Page.GetRecord(SalesLine);
                        CalcIntegrationMgmt.CalculateSalesLinePrice(SalesLine);
                        CurrPage.Update(false);
                    end;
                }

                action("SEW Calculate All Lines")
                {
                    ApplicationArea = All;
                    Caption = 'Calculate All Lines';
                    ToolTip = 'Create or update calculations for all item lines in this quote';
                    Image = CalculateLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        SalesLine: Record "Sales Line";
                        CalcIntegrationMgmt: Codeunit "SEW Calc Integration Mgt.";
                        ProcessedCount: Integer;
                        AllLinesCalculatedMsg: Label '%1 lines have been calculated', Comment = 'DE="%1 Zeilen wurden kalkuliert"';
                    begin
                        SalesLine.SetRange("Document Type", Rec."Document Type");
                        SalesLine.SetRange("Document No.", Rec."No.");
                        SalesLine.SetRange(Type, SalesLine.Type::Item);
                        SalesLine.SetFilter("No.", '<>%1', '');

                        if SalesLine.FindSet() then
                            repeat
                                CalcIntegrationMgmt.CalculateSalesLinePrice(SalesLine);
                                ProcessedCount += 1;
                            until SalesLine.Next() = 0;

                        Message(AllLinesCalculatedMsg, ProcessedCount);
                        CurrPage.Update(false);
                    end;
                }

                action("SEW Open Calculation")
                {
                    ApplicationArea = All;
                    Caption = 'Open Calculation';
                    ToolTip = 'Open the calculation card for the current line';
                    Image = Card;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        SalesLine: Record "Sales Line";
                        CalcHeader: Record "SEW Calc Header";
                        CalcCard: Page "SEW Calc Card";
                        NoCalcLinkedErr: Label 'No calculation is linked to this line', Comment = 'DE="Es ist keine Kalkulation mit dieser Zeile verknüpft"';
                    begin
                        CurrPage.SalesLines.Page.GetRecord(SalesLine);

                        if SalesLine."SEW Calc No." = '' then
                            Error(NoCalcLinkedErr);

                        if CalcHeader.Get(SalesLine."SEW Calc No.") then begin
                            CalcCard.SetRecord(CalcHeader);
                            CalcCard.Run();
                        end;
                    end;
                }
            }
        }
    }
}
