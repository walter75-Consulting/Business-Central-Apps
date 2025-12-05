table 60500 "SEW XML Fileimport"
{
    Caption = 'XML Fileimport';
    DataClassification = CustomerContent;
    DrillDownPageId = "SEW XML Fileimport Card";
    LookupPageId = "SEW XML Fileimport Card";

    Permissions = tabledata "SEW XML Fileimport" = rimd,
                    tabledata "SEW XML Fileimport Line" = rimd,
                    tabledata "SEW XML Fileimport Address" = rimd,
                    tabledata "SEW XML Fileimport Cost" = rimd;

    fields
    {
        field(1; transferID; Integer)
        {
            Caption = 'transferID';
            ToolTip = 'Unique ID for the file transfer.';
        }
        field(2; "Doc Type"; Enum "SEW Transfer Type")
        {
            Caption = 'Transfer Type';
            ToolTip = 'Specifies the type of transfer.';
            AllowInCustomizations = Never;
        }
        field(3; "Doc Status"; Enum "SEW Transfer Status")
        {
            Caption = 'Status';
            ToolTip = 'Specifies the status of the file transfer.';
            AllowInCustomizations = Never;
        }
        field(4; "Doc No."; Text[50])
        {
            Caption = 'Transfer Document No.';
            ToolTip = 'Specifies the document number associated with the file import.';
            AllowInCustomizations = Never;
        }

        field(5; "Purch. Order No."; Code[20])
        {
            Caption = 'Purch. Order No.';
            ToolTip = 'Specifies the purchase order number associated with the transfer.';
            TableRelation = "Purchase Header"."No." where("Document Type" = const(Order));
            AllowInCustomizations = Never;
        }
        field(6; "Purch. Order Date"; Date)
        {
            Caption = 'Purch. Order Date';
            ToolTip = 'Specifies the purchase order date associated with the transfer.';
            TableRelation = "Purchase Header"."No." where("Document Type" = const(Order));
            AllowInCustomizations = Never;
        }
        field(7; "Ext. Sales Order No."; Code[35])
        {
            Caption = 'External SO No.';
            ToolTip = 'Specifies the external SO number associated with the transfer.';
            AllowInCustomizations = Never;
            TableRelation = "SEW XML Fileimport"."Ext. Sales Order No." where("Doc Type" = const("SEW Transfer Type"::"Order Response"));
        }
        field(8; "Ext. Sales Order Date"; Date)
        {
            Caption = 'External SO Date';
            ToolTip = 'Specifies the external SO date associated with the transfer.';
            AllowInCustomizations = Never;
        }
        field(9; "Ext. Shipment No."; Code[35])
        {
            Caption = 'External Shipment No.';
            ToolTip = 'Specifies the external shipment number associated with the transfer.';
            AllowInCustomizations = Never;
            TableRelation = "SEW XML Fileimport"."Ext. Shipment No." where("Doc Type" = const("SEW Transfer Type"::"Delivery Note"));
        }
        field(10; "Ext. Shipment Date"; Date)
        {
            Caption = 'External Shipment Date';
            ToolTip = 'Specifies the external shipment date associated with the transfer.';
            AllowInCustomizations = Never;
        }
        field(11; "Ext. Invoice No."; Code[35])
        {
            Caption = 'External Invoice No.';
            ToolTip = 'Specifies the external invoice number associated with the transfer.';
            AllowInCustomizations = Never;
            TableRelation = "SEW XML Fileimport"."Ext. Invoice No." where("Doc Type" = const("SEW Transfer Type"::Invoice));
        }
        field(12; "Ext. Invoice Date"; Date)
        {
            Caption = 'External Invoice Date';
            ToolTip = 'Specifies the external invoice date associated with the transfer.';
            AllowInCustomizations = Never;
        }
        field(13; "Faktura Type"; Code[5])
        {
            Caption = 'FT';
            ToolTip = 'Specifies the type of invoice.';
            AllowInCustomizations = Never;
        }
        field(14; "Faktura Type2"; Code[5])
        {
            Caption = 'FT2';
            ToolTip = 'Specifies the type of invoice.';
            AllowInCustomizations = Never;
        }
        field(15; "Partner AG"; Code[35])
        {
            Caption = 'Partner AG';
            ToolTip = 'Specifies the partner AG associated with the file import.';
            TableRelation = "SEW XML Fileimport Address".PARTNER_ID where(PARTNER_Q = const('AG'));
            AllowInCustomizations = Never;
        }
        field(16; "Partner WE"; Code[35])
        {
            Caption = 'Partner WE';
            ToolTip = 'Specifies the partner WE associated with the file import.';
            TableRelation = "SEW XML Fileimport Address".PARTNER_ID where(PARTNER_Q = const('WE'));
            AllowInCustomizations = Never;
        }
        field(17; "Partner ZK"; Code[35])
        {
            Caption = 'Partner ZK';
            ToolTip = 'Specifies the partner ZK associated with the file import.';
            TableRelation = "SEW XML Fileimport Address".PARTNER_ID where(PARTNER_Q = const('ZK'));
            AllowInCustomizations = Never;
        }
        field(18; "Partner OSP"; Code[35])
        {
            Caption = 'Partner OSP';
            ToolTip = 'Specifies the partner OSP associated with the file import.';
            TableRelation = "SEW XML Fileimport Address".PARTNER_ID where(PARTNER_Q = const('OSP'));
            AllowInCustomizations = Never;
        }
        field(19; "Partner OSO"; Code[35])
        {
            Caption = 'Partner OSO';
            ToolTip = 'Specifies the partner OSO associated with the file import.';
            TableRelation = "SEW XML Fileimport Address".PARTNER_ID where(PARTNER_Q = const('OSO'));
            AllowInCustomizations = Never;
        }
        field(20; "Partner BK"; Code[35])
        {
            Caption = 'Partner BK';
            ToolTip = 'Specifies the partner BK associated with the file import.';
            TableRelation = "SEW XML Fileimport Address".PARTNER_ID where(PARTNER_Q = const('BK'));
            AllowInCustomizations = Never;
        }
        field(21; "Partner RG"; Code[35])
        {
            Caption = 'Partner RG';
            ToolTip = 'Specifies the partner RG associated with the file import.';
            TableRelation = "SEW XML Fileimport Address".PARTNER_ID where(PARTNER_Q = const('RG'));
            AllowInCustomizations = Never;
        }
        field(22; "Partner RE"; Code[35])
        {
            Caption = 'Partner RE';
            ToolTip = 'Specifies the partner RE associated with the file import.';
            TableRelation = "SEW XML Fileimport Address".PARTNER_ID where(PARTNER_Q = const('RE'));
            AllowInCustomizations = Never;
        }
        field(23; "Partner RS"; Code[35])
        {
            Caption = 'Partner RS';
            ToolTip = 'Specifies the partner RS associated with the file import.';
            TableRelation = "SEW XML Fileimport Address".PARTNER_ID where(PARTNER_Q = const('RS'));
            AllowInCustomizations = Never;
        }
        field(24; "Ship to Address No."; Code[10])
        {
            Caption = 'Ship to Address No.';
            ToolTip = 'Specifies the ship-to address number associated with the transfer.';
            AllowInCustomizations = Never;
            TableRelation = "Ship-to Address".Code;
        }


        field(25; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
            ToolTip = 'Specifies the line amount associated with the transfer.';
            AutoFormatType = 1;
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("SEW XML Fileimport Line"."Unit Cost Line Amount" where(transferID = field(transferID)));
            AllowInCustomizations = Never;
        }
        field(26; "Cost Amount"; Decimal)
        {
            Caption = 'Cost Amount';
            ToolTip = 'Specifies the cost amount associated with the transfer.';
            AutoFormatType = 1;
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("SEW XML Fileimport Cost"."Cost Amount" where(transferID = field(transferID)));
            AllowInCustomizations = Never;
        }

        field(27; "Doc Amount net"; Decimal)
        {
            Caption = 'Doc Amount net';
            ToolTip = 'Specifies the document amount (net) associated with the transfer.';
            AutoFormatType = 1;
            AllowInCustomizations = Never;
        }
        field(28; "Doc Currency"; Code[10])
        {
            Caption = 'Document Currency';
            ToolTip = 'Specifies the currency code for the document amounts.';
            TableRelation = Currency.Code;
            AllowInCustomizations = Never;
        }
        field(29; "Doc Count of Lines"; Integer)
        {
            Caption = 'Doc Count of Lines';
            ToolTip = 'Specifies the number of lines associated with the transfer.';
            AllowInCustomizations = Never;
        }


        field(30; "Count of Lines"; Integer)
        {
            Caption = 'Count of Lines';
            ToolTip = 'Specifies the number of lines associated with the transfer.';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("SEW XML Fileimport Line" where(transferID = field(transferID)));
            AllowInCustomizations = Never;
        }

        field(31; "Transfer Date/Time"; DateTime)
        {
            Caption = 'Transfer Date/Time';
            ToolTip = 'Specifies the date and time of the transfer.';
        }
        field(32; FileContentBlob; Blob)
        {
            Caption = 'Transfer Content';
            ToolTip = 'Specifies the content of the transfer in a blob field.';
        }
        field(33; "Doc Creation Date"; Date)
        {
            Caption = 'Creation Date';
            ToolTip = 'Specifies the date when the file import record was created.';
            AllowInCustomizations = Never;
        }
        field(34; "Doc Creation Time"; Time)
        {
            Caption = 'Creation Time';
            ToolTip = 'Specifies the time when the file import record was created.';
            AllowInCustomizations = Never;
        }
        field(35; "Doc Processed Date/Time"; DateTime)
        {
            Caption = 'Processed Date/Time';
            ToolTip = 'Specifies the date and time when the transfer was processed.';
            AllowInCustomizations = Never;
        }
        field(36; "Doc Imported"; Boolean)
        {
            Caption = 'Imported';
            ToolTip = 'Specifies whether the file has been imported.';
            AllowInCustomizations = Never;
        }
        field(37; ExtDocNo; Code[35])
        {
            Caption = 'Externe Belegnr.';
            ToolTip = 'Specifies whether the file has been imported.';
            AllowInCustomizations = Never;
        }
        field(38; Processed; Boolean)
        {
            Caption = 'Processed';
            ToolTip = 'Specifies whether the file has been processed.';
            AllowInCustomizations = Never;
        }

    }

    keys
    {
        key(PK; "transferID")
        {
            Clustered = true;
        }
        key(ExtDoc; ExtDocNo) { }

    }

    fieldgroups
    {
        fieldgroup(DropDown; "Purch. Order No.", "Ext. Sales Order No.", "Ext. Shipment No.", "Ext. Invoice No.", "Doc Type", "Doc Status", "Doc No.")
        {
        }
        fieldgroup(Brick; "Purch. Order No.", "Ext. Sales Order No.", "Ext. Shipment No.", "Ext. Invoice No.", "Doc Type", "Doc Status", "Doc No.")
        {
        }
    }

    trigger OnInsert()
    begin
        Rec.transferID := GetLastEntryNo() + 1;
        Rec."Transfer Date/Time" := CurrentDateTime();
    end;

    trigger OnDelete()
    var
        SEWXMLFileimportLine: Record "SEW XML Fileimport Line";
        SEWXMLFileimportCost: Record "SEW XML Fileimport Cost";
    begin
        SEWXMLFileimportLine.Reset();
        SEWXMLFileimportLine.SetRange(transferID, Rec.transferID);
        if SEWXMLFileimportLine.FindSet(true) then
            SEWXMLFileimportLine.DeleteAll(false);

        SEWXMLFileimportCost.Reset();
        SEWXMLFileimportCost.SetRange(transferID, Rec.transferID);
        if SEWXMLFileimportCost.FindSet(true) then
            SEWXMLFileimportCost.DeleteAll(false);
    end;

    procedure GetFileContent(): Text
    var
        InStream: InStream;
        TextValue: Text;
    begin
        Rec.CalcFields(Rec."FileContentBlob");
        Rec."FileContentBlob".CreateInStream(InStream, TextEncoding::UTF8);
        InStream.Read(TextValue);

        exit(TextValue);
    end;

    procedure SaveFileContent(FileContent: Text)
    var
        OutStream: OutStream;
    begin
        Rec."FileContentBlob".CreateOutStream(OutStream, TextEncoding::UTF8);
        OutStream.WriteText(FileContent);
        Rec.Modify(false);
    end;


    procedure GetLastEntryNo(): Integer
    var
        FindRecordManagement: Codeunit "Find Record Management";
    begin
        exit(FindRecordManagement.GetLastEntryIntFieldValue(Rec, FieldNo("transferID")));
    end;


    procedure LogActivitySucceded(ActivityDescription: Text; ActivityMessage: Text)
    var
        ActivityLog: Record "Activity Log";
        Description: Text;
    begin
        Description := StrSubstNo('%1 - %2', this.GetTableName(Rec.RecordId()), Rec.transferID);
        ActivityLog.LogActivity(Rec.RecordId(), ActivityLog.Status::Success, 'XML Fileimport', ActivityDescription, ActivityMessage)
    end;

    procedure LogActivityFailed(ActivityDescription: Text; ActivityErrorMessage: Text)
    var
        ActivityLog: Record "Activity Log";
        Description: Text;

    begin
        Description := StrSubstNo('%1 - %2', this.GetTableName(Rec.RecordId()), Rec.transferID);
        ActivityLog.LogActivity(Rec.RecordId(), ActivityLog.Status::Failed, 'XML Fileimport', CopyStr(ActivityDescription, 1, 250), CopyStr(ActivityErrorMessage, 1, 250));
    end;


    local procedure GetTableName(RelatedRecordID: RecordId): Text
    var
        AllObj: Record AllObj;
    begin
        if AllObj.Get(AllObj."Object Type"::Table, RelatedRecordID.TableNo()) then
            exit(AllObj."Object Name");
    end;
}