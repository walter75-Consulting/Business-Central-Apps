table 90706 "SEW Packing Station"
{
    Caption = 'Packing Station';
    DataClassification = CustomerContent;

    LookupPageId = "SEW Packing Station List";
    DrillDownPageId = "SEW Packing Station List";

    fields
    {
        field(1; stationID; Integer)
        {
            Caption = 'stationID';
            ToolTip = 'Specifies the unique identifier for the packing station.';
        }
        field(2; "Station Name"; Text[100])
        {
            Caption = 'Station Name';
            ToolTip = 'Specifies the name of the packing station.';
        }
        field(3; "Label PrinterID"; Integer)
        {
            Caption = 'Label PrinterID';
            ToolTip = 'Specifies the Printer ID for the label printer associated with this packing station.';
            TableRelation = "SEW PrintNode Printer"."Printer ID";
        }
        field(90710; "Last Shipment No."; Code[20])
        {
            Caption = 'Last Shipment No.';
            ToolTip = 'Specifies the last shipment number processed at this packing station.';
            AllowInCustomizations = Never;
            TableRelation = "Sales Shipment Header"."No.";
        }
        field(90711; "Last Invoice No."; Code[20])
        {
            Caption = 'Last Invoice No.';
            ToolTip = 'Specifies the last invoice number processed at this packing station.';
            AllowInCustomizations = Never;
            TableRelation = "Sales Invoice Header"."No.";
        }
        field(90712; "Packing is Active"; Boolean)
        {
            Caption = 'Packing is Active';
            ToolTip = 'Specifies whether packing is currently active at this station.';
            AllowInCustomizations = Never;
        }
        field(90713; "Cur. User ID"; Guid)
        {
            Caption = 'Current User ID';
            ToolTip = 'Specifies the ID of the user currently operating this packing station.';
            AllowInCustomizations = Never;
            TableRelation = User."User Security ID";
        }
        field(90717; "Full User Name"; Text[80])
        {
            Caption = 'Full User Name';
            ToolTip = 'Specifies the full name of the user currently operating this packing station.';
            AllowInCustomizations = Never;
            Editable = false;
            CalcFormula = lookup(User."Full Name" where("User Security ID" = field("Cur. User ID")));
            FieldClass = FlowField;
        }
        field(90714; "Cur. Warenhouse Activity Type"; Enum "Warehouse Activity Type")
        {
            Caption = 'Current Warehouse Activity Type';
            ToolTip = 'Specifies the type of the current warehouse activity at this packing station.';
            AllowInCustomizations = Never;
        }
        field(90715; "Cur. Warehouse Activity No."; Code[20])
        {
            Caption = 'Current Warehouse Activity';
            ToolTip = 'Specifies the current warehouse activity at this packing station.';
            AllowInCustomizations = Never;
        }
        field(90706; "Current Scan Action"; Enum "SEW Scan Action")
        {
            Caption = 'Scan Action';
            ToolTip = 'Specifies the scan action.';
            AllowInCustomizations = Never;
        }
        field(90707; "Text Last Scan"; Text[255])
        {
            Caption = 'Last Scan';
            ToolTip = 'Specifies the last scan input.';
            AllowInCustomizations = Never;
        }
        field(90708; "Text Display"; Text[255])
        {
            Caption = 'Display Text';
            ToolTip = 'Specifies the display text for the user.';
            AllowInCustomizations = Never;
        }
        field(90709; "Package Material Usage"; Boolean)
        {
            Caption = 'Package Material Usage';
            ToolTip = 'Specifies whether to track package material usage at this packing station.';
            AllowInCustomizations = Never;
        }
        field(90720; "use Scale"; Boolean)
        {
            Caption = 'Use Scale';
            ToolTip = 'Specifies whether to use a scale at this packing station.';
            AllowInCustomizations = Never;
        }
        field(90721; "Scale ID"; Integer)
        {
            Caption = 'Scale ID';
            ToolTip = 'Specifies the PrintNode scale ID associated with this packing station.';
            TableRelation = "SEW PrintNode Scale"."Scale ID";
            AllowInCustomizations = Never;
        }
        field(90722; "Delivery Note per Parcel"; Boolean)
        {
            Caption = 'Delivery Note per Parcel';
            ToolTip = 'Specifies whether to print a delivery note for each parcel at this packing station.';
            AllowInCustomizations = Never;

        }
    }
    keys
    {
        key(PK; stationID)
        {
            Clustered = true;
        }
    }


    fieldgroups
    {
        fieldgroup(DropDown; stationID, "Station Name") { }
        fieldgroup(Brick; stationID, "Station Name") { }
    }

    trigger OnInsert()
    begin
        Rec.stationID := GetLastEntryNo() + 1;
    end;

    procedure GetLastEntryNo(): Integer
    var
        FindRecordManagement: Codeunit "Find Record Management";
    begin
        exit(FindRecordManagement.GetLastEntryIntFieldValue(Rec, FieldNo("stationID")));
    end;
}
