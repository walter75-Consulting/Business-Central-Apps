// xmlport 60500 "SEW Export idoc-Order to SAP"
// {
//     // (c) Lederer Systemhaus GmbH
//     // Änderungen für Fa. Kastenmüller
//     // 
//     // 24.01.24 kn: #37174
//     //          XMLPort erstellt
//     // 12.11.24 kn 24.60774.2: #37391
//     // c01      LT-2410 - Anpassung Kastenmüller iDoc Textfelder
//     // 19.11.24 kn 24.60774.2:
//     //          Änderungen SNDPOR und SNDPRT gem. Mail Marcel.Rohlfing@jacob-group.com vom 19.11.2024
//     //          LT-2476: Anpassungen IDOC Kopf
//     // 03.12.24 kn 24.60774.2: LT-2611
//     //          Bestellnr. inkl. Verkäufercode exportieren
//     // 20.01.25 kn 24.60774.2: LT-2802
//     //          UPS-Kundennr. exportieren  
//     // 21.01.25 vorläufig auskommentiert, da Rückmeldung vom Partner fehlt.  
//     // 22.01.25 Freigabe von LT-2802 erfolgt

//     Direction = Export;
//     Encoding = UTF8;
//     UseRequestPage = false;

//     schema
//     {
//         tableelement("Purchase Header"; "Purchase Header")
//         {
//             RequestFilterFields = "No.";
//             XmlName = 'ORDERS05';
//             SourceTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order));

//             textelement(IDOC)
//             {
//                 textattribute(BEGIN1)
//                 {
//                     XmlName = 'BEGIN';
//                     trigger OnBeforePassVariable();
//                     begin
//                         BEGIN1 := '1';
//                     end;
//                 }
//                 textelement(EDI_DC40)
//                 {
//                     textattribute(SEGMENT1)
//                     {
//                         XmlName = 'SEGMENT';
//                         trigger OnBeforePassVariable();
//                         begin
//                             SEGMENT1 := '1';
//                         end;
//                     }
//                     textelement(TABNAM)
//                     {
//                         trigger OnBeforePassVariable();
//                         begin
//                             TABNAM := 'EDI_DC40';
//                         end;
//                     }
//                     textelement(EXPRSS)
//                     { }
//                     textelement(IDOCTYP)
//                     {
//                         trigger OnBeforePassVariable();
//                         begin
//                             IDOCTYP := 'ORDERS05';
//                         end;
//                     }
//                     textelement(MESTYP)
//                     {
//                         trigger OnBeforePassVariable();
//                         begin
//                             MESTYP := 'ORDERS';
//                         end;
//                     }
//                     textelement(SNDPOR)
//                     {
//                         trigger OnBeforePassVariable();
//                         begin
//                             SNDPOR := '102187';
//                         end;
//                     }
//                     textelement(SNDPRT)
//                     {
//                         trigger OnBeforePassVariable();
//                         begin
//                             SNDPRT := 'KU';
//                         end;
//                     }
//                     textelement(SNDPFC)
//                     { }
//                     textelement(SNDPRN)
//                     {
//                         trigger OnBeforePassVariable();
//                         begin
//                             SNDPRN := '102187';
//                         end;
//                     }
//                     textelement(RCVPOR)
//                     {
//                         trigger OnBeforePassVariable();
//                         begin
//                             RCVPOR := 'SAPPRD';
//                         end;
//                     }
//                     textelement(RCVPRT)
//                     {
//                         trigger OnBeforePassVariable();
//                         begin
//                             RCVPRT := 'LS';
//                         end;
//                     }
//                     textelement(RCVPFC)
//                     { }
//                     textelement(RCVPRN)
//                     {
//                         trigger OnBeforePassVariable();
//                         begin
//                             RCVPRN := '0000000000';
//                         end;
//                     }
//                     textelement(CREDAT)
//                     {
//                         trigger OnBeforePassVariable();
//                         begin
//                             CREDAT := Format(Today, 0, '<Year4><Month,2><Day,2>')
//                         end;
//                     }
//                     textelement(CRETIM)
//                     {
//                         trigger OnBeforePassVariable();
//                         begin
//                             CRETIM := Format(Time, 0, '<Hours24,2><Minutes,2><Seconds,2>');
//                         end;
//                     }
//                 }
//                 textelement(E1EDK01)
//                 {
//                     textattribute(SEGMENT2)
//                     {
//                         XmlName = 'SEGMENT';
//                         trigger OnBeforePassVariable();
//                         begin
//                             SEGMENT2 := '1';
//                         end;
//                     }
//                     textelement(ACTION)
//                     {
//                         trigger OnBeforePassVariable();
//                         begin
//                             ACTION := '004';
//                         end;
//                     }
//                     textelement(CURCY)
//                     {

//                         trigger OnBeforePassVariable()
//                         begin
//                             if "Purchase Header"."Currency Code" = '' then
//                                 CURCY := 'EUR'
//                             else
//                                 CURCY := "Purchase Header"."Currency Code";
//                         end;
//                     }
//                     textelement(BSART)
//                     {

