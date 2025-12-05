codeunit 80006 "SEW AP Event Subs"
{
    SingleInstance = true;
    Permissions = tabledata "Customer" = rmid;


    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", OnAfterCheckBuyFromVendor, '', false, false)]
    local procedure OnAfterCheckBuyFromVendor(var PurchaseHeader: Record "Purchase Header"; xPurchaseHeader: Record "Purchase Header"; Vendor: Record Vendor)
    var

    begin
        if GuiAllowed() then begin
            if Vendor."SEW Warn Text" = '' then exit;
            Message(Vendor."SEW Warn Text");
        end;
    end;




}
