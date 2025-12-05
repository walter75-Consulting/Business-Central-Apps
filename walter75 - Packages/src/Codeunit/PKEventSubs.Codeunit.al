codeunit 90702 "SEW PK Event Subs"
{
    var
        SEWPKSingleInstance: Codeunit "SEW PK Single Instance";


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Act.-Post (Yes/No)", OnBeforeConfirmPost, '', false, false)]
    local procedure OnBeforeConfirmPost(var WhseActivLine: Record "Warehouse Activity Line"; var HideDialog: Boolean; var Selection: Integer; var DefaultOption: Integer; var IsHandled: Boolean; var PrintDoc: Boolean)
    begin
        if SEWPKSingleInstance.GetPackingIsActive() = false then
            exit;

        if SEWPKSingleInstance.GetDeliveryNotePerParcel() then begin
            Selection := 1;
            DefaultOption := 1;
        end else begin
            Selection := 2;
            DefaultOption := 2;
        end;

        HideDialog := true;

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Post", OnAfterPostWhseActivHeader, '', false, false)]
    local procedure OnAfterPostWhseActivHeader(WhseActivHeader: Record "Warehouse Activity Header"; var PurchaseHeader: Record "Purchase Header"; var SalesHeader: Record "Sales Header"; var TransferHeader: Record "Transfer Header")
    begin
        //OnAfterPostWhseActivHeader
        //codeunit 7322 "Whse.-Activity-Post"

        SEWPKSingleInstance.SetLastShipmentNo(SalesHeader."Last Shipping No.");
        SEWPKSingleInstance.SetLastInvoiceNo(SalesHeader."Last Posting No.");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Sending Profile", OnBeforeCheckShowProfileSelectionMethodDialog, '', false, false)]
    local procedure OnBeforeCheckShowProfileSelectionMethodDialog(var ProfileSelectionMethod: Option ConfirmDefault,ConfirmPerEach,UseDefault; AccountNo: Code[20]; IsCustomer: Boolean; var Result: Boolean; var IsHandled: Boolean)
    begin
        if SEWPKSingleInstance.GetPackingIsActive() = false then
            exit;
        ProfileSelectionMethod := ProfileSelectionMethod::UseDefault;
        Result := true;
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Sending Profile", OnSendCustomerRecordsOnBeforeLookupProfile, '', false, false)]
    local procedure OnSendCustomerRecordsOnBeforeLookupProfile(ReportUsage: Integer; RecordVariant: Variant; CustomerNo: Code[20]; var RecRefToSend: RecordRef; SingleCustomerSelected: Boolean; var ShowDialog: Boolean)
    begin
        if SEWPKSingleInstance.GetPackingIsActive() = false then
            exit;
        ShowDialog := false;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", OnBeforeConfirmSalesPost, '', false, false)]
    local procedure OnBeforeConfirmSalesPost(var SalesHeader: Record "Sales Header"; var HideDialog: Boolean; var IsHandled: Boolean; var DefaultOption: Integer; var PostAndSend: Boolean)
    begin
        // Wenn wir für jedes Paket einen Lieferschein drucken, dann müssen wir hier den Dialog unterdrücken
        if SEWPKSingleInstance.GetPackingIsActive() = false then
            exit;
        HideDialog := true;
        DefaultOption := 2; // Invoice
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterPostSalesDoc, '', false, false)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry"; WhseShip: Boolean; WhseReceiv: Boolean; PreviewMode: Boolean)
    begin
        // Wenn wir für jedes Paket einen Lieferschein drucken, dann müssen wir die Rechnungsnummer hier abgreifen

        if SEWPKSingleInstance.GetPackingIsActive() = false then
            exit;
        SEWPKSingleInstance.SetLastInvoiceNo(SalesInvHdrNo);
    end;


}