//                         trigger OnBeforePassVariable()
//                         begin
//                             BSART := 'NB';
//                         end;
//                     }
//                     textelement(BELNR)
//                     {
//                         trigger OnBeforePassVariable()
//                         begin
//                             BELNR := "Purchase Header"."No.";
//                             BELNR := "Purchase Header"."No." + StrSubstNo(Slash_Lbl, "Purchase Header"."Purchaser Code");
//                         end;
//                     }
//                     textelement(ZBASE64)
//                     {
//                         trigger OnBeforePassVariable()
//                         var
//                             Base64Convert: Codeunit "Base64 Convert";
//                             TempBlob: Codeunit "Temp Blob";
//                             RecRef: RecordRef;
//                             IStream: InStream;
//                             OStream: OutStream;
//                         begin
//                             RecRef.GetTable(PurchaseHeader);
//                             RecRef.SetRecFilter();
//                             TempBlob.CreateOutStream(OStream);
//                             Report.SaveAs(Report::"Order, KM", '', ReportFormat::Pdf, OStream, RecRef);
//                             TempBlob.CreateInStream(IStream);
//                             ZBASE64 := Base64Convert.ToBase64(IStream);
//                         end;
//                     }
//                 }
//                 textelement(E1EDK03_011)
//                 {
//                     XmlName = 'E1EDK03';
//                     textattribute(SEGMENT3)
//                     {
//                         XmlName = 'SEGMENT';
//                         trigger OnBeforePassVariable();
//                         begin
//                             SEGMENT3 := '1';
//                         end;
//                     }
//                     textelement(IDDAT011)
//                     {
//                         XmlName = 'IDDAT';
//                         trigger OnBeforePassVariable();
//                         begin
//                             IDDAT011 := '011'; //Document Creation Date
//                         end;
//                     }
//                     textelement(DATUM011)
//                     {
//                         XmlName = 'DATUM';
//                         trigger OnBeforePassVariable();
//                         begin
//                             DATUM011 := Format(Today, 0, '<Year4><Month,2><Day,2>');
//                         end;
//                     }
//                 }
//                 textelement(E1EDK03_012)
//                 {
//                     XmlName = 'E1EDK03';
//                     textattribute(SEGMENT4)
//                     {
//                         XmlName = 'SEGMENT';
//                         trigger OnBeforePassVariable();
//                         begin
//                             SEGMENT4 := '1';
//                         end;
//                     }
//                     textelement(IDDAT012)
//                     {
//                         XmlName = 'IDDAT';
//                         trigger OnBeforePassVariable();
//                         begin
//                             IDDAT012 := '012'; //Document  Date
//                         end;
//                     }
//                     textelement(DATUM012)
//                     {
//                         XmlName = 'DATUM';
//                         trigger OnBeforePassVariable();
//                         begin
//                             DATUM012 := Format("PurchaseHeader"."Document Date", 0, '<Year4><Month,2><Day,2>');
//                         end;
//                     }
//                 }
//                 textelement(E1EDK03_022)
//                 {
//                     XmlName = 'E1EDK03';
//                     textattribute(SEGMENT5)
//                     {
//                         XmlName = 'SEGMENT';
//                         trigger OnBeforePassVariable();
//                         begin
//                             SEGMENT5 := '1';
//                         end;
//                     }
//                     textelement(IDDAT022)
//                     {
//                         XmlName = 'IDDAT';
//                         trigger OnBeforePassVariable();
//                         begin
//                             IDDAT022 := '022'; //Order  Date
//                         end;
//                     }
//                     textelement(DATUM022)
//                     {
//                         XmlName = 'DATUM';
//                         trigger OnBeforePassVariable();
//                         begin
//                             DATUM022 := Format("PurchaseHeader"."Order Date", 0, '<Year4><Month,2><Day,2>');
//                         end;
//                     }
//                 }
//                 textelement(E1EDK03_002)
//                 {
//                     XmlName = 'E1EDK03';
//                     textattribute(SEGMENT6)
//                     {
//                         XmlName = 'SEGMENT';
//                         trigger OnBeforePassVariable();
//                         begin
//                             SEGMENT6 := '1';
//                         end;
//                     }
//                     textelement(IDDAT002)
//                     {
//                         XmlName = 'IDDAT';
//                         trigger OnBeforePassVariable();
//                         begin
//                             IDDAT002 := '002'; //Requested Receipt Date
//                         end;
//                     }
//                     textelement(DATUM002)
//                     {
//                         XmlName = 'DATUM';
//                         trigger OnBeforePassVariable();
//                         begin
//                             DATUM002 := Format("PurchaseHeader"."Requested Receipt Date", 0, '<Year4><Month,2><Day,2>');
//                         end;
//                     }
//                 }
//                 textelement(E1EDKA1_AG)
//                 {
//                     XmlName = 'E1EDKA1';
//                     textattribute(SEGMENT7)
//                     {
//                         XmlName = 'SEGMENT';
//                         trigger OnBeforePassVariable();
//                         begin
//                             SEGMENT7 := '1';
//                         end;
//                     }
//                     textelement(PARVW_AG)
//                     {
//                         XmlName = 'PARVW';
//                         trigger OnBeforePassVariable();
//                         begin
//                             PARVW_AG := 'AG'; // Sold To
//                         end;
//                     }
//                     textelement(PARTN_AG)
//                     {
//                         XmlName = 'PARTN';
//                         trigger OnBeforePassVariable();
//                         begin
//                             PARTN_AG := Vend."Our Account No.";
//                         end;
//                     }
//                 }
//                 textelement(E1EDKA1_LF)
//                 {
//                     XmlName = 'E1EDKA1';
//                     textattribute(SEGMENT8)
//                     {
//                         XmlName = 'SEGMENT';
//                         trigger OnBeforePassVariable();
//                         begin
//                             SEGMENT8 := '1';
//                         end;
//                     }
//                     textelement(PARVW_LF)
//                     {
//                         XmlName = 'PARVW';
//                         trigger OnBeforePassVariable();
//                         begin
//                             PARVW_LF := 'LF'; // Vendor
//                         end;
//                     }
//                     textelement(PARTN_LF)
//                     {
//                         XmlName = 'PARTN';
//                         trigger OnBeforePassVariable();
//                         begin
//                             PARTN_LF := '0000000000';
//                         end;
//                     }
//                 }
//                 textelement(E1EDKA1_WE)
//                 {
//                     XmlName = 'E1EDKA1';
//                     textattribute(SEGMENT9)
//                     {
//                         XmlName = 'SEGMENT';
//                         trigger OnBeforePassVariable();
//                         begin
//                             SEGMENT9 := '1';
//                         end;
//                     }
//                     textelement(PARVW_WE)
//                     {
//                         XmlName = 'PARVW';
//                         trigger OnBeforePassVariable();
//                         begin
//                             PARVW_WE := 'WE'; // Goods Recipient
//                         end;
//                     }
//                     textelement(PARTN_WE)
//                     {
//                         XmlName = 'PARTN';
//                         trigger OnBeforePassVariable();
//                         begin
//                             PARTN_WE := Cust."Lieferanten - Adress-Nummer";
//                         end;
//                     }
//                 }
//                 textelement(E1EDKA1_ZB)
//                 {
//                     XmlName = 'E1EDKA1';
//                     textattribute(SEGMENT_ZB)
//                     {
//                         XmlName = 'SEGMENT';
//                         trigger OnBeforePassVariable();
//                         begin
//                             SEGMENT_ZB := '1';
//                         end;
//                     }
//                     textelement(PARVW_ZB)
//                     {
//                         XmlName = 'PARVW';
//                         trigger OnBeforePassVariable();
//                         begin
//                             PARVW_ZB := 'ZB'; // Ansprechpartner
//                         end;
//                     }
//                     textelement(PARTN_ZB)
//                     {
//                         XmlName = 'PARTN';
//                         trigger OnBeforePassVariable();
//                         var
//                             PurchSalesPerson: Record "Salesperson/Purchaser";
//                         begin
//                             if not PurchSalesPerson.Get("Purchase Header"."Purchaser Code") then
//                                 PurchSalesPerson.Init();
//                             if PurchSalesPerson."Global Dimension 1 Code" = '' then
//                                 PurchSalesPerson."Global Dimension 1 Code" := '42928';
//                             PurchSalesPerson.TestField("Global Dimension 1 Code");
//                             PARTN_ZB := PurchSalesPerson."Global Dimension 1 Code";
//                         end;
//                     }
//                 }
//                 textelement(E1EDK02)
//                 {
//                     XmlName = 'E1EDK02';
//                     textattribute(SEGMENT10)
//                     {
//                         XmlName = 'SEGMENT';
//                         trigger OnBeforePassVariable();
//                         begin
//                             SEGMENT10 := '1';
//                         end;
//                     }
//                     textelement(QUALF)
//                     {
//                         trigger OnBeforePassVariable();
//                         begin
//                             QUALF := '001';
//                         end;
//                     }
//                     textelement(BELNR2)
//                     {
//                         XmlName = 'BELNR';
//                         trigger OnBeforePassVariable();
//                         begin
//                             BELNR2 := "PurchaseHeader"."No.";
//                             BELNR2 := "Purchase Header"."No." + StrSubstNo(Slash_Lbl, "Purchase Header"."Purchaser Code");
//                         end;
//                     }
//                 }
//                 textelement(E1EDKT1_0007)
//                 {
//                     XmlName = 'E1EDKT1';
//                     textattribute(SEGMENT11)
//                     {
//                         XmlName = 'SEGMENT';
//                         trigger OnBeforePassVariable();
//                         begin
//                             SEGMENT11 := '1';
//                         end;
//                     }
//                     textelement(TDID)
//                     {
//                         XmlName = 'TDID';
//                         trigger OnBeforePassVariable();
//                         begin
//                             TDID := '0007'; //General Information
//                         end;
//                     }
//                     textelement(TSSPRAS_0007)
//                     {
//                         XmlName = 'TSSPRAS';
//                         trigger OnBeforePassVariable();
//                         begin
//                             TSSPRAS_0007 := 'DE';
//                         end;
//                     }
//                     textelement(TSSPRAS_ISO_0007)
//                     {
//                         XmlName = 'TSSPRAS_ISO';
//                         trigger OnBeforePassVariable();
//                         begin
//                             TSSPRAS_ISO_0007 := 'DE';
//                         end;
//                     }
//                     textelement(E1EDKT2_0007)
//                     {
//                         XmlName = 'E1EDKT2';
//                         textattribute(SEGMENT12)
//                         {
//                             XmlName = 'SEGMENT';
//                             trigger OnBeforePassVariable();
//                             begin
//                                 SEGMENT12 := '1';
//                             end;
//                         }
//                         textelement(TDLINE_0007)
//                         {
//                             XmlName = 'TDLINE';
//                             trigger OnBeforePassVariable();
//                             begin
//                                 PurchLineTextHdr.SETRANGE("Document Type", "Purchase Header"."Document Type");
//                                 PurchLineTextHdr.SETRANGE("Document No.", "Purchase Header"."No.");
//                                 PurchLineTextHdr.SETRANGE(Type, PurchLineTextHdr.Type::"G/L Account");
//                                 PurchLineTextHdr.SETRANGE("No.", 'Text');
//                                 //lshanf c01                                
//                                 PurchLineTextHdr.SetRange("No.");
//                                 //lshend c01
//                                 IF PurchLineTextHdr.FINDFIRST() THEN BEGIN
//                                     HeaderText := PurchLineTextHdr.Description;
//                                     AttachedPurchLines.SETRANGE("Document Type", PurchLineTextHdr."Document Type");
//                                     AttachedPurchLines.SETRANGE("Document No.", PurchLineTextHdr."Document No.");
//                                     AttachedPurchLines.SETRANGE("Attached to Line No.", PurchLineTextHdr."Line No.");
//                                     IF AttachedPurchLines.FINDSET() THEN
//                                         REPEAT
//                                             HeaderText := HeaderText + ' ' + AttachedPurchLines.Description;
//                                         UNTIL AttachedPurchLines.NEXT() = 0;
//                                 END ELSE
//                                     HeaderText := '';
//                                 TDLINE_0007 := CopyStr(HeaderText, 1, 500);
//                             end;
//                         }
//                         textelement(TDFORMAT_0007)
//                         {
//                             XmlName = 'TDFORMAT';
//                             trigger OnBeforePassVariable();
//                             begin
//                                 TDFORMAT_0007 := '*';
//                             end;
//                         }
//                     }
//                 }
//                 textelement(E1EDKT1_0006)
//                 {
//                     XmlName = 'E1EDKT1';
//                     textattribute(SEGMENT13)
//                     {
//                         XmlName = 'SEGMENT';
//                         trigger OnBeforePassVariable();
//                         begin
//                             SEGMENT13 := '1';
//                         end;
//                     }
//                     textelement(TDID_00006)
//                     {
//                         XmlName = 'TDID';
//                         trigger OnBeforePassVariable();
//                         begin
//                             TDID_00006 := '0006'; //Bill-to Text
//                         end;
//                     }
//                     textelement(TSSPRAS_0006)
//                     {
//                         XmlName = 'TSSPRAS';
//                         trigger OnBeforePassVariable();
//                         begin
//                             TSSPRAS_0006 := 'DE';
//                         end;
//                     }
//                     textelement(TSSPRAS_ISO_0006)
//                     {
//                         XmlName = 'TSSPRAS_ISO';
//                         trigger OnBeforePassVariable();
//                         begin
//                             TSSPRAS_ISO_0006 := 'DE';
//                         end;
//                     }
//                     textelement(E1EDKT2_0006)
//                     {
//                         XmlName = 'E1EDKT2';
//                         textattribute(SEGMENT14)
//                         {
//                             XmlName = 'SEGMENT';
//                             trigger OnBeforePassVariable();
//                             begin
//                                 SEGMENT14 := '1';
//                             end;
//                         }
//                         textelement(TDLINE_0006)
//                         {
//                             XmlName = 'TDLINE';
//                             trigger OnBeforePassVariable();
//                             begin
//                                 TDLINE_0006 := "PurchaseHeader"."Your Reference";
//                             end;
//                         }
//                         textelement(TDFORMAT_0006)
//                         {
//                             XmlName = 'TDFORMAT';
//                             trigger OnBeforePassVariable();
//                             begin
//                                 TDFORMAT_0006 := '*';
//                             end;
//                         }
//                     }
//                 }
//                 textelement(E1EDKT1_0003)
//                 {
//                     XmlName = 'E1EDKT1';
//                     textattribute(SEGMENT13_0003)
//                     {
//                         XmlName = 'SEGMENT';
//                         trigger OnBeforePassVariable();
//                         begin
//                             SEGMENT13_0003 := '1';
//                         end;
//                     }
//                     textelement(TDID_00003)
//                     {
//                         XmlName = 'TDID';
//                         trigger OnBeforePassVariable();
//                         begin
//                             TDID_00003 := '0003'; //UPS-Kundennummer
//                         end;
//                     }
//                     textelement(TSSPRAS_0003)
//                     {
//                         XmlName = 'TSSPRAS';
//                         trigger OnBeforePassVariable();
//                         begin
//                             TSSPRAS_0006 := 'DE';
//                         end;
//                     }
//                     textelement(TSSPRAS_ISO_0003)
//                     {
//                         XmlName = 'TSSPRAS_ISO';
//                         trigger OnBeforePassVariable();
//                         begin
//                             TSSPRAS_ISO_0003 := 'DE';
//                         end;
//                     }
//                     textelement(E1EDKT2_0003)
//                     {
//                         XmlName = 'E1EDKT2';
//                         textattribute(SEGMENT14_0003)
//                         {
//                             XmlName = 'SEGMENT';
//                             trigger OnBeforePassVariable();
//                             begin
//                                 SEGMENT14_0003 := '1';
//                             end;
//                         }
//                         textelement(TDLINE_0003)
//                         {
//                             XmlName = 'TDLINE';
//                             trigger OnBeforePassVariable();
//                             var
//                                 ShippingAgents: Record "Shipping Agent";
//                             begin
//                                 if ShippingAgents.Get(PurchaseHeader."Shipping Agent Code") then
//                                     TDLINE_0003 := ShippingAgents.Name
//                                 else
//                                     TDLINE_0003 := '';
//                             end;
//                         }
//                         textelement(TDFORMAT_0003)
//                         {
//                             XmlName = 'TDFORMAT';
//                             trigger OnBeforePassVariable();
//                             begin
//                                 TDFORMAT_0003 := '*';
//                             end;
//                         }
//                     }
//                 }
//                 tableelement("Purchase Line"; "Purchase Line")
//                 {
//                     XmlName = 'E1EDP01';
//                     SourceTableView = SORTING("Document Type", "Document No.", "Line No.") WHERE(Type = FILTER(Item));
//                     textattribute(SEGMENT15)
//                     {
//                         XmlName = 'SEGMENT';
//                         trigger OnBeforePassVariable();
//                         begin
//                             SEGMENT15 := '1';
//                         end;
//                     }
//                     textelement(POSEX)
//                     {
//                         trigger OnBeforePassVariable()
//                         begin
//                             POSEX := Format("Purchase Line"."Position No.");
//                         end;
//                     }
//                     textelement(ACTION2)
//                     {
//                         XmlName = 'ACTION';
//                         trigger OnBeforePassVariable()
//                         begin
//                             ACTION2 := '002';
//                         end;
//                     }
//                     textelement(quantity)
//                     {
//                         XmlName = 'MENGE';

