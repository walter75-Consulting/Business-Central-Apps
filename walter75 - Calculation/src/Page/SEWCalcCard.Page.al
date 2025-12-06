page 90831 "SEW Calc Card"
{
    Caption = 'Calculation Card';
    PageType = Document;
    ApplicationArea = All;
    SourceTable = "SEW Calc Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique number for the calculation';

                    trigger OnAssistEdit()
                    var
                        SalesSetup: Record "Sales & Receivables Setup";
                        NoSeriesMgt: Codeunit "No. Series";
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Template Code"; Rec."Template Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the template used for this calculation';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item number for this calculation';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies additional description';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the calculation';
                }
                field("Calculation Date"; Rec."Calculation Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the calculation date';
                }
            }

            group(ProductionInfo)
            {
                Caption = 'Production Information';

                field("Lot Size"; Rec."Lot Size")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the lot size for the calculation';
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the base unit of measure';
                }
                field("Production BOM No."; Rec."Production BOM No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the production BOM number';
                }
                field("Production BOM Version"; Rec."Production BOM Version")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the production BOM version';
                }
                field("Routing No."; Rec."Routing No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the routing number';
                }
                field("Routing Version"; Rec."Routing Version")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the routing version';
                }
            }

            group(Totals)
            {
                Caption = 'Cost Totals';

                field("Total Material Cost"; Rec."Total Material Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total material cost';
                    Style = Strong;
                }
                field("Total Labor Cost"; Rec."Total Labor Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total labor cost';
                    Style = Strong;
                }
                field("Total Overhead Cost"; Rec."Total Overhead Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total overhead cost';
                    Style = Strong;
                }
                field("Total Cost"; Rec."Total Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total cost';
                    Style = StrongAccent;
                }
            }

            group(Pricing)
            {
                Caption = 'Pricing';

                field("Target Sales Price"; Rec."Target Sales Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the target sales price';
                }
                field("Margin %"; Rec."Margin %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the margin percentage';
                }
            }

            part(Lines; "SEW Calc Lines")
            {
                ApplicationArea = All;
                Caption = 'Calculation Lines';
                SubPageLink = "Calc No." = field("No.");
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
                ToolTip = 'Apply the template and calculate costs';
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Message('Template calculation will be implemented in Phase 1.');
                end;
            }

            action(Release)
            {
                ApplicationArea = All;
                Caption = 'Release';
                ToolTip = 'Release the calculation';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Released;
                    Rec.Modify(true);
                    Message('Calculation has been released.');
                end;
            }

            action(Reopen)
            {
                ApplicationArea = All;
                Caption = 'Reopen';
                ToolTip = 'Reopen the calculation for editing';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Draft;
                    Rec.Modify(true);
                    Message('Calculation has been reopened.');
                end;
            }
        }
    }
}
