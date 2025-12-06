report 90885 "SEW Calculation Report"
{
    Caption = 'Calculation Report';
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/SEWCalculationReport.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(CalcHeader; "SEW Calc Header")
        {
            RequestFilterFields = "No.", "Item No.", Status;

            column(CompanyName; CompanyProperty.DisplayName())
            {
            }
            column(CalcNo; "No.")
            {
            }
            column(ItemNo; "Item No.")
            {
            }
            column(Description; Description)
            {
            }
            column(Description2; "Description 2")
            {
            }
            column(Status; Status)
            {
            }
            column(CalculationDate; "Calculation Date")
            {
            }
            column(TemplateCode; "Template Code")
            {
            }
            column(LotSize; "Lot Size")
            {
            }
            column(BaseUnitOfMeasure; "Base Unit of Measure")
            {
            }
            column(ProductionBOMNo; "Production BOM No.")
            {
            }
            column(RoutingNo; "Routing No.")
            {
            }
            column(TotalMaterialCost; "Total Material Cost")
            {
            }
            column(TotalLaborCost; "Total Labor Cost")
            {
            }
            column(TotalOverheadCost; "Total Overhead Cost")
            {
            }
            column(TotalCost; "Total Cost")
            {
            }
            column(TargetSalesPrice; "Target Sales Price")
            {
            }
            column(MarginPercent; "Margin %")
            {
            }

            dataitem(CalcLine; "SEW Calc Line")
            {
                DataItemLink = "Calc No." = field("No.");
                DataItemTableView = sorting("Calc No.", "Line No.");

                column(LineNo; "Line No.")
                {
                }
                column(LineType; Type)
                {
                }
                column(LineDescription; Description)
                {
                }
                column(Indentation; Indentation)
                {
                }
                column(Formula; Formula)
                {
                }
                column(Amount; Amount)
                {
                }
                column(Bold; Bold)
                {
                }
                column(ShowInReport; "Show in Report")
                {
                }
                column(SourceType; "Source Type")
                {
                }
            }
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(ShowFormulas; ShowFormulasVar)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Formulas';
                        ToolTip = 'Specifies whether to show formula details in the report.';
                    }
                    field(ShowOnlyReportLines; ShowOnlyReportLinesVar)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Only Report Lines';
                        ToolTip = 'Specifies whether to show only lines marked for reports.';
                    }
                }
            }
        }
    }

    labels
    {
        ReportTitle = 'Calculation Report';
        CalcNoLabel = 'Calculation No.';
        ItemNoLabel = 'Item No.';
        DescriptionLabel = 'Description';
        StatusLabel = 'Status';
        DateLabel = 'Date';
        TemplateLabel = 'Template';
        LotSizeLabel = 'Lot Size';
        
        CostBreakdownLabel = 'Cost Breakdown';
        MaterialCostLabel = 'Material Cost';
        LaborCostLabel = 'Labor Cost';
        OverheadCostLabel = 'Overhead Cost';
        TotalCostLabel = 'Total Cost';
        
        PricingLabel = 'Pricing';
        TargetPriceLabel = 'Target Sales Price';
        MarginLabel = 'Margin %';
        
        CalculationLinesLabel = 'Calculation Lines';
        LineDescLabel = 'Description';
        FormulaLabel = 'Formula';
        AmountLabel = 'Amount';
    }

    var
        ShowFormulasVar: Boolean;
        ShowOnlyReportLinesVar: Boolean;
}
