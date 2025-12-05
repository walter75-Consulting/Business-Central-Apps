codeunit 90600 "SEW BDE Terminal"
{

    procedure BDETerminalToRoutingLine()
    var
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        SEWBDETerminalCenter: Record "SEW BDE Terminal Center";
    begin
        ProdOrderRoutingLine.Reset();
        //ProdOrderRoutingLine.SetRange("Status", "Production Order Status"::"Firm Planned");
        if ProdOrderRoutingLine.FindSet(true) then
            repeat
                SEWBDETerminalCenter.Reset();
                SEWBDETerminalCenter.SetRange("Type", ProdOrderRoutingLine.Type);
                SEWBDETerminalCenter.SetRange("No.", ProdOrderRoutingLine."No.");
                if SEWBDETerminalCenter.FindFirst() then
                    ProdOrderRoutingLine."SEW BDE Terminal Code" := SEWBDETerminalCenter."Terminal Code";
                ProdOrderRoutingLine."SEW BDE Rout. Line Plan Status" := "SEW BDE Rout. Line Plan Status"::"in Time";
                ProdOrderRoutingLine."SEW BDE Rout. Line Status" := "SEW BDE Rout. Line Status"::"not Started";
                ProdOrderRoutingLine.Modify(false);

            until ProdOrderRoutingLine.Next() = 0;

    end;

    procedure ActionStart(LineStatus: Enum "SEW BDE Rout. Line Status";
                          ProdOrderRoutingLine: Record "Prod. Order Routing Line";
                          xUserStart: Code[20];
                          xComment: Text[255];
                          xTerminalCode: Code[10])
    var
        SEWBDEBooking: Record "SEW BDE Booking";
        ProdOrderLine: Record "Prod. Order Line";
    begin
        SEWBDEBooking.Init();
        SEWBDEBooking."Prod. Order No." := ProdOrderRoutingLine."Prod. Order No.";
        SEWBDEBooking."Operation No." := ProdOrderRoutingLine."Operation No.";
        SEWBDEBooking.Type := ProdOrderRoutingLine.Type;
        SEWBDEBooking."No." := ProdOrderRoutingLine."No.";
        SEWBDEBooking."Routing No." := ProdOrderRoutingLine."Routing No.";
        SEWBDEBooking."Routing Reference No." := ProdOrderRoutingLine."Routing Reference No.";

        ProdOrderLine.Reset();
        ProdOrderLine.SetRange("Prod. Order No.", ProdOrderRoutingLine."Prod. Order No.");
        ProdOrderLine.SetRange("Line No.", ProdOrderRoutingLine."Routing Reference No.");
        if ProdOrderLine.FindFirst() then begin
            SEWBDEBooking."Item No." := ProdOrderLine."Item No.";
            SEWBDEBooking."Variant Code" := ProdOrderLine."Variant Code";
            SEWBDEBooking."Unit of Measure Code" := ProdOrderLine."Unit of Measure Code";
        end;

        SEWBDEBooking."Starting Date/Time" := CurrentDateTime();
        SEWBDEBooking."Starting Date" := DT2Date(SEWBDEBooking."Starting Date/Time");
        SEWBDEBooking."Starting Time" := DT2Time(SEWBDEBooking."Starting Date/Time");

        SEWBDEBooking."User Start" := xUserStart;
        SEWBDEBooking."Comment Start" := xComment;
        SEWBDEBooking."BDE Rout. Line Status Start" := LineStatus;
        SEWBDEBooking.Processed := false;
        SEWBDEBooking."Terminal Code" := xTerminalCode;
        SEWBDEBooking.Insert(false);

        ProdOrderRoutingLine."SEW BDE Rout. Line Status" := LineStatus;
        ProdOrderRoutingLine.Modify(false);
    end;

    procedure ActionStop(LineStatus: Enum "SEW BDE Rout. Line Status";
                         ProdOrderRoutingLine: Record "Prod. Order Routing Line";
                         xUserStop: Code[20];
                         xComment: Text[255];
                         xOutputQuantity: Decimal;
                         xScrapQuantity: Decimal;
                         xScrapCode: Code[10];
                         xFinish: Boolean)
    var
        SEWBDEBooking: Record "SEW BDE Booking";
        Duration: Duration;
    begin
        SEWBDEBooking.Reset();
        SEWBDEBooking.SetRange("Prod. Order No.", ProdOrderRoutingLine."Prod. Order No.");
        SEWBDEBooking.SetRange("Operation No.", ProdOrderRoutingLine."Operation No.");
        SEWBDEBooking.SetRange("BDE Rout. Line Status Start", ProdOrderRoutingLine."SEW BDE Rout. Line Status");
        if SEWBDEBooking.FindFirst() then begin
            SEWBDEBooking."Ending Date/Time" := CurrentDateTime();
            SEWBDEBooking."Ending Date" := DT2Date(SEWBDEBooking."Ending Date/Time");
            SEWBDEBooking."Ending Time" := DT2Time(SEWBDEBooking."Ending Date/Time");
            SEWBDEBooking."User Stop" := xUserStop;
            SEWBDEBooking."Comment Start" := xComment;

            Duration := SEWBDEBooking."Ending Date/Time" - SEWBDEBooking."Starting Date/Time";
            SEWBDEBooking."Duration Minutes" := Round(Duration / 60000, 1, '=');

            SEWBDEBooking."Output Quantity" := xOutputQuantity;
            SEWBDEBooking."Scrap Quantity" := xScrapQuantity;
            SEWBDEBooking."Scrap Code" := xScrapCode;

            SEWBDEBooking.Finished := xFinish;
            SEWBDEBooking."BDE Rout. Line Status Stop" := LineStatus;

            SEWBDEBooking.Modify(false);

            ProdOrderRoutingLine."SEW BDE Rout. Line Status" := LineStatus;
            ProdOrderRoutingLine.Modify(false);
        end;
    end;


    procedure BDETransfertoItemJournal()
    var
        SEWBDEBooking: Record "SEW BDE Booking";
        SEWBDETerminal: Record "SEW BDE Terminal";
        ItemJournalLine: Record "Item Journal Line";

    begin
        SEWBDEBooking.Reset();
        SEWBDEBooking.SetRange("Processed", false);
        SEWBDEBooking.SetFilter("Ending Date", '<>%1', 0D);
        if SEWBDEBooking.FindSet() then
            repeat
                ItemJournalLine.Init();

                SEWBDETerminal.Reset();
                SEWBDETerminal.SetRange("Code", SEWBDEBooking."Terminal Code");
                if not SEWBDETerminal.FindFirst() then
                    Error('No Template');

                ItemJournalLine.Validate("Journal Template Name", SEWBDETerminal."Journal Template Name");
                ItemJournalLine.Validate("Journal Batch Name", SEWBDETerminal."Journal Batch Name");

                ItemJournalLine."Line No." := SEWBDEBooking.BookingID;

                ItemJournalLine.Validate("Posting Date", SEWBDEBooking."Ending Date");

                ItemJournalLine.Validate("Entry Type", ItemJournalLine."Entry Type"::Output);
                ItemJournalLine.Validate("Order No.", SEWBDEBooking."Prod. Order No.");
                ItemJournalLine.Validate("Order Line No.", SEWBDEBooking."Order Line No.");
                ItemJournalLine.Validate("Item No.", SEWBDEBooking."Item No.");
                ItemJournalLine.Validate("Variant Code", SEWBDEBooking."Variant Code");
                ItemJournalLine.Validate("Location Code", '');
                ItemJournalLine.Validate("Routing No.", SEWBDEBooking."Routing No.");
                ItemJournalLine.Validate("Routing Reference No.", SEWBDEBooking."Routing Reference No.");
                ItemJournalLine.Validate("Operation No.", SEWBDEBooking."Operation No.");
                ItemJournalLine.Validate("Unit of Measure Code", SEWBDEBooking."Unit of Measure Code");

                ItemJournalLine.Validate("Starting Time", SEWBDEBooking."Starting Time");
                ItemJournalLine.Validate("Ending Time", SEWBDEBooking."Ending Time");

                if SEWBDEBooking."BDE Rout. Line Status Start" = "SEW BDE Rout. Line Status"::"Start Setup" then
                    ItemJournalLine.Validate("Setup Time", SEWBDEBooking."Duration Minutes");

                if SEWBDEBooking."BDE Rout. Line Status Start" = "SEW BDE Rout. Line Status"::"Start Production" then
                    ItemJournalLine.Validate("Run Time", SEWBDEBooking."Duration Minutes");

                if SEWBDEBooking."BDE Rout. Line Status Start" = "SEW BDE Rout. Line Status"::"Start Malfunction" then begin
                    ItemJournalLine.Validate("Stop Time", SEWBDEBooking."Duration Minutes");
                    ItemJournalLine.Validate("Stop Code", SEWBDETerminal."Stop Code Malfunction");
                end;

                if SEWBDEBooking."BDE Rout. Line Status Start" = "SEW BDE Rout. Line Status"::"Start Pause" then begin
                    ItemJournalLine.Validate("Stop Time", SEWBDEBooking."Duration Minutes");
                    ItemJournalLine.Validate("Stop Code", SEWBDETerminal."Stop Code Pause");
                end;

                ItemJournalLine.Validate("Output Quantity", SEWBDEBooking."Output Quantity");

                ItemJournalLine.Validate("Scrap Quantity", SEWBDEBooking."Scrap Quantity");
                ItemJournalLine.Validate("Scrap Code", SEWBDEBooking."Scrap Code");

                ItemJournalLine.Validate("Finished", SEWBDEBooking.Finished);

                ItemJournalLine.Insert(true);

                //ItemJournalLine.PostingItemJnlFromProduction(false);

                SEWBDEBooking.Processed := true;
                SEWBDEBooking.Modify(false);

                ItemJournalLine.Reset();


            until SEWBDEBooking.Next() = 0;


    end;



}