//                         trigger OnBeforePassVariable()
//                         begin
//                             quantity := Format("Purchase Line".Quantity, 0, '<Precision,2:5><Standard Format,2>');
//                         end;

//                     }
//                     textelement(UOM)
//                     {
//                         XmlName = 'MENEE';

//                         trigger OnBeforePassVariable()
//                         var
//                             UnitOfMeasures: Record "Unit of Measure";
//                         begin
//                             if UnitOfMeasures.Get("Purchase Line"."Unit of Measure Code") then
//                                 UOM := UnitOfMeasures."LSHPD ISO Code (SAP Interface)"
//                             else
//                                 UOM := '';
//                             if UOM = '' then
//                                 Error('Bei Einheit %1 muss %2 ausgefüllt werden.',
//                                   "Purchase Line"."Unit of Measure Code", UnitOfMeasures.FieldCaption("LSHPD ISO Code (SAP Interface)"));
//                         end;
//                     }
//                     textelement(E1EDP02)
//                     {

//                         textattribute(SEGMENT16)
//                         {
//                             XmlName = 'SEGMENT';
//                             trigger OnBeforePassVariable();
//                             begin
//                                 SEGMENT16 := '1';
//                             end;
//                         }
//                         Textelement(QUALF1)
//                         {
//                             XmlName = 'QUALF';
//                             trigger OnBeforePassVariable();
//                             begin
//                                 QUALF1 := '001';
//                             end;
//                         }
//                         Textelement(BELNR3)
//                         {
//                             XmlName = 'BELNR';
//                             trigger OnBeforePassVariable();
//                             begin
//                                 BELNR3 := "PurchaseLine"."Document No.";
//                                 BELNR3 := "PurchaseLine"."Document No." + StrSubstNo(Slash_Lbl, "Purchase Header"."Purchaser Code");
//                             end;
//                         }
//                         Textelement(ZEILE)
//                         {
//                             XmlName = 'ZEILE';
//                             trigger OnBeforePassVariable();
//                             begin
//                                 ZEILE := Format(PurchaseLine."Line No.");
//                             end;
//                         }
//                     }
//                     textelement(E1EDP03)
//                     {

