codeunit 80023 "SEW Territories Processing"
{

    Permissions = tabledata Contact = rim,
                    tabledata Customer = rim,
                    tabledata "Contact Business Relation" = rim,
                    tabledata "Sales Header" = rim,
                    tabledata "Marketing Setup" = r,
                    tabledata Territory = r,
                    tabledata "Country/Region" = r,
                    tabledata "Post Code" = rim;

    procedure UpdateContactsSalespersonByTerritory(xTerritoryCode: Code[10]; SalespersonCode: Code[20]; UpdateSalesOrder: Boolean; UpdateSalesQuote: Boolean)
    var
        Contact: Record Contact;
        MarketingSetup: Record "Marketing Setup";
        ContactBusinessRelation: Record "Contact Business Relation";
    begin
        Contact.Reset();
        Contact.SetRange("Territory Code", xTerritoryCode);
        if Contact.FindSet(true) then
            repeat
                if Contact."SEW Salesperson manually" = false then
                    Contact.Validate("Salesperson Code", SalespersonCode);
                Contact.Modify(false);

                if Contact.Type = "Contact Type"::Company then begin
                    MarketingSetup.Get();
                    ContactBusinessRelation.SetRange("Contact No.", Contact."No.");
                    ContactBusinessRelation.SetRange("Business Relation Code", MarketingSetup."Bus. Rel. Code for Customers");

                    if ContactBusinessRelation.FindFirst() then begin
                        if UpdateSalesOrder = true then
                            this.SEWUpdateSalesHeader("Sales Document Type"::Order, ContactBusinessRelation."No.", SalespersonCode);
                        if UpdateSalesQuote = true then
                            this.SEWUpdateSalesHeader("Sales Document Type"::Quote, ContactBusinessRelation."No.", SalespersonCode);
                    end;
                end;
            until Contact.Next() = 0;
    end;


    local procedure SEWUpdateSalesHeader(DocType: Enum "Sales Document Type"; SellToCustomer: Code[20]; NewSalesPersonCode: Code[20])
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Reset();
        SalesHeader.SetRange("Sell-to Customer No.", SellToCustomer);
        SalesHeader.SetRange("Document Type", DocType);
        if SalesHeader.FindSet(true) then
            repeat
                SalesHeader.Validate("Salesperson Code", NewSalesPersonCode);
                SalesHeader.Modify(false);
            until SalesHeader.Next() = 0;
    end;


    procedure UpdateContactsTerritoryByCountryPostcode(xCountryCode: Code[10]; xPostCode: Code[20]; TerritoryCode: Code[10]; TerritoryServiceCode: Code[10])
    var
        Contact: Record Contact;
    begin
        Contact.Reset();
        Contact.SetRange("Country/Region Code", xCountryCode);

        if xPostCode = '' then
            Contact.SetFilter("Post Code", '=%1', '')
        else
            Contact.SetRange("Post Code", xPostCode);

        if Contact.FindSet(true) then
            repeat
                if Contact."SEW Territory manually" = false then
                    Contact.Validate("Territory Code", TerritoryCode);

                if ApplicationArea() = 'Service' then
                    if Contact."SEW Service Zone manually" = false then
                        Contact.Validate("SEW Service Zone Code", TerritoryServiceCode);

                Contact.Modify(true);

            until Contact.Next() = 0;
    end;


    procedure OnAfterValidateCustomerPostCode(var Customer: Record Customer): Boolean
    var
        PostCode: Record "Post Code";
        CountryRegion: Record "Country/Region";

    begin
        if Customer."Country/Region Code" = '' then
            exit(false);

        if Customer."Post Code" <> '' then begin
            PostCode.SetRange("Country/Region Code", Customer."Country/Region Code");
            PostCode.SetRange("Code", Customer."Post Code");

            if PostCode.FindFirst() then
                exit(UpdateCustfromPostCode(Customer, PostCode))
            else
                if CountryRegion.Get(Customer."Country/Region Code") then
                    exit(UpdateCustfromCountry(Customer, CountryRegion));
        end;
    end;

    local procedure UpdateCustfromPostCode(var Customer: Record Customer; var PostCode: Record "Post Code"): Boolean
    var
        Territory: Record Territory;
    begin
        if Customer."SEW Territory manually" = false then
            Customer.Validate("Territory Code", PostCode."SEW Territory Code");
        if Customer."SEW Service Zone manually" = false then
            Customer.Validate("Service Zone Code", PostCode."SEW Service Zone");
        if Customer."SEW Salesperson manually" = false then begin
            Territory.Reset();
            if Territory.Get(Customer."Territory Code") then
                if Territory."SEW Salesperson/Purchaser" <> '' then
                    Customer.Validate("Salesperson Code", Territory."SEW Salesperson/Purchaser");
        end;
        Customer.Modify(true);
        exit(true);
    end;

    local procedure UpdateCustfromCountry(var Customer: Record Customer; var CountryRegion: Record "Country/Region"): Boolean
    var
        Territory: Record Territory;
    begin
        if Customer."SEW Territory manually" = false then
            Customer.Validate("Territory Code", CountryRegion."SEW Territory Code");
        if Customer."SEW Service Zone manually" = false then
            Customer.Validate("Service Zone Code", CountryRegion."SEW Service Zone");
        if Customer."SEW Salesperson manually" = false then begin
            Territory.Reset();
            if Territory.Get(Customer."Territory Code") then
                if Territory."SEW Salesperson/Purchaser" <> '' then
                    Customer.Validate("Salesperson Code", Territory."SEW Salesperson/Purchaser");
        end;
        Customer.Modify(true);
        exit(true);
    end;

    procedure CreatePostCodesFromContacts()
    var
        Contact: Record Contact;
        PostCode: Record "Post Code";
    begin
        Contact.Reset();
        Contact.SetFilter("Post Code", '<>%1', ''); // only Contacts with Post Code
        Contact.SetFilter(City, '<>%1', ''); // only Contacts with City
        Contact.SetFilter("Country/Region Code", '<>%1', ''); // only Contacts in the selected Country/Region
        if Contact.FindSet() then
            if GuiAllowed() then
                if not ConfirmManagement.GetResponse(DialogCreateLbl, true) then
                    exit;


        repeat
            PostCode.Reset();
            PostCode.SetRange("Country/Region Code", Contact."Country/Region Code");
            PostCode.SetRange(Code, Contact."Post Code");
            PostCode.SetRange(City, Contact.City);
            if not PostCode.FindFirst() then begin
                PostCode.Init();
                PostCode."Country/Region Code" := Contact."Country/Region Code";
                PostCode.Code := Contact."Post Code";
                PostCode.City := Contact.City;
                if PostCode.Insert(false) = false then
                    if GuiAllowed() then
                        Error(DialogErrorLbl, Contact."Post Code", Contact.City, Contact."Country/Region Code", Contact."No.")
                    else
                        exit;
                Commit(); // to avoid record locking
            end;
        until Contact.Next() = 0;

        if GuiAllowed() then
            Message(DialogCreateDoneLbl);
    end;


    var
        ConfirmManagement: Codeunit "Confirm Management";
        DialogCreateLbl: Label 'Create Missing Postcodes?';
        DialogCreateDoneLbl: Label 'Finished creating missing Post Codes';
        DialogErrorLbl: Label 'Could not create Post Code %1 for City %2 \in Country/Region %3 \from Contact No. %4', Comment = '%1=Post Code, %2=City, %3=Country/Region Code, %4=Contact No.';
}