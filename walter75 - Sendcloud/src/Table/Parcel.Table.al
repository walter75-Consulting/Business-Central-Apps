table 95711 "SEW Parcel"
{
    Caption = 'Parcel Create';
    DataClassification = CustomerContent;
    DrillDownPageId = "SEW Parcel Card";
    LookupPageId = "SEW Parcel List";
    Extensible = false;

    Permissions = tabledata "SEW SendCloud Setup" = r,
                    tabledata "SEW Parcel Tracking" = rd,
                    tabledata "SEW Parcel Status" = r,
                    tabledata "Shipping Agent Services" = r,
                    tabledata "SEW Parcel" = rmid;

    fields
    {
        field(1; "Parcel No."; Code[20])
        {
            Caption = 'Parcel No.';
            ToolTip = 'Specifies the Parcel No.';
            NotBlank = true;

            trigger OnValidate()
            begin
                InitRecord();
            end;
        }
        field(2; "Source Type"; Enum "SEW Shipment Source Type")
        {
            Caption = 'Source Type';
            ToolTip = 'Specifies the Source Type.';
        }
        field(3; "Source Type Sub"; Enum "SEW Shipment Source Type Sub")
        {
            Caption = 'Source Type Sub';
            ToolTip = 'Specifies the Source Type Sub.';
            trigger OnValidate()
            var
                ErrMsgLbl: Label 'Invalid Source Type Sub for Source Type %1.', Comment = '%1 = Source Type';
            begin
                Validate("Parcel No."); // to ensure Parcel No. is filled

                case "Source Type" of

                    "Source Type"::Contact:
                        if not ("Source Type Sub" in ["Source Type Sub"::Contact,
                                                        "Source Type Sub"::"Contact Alt. Address"]) then
                            Error(ErrMsgLbl, "Source Type"::Contact);

                    "Source Type"::Customer:
                        if not ("Source Type Sub" in ["Source Type Sub"::Customer,
                                                        "Source Type Sub"::"Customer Ship-to",
                                                        "Source Type Sub"::"Sales Order",
                                                        "Source Type Sub"::"Sales Shipment",
                                                        "Source Type Sub"::"Sales Invoice",
                                                        "Source Type Sub"::"Sales Order Archive",
                                                        "Source Type Sub"::"Sales Return Order",
                                                        "Source Type Sub"::"Sales Return Shipment",
                                                        "Source Type Sub"::"Sales Credit Memo",
                                                        "Source Type Sub"::"Sales Blanket Order",
                                                        "Source Type Sub"::"Sales Quote",
                                                        "Source Type Sub"::"Subscription Contract Customer",
                                                        "Source Type Sub"::"Project",
                                                        "Source Type Sub"::"Project Archive",
                                                        "Source Type Sub"::"Service Order",
                                                        "Source Type Sub"::"Service Shipment",
                                                        "Source Type Sub"::"Service Invoice",
                                                        "Source Type Sub"::"Service Order Archive",
                                                        "Source Type Sub"::"Service Credit Memo",
                                                        "Source Type Sub"::"Service Quote"]) then
                            Error(ErrMsgLbl, "Source Type"::Customer);

                    "Source Type"::Vendor:
                        if not ("Source Type Sub" in ["Source Type Sub"::Vendor,
                                                        "Source Type Sub"::"Vendor Order Address",
                                                        "Source Type Sub"::"Vendor Remit Address",
                                                        "Source Type Sub"::"Purchase Order",
                                                        "Source Type Sub"::"Purchase Receipt",
                                                        "Source Type Sub"::"Purchase Invoice",
                                                        "Source Type Sub"::"Purchase Order Archive",
                                                        "Source Type Sub"::"Purchase Return Order",
                                                        "Source Type Sub"::"Purchase Return Shipment",
                                                        "Source Type Sub"::"Purchase Credit Memo",
                                                        "Source Type Sub"::"Purchase Blanket Order",
                                                        "Source Type Sub"::"Purchase Quote",
                                                        "Source Type Sub"::"Subscription Contract Vendor"]) then
                            Error(ErrMsgLbl, "Source Type"::Vendor);

                    "Source Type"::"Warehouse":
                        if not ("Source Type Sub" in ["Source Type Sub"::"Location",
                                                        "Source Type Sub"::"Warehouse Transfer",
                                                        "Source Type Sub"::"Warehouse Transfer Shipment",
                                                        "Source Type Sub"::"Warehouse Transfer Receipt",
                                                        "Source Type Sub"::"Warehouse Direct Transfer",
                                                        "Source Type Sub"::"Warehouse Shipment",
                                                        "Source Type Sub"::"Warehouse Receipt",
                                                        "Source Type Sub"::"Warehouse Pick",
                                                        "Source Type Sub"::"Warehouse Pick Posted"]) then
                            Error(ErrMsgLbl, "Source Type"::"Warehouse");

                    "Source Type"::"other":
                        if not ("Source Type Sub" in ["Source Type Sub"::"Ressource",
                                                        "Source Type Sub"::"Employee",
                                                        "Source Type Sub"::"Recipient Address"]) then
                            Error(ErrMsgLbl, "Source Type"::"other");
                end;
            end;
        }
        field(4; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            ToolTip = 'Specifies the Source No.';
            TableRelation =
            if ("Source Type" = const(Contact), "Source Type Sub" = filter('')) "Contact"
            else if ("Source Type" = const(Contact), "Source Type Sub" = const("Contact Alt. Address")) "Contact" // "Contact Alt. Address" // needs Sub No.

            else if ("Source Type" = const(Customer), "Source Type Sub" = filter('')) "Customer"
            else if ("Source Type" = const(Customer), "Source Type Sub" = const("Customer Ship-to")) Customer //"Ship-to Address" // needs Sub No.
            else if ("Source Type" = const(Customer), "Source Type Sub" = const("Sales Order")) "Sales Header"."No." where("Document Type" = const("Sales Document Type"::"Order"))
            else if ("Source Type" = const(Customer), "Source Type Sub" = const("Sales Shipment")) "Sales Shipment Header"."No."
            else if ("Source Type" = const(Customer), "Source Type Sub" = const("Sales Invoice")) "Sales Invoice Header"."No."
            else if ("Source Type" = const(Customer), "Source Type Sub" = const("Sales Order Archive")) "Sales Header Archive"."No."
            else if ("Source Type" = const(Customer), "Source Type Sub" = const("Sales Return Order")) "Sales Header" where("Document Type" = const("Sales Document Type"::"Return Order"))
            else if ("Source Type" = const(Customer), "Source Type Sub" = const("Sales Return Shipment")) "Return Shipment Header"
            else if ("Source Type" = const(Customer), "Source Type Sub" = const("Sales Credit Memo")) "Sales Cr.Memo Header"
            else if ("Source Type" = const(Customer), "Source Type Sub" = const("Sales Blanket Order")) "Sales Header" where("Document Type" = const("Sales Document Type"::"Blanket Order"))
            else if ("Source Type" = const(Customer), "Source Type Sub" = const("Sales Quote")) "Sales Header" where("Document Type" = const("Sales Document Type"::Quote))
            //else if ("Source Type" = const(Customer), "Source Type Sub" = const("Subscription Customer")) "Subscription Header"
            //else if ("Source Type" = const(Customer), "Source Type Sub" = const("Subscription Contract Customer")) "Customer Subscription Contract"
            else if ("Source Type" = const(Customer), "Source Type Sub" = const("Project")) Job
            else if ("Source Type" = const(Customer), "Source Type Sub" = const("Project Archive")) "Job Archive"
            else if ("Source Type" = const(Customer), "Source Type Sub" = const("Service Order")) "Service Header" where("Document Type" = const("Service Document Type"::Order))
            else if ("Source Type" = const(Customer), "Source Type Sub" = const("Service Shipment")) "Service Shipment Header"
            else if ("Source Type" = const(Customer), "Source Type Sub" = const("Service Invoice")) "Service Invoice Header"
            else if ("Source Type" = const(Customer), "Source Type Sub" = const("Service Order Archive")) "Service Header Archive"
            else if ("Source Type" = const(Customer), "Source Type Sub" = const("Service Credit Memo")) "Service Cr.Memo Header"
            else if ("Source Type" = const(Customer), "Source Type Sub" = const("Service Quote")) "Service Header" where("Document Type" = const("Service Document Type"::Quote))
            else if ("Source Type" = const(Customer), "Source Type Sub" = const("Service Contract Customer")) "Service Contract Header" where("Contract Type" = const("Service Contract Type"::Contract))
            //else if ("Source Type" = const(Customer), "Source Type Sub" = const("Subscription Contract Vendor")) "Subscription Contract"

            else if ("Source Type" = const(Vendor), "Source Type Sub" = filter('')) Vendor
            else if ("Source Type" = const(Vendor), "Source Type Sub" = const("Vendor Order Address")) Vendor //"Order Address" // needs Sub No.
            else if ("Source Type" = const(Vendor), "Source Type Sub" = const("Vendor Remit Address")) Vendor //"Remit Address" // needs Sub No.
            else if ("Source Type" = const(Vendor), "Source Type Sub" = const("Purchase Order")) "Purchase Header" where("Document Type" = const("Purchase Document Type"::Order))
            else if ("Source Type" = const(Vendor), "Source Type Sub" = const("Purchase Receipt")) "Purch. Rcpt. Header"
            else if ("Source Type" = const(Vendor), "Source Type Sub" = const("Purchase Invoice")) "Purch. Inv. Header"
            else if ("Source Type" = const(Vendor), "Source Type Sub" = const("Purchase Order Archive")) "Purchase Header Archive"
            else if ("Source Type" = const(Vendor), "Source Type Sub" = const("Purchase Return Order")) "Purchase Header" where("Document Type" = const("Purchase Document Type"::"Return Order"))
            else if ("Source Type" = const(Vendor), "Source Type Sub" = const("Purchase Return Shipment")) "Return Receipt Header"
            else if ("Source Type" = const(Vendor), "Source Type Sub" = const("Purchase Credit Memo")) "Purch. Cr. Memo Hdr."
            else if ("Source Type" = const(Vendor), "Source Type Sub" = const("Purchase Blanket Order")) "Purchase Header" where("Document Type" = const("Purchase Document Type"::"Blanket Order"))
            else if ("Source Type" = const(Vendor), "Source Type Sub" = const("Purchase Quote")) "Purchase Header" where("Document Type" = const("Purchase Document Type"::"Quote"))

            else if ("Source Type" = const("Warehouse"), "Source Type Sub" = const("Location")) Location
            else if ("Source Type" = const("Warehouse"), "Source Type Sub" = const("Warehouse Transfer")) "Transfer Header"
            else if ("Source Type" = const("Warehouse"), "Source Type Sub" = const("Warehouse Transfer Shipment")) "Transfer Shipment Header"
            else if ("Source Type" = const("Warehouse"), "Source Type Sub" = const("Warehouse Transfer Receipt")) "Transfer Receipt Header"
            else if ("Source Type" = const("Warehouse"), "Source Type Sub" = const("Warehouse Direct Transfer")) "Direct Trans. Header"

            else if ("Source Type" = const("Warehouse"), "Source Type Sub" = const("Warehouse Pick")) "Warehouse Activity Header"."No." where("Type" = const("Warehouse Activity Type"::"Invt. Pick"))
            else if ("Source Type" = const("Warehouse"), "Source Type Sub" = const("Warehouse Pick Posted")) "Posted Invt. Pick Header"."Invt Pick No."

            else if ("Source Type" = const("Warehouse"), "Source Type Sub" = const("Warehouse Receipt")) "Warehouse Receipt Header"
            else if ("Source Type" = const("Warehouse"), "Source Type Sub" = const("Warehouse Shipment")) "Warehouse Shipment Header"

            else if ("Source Type" = const("Other"), "Source Type Sub" = const("Ressource")) Resource
            else if ("Source Type" = const("Other"), "Source Type Sub" = const("Employee")) Employee
            else if ("Source Type" = const("Other"), "Source Type Sub" = const("Recipient Address")) "SEW Recipient Address";


            trigger OnValidate()
            var
                SEWAddressMgmt: Codeunit "SEW SC Address Mgmt";
            begin
                case "Source Type Sub" of
                    "SEW Shipment Source Type Sub"::"Contact Alt. Address", "SEW Shipment Source Type Sub"::"Customer Ship-to",
                    "SEW Shipment Source Type Sub"::"Vendor Order Address", "SEW Shipment Source Type Sub"::"Vendor Remit Address":
                        if "Source No. Sub" = '' then
                            ; // Do nothing, wait for Sub No.
                    else
                        SEWAddressMgmt.getAdressData(Rec, Rec."Source No.", Rec."Source No. Sub");
                end;
            end;

        }
        field(5; "Source No. Sub"; Code[10])
        {
            Caption = 'Source Sub No.';
            ToolTip = 'Specifies the Source Sub No.';
            TableRelation =
            if ("Source Type" = const(Contact), "Source Type Sub" = const("Contact Alt. Address")) "Contact Alt. Address".Code where("Contact No." = field("Source No."))
            else if ("Source Type" = const(Customer), "Source Type Sub" = const("Customer Ship-to")) "Ship-to Address".Code where("Customer No." = field("Source No."))
            else if ("Source Type" = const(Vendor), "Source Type Sub" = const("Vendor Order Address")) "Order Address".Code where("Vendor No." = field("Source No."))
            else if ("Source Type" = const(Vendor), "Source Type Sub" = const("Vendor Remit Address")) "Remit Address".Code where("Vendor No." = field("Source No."));

            trigger OnValidate()
            var
                SEWAddressMgmt: Codeunit "SEW SC Address Mgmt";
                ErrMsgLbl: Label 'Source Sub No. must be filled for the selected Source Type Sub.';
            begin
                case "Source Type Sub" of
                    "SEW Shipment Source Type Sub"::"Contact Alt. Address", "SEW Shipment Source Type Sub"::"Customer Ship-to",
                "SEW Shipment Source Type Sub"::"Vendor Order Address", "SEW Shipment Source Type Sub"::"Vendor Remit Address":
                        if "Source No. Sub" = '' then
                            Error(ErrMsgLbl);
                    else
                        SEWAddressMgmt.getAdressData(Rec, Rec."Source No.", Rec."Source No. Sub");
                end;
            end;

        }

        // Receiver Information
        field(10; "Ship-to Name 1"; Text[100])
        {
            Caption = 'Name 1';
            ToolTip = 'Specifies Recipent Name 1 information.';
            AllowInCustomizations = Never;
        }
        field(11; "Ship-to Name 2"; Text[50])
        {
            Caption = 'Name 2';
            ToolTip = 'Specifies Recipent Name 2 information.';
            AllowInCustomizations = Never;
        }
        field(12; "Ship-to Address 1"; Text[100])
        {
            Caption = 'Address 1';
            ToolTip = 'Specifies Recipent Address 1 information.';
            AllowInCustomizations = Never;
        }
        field(13; "Ship-to Address 2"; Text[50])
        {
            Caption = 'Address 2';
            ToolTip = 'Specifies Recipent Address 2 information.';
            AllowInCustomizations = Never;
        }
        field(14; "Ship-to Street"; Text[100])
        {
            Caption = 'Street';
            ToolTip = 'Specifies Recipent Street information.';
            AllowInCustomizations = Never;
        }
        field(15; "Ship-to House Nbr."; Text[250])
        {
            Caption = 'House Nbr.';
            ToolTip = 'Specifies Recipent House Nbr. information.';
            AllowInCustomizations = Never;
        }
        field(16; "Ship-to Country Code"; Code[10])
        {
            Caption = 'Country';
            ToolTip = 'Specifies the Country code for the shipment.';
            TableRelation = "Country/Region".Code;
            AllowInCustomizations = Never;
        }
        field(17; "Ship-to Post Code"; Text[20])
        {
            Caption = 'Post Code';
            ToolTip = 'Specifies the Postal code for the shipment.';
            TableRelation = "Post Code".Code where("Country/Region Code" = field("Ship-to Country Code"));
            AllowInCustomizations = Never;
        }
        field(18; "Ship-to City"; Text[30])
        {
            Caption = 'City';
            ToolTip = 'Specifies the City for the shipment.';
            AllowInCustomizations = Never;
        }
        field(19; "Ship-to County"; Text[30])
        {
            Caption = 'County';
            ToolTip = 'Specifies the County for the shipment.';
            AllowInCustomizations = Never;
        }
        field(20; "Ship-to Contact Name"; Text[100])
        {
            Caption = 'Contact Name';
            ToolTip = 'Specifies the Contact name for the shipment.';
            AllowInCustomizations = Never;
        }
        field(21; "Ship-to Phone"; Text[30])
        {
            Caption = 'Phone';
            ToolTip = 'Specifies the Phone number for the shipment.';
            AllowInCustomizations = Never;
        }
        field(22; "Ship-to Email"; Text[80])
        {
            Caption = 'Email';
            ToolTip = 'Specifies the Email address for the shipment.';
            ExtendedDatatype = EMail;
            AllowInCustomizations = Never;
        }
        field(23; "Your Reference"; Text[50])
        {
            Caption = 'Your Reference';
            ToolTip = 'Specifies Your Reference.';
        }

        // Sender Information

        field(30; "Sender Name 1"; Text[100])
        {
            Caption = 'Name 1';
            ToolTip = 'Specifies the Name 1 field for the sender information.';
        }
        field(31; "Sender Name 2"; Text[50])
        {
            Caption = 'Name 2';
            ToolTip = 'Specifies the Name 2 field for the sender information.';
        }
        field(32; "Sender Address 1"; Text[100])
        {
            Caption = 'Address 1';
            ToolTip = 'Specifies the Address1 field for the sender information.';
        }
        field(33; "Sender Address 2"; Text[50])
        {
            Caption = 'Address 2';
            ToolTip = 'Specifies the Address2 field for the sender information.';
        }
        field(34; "Sender Street"; Text[100])
        {
            Caption = 'Street';
            ToolTip = 'Specifies the Street field for the sender information.';
            AllowInCustomizations = Never;
        }
        field(35; "Sender House Nbr."; Text[250])
        {
            Caption = 'House Nbr.';
            ToolTip = 'Specifies the House Nbr. field for the sender information.';
            AllowInCustomizations = Never;
        }
        field(36; "Sender Country Code"; Code[10])
        {
            Caption = 'Country';
            ToolTip = 'Specifies the Country code for the sender information.';
            TableRelation = "Country/Region".Code;
            AllowInCustomizations = Never;
        }
        field(37; "Sender Post Code"; Text[20])
        {
            Caption = 'Post Code';
            ToolTip = 'Specifies the Postal code for the sender information.';
            TableRelation = "Post Code".Code where("Country/Region Code" = field("Sender Country Code"));
            AllowInCustomizations = Never;
        }
        field(38; "Sender City"; Text[30])
        {
            Caption = 'City';
            ToolTip = 'Specifies the City for the sender information.';
            AllowInCustomizations = Never;
        }
        field(39; "Sender County"; Text[30])
        {
            Caption = 'County';
            ToolTip = 'Specifies the County for the sender information.';
            AllowInCustomizations = Never;
        }
        field(40; "Sender Contact Name"; Text[100])
        {
            Caption = 'Contact Name';
            ToolTip = 'Specifies the Contact name for the sender information.';
            AllowInCustomizations = Never;
        }
        field(41; "Sender Phone"; Text[30])
        {
            Caption = 'Phone';
            ToolTip = 'Specifies the Phone number for the sender information.';
            AllowInCustomizations = Never;
        }
        field(42; "Sender Email"; Text[80])
        {
            Caption = 'Email';
            ToolTip = 'Specifies the Email address for the sender information.';
            ExtendedDatatype = EMail;
            AllowInCustomizations = Never;
        }
        field(43; "SC Sender ID"; Integer)
        {
            Caption = 'Sender ID';
            ToolTip = 'Specifies the SendCloud Sender ID.';
            TableRelation = "SEW Sender Address".ID;
            AllowInCustomizations = Never;

        }

        //Transport Information
        field(50; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            ToolTip = 'Specifies the Shipping Agent Code.';
            TableRelation = "Shipping Agent".Code;
            AllowInCustomizations = Never;
        }
        field(51; "SC Carrier Code"; Code[50])
        {
            Caption = 'Carrier Code';
            ToolTip = 'Specifies the SendCloud Carrier Code.';
            TableRelation = "SEW Carrier".Code;
            AllowInCustomizations = Never;
        }
        field(52; "Shipping Agent Service Code"; Code[10])
        {
            Caption = 'Shipping Agent Service Code';
            ToolTip = 'Specifies the Shipping Agent Service Code.';
            TableRelation = "Shipping Agent Services".Code where("Shipping Agent Code" = field("Shipping Agent Code"));
            AllowInCustomizations = Never;
            trigger OnValidate()
            var
                ShippingAgentServices: Record "Shipping Agent Services";
            begin
                if "SC Carrier Ship Meth ID" = 0 then
                    if ShippingAgentServices.Get("Shipping Agent Code", "Shipping Agent Service Code") then
                        Rec."SC Carrier Ship Meth ID" := ShippingAgentServices."SEW sendCloudID";
            end;
        }
        field(53; "SC Carrier Ship Meth ID"; Integer)
        {
            Caption = 'Carrier Shipment Method ID';
            ToolTip = 'Specifies the SendCloud Carrier Service Code.';
            TableRelation = "SEW Carrier Ship Met".ID where("Carrier Code" = field("SC Carrier Code"));
            AllowInCustomizations = Never;
        }


        //Parcel Information
        field(60; "Parcel Weight"; Decimal)
        {
            Caption = 'Parcel Weight';
            ToolTip = 'Weight of the parcel in KG.';
            DecimalPlaces = 3 : 3;
            AllowInCustomizations = Never;
        }
        field(61; "Parcel Length"; Decimal)
        {
            Caption = 'Parcel Length';
            ToolTip = 'Length of the parcel in CM.';
            DecimalPlaces = 0 : 0;
            AllowInCustomizations = Never;
        }
        field(62; "Parcel Width"; Decimal)
        {
            Caption = 'Parcel Width';
            ToolTip = 'Width of the parcel in CM.';
            DecimalPlaces = 0 : 0;
            AllowInCustomizations = Never;
        }
        field(63; "Parcel Height"; Decimal)
        {
            Caption = 'Parcel Height';
            ToolTip = 'Height of the parcel in CM.';
            DecimalPlaces = 0 : 0;
            AllowInCustomizations = Never;
        }


        // SendCloud Response Information
        field(800; "SC ID"; Integer)
        {
            Caption = 'SendCloud ID';
            ToolTip = 'Specifies the SendCloud ID.';
            Editable = false;
            AllowInCustomizations = Never;
        }
        field(801; "SC Status ID"; Integer)
        {
            Caption = 'Status ID';
            ToolTip = 'Specifies the Status ID.';
            Editable = false;
            AllowInCustomizations = Never;
            TableRelation = "SEW Parcel Status"."SC Status ID";
            trigger OnValidate()
            var
                SEWParcelStatus: Record "SEW Parcel Status";
            begin
                if SEWParcelStatus.Get(Rec."SC Status ID") then
                    Rec."SC Parcel Status" := SEWParcelStatus.Message
                else
                    Rec."SC Parcel Status" := '';
            end;
        }
        field(802; "SC Tracking Number"; Text[50])
        {
            Caption = 'Tracking Nbr.';
            ToolTip = 'Specifies the Tracking Nbr.';
            Editable = false;
            AllowInCustomizations = Never;
        }
        field(803; "SC Note"; Text[250])
        {
            Caption = 'Note';
            ToolTip = 'Specifies the SendCloud Note.';
            Editable = false;
            AllowInCustomizations = Never;
        }
        field(804; "SC Shipment uuid"; Text[50])
        {
            Caption = 'Shipment uuid';
            ToolTip = 'Specifies the SendCloud Shipment uuid.';
            Editable = false;
            AllowInCustomizations = Never;
        }
        field(805; "SC External Order Id"; Text[50])
        {
            Caption = 'External Order ID';
            ToolTip = 'Specifies the SendCloud External Order ID.';
            Editable = false;
            AllowInCustomizations = Never;
        }
        field(806; "SC External Shipment Id"; Text[50])
        {
            Caption = 'External Shipment ID';
            ToolTip = 'Specifies the SendCloud External Shipment ID.';
            Editable = false;
            AllowInCustomizations = Never;
        }
        field(807; "SC Colli uuid"; Text[50])
        {
            Caption = 'Colli uuid';
            ToolTip = 'Specifies the SendCloud Colli uuid.';
            Editable = false;
            AllowInCustomizations = Never;
        }
        field(808; "SC Date created"; DateTime)
        {
            Caption = 'Date created';
            ToolTip = 'Specifies the SendCloud Date created.';
            Editable = false;
            AllowInCustomizations = Never;
        }
        field(809; "SC Date announced"; DateTime)
        {
            Caption = 'Date Announced';
            ToolTip = 'Specifies the SendCloud Date Announced.';
            Editable = false;
            AllowInCustomizations = Never;
        }
        field(810; "SC Date Updated"; DateTime)
        {
            Caption = 'Date updated';
            ToolTip = 'Specifies the SendCloud Date updated.';
            Editable = false;
            AllowInCustomizations = Never;
        }
        field(811; "SC Order Nbr."; Text[50])
        {
            Caption = 'Order Number';
            ToolTip = 'Specifies the SendCloud Order Number.';
            Editable = false;
            AllowInCustomizations = Never;
        }
        field(812; "SC Label URL"; Text[250])
        {
            Caption = 'Label URL';
            ToolTip = 'Specifies the SendCloud Label URL.';
            Editable = false;
            ExtendedDatatype = URL;
            AllowInCustomizations = Never;
        }
        field(813; "SC Parcel Status"; Text[250])
        {
            Caption = 'Parcel Status';
            ToolTip = 'Specifies the SendCloud Parcel Status.';
            Editable = false;
            AllowInCustomizations = Never;
        }
        field(814; "SC Tracking URL"; Text[250])
        {
            Caption = 'Tracking URL';
            ToolTip = 'Specifies the SendCloud Tracking URL.';
            Editable = false;
            ExtendedDatatype = URL;
            AllowInCustomizations = Never;
        }
        field(815; "SC Parcel Tracking Activities"; Integer)
        {
            Caption = 'Tracking Activities';
            ToolTip = 'Specifies the Number obf Tracking Activities.';
            FieldClass = FlowField;
            CalcFormula = count("SEW Parcel Tracking" where("SC Parcel ID" = field("SC ID")));
            Editable = false;
            AllowInCustomizations = Never;
        }
        field(900; "Label PDF"; Blob)
        {
            Caption = 'Label PDF';
            ToolTip = 'Specifies the Label PDF.';
        }
    }

    keys
    {
        key(PK; "Parcel No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Parcel No.", "Source Type", "Source No.", "Source No. Sub", "Ship-to Name 1")
        {
        }
        fieldgroup(Brick; "Parcel No.", "Source Type", "Source No.", "Source No. Sub", "Ship-to Name 1")
        {
        }
    }


    trigger OnInsert()
    begin
        InitRecord();
    end;

    trigger OnDelete()
    var
        SEWParcelTracking: Record "SEW Parcel Tracking";
    begin
        // Delete related tracking entries
        SEWParcelTracking.SetRange("SC Parcel ID", Rec."SC ID");

        if SEWParcelTracking.FindSet() then
            SEWParcelTracking.DeleteAll(false);
    end;

    procedure GetFileContent(): Text
    var
        InStream: InStream;
        TextValue: Text;
    begin
        Rec.CalcFields(Rec."Label PDF");
        Rec."Label PDF".CreateInStream(InStream, TextEncoding::UTF8);
        InStream.Read(TextValue);

        exit(TextValue);
    end;

    procedure SaveFileContent(FileContent: Text)
    var
        OutStream: OutStream;
    begin
        Rec."Label PDF".CreateOutStream(OutStream, TextEncoding::UTF8);
        OutStream.WriteText(FileContent);
        Rec.Modify(false);
    end;


    procedure InitRecord()
    var
        SEWSendCloudSetup: Record "SEW SendCloud Setup";
        SEWNoSeriesCU: Codeunit "No. Series";
        ErrMsgSetupLbl: Label 'No SendCloud Setup found. Please set up SendCloud Setup first.';
    begin
        if not SEWSendCloudSetup.Get() then
            Error(ErrMsgSetupLbl);

        if Rec."Parcel No." = '' then
            Rec."Parcel No." := SEWNoSeriesCU.GetNextNo(SEWSendCloudSetup."Parcel No. Series");

        if Rec."SC Sender ID" = 0 then
            Rec."SC Sender ID" := SEWSendCloudSetup."Default SenderID";
    end;

    procedure PostParcelToSendCloud(): Boolean
    var
        SEWSCRestRequests: Codeunit "SEW SC Rest Requests";
        Success: Boolean;
    begin
        Success := SEWSCRestRequests.RequestParcelPost(Rec, true);
        if Success then
            Rec.Modify(false);

        if Success then
            Success := SEWSCRestRequests.GetParcelLabel(Rec);
        if Success then
            Rec.Modify(false);

        exit(Success);
    end;

    procedure TryParcelDelete(): Boolean
    begin
        if Rec."SC ID" = 0 then
            exit(Rec.Delete(true));

        exit(false);
    end;

    procedure TryParcelCancel(): Boolean
    var
        SEWSCRestRequests: Codeunit "SEW SC Rest Requests";
    begin
        if Rec."SC ID" = 0 then
            exit(Rec.Delete(true));

        exit(SEWSCRestRequests.RequestParcelCancel(Rec."SC ID"));
    end;




}