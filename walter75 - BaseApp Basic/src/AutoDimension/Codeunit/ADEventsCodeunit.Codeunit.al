codeunit 80019 "SEW AD Events Codeunit"
{
    Permissions = tabledata "Customer" = rimd;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CustVendBank-Update", OnAfterUpdateCustomer, '', true, true)]
    local procedure OnAfterUpdateCustomer(var Customer: Record Customer; Contact: Record Contact; var ContBusRel: Record "Contact Business Relation")
    begin
        Customer.Validate("Territory Code", Contact."Territory Code");
        Customer.Modify(false);
    end;

}