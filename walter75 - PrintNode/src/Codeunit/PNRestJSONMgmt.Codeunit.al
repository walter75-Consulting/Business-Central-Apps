codeunit 92715 "SEW PN Rest JSON Mgmt"
{

    Permissions = tabledata "SEW PrintNode Computer" = rimd,
                    tabledata "SEW PrintNode Printer" = rimd,
                    tabledata "SEW PrintNode Setup" = rimd,
                    tabledata "SEW PrintNode Paper Size" = rimd;

    procedure ProcessComputersArray(JsonArrayComputers: JsonArray)
    var
        SEWPrintNodeComputer: Record "SEW PrintNode Computer";
        TempSEWPrintNodeComputer: Record "SEW PrintNode Computer" temporary;
        SEWPNRestRequests: Codeunit "SEW PN Rest Requests";

        computerID: Integer;
        JsonTokenLoop: JsonToken;
        JsonObjectLoop: JsonObject;
    begin
        foreach JsonTokenLoop in JsonArrayComputers do begin

            JsonObjectLoop := JsonTokenLoop.AsObject();
            computerID := JsonObjectLoop.GetInteger('id', true);

            Clear(SEWPrintNodeComputer);
            if not SEWPrintNodeComputer.Get(computerID) then begin
                SEWPrintNodeComputer.Init();
                SEWPrintNodeComputer."Computer ID" := computerID;
                SEWPrintNodeComputer.Insert(true);
            end;

            SEWPrintNodeComputer."Computer Name" := CopyStr(JsonObjectLoop.GetText('name'), 1, MaxStrLen(SEWPrintNodeComputer."Computer Name"));
            SEWPrintNodeComputer."Computer State" := CopyStr(JsonObjectLoop.GetText('state'), 1, MaxStrLen(SEWPrintNodeComputer."Computer State"));
            SEWPrintNodeComputer.Modify(true);

            //Save all found Computers in temp table for later use
            TempSEWPrintNodeComputer.Init();
            TempSEWPrintNodeComputer."Computer ID" := SEWPrintNodeComputer."Computer ID";
            TempSEWPrintNodeComputer.Insert(false);

            //Process Scales for this Computer
            SEWPNRestRequests.GetComputerScales(computerID);
        end;

        //for development only
        Clear(SEWPrintNodeComputer);
        if not SEWPrintNodeComputer.Get(0) then begin
            SEWPrintNodeComputer.Init();
            SEWPrintNodeComputer."Computer ID" := 0;
            SEWPrintNodeComputer."Computer Name" := 'Demo Computer';
            SEWPrintNodeComputer."Computer State" := 'active';
            SEWPrintNodeComputer.Insert(true);
        end;
        SEWPNRestRequests.ActivateTestScale();
        SEWPNRestRequests.GetComputerScales(0);
        //Save all found Computers in temp table for later use
        TempSEWPrintNodeComputer.Init();
        TempSEWPrintNodeComputer."Computer ID" := 0;
        TempSEWPrintNodeComputer.Insert(false);


        // Clean-up deleted Computers
        SEWPrintNodeComputer.Reset();
        if SEWPrintNodeComputer.FindSet() then
            repeat
                if not TempSEWPrintNodeComputer.Get(SEWPrintNodeComputer."Computer ID") then
                    SEWPrintNodeComputer.Delete(true);
            until SEWPrintNodeComputer.Next() = 0;
    end;

    procedure ProcessComputerScalesArray(JsonArrayScales: JsonArray; xComputerID: Integer; xCleanup: Boolean)
    var
        SEWPrintNodeScale: Record "SEW PrintNode Scale";
        TempSEWPrintNodeScale: Record "SEW PrintNode Scale" temporary;

        scaleID: Integer;
        computerID: Integer;
        scaleName: Text[150];

        JsonTokenLoop: JsonToken;
        JsonObjectLoop: JsonObject;
    begin
        foreach JsonTokenLoop in JsonArrayScales do begin
            JsonObjectLoop := JsonTokenLoop.AsObject();

            scaleID := JsonObjectLoop.GetInteger('deviceNum', true);
            computerID := JsonObjectLoop.GetInteger('computerId', true);
            scaleName := CopyStr(JsonObjectLoop.GetText('deviceName'), 1, MaxStrLen(SEWPrintNodeScale."Scale Name"));

            SEWPrintNodeScale.Reset();
            SEWPrintNodeScale.SetRange("Computer ID", computerID);
            SEWPrintNodeScale.SetRange("Scale Name", scaleName);
            SEWPrintNodeScale.SetRange("Scale No.", scaleID);
            if not SEWPrintNodeScale.FindFirst() then begin
                SEWPrintNodeScale.Init();
                SEWPrintNodeScale."Computer ID" := computerID;
                SEWPrintNodeScale."Scale Name" := scaleName;
                SEWPrintNodeScale."Scale No." := scaleID;
                SEWPrintNodeScale.Insert(true);
            end;

            SEWPrintNodeScale."Scale Vendor" := CopyStr(JsonObjectLoop.GetText('vendor'), 1, MaxStrLen(SEWPrintNodeScale."Scale Vendor"));
            SEWPrintNodeScale.Modify(true);

            //Save all found Scales in temp table for later use
            TempSEWPrintNodeScale.Init();
            TempSEWPrintNodeScale."Computer ID" := SEWPrintNodeScale."Computer ID";
            TempSEWPrintNodeScale."Scale Name" := SEWPrintNodeScale."Scale Name";
            TempSEWPrintNodeScale."Scale No." := SEWPrintNodeScale."Scale No.";
            TempSEWPrintNodeScale.Insert(false);
        end;

        // Clean-up deleted Scales
        if xCleanup then begin
            SEWPrintNodeScale.Reset();
            SEWPrintNodeScale.SetRange("Computer ID", xComputerID); // only clean scales for this computer
            if SEWPrintNodeScale.FindSet() then
                repeat
                    if not TempSEWPrintNodeScale.Get(SEWPrintNodeScale."Computer ID", SEWPrintNodeScale."Scale Name", SEWPrintNodeScale."Scale No.") then
                        SEWPrintNodeScale.Delete(true);
                until SEWPrintNodeScale.Next() = 0;
        end;
    end;


    procedure ProcessPrintersArray(JsonArrayComputers: JsonArray)
    var
        SEWPrintNodePrinter: Record "SEW PrintNode Printer";
        TempSEWPrintNodePrinter: Record "SEW PrintNode Printer" temporary;
        printerID: Integer;

        JsonObjectLoop: JsonObject;
        JsonTokenLoop: JsonToken;

        JObjectComputer: JsonObject;
        JTokenComputer: JsonToken;

        JObjectCapabilities: JsonObject;
        JTokenCapabilities: JsonToken;

        JObjectPapers: JsonObject;
        JTokenPapers: JsonToken;
    begin
        foreach JsonTokenLoop in JsonArrayComputers do begin

            JsonObjectLoop := JsonTokenLoop.AsObject();
            printerID := JsonObjectLoop.GetInteger('id', true);

            if not SEWPrintNodePrinter.Get(printerID) then begin
                SEWPrintNodePrinter.Init();
                SEWPrintNodePrinter."Printer ID" := printerID;
                SEWPrintNodePrinter.Insert(true);
            end;

            SEWPrintNodePrinter."Printer Name" := CopyStr(JsonObjectLoop.GetText('name'), 1, MaxStrLen(SEWPrintNodePrinter."Printer Name"));
            SEWPrintNodePrinter."Printer Name" := CopyStr(SEWPrintNodePrinter."Printer Name" + ' (' + SEWPrintNodePrinter."Printer Computer" + ')', 1, MaxStrLen(SEWPrintNodePrinter."Printer Name"));

            SEWPrintNodePrinter."Printer State" := CopyStr(JsonObjectLoop.GetText('state'), 1, MaxStrLen(SEWPrintNodePrinter."Printer State"));
            SEWPrintNodePrinter."Printer Default" := JsonObjectLoop.GetBoolean('default', true);

            //Computer Name
            JsonObjectLoop.SelectToken('computer', JTokenComputer);
            JObjectComputer := JTokenComputer.AsObject();
            SEWPrintNodePrinter."Printer Computer" := CopyStr(JObjectComputer.GetText('name'), 1, MaxStrLen(SEWPrintNodePrinter."Printer Computer"));

            //Capabilities
            JsonObjectLoop.SelectToken('capabilities', JTokenCapabilities);
            JObjectCapabilities := JTokenCapabilities.AsObject();

            //Paper Sizes
            JObjectCapabilities.SelectToken('papers', JTokenPapers);
            JObjectPapers := JTokenPapers.AsObject();
            ProcessPrinterPaper(JObjectPapers, SEWPrintNodePrinter."Printer ID");
            SEWPrintNodePrinter."Default Paper Tray Width" := 210;
            SEWPrintNodePrinter."Default Paper Tray Height" := 297;


            SEWPrintNodePrinter.Modify(true);

            //Save all found Computers in temp table for later use
            TempSEWPrintNodePrinter.Init();
            TempSEWPrintNodePrinter."Printer ID" := SEWPrintNodePrinter."Printer ID";
            TempSEWPrintNodePrinter.Insert(false);
        end;

        // Clean-up deleted Computers
        SEWPrintNodePrinter.Reset();
        if SEWPrintNodePrinter.FindSet() then
            repeat
                if not TempSEWPrintNodePrinter.Get(SEWPrintNodePrinter."Printer ID") then
                    SEWPrintNodePrinter.Delete(true);
            until SEWPrintNodePrinter.Next() = 0;
    end;

    local procedure ProcessPrinterPaper(JObjectPapers: JsonObject; PrinterId: Integer)
    var
        SEWPrintNodePaperSize: Record "SEW PrintNode Paper Size";
        TempSEWPrintNodePaperSize: Record "SEW PrintNode Paper Size" temporary;

        PapersizeList: List of [Text];
        JToken: JsonToken;
        JArray: JsonArray;
        i: Integer;
        PaperCode: Code[50];
        PaperName: Text[100];
        PaperDimension: Text[50];
        PapersizeWidth: Decimal;
        PapersizeHeight: Decimal;
    begin
        //save existing paper sizes
        SEWPrintNodePaperSize.Reset();
        SEWPrintNodePaperSize.SetRange("Printer ID", PrinterId);
        if SEWPrintNodePaperSize.FindSet() then
            repeat
                TempSEWPrintNodePaperSize := SEWPrintNodePaperSize;
                TempSEWPrintNodePaperSize.Insert(false);
            until SEWPrintNodePaperSize.Next() = 0;


        PapersizeList := JObjectPapers.Keys();

        for i := 1 to PapersizeList.Count() do begin
            Clear(PaperCode);
            Clear(PaperDimension);
            Clear(PapersizeWidth);
            Clear(PapersizeHeight);
            Clear(JToken);
            Clear(JArray);

            PaperCode := CopyStr(PapersizeList.Get(i), 1, 50);
            PaperName := CopyStr(PapersizeList.Get(i), 1, 100);

            JObjectPapers.Get(PapersizeList.Get(i), JToken);

            JArray := JToken.AsArray();
            Evaluate(PapersizeWidth, JArray.GetText(0));
            PapersizeWidth := PapersizeWidth / 10;
            Evaluate(PapersizeHeight, JArray.GetText(1));
            PapersizeHeight := PapersizeHeight / 10;
            PaperDimension := CopyStr(PapersizeWidth.ToText() + ' x ' + PapersizeHeight.ToText(), 1, 50);

            //Insert or Update Paper Size
            ProcessPrinterPapersize(PrinterId, PaperCode, PaperName, PaperDimension, PapersizeWidth, PapersizeHeight);

            //remove Paper Size from previous list
            if TempSEWPrintNodePaperSize.Get(PrinterId, PaperCode) then
                TempSEWPrintNodePaperSize.Delete(false);

        end;

        //remove unused and orphaned computer
        if TempSEWPrintNodePaperSize.FindSet() then
            repeat
                if SEWPrintNodePaperSize.Get(TempSEWPrintNodePaperSize."Printer ID", TempSEWPrintNodePaperSize."Code") then
                    SEWPrintNodePaperSize.Delete(true);
            until TempSEWPrintNodePaperSize.Next() = 0;

    end;

    local procedure ProcessPrinterPapersize(PrinterId: Integer; PaperCode: Code[50]; PaperName: Text[100]; PaperDimension: Text[50]; PaperWidth: Decimal; PaperHeight: Decimal)
    var
        SEWPrintNodePaperSize: Record "SEW PrintNode Paper Size";
    begin
        SEWPrintNodePaperSize.SetRange("Printer ID", PrinterId);
        SEWPrintNodePaperSize.SetRange("Code", PaperCode);
        if SEWPrintNodePaperSize.FindFirst() then begin
            SEWPrintNodePaperSize."Paper Name" := PaperName;
            SEWPrintNodePaperSize."Paper Dimension" := PaperDimension;
            SEWPrintNodePaperSize."Paper Width" := PaperWidth;
            SEWPrintNodePaperSize."Paper Height" := PaperHeight;
            if ProcessPrinterCheckEnum(PaperCode) <> 0 then
                SEWPrintNodePaperSize."System Paper Kind" := "Printer Paper Kind".FromInteger(ProcessPrinterCheckEnum(PaperCode));
            SEWPrintNodePaperSize.Modify(false);
        end else begin
            SEWPrintNodePaperSize.Init();
            SEWPrintNodePaperSize."Printer ID" := PrinterId;
            SEWPrintNodePaperSize."Code" := PaperCode;
            SEWPrintNodePaperSize."Paper Name" := PaperName;
            SEWPrintNodePaperSize."Paper Dimension" := PaperDimension;
            SEWPrintNodePaperSize."Paper Width" := PaperWidth;
            SEWPrintNodePaperSize."Paper Height" := PaperHeight;
            if ProcessPrinterCheckEnum(PaperCode) <> 0 then
                SEWPrintNodePaperSize."System Paper Kind" := "Printer Paper Kind".FromInteger(ProcessPrinterCheckEnum(PaperCode));
            SEWPrintNodePaperSize.Insert(false);
        end;
    end;

    local procedure ProcessPrinterCheckEnum(Papercode: Text[50]): Integer
    var
        i: Integer;
        Name: Text;
    begin
        if Enum::"Printer Paper Kind".Names().Contains(Papercode) then begin
            i := Enum::"Printer Paper Kind".Names().IndexOf(Papercode);
            Name := Enum::"Printer Paper Kind".Names().Get(i);
            if Name.ToUpper() = Papercode.ToUpper() then
                exit(Enum::"Printer Paper Kind".Ordinals().Get(i));
        end;
    end;


}

