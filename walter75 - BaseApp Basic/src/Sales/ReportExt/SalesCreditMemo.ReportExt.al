reportextension 80014 "SEW Sales Credit Memo" extends "Standard Sales - Credit Memo"
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
            column(SEWisShipAddressEqual; SEWisShipAddressEqual) { }
            column(SEW_DisplayShipmentInformation; DisplayShipmentInformation) { }


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

            column(SEW_ShipmentNo; ShipmentLine."Document No.") { }
            column(SEW_ShipmentNoLbl; ShipmentLine.FieldCaption("Document No.")) { }

            //column(SEW_OrderDate; "Order Date") { }
            //column(SEW_OrderDateLbl; FieldCaption("Order Date")) { }
            //column(SEW_OrderNo; "Order No.") { }
            //column(SEW_OrderNoLbl; FieldCaption("Order No.")) { }
            // column(SEW_DeliveryDateRequested; Header."Requested Delivery Date") { }
            // column(SEW_DeliveryDatePromised; Header."Promised Delivery Date") { }

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

                SEW_DocTextSalesHeader := SEWReportFunctions.GetDocumentTextSales(Header."Sell-to Contact No.", "Language Code", "Sales Document Type"::"Credit Memo", "SEW Document Text Position"::Header, false);
                SEW_DocTextSalesFooter := SEWReportFunctions.GetDocumentTextSales(Header."Sell-to Contact No.", "Language Code", "Sales Document Type"::"Credit Memo", "SEW Document Text Position"::Footer, false);
                SEW_DocTextSalesHeaderMail := SEWReportFunctions.GetDocumentTextSales(Header."Sell-to Contact No.", "Language Code", "Sales Document Type"::"Credit Memo", "SEW Document Text Position"::Header, true);
                SEW_DocTextSalesFooterMail := SEWReportFunctions.GetDocumentTextSales(Header."Sell-to Contact No.", "Language Code", "Sales Document Type"::"Credit Memo", "SEW Document Text Position"::Footer, true);


                if "Prepayment Credit Memo" = true then begin
                    SEWDocTitleInvoice := SEW_DocTitleRechnungVorkasseLbl;
                    SEWDocTitleCreditMemo := SEW_DocTitleGutschriftVorkasseLbl;
                end else begin
                    SEWDocTitleInvoice := SEW_DocTitleRechnungLbl;
                    SEWDocTitleCreditMemo := SEW_DocTitleGutschriftLbl;
                end;

                if DisplayShipmentInformation = false then
                    if SEWShipmentNo = '' then begin
                        Line.SetRange("Document No.", "No.");
                        Line.SetRange(Type, Line.Type::Item);
#pragma warning disable LC0068
                        if Line.FindFirst() then begin
