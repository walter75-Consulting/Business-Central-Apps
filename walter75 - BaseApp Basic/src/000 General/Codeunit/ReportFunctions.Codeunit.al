codeunit 80024 "SEW Report Functions"
{
    Permissions = tabledata "Sales Header" = rimd,
                    tabledata "Purchase Header" = rmid,
                    tabledata "Company Information" = rmid,
                    tabledata "SEW Document Text Sales" = r,
                    tabledata Contact = r,
                    tabledata "VAT Business Posting Group" = r,
                    tabledata "Tariff Number" = r,
                    tabledata "Country/Region" = r;

    procedure IsShipToAddressEqual(RecordId_RecID: RecordId) Result: Boolean
    var
        SalesHeader: Record "Sales Header";
        SalesHeaderFilter: Record "Sales Header";
        PurchaseHeader: Record "Purchase Header";
        PurchaseHeaderFilter: Record "Purchase Header";
        CompanyInformation: Record "Company Information";
        RecordRef_RecRef: RecordRef;

    begin
        if CompanyInformation.Get() then; // to avoid "unused variable" warning

        RecordRef_RecRef.Get(RecordId_RecID);
        RecordRef_RecRef := RecordId_RecID.GetRecord();
        RecordRef_RecRef.SetRecFilter();

        case RecordId_RecID.TableNo() of
            Database::"Sales Header":
                begin
                    RecordRef_RecRef := RecordId_RecID.GetRecord();
                    RecordRef_RecRef.SetRecFilter();
                    RecordRef_RecRef.SetTable(SalesHeader);

                    if SalesHeaderFilter.Get(SalesHeader."Document Type", SalesHeader."No.") then
                        Result :=
                          (SalesHeader."Ship-to Address" = SalesHeaderFilter."Sell-to Address") and
                          (SalesHeader."Ship-to Address 2" = SalesHeaderFilter."Sell-to Address 2") and
                          (SalesHeader."Ship-to City" = SalesHeaderFilter."Sell-to City") and
                          (SalesHeader."Ship-to County" = SalesHeaderFilter."Sell-to County") and
                          (SalesHeader."Ship-to Post Code" = SalesHeaderFilter."Sell-to Post Code") and
                          (SalesHeader."Ship-to Country/Region Code" = SalesHeaderFilter."Sell-to Country/Region Code");
                end;
            Database::"Purchase Header":
                begin
                    RecordRef_RecRef := RecordId_RecID.GetRecord();
                    RecordRef_RecRef.SetRecFilter();
                    RecordRef_RecRef.SetTable(PurchaseHeader);

                    if PurchaseHeaderFilter.Get(PurchaseHeader."Document Type", PurchaseHeader."No.") then
                        Result :=
                          (PurchaseHeaderFilter."Ship-to Address" = CompanyInformation."Ship-to Address") and
                          (PurchaseHeaderFilter."Ship-to Address 2" = CompanyInformation."Ship-to Address 2") and
                          (PurchaseHeaderFilter."Ship-to City" = CompanyInformation."Ship-to City") and
                          (PurchaseHeaderFilter."Ship-to County" = CompanyInformation."Ship-to County") and
                          (PurchaseHeaderFilter."Ship-to Post Code" = CompanyInformation."Ship-to Post Code") and
                          (PurchaseHeaderFilter."Ship-to Country/Region Code" = CompanyInformation."Ship-to Country/Region Code") and
                          (PurchaseHeaderFilter."Ship-to Name" = CompanyInformation."Ship-to Name");
                end;
        end;
    end;



    procedure GetDocumentTextSales(xContactNo: Code[20]; xLanguageCode: Code[10]; xDocumentType: Enum "Sales Document Type"; xPosition: Enum "SEW Document Text Position"; xforEmail: Boolean): Text
    var
        SEWDocumentTextSales: Record "SEW Document Text Sales";
        TypeHelper: Codeunit "Type Helper";

        SEWContactSalutation: Text;
        SEWDocTextSalesHeader: Text;
        SEWDocTextSalesHeaderTmp: Text;
        NewLine: Text;

    begin
        NewLine := Format(TypeHelper.CRLFSeparator());
        SEWContactSalutation := GetContactSalutation(xContactNo, xLanguageCode);

        //Set filters and find document texts
        SEWDocumentTextSales.SetRange("Document Type Sales", xDocumentType);
        SEWDocumentTextSales.SetRange("Language Code", xLanguageCode);
        SEWDocumentTextSales.SetRange("All Language Codes", false);
        SEWDocumentTextSales.SetRange("Position", xPosition);
        SEWDocumentTextSales.SetRange("for eMail", xforEmail);
        SEWDocumentTextSales.SetFilter("Starting Date", '%1|<=%2', 0D, WorkDate());
        SEWDocumentTextSales.SetFilter("Ending Date", '%1|>=%2', 0D, WorkDate());
        SEWDocumentTextSales.SetCurrentKey(Sortorder);
        SEWDocumentTextSales.SetAscending("Sortorder", true);

        if SEWDocumentTextSales.IsEmpty() then begin
            SEWDocumentTextSales.SetRange("Language Code");
            SEWDocumentTextSales.SetRange("All Language Codes", true);
        end;

        if SEWDocumentTextSales.FindSet() then begin
            SEWDocTextSalesHeader := '';
            SEWDocTextSalesHeaderTmp := '';
            repeat
                SEWDocTextSalesHeaderTmp := StrSubstNo(SEWDocumentTextSales."Document Text", SEWContactSalutation);

                if StrLen(SEWDocTextSalesHeader) = 0 then
                    SEWDocTextSalesHeader := SEWDocTextSalesHeaderTmp
                else
                    SEWDocTextSalesHeader := SEWDocTextSalesHeader + NewLine + SEWDocTextSalesHeaderTmp;

            until SEWDocumentTextSales.Next() = 0;
        end;

        exit(SEWDocTextSalesHeader);
    end;


    procedure GetContactSalutation(xContactNo: Code[20]; xLanguageCode: Code[10]): Text
    var
        Contact: Record Contact;
    begin

        if Contact.Get(xContactNo) then; // to avoid "unused variable" warning
        if Contact."Salutation Code" <> '' then
            exit(Contact.GetSalutation("Salutation Formula Salutation Type"::Formal, xLanguageCode))
        else
            exit('');
    end;

    procedure GetFontName(xReportFont: Enum "SEW Report Font"): Text
    var
        Level: Enum "SEW Report Font";
        OrdinalValue: Integer;
        Index: Integer;
        LevelName: Text;
    begin
        Level := xReportFont;
        OrdinalValue := Level.AsInteger();  // Ordinal value = 30
        Index := Level.Ordinals().IndexOf(OrdinalValue);  // Index = 3
        LevelName := Level.Names().Get(Index); // Name = Gold
        exit(LevelName);
    end;

    procedure GetTariffPrint(xBusPostingGroup: Code[20]; var SEWPrintTariffNo: Boolean; var SEWPrintCountryOfOrigin: Boolean)
    var
        VATBusinessPostingGroup: Record "VAT Business Posting Group";
    begin
        VATBusinessPostingGroup.Reset();
        VATBusinessPostingGroup.SetRange(Code, xBusPostingGroup);
        if VATBusinessPostingGroup.FindFirst() then begin
            SEWPrintTariffNo := VATBusinessPostingGroup."SEW Print Tariff Number Invo";
            SEWPrintCountryOfOrigin := VATBusinessPostingGroup."SEW Print CtryofOrigin Invo";
        end else begin
            SEWPrintTariffNo := false;
            SEWPrintCountryOfOrigin := false;
        end;
    end;

    procedure GetTariffDescription(xTariffNo: Code[20]): Text[250]
    var
        TariffNumber: Record "Tariff Number";
    begin
        TariffNumber.Reset();
        TariffNumber.SetRange("No.", xTariffNo);
        if TariffNumber.FindFirst() then
            exit(TariffNumber.Description)
        else
            exit('');
    end;

    procedure GetCountryName(xCountryCode: Code[10]): Text[50]
    var
        CountryRegion: Record "Country/Region";
    begin
        CountryRegion.Reset();
        CountryRegion.SetRange(Code, xCountryCode);
        if CountryRegion.FindFirst() then
            exit(CountryRegion.Name)
        else
            exit('');
    end;
}