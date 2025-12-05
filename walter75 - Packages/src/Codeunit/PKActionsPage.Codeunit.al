codeunit 90703 "SEW PK Actions Page"
{
    Permissions = tabledata "Warehouse Activity Header" = rim,
                    tabledata "Warehouse Activity Line" = rim,
                    tabledata Item = r,
                    tabledata "Transfer Header" = r,
                    tabledata "Sales Header" = r,
                    tabledata "Sales Line" = r,
                    tabledata "Purchase Header" = r,
                    tabledata "SEW Package Setup" = r,
                    tabledata "SEW Package Material" = r,
                    tabledata "SEW Parcel" = rmi,
                    tabledata "Inventory Setup" = r,
                    tabledata "Customer" = r,
                    tabledata "Sales Shipment Header" = r,
                    tabledata "Sales Invoice Header" = r;

    var
        SEWPKSingleInstance: Codeunit "SEW PK Single Instance";


    /// <summary>
    /// Processes a scanned warehouse document number and loads the associated pick order lines.
    /// Validates that the scanned input matches the expected pick order number series format.
    /// </summary>
    /// <param name="xScanInput">The scanned barcode text from the warehouse document</param>
    /// <param name="WarehouseActivityLine">VAR: The warehouse activity line record that will be populated with document lines</param>
    /// <example>
    /// ActionScanDocument('WH-PICK-001', WarehouseActivityLine);
    /// </example>
    procedure ActionScanDocument(xScanInput: Text; var WarehouseActivityLine: Record "Warehouse Activity Line")
    var
        TextInvalidScanLbl: Label 'Ungültiger Scan: %1', Comment = 'Invalicd Scan: %1';
    begin
        // Handle Scan Document action
        if not xScanInput.StartsWith(GetNoSeriesPickOrders()) then begin
            SEWPKSingleInstance.SetTextLastScan(StrSubstNo(TextInvalidScanLbl, xScanInput));
            SEWPKSingleInstance.SetScanInput('');
            exit;
        end;

        //Check if Document is already assigned to another user
        SEWPKSingleInstance.GetWarehouseHeader(xScanInput);

        //Get the lines for the document
        WarehouseActivityLine.Reset();
        WarehouseActivityLine.SetRange("No.", SEWPKSingleInstance.GetWarehouseActivityHeaderNo());
        WarehouseActivityLine.SetRange("Activity Type", SEWPKSingleInstance.GetWarehouseActivityHeaderType());
        WarehouseActivityLine.FindSet(true);

        UpdateWeight(WarehouseActivityLine);

        SEWPKSingleInstance.SetTextLastScan('Warehouse Document: ' + xScanInput);
        SEWPKSingleInstance.SetScanInput('');

    end;

    /// <summary>
    /// Processes a scanned package material barcode and updates the current packing session with the material details.
    /// Retrieves package dimensions (height, width, length) and updates the scan action to move to item scanning.
    /// </summary>
    /// <param name="xScanInput">The scanned barcode text from the package material (e.g., box code)</param>
    /// <example>
    /// ActionScanPackageMaterial('BOX-M');
    /// </example>
    procedure ActionScanPackageMaterial(xScanInput: Text)
    var
        SEWPackageMaterial: Record "SEW Package Material";
    begin
        // Handle Scan Package Material action
        if xScanInput = '' then
            exit;
        if SEWPKSingleInstance.GetPacketMaterialUsage() = false then
            exit;

        SEWPackageMaterial.Reset();
        SEWPackageMaterial.SetRange(Code, CopyStr(xScanInput, 1, 10));
        if SEWPackageMaterial.FindFirst() then begin
            SEWPKSingleInstance.SetCurrentPackageMaterial(SEWPackageMaterial.Code);
            SEWPKSingleInstance.SetCurrentPackageMaterialDescription(SEWPackageMaterial.Description);
            SEWPKSingleInstance.SetPacelHeightWidthLength(SEWPackageMaterial."Height cm", SEWPackageMaterial."Width cm", SEWPackageMaterial."Length cm");
            SEWPKSingleInstance.SetScanAction("SEW Scan Action"::"Scan Item");
            SEWPKSingleInstance.SetTextDisplayScanAction();
            SEWPKSingleInstance.SetTextLastScan('Package Material: ' + xScanInput);
            SEWPKSingleInstance.SetScanInput('');
        end else begin
            SEWPKSingleInstance.SetTextLastScan('Package Material not found: ' + xScanInput);
            SEWPKSingleInstance.SetScanInput('');
        end;
    end;

    /// <summary>
    /// Processes a scanned item and assigns it to the current parcel with the specified quantity.
    /// Handles partial packing by splitting lines when needed, and updates item weights automatically.
    /// Shows a quantity dialog to confirm how many items should be packed into the current parcel.
    /// </summary>
    /// <param name="xScanInput">The scanned item number or barcode</param>
    /// <param name="WarehouseActivityLine">VAR: The warehouse activity line record containing items to pack</param>
    /// <example>
    /// ActionScanItem('ITEM-1000', WarehouseActivityLine);
    /// </example>
    procedure ActionScanItem(xScanInput: Text; var WarehouseActivityLine: Record "Warehouse Activity Line")
    var
        DlgInputQuantity: Integer;
    begin
        SetDocument(WarehouseActivityLine, true);

        // Handle Scan Item or Pack End action
        //Artikel prüfen, wenn vorhanden Menge abfragen und einfügen
        WarehouseActivityLine.SetRange("Item No.", xScanInput);
        WarehouseActivityLine.SetFilter("SEW Qty. to Pack", '>0');
        WarehouseActivityLine.SetFilter("SEW Qty. Packed", '=0');

        if WarehouseActivityLine.FindFirst() then
            SEWPKSingleInstance.DialogItemQuantity(WarehouseActivityLine."Item No.", WarehouseActivityLine.Description, WarehouseActivityLine."SEW Qty. to Pack");

        DlgInputQuantity := SEWPKSingleInstance.DialogItemQuantityGet();

        if WarehouseActivityLine."SEW Qty. to Pack" < DlgInputQuantity then begin
            if WarehouseActivityLine.Count() > 1 then
                Message('Falsche Menge, kann nicht mehr als ' + WarehouseActivityLine."SEW Qty. to Pack".ToText() + ' sein, da noch weitere Zeilen mit dieser Artikelnummer offen sind. Bitte die anderen Zeilen zuerst packen.');
            Message('Falsche Menge, kann nicht mehr als ' + WarehouseActivityLine."SEW Qty. to Pack".ToText());
            exit;
        end;

        //Not all Items are going into this pacel
        if WarehouseActivityLine."SEW Qty. to Pack" > DlgInputQuantity then begin
            WarehouseActivityLine.Validate("Qty. to Handle", DlgInputQuantity);
            WarehouseActivityLine.Validate("Qty. to Handle (Base)", DlgInputQuantity);

            WarehouseActivityLine.SplitLine(WarehouseActivityLine);

            WarehouseActivityLine.Validate("SEW Qty. Packed", DlgInputQuantity);
            WarehouseActivityLine.Validate("SEW Parcel No.", SEWPKSingleInstance.GetCurrentParcelNo());
            //WarehouseActivityLine.Validate("SEW CMS Shiptmentorder Status", SEWPKSingleInstance.GetCurrentShipmentOrderStatus());
            WarehouseActivityLine.Validate(Weight, WarehouseActivityLine."SEW Gross Weight Item kg" * DlgInputQuantity);

            WarehouseActivityLine.Modify(true);

            WarehouseActivityLine.Next();
            WarehouseActivityLine.Validate("Qty. to Handle", 0);
            WarehouseActivityLine.Validate("Qty. to Handle (Base)", 0);
            Clear(WarehouseActivityLine."SEW Qty. Packed");
            Clear(WarehouseActivityLine."SEW Parcel No.");
            //Clear(WarehouseActivityLine."SEW Parcel Status");
            WarehouseActivityLine.Modify(true);

        end else begin

            //All Items are going into this parcel
            WarehouseActivityLine.Validate("Qty. to Handle", DlgInputQuantity);
            WarehouseActivityLine.Validate("Qty. to Handle (Base)", DlgInputQuantity);
            WarehouseActivityLine.Validate("SEW Qty. Packed", DlgInputQuantity);
            WarehouseActivityLine.Validate("SEW Parcel No.", SEWPKSingleInstance.GetCurrentParcelNo());
            //WarehouseActivityLine.Validate("SEW CMS Shiptmentorder Status", SEWPKSingleInstance.GetCurrentShipmentOrderStatus());
            WarehouseActivityLine.Validate(Weight, WarehouseActivityLine."SEW Gross Weight Item kg" * DlgInputQuantity);
            WarehouseActivityLine.Modify(true);
        end;

        Commit();// Make sure the record is committed before continuing

        SEWPKSingleInstance.SetTextLastScan('Item: ' + xScanInput);
        SEWPKSingleInstance.SetScanInput('');

        SetDocument(WarehouseActivityLine, false);
    end;







    /// <summary>
    /// Clears the current packing station and resets the scan document state.
    /// Prepares the station for scanning a new warehouse document.
    /// </summary>
    /// <example>
    /// CmdDocScan();
    /// </example>
    procedure CmdDocScan()
    begin
        SEWPKSingleInstance.ClearStation();
    end;

    /// <summary>
    /// Clears all packing data from the current station and resets to initial state.
    /// Removes all parcels and unpacks all items from the current warehouse document.
    /// </summary>
    /// <example>
    /// CmdDocClear();
    /// </example>
    procedure CmdDocClear()
    begin
        SEWPKSingleInstance.ClearStation();
    end;

    /// <summary>
    /// Closes the current warehouse document and clears the packing station.
    /// Finalizes the packing session without posting the document.
    /// </summary>
    /// <example>
    /// CmdDocClose();
    /// </example>
    procedure CmdDocClose()
    begin
        SEWPKSingleInstance.ClearStation();
    end;

    /// <summary>
    /// Sets the scan action to item scanning mode and updates the display text accordingly.
    /// Used to manually switch to item scanning when not following the standard workflow.
    /// </summary>
    /// <example>
    /// CmdScanItem();
    /// </example>
    procedure CmdScanItem()
    begin
        SEWPKSingleInstance.SetScanAction("SEW Scan Action"::"Scan Item");
        SEWPKSingleInstance.SetTextDisplayScanAction();
        SEWPKSingleInstance.SetTextLastScan('Command: Scan Item');
    end;

    /// <summary>
    /// Moves the current line selection up by one position in the warehouse activity lines.
    /// Used for manual navigation through the pick order items.
    /// </summary>
    /// <param name="WarehouseActivityLine">VAR: The warehouse activity line to move up from</param>
    /// <example>
    /// CmdLineUp(WarehouseActivityLine);
    /// </example>
    procedure CmdLineUp(var WarehouseActivityLine: Record "Warehouse Activity Line")
    begin
        WarehouseActivityLine.Next(-1);
        SEWPKSingleInstance.SetTextLastScan('Command: Line Up to: ' + WarehouseActivityLine."Line No.".ToText());
    end;

    /// <summary>
    /// Moves the current line selection down by one position in the warehouse activity lines.
    /// Used for manual navigation through the pick order items.
    /// </summary>
    /// <param name="WarehouseActivityLine">VAR: The warehouse activity line to move down from</param>
    /// <example>
    /// CmdLineDown(WarehouseActivityLine);
    /// </example>
    procedure CmdLineDown(var WarehouseActivityLine: Record "Warehouse Activity Line")
    begin
        WarehouseActivityLine.Next(+1);
        SEWPKSingleInstance.SetTextLastScan('Command: Line Down to: ' + WarehouseActivityLine."Line No.".ToText());
    end;

    /// <summary>
    /// Packs the selected warehouse activity line item into the current parcel.
    /// Validates that a parcel exists before packing and triggers the item scanning workflow.
    /// </summary>
    /// <param name="WarehouseActivityLine">VAR: The warehouse activity line to pack</param>
    /// <example>
    /// CmdLinePack(WarehouseActivityLine);
    /// </example>
    procedure CmdLinePack(var WarehouseActivityLine: Record "Warehouse Activity Line")
    begin
        if SEWPKSingleInstance.GetCurrentParcelNo() = '' then begin
            Message('Bitte zuerst ein Paket anlegen.');
            exit;
        end;

        SEWPKSingleInstance.SetScanAction("SEW Scan Action"::"Scan Item");
        SEWPKSingleInstance.SetTextDisplayScanAction();
        ActionScanItem(WarehouseActivityLine."Item No.", WarehouseActivityLine);
    end;

    /// <summary>
    /// Unpacks the selected warehouse activity line, removing it from its assigned parcel.
    /// Resets the packed quantity and parcel assignment for the line.
    /// </summary>
    /// <param name="WarehouseActivityLine">VAR: The warehouse activity line to unpack</param>
    /// <example>
    /// CmdLineUnpack(WarehouseActivityLine);
    /// </example>
    procedure CmdLineUnpack(var WarehouseActivityLine: Record "Warehouse Activity Line")
    begin

        ItemUnpack(WarehouseActivityLine);
    end;


    /// <summary>
    /// Deletes the parcel associated with the selected warehouse activity line.
    /// Unpacks all items from the parcel before deletion and resets the current parcel reference.
    /// </summary>
    /// <param name="WarehouseActivityLine">VAR: The warehouse activity line whose parcel should be deleted</param>
    /// <example>
    /// CmdPackageDelete(WarehouseActivityLine);
    /// </example>
    procedure CmdPackageDelete(var WarehouseActivityLine: Record "Warehouse Activity Line")
    var
    begin
        if WarehouseActivityLine."SEW Parcel No." = '' then
            exit;
        SEWPKSingleInstance.SetCurrentParcelNo(WarehouseActivityLine."SEW Parcel No.");

        if SEWPKSingleInstance.TryParcelCancel() = true then begin
            repeat
                if WarehouseActivityLine."SEW Parcel No." = SEWPKSingleInstance.GetCurrentParcelNo() then
                    ItemUnpack(WarehouseActivityLine);
            until WarehouseActivityLine.Next() = 0;

            SEWPKSingleInstance.SetCurrentParcelNo('');
            exit;
        end else begin
            Message('Fehler beim Stornieren des Pakets in Sendcloud.');
            SEWPKSingleInstance.SetCurrentParcelNo('');
        end;
    end;

    /// <summary>
    /// Clears all items from a parcel without deleting the parcel itself.
    /// Unpacks all warehouse activity lines associated with the specified parcel.
    /// </summary>
    /// <param name="WarehouseActivityLine">VAR: The warehouse activity line whose parcel should be cleared</param>
    /// <example>
    /// CmdPackageClear(WarehouseActivityLine);
    /// </example>
    procedure CmdPackageClear(var WarehouseActivityLine: Record "Warehouse Activity Line")
    begin
        if WarehouseActivityLine."SEW Parcel No." = '' then
            exit;
        SEWPKSingleInstance.SetCurrentParcelNo(WarehouseActivityLine."SEW Parcel No.");

        repeat
            if WarehouseActivityLine."SEW Parcel No." = SEWPKSingleInstance.GetCurrentParcelNo() then
                ItemUnpack(WarehouseActivityLine);
        until WarehouseActivityLine.Next() = 0;
    end;

    /// <summary>
    /// Posts the current package and finalizes the warehouse activity.
    /// Currently not implemented - placeholder for future functionality.
    /// </summary>
    /// <example>
    /// CmdPackagePost();
    /// </example>
    procedure CmdPackagePost()
    begin
        Message('Post Package not implemented yet');
    end;


    /// <summary>
    /// Prints the delivery note for the current package.
    /// Currently not implemented - placeholder for future functionality.
    /// </summary>
    /// <example>
    /// CmdPackagePrintDelNote();
    /// </example>
    procedure CmdPackagePrintDelNote()
    begin
        Message('Print Delivery Note not implemented yet');
    end;

    /// <summary>
    /// Prints the packing list showing all items in the current package.
    /// Currently not implemented - placeholder for future functionality.
    /// </summary>
    /// <example>
    /// CmdPackagePrintPackingList();
    /// </example>
    procedure CmdPackagePrintPackingList()
    begin
        Message('Print Packing List not implemented yet');
    end;

    procedure CmdPackagePostAndPrint()
    begin
        Message('Post and Print not implemented yet');
    end;

    procedure CmdDocPost()
    begin
        Message('Post not implemented yet');
    end;

    procedure CmdDocPrintDelNote()
    begin
        Message('Print Delivery Note not implemented yet');
    end;

    procedure CmdDocPostAndPrint()
    begin
        Message('Post and Print not implemented yet');
    end;

    procedure CmdDocPrintInvoice()
    begin
        Message('Print Packing List not implemented yet');
    end;

    /// <summary>
    /// Creates a new parcel for the current packing session and sets the appropriate scan action.
    /// If package material usage is enabled, prompts for material scanning; otherwise moves to item scanning.
    /// </summary>
    /// <returns>True if parcel creation succeeds, false otherwise</returns>
    /// <example>
    /// CmdPackageNew();
    /// </example>
    procedure CmdPackageNew()
    begin
        if not SEWPKSingleInstance.CreateNewParcel() then begin
            Message('Error creating new package.');
            exit;
        end;

        if SEWPKSingleInstance.GetPacketMaterialUsage() then
            SEWPKSingleInstance.SetScanAction("SEW Scan Action"::"Scan Package Material")
        else
            SEWPKSingleInstance.SetScanAction("SEW Scan Action"::"Scan Item");

        SEWPKSingleInstance.SetTextDisplayScanAction();
        SEWPKSingleInstance.SetTextLastScan('Command: Create New Package');
        SEWPKSingleInstance.SetScanInput('');
    end;

    /// <summary>
    /// Prints the shipping label for the selected parcel using PrintNode integration.
    /// Prompts for package weight if not set, updates parcel dimensions, and sends print job to configured printer.
    /// </summary>
    /// <param name="WarehouseActivityLine">VAR: The warehouse activity line containing the parcel reference</param>
    /// <example>
    /// CmdPackagePrintLabel(WarehouseActivityLine);
    /// </example>
    procedure CmdPackagePrintLabel()
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SEWParcel: Record "SEW Parcel";
        ConfirmManagement: Codeunit "Confirm Management";
        DlgPackageWeight: Decimal;

    begin
        Commit(); // Make sure all records are committed before continuing


        //Gewicht abfragen
        if SEWPKSingleInstance.GetScaleUsage() = false then begin

            SEWPKSingleInstance.DialogPackageWeight();

            DlgPackageWeight := SEWPKSingleInstance.DialogPackageWeightGet();
            if DlgPackageWeight <= 0 then begin
                Message('Falsches Gewicht, muss größer als 0 sein.');
                exit;
            end;
        end else
            SEWPKSingleInstance.GetScacleWeight();

        // Paket an Sendcloud senden
        if SEWPKSingleInstance.PostParceltoSendcloud() = false then begin
            Message('Fehler beim Senden des Pakets an Sendcloud.');
            exit;
        end;

        //Print Label
        if SEWPKSingleInstance.PrintPacelLabel() = false then begin
            Message('Fehler beim Drucken des Versandetiketts.');
            exit;
        end;


        // Labeldruck OK?
        if not ConfirmManagement.GetResponse('Labeldruck OK?', true) then
            // Paket wieder stornieren....
            if SEWPKSingleInstance.PrintPacelLabel() = false then begin
                Message('Fehler beim Drucken des Versandetiketts.');
                exit;
            end;


        // depending on the Station Setting we post immeadiately or after all Lines are processed 
        if SEWPKSingleInstance.GetDeliveryNotePerParcel() then
            PostPerParcel()
        else
            PostPerPick();
    end;


    local procedure PostPerParcel()
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        WarehouseActivityLine: Record "Warehouse Activity Line";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SEWParcel: Record "SEW Parcel";
        ConfirmManagement: Codeunit "Confirm Management";
        DlgPackageWeight: Decimal;
    begin
        // Get all Lines from the current Picking Document, already posted Lines are not there anymore
        WarehouseActivityLine.Reset();
        WarehouseActivityLine.SetRange("Activity Type", WarehouseActivityLine."Activity Type"::"Invt. Pick");
        WarehouseActivityLine.SetRange("No.", SEWPKSingleInstance.GetWarehouseActivityHeaderNo());

        //Now Post the Pick Order, Posting Mode (Delivery) is already set in "SEW PK Event Subs"
        PostPickYesNo();

        //Print Delivery Note
        SalesShipmentHeader.Reset();
        SalesShipmentHeader.SetRange("No.", SEWPKSingleInstance.GetLastShipmentNo());
        if SalesShipmentHeader.FindFirst() then begin
            // Since we have 1 Parcel per Delivery Note we can Update the Parcel with the Tracking Number so that the BC-Function Tracking will work.
            SalesShipmentHeader."Package Tracking No." := SEWPKSingleInstance.GetCurrentParcelTrackingNbr();
            SalesShipmentHeader.Modify(false);
            SalesShipmentHeader.PrintRecords(false);
        end;

        // when we print Delivery notes per parcel we have to post the invoice true the sales header,
        // as the warehouse header is after posting all lines moved to the posted table.
        //Posting with warehouse header only works when posting all lines at once.

        //Check if all Lines are Posted and the document is completely shipped
        WarehouseActivityLine.Reset();
        WarehouseActivityLine.SetRange("Activity Type", WarehouseActivityLine."Activity Type"::"Invt. Pick");
        WarehouseActivityLine.SetRange("No.", SEWPKSingleInstance.GetWarehouseActivityHeaderNo());
        if WarehouseActivityLine.IsEmpty() then begin
            SalesHeader := SEWPKSingleInstance.GetSalesHeader();
            SalesHeader.SendToPosting(81); //codeunit 81 "Sales-Post (Yes/No)"

            // Now lets print/send the Invoice
            SalesInvoiceHeader.Reset();
            SalesInvoiceHeader.SetRange("No.", SEWPKSingleInstance.GetLastInvoiceNo());
            if SalesInvoiceHeader.FindFirst() then
                if CheckCustomerSendingProfile(SalesInvoiceHeader) = true then
                    SalesInvoiceHeader.SendRecords()
                else
                    SalesInvoiceHeader.PrintRecords(false);

        end;


    end;

    local procedure PostPerPick()
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        WarehouseActivityLine: Record "Warehouse Activity Line";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SEWParcel: Record "SEW Parcel";
        ConfirmManagement: Codeunit "Confirm Management";
        DlgPackageWeight: Decimal;

    begin
        // Alles gepackt? 
        WarehouseActivityLine.Reset();
        WarehouseActivityLine.SetRange("Activity Type", WarehouseActivityLine."Activity Type"::"Invt. Pick");
        WarehouseActivityLine.SetRange("No.", SEWPKSingleInstance.GetWarehouseActivityHeaderNo());
        WarehouseActivityLine.SetFilter("SEW Qty. to Pack", '>0');
        WarehouseActivityLine.SetFilter("SEW Qty. Packed", '=0');
        if WarehouseActivityLine.IsEmpty() then begin
            // JA: Kommissionierung buchen, Lieferschein drucken, Rechnung drucken (optional)
            PostPickYesNo();

            //Print Delivery Note
            SalesShipmentHeader.Reset();
            SalesShipmentHeader.SetRange("No.", SEWPKSingleInstance.GetLastShipmentNo());
            if SalesShipmentHeader.FindFirst() then
                SalesShipmentHeader.PrintRecords(false);

            //Process Invoice
            SalesInvoiceHeader.Reset();
            SalesInvoiceHeader.SetRange("No.", SEWPKSingleInstance.GetLastInvoiceNo());
            if SalesInvoiceHeader.FindFirst() then
                if CheckCustomerSendingProfile(SalesInvoiceHeader) = true then
                    SalesInvoiceHeader.SendRecords()
                else
                    SalesInvoiceHeader.PrintRecords(false);

            //Update Pacel Source Document
            SEWParcel.Reset();
            SEWParcel.SetRange("Source Type", SEWParcel."Source Type"::"Warehouse");
            SEWParcel.SetRange("Source Type Sub", SEWParcel."Source Type Sub"::"Warehouse Pick");

            SEWParcel.SetRange("Source No.", SEWPKSingleInstance.GetWarehouseActivityHeaderNo());
            if SEWParcel.FindSet() then
                repeat
                    SEWParcel."Source Type Sub" := SEWParcel."Source Type Sub"::"Warehouse Pick Posted";
                    SEWParcel.Modify(false);
                until SEWParcel.Next() = 0;



            SEWPKSingleInstance.ClearStation();

            Message('Posting completed');

        end else begin
            // Nein: Current Shipment auf Null setzen, Scan Action auf Scan Document setzen
            SEWPKSingleInstance.SetCurrentParcelNo('');
            SEWPKSingleInstance.SetScanAction("SEW Scan Action"::"Create Package");
            SEWPKSingleInstance.SetTextDisplayScanAction();
            SEWPKSingleInstance.SetTextLastScan('Please continue packing.');
        end;
    end;

    local procedure CheckCustomerSendingProfile(var SalesInvoiceHeader: Record "Sales Invoice Header"): Boolean
    var
        Customer: Record Customer;
        ErrCustomerNotFoundLbl: Label 'Customer not found.';
    begin
        Customer.Reset();
        Customer.SetRange("No.", SalesInvoiceHeader."Bill-to Customer No.");
        if not Customer.FindFirst() then
            Error(ErrCustomerNotFoundLbl);

        if Customer."Document Sending Profile" = '' then
            exit(false);

        exit(true);
    end;

    local procedure PostPickYesNo()
    var
        WarehouseActivityLine: Record "Warehouse Activity Line";
        WhseActPostYesNo: Codeunit "Whse.-Act.-Post (Yes/No)";
    begin
        WarehouseActivityLine.SetRange("Activity Type", WarehouseActivityLine."Activity Type"::"Invt. Pick");
        WarehouseActivityLine.SetRange("No.", SEWPKSingleInstance.GetWarehouseActivityHeaderNo());
        WarehouseActivityLine.FindSet();

        WhseActPostYesNo.Run(WarehouseActivityLine);
    end;

    local procedure UpdateWeight(var WarehouseActivityLine: Record "Warehouse Activity Line")
    var
        SalesLine: Record "Sales Line";
    begin
        if WarehouseActivityLine.FindFirst() then; //Damit der Filter greift
        repeat
            if WarehouseActivityLine."Source Document" = "Warehouse Activity Source Document"::"Sales Order" then begin
                SalesLine.Reset();
                SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                SalesLine.SetRange("Document No.", WarehouseActivityLine."Source No.");
                SalesLine.SetRange("Line No.", WarehouseActivityLine."Source Line No.");
                if SalesLine.FindFirst() then
                    if WarehouseActivityLine."SEW Gross Weight Item kg" <> SalesLine."Gross Weight" then begin
                        WarehouseActivityLine."SEW Gross Weight Item kg" := SalesLine."Gross Weight";
                        WarehouseActivityLine.Modify(false);
                    end;
            end;
        until WarehouseActivityLine.Next() = 0;
    end;


    procedure SetDocument(var WarehouseActivityLine: Record "Warehouse Activity Line"; withCommit: Boolean)
    begin
        if SEWPKSingleInstance.GetWarehouseActivityHeaderNo() = '' then begin
            WarehouseActivityLine.Reset();
            WarehouseActivityLine.SetFilter("No.", '=%1', '');
            exit;
        end;

        WarehouseActivityLine.Reset();
        WarehouseActivityLine.SetRange("No.", SEWPKSingleInstance.GetWarehouseActivityHeaderNo());
        WarehouseActivityLine.SetRange("Activity Type", SEWPKSingleInstance.GetWarehouseActivityHeaderType());
        WarehouseActivityLine.FindSet(true);

        if withCommit then
            Commit(); // Make sure the record is committed before continuing
    end;



    procedure ItemUnpack(var WarehouseActivityLine: Record "Warehouse Activity Line")
    begin
        if WarehouseActivityLine."SEW Qty. Packed" = 0 then begin
            Message('Diese Zeile ist nicht verpackt.');
            exit;
        end;

        //Unpack the whole line
        WarehouseActivityLine.Validate("SEW Qty. to Pack", WarehouseActivityLine."SEW Qty. to Pack" + WarehouseActivityLine."SEW Qty. Packed");
        WarehouseActivityLine.Validate("Qty. to Handle", WarehouseActivityLine."Qty. to Handle" - WarehouseActivityLine."SEW Qty. Packed");
        Clear(WarehouseActivityLine."SEW Qty. Packed");
        Clear(WarehouseActivityLine."SEW Parcel No.");
        WarehouseActivityLine.Modify(true);
        exit;

    end;



    procedure GetNoSeriesPickOrders(): Text
    var
        InventorySetup: Record "Inventory Setup";
        NoSeries: Codeunit "No. Series";
        ErrInventorySetupNotFoundLbl: Label 'Inventory Setup not found.';
    begin
        if not InventorySetup.Get() then
            Error(ErrInventorySetupNotFoundLbl);
        exit(DelChr(NoSeries.PeekNextNo(InventorySetup."Inventory Pick Nos."), '=', '0123456789'));
    end;


    procedure GetShipmentNofromSalesOrder(xSalesOrderNo: Code[20]): Code[20]
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("No.", xSalesOrderNo);
        if SalesHeader.FindFirst() then
            exit(SalesHeader."Last Shipping No.");
        exit('');
    end;

    procedure GetInvoiceNofromSalesOrder(xSalesOrderNo: Code[20]): Code[20]
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("No.", xSalesOrderNo);
        if SalesHeader.FindFirst() then
            exit(SalesHeader."Last Posting No.");
        exit('');
    end;

    procedure PrintCommands()
    var
        SEWPackageMaterial: Record "SEW Package Material";
    begin
        if SEWPackageMaterial.FindSet() then
            Report.RunModal(Report::"SEW Packing Scan Commands", false, true, SEWPackageMaterial);
    end;








}
