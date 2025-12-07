page 90841 "SEW Calc Activities"
{
    Caption = 'Calculation Activities';
    PageType = CardPart;
    SourceTable = "SEW Calc Cue";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            cuegroup(Calculations)
            {
                Caption = 'Calculations';

                field("Draft Count"; Rec."Draft Count")
                {
                    ApplicationArea = All;
                    Caption = 'Draft';
                    ToolTip = 'Specifies the number of draft calculations';
                    DrillDownPageId = "SEW Calc Headers";

                    trigger OnDrillDown()
                    var
                        CalcHeader: Record "SEW Calc Header";
                    begin
                        CalcHeader.SetRange(Status, CalcHeader.Status::Draft);
                        Page.Run(Page::"SEW Calc Headers", CalcHeader);
                    end;
                }

                field("Released Count"; Rec."Released Count")
                {
                    ApplicationArea = All;
                    Caption = 'Released';
                    ToolTip = 'Specifies the number of released calculations';
                    DrillDownPageId = "SEW Calc Headers";

                    trigger OnDrillDown()
                    var
                        CalcHeader: Record "SEW Calc Header";
                    begin
                        CalcHeader.SetRange(Status, CalcHeader.Status::Released);
                        Page.Run(Page::"SEW Calc Headers", CalcHeader);
                    end;
                }

                field("Archived Count"; Rec."Archived Count")
                {
                    ApplicationArea = All;
                    Caption = 'Archived';
                    ToolTip = 'Specifies the number of archived calculations';
                    DrillDownPageId = "SEW Calc Headers";

                    trigger OnDrillDown()
                    var
                        CalcHeader: Record "SEW Calc Header";
                    begin
                        CalcHeader.SetRange(Status, CalcHeader.Status::Archived);
                        Page.Run(Page::"SEW Calc Headers", CalcHeader);
                    end;
                }

                field("Warning Count"; Rec."Warning Count")
                {
                    ApplicationArea = All;
                    Caption = 'Low Margin Warnings';
                    ToolTip = 'Specifies the number of calculations with margin below 15%';
                    Style = Unfavorable;
                    StyleExpr = Rec."Warning Count" > 0;
                    DrillDownPageId = "SEW Calc Headers";

                    trigger OnDrillDown()
                    var
                        CalcHeader: Record "SEW Calc Header";
                    begin
                        CalcHeader.SetFilter(Status, '%1|%2', CalcHeader.Status::Draft, CalcHeader.Status::Released);
                        CalcHeader.SetFilter("Margin %", '< 15');
                        Page.Run(Page::"SEW Calc Headers", CalcHeader);
                    end;
                }
            }

            cuegroup(Performance)
            {
                Caption = 'Performance';

                field("Average Margin %"; Rec."Average Margin %")
                {
                    ApplicationArea = All;
                    Caption = 'Avg. Margin %';
                    ToolTip = 'Specifies the average margin percentage of released calculations';
                    Style = Favorable;
                    StyleExpr = Rec."Average Margin %" >= 15;
                    DecimalPlaces = 2 : 2;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec."Primary Key" := '';
            Rec.Insert();
        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        Rec.CalcFields("Draft Count", "Released Count", "Archived Count", "Warning Count", "Average Margin %");
    end;
}
