page 90831 "SEW Calc Card"
{
    Caption = 'Calculation Card';
    PageType = Document;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "SEW Calc Header";
    Permissions = tabledata "SEW Calc Simulation Header" = i,
                  tabledata "Production Order" = r;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Template Code"; Rec."Template Code")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Description 2"; Rec."Description 2")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Calculation Date"; Rec."Calculation Date")
                {
                }
            }

            group(ProductionInfo)
            {
                Caption = 'Production Information';

                field("Lot Size"; Rec."Lot Size")
                {
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                }
                field("Production BOM No."; Rec."Production BOM No.")
                {
                }
                field("Production BOM Version"; Rec."Production BOM Version")
                {
                }
                field("Routing No."; Rec."Routing No.")
                {
                }
                field("Routing Version"; Rec."Routing Version")
                {
                }
            }

            group(Totals)
            {
                Caption = 'Cost Totals';

                field("Total Material Cost"; Rec."Total Material Cost")
                {
                    Style = Strong;
                }
                field("Total Labor Cost"; Rec."Total Labor Cost")
                {
                    Style = Strong;
                }
                field("Total Overhead Cost"; Rec."Total Overhead Cost")
                {
                    Style = Strong;
                }
                field("Total Cost"; Rec."Total Cost")
                {
                    Style = StrongAccent;
                }
            }

            group(Pricing)
            {
                Caption = 'Pricing';

                field("Target Sales Price"; Rec."Target Sales Price")
                {
                }
                field("Margin %"; Rec."Margin %")
                {
                }
            }

            part(Lines; "SEW Calc Lines")
            {
                Caption = 'Calculation Lines';
                SubPageLink = "Calc No." = field("No.");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CalculateFromTemplate)
            {
                ApplicationArea = All;
                Caption = 'Calculate from Template';
                ToolTip = 'Apply the template and calculate costs.';
                Image = Calculate;

                trigger OnAction()
                var
                    CalcEngine: Codeunit "SEW Calc Engine";
                begin
                    CalcEngine.CalculateFromTemplate(Rec);
                    CurrPage.Update(false);
                end;
            }

            action(Recalculate)
            {
                ApplicationArea = All;
                Caption = 'Recalculate';
                ToolTip = 'Recalculate all formulas and update totals.';
                Image = Refresh;

                trigger OnAction()
                var
                    CalcEngine: Codeunit "SEW Calc Engine";
                begin
                    CalcEngine.Calculate(Rec);
                    CurrPage.Update(false);
                end;
            }

            action(TransferToItem)
            {
                ApplicationArea = All;
                Caption = 'Transfer to Item';
                ToolTip = 'Transfer calculation results to the item card.';
                Image = TransferToLines;
                Enabled = Rec.Status = Rec.Status::Released;

                trigger OnAction()
                var
                    CalcEngine: Codeunit "SEW Calc Engine";
                begin
                    CalcEngine.TransferToItem(Rec);
                end;
            }

            action(Release)
            {
                ApplicationArea = All;
                Caption = 'Release';
                ToolTip = 'Release the calculation.';
                Image = ReleaseDoc;
                Enabled = Rec.Status = Rec.Status::Draft;

                trigger OnAction()
                var
                    CalcEngine: Codeunit "SEW Calc Engine";
                    TemplateManagement: Codeunit "SEW Calc Template Management";
                begin
                    if CalcEngine.ValidateCalculation(Rec) then begin
                        TemplateManagement.ReleaseCalculation(Rec);
                        CurrPage.Update(false);
                    end;
                end;
            }

            action(Reopen)
            {
                ApplicationArea = All;
                Caption = 'Reopen';
                ToolTip = 'Reopen the calculation for editing.';
                Image = ReOpen;
                Enabled = Rec.Status = Rec.Status::Released;

                trigger OnAction()
                var
                    TemplateManagement: Codeunit "SEW Calc Template Management";
                begin
                    TemplateManagement.ReopenCalculation(Rec);
                    CurrPage.Update(false);
                end;
            }

            action(Archive)
            {
                ApplicationArea = All;
                Caption = 'Archive';
                ToolTip = 'Archive this calculation.';
                Image = Archive;
                Enabled = Rec.Status = Rec.Status::Released;

                trigger OnAction()
                var
                    TemplateManagement: Codeunit "SEW Calc Template Management";
                begin
                    TemplateManagement.ArchiveCalculation(Rec);
                    CurrPage.Update(false);
                end;
            }

            action(SimulateLotSizes)
            {
                ApplicationArea = All;
                Caption = 'Simulate Lot Sizes';
                ToolTip = 'Create a new lot size simulation to compare different production quantities.';
                Image = Worksheet;
                Enabled = Rec.Status = Rec.Status::Released;

                trigger OnAction()
                var
                    SimHeader: Record "SEW Calc Simulation Header";
                    SimCard: Page "SEW Calc Simulation Card";
                begin
                    SimHeader.Init();
                    SimHeader."Calc No." := Rec."No.";
                    SimHeader.Validate("Calc No.");
                    SimHeader.Insert(true);

                    SimCard.SetRecord(SimHeader);
                    SimCard.Run();
                end;
            }

            action(ExportToExcel)
            {
                ApplicationArea = All;
                Caption = 'Export to Excel';
                ToolTip = 'Export this calculation to an Excel file.';
                Image = ExportToExcel;

                trigger OnAction()
                var
                    ExportMgt: Codeunit "SEW Calc Export Management";
                begin
                    ExportMgt.ExportCalculationToExcel(Rec."No.");
                end;
            }

            action(ShowHistory)
            {
                ApplicationArea = All;
                Caption = 'Show History';
                ToolTip = 'View the history of changes for this calculation.';
                Image = History;

                trigger OnAction()
                var
                    CalcHistory: Record "SEW Calc History Entry";
                    HistoryPage: Page "SEW Calc History List";
                begin
                    CalcHistory.SetRange("Calculation No.", Rec."No.");
                    HistoryPage.SetTableView(CalcHistory);
                    HistoryPage.Run();
                end;
            }

            action(CreatePostCalc)
            {
                ApplicationArea = All;
                Caption = 'Create Post-Calculation';
                ToolTip = 'Create a post-calculation from a finished production order.';
                Image = PostDocument;

                trigger OnAction()
                var
                    ProdOrder: Record "Production Order";
                    PostCalc: Codeunit "SEW Calc Post-Calculation";
                    ProdOrderNo: Code[20];
                    NewCalcNo: Code[20];
                begin
                    // Find production orders linked to this calculation
                    ProdOrder.SetRange("SEW Calc No.", Rec."No.");
                    ProdOrder.SetRange(Status, ProdOrder.Status::Finished);
                    if ProdOrder.FindFirst() then
                        ProdOrderNo := ProdOrder."No."
                    else begin
                        Message('No finished production order found linked to this calculation');
                        exit;
                    end;

                    NewCalcNo := PostCalc.CreatePostCalc(ProdOrderNo);
                    if NewCalcNo <> '' then begin
                        Rec.Get(NewCalcNo);
                        CurrPage.Update(false);
                    end;
                end;
            }
        }

        area(Reporting)
        {
            action(PrintCalculation)
            {
                ApplicationArea = All;
                Caption = 'Print Calculation';
                ToolTip = 'Print the calculation report.';
                Image = Print;

                trigger OnAction()
                var
                    CalcHeader: Record "SEW Calc Header";
                begin
                    CalcHeader.SetRange("No.", Rec."No.");
                    Report.Run(Report::"SEW Calculation Report", true, false, CalcHeader);
                end;
            }
        }

        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(CalculateFromTemplate_Promoted; CalculateFromTemplate)
                {
                }
                actionref(Recalculate_Promoted; Recalculate)
                {
                }
                actionref(TransferToItem_Promoted; TransferToItem)
                {
                }
                actionref(Release_Promoted; Release)
                {
                }
                actionref(Reopen_Promoted; Reopen)
                {
                }
                actionref(Archive_Promoted; Archive)
                {
                }
                actionref(SimulateLotSizes_Promoted; SimulateLotSizes)
                {
                }
                actionref(ExportToExcel_Promoted; ExportToExcel)
                {
                }
                actionref(CreatePostCalc_Promoted; CreatePostCalc)
                {
                }
            }
            group(Category_Report)
            {
                Caption = 'Report';

                actionref(PrintCalculation_Promoted; PrintCalculation)
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Navigate';

                actionref(ShowHistory_Promoted; ShowHistory)
                {
                }
            }
        }
    }
}