//                         textattribute(SEGMENT17)
//                         {
//                             XmlName = 'SEGMENT';
//                             trigger OnBeforePassVariable();
//                             begin
//                                 SEGMENT17 := '1';
//                             end;
//                         }
//                         Textelement(IDDAT)
//                         {
//                             XmlName = 'IDDAT';
//                             trigger OnBeforePassVariable();
//                             begin
//                                 IDDAT := '002';
//                             end;
//                         }
//                         Textelement(DATUM)
//                         {
//                             XmlName = 'DATUM';
//                             trigger OnBeforePassVariable();
//                             begin
//                                 DATUM := Format(PurchaseLine."Requested Receipt Date", 0, '<Year4><Month,2><Day,2>');
//                             end;
//                         }
//                     }
//                     textelement(E1EDP20)
//                     {

//                         textattribute(SEGMENT18)
//                         {
//                             XmlName = 'SEGMENT';
//                             trigger OnBeforePassVariable();
//                             begin
//                                 SEGMENT18 := '1';
//                             end;
//                         }
//                         Textelement(WMENG)
//                         {
//                             XmlName = 'WMENG';
//                             trigger OnBeforePassVariable();
//                             begin
//                                 WMENG := Format(PurchaseLine.Quantity, 0, '<Precision,2:5><Standard Format,2>');
//                             end;
//                         }
//                         Textelement(EDATU)
//                         {
//                             XmlName = 'EDATU';
//                             trigger OnBeforePassVariable();
//                             begin
//                                 EDATU := Format(PurchaseLine."Requested Receipt Date", 0, '<Year4><Month,2><Day,2>');
//                             end;
//                         }
//                         Textelement(ACTION3)
//                         {
//                             XmlName = 'ACTION';
//                             trigger OnBeforePassVariable();
//                             begin
//                                 ACTION3 := '002';
//                             end;
//                         }
//                     }
//                     textelement(E1EDP19_001)
//                     {
//                         XmlName = 'E1EDP19';
//                         textattribute(SEGMENT22)
//                         {
//                             XmlName = 'SEGMENT';
//                             trigger OnBeforePassVariable();
//                             begin
//                                 SEGMENT22 := '1';
//                             end;
//                         }
//                         Textelement(QUALF_001)
//                         {
//                             XmlName = 'QUALF';
//                             trigger OnBeforePassVariable();
//                             begin
//                                 QUALF_001 := '001';
//                             end;
//                         }
//                         Textelement(IDTNR_001)
//                         {
//                             XmlName = 'IDTNR';
//                             trigger OnBeforePassVariable();
//                             begin
//                                 IDTNR_001 := "PurchaseLine"."No.";
//                             end;
//                         }
//                     }
//                     textelement(E1EDP19)
//                     {