#pragma warning disable LC0068                            
                            ShipmentLine.GetLinesForSalesCreditMemoLine(Line, Header);
                            if ShipmentLine."Document No." <> '' then begin
                                SEWShipmentNo := ShipmentLine."Document No.";
                                "Shipment Date" := ShipmentLine."Posting Date";
                            end;
                        end;
                    end;
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

        addlast(Line)
        {
#pragma warning disable LC0068
            dataitem("Value Entry"; "Value Entry")
            {
                DataItemLink = "Document No." = field("Document No."), "Item No." = field("No."), "Document Line No." = field("Line No.");
                DataItemLinkReference = Line;
                column(SEWItem_Ledger_Entry_No_; "Item Ledger Entry No.") { }
                dataitem("Item Ledger Entry"; "Item Ledger Entry")
#pragma warning restore LC0068
                {
                    DataItemLink = "Entry No." = field("Item Ledger Entry No.");
                    DataItemLinkReference = "Value Entry";
                    column(SEWValue_Entry_No_; "Entry No.") { }
                    column(SEW_Qty; "Quantity")
                    {
                        AutoFormatType = 0;
                    }
                    column(SEW_QtyLbl; FieldCaption("Quantity")) { }
                    column(SEW_UnitofMeasure; "Unit of Measure Code") { }
                    column(SEW_UnitofMeasureLbl; FieldCaption("Unit of Measure Code")) { }
                    column(SEW_SerialNo; "Serial No.") { }
                    column(SEW_SerialNoLbl; FieldCaption("Serial No.")) { }
                    column(SEW_LotNo; "Lot No.") { }
                    column(SEW_LotNoLbl; FieldCaption("Lot No.")) { }
                    column(SEW_ExpirationDate; "Expiration Date") { }
                    column(SEW_ExpirationDateLbl; FieldCaption("Expiration Date")) { }

                    trigger OnAfterGetRecord()
                    begin
                        Quantity := Abs(Quantity);
                    end;
                }
            }
        }
    }

    rendering
    {
        layout("SEW Sales Credit Memo 01")
        {
            Type = RDLC;
            LayoutFile = './src/Sales/ReportExt/Layout/SalesCreditMemo01.rdlc';
            Caption = 'Sales Credit Memo Design 01 (RDLC)';
            Summary = 'Sales Credit Memo (RDLC)';
        }
        layout("SEW Sales Credit Memo 01 eMail")
        {
            Type = Word;
            LayoutFile = './src/Sales/ReportExt/Layout/SalesCreditMemo01 eMail.docx';
            Caption = 'Sales Credit Memo Design 01 eMail (Word)';
            Summary = 'Sales Credit Memo eMail (Word)';
        }
        layout("SEW Sales Credit Memo 02")
        {
            Type = RDLC;
            LayoutFile = './src/Sales/ReportExt/Layout/SalesCreditMemo02.rdlc';
            Caption = 'Sales Credit Memo Design 02 (RDLC)';
            Summary = 'Sales Credit Memo (RDLC)';
        }
        layout("SEW Sales Credit Memo 03")
        {
            Type = RDLC;
            LayoutFile = './src/Sales/ReportExt/Layout/SalesCreditMemo03.rdlc';
            Caption = 'Sales Credit Memo Design 03 (RDLC)';
            Summary = 'Sales Credit Memo (RDLC)';
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
        VATBusinessPostingGroup: Record "VAT Business Posting Group";
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
        SEW_DocTitleRechnungLbl: Label 'Invoice';
        SEW_DocTitleRechnungVorkasseLbl: Label 'Advance payment-Invoice';
        SEW_DocTitleGutschriftLbl: Label 'Credit Memo';
        SEW_DocTitleGutschriftVorkasseLbl: Label 'Advance payment-Credit Memo';
        SEW_DocTitleRechnungskorrekturLbl: Label 'Invoice correction';
        SEW_DocTitleLieferscheinLbl: Label 'delivery note';
        SEW_DocTitleAuftragsbestaetigungLbl: Label 'Orderconfirmation';
        SEW_DocTitleVerkaufLbl: Label 'Sale';

        SEW_DocBelegdatumLbl: Label 'Document date';
        SEW_DocLieferdatumLbl: Label 'Delivery date';
        SEW_DocBelegnrLbl: Label 'Document No.';
        SEW_DocLieferadresseLbl: Label 'Delivery address';
        SEW_DocVersandartLbl: Label 'Shipping method';
        SEW_DocShippingAgentLbl: Label 'Shipping Agent';
        SEW_DocShippingAgentServiceLbl: Label 'Shipping Agent Service';
        SEW_DocAnsprechpartnerLbl: Label 'contact person';


        //Region "DocSellTo" - alles Kundenbezogen
        SEW_DocSellToDebitorLbl: Label 'Customer';
        SEW_DocSellToKundennrLbl: Label 'Customer-No.';
        SEW_DocSellToIhreLbl: Label 'Your Tax-ID';
        SEW_DocSellToUstIDLbl: Label 'Tax-ID';

        //Region "Line" - alles Artikelbezogen
        SEW_LinePosLbl: Label 'Pos.';
        SEW_LineIhreArtNrLbl: Label 'Your Item-No.';
        SEW_LineVKPreisLbl: Label 'SA-Price';
        SEW_LineChargeLbl: Label 'LOT';
        SEW_LineMHDLbl: Label 'BBD';
        SEW_LinePreisLbl: Label 'Price';
        SEW_LineAnzahlLbl: Label 'Quantity';
        SEW_LineBezeichnungLbl: Label 'Description';
        SEW_LineCountryOfOrginLbl: Label 'Country of Orgin';
        SEW_LineTariffNoLbl: Label 'Tariff No.';

        //Region "Totals" - alles Summenbezogen
        SEW_TotalsZwischensummeLbl: Label 'Subtotal';
        SEW_TotalsNettowertLbl: Label 'Net Sum';
        SEW_TotalsGesamtbetragLbl: Label 'Total amount';
        SEW_TotalsOhneLbl: Label 'without';
        SEW_TotalsInklLbl: Label 'incl.';
        SEW_TotalsBetragLbl: Label 'Amount';
        SEW_TotalszzglLbl: Label 'plus.';
        SEW_TotalsUSTLbl: Label 'USt.';
        SEW_TotalsMwStLbl: Label 'MwSt.';
        SEW_TotalsbisLbl: Label 'bis';
        SEW_TotalsausLbl: Label 'aus';
        SEW_TotalsTotalLbl: Label 'Total';

        SEW_DocMailDisclaimerLbl: Label 'This e-mail may contain confidential and/or privileged information. If you are not the intended recipient (or have received this mail in error) please notify the sender immediately and destroy this e-mail. Any unauthorised copying, disclosure or distribution of the material in this mail is strictly forbidden.';
        SEW_DocMailDataProtectionLbl: Label 'Information on data protection can be found at:';
}