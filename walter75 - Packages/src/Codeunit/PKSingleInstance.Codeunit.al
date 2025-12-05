

codeunit 90704 "SEW PK Single Instance"
{
    SingleInstance = true;


    Permissions = tabledata "Warehouse Activity Line" = rimd,
                  tabledata "Warehouse Activity Header" = rimd,
                  tabledata "SEW Packing Station" = rm,
                  tabledata "SEW PrintNode Scale" = r,
                  tabledata "SEW Parcel" = rimd;


    #region variables

    var
        WarehouseActivityHeader: Record "Warehouse Activity Header";
        SEWPackingStation: Record "SEW Packing Station";
        SEWParcel: Record "SEW Parcel";
        SEWPackingCardDialogQty: Page "SEW Packing Card Dialog Qty";
        SEWPackingCardDialogWeight: Page "SEW Packing Card Dialog Weight";

        IsInstanceRunning: Boolean;

        DlgInputQuantity: Integer;
        DlgPackageWeight: Decimal;
        ScanInput: Text;


    procedure SetInstanceRunning(Running: Boolean)
    begin
        IsInstanceRunning := Running;
    end;

    procedure GetInstanceRunning(): Boolean
    begin
        exit(IsInstanceRunning);
    end;
    #endregion


    #region Init Packing Station
    procedure StartPackingStation(xStationID: Integer)
    var
        MsgPickCompletedLbl: Label 'Ready. Please scan new document.';
        GetWarehouseHeaderSuccess: Boolean;
    begin
        Clear(WarehouseActivityHeader);
        Clear(SEWParcel);
        Clear(SEWPackingStation);

        SEWPackingStation.Get(xStationID);
        SEWPackingStation."Packing is Active" := true;
        SEWPackingStation."Cur. User ID" := UserSecurityId();
        SEWPackingStation.Modify(false);

        if SEWPackingStation."Cur. Warehouse Activity No." <> '' then
            GetWarehouseHeaderSuccess := GetWarehouseHeader(SEWPackingStation."Cur. Warehouse Activity No.");

        if not GetWarehouseHeaderSuccess then begin
            SEWPackingStation."Current Scan Action" := "SEW Scan Action"::"Scan Document";
            SEWPackingStation."Text Display" := Format(SEWPackingStation."Current Scan Action");
            SEWPackingStation."Text Last Scan" := CopyStr(MsgPickCompletedLbl, 1, MaxStrLen(SEWPackingStation."Text Last Scan"));
        end;
    end;

    procedure GetWarehouseHeader(xScanInput: Text): Boolean
    var
        ErrHeaderAssignedLbl: Label 'This document is assigned to another user.';
    begin
        //Check if Document is already assigned to another user
        Clear(WarehouseActivityHeader);
        WarehouseActivityHeader.SetRange("Type", "Warehouse Activity Type"::"Invt. Pick");
        WarehouseActivityHeader.SetRange("No.", xScanInput);
        if WarehouseActivityHeader.FindFirst() then begin

            case WarehouseActivityHeader."Assigned User ID" of
                '':
                    begin
                        WarehouseActivityHeader.Validate("Assigned User ID", UserId());
                        WarehouseActivityHeader.Modify(false);
                    end;

                UserId():
                    ; //Document is already assigned to current user, continue

                else begin
                    Clear(WarehouseActivityHeader);
                    Error(ErrHeaderAssignedLbl);
                end;
            end;

            SEWPackingStation."Cur. Warehouse Activity No." := WarehouseActivityHeader."No.";
            SEWPackingStation."Cur. Warenhouse Activity Type" := WarehouseActivityHeader."Type";
            SEWPackingStation.Modify(false);


            if WarehouseActivityHeader."SEW Current Parcel No." <> '' then begin
                if SEWParcel.Get(WarehouseActivityHeader."SEW Current Parcel No.") then
                    if WarehouseActivityHeader."SEW Current Package Material" <> '' then begin
                        SetScanAction("SEW Scan Action"::"Scan Item");
                        SetTextDisplayScanAction();
                    end else begin
                        SetScanAction("SEW Scan Action"::"Scan Package Material");
                        SetTextDisplayScanAction();
                    end;
            end else begin
                SetScanAction("SEW Scan Action"::"Create Package");
                SetTextDisplayScanAction();
            end;
        end;
        exit(true);
    end;

    procedure StopPackingStation()
    begin
        SEWPackingStation."Packing is Active" := false;
        Clear(SEWPackingStation."Cur. User ID");
        SEWPackingStation.Modify(false);

        if WarehouseActivityHeader."No." <> '' then begin
            Clear(WarehouseActivityHeader."Assigned User ID");
            WarehouseActivityHeader.Modify(false);
        end;
    end;

    procedure GetPackingIsActive(): Boolean
    begin
        exit(SEWPackingStation."Packing is Active");
    end;

    procedure GetPacketMaterialUsage(): Boolean
    begin
        exit(SEWPackingStation."Package Material Usage");
    end;

    procedure GetScaleUsage(): Boolean
    begin
        exit(SEWPackingStation."use Scale");
    end;

    procedure GetDeliveryNotePerParcel(): Boolean
    begin
        exit(SEWPackingStation."Delivery Note per Parcel");
    end;

    procedure GetSalesHeader(): Record "Sales Header"
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("No.", WarehouseActivityHeader."Source No.");
        if SalesHeader.FindFirst() then
            exit(SalesHeader);
    end;


    procedure ClearStation()
    begin
        Clear(WarehouseActivityHeader);
        Clear(SEWParcel);

        SEWPackingStation."Cur. Warehouse Activity No." := '';
        SEWPackingStation."Cur. Warenhouse Activity Type" := SEWPackingStation."Cur. Warenhouse Activity Type"::"Invt. Pick";
        SEWPackingStation."Current Scan Action" := "SEW Scan Action"::"Scan Document";
        SEWPackingStation."Text Display" := Format(SEWPackingStation."Current Scan Action");
        SEWPackingStation."Text Last Scan" := '';
        SEWPackingStation.Modify(false);
    end;

    procedure GetScacleWeight(): Boolean
    var
        SEWPrintNodeScale: Record "SEW PrintNode Scale";
        SEWPNRestRequests: Codeunit "SEW PN Rest Requests";
    begin
        SEWPrintNodeScale.SetRange("Scale ID", SEWPackingStation."Scale ID");
        if SEWPrintNodeScale.FindFirst() then
            DlgPackageWeight := SEWPNRestRequests.GetScaleValue(SEWPrintNodeScale."Computer ID", SEWPrintNodeScale."Scale Name") / 10000000;

        SEWParcel."Parcel Weight" := DlgPackageWeight;
        SEWParcel.Modify(false);
    end;

    #endregion



    #region Packing Station Values


    procedure SetScanInput(xScanInput: Text)
    begin
        ScanInput := xScanInput;
    end;

    procedure GetScanInput(): Text
    begin
        exit(ScanInput);
    end;

    procedure SetTextLastScan(xTextLastScan: Text[255])
    begin
        if WarehouseActivityHeader."No." <> '' then begin
            WarehouseActivityHeader."SEW Text Last Scan" := xTextLastScan;
            WarehouseActivityHeader.Modify(false);
        end else begin
            SEWPackingStation."Text Last Scan" := xTextLastScan;
            SEWPackingStation.Modify(false);
        end;
    end;

    procedure GetTextLastScan(): Text[255]
    begin
        if WarehouseActivityHeader."No." <> '' then
            exit(WarehouseActivityHeader."SEW Text Last Scan")
        else
            exit(SEWPackingStation."Text Last Scan");
    end;

    procedure SetTextDisplay(xTextDisplay: Text[255])
    begin
        if WarehouseActivityHeader."No." <> '' then begin
            WarehouseActivityHeader."SEW Text Display" := xTextDisplay;
            WarehouseActivityHeader.Modify(false);
        end else begin
            SEWPackingStation."Text Display" := xTextDisplay;
            SEWPackingStation.Modify(false);
        end;
    end;

    procedure SetTextDisplayScanAction()
    begin
        if WarehouseActivityHeader."No." <> '' then
            WarehouseActivityHeader."SEW Text Display" := Format(WarehouseActivityHeader."SEW Current Scan Action")
        else
            SEWPackingStation."Text Display" := Format(SEWPackingStation."Current Scan Action");
    end;

    procedure GetTextDisplay(): Text[255]
    begin
        if WarehouseActivityHeader."No." <> '' then
            exit(WarehouseActivityHeader."SEW Text Display")
        else
            exit(SEWPackingStation."Text Display");
    end;

    procedure SetScanAction(xSEWScanAction: Enum "SEW Scan Action")
    begin
        if WarehouseActivityHeader."No." <> '' then begin
            WarehouseActivityHeader."SEW Current Scan Action" := xSEWScanAction;
            WarehouseActivityHeader.Modify(false);
        end else begin
            SEWPackingStation."Current Scan Action" := xSEWScanAction;
            SEWPackingStation.Modify(false);
        end;
    end;

    procedure GetScanAction(): Enum "SEW Scan Action"
    begin
        if WarehouseActivityHeader."No." <> '' then
            exit(WarehouseActivityHeader."SEW Current Scan Action")
        else
            exit(SEWPackingStation."Current Scan Action");
    end;

    procedure SetLastShipmentNo(xLastShipmentNo: Code[20])
    begin
        SEWPackingStation."Last Shipment No." := xLastShipmentNo;
        SEWPackingStation.Modify(false);
    end;

    procedure GetLastShipmentNo(): Code[20]
    begin
        exit(SEWPackingStation."Last Shipment No.");
    end;

    procedure SetLastInvoiceNo(xLastInvoiceNo: Code[20])
    begin
        SEWPackingStation."Last Invoice No." := xLastInvoiceNo;
        SEWPackingStation.Modify(false);
    end;

    procedure GetLastInvoiceNo(): Code[20]
    begin
        exit(SEWPackingStation."Last Invoice No.");
    end;

    procedure SetCurrentPackageMaterial(xCurrentPackageMaterial: Code[10])
    begin
        WarehouseActivityHeader."SEW Current Package Material" := xCurrentPackageMaterial;
        WarehouseActivityHeader.Modify(false);
    end;

    procedure GetCurrentPackageMaterial(): Code[10]
    begin
        exit(WarehouseActivityHeader."SEW Current Package Material");
    end;

    procedure SetCurrentPackageMaterialDescription(xCurrentPackageMaterialDescription: Text[100])
    begin
        WarehouseActivityHeader."SEW Package Material Desc" := xCurrentPackageMaterialDescription;
        WarehouseActivityHeader.Modify(false);
    end;

    procedure GetCurrentPackageMaterialDescription(): Text[100]
    begin
        exit(WarehouseActivityHeader."SEW Package Material Desc");
    end;


    procedure GetWarehouseActivityHeaderNo(): Code[20]
    begin
        exit(SEWPackingStation."Cur. Warehouse Activity No.");
    end;

    procedure GetWarehouseActivityHeaderType(): Enum "Warehouse Activity Type"
    begin
        exit(SEWPackingStation."Cur. Warenhouse Activity Type");
    end;


    procedure SetCurrentParcelNo(xCurrentParcelNo: Code[20])
    begin
        WarehouseActivityHeader."SEW Current Parcel No." := xCurrentParcelNo;
        WarehouseActivityHeader.Modify(false);

        if WarehouseActivityHeader."SEW Current Parcel No." <> '' then
            if not SEWParcel.Get(xCurrentParcelNo) then begin
                WarehouseActivityHeader."SEW Current Parcel No." := '';
                WarehouseActivityHeader.Modify(false);
                Clear(SEWParcel);
            end;
    end;

    procedure GetCurrentParcelNo(): Code[20]
    begin
        exit(WarehouseActivityHeader."SEW Current Parcel No.");
    end;

    procedure GetCurrentParcelStatus(): Text[250]
    begin
        exit(WarehouseActivityHeader."SEW Current Parcel Status");
    end;

    procedure GetCurrentParcelTrackingNbr(): Text[50]
    begin
        exit(SEWParcel."SC Tracking Number")
    end;


    procedure GetCountLinesUnpacked(): Integer
    begin
        if WarehouseActivityHeader."No." = '' then
            exit(0);
        WarehouseActivityHeader.CalcFields("SEW Unpacked Count Lines");
        exit(WarehouseActivityHeader."SEW Unpacked Count Lines");
    end;

    procedure GetCountItemsUnpacked(): Decimal
    begin
        if WarehouseActivityHeader."No." = '' then
            exit(0);
        WarehouseActivityHeader.CalcFields("SEW Unpacked Count Items");
        exit(WarehouseActivityHeader."SEW Unpacked Count Items");
    end;


    #endregion

















    #region Dialog Item
    procedure DialogItemQuantity(xDlgItemNo: Code[20]; xDlgItemDescription: Text[100]; xDlgItemQty: Decimal)
    begin
        Clear(SEWPackingCardDialogQty);
        SEWPackingCardDialogQty.SetItemValues(xDlgItemNo, xDlgItemDescription, xDlgItemQty);
        if SEWPackingCardDialogQty.RunModal() = Action::OK then; //HandoverInputQuantity();
    end;

    procedure DialogItemQuantityClose()
    begin
        Clear(SEWPackingCardDialogQty);
    end;

    procedure DialogItemQuantitySet(InputQuantity: Integer)
    begin
        DlgInputQuantity := InputQuantity;
    end;

    procedure DialogItemQuantityGet(): Integer
    begin
        exit(DlgInputQuantity);
    end;
    #endregion


    #region Dialog weight
    procedure DialogPackageWeight()
    begin
        Clear(SEWPackingCardDialogWeight);
        SEWPackingCardDialogWeight.SetPackageValues();
        if SEWPackingCardDialogWeight.RunModal() = Action::OK then; //HandoverInputQuantity();
    end;

    procedure DialogPackageWeightClose()
    begin
        Clear(SEWPackingCardDialogWeight);
    end;

    procedure DialogPackageWeightSet(InputWeight: Decimal)
    begin
        DlgPackageWeight := InputWeight;
        SEWParcel."Parcel Weight" := InputWeight;
        SEWParcel.Modify(false);
    end;

    procedure DialogPackageWeightGet(): Decimal
    begin
        exit(DlgPackageWeight);
    end;
    #endregion


    #region Parcel Functions
    procedure CreateNewParcel(): Boolean
    begin
        Clear(SEWParcel);
        SEWParcel.Init();
        SEWParcel.Validate("Parcel No.");
        SEWParcel.Validate("Source Type", "SEW Shipment Source Type"::Warehouse);
        SEWParcel.Validate("Source Type Sub", "SEW Shipment Source Type Sub"::"Warehouse Pick");
        SEWParcel.Validate("Source No.", SEWPackingStation."Cur. Warehouse Activity No.");
        SEWParcel.Validate("Shipping Agent Service Code");
        if SEWParcel.Insert(false) then begin
            WarehouseActivityHeader."SEW Current Parcel No." := SEWParcel."Parcel No.";
            WarehouseActivityHeader.Modify(false);
        end;

        exit(true);
    end;

    procedure TryParcelCancel(): Boolean
    begin
        exit(SEWParcel.TryParcelCancel());
    end;

    procedure GetParcelStatusID(): Integer
    begin
        exit(SEWParcel."SC Status ID");
    end;


    procedure PostParceltoSendcloud(): Boolean
    var
        SEWSCRestRequests: Codeunit "SEW SC Rest Requests";
        Success: Boolean;
    begin
        Success := false;
        Success := SEWSCRestRequests.RequestParcelPost(SEWParcel, true);
        if Success then begin
            // This will reload the current Parcel with the SendCloud Values and Download the Label we requested
            SetCurrentParcelNo(GetCurrentParcelNo());
            SEWSCRestRequests.GetParcelLabel(SEWParcel);
        end;
        exit(Success);
    end;

    procedure PrintPacelLabel(): Boolean
    var
        SEWPNRestRequests: Codeunit "SEW PN Rest Requests";
        InStream: InStream;
        FileName: Text;
    begin
        SEWParcel.CalcFields("Label PDF");
        if SEWParcel."Label PDF".HasValue() then begin
            SEWParcel."Label PDF".CreateInStream(InStream);
            FileName := 'Label_' + SEWParcel."Parcel No." + '.pdf';
            SEWPNRestRequests.NewPrintJob(SEWPackingStation."Label PrinterID", InStream, FileName);
            exit(true);
        end else
            exit(false);
    end;

    procedure SetPacelHeightWidthLength(Height: Decimal; Width: Decimal; Length: Decimal)
    begin
        SEWParcel.Validate("Parcel Height", Height);
        SEWParcel.Validate("Parcel Width", Width);
        SEWParcel.Validate("Parcel Length", Length);
        SEWParcel.Modify(false);
    end;


    #endregion

}
