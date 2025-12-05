page 60502 "SEW XML Fileimport"
{
    Caption = 'XML Fileimport List';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "SEW XML Fileimport";
    InsertAllowed = false;
    Permissions = tabledata "SEW XML Fileimport" = rimd,
                  tabledata "SEW XML Fileimport Line" = rimd,
                  tabledata "SEW XML Fileimport Address" = rimd,
                  tabledata "SEW XML Fileimport Cost" = rimd;


    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                FreezeColumn = "Purch. Order No.";

                field("Doc No."; Rec."Doc No.")
                {
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"SEW XML Fileimport Card", Rec);
                    end;
                }
                field(transferID; Rec.transferID)
                {
                    Visible = false;
                    Editable = false;
                }
                field("Doc Type"; Rec."Doc Type") { }
                field("Doc Status"; Rec."Doc Status") { }



                field("Count of Lines"; Rec."Count of Lines") { }
                field("Doc Count of Lines"; Rec."Doc Count of Lines") { }
                field("Purch. Order No."; Rec."Purch. Order No.") { }
                field("Purch. Order Date"; Rec."Purch. Order Date") { }
                field("Ext. Sales Order No."; Rec."Ext. Sales Order No.") { }
                field("Ext. Sales Order Date"; Rec."Ext. Sales Order Date") { }
                field("Ext. Shipment No."; Rec."Ext. Shipment No.") { }
                field("Ext. Shipment Date"; Rec."Ext. Shipment Date") { }
                field("Ext. Invoice No."; Rec."Ext. Invoice No.") { }
                field("Ext. Invoice Date"; Rec."Ext. Invoice Date") { }
                field("Faktura Type"; Rec."Faktura Type") { }
                field("Faktura Type2"; Rec."Faktura Type2") { }

                field("Partner AG"; Rec."Partner AG") { }
                field("Partner WE"; Rec."Partner WE") { }
                field("Partner ZK"; Rec."Partner ZK") { }
                field("Partner OSP"; Rec."Partner OSP") { }
                field("Partner OSO"; Rec."Partner OSO") { }
                field("Partner BK"; Rec."Partner BK") { }
                field("Partner RG"; Rec."Partner RG") { }
                field("Partner RE"; Rec."Partner RE") { }
                field("Partner RS"; Rec."Partner RS") { }
                field("Cost Amount"; Rec."Cost Amount") { }
                field("Line Amount"; Rec."Line Amount") { }
                field("Calculated Doc Amount"; CalculatedDocuAmount)
                {
                    Caption = 'Total Amount';
                    ToolTip = 'Specifies the total amount including line amounts and cost amounts.';
                    AutoFormatType = 1;
                    Editable = false;
                }
                field("Doc Amount net"; Rec."Doc Amount net")
                {
                    StyleExpr = StyleExprTxt;
                }
                field("Doc Currency"; Rec."Doc Currency") { }

                field("Transfer Date/Time"; Rec."Transfer Date/Time") { }
                field("Doc Creation Date"; Rec."Doc Creation Date") { }
                field("Doc Creation Time"; Rec."Doc Creation Time") { }
                field("Doc Processed Date/Time"; Rec."Doc Processed Date/Time") { }
                field("Doc Imported"; Rec."Doc Imported") { }
            }
        }

        area(FactBoxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            fileuploadaction(UploadDESAVFile)
            {
                Caption = 'Upload DESAV Files';
                ToolTip = 'Upload a DESAV XML files from your local system.';
                ApplicationArea = All;
                Image = Import;
                AllowMultipleFiles = true;

                trigger OnAction(files: List of [FileUpload])
                var
                    FileManagement: Codeunit "File Management";
                    xlInStream: InStream;
                    xlOutStream: OutStream;
                    CurrentFile: FileUpload;
                    FileName: Text;

                begin
                    FileName := '';
                    foreach CurrentFile in files do begin
                        CurrentFile.CreateInStream(xlInStream, TextEncoding::UTF8);
                        FileName := FileManagement.GetFileNameWithoutExtension(CurrentFile.FileName());
                        Rec.Init();
                        Rec.FileContentBlob.CreateOutStream(xlOutStream, TextEncoding::UTF8);
                        CopyStream(xlOutStream, xlInStream);
                        Rec."Doc Type" := "SEW Transfer Type"::"Delivery Note";
                        Rec."Doc Status" := "SEW Transfer Status"::"File Received";
                        Rec.Insert(true);
                    end;
                end;
            }
            fileuploadaction(UploadINVOICFile)
            {
                Caption = 'Upload INVOIC Files';
                ToolTip = 'Upload INVOIC XML files from your local system.';
                ApplicationArea = All;
                Image = Import;


                trigger OnAction(files: List of [FileUpload])
                var
                    FileManagement: Codeunit "File Management";
                    xlInStream: InStream;
                    xlOutStream: OutStream;
                    CurrentFile: FileUpload;
                    FileName: Text;

                begin
                    FileName := '';
                    foreach CurrentFile in files do begin
                        CurrentFile.CreateInStream(xlInStream, TextEncoding::UTF8);
                        FileName := FileManagement.GetFileNameWithoutExtension(CurrentFile.FileName());
                        Rec.Init();
                        Rec.FileContentBlob.CreateOutStream(xlOutStream, TextEncoding::UTF8);
                        CopyStream(xlOutStream, xlInStream);
                        Rec."Doc Type" := "SEW Transfer Type"::Invoice;
                        Rec."Doc Status" := "SEW Transfer Status"::"File Received";
                        Rec.Insert(true);
                    end;
                end;
            }
            action(ProcessFile)
            {
                Caption = 'Process Files';
                ToolTip = 'Process the uploaded XML files.';
                ApplicationArea = All;
                Image = Process;

                trigger OnAction()
                var
                    SEWFiletransfer: Record "SEW XML Fileimport";
                    SEWFiletransferMgt: Codeunit "SEW XML Fileimport Proc";
                    Progress: Dialog;
                    Text000Lbl: Label 'Processing Record #1 from #2', Comment = '%1: Current Record, %2: Total Records';
                    CountRec: Integer;
                    CountCurr: Integer;
                begin
                    Clear(SEWFiletransfer);
                    SEWFiletransfer.Reset();
                    CurrPage.SetSelectionFilter(SEWFiletransfer);


                    if SEWFiletransfer.FindSet(true) then begin
                        CountRec := SEWFiletransfer.Count();
                        CountCurr := 0;
                        Progress.Open(Text000Lbl, CountCurr, CountRec);
                        repeat
                            if SEWFiletransfer."Doc Status" = "SEW Transfer Status"::"File Received" then
                                SEWFiletransferMgt.ProcessRecord(SEWFiletransfer);

                            CountCurr += 1;
                            Progress.Update();
                        until SEWFiletransfer.Next() = 0;
                        Progress.Close();
                    end;

                    CurrPage.Update();
                end;
            }
        }
        area(Navigation)
        {
            action(ShowLog)
            {
                Caption = 'Activity Log';
                ToolTip = 'Show the activity log for the selected file transfer.';
                ApplicationArea = All;
                Image = Log;
                trigger OnAction()
                var
                    ActivityLog: record "Activity Log";
                begin
                    ActivityLog.ShowEntries(Rec.RecordId());
                end;
            }
            action(ShowLines)
            {
                Caption = 'All Lines';
                ToolTip = 'Show all lines created by the file transfer.';
                ApplicationArea = All;
                Image = View;
                trigger OnAction()
                begin
                    Page.Run(Page::"SEW XML Fileimport Line");
                end;
            }
            action(ShowCostLines)
            {
                Caption = 'All Cost Lines';
                ToolTip = 'Show all cost lines created by the file transfer.';
                ApplicationArea = All;
                Image = View;
                trigger OnAction()
                begin
                    Page.Run(Page::"SEW XML Fileimport Cost");
                end;
            }

            action(ShowAddresses)
            {
                Caption = 'All Addresses';
                ToolTip = 'Show all addresses created by the file transfer.';
                ApplicationArea = All;
                Image = View;
                trigger OnAction()
                begin
                    Page.Run(Page::"SEW XML Fileimport Address");
                end;
            }
            action(ClearFile)
            {
                Caption = 'Clear Files';
                ToolTip = 'Clear the uploaded XML files.';
                ApplicationArea = All;
                Image = ClearLog;

                trigger OnAction()
                var
                    SEWFiletransfer: Record "SEW XML Fileimport";
                    SEWXMLFileimportLine: Record "SEW XML Fileimport Line";
                    SEWXMLFileimportCost: Record "SEW XML Fileimport Cost";
                    Progress: Dialog;
                    Text000Lbl: Label 'Processing Record #1 from #2', Comment = '%1: Current Record, %2: Total Records';
                    CountRec: Integer;
                    CountCurr: Integer;
                begin
                    Clear(SEWFiletransfer);
                    SEWFiletransfer.Reset();
                    CurrPage.SetSelectionFilter(SEWFiletransfer);


                    if SEWFiletransfer.FindSet(true) then begin
                        CountRec := SEWFiletransfer.Count();
                        CountCurr := 0;
                        Progress.Open(Text000Lbl, CountCurr, CountRec);
                        repeat

                            SEWXMLFileimportLine.Reset();
                            SEWXMLFileimportLine.SetRange(transferID, SEWFiletransfer.transferID);
                            if SEWXMLFileimportLine.FindSet(true) then
                                SEWXMLFileimportLine.DeleteAll(false);

                            SEWXMLFileimportCost.Reset();
                            SEWXMLFileimportCost.SetRange(transferID, SEWFiletransfer.transferID);
                            if SEWXMLFileimportCost.FindSet(true) then
                                SEWXMLFileimportCost.DeleteAll(false);

                            SEWFiletransfer."Doc Status" := "SEW Transfer Status"::"File Received";
                            SEWFiletransfer."Doc No." := '';
                            SEWFiletransfer.Modify(false);

                            CountCurr += 1;
                            Progress.Update();
                        until SEWFiletransfer.Next() = 0;
                        Progress.Close();
                    end;

                    CurrPage.Update();
                end;
            }
        }

        area(Promoted)
        {
            actionref(UploadDESAVFilePmtd; UploadDESAVFile) { }
            actionref(UploadINVOICFilePmtd; UploadINVOICFile) { }
            actionref(ProcessFilePmtd; ProcessFile) { }
            actionref(ShowLinesPmtd; ShowLines) { }
            actionref(ShowAddressesPmtd; ShowAddresses) { }
            actionref(ShowCostLinesPmtd; ShowCostLines) { }
        }

        // group(Special)
        // {
        //     Caption = 'Special';
        // action(ImportOld)
        // {
        //     Caption = 'Import Old FT';
        //     ToolTip = 'Show the addresses for the selected file transfer.';
        //     ApplicationArea = All;
        //     Image = View;
        //     trigger OnAction()
        //     var
        //         SEWFiletransfer: Record "SEW Filetransfer";
        //         SEWFiletransferNEW: Record "SEW Filetransfer NEW";
        //         xlInStream: InStream;
        //         xlOutStream: OutStream;
        //     begin
        //         if SEWFiletransfer.FindSet() then
        //             repeat
        //                 Clear(xlInStream);
        //                 Clear(xlOutStream);
        //                 Clear(SEWFiletransferNEW);
        //                 SEWFiletransferNEW.Init();
        //                 SEWFiletransfer.CalcFields(FileContentBlob);
        //                 SEWFiletransfer.FileContentBlob.CreateInStream(xlInStream);
        //                 SEWFiletransferNEW.FileContentBlob.CreateOutStream(xlOutStream);
        //                 CopyStream(xlOutStream, xlInStream);
        //                 SEWFiletransferNEW."Transfer Date/Time" := SEWFiletransfer."Transfer Date/Time";
        //                 if SEWFiletransfer."Transfer Typ" = "SEW Transfertyp"::"Delivery Note" then
        //                     SEWFiletransferNEW."Doc Typ" := "SEW Transfer Type"::"Delivery Note";
        //                 if SEWFiletransfer."Transfer Typ" = "SEW Transfertyp"::"Invoice" then
        //                     SEWFiletransferNEW."Doc Typ" := "SEW Transfer Type"::"Invoice";
        //                 SEWFiletransferNEW."Doc Status" := "SEW Transfer Status"::"File Received";
        //                 SEWFiletransferNEW.Insert(true);
        //             until SEWFiletransfer.Next() = 0;
        //     end;
        // }
        // action(ImportSuperSHI)
        // {
        //     Caption = 'Import Super Old Ship';
        //     ToolTip = 'Show the addresses for the selected file transfer.';
        //     ApplicationArea = All;
        //     Image = View;
        //     trigger OnAction()
        //     var
        //         InterfaceImportTable: Record "SEW Interface Import Table";
        //         SEWFiletransferNEW: Record "SEW XML Fileimport";
        //         xtransferID: Integer;
        //         Progress: Dialog;
        //         Text000Lbl: Label 'Processing Record #1 from #2', Comment = '%1: Current Record, %2: Total Records';
        //         CountRec: Integer;
        //         CountCurr: Integer;
        //     begin
        //         InterfaceImportTable.Reset();
        //         InterfaceImportTable.SetRange(DocType, InterfaceImportTable.DocType::Shipment);
        //         if InterfaceImportTable.FindSet() then begin
        //             CountRec := InterfaceImportTable.Count();
        //             CountCurr := 0;
        //             Progress.Open(Text000Lbl, CountCurr, CountRec);
        //             repeat
        //                 xtransferID := 0;
        //                 SEWFiletransferNEW.Reset();
        //                 SEWFiletransferNEW.SetRange("Doc Type", "SEW Transfer Type"::"Delivery Note");
        //                 SEWFiletransferNEW.SetRange("Ext. Shipment No.", InterfaceImportTable.ExtDocNo);
        //                 if not SEWFiletransferNEW.FindFirst() then
        //                     xtransferID := InsertInterfaceImportHead(InterfaceImportTable);

        //                 if xtransferID = 0 then
        //                     xtransferID := SEWFiletransferNEW.transferID;

        //                 if xtransferID = 0 then
        //                     Error('Problems...');

        //                 if xtransferID <> 0 then
        //                     InsertInterfaceImportLine(InterfaceImportTable, xtransferID);

        //                 Commit(); //so far so good...
        //                 CountCurr += 1;
        //                 Progress.Update();

        //             until InterfaceImportTable.Next() = 0;
        //         end;
        //     end;
        // }
        // action(ImportSuperINV)
        // {
        //     Caption = 'Import Super Old INVO';
        //     ToolTip = 'Show the addresses for the selected file transfer.';
        //     ApplicationArea = All;
        //     Image = View;
        //     trigger OnAction()
        //     var
        //         InterfaceImportTable: Record "SEW Interface Import Table";
        //         SEWFiletransferNEW: Record "SEW XML Fileimport";
        //         xtransferID: Integer;
        //         Progress: Dialog;
        //         Text000Lbl: Label 'Processing Record #1 from #2', Comment = '%1: Current Record, %2: Total Records';
        //         CountRec: Integer;
        //         CountCurr: Integer;
        //     begin
        //         InterfaceImportTable.Reset();
        //         InterfaceImportTable.SetRange(DocType, InterfaceImportTable.DocType::Invoice);
        //         if InterfaceImportTable.FindSet() then begin
        //             CountRec := InterfaceImportTable.Count();
        //             CountCurr := 0;
        //             Progress.Open(Text000Lbl, CountCurr, CountRec);
        //             repeat
        //                 xtransferID := 0;
        //                 SEWFiletransferNEW.Reset();
        //                 SEWFiletransferNEW.SetRange("Doc Typ", "SEW Transfer Type"::Invoice);
        //                 SEWFiletransferNEW.SetRange("Ext. Invoice No.", InterfaceImportTable.ExtDocNo);
        //                 if not SEWFiletransferNEW.FindFirst() then
        //                     xtransferID := InsertInterfaceImportHead(InterfaceImportTable);

        //                 if xtransferID = 0 then
        //                     xtransferID := SEWFiletransferNEW.transferID;

        //                 if xtransferID = 0 then
        //                     Error('Problems...');

        //                 if xtransferID <> 0 then
        //                     InsertInterfaceImportLine(InterfaceImportTable, xtransferID);

        //                 Commit(); //so far so good...
        //                 CountCurr += 1;
        //                 Progress.Update();

        //             until InterfaceImportTable.Next() = 0;
        //         end;
        //     end;
        // }
        //         }
        //     }
        // }

        // local procedure InsertInterfaceImportHead(SEWInterfaceImportTable: Record "SEW Interface Import Table"): Integer
        // var
        //     SEWXMLFileimport: Record "SEW XML Fileimport";
        // begin
        //     SEWXMLFileimport.Init();

        //     SEWXMLFileimport."Doc Status" := "SEW Transfer Status"::"File Processed";
        //     SEWXMLFileimport."Doc No." := SEWInterfaceImportTable.ExtDocNo;
        //     SEWXMLFileimport."Purch. Order No." := SEWInterfaceImportTable.DocNo;
        //     SEWXMLFileimport."Ext. Sales Order No." := SEWInterfaceImportTable.OrderNo;
        //     SEWXMLFileimport.Processed := SEWInterfaceImportTable.Processed;
        //     SEWXMLFileimport."Doc Creation Date" := SEWInterfaceImportTable.CreationDate;
        //     SEWXMLFileimport."Doc Creation Time" := SEWInterfaceImportTable.CreationTime;

        //     if SEWInterfaceImportTable.DocType = SEWInterfaceImportTable.DocType::Shipment then begin
        //         SEWXMLFileimport."Doc Type" := "SEW Transfer Type"::"Delivery Note";
        //         SEWXMLFileimport."Ext. Shipment No." := SEWInterfaceImportTable.ExtDocNo;
        //     end;

        //     if SEWInterfaceImportTable.DocType = SEWInterfaceImportTable.DocType::Invoice then begin
        //         SEWXMLFileimport."Doc Type" := "SEW Transfer Type"::Invoice;
        //         SEWXMLFileimport."Ext. Invoice No." := SEWInterfaceImportTable.ExtDocNo;
        //     end;


        //     SEWXMLFileimport.Insert(true);

        //     exit(SEWXMLFileimport.transferID);

        // end;

        // local procedure InsertInterfaceImportLine(SEWInterfaceImportTable: Record "SEW Interface Import Table"; xTransferID: Integer)
        // var
        //     SEWXMLFileimportLine: Record "SEW XML Fileimport Line";
        // begin
        //     SEWXMLFileimportLine.Init();
        //     SEWXMLFileimportLine.id := SEWXMLFileimportLine.GetLastEntryNo() + 1;
        //     SEWXMLFileimportLine.transferID := xTransferID;
        //     SEWXMLFileimportLine.MATNR := SEWInterfaceImportTable.VendItemNo;
        //     SEWXMLFileimportLine.KDMAT := SEWInterfaceImportTable.ItemNo;
        //     SEWXMLFileimportLine."Ext. Sales Order Qty" := SEWInterfaceImportTable.DocQuantity;
        //     SEWXMLFileimportLine."Unit of Measure" := SEWInterfaceImportTable.UOM;
        //     SEWXMLFileimportLine."Purch. Order No." := SEWInterfaceImportTable.OrderNo;
        //     SEWXMLFileimportLine."Purch. Order Line No." := SEWInterfaceImportTable.OrderPosNo;
        //     SEWXMLFileimportLine."Purch. Order No." := SEWInterfaceImportTable.DocNo;
        //     SEWXMLFileimportLine."Purch. Order Line No." := SEWInterfaceImportTable.OrderPosNo;
        //     SEWXMLFileimportLine."Ext. Sales Order No." := SEWInterfaceImportTable.OrderNo;
        //     SEWXMLFileimportLine."Ext. Sales Order Line No." := SEWInterfaceImportTable.OrderPosNo;
        //     SEWXMLFileimportLine."Unit Cost" := SEWInterfaceImportTable.UnitCost;


        //     if SEWInterfaceImportTable.DocType = SEWInterfaceImportTable.DocType::Shipment then begin
        //         SEWXMLFileimportLine."Ext. Shipment Qty" := SEWInterfaceImportTable.DocQuantity;
        //         SEWXMLFileimportLine."Ext. Shipment No." := SEWInterfaceImportTable.ExtDocNo;
        //         SEWXMLFileimportLine."Ext. Shipment Line No." := SEWInterfaceImportTable.OrderPosNo;
        //     end;
        //     if SEWInterfaceImportTable.DocType = SEWInterfaceImportTable.DocType::Invoice then begin
        //         SEWXMLFileimportLine."Ext. Invoice Qty" := SEWInterfaceImportTable.DocQuantity;
        //         SEWXMLFileimportLine."Ext. Invoice No." := SEWInterfaceImportTable.ExtDocNo;
        //         SEWXMLFileimportLine."Ext. Invoice Line No." := SEWInterfaceImportTable.OrderPosNo;
        //     end;

        //     SEWXMLFileimportLine.Insert(false);
        //end;



    }



    trigger OnAfterGetRecord()
    begin

        CalculatedDocuAmount := 0;
        StyleExprTxt := '';

        // Just to make sure that the FlowField is calculated
        if Rec."Doc Type" = Rec."Doc Type"::Invoice then begin
            Rec.SetAutoCalcFields("Cost Amount", "Line Amount");
            CalculatedDocuAmount := Rec."Cost Amount" + Rec."Line Amount";

            StyleExprTxt := '';
            if Round(Rec."Doc Amount net", 0.01) <> Round(CalculatedDocuAmount, 0.01) then
                StyleExprTxt := Format(PageStyle::Attention)
            else
                StyleExprTxt := Format(PageStyle::Strong);
        end else
            StyleExprTxt := Format(PageStyle::None);
    end;

    var
        StyleExprTxt: Text;
        CalculatedDocuAmount: Decimal;

}