codeunit 80005 "SEW AS Event Subs"
{
    SingleInstance = true;
    Permissions = tabledata "Customer" = rmid,
                    tabledata "Item" = rmid;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnValidateSellToCustomerNoOnAfterTestStatusOpen, '', false, false)]
    local procedure OnValidateSellToCustomerNoOnAfterTestStatusOpen(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    var
        Customer: Record Customer;
    begin
        Customer.SetRange("No.", SalesHeader."Sell-to Customer No.");
        if Customer.FindFirst() then
            if GuiAllowed() then begin
                if Customer."SEW Warn Text" = '' then exit;
                Message(Customer."SEW Warn Text");
            end;
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Explode BOM", OnBeforeConfirmExplosion, '', false, false)]
    local procedure OnBeforeConfirmExplosion(var SalesLine: Record "Sales Line"; var Selection: Integer; var HideDialog: Boolean; var NoOfBOMComp: Integer)
    var
        SEWPKSingleInstance: Codeunit "SEW BA Single Instance";
    begin
        if SEWPKSingleInstance.GetAutoExplode() then begin
            Selection := 1;
            HideDialog := true;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Explode BOM", OnAfterConfirmExplosion, '', false, false)]
    local procedure OnAfterConfirmExplosion(var SalesLine: Record "Sales Line"; var Selection: Integer; var HideDialog: Boolean)
    var
        SEWPKSingleInstance: Codeunit "SEW BA Single Instance";
    begin
        if SEWPKSingleInstance.GetAutoExplode() then begin
            Selection := 1;
            HideDialog := true;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", OnAfterInitFromSalesLine, '', false, false)]
    local procedure OnAfterInitFromSalesLine(SalesShptHeader: Record "Sales Shipment Header"; SalesLine: Record "Sales Line"; var SalesShptLine: Record "Sales Shipment Line")
    var
        Item: Record Item;
    begin
        if SalesLine.Type = SalesLine.Type::Item then
            if Item.Get(SalesLine."No.") then
                SalesShptLine."SEW Shelf No." := Item."Shelf No.";
    end;


}
