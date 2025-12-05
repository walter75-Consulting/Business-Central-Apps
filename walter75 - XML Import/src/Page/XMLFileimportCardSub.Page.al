page 60508 "SEW XML Fileimport Card Sub"
{
    ApplicationArea = All;
    Caption = 'XML Fileimport Card Sub';
    PageType = ListPart;
    SourceTable = "SEW XML Fileimport Line";
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                Caption = 'General';

                field(id; Rec.id) { }
                field(FiletransferId; Rec.transferID) { }

                field(MATNR; Rec.MATNR) { }
                field(KDMAT; Rec.KDMAT) { }
                field(ARKTX; Rec.ARKTX) { }

                field("Purch. Order Date"; Rec."Purch. Order Date") { }
                field("Purch. Order No."; Rec."Purch. Order No.") { }
                field("Purch. Order Line No."; Rec."Purch. Order Line No.") { }
                field("Purch. Order Qty"; Rec."Purch. Order Qty") { }
                field("Ext. Sales Order Date"; Rec."Ext. Sales Order Date") { }
                field("Ext. Sales Order No."; Rec."Ext. Sales Order No.") { }
                field("Ext. Sales Order Line No."; Rec."Ext. Sales Order Line No.") { }
                field("Ext. Sales Order Qty"; Rec."Ext. Sales Order Qty") { }
                field("Ext. Shipment Date"; Rec."Ext. Shipment Date") { }
                field("Ext. Shipment No."; Rec."Ext. Shipment No.") { }
                field("Ext. Shipment Line No."; Rec."Ext. Shipment Line No.") { }
                field("Ext. Shipment Qty"; Rec."Ext. Shipment Qty") { }
                field("Ext. Invoice Date"; Rec."Ext. Invoice Date") { }
                field("Ext. Invoice No."; Rec."Ext. Invoice No.") { }
                field("Ext. Invoice Line No."; Rec."Ext. Invoice Line No.") { }
                field("Ext. Invoice Qty"; Rec."Ext. Invoice Qty") { }
                field("Unit of Measure"; Rec."Unit of Measure") { }
                field("Unit Cost"; Rec."Unit Cost") { }
                field("Unit Cost Line Amount"; Rec."Unit Cost Line Amount") { }

                field("Weight Net"; Rec."Weight Net") { }
                field("Weight Gross"; Rec."Weight Gross") { }
                field("Weight Unit"; Rec."Weight Unit") { }
                field(Volume; Rec."Volume") { }
                field("Volume Unit"; Rec."Volume Unit") { }
                field("Country of Origin"; Rec."Country of Origin") { }
            }
        }
    }
}
