page 92703 "SEW PrintNode Printer List"
{
    Caption = 'PrintNode Printer List';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "SEW PrintNode Printer";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Printer ID"; Rec."Printer ID")
                {
                }
                field("Printer Name"; Rec."Printer Name")
                {
                }
                field("Printer Computer"; Rec."Printer Computer")
                {
                }
                field("Printer State"; Rec."Printer State")
                {
                }
                field("Printer Default"; Rec."Printer Default")
                {
                }
                field("Default Paper Tray Width"; Rec."Default Paper Tray Width")
                {
                }
                field("Default Paper Tray Height"; Rec."Default Paper Tray Height")
                {
                }
                field("Default Paper Size Code"; Rec."Default Paper Size Code")
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RefreshPrinters)
            {
                Caption = 'Refresh Printers';
                ToolTip = 'Refresh the list of printers from PrintNode service.';
                Image = Refresh;
                ApplicationArea = All;

                trigger OnAction()
                var
                    SEWPNRestRequests: Codeunit "SEW PN Rest Requests";
                begin
                    SEWPNRestRequests.GetPrinters();
                    CurrPage.Update();
                end;
            }
            action(SetDefaultPapersize)
            {
                Caption = 'Set Default Paper Size';
                ToolTip = 'Set the default paper size for the selected printer.';
                Image = PrintReport;
                ApplicationArea = All;

                trigger OnAction()
                var
                    SEWPrintNodePaperSize: Record "SEW PrintNode Paper Size";
                    ConfirmManagement: Codeunit "Confirm Management";
                    Options: Text;
                    SelectedOption: Integer;
                    MenuTextLbl: Label 'How would you like to set the default paper size?';
                    MenuOptionLbl: Label 'Pick from the list of papers.,Remove current default paper size.';
                    DialogDefaultValuesLbl: Label 'Would you like to set the default paper width and height?';
                begin
                    Options := MenuOptionLbl; // Options for the user
                    SelectedOption := Dialog.StrMenu(Options, 1, MenuTextLbl); // Displays the menu with "Save" as the default

                    case SelectedOption of
                        1: // Pick from the list of papers
                            begin
                                SEWPrintNodePaperSize.SetRange("Printer ID", Rec."Printer ID");
                                if Page.RunModal(Page::"SEW PrintNode Paper Size", SEWPrintNodePaperSize) = Action::LookupOK then begin
                                    Rec.Validate("Default Paper Size Code", SEWPrintNodePaperSize.Code);
                                    Rec."Default Paper Tray Height" := SEWPrintNodePaperSize."Paper Height";
                                    Rec."Default Paper Tray Width" := SEWPrintNodePaperSize."Paper Width";
                                    Rec.Modify(false);
                                end;
                            end;
                        2: // Remove current default paper size
                            begin
                                Rec."Default Paper Size Code" := '';
                                if ConfirmManagement.GetResponse(DialogDefaultValuesLbl, true) then begin
                                    Rec."Default Paper Tray Width" := 210;
                                    Rec."Default Paper Tray Height" := 297;
                                end;
                                Rec.Modify(false);
                            end;

                    end;
                end;
            }
        }
        area(Promoted)
        {
            actionref(RefreshPrintersPrm; RefreshPrinters) { }
            actionref(SetDefaultPapersizePrm; SetDefaultPapersize) { }
        }
    }
}