//                         textattribute(SEGMENT19)
//                         {
//                             XmlName = 'SEGMENT';
//                             trigger OnBeforePassVariable();
//                             begin
//                                 SEGMENT19 := '1';
//                             end;
//                         }
//                         Textelement(QUALF4)
//                         {
//                             XmlName = 'QUALF';
//                             trigger OnBeforePassVariable();
//                             begin
//                                 QUALF4 := '002';
//                             end;
//                         }
//                         Textelement(IDTNR)
//                         {
//                             XmlName = 'IDTNR';
//                             trigger OnBeforePassVariable();
//                             begin
//                                 IDTNR := ItemRef."Reference No.";
//                                 if "PurchaseLine"."Vendor Item No." <> '' then
//                                     IDTNR := "PurchaseLine"."Vendor Item No.";
//                             end;
//                         }
//                     }
//                     textelement(E1EDPT1_0001)
//                     {
//                         XmlName = 'E1EDPT1';
//                         textattribute(SEGMENT23)
//                         {
//                             XmlName = 'SEGMENT';
//                             trigger OnBeforePassVariable();
//                             begin
//                                 SEGMENT23 := '1';
//                             end;
//                         }
//                         textelement(TDID_0001)
//                         {
//                             XmlName = 'TDID';
//                             trigger OnBeforePassVariable();
//                             begin
//                                 TDID_Z007 := '0001';
//                             end;
//                         }
//                         textelement(TSSPRAS_0001)
//                         {
//                             XmlName = 'TSSPRAS';
//                             trigger OnBeforePassVariable();
//                             begin
//                                 TSSPRAS_0001 := 'DE';
//                             end;
//                         }
//                         textelement(TSSPRAS_ISO_0001)
//                         {
//                             XmlName = 'TSSPRAS_ISO';
//                             trigger OnBeforePassVariable();
//                             begin
//                                 TSSPRAS_ISO_0001 := 'DE';
//                             end;
//                         }
//                         //lshanf c01
//                         /*
//                         textelement(E1EDPT2_0001)
//                         {
//                             XmlName = 'E1EDPT2';
//                             textattribute(SEGMENT24)
//                             {
//                                 XmlName = 'SEGMENT';
//                                 trigger OnBeforePassVariable();
//                                 begin
//                                     SEGMENT24 := '1';
//                                 end;
//                             }
//                             textelement(TDLINE_0001)
//                             {
//                                 XmlName = 'TDLINE';
//                                 trigger OnBeforePassVariable()
//                                 begin
//                                     TDLINE_0001 := PosHeaderText;
//                                 end;
//                             }
//                             textelement(TDFORMAT_0001)
//                             {
//                                 XmlName = 'TDFORMAT';
//                                 trigger OnBeforePassVariable();
//                                 begin
//                                     TDFORMAT_0001 := '*';
//                                 end;
//                             }
//                         }
//                         */
//                         //lshend c01
//                     }
//                     textelement(E1EDPT1)
//                     {

