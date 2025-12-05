table 60503 "SEW XML Fileimport Line"
{
    Caption = 'XML Fileimport Line';
    DataClassification = CustomerContent;
    DrillDownPageId = "SEW XML Fileimport Line";
    LookupPageId = "SEW XML Fileimport Line";

    fields
    {
        field(1; id; Integer)
        {
            Caption = 'ID';
            ToolTip = 'Specifies the unique identifier for each record.';
        }
        field(2; transferID; Integer)
        {
            Caption = 'Transfer ID';
            ToolTip = 'Specifies the identifier of the associated transfer record.';
            AllowInCustomizations = Never;
        }
        field(3; MATNR; Code[50]) // Material Number
        {
            Caption = 'Material Number';
            ToolTip = 'Specifies the material number associated with the item.';
            TableRelation = Item."Vendor Item No." where("Vendor No." = const('70100'));
        }
        field(4; KDMAT; Code[20]) // Customer Material Number
        {
            Caption = 'Customer Material Number';
            ToolTip = 'Specifies the customer material number associated with the item.';
            TableRelation = Item."No.";
        }
        field(5; ARKTX; Text[150]) // Description
        {
            Caption = 'Description';
            ToolTip = 'Specifies the description of the item.';
        }
        field(17; "Purch. Order Date"; Date)
        {
            Caption = 'Purch. Order Date';
            ToolTip = 'Specifies the purchase order date associated with the transfer.';
            AllowInCustomizations = Never;
        }
        field(18; "Purch. Order No."; Code[20])
        {
            Caption = 'Purch. Order No.';
            ToolTip = 'Specifies the purchase order number associated with the transfer.';
            AllowInCustomizations = Never;
            TableRelation = "Purchase Header"."No." where("Document Type" = const(Order));
        }
        field(19; "Purch. Order Line No."; Integer)
        {
            Caption = 'Purch. Order Line No.';
            ToolTip = 'Specifies the purchase order line number associated with the item.';
            AllowInCustomizations = Never;
            TableRelation = "Purchase Line"."Line No." where("Document Type" = const(Order),
                                                           "Document No." = field("Purch. Order No."));
        }
        field(20; "Purch. Order Qty"; Decimal)
        {
            Caption = 'Purch. Order Qty';
            ToolTip = 'Specifies the quantity of items in the purchase order.';
            DecimalPlaces = 0 : 5;
            AllowInCustomizations = Never;
        }
        field(21; "Ext. Sales Order Date"; Date)
        {
            Caption = 'Ext. Sales Order Date';
            ToolTip = 'Specifies the external sales order date associated with the item.';
            AllowInCustomizations = Never;
        }

        field(22; "Ext. Sales Order No."; Code[35])
        {
            Caption = 'Ext. Sales Order No.';
            ToolTip = 'Specifies the external sales order number associated with the item.';
            AllowInCustomizations = Never;
        }
        field(23; "Ext. Sales Order Line No."; Integer)
        {
            Caption = 'Ext. Sales Order Line No.';
            ToolTip = 'Specifies the external sales order line number associated with the item.';
            AllowInCustomizations = Never;
        }
        field(24; "Ext. Sales Order Qty"; Decimal)
        {
            Caption = 'Ext. Sales Order Qty';
            ToolTip = 'Specifies the quantity of items in the external sales order.';
            DecimalPlaces = 0 : 5;
            AllowInCustomizations = Never;
        }
        field(25; "Ext. Shipment Date"; Date)
        {
            Caption = 'Ext. Shipment Date';
            ToolTip = 'Specifies the external shipment date associated with the item.';
            AllowInCustomizations = Never;
        }
        field(26; "Ext. Shipment No."; Code[35])
        {
            Caption = 'Ext. Shipment No.';
            ToolTip = 'Specifies the external shipment number associated with the item.';
            AllowInCustomizations = Never;
            TableRelation = "SEW XML Fileimport"."Ext. Shipment No.";
        }
        field(27; "Ext. Shipment Line No."; Integer)
        {
            Caption = 'Ext. Shipment Line No.';
            ToolTip = 'Specifies the external shipment line number associated with the item.';
            AllowInCustomizations = Never;
        }
        field(28; "Ext. Shipment Qty"; Decimal)
        {
            Caption = 'Ext. Shipment Qty';
            ToolTip = 'Specifies the quantity of items in the external shipment.';
            DecimalPlaces = 0 : 5;
            AllowInCustomizations = Never;
        }
        field(29; "Ext. Invoice Date"; Date)
        {
            Caption = 'Ext. Invoice Date';
            ToolTip = 'Specifies the external invoice date associated with the transfer.';
            AllowInCustomizations = Never;
        }
        field(30; "Ext. Invoice No."; Code[35])
        {
            Caption = 'Ext. Invoice No.';
            ToolTip = 'Specifies the external invoice number associated with the transfer.';
            AllowInCustomizations = Never;
            TableRelation = "SEW XML Fileimport"."Ext. Invoice No.";
        }
        field(31; "Ext. Invoice Line No."; Integer)
        {
            Caption = 'External Invoice Line No.';
            ToolTip = 'Specifies the external invoice line number associated with the transfer.';
            AllowInCustomizations = Never;
        }
        field(32; "Ext. Invoice Qty"; Decimal)
        {
            Caption = 'Ext. Invoice Qty';
            ToolTip = 'Specifies the quantity of items in the external invoice.';
            DecimalPlaces = 0 : 5;
            AllowInCustomizations = Never;
        }
        field(10; "Unit of Measure"; Code[10]) // Unit of Measure for Quantity
        {
            Caption = 'Unit of Measure for Quantity';
            ToolTip = 'Specifies the unit of measure for the quantity of items.';
            AllowInCustomizations = Never;
            TableRelation = "Unit of Measure"."SEW SAP Code";
        }

        field(33; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
            ToolTip = 'Specifies the unit cost of the item.';
            AutoFormatType = 1;
            AllowInCustomizations = Never;
        }
        field(41; "Unit Cost Line Amount"; Decimal)
        {
            Caption = 'Unit Cost Line Amount';
            ToolTip = 'Specifies the unit cost line amount of the item.';
            AutoFormatType = 1;
            AllowInCustomizations = Never;
        }


        field(34; "Weight Net"; Decimal)
        {
            Caption = 'Net Weight';
            ToolTip = 'Specifies the net weight of the item.';
            DecimalPlaces = 0 : 5;
            AllowInCustomizations = Never;
        }
        field(36; "Weight Gross"; Decimal) // Gross Weight
        {
            Caption = 'Gross Weight';
            ToolTip = 'Specifies the gross weight of the item.';
            DecimalPlaces = 0 : 5;
            AllowInCustomizations = Never;
        }
        field(37; "Weight Unit"; Code[10]) // Weight Unit
        {
            Caption = 'Weight Unit';
            ToolTip = 'Specifies the weight unit associated with the item.';
            TableRelation = "Unit of Measure"."SEW SAP Code";
        }
        field(38; Volume; Decimal) // Volume
        {
            Caption = 'Volume';
            ToolTip = 'Specifies the volume of the item.';
            DecimalPlaces = 0 : 5;
        }
        field(39; "Volume Unit"; Code[10]) // Volume Unit
        {
            Caption = 'Volume Unit';
            ToolTip = 'Specifies the volume unit associated with the item.';
            TableRelation = "Unit of Measure"."SEW SAP Code";
        }
        field(40; "Country of Origin"; Code[10])
        {
            Caption = 'Country of Origin';
            ToolTip = 'Specifies the country of origin of the item.';
            AllowInCustomizations = Never;
            TableRelation = "Country/Region"."Code";
        }
    }

    keys
    {
        key(PK; "id")
        {
            Clustered = true;
        }
        key(Key2; transferID)
        {
            MaintainSIFTIndex = true;
            SumIndexFields = "Unit Cost Line Amount";
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; MATNR, KDMAT, ARKTX) { }
        fieldgroup(Brick; MATNR, KDMAT, ARKTX) { }
    }

    trigger OnInsert()
    begin
        if Rec.transferID <> 0 then
            Rec.transferID := GetLastEntryNo() + 1;
    end;

    procedure GetLastEntryNo(): Integer
    var
        FindRecordManagement: Codeunit "Find Record Management";
    begin
        exit(FindRecordManagement.GetLastEntryIntFieldValue(Rec, FieldNo("id")));
    end;

}