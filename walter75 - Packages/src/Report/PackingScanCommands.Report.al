namespace walterPackages.walterPackages;
using System.Text;

report 90700 "SEW Packing Scan Commands"
{
    DefaultRenderingLayout = "SEW Packing Scan Commands01";
    Caption = 'Packing Scan Commands';
    UsageCategory = Administration;
    ApplicationArea = All;
    Permissions = tabledata "SEW Package Material" = R;

    dataset
    {
        dataitem("SEWPackageMaterial"; "SEW Package Material")
        {
            DataItemTableView = sorting(Code);


            column(PackageCode; Code) { }
            column(PackageDescription; Description) { }
            column(EncodedText01; EncodedText01) { }

            column(CmdDocScan; CmdDocScan) { }
            column(CmdDocScanLbl; CmdDocScanLbl) { }
            column(CmdDocClear; CmdDocClear) { }
            column(CmdDocClearLbl; CmdDocClearLbl) { }
            column(CmdDocClose; CmdDocClose) { }
            column(CmdDocCloseLbl; CmdDocCloseLbl) { }
            column(CmdScanItem; CmdScanItem) { }
            column(CmdScanItemLbl; CmdScanItemLbl) { }
            column(CmdLineUp; CmdLineUp) { }
            column(CmdLineUpLbl; CmdLineUpLbl) { }
            column(CmdLineDown; CmdLineDown) { }
            column(CmdLineDownLbl; CmdLineDownLbl) { }
            column(CmdLinePack; CmdLinePack) { }
            column(CmdLinePackLbl; CmdLinePackLbl) { }
            column(CmdLineUnpack; CmdLineUnpack) { }
            column(CmdLineUnpackLbl; CmdLineUnpackLbl) { }
            column(CmdPackageNew; CmdPackageNew) { }
            column(CmdPackageNewLbl; CmdPackageNewLbl) { }
            column(CmdPackageDelete; CmdPackageDelete) { }
            column(CmdPackageDeleteLbl; CmdPackageDeleteLbl) { }
            column(CmdPackageClear; CmdPackageClear) { }
            column(CmdPackageClearLbl; CmdPackageClearLbl) { }
            column(CmdPackagePost; CmdPackagePost) { }
            column(CmdPackagePostLbl; CmdPackagePostLbl) { }
            column(CmdPackagePrintLabel; CmdPackagePrintLabel) { }
            column(CmdPackagePrintLabelLbl; CmdPackagePrintLabelLbl) { }
            column(CmdPackagePrintDelNote; CmdPackagePrintDelNote) { }
            column(CmdPackagePrintDelNoteLbl; CmdPackagePrintDelNoteLbl) { }
            column(CmdPackagePrintPackingList; CmdPackagePrintPackingList) { }
            column(CmdPackagePrintPackingListLbl; CmdPackagePrintPackingListLbl) { }
            column(CmdPackagePostAndPrint; CmdPackagePostAndPrint) { }
            column(CmdPackagePostAndPrintLbl; CmdPackagePostAndPrintLbl) { }
            column(CmdDocPost; CmdDocPost) { }
            column(CmdDocPostLbl; CmdDocPostLbl) { }
            column(CmdDocPrintDelNote; CmdDocPrintDelNote) { }
            column(CmdDocPrintDelNoteLbl; CmdDocPrintDelNoteLbl) { }
            column(CmdDocPostAndPrint; CmdDocPostAndPrint) { }
            column(CmdDocPostAndPrintLbl; CmdDocPostAndPrintLbl) { }
            column(CmdDocPrintInvoice; CmdDocPrintInvoice) { }
            column(CmdDocPrintInvoiceLbl; CmdDocPrintInvoiceLbl) { }

            trigger OnAfterGetRecord()
            var
                BarcodeSymbology: Enum "Barcode Symbology";
                BarcodeFontProvider: Interface "Barcode Font Provider";
                BarcodeString01: Text;

            begin
                Clear(EncodedText01);
                Clear(BarcodeString01);

                BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
                BarcodeSymbology := Enum::"Barcode Symbology"::Code39;
                BarcodeString01 := "SEWPackageMaterial".Code;
                BarcodeFontProvider.ValidateInput(BarcodeString01, BarcodeSymbology);
                EncodedText01 := BarcodeFontProvider.EncodeFont(BarcodeString01, BarcodeSymbology);
            end;

        }



    }

    rendering
    {

        layout("SEW Packing Scan Commands01")
        {
            Type = RDLC;
            LayoutFile = './src/Report/Layout/PackingScanCommands01.rdlc';
            Caption = 'Packing Scan Commands';
            Summary = 'List of Packing Scan Commands with Barcodes';
        }
    }



    trigger OnPreReport()
    var
        BarcodeSymbology: Enum System.Text."Barcode Symbology";
        BarcodeFontProvider: Interface System.Text."Barcode Font Provider";
    begin
        CmdDocScanBC := '--SDC';
        CmdDocClearBC := '--CDC';
        CmdDocCloseBC := '--CLD';
        CmdScanItemBC := '--SIT';
        CmdLineUpBC := '--LUP';
        CmdLineDownBC := '--LDN';
        CmdLinePackBC := '--LPK';
        CmdLineUnpackBC := '--LUPK';
        CmdPackageNewBC := '--NPK';
        CmdPackageDeleteBC := '--DPK';
        CmdPackageClearBC := '--CPK';
        CmdPackagePostBC := '--PPK';
        CmdPackagePrintLabelBC := '--PLB';
        CmdPackagePrintDelNoteBC := '--PDN';
        CmdPackagePrintPackingListBC := '--PPL';
        CmdPackagePostAndPrintBC := '--PPP';
        CmdDocPostBC := '--PDC';
        CmdDocPrintDelNoteBC := '--PDN';
        CmdDocPostAndPrintBC := '--PPC';
        CmdDocPrintInvoiceBC := '--PIN';




        BarcodeFontProvider := Enum::System.Text."Barcode Font Provider"::IDAutomation1D;
        BarcodeSymbology := Enum::System.Text."Barcode Symbology"::Code39;

        BarcodeFontProvider.ValidateInput(CmdDocScanBC, BarcodeSymbology);
        CmdDocScan := BarcodeFontProvider.EncodeFont(CmdDocScanBC, BarcodeSymbology);

        BarcodeFontProvider.ValidateInput(CmdDocClearBC, BarcodeSymbology);
        CmdDocClear := BarcodeFontProvider.EncodeFont(CmdDocClearBC, BarcodeSymbology);

        BarcodeFontProvider.ValidateInput(CmdDocCloseBC, BarcodeSymbology);
        CmdDocClose := BarcodeFontProvider.EncodeFont(CmdDocCloseBC, BarcodeSymbology);

        BarcodeFontProvider.ValidateInput(CmdScanItemBC, BarcodeSymbology);
        CmdScanItem := BarcodeFontProvider.EncodeFont(CmdScanItemBC, BarcodeSymbology);

        BarcodeFontProvider.ValidateInput(CmdLineUpBC, BarcodeSymbology);
        CmdLineUp := BarcodeFontProvider.EncodeFont(CmdLineUpBC, BarcodeSymbology);

        BarcodeFontProvider.ValidateInput(CmdLineDownBC, BarcodeSymbology);
        CmdLineDown := BarcodeFontProvider.EncodeFont(CmdLineDownBC, BarcodeSymbology);

        BarcodeFontProvider.ValidateInput(CmdLinePackBC, BarcodeSymbology);
        CmdLinePack := BarcodeFontProvider.EncodeFont(CmdLinePackBC, BarcodeSymbology);

        BarcodeFontProvider.ValidateInput(CmdLineUnpackBC, BarcodeSymbology);
        CmdLineUnpack := BarcodeFontProvider.EncodeFont(CmdLineUnpackBC, BarcodeSymbology);

        BarcodeFontProvider.ValidateInput(CmdPackageNewBC, BarcodeSymbology);
        CmdPackageNew := BarcodeFontProvider.EncodeFont(CmdPackageNewBC, BarcodeSymbology);

        BarcodeFontProvider.ValidateInput(CmdPackageDeleteBC, BarcodeSymbology);
        CmdPackageDelete := BarcodeFontProvider.EncodeFont(CmdPackageDeleteBC, BarcodeSymbology);

        BarcodeFontProvider.ValidateInput(CmdPackageClearBC, BarcodeSymbology);
        CmdPackageClear := BarcodeFontProvider.EncodeFont(CmdPackageClearBC, BarcodeSymbology);

        BarcodeFontProvider.ValidateInput(CmdPackagePostBC, BarcodeSymbology);
        CmdPackagePost := BarcodeFontProvider.EncodeFont(CmdPackagePostBC, BarcodeSymbology);

        BarcodeFontProvider.ValidateInput(CmdPackagePrintLabelBC, BarcodeSymbology);
        CmdPackagePrintLabel := BarcodeFontProvider.EncodeFont(CmdPackagePrintLabelBC, BarcodeSymbology);

        BarcodeFontProvider.ValidateInput(CmdPackagePrintDelNoteBC, BarcodeSymbology);
        CmdPackagePrintDelNote := BarcodeFontProvider.EncodeFont(CmdPackagePrintDelNoteBC, BarcodeSymbology);

        BarcodeFontProvider.ValidateInput(CmdPackagePrintPackingListBC, BarcodeSymbology);
        CmdPackagePrintPackingList := BarcodeFontProvider.EncodeFont(CmdPackagePrintPackingListBC, BarcodeSymbology);

        BarcodeFontProvider.ValidateInput(CmdPackagePostAndPrintBC, BarcodeSymbology);
        CmdPackagePostAndPrint := BarcodeFontProvider.EncodeFont(CmdPackagePostAndPrintBC, BarcodeSymbology);

        BarcodeFontProvider.ValidateInput(CmdDocPostBC, BarcodeSymbology);
        CmdDocPost := BarcodeFontProvider.EncodeFont(CmdDocPostBC, BarcodeSymbology);

        BarcodeFontProvider.ValidateInput(CmdDocPrintDelNoteBC, BarcodeSymbology);
        CmdDocPrintDelNote := BarcodeFontProvider.EncodeFont(CmdDocPrintDelNoteBC, BarcodeSymbology);

        BarcodeFontProvider.ValidateInput(CmdDocPostAndPrintBC, BarcodeSymbology);
        CmdDocPostAndPrint := BarcodeFontProvider.EncodeFont(CmdDocPostAndPrintBC, BarcodeSymbology);

        BarcodeFontProvider.ValidateInput(CmdDocPrintInvoiceBC, BarcodeSymbology);
        CmdDocPrintInvoice := BarcodeFontProvider.EncodeFont(CmdDocPrintInvoiceBC, BarcodeSymbology);


    end;

    var
        CmdDocScan: Text;
        CmdDocScanBC: Text;
        CmdDocScanLbl: Label 'Scan Document';

        CmdDocClear: Text;
        CmdDocClearBC: Text;
        CmdDocClearLbl: Label 'Clear Document';

        CmdDocClose: Text;
        CmdDocCloseBC: Text;
        CmdDocCloseLbl: Label 'Close Document';


        CmdScanItem: Text;
        CmdScanItemBC: Text;
        CmdScanItemLbl: Label 'Scan Item ...';

        CmdLineUp: Text;
        CmdLineUpBC: Text;
        CmdLineUpLbl: Label 'Line Up';

        CmdLineDown: Text;
        CmdLineDownBC: Text;
        CmdLineDownLbl: Label 'Line Down';

        CmdLinePack: Text;
        CmdLinePackBC: Text;
        CmdLinePackLbl: Label 'Pack Line';

        CmdLineUnpack: Text;
        CmdLineUnpackBC: Text;
        CmdLineUnpackLbl: Label 'Unpack Line';

        CmdPackageNew: Text;
        CmdPackageNewBC: Text;
        CmdPackageNewLbl: Label 'New Package';

        CmdPackageDelete: Text;
        CmdPackageDeleteBC: Text;
        CmdPackageDeleteLbl: Label 'Delete Package';

        CmdPackageClear: Text;
        CmdPackageClearBC: Text;
        CmdPackageClearLbl: Label 'Clear Package';

        CmdPackagePost: Text;
        CmdPackagePostBC: Text;
        CmdPackagePostLbl: Label 'Post Package';

        CmdPackagePrintLabel: Text;
        CmdPackagePrintLabelBC: Text;
        CmdPackagePrintLabelLbl: Label 'Print Package Label';

        CmdPackagePrintDelNote: Text;
        CmdPackagePrintDelNoteBC: Text;
        CmdPackagePrintDelNoteLbl: Label 'Print Delivery Note';

        CmdPackagePrintPackingList: Text;
        CmdPackagePrintPackingListBC: Text;
        CmdPackagePrintPackingListLbl: Label 'Print Packing List';

        CmdPackagePostAndPrint: Text;
        CmdPackagePostAndPrintBC: Text;
        CmdPackagePostAndPrintLbl: Label 'Post and Print Package Documents';

        CmdDocPost: Text;
        CmdDocPostBC: Text;
        CmdDocPostLbl: Label 'Post Document';

        CmdDocPrintDelNote: Text;
        CmdDocPrintDelNoteBC: Text;
        CmdDocPrintDelNoteLbl: Label 'Print Delivery Note';

        CmdDocPostAndPrint: Text;
        CmdDocPostAndPrintBC: Text;
        CmdDocPostAndPrintLbl: Label 'Post and Print Documents';

        CmdDocPrintInvoice: Text;
        CmdDocPrintInvoiceBC: Text;
        CmdDocPrintInvoiceLbl: Label 'Print Invoice';


        EncodedText01: Text;
}