//                         textattribute(SEGMENT20)
//                         {
//                             XmlName = 'SEGMENT';
//                             trigger OnBeforePassVariable();
//                             begin
//                                 SEGMENT20 := '1';
//                             end;
//                         }
//                         textelement(TDID_Z007)
//                         {
//                             XmlName = 'TDID';
//                             trigger OnBeforePassVariable();
//                             begin
//                                 TDID_Z007 := 'Z007';
//                             end;
//                         }
//                         textelement(TSSPRAS_Z007)
//                         {
//                             XmlName = 'TSSPRAS';
//                             trigger OnBeforePassVariable();
//                             begin
//                                 TSSPRAS_Z007 := 'DE';
//                             end;
//                         }
//                         textelement(TSSPRAS_ISO_Z007)
//                         {
//                             XmlName = 'TSSPRAS_ISO';
//                             trigger OnBeforePassVariable();
//                             begin
//                                 TSSPRAS_ISO_Z007 := 'DE';
//                             end;
//                         }
//                         textelement(E1EDPT2)
//                         {
//                             textattribute(SEGMENT21)
//                             {
//                                 XmlName = 'SEGMENT';
//                                 trigger OnBeforePassVariable();
//                                 begin
//                                     SEGMENT21 := '1';
//                                 end;
//                             }
//                             textelement(TDLINE)
//                             {

