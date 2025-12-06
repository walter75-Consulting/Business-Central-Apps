reportextension 80016 "SEW Sales - Order Conf." extends "Standard Sales - Order Conf."
{
    dataset
    {
        add(Header)
        {
            // Basics
            column(SEW_CurrencyCode; SEWCurrCode) { }
            column(SEW_CurrencySymbol; SEWCurrSymbol) { }
            column(SEW_CompanyColor1; CompanyInfo."SEW Company Color 1") { }
            column(SEW_CompanyColor2; CompanyInfo."SEW Company Color 2") { }
            column(SEW_CompanyFontColor1; CompanyInfo."SEW Company Font Color 1") { }
            column(SEW_CompanyFontColor2; CompanyInfo."SEW Company Font Color 2") { }
            column(SEW_CompanyFont1; SEWCIFont1) { }
            column(SEW_CompanyFont2; SEWCIFont1) { }
            column(SEW_isShipAddressEqual; SEWisShipAddressEqual) { }
            //column(SEW_DisplayShipmentInformation; DisplayShipmentInformation) { }


            //Region "Company Info" (Firmendaten)
            column(SEW_CommercialRegister; CompanyInfo."SEW Commercial Register") { }
            column(SEW_CommercialRegisterLbl; CompanyInfo.FieldCaption("SEW Commercial Register")) { }
            column(SEW_ConditionsURL; CompanyInfo."SEW Conditions URL") { }
            column(SEW_ConditionsURLLbl; CompanyInfo.FieldCaption("SEW Conditions URL")) { }
            column(SEW_DataProtectionURL; CompanyInfo."SEW Data Protection URL") { }
            column(SEW_DataProtectionURLLbl; CompanyInfo.FieldCaption("SEW Data Protection URL")) { }
            column(SEW_ManagingDirector; CompanyInfo."SEW Managing Director") { }
            column(SEW_ManagingDirectorLbl; CompanyInfo.FieldCaption("SEW Managing Director")) { }

            column(SEW_CompanyPicture2; SEWCompanyInformation."SEW Picture 2") { }
            column(SEW_CompanyPicture3; SEWCompanyInformation."SEW Picture 3") { }
            column(SEW_CompanyPicture4; SEWCompanyInformation."SEW Picture 4") { }
            column(SEW_CompanyPicture5; SEWCompanyInformation."SEW Picture 5") { }

            column(SEW_CI_Name1; CompanyInfo.Name) { }
            column(SEW_CI_Name2; CompanyInfo."Name 2") { }
            column(SEW_CI_Address1; CompanyInfo.Address) { }
            column(SEW_CI_Address2; CompanyInfo."Address 2") { }
            column(SEW_CI_PostCode; CompanyInfo."Post Code") { }
            column(SEW_CI_City; CompanyInfo.City) { }
            column(SEW_CI_CountryCode; CompanyInfo."Country/Region Code") { }
            column(SEW_CompanyFax; CompanyInfo."Fax No.") { }
            column(SEW_CompanyFaxLbL; CompanyInfo.FieldCaption("Fax No.")) { }

            column(SEW_BankName2; CompanyInfo."SEW Bank Name 02") { }
            column(SEW_BankBranchNo2; CompanyInfo."SEW Bank Branch No. 02") { }
            column(SEW_BankAccountNo2; CompanyInfo."SEW Bank Account No. 02") { }
            column(SEW_BankIBAN2; CompanyInfo."SEW Bank IBAN 02") { }
            column(SEW_BankSWIFTCode2; CompanyInfo."SEW Bank SWIFT Code 02") { }
            column(SEW_BankName3; CompanyInfo."SEW Bank Name 03") { }
            column(SEW_BankBranchNo3; CompanyInfo."SEW Bank Branch No. 03") { }
            column(SEW_BankAccountNo3; CompanyInfo."SEW Bank Account No. 03") { }
            column(SEW_BankIBAN3; CompanyInfo."SEW Bank IBAN 03") { }
            column(SEW_BankSWIFTCode3; CompanyInfo."SEW Bank SWIFT Code 03") { }

            column(SEW_DocumentText01; CompanyInfo."SEW Document Text 01") { }
            column(SEW_DocumentText02; CompanyInfo."SEW Document Text 02") { }
            column(SEW_DocumentText03; CompanyInfo."SEW Document Text 03") { }
            column(SEW_DocumentText04; CompanyInfo."SEW Document Text 04") { }
            column(SEW_DocumentText05; CompanyInfo."SEW Document Text 05") { }
            column(SEW_DocumentText06; CompanyInfo."SEW Document Text 06") { }

            column(SEW_DocumentFooterText01; CompanyInfo."SEW Document Footer Text 01") { }
            column(SEW_DocumentFooterText02; CompanyInfo."SEW Document Footer Text 02") { }
            column(SEW_DocumentFooterText03; CompanyInfo."SEW Document Footer Text 03") { }
            column(SEW_DocumentFooterText04; CompanyInfo."SEW Document Footer Text 04") { }
            column(SEW_DocumentFooterText05; CompanyInfo."SEW Document Footer Text 05") { }
            column(SEW_DocumentFooterText06; CompanyInfo."SEW Document Footer Text 06") { }

            column(SEW_DocTextSalesHeader; SEW_DocTextSalesHeader) { }
            column(SEW_DocTextSalesHeaderMail; SEW_DocTextSalesHeaderMail) { }
            column(SEW_DocTextSalesFooter; SEW_DocTextSalesFooter) { }
            column(SEW_DocTextSalesFooterMail; SEW_DocTextSalesFooterMail) { }
            column(SEW_DocMailDisclaimerLbl; SEW_DocMailDisclaimerLbl) { }
            column(SEW_DocMailDataProtectionLbl; SEW_DocMailDataProtectionLbl) { }


            //Region "SalesHeader"
            column(SEW_DocumentDate; "Document Date") { }
            column(SEW_ShipmentDate; "Shipment Date") { }

            column(SEW_ShipmentNo; SEWShipmentNo) { }
            // column(SEW_ShipmentNoLbl; ShipmentLine.FieldCaption("Document No.")) { }

            column(SEW_OrderDate; "Order Date") { }
            column(SEW_OrderDateLbl; FieldCaption("Order Date")) { }
            // column(SEW_OrderNo; "Order No.") { }
            // column(SEW_OrderNoLbl; FieldCaption("Order No.")) { }
            column(SEW_DeliveryDateRequested; Header."Requested Delivery Date") { }
            column(SEW_DeliveryDatePromised; Header."Promised Delivery Date") { }

            column(SEW_SalesPersonPhone; SalespersonPurchaser."Phone No.") { }
            column(SEW_SalesPersonPhoneLbl; SalespersonPurchaser.FieldCaption("Phone No.")) { }
            column(SEW_SalesPersonEmail; SalespersonPurchaser."E-Mail") { }
            column(SEW_SalesPersonEmailLbl; SalespersonPurchaser.FieldCaption("E-Mail")) { }

            column(SEW_ShippingAgentName; ShippingAgent.Name) { }
            column(SEW_ShippingAgentService; ShippingAgentServices.Description) { }
            column(SEW_ShippingAgentServiceCode; "Shipping Agent Service Code") { }
            column(SEW_ShippingAgentServiceCodeLbl; FieldCaption("Shipping Agent Service Code")) { }


            //Region "Doc" - alles allgemein Beleg bezogenes
            column(SEW_DocTitleRechnungLbl; SEWDocTitleInvoice) { }
            column(SEW_DocTitleGutschriftLbl; SEWDocTitleCreditMemo) { }
            column(SEW_DocTitleRechnungskorrekturLbl; SEW_DocTitleRechnungskorrekturLbl) { }
            column(SEW_DocTitleLieferscheinLbl; SEW_DocTitleLieferscheinLbl) { }
            column(SEW_DocTitleAuftragsbestaetigungLbl; SEW_DocTitleAuftragsbestaetigungLbl) { }
            column(SEW_DocTitleVerkaufLbl; SEW_DocTitleVerkaufLbl) { }


            column(SEW_DocBelegdatumLbl; SEW_DocBelegdatumLbl) { }
            column(SEW_DocLieferdatumLbl; SEW_DocLieferdatumLbl) { }
            column(SEW_DocBelegnrLbl; SEW_DocBelegnrLbl) { }
            column(SEW_DocLieferadresseLbl; SEW_DocLieferadresseLbl) { }
            column(SEW_DocVersandartLbl; SEW_DocVersandartLbl) { }
            column(SEW_DocShippingAgentLbl; SEW_DocShippingAgentLbl) { }
            column(SEW_DocShippingAgentServiceLbl; SEW_DocShippingAgentServiceLbl) { }
            column(SEW_DocAnsprechpartnerLbl; SEW_DocAnsprechpartnerLbl) { }

            //Region "DocSellTo" - alles Kundenbezogen
            column(SEW_DocSellToDebitorLbl; SEW_DocSellToDebitorLbl) { }
            column(SEW_DocSellToKundennrLbl; SEW_DocSellToKundennrLbl) { }
            column(SEW_DocSellToIhreLbl; SEW_DocSellToIhreLbl) { }
            column(SEW_DocSellToUstIDLbl; SEW_DocSellToUstIDLbl) { }
            column(SEW_ContactSalutation; SEWContactSalutation) { }


            //Region "Line" - alles Artikelbezogen
            column(SEW_LinePosLbl; SEW_LinePosLbl) { }
            column(SEW_LineIhreArtNrLbl; SEW_LineIhreArtNrLbl) { }
            column(SEW_LineVKPreisLbl; SEW_LineVKPreisLbl) { }
            column(SEW_LineChargeLbl; SEW_LineChargeLbl) { }
            column(SEW_LineMHDLbl; SEW_LineMHDLbl) { }
            column(SEW_LinePreisLbl; SEW_LinePreisLbl) { }
            column(SEW_LineAnzahlLbl; SEW_LineAnzahlLbl) { }
            column(SEW_LineBezeichnungLbl; SEW_LineBezeichnungLbl) { }


            //Region "Totals" - alles Summenbezogen
            column(SEW_TotalsZwischensummeLbl; SEW_TotalsZwischensummeLbl) { }
            column(SEW_TotalsNettowertLbl; SEW_TotalsNettowertLbl) { }
            column(SEW_TotalsGesamtbetragLbl; SEW_TotalsGesamtbetragLbl) { }
            column(SEW_TotalsOhneLbl; SEW_TotalsOhneLbl) { }
            column(SEW_TotalsInklLbl; SEW_TotalsInklLbl) { }
            column(SEW_TotalsBetragLbl; SEW_TotalsBetragLbl) { }
            column(SEW_TotalszzglLbl; SEW_TotalszzglLbl) { }
            column(SEW_TotalsUSTLbl; SEW_TotalsUSTLbl) { }
            column(SEW_TotalsMwStLbl; SEW_TotalsMwStLbl) { }
            column(SEW_TotalsbisLbl; SEW_TotalsbisLbl) { }
            column(SEW_TotalsausLbl; SEW_TotalsausLbl) { }
            column(SEW_TotalsTotalLbl; SEW_TotalsTotalLbl) { }
        }

        modify(Header)
        {
            trigger OnAfterAfterGetRecord()
            begin
                PosNbr := 0;
#pragma warning disable LC0068     
                if "Shipping Agent Code" <> '' then begin
                    if ShippingAgent.Get("Shipping Agent Code") then; // To avoid "unused variable" warning
                    if ShippingAgentServices.Get("Shipping Agent Code", "Shipping Agent Service Code") then; // To avoid "unused variable" warning
                end;

                if "Currency Code" <> '' then begin
                    CurrencyExchangeRate.FindCurrency("Posting Date", "Currency Code", 1);
                    SEWCalculatedExchRate :=
                      Round(1 / "Currency Factor" * CurrencyExchangeRate."Exchange Rate Amount", 0.000001);
                    SEWExchangeRateText := StrSubstNo(SEWExchangeRateTxt, SEWCalculatedExchRate, CurrencyExchangeRate."Exchange Rate Amount");
                    SEWCurrCode := "Currency Code";
                    if Currency.Get("Currency Code") then
                        SEWCurrSymbol := Currency.GetCurrencySymbol();
                end else
                    if GeneralLedgerSetup.Get() then begin
                        SEWCurrCode := GeneralLedgerSetup."LCY Code";
                        SEWCurrSymbol := GeneralLedgerSetup.GetCurrencySymbol();
                    end;
#pragma warning restore LC0068
                SEWisShipAddressEqual := SEWReportFunctions.IsShipToAddressEqual(RecordId());
                SEWReportFunctions.GetTariffPrint("VAT Bus. Posting Group", SEWPrintTariffNo, SEWPrintCountryOfOrigin);

                SEW_DocTextSalesHeader := SEWReportFunctions.GetDocumentTextSales(Header."Sell-to Contact No.", "Language Code", "Sales Document Type"::Order, "SEW Document Text Position"::Header, false);
                SEW_DocTextSalesFooter := SEWReportFunctions.GetDocumentTextSales(Header."Sell-to Contact No.", "Language Code", "Sales Document Type"::Order, "SEW Document Text Position"::Footer, false);
                SEW_DocTextSalesHeaderMail := SEWReportFunctions.GetDocumentTextSales(Header."Sell-to Contact No.", "Language Code", "Sales Document Type"::Order, "SEW Document Text Position"::Header, true);
                SEW_DocTextSalesFooterMail := SEWReportFunctions.GetDocumentTextSales(Header."Sell-to Contact No.", "Language Code", "Sales Document Type"::Order, "SEW Document Text Position"::Footer, true);


                // if "Prepayment Invoice" = true then begin
                //     SEWDocTitleInvoice := SEW_DocTitleRechnungVorkasseLbl;
                //     SEWDocTitleCreditMemo := SEW_DocTitleGutschriftVorkasseLbl;
                // end else begin
                //     SEWDocTitleInvoice := SEW_DocTitleRechnungLbl;
                //     SEWDocTitleCreditMemo := SEW_DocTitleGutschriftLbl;
                // end;

                //                 if DisplayShipmentInformation = false then
                //                     if SEWShipmentNo = '' then begin
                //                         Line.SetRange("Document No.", "No.");
                //                         Line.SetRange(Type, Line.Type::Item);
                // #pragma warning disable LC0068
                //                         if Line.FindFirst() then begin
                // #pragma warning disable LC0068
                //                             ShipmentLine.GetLinesForSalesInvoiceLine(Line, Header);
                //                             if ShipmentLine."Document No." <> '' then
                //                                 SEWShipmentNo := ShipmentLine."Document No.";
                //                         end;
                //                     end;
            end;
        }

        modify(Line)
        {
            trigger OnAfterAfterGetRecord()
            var
                Item: Record Item;
            begin
                if (Type = Type::"G/L Account") or (Type = Type::Item) or (Type = Type::Resource) then
                    PosNbr += 1;

                Clear(SEWTariffNo);
                Clear(SEWTariffDescription);
                Clear(SEWCountryofOriginCode);
                Clear(SEWCountryofOriginDescription);

                if Type = Type::Item then begin
                    Item.Reset();
                    Item.SetRange("No.", "No.");

#pragma warning disable LC0068
                    if Item.FindFirst() then begin
#pragma warning disable LC0068
                        if SEWPrintTariffNo then
                            SEWTariffNo := Item."Tariff No.";

                        if SEWPrintCountryOfOrigin then
                            SEWCountryofOriginCode := Item."Country/Region of Origin Code";
                    end;

                    if SEWTariffNo <> '' then
                        SEWTariffDescription := SEWReportFunctions.GetTariffDescription(SEWTariffNo);

                    if SEWCountryofOriginCode <> '' then
                        SEWCountryofOriginDescription := SEWReportFunctions.GetCountryName(SEWCountryofOriginCode);
                end;
            end;
        }


        add(Line)
        {
            column(SEW_PosNbr; PosNbr) { }
            column(SEW_DescriptionLine2; "Description 2") { }
            column(SEW_CountryofOriginCode; SEWCountryofOriginCode) { }
            column(SEW_SEW_CountryofOriginCodeLbl; SEW_LineCountryOfOrginLbl) { }
            column(SEW_CountryofOriginDescription; SEWCountryofOriginDescription) { }
            column(SEW_TariffNo; SEWTariffNo) { }
            column(SEW_TariffNoLbl; SEW_LineTariffNoLbl) { }
            column(SEW_TariffDescription; SEWTariffDescription) { }
        }

    }

    rendering
    {
        layout("SEW Sales OrderConfirmation01")
        {
            Type = RDLC;
            LayoutFile = './src/Sales/ReportExt/Layout/SalesOrderConfirmation01.rdlc';
            Caption = 'Sales Order Confirmation 01 (RDLC)';
            Summary = 'Order Confirmation (RDLC)';
        }
        layout("SEW Sales Invoice 01 eMail")
        {
            Type = Word;
            LayoutFile = './src/Sales/ReportExt/Layout/SalesOrderConfirmation01 eMail.docx';
            Caption = 'Sales Order Confirmation 01 eMail (Word)';
            Summary = 'Order Confirmation eMail (Word)';
        }
        layout("SEW Sales OrderConfirmation02")
        {
            Type = RDLC;
            LayoutFile = './src/Sales/ReportExt/Layout/SalesOrderConfirmation02.rdlc';
            Caption = 'Sales Order Confirmation 02 (RDLC)';
            Summary = 'Order Confirmation (RDLC)';
        }
        layout("SEW Sales OrderConfirmation03")
        {
            Type = RDLC;
            LayoutFile = './src/Sales/ReportExt/Layout/SalesOrderConfirmation03.rdlc';
            Caption = 'Sales Order Confirmation 03 (RDLC)';
            Summary = 'Order Confirmation (RDLC)';
        }
    }

    trigger OnPreReport()
    begin
        PosNbr := 0;
        SEWPrintTariffNo := false;
        SEWPrintCountryOfOrigin := false;

#pragma warning disable LC0068
        if CompanyInfo.Get() then; // to avoid "unused variable" warning
#pragma warning restore LC0068
        SEWCIFont1 := SEWReportFunctions.GetFontName(CompanyInfo."SEW Company Font 1");
        SEWCIFont2 := SEWReportFunctions.GetFontName(CompanyInfo."SEW Company Font 2");
        //CompanyInfo.Get();
        //CompanyInfo.CalcFields("SEW Picture 2");
        //CompanyInfo.CalcFields("SEW Picture 3");
        //CompanyInfo.CalcFields("SEW Picture 4");
        //CompanyInfo.CalcFields("SEW Picture 5");
        //SEWCompanyInformation."SEW Picture 2" := CompanyInfo."SEW Picture 2";
        //SEWCompanyInformation."SEW Picture 3" := CompanyInfo."SEW Picture 3";
        //SEWCompanyInformation."SEW Picture 4" := CompanyInfo."SEW Picture 4";
        //SEWCompanyInformation."SEW Picture 5" := CompanyInfo."SEW Picture 5";
    end;

    var
        SEWCompanyInformation: Record "Company Information";
        ShippingAgent: Record "Shipping Agent";
        ShippingAgentServices: Record "Shipping Agent Services";
        GeneralLedgerSetup: Record "General Ledger Setup";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        Currency: Record Currency;
        SEWReportFunctions: Codeunit "SEW Report Functions";
        SEWCalculatedExchRate: Decimal;
        SEWExchangeRateText: Text;
        PosNbr: Integer;

        SEWPrintTariffNo: Boolean;
        SEWPrintCountryOfOrigin: Boolean;
        SEWisShipAddressEqual: Boolean;
        SEWShipmentNo: Code[20];

        SEW_DocTextSalesHeader: Text;
        SEW_DocTextSalesFooter: Text;
        SEW_DocTextSalesHeaderMail: Text;
        SEW_DocTextSalesFooterMail: Text;

        SEWDocTitleInvoice: Text;
        SEWDocTitleCreditMemo: Text;
        SEWContactSalutation: Text;


        SEWCurrCode: Text[10];
        SEWCurrSymbol: Text[10];

        SEWTariffNo: Code[20];
        SEWTariffDescription: Text[250];
        SEWCountryofOriginCode: Code[10];
        SEWCountryofOriginDescription: Text[50];
        SEWCIFont1: Text;
        SEWCIFont2: Text;

        SEWExchangeRateTxt: Label 'Exchange rate: %1/%2', Comment = '%1 and %2 are both amounts.';

        //Region "Doc" - alles allgemein Beleg bezogenes
        SEW_DocTitleRechnungskorrekturLbl: Label 'Rechnungskorrektur';
        SEW_DocTitleLieferscheinLbl: Label 'Lieferschein';
        SEW_DocTitleAuftragsbestaetigungLbl: Label 'Auftragsbestätigung';
        SEW_DocTitleVerkaufLbl: Label 'Verkauf';

        SEW_DocBelegdatumLbl: Label 'Belegdatum';
        SEW_DocLieferdatumLbl: Label 'Lieferdatum';
        SEW_DocBelegnrLbl: Label 'Belegnr.';
        SEW_DocLieferadresseLbl: Label 'Lieferadresse';
        SEW_DocVersandartLbl: Label 'Versandart';
        SEW_DocShippingAgentLbl: Label 'Shipping Agent';
        SEW_DocShippingAgentServiceLbl: Label 'Shipping Agent Service';
        SEW_DocAnsprechpartnerLbl: Label 'Ansprechpartner';


        //Region "DocSellTo" - alles Kundenbezogen
        SEW_DocSellToDebitorLbl: Label 'Debitor';
        SEW_DocSellToKundennrLbl: Label 'Kunden-Nr.';
        SEW_DocSellToIhreLbl: Label 'Ihre USt.-ID';
        SEW_DocSellToUstIDLbl: Label 'USt.-ID';

        //Region "Line" - alles Artikelbezogen
        SEW_LinePosLbl: Label 'Pos.';
        SEW_LineIhreArtNrLbl: Label 'Ihre Artikel-Nr.';
        SEW_LineVKPreisLbl: Label 'VK-Preis';
        SEW_LineChargeLbl: Label 'Charge';
        SEW_LineMHDLbl: Label 'MHD';
        SEW_LinePreisLbl: Label 'Preis';
        SEW_LineAnzahlLbl: Label 'Anzahl';
        SEW_LineBezeichnungLbl: Label 'Bezeichnung';
        SEW_LineCountryOfOrginLbl: Label 'Ursprungsland';
        SEW_LineTariffNoLbl: Label 'Zollpos.';

        //Region "Totals" - alles Summenbezogen
        SEW_TotalsZwischensummeLbl: Label 'Zwischensumme';
        SEW_TotalsNettowertLbl: Label 'Nettowert';
        SEW_TotalsGesamtbetragLbl: Label 'Gesamtbetrag';
        SEW_TotalsOhneLbl: Label 'ohne';
        SEW_TotalsInklLbl: Label 'inkl.';
        SEW_TotalsBetragLbl: Label 'Betrag';
        SEW_TotalszzglLbl: Label 'zzgl.';
        SEW_TotalsUSTLbl: Label 'USt.';
        SEW_TotalsMwStLbl: Label 'MwSt.';
        SEW_TotalsbisLbl: Label 'bis';
        SEW_TotalsausLbl: Label 'aus';
        SEW_TotalsTotalLbl: Label 'Total';

        SEW_DocMailDisclaimerLbl: Label 'This e-mail may contain confidential and/or privileged information. If you are not the intended recipient (or have received this mail in error) please notify the sender immediately and destroy this e-mail. Any unauthorised copying, disclosure or distribution of the material in this mail is strictly forbidden.';
        SEW_DocMailDataProtectionLbl: Label 'Information on data protection can be found at:';

}