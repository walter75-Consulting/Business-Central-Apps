codeunit 92712 "SEW PN Event Subs"
{

    Permissions = tabledata "SEW PrintNode Printer" = r;

    #region "PrintJob trigger"
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reporting Triggers", OnDocumentPrintReady, '', true, true)]
    local procedure OnDocumentPrintReady(ObjectType: Option "Report","Page"; ObjectId: Integer; ObjectPayload: JsonObject; DocumentStream: InStream; var Success: Boolean)
    var
        SEWPrintNodePrinter: Record "SEW PrintNode Printer";
        SEWPNRestRequests: Codeunit "SEW PN Rest Requests";
        PrinterNameToken: JsonToken;
        PrinterName: Text[250];
        ObjectNameToken: JsonToken;
        ObjectName: Text;

    begin
        // exit if not report
        if ObjectType <> ObjectType::Report then
            exit;

        // exit if not PrintNode printer
        if ObjectPayload.Get('printername', PrinterNameToken) then
            PrinterName := CopyStr(PrinterNameToken.AsValue().AsText(), 1, MaxStrLen(PrinterName));

        if ObjectPayload.Get('objectname', ObjectNameToken) then
            ObjectName := CopyStr(ObjectNameToken.AsValue().AsText(), 1, MaxStrLen(ObjectName));

        SEWPrintNodePrinter.SetFilter("Printer Name", '=%1', PrinterName);
        if not SEWPrintNodePrinter.FindFirst() then
            exit;

        SEWPNRestRequests.NewPrintJob(SEWPrintNodePrinter."Printer ID", DocumentStream, ObjectName);

        Success := true;
    end;

    #endregion

    #region "Printer Setup trigger"
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reporting Triggers", SetupPrinters, '', true, true)]
    local procedure SetSendToEmailPrinter(var Printers: Dictionary of [Text[250], JsonObject])
    var
        SEWPrintNodePrinter: Record "SEW PrintNode Printer";
        Payload: JsonObject;
        PaperTrays: JsonArray;
        PaperTray: JsonObject;
        PrinterPaperSourceKind: Enum "Printer Paper Source Kind";
        PrinterName: Text[250];
        PrinterDescLbl: Label 'Send print jobs using PrintNode Connector to %1', Comment = 'Placeholder %1 is the printer name';

    begin
        if not SEWPrintNodePrinter.FindSet() then
            exit;

        // Create payload for each email printer containing version, papertrays and description
        repeat
            if SEWPrintNodePrinter."Printer Name" <> '' then begin
                Clear(PaperTray);
                Clear(PaperTrays);
                Clear(Payload);

                PaperTray.Add('papersourcekind', PrinterPaperSourceKind::AutomaticFeed.AsInteger());
                PaperTray.Add('paperkind', SEWPrintNodePrinter."System Paper Kind".AsInteger());
                // If paper size is custom and no height and width is specified then set the paper size to A4
                if IsPaperSizeCustom("Printer Paper Kind"::Custom) then begin
                    if (SEWPrintNodePrinter."Default Paper Tray Height" <= 0) or (SEWPrintNodePrinter."Default Paper Tray Width" <= 0) then
                        PaperTray.Replace('paperkind', "Printer Paper Kind"::Custom.AsInteger());
                    ConvertAndAddPrinterPaperDimensions(SEWPrintNodePrinter, PaperTray);
                end;
                PaperTray.Add('landscape', false);
                PaperTrays.Add(PaperTray);

                Payload.Add('version', 1);
                Payload.Add('description', StrSubstNo(PrinterDescLbl, SEWPrintNodePrinter."Printer Name"));
                Payload.Add('papertrays', PaperTrays);
                PrinterName := CopyStr(SEWPrintNodePrinter."Printer Name", 1, MaxStrLen(PrinterName));

                Printers.Add(PrinterName, Payload);
            end;



        until SEWPrintNodePrinter.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Printer Setup", OnOpenPrinterSettings, '', false, false)]
    local procedure OnOpenSendToEmailPrinter(PrinterID: Text; var IsHandled: Boolean)
    var
        SEWPrintNodePrinter: Record "SEW PrintNode Printer";
    begin
        if IsHandled then
            exit;
        SEWPrintNodePrinter.SetFilter("Printer Name", '%1', PrinterID);
        if SEWPrintNodePrinter.FindFirst() then begin
            Page.Run(Page::"SEW PrintNode Printer List", SEWPrintNodePrinter);
            IsHandled := true;
            exit;
        end;
    end;





    internal procedure IsPaperSizeCustom("Paper Size": Enum "Printer Paper Kind"): Boolean
    begin
        exit("Paper Size" = "Paper Size"::Custom);
    end;

    internal procedure ConvertAndAddPrinterPaperDimensions(SEWPrintNodePrinter: Record "SEW PrintNode Printer"; var PaperTray: JsonObject)
    var
        PrinterUnit: Enum "Printer Unit";
    begin
        //Converting mm/in to hundredths of  a mm/in
        PaperTray.Add('height', SEWPrintNodePrinter."Default Paper Tray Height" * 100);
        PaperTray.Add('width', SEWPrintNodePrinter."Default Paper Tray Width" * 100);
        // if SEWPrintNodePrinter."Paper Unit" = SEWPrintNodePrinter."Paper Unit"::Millimeters then
        PaperTray.Add('units', PrinterUnit::HundredthsOfAMillimeter.AsInteger());
        // if SEWPrintNodePrinter."Paper Unit" = SEWPrintNodePrinter."Paper Unit"::Inches then
        //     PaperTray.Add('units', PrinterUnit::Display.AsInteger());
    end;


    #endregion

}