//                                 trigger OnBeforePassVariable()
//                                 begin
//                                     TDLINE := "PurchaseLine".Description + ' ' + "PurchaseLine"."Description 2";
//                                 end;
//                             }
//                             textelement(TDFORMAT_Z007)
//                             {
//                                 XmlName = 'TDFORMAT';
//                                 trigger OnBeforePassVariable();
//                                 begin
//                                     TDFORMAT_Z007 := '*';
//                                 end;
//                             }
//                         }
//                     }
//                     trigger OnAfterGetRecord()
//                     begin
//                         ItemRef.SetRange(ItemRef."Item No.", "Purchase Line"."No.");
//                         ItemRef.SetRange(ItemRef."Reference Type", ItemRef."Reference Type"::Customer);
//                         ItemRef.SetRange(ItemRef."Reference Type No.", Cust."No.");
//                         if not ItemRef.FindFirst() then begin
//                             ItemRef.Init();
//                             ItemRef."Reference No." := "Purchase Line"."No.";
//                         end;

//                         PosHeaderText := '';
//                         PurchLineTextHdr.SetRange(PurchLineTextHdr."Document Type", "Purchase Line"."Document Type");
//                         PurchLineTextHdr.SetRange(PurchLineTextHdr."Document No.", "Purchase Line"."Document No.");
//                         PurchLineTextHdr.SetRange(PurchLineTextHdr."No.");
//                         PurchLineTextHdr.SetFilter(PurchLineTextHdr."Line No.", '<%1', "Purchase Line"."Line No.");
//                         PurchLineTextHdr.SetFilter(PurchLineTextHdr.Type, '<>%1', 0);
//                         if PurchLineTextHdr.FindLast() then
//                             if (PurchLineTextHdr.Type = PurchLineTextHdr.Type::"G/L Account") and (PurchLineTextHdr."No." = 'TEXT') then begin
//                                 PosHeaderText := PurchLineTextHdr.Description;
//                                 PurchLineTextLines.SetRange(PurchLineTextLines."Document Type", "Purchase Line"."Document Type");
//                                 PurchLineTextLines.SetRange(PurchLineTextLines."Document No.", "Purchase Line"."Document No.");
//                                 PurchLineTextLines.SetRange(PurchLineTextLines.Type, PurchLineTextLines.Type::" ");
//                                 PurchLineTextLines.SetRange(PurchLineTextLines."Attached to Line No.", PurchLineTextHdr."Line No.");
//                                 if PurchLineTextLines.FindSet() then
//                                     repeat
//                                         PosHeaderText := PosHeaderText + ' ' + PurchLineTextLines.Description;
//                                     until (PurchLineTextLines.Next() = 0) or (StrLen(PosHeaderText) > 500);
//                             end;

//                         PurchaseLine.Get("Purchase Line"."Document Type", "Purchase Line"."Document No.", "Purchase Line"."Line No.");
//                     end;

//                     trigger OnPreXmlItem()
//                     begin
//                         "Purchase Line".SetRange("Purchase Line"."Document No.", "PurchaseHeader"."No.");
//                     end;
//                 }
//             }

//             trigger OnAfterGetRecord()
//             var
//             begin
//                 if not Vend.Get("Purchase Header"."Buy-from Vendor No.") then
//                     Vend.Init();

