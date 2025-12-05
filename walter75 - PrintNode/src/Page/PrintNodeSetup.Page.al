page 92702 "SEW PrintNode Setup"
{
    Caption = 'PrintNode Setup';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "SEW PrintNode Setup";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("API Key"; Rec."API Key")
                {
                }
                field("PrintNode Base URL"; Rec."PrintNode Base URL")
                {
                }
            }
        }
    }


    actions
    {
        area(Processing)
        {
            action(RefreshPrintNodePrinters)
            {
                Caption = 'Refresh PrintNode Printers';
                ToolTip = 'Refresh the list of available printers from PrintNode.';
                Image = Refresh;
                ApplicationArea = All;

                trigger OnAction()
                var
                    SEWPNRestRequests: Codeunit "SEW PN Rest Requests";
                begin
                    SEWPNRestRequests.GetPrinters()
                end;
            }
            action(setupPrinters)
            {
                Caption = 'Setup Printers';
                ToolTip = 'Setup the printers for sending documents to PrintNode.';
                Image = Setup;
                ApplicationArea = All;

                trigger OnAction()
                var
                    SEWPNRestRequests: Codeunit "SEW PN Rest Requests";
                begin
                    SEWPNRestRequests.GetPrinters()
                end;
            }
            action(openPrintNodePrinters)
            {
                Caption = 'PrintNode Printers';
                ToolTip = 'Open the list of available PrintNode printers.';
                Image = Report;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Page.Run(Page::"SEW PrintNode Printer List");
                end;
            }
            action(openPrinterSelections)
            {
                Caption = 'Printer Selections';
                ToolTip = 'Open the list of printer selections for reports.';
                Image = Report;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Page.Run(Page::"Printer Selections");
                end;
            }
        }
        area(Promoted)
        {
            actionref(RefreshPrintNodePrintersPrm; RefreshPrintNodePrinters) { }
            actionref(setupPrintersPrm; setupPrinters) { }
            actionref(openPrintNodePrintersPrm; openPrintNodePrinters) { }
            actionref(openPrinterSelectionsPrm; openPrinterSelections) { }
        }
    }



    trigger OnOpenPage()
    begin
        Rec.InsertIfNotExists();
    end;
}

