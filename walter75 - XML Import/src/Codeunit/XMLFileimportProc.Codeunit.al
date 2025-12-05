codeunit 60501 "SEW XML Fileimport Proc"
{
    Permissions = tabledata "SEW XML Fileimport" = rimd,
                tabledata "XML Buffer" = rimd,
                tabledata "SEW XML Fileimport Address" = rimd,
                tabledata "SEW XML Fileimport Line" = rimd,
                tabledata "Nonstock Item" = rimd,
                tabledata "SEW XML Fileimport Cost" = rimd;

    var
        TempXMLBuffer2: Record "XML Buffer" temporary;

    procedure ProcessRecord(var SEWXMLFileimport: Record "SEW XML Fileimport")
    var
        TempXMLBuffer: Record "XML Buffer" temporary;
        xlInStream: InStream;
    begin
        Clear(TempXMLBuffer);

        SEWXMLFileimport.CalcFields(SEWXMLFileimport.FileContentBlob);
        SEWXMLFileimport.FileContentBlob.CreateInStream(xlInStream, TextEncoding::UTF8);
        TempXMLBuffer.LoadFromStream(xlInStream);

        ProcessDocument(TempXMLBuffer, SEWXMLFileimport);
        //Page.Run(Page::"SEW XMLBuffer", TempXMLBuffer);

        SEWXMLFileimport."Doc Status" := "SEW Transfer Status"::"File Processed";
        SEWXMLFileimport."Doc Processed Date/Time" := CurrentDateTime();
        SEWXMLFileimport.Modify(false);

        Commit(); // so far... so good...
    end;

    local procedure ProcessDocument(var TempXMLBuffer: Record "XML Buffer" temporary; var SEWXMLFileimport: Record "SEW XML Fileimport")
    var
        SEWXMLFileimportCheck: Record "SEW XML Fileimport";
        TempXMLBuffer1: Record "XML Buffer" temporary;
    begin
        Clear(TempXMLBuffer1);
        Clear(TempXMLBuffer2);
        TempXMLBuffer1.DeleteAll(false);
        TempXMLBuffer2.DeleteAll(false);

        TempXMLBuffer.Reset();
        if TempXMLBuffer.FindSet(false) then
            repeat
                TempXMLBuffer1 := TempXMLBuffer;
                TempXMLBuffer1.Insert(false);
                TempXMLBuffer2 := TempXMLBuffer;
                TempXMLBuffer2.Insert(false);
            until TempXMLBuffer.Next() = 0;

        // Set Path filter for DOCNUM depending on Doc Typ
        case SEWXMLFileimport."Doc Type" of
            SEWXMLFileimport."Doc Type"::Invoice:
                TempXMLBuffer.SetRange("Path", '/INVOIC02/IDOC/EDI_DC40/DOCNUM');

            SEWXMLFileimport."Doc Type"::"Delivery Note":
                TempXMLBuffer.SetRange("Path", '/DELVRY03/IDOC/EDI_DC40/DOCNUM');
        end;

        //Get Doc No.
        if TempXMLBuffer.FindFirst() then
            SEWXMLFileimport."Doc No." := CopyStr(TempXMLBuffer.Value, 1, MaxStrLen(SEWXMLFileimport."Doc No."));

        //Check if we find a DOCNUM node, if yes, this document was already processed
        SEWXMLFileimportCheck.Reset();
        SEWXMLFileimportCheck.SetRange("Doc No.", SEWXMLFileimport."Doc No.");
        if not SEWXMLFileimportCheck.IsEmpty() then begin
            SEWXMLFileimport."Doc Status" := "SEW Transfer Status"::"Error on File Processing";
            SEWXMLFileimport.Modify(false);
            exit;
        end;

        if SEWXMLFileimport."Doc Type" = SEWXMLFileimport."Doc Type"::Invoice then
            ProcessDocInv(TempXMLBuffer, TempXMLBuffer1, SEWXMLFileimport);

        if SEWXMLFileimport."Doc Type" = SEWXMLFileimport."Doc Type"::"Delivery Note" then
            ProcessDocDel(TempXMLBuffer, TempXMLBuffer1, SEWXMLFileimport);

        // Finally modify the SEWXMLFileimport record
        SEWXMLFileimport.Modify(false);
    end;




    // Invoice related processing functions HEADER
    local procedure ProcessDocInv(var TempXMLBuffer: Record "XML Buffer" temporary; var TempXMLBuffer1: Record "XML Buffer" temporary; var SEWXMLFileimport: Record "SEW XML Fileimport")
    begin

        SEWXMLFileimport."Doc Creation Date" := CreateDateFromText(GetXMLPathValueText(TempXMLBuffer, '/INVOIC02/IDOC/EDI_DC40/CREDAT'));
        Evaluate(SEWXMLFileimport."Doc Creation Time", GetXMLPathValueText(TempXMLBuffer, '/INVOIC02/IDOC/EDI_DC40/CRETIM'));
        SEWXMLFileimport."Doc Currency" := CopyStr(GetXMLPathValueText(TempXMLBuffer, '/INVOIC02/IDOC/E1EDK01/CURCY'), 1, MaxStrLen(SEWXMLFileimport."Doc Currency"));
        SEWXMLFileimport."Faktura Type" := CopyStr(GetXMLPathValueText(TempXMLBuffer, '/INVOIC02/IDOC/E1EDK01/FKART_RL'), 1, MaxStrLen(SEWXMLFileimport."Faktura Type"));
        SEWXMLFileimport."Faktura Type2" := CopyStr(GetXMLPathValueText(TempXMLBuffer, '/INVOIC02/IDOC/E1EDK01/FKTYP'), 1, MaxStrLen(SEWXMLFileimport."Faktura Type2"));

        TempXMLBuffer.SetRange("Path", '/INVOIC02/IDOC/E1EDK02'); // Get Reference Data
        if TempXMLBuffer.FindSet(false) then
            repeat
                ProcessDocInvE1EDK02(TempXMLBuffer1, SEWXMLFileimport, TempXMLBuffer."Entry No.");
            until TempXMLBuffer.Next() = 0;

        TempXMLBuffer.SetRange("Path", '/INVOIC02/IDOC/E1EDK05'); // Get Freight and Packing Data
        if TempXMLBuffer.FindSet(false) then
            repeat
                ProcessDocInvE1EDK05(TempXMLBuffer1, SEWXMLFileimport, TempXMLBuffer."Entry No.");
            until TempXMLBuffer.Next() = 0;

        TempXMLBuffer.SetRange("Path", '/INVOIC02/IDOC/E1EDKA1'); // Get Address Data
        if TempXMLBuffer.FindSet(false) then
            repeat
                ProcessDocAddress(TempXMLBuffer1, SEWXMLFileimport, TempXMLBuffer."Entry No.");
            until TempXMLBuffer.Next() = 0;

        TempXMLBuffer.SetRange("Path", '/INVOIC02/IDOC/E1EDP01'); // Get Item Data
        if TempXMLBuffer.FindSet(false) then
            repeat
                ProcessDocInvItem(TempXMLBuffer1, SEWXMLFileimport, TempXMLBuffer."Entry No.");
            until TempXMLBuffer.Next() = 0;

        TempXMLBuffer.SetRange("Path", '/INVOIC02/IDOC/E1EDS01'); // Get Summary Data
        if TempXMLBuffer.FindSet(false) then
            repeat
                ProcessDocInvE1EDS01(TempXMLBuffer1, SEWXMLFileimport, TempXMLBuffer."Entry No.");
            until TempXMLBuffer.Next() = 0;
    end;

    local procedure ProcessDocInvE1EDS01(var TempXMLBuffer: Record "XML Buffer" temporary; var SEWXMLFileimport: Record "SEW XML Fileimport"; EntryNo: Integer)
    var
        xQUALF: Text;
    begin
        TempXMLBuffer.Reset();
        TempXMLBuffer.SetRange("Parent Entry No.", EntryNo);
        xQUALF := GetXMLPathValueText(TempXMLBuffer, '/INVOIC02/IDOC/E1EDS01/SUMID');

        case xQUALF of
            '001': // Kastenmüller Bestellnummer
                SEWXMLFileimport."Doc Count of Lines" := GetXMLPathValueInteger(TempXMLBuffer, '/INVOIC02/IDOC/E1EDS01/SUMME');

            '010': // Jacob Auftragsnummer
                SEWXMLFileimport."Doc Amount net" := GetXMLPathValueDecimal(TempXMLBuffer, '/INVOIC02/IDOC/E1EDS01/SUMME');

        end;
    end;

    local procedure ProcessDocInvE1EDK02(var TempXMLBuffer: Record "XML Buffer" temporary; var SEWXMLFileimport: Record "SEW XML Fileimport"; EntryNo: Integer)
    var
        xQUALF: Text;
    begin
        TempXMLBuffer.Reset();
        TempXMLBuffer.SetRange("Parent Entry No.", EntryNo);
        xQUALF := GetXMLPathValueText(TempXMLBuffer, '/INVOIC02/IDOC/E1EDK02/QUALF');

        case xQUALF of
            '001': // Kastenmüller Bestellnummer
                begin
                    SEWXMLFileimport."Purch. Order No." := CopyStr(GetXMLPathValueText(TempXMLBuffer, '/INVOIC02/IDOC/E1EDK02/BELNR'), 1, MaxStrLen(SEWXMLFileimport."Purch. Order No."));
                    SEWXMLFileimport."Purch. Order No." := CopyStr(CleanPurchaseOrderNo(SEWXMLFileimport."Purch. Order No."), 1, MaxStrLen(SEWXMLFileimport."Purch. Order No."));
                    SEWXMLFileimport."Purch. Order Date" := CreateDateFromText(CopyStr(GetXMLPathValueText(TempXMLBuffer, '/INVOIC02/IDOC/E1EDK02/DATUM'), 1, 250));
                end;
            '002': // Jacob Auftragsnummer
                begin
                    SEWXMLFileimport."Ext. Sales Order No." := CopyStr(GetXMLPathValueText(TempXMLBuffer, '/INVOIC02/IDOC/E1EDK02/BELNR'), 1, MaxStrLen(SEWXMLFileimport."Ext. Sales Order No."));
                    SEWXMLFileimport."Ext. Sales Order Date" := CreateDateFromText(CopyStr(GetXMLPathValueText(TempXMLBuffer, '/INVOIC02/IDOC/E1EDK02/DATUM'), 1, 250));
                end;
            '012': //Jaboc Lieferscheinummer
                begin
                    SEWXMLFileimport."Ext. Shipment No." := CopyStr(GetXMLPathValueText(TempXMLBuffer, '/INVOIC02/IDOC/E1EDK02/BELNR'), 1, MaxStrLen(SEWXMLFileimport."Ext. Shipment No."));
                    SEWXMLFileimport."Ext. Shipment Date" := CreateDateFromText(CopyStr(GetXMLPathValueText(TempXMLBuffer, '/INVOIC02/IDOC/E1EDK02/DATUM'), 1, 250));
                end;
            '009': // Jacob Rechnungnummer
                begin
                    SEWXMLFileimport."Ext. Invoice No." := CopyStr(GetXMLPathValueText(TempXMLBuffer, '/INVOIC02/IDOC/E1EDK02/BELNR'), 1, MaxStrLen(SEWXMLFileimport."Ext. Invoice No."));
                    SEWXMLFileimport."Ext. Invoice Date" := CreateDateFromText(CopyStr(GetXMLPathValueText(TempXMLBuffer, '/INVOIC02/IDOC/E1EDK02/DATUM'), 1, 250));
                end;
        end;
    end;

    local procedure ProcessDocInvE1EDK05(var TempXMLBuffer: Record "XML Buffer" temporary; var SEWXMLFileimport: Record "SEW XML Fileimport"; EntryNo: Integer)
    var
        xKSCHL: Text;
        xCostCode: Code[20];
        xCostDescription: Text[100];
        xCostAmount: Decimal;
        xCostMark: Code[1];
    begin
        TempXMLBuffer.Reset();
        TempXMLBuffer.SetRange("Parent Entry No.", EntryNo);
        xKSCHL := GetXMLPathValueText(TempXMLBuffer, '/INVOIC02/IDOC/E1EDK05/KSCHL');

        if xKSCHL <> 'ZBAS' then begin
            xCostCode := CopyStr(xKSCHL, 1, 20);
            xCostDescription := CopyStr(GetXMLPathValueText(TempXMLBuffer, '/INVOIC02/IDOC/E1EDK05/KOTXT'), 1, 100);
            xCostAmount := GetXMLPathValueDecimal(TempXMLBuffer, '/INVOIC02/IDOC/E1EDK05/BETRG');
            xCostMark := CopyStr(GetXMLPathValueText(TempXMLBuffer, '/INVOIC02/IDOC/E1EDK05/ALCKZ'), 1, 1);
            if xCostMark = '-' then
                xCostAmount := xCostAmount * -1;

            ProcessDocInvE1EDK05Cost(SEWXMLFileimport, xCostCode, xCostDescription, xCostAmount);
        end;


    end;

    local procedure ProcessDocInvE1EDK05Cost(var SEWXMLFileimport: Record "SEW XML Fileimport"; xCostCode: Code[20]; xCostDescription: Text[100]; xCostAmount: Decimal)
    var
        SEWXMLFileimportCost: Record "SEW XML Fileimport Cost";
    begin
        SEWXMLFileimportCost.Init();
        SEWXMLFileimportCost.id := SEWXMLFileimportCost.GetLastEntryNo() + 1;
        SEWXMLFileimportCost."transferID" := SEWXMLFileimport.transferID;
        SEWXMLFileimportCost."Cost Code" := xCostCode;
        SEWXMLFileimportCost."Cost Description" := xCostDescription;
        SEWXMLFileimportCost."Cost Amount" := xCostAmount;
        SEWXMLFileimportCost.Insert(false);


    end;
    // Invoice related processing functions ITEM    
    local procedure ProcessDocInvItem(var TempXMLBuffer: Record "XML Buffer" temporary; var SEWXMLFileimport: Record "SEW XML Fileimport"; EntryNo: Integer)
    var
        SEWXMLFileimportLine: Record "SEW XML Fileimport Line";
    begin
        TempXMLBuffer.Reset();
        TempXMLBuffer.SetRange("Parent Entry No.", EntryNo);

        if not TempXMLBuffer.FindSet(false) then
            exit;

        SEWXMLFileimportLine.Init();
        SEWXMLFileimportLine.id := SEWXMLFileimportLine.GetLastEntryNo() + 1;
        SEWXMLFileimportLine."transferID" := SEWXMLFileimport.transferID;

        repeat
            case TempXMLBuffer."Path" of
                '/INVOIC02/IDOC/E1EDP01/POSEX':
                    Evaluate(SEWXMLFileimportLine."Ext. Invoice Line No.", TempXMLBuffer.Value.Replace('.', ','));



                '/INVOIC02/IDOC/E1EDP01/MENGE':
                    Evaluate(SEWXMLFileimportLine."Ext. Invoice Qty", TempXMLBuffer.Value.Replace('.', ','));



                '/INVOIC02/IDOC/E1EDP01/MENEE':
                    SEWXMLFileimportLine."Unit of Measure" := CopyStr(TempXMLBuffer.Value, 1, MaxStrLen(SEWXMLFileimportLine."Unit of Measure"));

                '/INVOIC02/IDOC/E1EDP01/NTGEW':
                    Evaluate(SEWXMLFileimportLine."Weight Net", TempXMLBuffer.Value.Replace('.', ','));

                '/INVOIC02/IDOC/E1EDP01/GEWEI':
                    SEWXMLFileimportLine."Weight Unit" := CopyStr(TempXMLBuffer.Value, 1, MaxStrLen(SEWXMLFileimportLine."Weight Unit"));

                '/INVOIC02/IDOC/E1EDP01/BRGEW':
                    Evaluate(SEWXMLFileimportLine."Weight Gross", TempXMLBuffer.Value.Replace('.', ','));

                '/INVOIC02/IDOC/E1EDP01/E1EDP02':
                    // Process each E1EDP02 node
                    ProcessDocInvItemE1EDP02(TempXMLBuffer2, SEWXMLFileimportLine, TempXMLBuffer."Entry No.");

                '/INVOIC02/IDOC/E1EDP01/E1EDP19':
                    // Process each E1EDP19 node
                    ProcessDocInvItemE1EDP19(TempXMLBuffer2, SEWXMLFileimportLine, TempXMLBuffer."Entry No.");

                '/INVOIC02/IDOC/E1EDP01/E1EDP26':
                    // Process each E1EDP26 node
                    ProcessDocInvItemE1EDP26(TempXMLBuffer2, SEWXMLFileimportLine, TempXMLBuffer."Entry No.");
            end;


        until TempXMLBuffer.Next() = 0;

        SEWXMLFileimportLine."Ext. Invoice No." := SEWXMLFileimport."Ext. Invoice No.";
        SEWXMLFileimportLine."Ext. Invoice Date" := SEWXMLFileimport."Ext. Invoice Date";

        SEWXMLFileimportLine.Insert(false);
    end;

    local procedure ProcessDocInvItemE1EDP02(var TempXMLBuffer: Record "XML Buffer" temporary; var SEWXMLFileimportLine: Record "SEW XML Fileimport Line"; EntryNo: Integer)
    var
        xQUALF: Text;
    begin
        TempXMLBuffer.Reset();
        TempXMLBuffer.SetRange("Parent Entry No.", EntryNo);
        xQUALF := GetXMLPathValueText(TempXMLBuffer, '/INVOIC02/IDOC/E1EDP01/E1EDP02/QUALF');

        case xQUALF of
            '001': // Kastenmüller Bestellung
                begin
                    SEWXMLFileimportLine."Purch. Order No." := CopyStr(GetXMLPathValueText(TempXMLBuffer, '/INVOIC02/IDOC/E1EDP01/E1EDP02/BELNR'), 1, MaxStrLen(SEWXMLFileimportLine."Purch. Order No."));
                    SEWXMLFileimportLine."Purch. Order No." := CopyStr(CleanPurchaseOrderNo(SEWXMLFileimportLine."Purch. Order No."), 1, MaxStrLen(SEWXMLFileimportLine."Purch. Order No."));
                    SEWXMLFileimportLine."Purch. Order Line No." := GetXMLPathValueInteger(TempXMLBuffer, '/INVOIC02/IDOC/E1EDP01/E1EDP02/ZEILE');
                end;

            '002': // Jacob Auftrag
                begin
                    SEWXMLFileimportLine."Ext. Sales Order No." := CopyStr(GetXMLPathValueText(TempXMLBuffer, '/INVOIC02/IDOC/E1EDP01/E1EDP02/BELNR'), 1, MaxStrLen(SEWXMLFileimportLine."Ext. Sales Order No."));
                    SEWXMLFileimportLine."Ext. Sales Order Line No." := GetXMLPathValueInteger(TempXMLBuffer, '/INVOIC02/IDOC/E1EDP01/E1EDP02/ZEILE');
                end;

            '016': // Jacob Lieferung
                begin
                    SEWXMLFileimportLine."Ext. Shipment No." := CopyStr(GetXMLPathValueText(TempXMLBuffer, '/INVOIC02/IDOC/E1EDP01/E1EDP02/BELNR'), 1, MaxStrLen(SEWXMLFileimportLine."Ext. Shipment No."));
                    SEWXMLFileimportLine."Ext. Shipment Line No." := GetXMLPathValueInteger(TempXMLBuffer, '/INVOIC02/IDOC/E1EDP01/E1EDP02/ZEILE');
                end;
        end;
    end;

    local procedure ProcessDocInvItemE1EDP19(var TempXMLBuffer: Record "XML Buffer" temporary; var SEWXMLFileimportLine: Record "SEW XML Fileimport Line"; EntryNo: Integer)
    var
        xQUALF: Text;
    begin
        TempXMLBuffer.Reset();
        TempXMLBuffer.SetRange("Parent Entry No.", EntryNo);
        xQUALF := GetXMLPathValueText(TempXMLBuffer, '/INVOIC02/IDOC/E1EDP01/E1EDP19/QUALF');

        case xQUALF of
            '001': // Materialnummer
                SEWXMLFileimportLine.KDMAT := CopyStr(GetXMLPathValueText(TempXMLBuffer, '/INVOIC02/IDOC/E1EDP01/E1EDP19/IDTNR'), 1, MaxStrLen(SEWXMLFileimportLine.KDMAT));

            '002': // Artikeltext
                begin
                    SEWXMLFileimportLine.MATNR := CopyStr(GetXMLPathValueText(TempXMLBuffer, '/INVOIC02/IDOC/E1EDP01/E1EDP19/IDTNR'), 1, MaxStrLen(SEWXMLFileimportLine.MATNR));
                    SEWXMLFileimportLine.ARKTX := CopyStr(GetXMLPathValueText(TempXMLBuffer, '/INVOIC02/IDOC/E1EDP01/E1EDP19/KTEXT'), 1, MaxStrLen(SEWXMLFileimportLine.ARKTX));
                end;

        end;
    end;

    local procedure ProcessDocInvItemE1EDP26(var TempXMLBuffer: Record "XML Buffer" temporary; var SEWXMLFileimportLine: Record "SEW XML Fileimport Line"; EntryNo: Integer)
    var
        xQUALF: Text;
    begin
        TempXMLBuffer.Reset();
        TempXMLBuffer.SetRange("Parent Entry No.", EntryNo);
        xQUALF := GetXMLPathValueText(TempXMLBuffer, '/INVOIC02/IDOC/E1EDP01/E1EDP26/QUALF');

        case xQUALF of
            '015': // Einzelpreis
                begin
                    SEWXMLFileimportLine."Unit Cost" := (GetXMLPathValueDecimal(TempXMLBuffer, '/INVOIC02/IDOC/E1EDP01/E1EDP26/BETRG') / SEWXMLFileimportLine."Ext. Invoice Qty");
                    SEWXMLFileimportLine."Unit Cost Line Amount" := GetXMLPathValueDecimal(TempXMLBuffer, '/INVOIC02/IDOC/E1EDP01/E1EDP26/BETRG');
                end;

            '002': // Artikeltext
                ; // nothing so far...
        end;
    end;




    //   Delivery Note related processing functions HEADER
    local procedure ProcessDocDel(var TempXMLBuffer: Record "XML Buffer" temporary; var TempXMLBuffer1: Record "XML Buffer" temporary; var SEWXMLFileimport: Record "SEW XML Fileimport")
    begin
        TempXMLBuffer.SetRange("Path", '/DELVRY03/IDOC/EDI_DC40/CREDAT');
        if TempXMLBuffer.FindFirst() then
            SEWXMLFileimport."Doc Creation Date" := CreateDateFromText(TempXMLBuffer.Value);

        TempXMLBuffer.SetRange("Path", '/DELVRY03/IDOC/EDI_DC40/CRETIM');
        if TempXMLBuffer.FindFirst() then
            Evaluate(SEWXMLFileimport."Doc Creation Time", TempXMLBuffer.Value);

        TempXMLBuffer.SetRange("Path", '/DELVRY03/IDOC/E1EDL20/VBELN');
        if TempXMLBuffer.FindFirst() then
            SEWXMLFileimport."Ext. Shipment No." := CopyStr(TempXMLBuffer.Value, 1, MaxStrLen(SEWXMLFileimport."Ext. Shipment No."));

        TempXMLBuffer.SetRange("Path", '/DELVRY03/IDOC/E1EDL20/E1EDL24/VGBEL');
        if TempXMLBuffer.FindFirst() then
            SEWXMLFileimport."Ext. Sales Order No." := CopyStr(TempXMLBuffer.Value, 1, MaxStrLen(SEWXMLFileimport."Ext. Sales Order No."));

        TempXMLBuffer.SetRange("Path", '/DELVRY03/IDOC/E1EDL20/E1EDL24/E1EDL41/BSTNR');
        if TempXMLBuffer.FindFirst() then
            SEWXMLFileimport."Purch. Order No." := CopyStr(CleanPurchaseOrderNo(TempXMLBuffer.Value), 1, MaxStrLen(SEWXMLFileimport."Purch. Order No."));

        //Get Dates
        TempXMLBuffer.SetRange("Path", '/DELVRY03/IDOC/E1EDL20/E1EDT13');
        if TempXMLBuffer.FindSet(false) then
            repeat
                // Process each E1ADRM1 node
                ProcessDocDelE1EDT13(TempXMLBuffer2, SEWXMLFileimport, TempXMLBuffer."Entry No.");
            until TempXMLBuffer.Next() = 0;


        // Get Address Data
        TempXMLBuffer.SetRange("Path", '/DELVRY03/IDOC/E1EDL20/E1ADRM1');
        if TempXMLBuffer.FindSet(false) then
            repeat
                // Process each E1ADRM1 node
                ProcessDocAddress(TempXMLBuffer1, SEWXMLFileimport, TempXMLBuffer."Entry No.");
            until TempXMLBuffer.Next() = 0;

        // Get Item Data
        TempXMLBuffer.SetRange("Path", '/DELVRY03/IDOC/E1EDL20/E1EDL24');
        if TempXMLBuffer.FindSet(false) then
            repeat
                ProcessDocDelItem(TempXMLBuffer1, SEWXMLFileimport, TempXMLBuffer."Entry No.");
            until TempXMLBuffer.Next() = 0;
    end;


    local procedure ProcessDocDelE1EDT13(var TempXMLBuffer: Record "XML Buffer" temporary; var SEWXMLFileimport: Record "SEW XML Fileimport"; EntryNo: Integer)
    var
        xQUALF: Text;
    begin
        TempXMLBuffer.Reset();
        TempXMLBuffer.SetRange("Parent Entry No.", EntryNo);
        xQUALF := GetXMLPathValueText(TempXMLBuffer, '/DELVRY03/IDOC/E1EDL20/E1EDT13/QUALF');

        case xQUALF of
            '001': // Einzelpreis
                SEWXMLFileimport."Ext. Shipment Date" := CreateDateFromText(CopyStr(GetXMLPathValueText(TempXMLBuffer, '/DELVRY03/IDOC/E1EDL20/E1EDT13/NTANF'), 1, 250));


            '002': // Artikeltext
                ; // nothing so far...
        end;

    end;


    // Delivery Note related processing functions ITEM
    local procedure ProcessDocDelItem(var TempXMLBuffer: Record "XML Buffer" temporary; var SEWXMLFileimport: Record "SEW XML Fileimport"; EntryNo: Integer)
    var
        SEWXMLFileimportLine: Record "SEW XML Fileimport Line";
    begin
        TempXMLBuffer.Reset();
        TempXMLBuffer.SetRange("Parent Entry No.", EntryNo);

        SEWXMLFileimportLine.Init();
        SEWXMLFileimportLine.id := SEWXMLFileimportLine.GetLastEntryNo() + 1;
        SEWXMLFileimportLine."transferID" := SEWXMLFileimport.transferID;


        SEWXMLFileimportLine.MATNR := CopyStr(GetXMLPathValueText(TempXMLBuffer, '/DELVRY03/IDOC/E1EDL20/E1EDL24/MATNR'), 1, MaxStrLen(SEWXMLFileimportLine.MATNR));
        SEWXMLFileimportLine.ARKTX := CopyStr(GetXMLPathValueText(TempXMLBuffer, '/DELVRY03/IDOC/E1EDL20/E1EDL24/ARKTX'), 1, MaxStrLen(SEWXMLFileimportLine.ARKTX));
        SEWXMLFileimportLine.KDMAT := CopyStr(GetXMLPathValueText(TempXMLBuffer, '/DELVRY03/IDOC/E1EDL20/E1EDL24/KDMAT'), 1, MaxStrLen(SEWXMLFileimportLine.KDMAT));

        SEWXMLFileimportLine."Purch. Order Qty" := GetXMLPathValueDecimal(TempXMLBuffer, '/DELVRY03/IDOC/E1EDL20/E1EDL24/ORMNG');

        SEWXMLFileimportLine."Ext. Shipment No." := SEWXMLFileimport."Ext. Shipment No.";
        SEWXMLFileimportLine."Ext. Shipment Line No." := GetXMLPathValueInteger(TempXMLBuffer, '/DELVRY03/IDOC/E1EDL20/E1EDL24/POSNR');
        SEWXMLFileimportLine."Ext. Shipment Qty" := GetXMLPathValueDecimal(TempXMLBuffer, '/DELVRY03/IDOC/E1EDL20/E1EDL24/LFIMG');
        SEWXMLFileimportLine."Ext. Sales Order Qty" := GetXMLPathValueDecimal(TempXMLBuffer, '/DELVRY03/IDOC/E1EDL20/E1EDL24/ORMNG');

        SEWXMLFileimportLine."Unit of Measure" := CopyStr(GetXMLPathValueText(TempXMLBuffer, '/DELVRY03/IDOC/E1EDL20/E1EDL24/MEINS'), 1, MaxStrLen(SEWXMLFileimportLine."Unit of Measure"));
        SEWXMLFileimportLine."Weight Net" := GetXMLPathValueDecimal(TempXMLBuffer, '/DELVRY03/IDOC/E1EDL20/E1EDL24/NTGEW');
        SEWXMLFileimportLine."Weight Gross" := GetXMLPathValueDecimal(TempXMLBuffer, '/DELVRY03/IDOC/E1EDL20/E1EDL24/BRGEW');
        SEWXMLFileimportLine."Weight Unit" := CopyStr(GetXMLPathValueText(TempXMLBuffer, '/DELVRY03/IDOC/E1EDL20/E1EDL24/GEWEI'), 1, MaxStrLen(SEWXMLFileimportLine."Weight Unit"));
        SEWXMLFileimportLine.Volume := GetXMLPathValueDecimal(TempXMLBuffer, '/DELVRY03/IDOC/E1EDL20/E1EDL24/VOLUM');
        SEWXMLFileimportLine."Volume Unit" := CopyStr(GetXMLPathValueText(TempXMLBuffer, '/DELVRY03/IDOC/E1EDL20/E1EDL24/VOLEH'), 1, MaxStrLen(SEWXMLFileimportLine."Volume Unit"));



        TempXMLBuffer.SetRange("Path", '/DELVRY03/IDOC/E1EDL20/E1EDL24/E1EDL35');
        if TempXMLBuffer.FindFirst() then
            ProcessDocDelItemE1EDL35(TempXMLBuffer2, SEWXMLFileimportLine, TempXMLBuffer."Entry No.");

        // //ProcessE1EDL41Node(TempXMLBuffer, SEWXMLFileimportLine, TempXMLBuffer."Entry No."); >> Bestelldatum
        TempXMLBuffer.SetRange("Path", '/DELVRY03/IDOC/E1EDL20/E1EDL24/E1EDL41');
        if TempXMLBuffer.FindFirst() then
            ProcessDocDelItemE1EDL41(TempXMLBuffer2, SEWXMLFileimportLine, TempXMLBuffer."Entry No.");

        // //ProcessE1EDL43Node(TempXMLBuffer, SEWXMLFileimportLine, TempXMLBuffer."Entry No."); >> Bestelldatum
        TempXMLBuffer.SetRange("Path", '/DELVRY03/IDOC/E1EDL20/E1EDL24/E1EDL43');
        if TempXMLBuffer.FindFirst() then
            ProcessDocDelItemE1EDL43(TempXMLBuffer2, SEWXMLFileimportLine, TempXMLBuffer."Entry No.");

        // Now set the header related fields if not already set in the line
        if SEWXMLFileimport."Purch. Order Date" = 0D then
            SEWXMLFileimport."Purch. Order Date" := SEWXMLFileimportLine."Purch. Order Date";
        if SEWXMLFileimport."Ext. Sales Order Date" = 0D then
            SEWXMLFileimport."Ext. Sales Order Date" := SEWXMLFileimportLine."Ext. Sales Order Date";

        if SEWXMLFileimportLine."Ext. Shipment Date" = 0D then
            SEWXMLFileimportLine."Ext. Shipment Date" := SEWXMLFileimport."Ext. Shipment Date";

        SEWXMLFileimportLine.Insert(false);
    end;

    local procedure ProcessDocDelItemE1EDL35(var TempXMLBuffer: Record "XML Buffer" temporary; var SEWXMLFileimportLine: Record "SEW XML Fileimport Line"; EntryNo: Integer)
    begin
        TempXMLBuffer.Reset();
        TempXMLBuffer.SetRange("Parent Entry No.", EntryNo);

        SEWXMLFileimportLine."Country of Origin" := CopyStr(GetXMLPathValueText(TempXMLBuffer, '/DELVRY03/IDOC/E1EDL20/E1EDL24/E1EDL35/HERKL'), 1, MaxStrLen(SEWXMLFileimportLine."Country of Origin"));

    end;

    local procedure ProcessDocDelItemE1EDL41(var TempXMLBuffer: Record "XML Buffer" temporary; var SEWXMLFileimportLine: Record "SEW XML Fileimport Line"; EntryNo: Integer)
    var
        xQUALF: Text;
    begin
        TempXMLBuffer.Reset();
        TempXMLBuffer.SetRange("Parent Entry No.", EntryNo);
        xQUALF := GetXMLPathValueText(TempXMLBuffer, '/DELVRY03/IDOC/E1EDL20/E1EDL24/E1EDL41/QUALI');

        case xQUALF of
            '001': // Einzelpreis
                begin
                    SEWXMLFileimportLine."Purch. Order No." := CopyStr(CleanPurchaseOrderNo(GetXMLPathValueText(TempXMLBuffer, '/DELVRY03/IDOC/E1EDL20/E1EDL24/E1EDL41/BSTNR')), 1, MaxStrLen(SEWXMLFileimportLine."Purch. Order No."));
                    SEWXMLFileimportLine."Purch. Order Line No." := GetXMLPathValueInteger(TempXMLBuffer, '/DELVRY03/IDOC/E1EDL20/E1EDL24/E1EDL41/POSEX');
                    SEWXMLFileimportLine."Purch. Order Date" := CreateDateFromText(CopyStr(GetXMLPathValueText(TempXMLBuffer, '/DELVRY03/IDOC/E1EDL20/E1EDL24/E1EDL41/BSTDT'), 1, 250));
                end;

            '002': // Artikeltext
                ; // nothing so far...
        end;

    end;

    local procedure ProcessDocDelItemE1EDL43(var TempXMLBuffer: Record "XML Buffer" temporary; var SEWXMLFileimportLine: Record "SEW XML Fileimport Line"; EntryNo: Integer)
    var
        xQUALF: Text;
    begin
        TempXMLBuffer.Reset();
        TempXMLBuffer.SetRange("Parent Entry No.", EntryNo);
        xQUALF := GetXMLPathValueText(TempXMLBuffer, '/DELVRY03/IDOC/E1EDL20/E1EDL24/E1EDL43/QUALF');

        case xQUALF of
            'C': // Einzelpreis
                begin
                    SEWXMLFileimportLine."Ext. Sales Order No." := CopyStr(GetXMLPathValueText(TempXMLBuffer, '/DELVRY03/IDOC/E1EDL20/E1EDL24/E1EDL43/BELNR'), 1, MaxStrLen(SEWXMLFileimportLine."Ext. Sales Order No."));
                    SEWXMLFileimportLine."Ext. Sales Order Line No." := GetXMLPathValueInteger(TempXMLBuffer, '/DELVRY03/IDOC/E1EDL20/E1EDL24/E1EDL43/POSNR');
                    SEWXMLFileimportLine."Ext. Sales Order Date" := CreateDateFromText(CopyStr(GetXMLPathValueText(TempXMLBuffer, '/DELVRY03/IDOC/E1EDL20/E1EDL24/E1EDL43/DATUM'), 1, 250));
                end;

            '002': // Artikeltext
                ; // nothing so far...
        end;

    end;


    // Document related processing functions ADDRESS
    local procedure ProcessDocAddress(var TempXMLBuffer: Record "XML Buffer" temporary; var SEWXMLFileimport: Record "SEW XML Fileimport"; EntryNo: Integer)
    var
        SEWXMLFileimportAddress: Record "SEW XML Fileimport Address";
        xPARTNER_Q: Text;
        xPARTNER_ID: Text;
    begin
        Clear(xPARTNER_ID);
        Clear(xPARTNER_Q);

        TempXMLBuffer.Reset();
        TempXMLBuffer.SetRange("Parent Entry No.", EntryNo);

        case SEWXMLFileimport."Doc Type" of

            SEWXMLFileimport."Doc Type"::Invoice:
                begin
                    TempXMLBuffer.SetRange("Path", '/INVOIC02/IDOC/E1EDKA1/PARVW');
                    if not TempXMLBuffer.FindFirst() then
                        exit;
                    xPARTNER_Q := TempXMLBuffer.Value;

                    TempXMLBuffer.SetRange("Path", '/INVOIC02/IDOC/E1EDKA1/PARTN');
                    if not TempXMLBuffer.FindFirst() then
                        exit;
                    xPARTNER_ID := TempXMLBuffer.Value;
                end;

            SEWXMLFileimport."Doc Type"::"Delivery Note":
                begin
                    TempXMLBuffer.SetRange("Path", '/DELVRY03/IDOC/E1EDL20/E1ADRM1/PARTNER_Q');
                    if not TempXMLBuffer.FindFirst() then
                        exit;
                    xPARTNER_Q := TempXMLBuffer.Value;

                    TempXMLBuffer.SetRange("Path", '/DELVRY03/IDOC/E1EDL20/E1ADRM1/PARTNER_ID');
                    if not TempXMLBuffer.FindFirst() then
                        exit;
                    xPARTNER_ID := TempXMLBuffer.Value;
                end;
        end;

        SEWXMLFileimportAddress.Reset();
        SEWXMLFileimportAddress.SetRange(PARTNER_ID, xPARTNER_ID);
        SEWXMLFileimportAddress.SetRange(PARTNER_Q, xPARTNER_Q);
        if not SEWXMLFileimportAddress.FindFirst() then begin
            SEWXMLFileimportAddress.Init();
            SEWXMLFileimportAddress.PARTNER_ID := CopyStr(xPARTNER_ID, 1, MaxStrLen(SEWXMLFileimportAddress.PARTNER_ID));
            SEWXMLFileimportAddress.PARTNER_Q := CopyStr(xPARTNER_Q, 1, MaxStrLen(SEWXMLFileimportAddress.PARTNER_Q));
            SEWXMLFileimportAddress.Insert(false);
        end;

        case xPARTNER_Q of
            'AG':
                SEWXMLFileimport."Partner AG" := CopyStr(xPARTNER_ID, 1, MaxStrLen(SEWXMLFileimport."Partner AG"));
            'BK':
                SEWXMLFileimport."Partner BK" := CopyStr(xPARTNER_ID, 1, MaxStrLen(SEWXMLFileimport."Partner BK"));
            'WE':
                SEWXMLFileimport."Partner WE" := CopyStr(xPARTNER_ID, 1, MaxStrLen(SEWXMLFileimport."Partner WE"));
            'RG':
                SEWXMLFileimport."Partner RG" := CopyStr(xPARTNER_ID, 1, MaxStrLen(SEWXMLFileimport."Partner RG"));
            'RE':
                SEWXMLFileimport."Partner RE" := CopyStr(xPARTNER_ID, 1, MaxStrLen(SEWXMLFileimport."Partner RE"));
            'RS':
                SEWXMLFileimport."Partner RS" := CopyStr(xPARTNER_ID, 1, MaxStrLen(SEWXMLFileimport."Partner RS"));
            'ZK':
                SEWXMLFileimport."Partner ZK" := CopyStr(xPARTNER_ID, 1, MaxStrLen(SEWXMLFileimport."Partner ZK"));
            'OSP':
                SEWXMLFileimport."Partner OSP" := CopyStr(xPARTNER_ID, 1, MaxStrLen(SEWXMLFileimport."Partner OSP"));
            'OSO':
                SEWXMLFileimport."Partner OSO" := CopyStr(xPARTNER_ID, 1, MaxStrLen(SEWXMLFileimport."Partner OSO"));
        end;

        TempXMLBuffer.SetRange("Path"); // Clear Path filter
        if TempXMLBuffer.FindSet() then
            repeat
                case TempXMLBuffer."Path" of
                    '/DELVRY03/IDOC/E1EDL20/E1ADRM1/NAME1', '/INVOIC02/IDOC/E1EDKA1/NAME1':
                        SEWXMLFileimportAddress.NAME1 := CopyStr(TempXMLBuffer.Value, 1, MaxStrLen(SEWXMLFileimportAddress.NAME1));

                    '/INVOIC02/IDOC/E1EDKA1/NAME2', '/DELVRY03/IDOC/E1EDL20/E1ADRM1/NAME2':
                        SEWXMLFileimportAddress.NAME2 := CopyStr(TempXMLBuffer.Value, 1, MaxStrLen(SEWXMLFileimportAddress.NAME2));

                    '/INVOIC02/IDOC/E1EDKA1/STRAS', '/DELVRY03/IDOC/E1EDL20/E1ADRM1/STREET1':
                        SEWXMLFileimportAddress.STREET1 := CopyStr(TempXMLBuffer.Value, 1, MaxStrLen(SEWXMLFileimportAddress.STREET1));

                    '/INVOIC02/IDOC/E1EDKA1/LAND1', '/DELVRY03/IDOC/E1EDL20/E1ADRM1/COUNTRY1':
                        SEWXMLFileimportAddress.COUNTRY1 := CopyStr(TempXMLBuffer.Value, 1, MaxStrLen(SEWXMLFileimportAddress.COUNTRY1));

                    '/INVOIC02/IDOC/E1EDKA1/PSTLZ', '/DELVRY03/IDOC/E1EDL20/E1ADRM1/POSTL_COD1':
                        SEWXMLFileimportAddress.POSTL_COD1 := CopyStr(TempXMLBuffer.Value, 1, MaxStrLen(SEWXMLFileimportAddress.POSTL_COD1));

                    '/INVOIC02/IDOC/E1EDKA1/ORT01', '/DELVRY03/IDOC/E1EDL20/E1ADRM1/CITY1':
                        SEWXMLFileimportAddress.CITY1 := CopyStr(TempXMLBuffer.Value, 1, MaxStrLen(SEWXMLFileimportAddress.CITY1));

                    '/INVOIC02/IDOC/E1EDKA1/TELF1', '/DELVRY03/IDOC/E1EDL20/E1ADRM1/TELEPHONE1':
                        SEWXMLFileimportAddress.TELEPHONE1 := CopyStr(TempXMLBuffer.Value, 1, MaxStrLen(SEWXMLFileimportAddress.TELEPHONE1));

                    '/INVOIC02/IDOC/E1EDKA1/TELFXX', '/DELVRY03/IDOC/E1EDL20/E1ADRM1/TELEFAX':
                        SEWXMLFileimportAddress.TELEFAX := CopyStr(TempXMLBuffer.Value, 1, MaxStrLen(SEWXMLFileimportAddress.TELEFAX));

                    '/DELVRY03/IDOC/E1EDL20/E1ADRM1/E_MAIL':
                        SEWXMLFileimportAddress.E_MAIL := CopyStr(TempXMLBuffer.Value, 1, MaxStrLen(SEWXMLFileimportAddress.E_MAIL));

                    '/INVOIC02/IDOC/E1EDKA1/SPRAS_ISO', '/DELVRY03/IDOC/E1EDL20/E1ADRM1/LANGUAGE':
                        SEWXMLFileimportAddress.LANGUAGE := CopyStr(TempXMLBuffer.Value, 1, MaxStrLen(SEWXMLFileimportAddress.LANGUAGE));
                end;
            until TempXMLBuffer.Next() = 0;


        SEWXMLFileimportAddress.Modify(false);
        SEWXMLFileimport.Modify(false);

    end;




    // Helper functions
    local procedure GetXMLPathValueText(var TempXMLBuffer: Record "XML Buffer" temporary; XMLPath: Text): Text
    begin
        TempXMLBuffer.SetRange("Path", XMLPath);
        if TempXMLBuffer.FindFirst() then
            exit(TempXMLBuffer.Value)
        else
            exit('');
    end;

    local procedure GetXMLPathValueInteger(var TempXMLBuffer: Record "XML Buffer" temporary; XMLPath: Text): Integer
    var
        xdest: Integer;
    begin
        xdest := 0;
        TempXMLBuffer.SetRange("Path", XMLPath);
        if TempXMLBuffer.FindFirst() then
            if TempXMLBuffer.Value <> '' then
                Evaluate(xdest, TempXMLBuffer.Value);
        exit(xdest);
    end;

    local procedure GetXMLPathValueDecimal(var TempXMLBuffer: Record "XML Buffer" temporary; XMLPath: Text): Decimal
    var
        ValueText: Text;
        ValueDecimal: Decimal;
    begin
        ValueText := GetXMLPathValueText(TempXMLBuffer, XMLPath);
        if Evaluate(ValueDecimal, ValueText.Replace('.', ',')) then
            exit(ValueDecimal)
        else
            exit(0);
    end;

    local procedure CreateDateFromText(Input: Text): Date
    var
        Day: Integer;
        Month: Integer;
        Year: Integer;
    begin
        if Evaluate(Day, CopyStr(Input, 7, 2)) and
           Evaluate(Month, CopyStr(Input, 5, 2)) and
           Evaluate(Year, CopyStr(Input, 1, 4)) then
            exit(DMY2Date(Day, Month, Year))
        else
            exit(0D);
    end;

    local procedure CleanPurchaseOrderNo(PurchaseOrderNo: Text): Text
    var
        Slash_Pos: Integer;
    begin
        if PurchaseOrderNo.Contains('/') then begin
            Slash_Pos := StrPos(PurchaseOrderNo, '/');
            if Slash_Pos <> 0 then
                exit(CopyStr(PurchaseOrderNo, 1, Slash_Pos - 1));
        end;
        exit(PurchaseOrderNo);
    end;

}