//                 if not Cust.Get("Purchase Header"."Sell-to Customer No.") then
//                     Cust.Init();

//                 if not ShipToAddr.Get("Purchase Header"."Sell-to Customer No.", "Purchase Header"."Ship-to Code") then
//                     ShipToAddr.Init();

//                 if not SalesHeader.Get(SalesHeader."Document Type"::Order, "Purchase Header"."Sales Order No.") then
//                     SalesHeader.Init();

//                 CompInfo.Get();
//                 PurchaseHeader.Get("Purchase Header"."Document Type", "Purchase Header"."No.");

//                 if ("Purchase Header"."Sell-to Customer No." = '') and ("Purchase Header"."Ship-to Code" = '') then begin

//                     Cust."Lieferanten - Adress-Nummer" := CopyStr(Vend."Our Account No.", 1, 10);

//                     "Purchase Header"."Ship-to Name" := CompInfo.Name;
//                     "Purchase Header"."Ship-to Name 2" := CompInfo."Name 2";
//                     "Purchase Header"."Ship-to Address" := CompInfo.Address;
//                     "Purchase Header"."Ship-to Address 2" := CompInfo."Address 2";
//                     "Purchase Header"."Ship-to City" := CompInfo.City;
//                     "Purchase Header"."Ship-to Post Code" := CompInfo."Post Code";
//                     "Purchase Header"."Ship-to Country/Region Code" := CompInfo."Country/Region Code";
//                 end;
//                 if ("Purchase Header"."Ship-to Country/Region Code" = '') or ("Purchase Header"."Ship-to Country/Region Code" = 'D') then
//                     "Purchase Header"."Ship-to Country/Region Code" := 'DE';

//                 if ("Purchase Header"."Sell-to Customer No." <> '') and ("Purchase Header"."Ship-to Code" <> '') then
//                     Cust."Lieferanten - Adress-Nummer" := ShipToAddr."Lieferanten - Adress-Nummer";

//                 //lshanf c04
//                 /*
//                 if StrLen("Purchase Header"."Ship-to Name") > 35 then begin
//                     SetFieldID("Purchase Header".FieldNo("Ship-to Name"));
//                     Error('%1 ist länger als 35 Zeichen.', "Purchase Header".FieldCaption("Ship-to Name"));
//                 end;
//                 if StrLen("Purchase Header"."Ship-to Name 2") > 35 then begin
//                     SetFieldID("Purchase Header".FieldNo("Ship-to Name 2"));
//                     Error('%1 ist länger als 35 Zeichen.', "Purchase Header".FieldCaption("Ship-to Name 2"));
//                 end;
//                 if StrLen("Purchase Header"."Ship-to Address") > 35 then begin
//                     SetFieldID("Purchase Header".FieldNo("Ship-to Address"));
//                     Error('%1 ist länger als 35 Zeichen.', "Purchase Header".FieldCaption("Ship-to Address"));
//                 end;
//                 if StrLen("Purchase Header"."Ship-to Address 2") > 35 then begin
//                     SetFieldID("Purchase Header".FieldNo("Ship-to Address 2"));
//                     Error('%1 ist länger als 35 Zeichen.', "Purchase Header".FieldCaption("Ship-to Address 2"));
//                 end;
//                 if StrLen("Purchase Header"."Ship-to City") > 35 then begin
//                     SetFieldID("Purchase Header".FieldNo("Ship-to City"));
//                     Error('%1 ist länger als 35 Zeichen.', "Purchase Header".FieldCaption("Ship-to City"));
//                 end;
//                 */
//                 //lshend c04


//                 //lshanf c05
//                 /*
//                 PurchLine.SetRange(PurchLine."Document Type", "Purchase Header"."Document Type");
//                 PurchLine.SetRange(PurchLine."Document No.", "Purchase Header"."No.");
//                 if PurchLine.FindSet() then
//                     repeat
//                         if StrLen(Format(PurchLine."Position No.")) > 6 then begin
//                             SetFieldID(PurchLine.FieldNo("Position No."));
//                             Error('%1 ist länger als 6 Zeichen.', PurchLine."Position No.");
//                         end;
//                     until PurchLine.Next() = 0;
//                 */
//                 //lshend c05              
//             end;

//             trigger OnPreXmlItem()
//             begin

//             end;
//         }
//     }

//     requestpage
//     {

//         layout
//         {
//         }

//         actions
//         {
//         }
//     }

//     var
//         CompInfo: Record "Company Information";
//         Cust: Record Customer;
//         ItemRef: Record "Item Reference";
//         PurchaseHeader: Record "Purchase Header";
//         AttachedPurchLines: Record "Purchase Line";
//         PurchaseLine: Record "Purchase Line";
//         PurchLineTextHdr: Record "Purchase Line";
//         PurchLineTextLines: Record "Purchase Line";
//         SalesHeader: Record "Sales Header";
//         ShipToAddr: Record "Ship-to Address";
//         Vend: Record Vendor;
//         HeaderText: Text;
//         PosHeaderText: Text;
//         Slash_Lbl: Label '/%1';
// }

