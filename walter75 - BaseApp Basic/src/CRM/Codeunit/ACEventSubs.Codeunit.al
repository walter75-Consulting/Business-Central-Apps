codeunit 80022 "SEW AC Event Subs"
{

    Permissions = tabledata Contact = rim,
                  tabledata Customer = rim,
                  tabledata "Contact Business Relation" = rim,
                  tabledata Territory = r,
                  tabledata "Post Code" = r,
                  tabledata "Country/Region" = r,
                  tabledata "Ship-to Address" = rim;


    [EventSubscriber(ObjectType::Table, Database::"Contact", OnAfterLookupPostCode, '', true, true)]
    local procedure ContactOnAfterLookupPostCode(var Contact: Record Contact; var PostCode: Record "Post Code")
    begin
        SEWUpdateContact(Contact);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Contact", OnAfterValidatePostCode, '', true, true)]
    local procedure ContactOnAfterValidatePostCode(var Contact: Record Contact; xContact: Record Contact)
    begin
        SEWUpdateContact(Contact);
    end;

    // [EventSubscriber(ObjectType::Table, Database::"Customer", 'OnAfterValidatePostCode', '', true, true)]
    // local procedure CustomerOnAfterValidatePostCode(var Customer: Record Customer; xCustomer: Record Customer)
    // begin

    // end;

    // Events beim Update von Customer / Contact
    [EventSubscriber(ObjectType::Table, Database::"Contact", OnBeforeIsUpdateNeeded, '', true, true)]
    local procedure OnBeforeIsUpdateNeeded(var Contact: Record Contact; xContact: Record Contact; var UpdateNeeded: Boolean)
    begin
        if not UpdateNeeded = true then
            UpdateNeeded :=
            (Contact."SEW Salesperson manually" <> xContact."SEW Salesperson manually") or
            (Contact."SEW Territory manually" <> xContact."SEW Territory manually") or
            (Contact."SEW Service Zone manually" <> xContact."SEW Service Zone manually") or
            (Contact."Territory Code" <> xContact."Territory Code") or
            (Contact."SEW Service Zone Code" <> xContact."SEW Service Zone Code");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CustVendBank-Update", OnAfterUpdateCustomer, '', true, true)]
    local procedure OnAfterUpdateCustomer(var Customer: Record Customer; Contact: Record Contact; var ContBusRel: Record "Contact Business Relation")
    begin
        Customer."SEW Salesperson manually" := Contact."SEW Salesperson manually";
        Customer."SEW Territory manually" := Contact."SEW Territory manually";
        Customer."SEW Service Zone manually" := Contact."SEW Service Zone manually";
        if Contact."SEW Salesperson manually" = false then
            Customer."Service Zone Code" := Contact."SEW Service Zone Code";
        Customer.Modify(false);

        Customer.Validate("Territory Code", Contact."Territory Code");
        Customer.Modify(false);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Customer", OnBeforeIsContactUpdateNeeded, '', true, true)]
    local procedure OnBeforeIsContactUpdateNeeded(Customer: Record Customer; xCustomer: Record Customer; var UpdateNeeded: Boolean; ForceUpdateContact: Boolean)
    begin
        if not UpdateNeeded = true then
            UpdateNeeded :=
            (Customer."SEW Salesperson manually" <> xCustomer."SEW Salesperson manually") or
            (Customer."SEW Territory manually" <> xCustomer."SEW Territory manually") or
            (Customer."SEW Service Zone manually" <> xCustomer."SEW Service Zone manually") or
            (Customer."Territory Code" <> xCustomer."Territory Code") or
            (Customer."Service Zone Code" <> xCustomer."Service Zone Code");

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CustCont-Update", OnAfterTransferFieldsFromCustToCont, '', true, true)]
    local procedure OnAfterTransferFieldsFromCustToCont(var Contact: Record Contact; Customer: Record Customer)
    begin
        // Contact."SEW Salesperson manually" := Customer."SEW Salesperson manually";
        // Contact."SEW Territory manually" := Customer."SEW Territory manually";
        // Contact."SEW Service Zone manually" := Customer."SEW Service Zone manually";
        // if Customer."SEW Salesperson manually" = false then
        //     Contact."SEW Service Zone Code" := Customer."Service Zone Code";
        // Contact.Modify(false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CustCont-Update", OnAfterOnModify, '', true, true)]
    local procedure OnAfterOnModify(var Contact: Record Contact; var OldContact: Record Contact; var Customer: Record Customer)
    begin
        Contact."SEW Salesperson manually" := Customer."SEW Salesperson manually";
        Contact."SEW Territory manually" := Customer."SEW Territory manually";
        Contact."SEW Service Zone manually" := Customer."SEW Service Zone manually";
        if Customer."SEW Salesperson manually" = false then
            Contact."SEW Service Zone Code" := Customer."Service Zone Code";
        Contact.Modify(false);
    end;



    [EventSubscriber(ObjectType::Table, Database::"Ship-to Address", OnAfterValidatePostCode, '', true, true)]
    local procedure ShiptoAddressOnAfterValidatePostCode(var ShipToAddress: Record "Ship-to Address"; var PostCode: Record "Post Code")
    var
        SEWPostCode: Record "Post Code";
        SEWCountryRegion: Record "Country/Region";
    begin
        if ShipToAddress."Country/Region Code" <> '' then
            if ShipToAddress."Post Code" <> '' then begin
                SEWPostCode.SetRange("Country/Region Code", ShipToAddress."Country/Region Code");
                SEWPostCode.SetRange("Code", ShipToAddress."Post Code");
                if SEWPostCode.FindFirst() then
                    ShipToAddress."Service Zone Code" := SEWPostCode."SEW Service Zone"
            end else
                if SEWCountryRegion.Get(ShipToAddress."Country/Region Code") then
                    ShipToAddress."Service Zone Code" := SEWCountryRegion."SEW Service Zone";
    end;


    procedure SEWUpdateContact(var Contact: Record Contact)
    var
        PostCode: Record "Post Code";
        CountryRegion: Record "Country/Region";
        Territory: Record Territory;

        Contact2: Record Contact;


    begin
        if Contact."Country/Region Code" <> '' then
            if Contact."Post Code" <> '' then begin
                PostCode.SetRange("Country/Region Code", Contact."Country/Region Code");
                PostCode.SetRange("Code", Contact."Post Code");
                if PostCode.FindFirst() then begin
                    if Contact."SEW Territory manually" = false then
                        Contact."Territory Code" := PostCode."SEW Territory Code";
                    if Contact."SEW Service Zone manually" = false then
                        Contact."SEW Service Zone Code" := PostCode."SEW Service Zone";
                    if Contact."SEW Salesperson manually" = false then begin
                        Territory.Reset();
                        if Territory.Get(Contact."Territory Code") then
                            Contact."Salesperson Code" := Territory."SEW Salesperson/Purchaser";
                    end;
                end else
                    if CountryRegion.Get(Contact."Country/Region Code") then begin
                        Contact."Territory Code" := CountryRegion."SEW Territory Code";
                        Contact."SEW Service Zone Code" := CountryRegion."SEW Service Zone";
                        if Contact."SEW Salesperson manually" = false then begin
                            Territory.Reset();
                            if Territory.Get(Contact."Territory Code") then
                                Contact."Salesperson Code" := Territory."SEW Salesperson/Purchaser";
                        end;
                    end;
            end;


        if Contact.Type = "Contact Type"::Company then begin
            Contact2.Reset();
            Contact2.SetRange("Company No.", Contact."No.");
            Contact2.SetRange(Type, "Contact Type"::Person);
            Contact2.SetFilter("No.", '<>%1', Contact."No.");
            if Contact2.Find('-') then
                repeat
                    if Contact2."SEW Territory manually" = false then
                        Contact2."Territory Code" := Contact."Territory Code";

                    if Contact2."SEW Service Zone manually" = false then
                        Contact2."SEW Service Zone Code" := Contact."SEW Service Zone Code";

                    if Contact2."SEW Salesperson manually" = false then
                        Contact2."Salesperson Code" := Contact."Salesperson Code";

                    Contact2.Modify(false);
                until Contact2.Next() = 0;
        end;
    end;




}