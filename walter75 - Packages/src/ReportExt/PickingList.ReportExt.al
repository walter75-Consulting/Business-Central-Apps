reportextension 90700 "SEW Picking List" extends "Picking List"
{
    dataset
    {
        add("Warehouse Activity Header")
        {
            column(SEWBarcode; EncodedText01) { }
        }

        modify("Warehouse Activity Header")
        {
            trigger OnAfterAfterGetRecord()
            var
                BarcodeSymbology: Enum "Barcode Symbology";
                BarcodeFontProvider: Interface "Barcode Font Provider";
                BarcodeString01: Text;
            begin
                BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
                BarcodeSymbology := Enum::"Barcode Symbology"::Code39;
                BarcodeString01 := "Warehouse Activity Header"."No.";
                BarcodeFontProvider.ValidateInput(BarcodeString01, BarcodeSymbology);
                EncodedText01 := BarcodeFontProvider.EncodeFont(BarcodeString01, BarcodeSymbology);
            end;
        }

        add(WhseActLine)
        {
            column(SEWBarcodeItem; EncodedText02) { }
        }
        modify(WhseActLine)
        {
            trigger OnAfterAfterGetRecord()
            var
                BarcodeSymbology: Enum "Barcode Symbology";
                BarcodeFontProvider: Interface "Barcode Font Provider";
                BarcodeString02: Text;
            begin
                BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
                BarcodeSymbology := Enum::"Barcode Symbology"::Code39;
                BarcodeString02 := WhseActLine."Item No.";
                BarcodeFontProvider.ValidateInput(BarcodeString02, BarcodeSymbology);
                EncodedText02 := BarcodeFontProvider.EncodeFont(BarcodeString02, BarcodeSymbology);
            end;
        }

    }




    rendering
    {
        layout("SEW Picking List01")
        {
            Type = RDLC;
            LayoutFile = './src/ReportExt/Layout/PickingList01.rdlc';
            Caption = 'Picking List';
            Summary = 'Picking List with Barcodes';
        }
    }


    var
        EncodedText01: Text;
        EncodedText02: Text;
}