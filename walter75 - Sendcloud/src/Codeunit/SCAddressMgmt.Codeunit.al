codeunit 95702 "SEW SC Address Mgmt"
{

    Permissions = tabledata "Contact" = r,
                    tabledata "Contact Alt. Address" = r,
                    tabledata "Customer" = r,
                    tabledata "Ship-to Address" = r,
                    tabledata "Sales Header" = r,
                    tabledata "Sales Header Archive" = r,
                    tabledata "Sales Shipment Header" = r,
                    tabledata "Sales Invoice Header" = r,
                    tabledata "Return Shipment Header" = r,
                    tabledata "Job" = r,
                    tabledata "Service Header" = r,
                    tabledata "Service Shipment Header" = r,
                    tabledata "Service Invoice Header" = r,
                    tabledata "Service Cr.Memo Header" = r,
                    tabledata "Vendor" = r,
                    tabledata "Purchase Header" = r,
                    tabledata "Purch. Inv. Header" = r,
                    tabledata "Return Receipt Header" = r,
                    tabledata "Purch. Cr. Memo Hdr." = r,
                    tabledata "Purch. Rcpt. Header" = r,
                    tabledata "Remit Address" = r,
                    tabledata "Order Address" = r,
                    tabledata "Location" = r,
                    tabledata "Transfer Header" = r,
                    tabledata "Transfer Shipment Header" = r,
                    tabledata "Transfer Receipt Header" = r,
                    tabledata "Direct Trans. Header" = r,
                    tabledata "Warehouse Activity Header" = r,
                    tabledata "Resource" = r,
                    tabledata "Employee" = r,
                    tabledata "SEW Recipient Address" = r;


    procedure getAdressData(var SEWParcelCreate: Record "SEW Parcel"; xSourceNo: Code[20]; xSourceSubNo: Code[10])
    begin
        if SEWParcelCreate."Source Type Sub" = "SEW Shipment Source Type Sub".FromInteger(0) then begin
            case SEWParcelCreate."Source Type" of
                SEWParcelCreate."Source Type"::Contact:
                    GetFromContact(SEWParcelCreate, xSourceNo);

                SEWParcelCreate."Source Type"::Customer:
                    GetFromCustomer(SEWParcelCreate, xSourceNo);

                SEWParcelCreate."Source Type"::Vendor:
                    GetFromVendor(SEWParcelCreate, xSourceNo);
            end;
            exit;
        end;



        case SEWParcelCreate."Source Type Sub" of
            SEWParcelCreate."Source Type Sub"::"Contact Alt. Address":
                GetFromContactAltAddress(SEWParcelCreate, xSourceNo, xSourceSubNo);

            SEWParcelCreate."Source Type Sub"::"Customer Ship-to":
                GetFromCustomerShipTo(SEWParcelCreate, xSourceNo, xSourceSubNo);
            SEWParcelCreate."Source Type Sub"::"Sales Order":
                GetFromSalesHeader(SEWParcelCreate, xSourceNo, "Sales Document Type"::Order);
            SEWParcelCreate."Source Type Sub"::"Sales Shipment":
                GetFromSalesShipment(SEWParcelCreate, xSourceNo);
            SEWParcelCreate."Source Type Sub"::"Sales Invoice":
                GetFromSalesInvoice(SEWParcelCreate, xSourceNo);
            SEWParcelCreate."Source Type Sub"::"Sales Order Archive":
                GetFromSalesHeaderArchive(SEWParcelCreate, xSourceNo, "Sales Document Type"::Order);
            SEWParcelCreate."Source Type Sub"::"Sales Return Order":
                GetFromSalesHeader(SEWParcelCreate, xSourceNo, "Sales Document Type"::"Return Order");
            SEWParcelCreate."Source Type Sub"::"Sales Return Shipment":
                GetFromSalesReturnShipment(SEWParcelCreate, xSourceNo);
            SEWParcelCreate."Source Type Sub"::"Sales Credit Memo":
                GetFromSalesHeader(SEWParcelCreate, xSourceNo, "Sales Document Type"::"Credit Memo");
            SEWParcelCreate."Source Type Sub"::"Sales Blanket Order":
                GetFromSalesHeader(SEWParcelCreate, xSourceNo, "Sales Document Type"::"Blanket Order");
            SEWParcelCreate."Source Type Sub"::"Sales Quote":
                GetFromSalesHeader(SEWParcelCreate, xSourceNo, "Sales Document Type"::Quote);
            //"Source Type Sub"::"Subscription Customer":
            //    GetFromSubscriptionHeader("Source No.");  
            //"Source Type Sub"::"Subscription Contract Customer":
            //    GetFromCustomerSubscriptionContract("Source No.");
            SEWParcelCreate."Source Type Sub"::"Project":
                GetFromJob(SEWParcelCreate, xSourceNo);
            //"Source Type Sub"::"Project Archive":
            //    GetFromJobArchive("Source No.");
            SEWParcelCreate."Source Type Sub"::"Service Order":
                GetFromServiceHeader(SEWParcelCreate, xSourceNo, "Service Document Type"::Order);
            SEWParcelCreate."Source Type Sub"::"Service Shipment":
                GetFromServiceShipment(SEWParcelCreate, xSourceNo);
            SEWParcelCreate."Source Type Sub"::"Service Invoice":
                GetFromServiceInvoice(SEWParcelCreate, xSourceNo);
            //"Source Type Sub"::"Service Order Archive":
            //    GetFromServiceHeaderArchive("Source No.");
            SEWParcelCreate."Source Type Sub"::"Service Credit Memo":
                GetFromServiceCreditMemoHeader(SEWParcelCreate, xSourceNo);
            SEWParcelCreate."Source Type Sub"::"Service Quote":
                GetFromServiceHeader(SEWParcelCreate, xSourceNo, "Service Document Type"::Quote);
            //"Source Type Sub"::"Service Contract Customer":
            //    GetFromServiceContractHeader("Source No.");
            SEWParcelCreate."Source Type Sub"::Vendor:
                GetFromVendor(SEWParcelCreate, xSourceNo);
            SEWParcelCreate."Source Type Sub"::"Vendor Order Address":
                GetFromVendorOrderAddress(SEWParcelCreate, xSourceNo, xSourceSubNo);
            SEWParcelCreate."Source Type Sub"::"Vendor Remit Address":
                GetFromVendorRemitAddress(SEWParcelCreate, xSourceNo, xSourceSubNo);
            SEWParcelCreate."Source Type Sub"::"Purchase Order":
                GetFromPurchaseHeader(SEWParcelCreate, xSourceNo, "Purchase Document Type"::Order);
            SEWParcelCreate."Source Type Sub"::"Purchase Receipt":
                GetFromPurchaseReceiptHeader(SEWParcelCreate, xSourceNo);
            SEWParcelCreate."Source Type Sub"::"Purchase Invoice":
                GetFromPurchaseInvoiceHeader(SEWParcelCreate, xSourceNo);
            //"Source Type Sub"::"Purchase Order Archive":
            //    GetFromPurchaseHeaderArchive("Purchase Document Type"::Order, "Source No.");
            SEWParcelCreate."Source Type Sub"::"Purchase Return Order":
                GetFromPurchaseHeader(SEWParcelCreate, xSourceNo, "Purchase Document Type"::"Return Order");
            SEWParcelCreate."Source Type Sub"::"Purchase Return Shipment":
                GetFromPurchaseReturnShipment(SEWParcelCreate, xSourceNo);
            SEWParcelCreate."Source Type Sub"::"Purchase Credit Memo":
                GetFromPurchaseCreditMemoHeader(SEWParcelCreate, xSourceNo);
            SEWParcelCreate."Source Type Sub"::"Purchase Blanket Order":
                GetFromPurchaseHeader(SEWParcelCreate, xSourceNo, "Purchase Document Type"::"Blanket Order");
            SEWParcelCreate."Source Type Sub"::"Purchase Quote":
                GetFromPurchaseHeader(SEWParcelCreate, xSourceNo, "Purchase Document Type"::"Quote");
            //"Source Type Sub"::"Subscription Contract Vendor":
            //    GetFromSubscriptionContract("Source No.");

            SEWParcelCreate."Source Type Sub"::"Location":
                GetFromLocation(SEWParcelCreate, xSourceNo);
            SEWParcelCreate."Source Type Sub"::"Warehouse Transfer":
                GetFromWarehouseTransferHeader(SEWParcelCreate, xSourceNo);
            SEWParcelCreate."Source Type Sub"::"Warehouse Transfer Shipment":
                GetFromWarehouseTransferShipmentHeader(SEWParcelCreate, xSourceNo);
            SEWParcelCreate."Source Type Sub"::"Warehouse Transfer Receipt":
                GetFromWarehouseTransferReceiptHeader(SEWParcelCreate, xSourceNo);
            SEWParcelCreate."Source Type Sub"::"Warehouse Direct Transfer":
                GetFromWarehouseDirectTransferHeader(SEWParcelCreate, xSourceNo);
            SEWParcelCreate."Source Type Sub"::"Warehouse Shipment":
                GetFromWarehouseShipmentHeader();
            SEWParcelCreate."Source Type Sub"::"Warehouse Receipt":
                GetFromWarehouseReceiptHeader();
            SEWParcelCreate."Source Type Sub"::"Warehouse Pick":
                GetFromWarehouseActivityHeader(SEWParcelCreate, xSourceNo, "Warehouse Activity Type"::"Invt. Pick");
            SEWParcelCreate."Source Type Sub"::"Ressource":
                GetFromResource(SEWParcelCreate, xSourceNo);
            SEWParcelCreate."Source Type Sub"::"Employee":
                GetFromEmployee(SEWParcelCreate, xSourceNo);
            SEWParcelCreate."Source Type Sub"::"Recipient Address":
                GetFromRecipientAddress(SEWParcelCreate, xSourceNo);

        end;
    end;




    local procedure GetFromContact(var SEWParcelCreate: Record "SEW Parcel"; xSourceNo: Code[20])
    var
        Contact: Record Contact;
    begin
        if Contact.Get(xSourceNo) then begin
            SEWParcelCreate."Ship-to Name 1" := Contact.Name;
            SEWParcelCreate."Ship-to Name 2" := Contact."Name 2";
            SEWParcelCreate."Ship-to Address 1" := Contact.Address;
            SEWParcelCreate."Ship-to Address 2" := Contact."Address 2";
            SEWParcelCreate."Ship-to Post Code" := Contact."Post Code";
            SEWParcelCreate."Ship-to City" := Contact.City;
            SEWParcelCreate."Ship-to Country Code" := Contact."Country/Region Code";
            SEWParcelCreate."Ship-to County" := Contact.County;
            //ContactName := Contact.;
            SEWParcelCreate."Ship-to Phone" := Contact."Phone No.";
            SEWParcelCreate."Ship-to Email" := Contact."E-Mail";
            SEWParcelCreate."SC Order Nbr." := Contact."No.";
        end;
    end;

    local procedure GetFromContactAltAddress(var SEWParcelCreate: Record "SEW Parcel"; xSourceNo: Code[20]; xSourceSubNo: Code[10])
    var
        ContactAltAddress: Record "Contact Alt. Address";
    begin
        if ContactAltAddress.Get(xSourceNo, xSourceSubNo) then begin
            SEWParcelCreate."Ship-to Name 1" := ContactAltAddress."Company Name";
            SEWParcelCreate."Ship-to Name 2" := ContactAltAddress."Company Name 2";
            SEWParcelCreate."Ship-to Address 1" := ContactAltAddress.Address;
            SEWParcelCreate."Ship-to Address 2" := ContactAltAddress."Address 2";
            SEWParcelCreate."Ship-to Post Code" := ContactAltAddress."Post Code";
            SEWParcelCreate."Ship-to City" := ContactAltAddress.City;
            SEWParcelCreate."Ship-to Country Code" := ContactAltAddress."Country/Region Code";
            SEWParcelCreate."Ship-to County" := ContactAltAddress.County;
            SEWParcelCreate."Ship-to Phone" := ContactAltAddress."Phone No.";
            SEWParcelCreate."Ship-to Email" := ContactAltAddress."E-Mail";
            SEWParcelCreate."SC Order Nbr." := ContactAltAddress."Contact No.";
        end;
    end;

    local procedure GetFromCustomer(var SEWParcelCreate: Record "SEW Parcel"; xSourceNo: Code[20])
    var
        Customer: Record Customer;
    begin
        if Customer.Get(xSourceNo) then begin
            SEWParcelCreate."Ship-to Name 1" := Customer.Name;
            SEWParcelCreate."Ship-to Name 2" := Customer."Name 2";
            SEWParcelCreate."Ship-to Address 1" := Customer.Address;
            SEWParcelCreate."Ship-to Address 2" := Customer."Address 2";
            SEWParcelCreate."Ship-to Post Code" := Customer."Post Code";
            SEWParcelCreate."Ship-to City" := Customer.City;
            SEWParcelCreate."Ship-to Country Code" := Customer."Country/Region Code";
            SEWParcelCreate."Ship-to County" := Customer.County;
            SEWParcelCreate."Ship-to Contact Name" := Customer.Contact;
            SEWParcelCreate."Ship-to Phone" := Customer."Phone No.";
            SEWParcelCreate."Ship-to Email" := Customer."E-Mail";
            SEWParcelCreate."SC Order Nbr." := Customer."No.";
        end;
    end;

    local procedure GetFromCustomerShipTo(var SEWParcelCreate: Record "SEW Parcel"; xSourceNo: Code[20]; xSourceSubNo: Code[10])
    var
        ShiptoAddress: Record "Ship-to Address";
    begin
        if ShiptoAddress.Get(xSourceNo, xSourceSubNo) then begin
            SEWParcelCreate."Ship-to Name 1" := ShiptoAddress.Name;
            SEWParcelCreate."Ship-to Name 2" := ShiptoAddress."Name 2";
            SEWParcelCreate."Ship-to Address 1" := ShiptoAddress.Address;
            SEWParcelCreate."Ship-to Address 2" := ShiptoAddress."Address 2";
            SEWParcelCreate."Ship-to Post Code" := ShiptoAddress."Post Code";
            SEWParcelCreate."Ship-to City" := ShiptoAddress.City;
            SEWParcelCreate."Ship-to Country Code" := ShiptoAddress."Country/Region Code";
            SEWParcelCreate."Ship-to County" := ShiptoAddress.County;
            SEWParcelCreate."Ship-to Contact Name" := ShiptoAddress.Contact;
            SEWParcelCreate."Ship-to Phone" := ShiptoAddress."Phone No.";
            SEWParcelCreate."Ship-to Email" := ShiptoAddress."E-Mail";
            SEWParcelCreate."Shipping Agent Code" := ShiptoAddress."Shipping Agent Code";
            SEWParcelCreate."Shipping Agent Service Code" := ShiptoAddress."Shipping Agent Service Code";
            SEWParcelCreate."SC Order Nbr." := ShiptoAddress."Customer No.";
        end;
    end;

    local procedure GetFromSalesHeader(var SEWParcelCreate: Record "SEW Parcel"; xSourceNo: Code[20]; xDocType: Enum "Sales Document Type")
    var
        SalesHeader: Record "Sales Header";
    begin
        if SalesHeader.Get(xDocType, xSourceNo) then begin
            SEWParcelCreate."Ship-to Name 1" := SalesHeader."Ship-to Name";
            SEWParcelCreate."Ship-to Name 2" := SalesHeader."Ship-to Name 2";
            SEWParcelCreate."Ship-to Address 1" := SalesHeader."Ship-to Address";
            SEWParcelCreate."Ship-to Address 2" := SalesHeader."Ship-to Address 2";
            SEWParcelCreate."Ship-to Post Code" := SalesHeader."Ship-to Post Code";
            SEWParcelCreate."Ship-to City" := SalesHeader."Ship-to City";
            SEWParcelCreate."Ship-to Country Code" := SalesHeader."Ship-to Country/Region Code";
            SEWParcelCreate."Ship-to County" := SalesHeader."Ship-to County";
            SEWParcelCreate."Ship-to Contact Name" := SalesHeader."Ship-to Contact";
            SEWParcelCreate."Ship-to Phone" := SalesHeader."Ship-to Phone No.";
            SEWParcelCreate."Ship-to Email" := SalesHeader."Sell-to E-Mail";
            SEWParcelCreate."Shipping Agent Code" := SalesHeader."Shipping Agent Code";
            SEWParcelCreate."Shipping Agent Service Code" := SalesHeader."Shipping Agent Service Code";
            SEWParcelCreate."Your Reference" := SalesHeader."Your Reference";
            SEWParcelCreate."SC Order Nbr." := SalesHeader."No.";
        end;
    end;

    local procedure GetFromSalesHeaderArchive(var SEWParcelCreate: Record "SEW Parcel"; xSourceNo: Code[20]; xDocType: Enum "Sales Document Type")
    var
        SalesHeaderArchive: Record "Sales Header Archive";
    begin
        if SalesHeaderArchive.Get(xDocType, xSourceNo, 1, 1) then begin
            SEWParcelCreate."Ship-to Name 1" := SalesHeaderArchive."Ship-to Name";
            SEWParcelCreate."Ship-to Name 2" := SalesHeaderArchive."Ship-to Name 2";
            SEWParcelCreate."Ship-to Address 1" := SalesHeaderArchive."Ship-to Address";
            SEWParcelCreate."Ship-to Address 2" := SalesHeaderArchive."Ship-to Address 2";
            SEWParcelCreate."Ship-to Post Code" := SalesHeaderArchive."Ship-to Post Code";
            SEWParcelCreate."Ship-to City" := SalesHeaderArchive."Ship-to City";
            SEWParcelCreate."Ship-to Country Code" := SalesHeaderArchive."Ship-to Country/Region Code";
            SEWParcelCreate."Ship-to County" := SalesHeaderArchive."Ship-to County";
            SEWParcelCreate."Ship-to Contact Name" := SalesHeaderArchive."Ship-to Contact";
            SEWParcelCreate."Ship-to Phone" := SalesHeaderArchive."Ship-to Phone No.";
            SEWParcelCreate."Ship-to Email" := SalesHeaderArchive."Sell-to E-Mail";
            SEWParcelCreate."Shipping Agent Code" := SalesHeaderArchive."Shipping Agent Code";
            SEWParcelCreate."Shipping Agent Service Code" := SalesHeaderArchive."Shipping Agent Service Code";
            SEWParcelCreate."Your Reference" := SalesHeaderArchive."Your Reference";
            SEWParcelCreate."SC Order Nbr." := SalesHeaderArchive."No.";
        end;
    end;

    local procedure GetFromSalesShipment(var SEWParcelCreate: Record "SEW Parcel"; xSourceNo: Code[20])
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
    begin
        if SalesShipmentHeader.Get(xSourceNo) then begin
            SEWParcelCreate."Ship-to Name 1" := SalesShipmentHeader."Ship-to Name";
            SEWParcelCreate."Ship-to Name 2" := SalesShipmentHeader."Ship-to Name 2";
            SEWParcelCreate."Ship-to Address 1" := SalesShipmentHeader."Ship-to Address";
            SEWParcelCreate."Ship-to Address 2" := SalesShipmentHeader."Ship-to Address 2";
            SEWParcelCreate."Ship-to Post Code" := SalesShipmentHeader."Ship-to Post Code";
            SEWParcelCreate."Ship-to City" := SalesShipmentHeader."Ship-to City";
            SEWParcelCreate."Ship-to Country Code" := SalesShipmentHeader."Ship-to Country/Region Code";
            SEWParcelCreate."Ship-to County" := SalesShipmentHeader."Ship-to County";
            SEWParcelCreate."Ship-to Contact Name" := SalesShipmentHeader."Ship-to Contact";
            SEWParcelCreate."Ship-to Phone" := SalesShipmentHeader."Ship-to Phone No.";
            SEWParcelCreate."Ship-to Email" := SalesShipmentHeader."Sell-to E-Mail";
            SEWParcelCreate."Shipping Agent Code" := SalesShipmentHeader."Shipping Agent Code";
            SEWParcelCreate."Shipping Agent Service Code" := SalesShipmentHeader."Shipping Agent Service Code";
            SEWParcelCreate."Your Reference" := SalesShipmentHeader."Your Reference";
            SEWParcelCreate."SC Order Nbr." := SalesShipmentHeader."No.";
        end;
    end;

    local procedure GetFromSalesInvoice(var SEWParcelCreate: Record "SEW Parcel"; xSourceNo: Code[20])
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        if SalesInvoiceHeader.Get(xSourceNo) then begin
            SEWParcelCreate."Ship-to Name 1" := SalesInvoiceHeader."Ship-to Name";
            SEWParcelCreate."Ship-to Name 2" := SalesInvoiceHeader."Ship-to Name 2";
            SEWParcelCreate."Ship-to Address 1" := SalesInvoiceHeader."Ship-to Address";
            SEWParcelCreate."Ship-to Address 2" := SalesInvoiceHeader."Ship-to Address 2";
            SEWParcelCreate."Ship-to Post Code" := SalesInvoiceHeader."Ship-to Post Code";
            SEWParcelCreate."Ship-to City" := SalesInvoiceHeader."Ship-to City";
            SEWParcelCreate."Ship-to Country Code" := SalesInvoiceHeader."Ship-to Country/Region Code";
            SEWParcelCreate."Ship-to County" := SalesInvoiceHeader."Ship-to County";
            SEWParcelCreate."Ship-to Contact Name" := SalesInvoiceHeader."Ship-to Contact";
            //Phone := SalesInvoiceHeader."Ship-to Phone No.";
            //Email := SalesInvoiceHeader."Ship-to E-Mail";
            SEWParcelCreate."Shipping Agent Code" := SalesInvoiceHeader."Shipping Agent Code";
            SEWParcelCreate."Shipping Agent Service Code" := SalesInvoiceHeader."Shipping Agent Service Code";
            SEWParcelCreate."Your Reference" := SalesInvoiceHeader."Your Reference";
            SEWParcelCreate."SC Order Nbr." := SalesInvoiceHeader."No.";
        end;
    end;

    local procedure GetFromSalesReturnShipment(var SEWParcelCreate: Record "SEW Parcel"; xSourceNo: Code[20])
    var
        ReturnShipmentHeader: Record "Return Shipment Header";
    begin
        if ReturnShipmentHeader.Get(xSourceNo) then begin
            SEWParcelCreate."Ship-to Name 1" := ReturnShipmentHeader."Ship-to Name";
            SEWParcelCreate."Ship-to Name 2" := ReturnShipmentHeader."Ship-to Name 2";
            SEWParcelCreate."Ship-to Address 1" := ReturnShipmentHeader."Ship-to Address";
            SEWParcelCreate."Ship-to Address 2" := ReturnShipmentHeader."Ship-to Address 2";
            SEWParcelCreate."Ship-to Post Code" := ReturnShipmentHeader."Ship-to Post Code";
            SEWParcelCreate."Ship-to City" := ReturnShipmentHeader."Ship-to City";
            SEWParcelCreate."Ship-to Country Code" := ReturnShipmentHeader."Ship-to Country/Region Code";
            SEWParcelCreate."Ship-to County" := ReturnShipmentHeader."Ship-to County";
            SEWParcelCreate."Ship-to Contact Name" := ReturnShipmentHeader."Ship-to Contact";
            SEWParcelCreate."Ship-to Phone" := ReturnShipmentHeader."Ship-to Phone No.";
            //Email := ReturnShipmentHeader."Sell-to E-Mail";
            SEWParcelCreate."Your Reference" := ReturnShipmentHeader."Your Reference";
            SEWParcelCreate."SC Order Nbr." := ReturnShipmentHeader."No.";
        end;
    end;

    local procedure GetFromJob(var SEWParcelCreate: Record "SEW Parcel"; xSourceNo: Code[20])

    var
        Job: Record Job;
    begin
        if Job.Get(xSourceNo) then begin
            SEWParcelCreate."Ship-to Name 1" := Job."Ship-to Name";
            SEWParcelCreate."Ship-to Name 2" := Job."Ship-to Name 2";
            SEWParcelCreate."Ship-to Address 1" := Job."Ship-to Address";
            SEWParcelCreate."Ship-to Address 2" := Job."Ship-to Address 2";
            SEWParcelCreate."Ship-to Post Code" := Job."Ship-to Post Code";
            SEWParcelCreate."Ship-to City" := Job."Ship-to City";
            SEWParcelCreate."Ship-to Country Code" := Job."Ship-to Country/Region Code";
            SEWParcelCreate."Ship-to County" := Job."Ship-to County";
            SEWParcelCreate."Ship-to Contact Name" := Job."Ship-to Contact";
            SEWParcelCreate."Ship-to Phone" := Job."Ship-to Phone No.";
            SEWParcelCreate."Ship-to Email" := Job."Sell-to E-Mail";
            SEWParcelCreate."Your Reference" := Job."Your Reference";
            SEWParcelCreate."SC Order Nbr." := Job."No.";
        end;
    end;

    local procedure GetFromServiceHeader(var SEWParcelCreate: Record "SEW Parcel"; xSourceNo: Code[20]; xDocType: Enum "Service Document Type")
    var
        ServiceHeader: Record "Service Header";
    begin
        if ServiceHeader.Get(xDocType, xSourceNo) then begin
            SEWParcelCreate."Ship-to Name 1" := ServiceHeader."Ship-to Name";
            SEWParcelCreate."Ship-to Name 2" := ServiceHeader."Ship-to Name 2";
            SEWParcelCreate."Ship-to Address 1" := ServiceHeader."Ship-to Address";
            SEWParcelCreate."Ship-to Address 2" := ServiceHeader."Ship-to Address 2";
            SEWParcelCreate."Ship-to Post Code" := ServiceHeader."Ship-to Post Code";
            SEWParcelCreate."Ship-to City" := ServiceHeader."Ship-to City";
            SEWParcelCreate."Ship-to Country Code" := ServiceHeader."Ship-to Country/Region Code";
            SEWParcelCreate."Ship-to County" := ServiceHeader."Ship-to County";
            SEWParcelCreate."Ship-to Contact Name" := ServiceHeader."Ship-to Contact";
            //Phone := ServiceHeader."Ship-to Phone No.";
            //Email := ServiceHeader."Sell-to E-Mail";
            SEWParcelCreate."Shipping Agent Code" := ServiceHeader."Shipping Agent Code";
            SEWParcelCreate."Shipping Agent Service Code" := ServiceHeader."Shipping Agent Service Code";
            SEWParcelCreate."Your Reference" := ServiceHeader."Your Reference";
            SEWParcelCreate."SC Order Nbr." := ServiceHeader."No.";
        end;
    end;

    local procedure GetFromServiceShipment(var SEWParcelCreate: Record "SEW Parcel"; xSourceNo: Code[20])
    var
        ServiceShipmentHeader: Record "Service Shipment Header";
    begin
        if ServiceShipmentHeader.Get(xSourceNo) then begin
            SEWParcelCreate."Ship-to Name 1" := ServiceShipmentHeader."Ship-to Name";
            SEWParcelCreate."Ship-to Name 2" := ServiceShipmentHeader."Ship-to Name 2";
            SEWParcelCreate."Ship-to Address 1" := ServiceShipmentHeader."Ship-to Address";
            SEWParcelCreate."Ship-to Address 2" := ServiceShipmentHeader."Ship-to Address 2";
            SEWParcelCreate."Ship-to Post Code" := ServiceShipmentHeader."Ship-to Post Code";
            SEWParcelCreate."Ship-to City" := ServiceShipmentHeader."Ship-to City";
            SEWParcelCreate."Ship-to Country Code" := ServiceShipmentHeader."Ship-to Country/Region Code";
            SEWParcelCreate."Ship-to County" := ServiceShipmentHeader."Ship-to County";
            SEWParcelCreate."Ship-to Contact Name" := ServiceShipmentHeader."Ship-to Contact";
            //Phone := ServiceShipmentHeader."Ship-to Phone No.";
            //Email := ServiceShipmentHeader."Sell-to E-Mail";
            SEWParcelCreate."Shipping Agent Code" := ServiceShipmentHeader."Shipping Agent Code";
            SEWParcelCreate."Shipping Agent Service Code" := ServiceShipmentHeader."Shipping Agent Service Code";
            SEWParcelCreate."Your Reference" := ServiceShipmentHeader."Your Reference";
            SEWParcelCreate."SC Order Nbr." := ServiceShipmentHeader."No.";
        end;
    end;

    local procedure GetFromServiceInvoice(var SEWParcelCreate: Record "SEW Parcel"; xSourceNo: Code[20])
    var
        ServiceInvoiceHeader: Record "Service Invoice Header";
    begin
        if ServiceInvoiceHeader.Get(xSourceNo) then begin
            SEWParcelCreate."Ship-to Name 1" := ServiceInvoiceHeader."Ship-to Name";
            SEWParcelCreate."Ship-to Name 2" := ServiceInvoiceHeader."Ship-to Name 2";
            SEWParcelCreate."Ship-to Address 1" := ServiceInvoiceHeader."Ship-to Address";
            SEWParcelCreate."Ship-to Address 2" := ServiceInvoiceHeader."Ship-to Address 2";
            SEWParcelCreate."Ship-to Post Code" := ServiceInvoiceHeader."Ship-to Post Code";
            SEWParcelCreate."Ship-to City" := ServiceInvoiceHeader."Ship-to City";
            SEWParcelCreate."Ship-to Country Code" := ServiceInvoiceHeader."Ship-to Country/Region Code";
            SEWParcelCreate."Ship-to County" := ServiceInvoiceHeader."Ship-to County";
            SEWParcelCreate."Ship-to Contact Name" := ServiceInvoiceHeader."Ship-to Contact";
            //Phone := ServiceInvoiceHeader."Ship-to Phone No.";
            //Email := ServiceInvoiceHeader."Ship-to E-Mail";
            SEWParcelCreate."Shipping Agent Code" := ServiceInvoiceHeader."Shipping Agent Code";
            SEWParcelCreate."Shipping Agent Service Code" := ServiceInvoiceHeader."Shipping Agent Service Code";
            SEWParcelCreate."Your Reference" := ServiceInvoiceHeader."Your Reference";
            SEWParcelCreate."SC Order Nbr." := ServiceInvoiceHeader."No.";
        end;
    end;

    local procedure GetFromServiceCreditMemoHeader(var SEWParcelCreate: Record "SEW Parcel"; xSourceNo: Code[20])
    var
        ServiceCrMemoHeader: Record "Service Cr.Memo Header";
    begin
        if ServiceCrMemoHeader.Get(xSourceNo) then begin
            SEWParcelCreate."Ship-to Name 1" := ServiceCrMemoHeader."Ship-to Name";
            SEWParcelCreate."Ship-to Name 2" := ServiceCrMemoHeader."Ship-to Name 2";
            SEWParcelCreate."Ship-to Address 1" := ServiceCrMemoHeader."Ship-to Address";
            SEWParcelCreate."Ship-to Address 2" := ServiceCrMemoHeader."Ship-to Address 2";
            SEWParcelCreate."Ship-to Post Code" := ServiceCrMemoHeader."Ship-to Post Code";
            SEWParcelCreate."Ship-to City" := ServiceCrMemoHeader."Ship-to City";
            SEWParcelCreate."Ship-to Country Code" := ServiceCrMemoHeader."Ship-to Country/Region Code";
            SEWParcelCreate."Ship-to County" := ServiceCrMemoHeader."Ship-to County";
            SEWParcelCreate."Ship-to Contact Name" := ServiceCrMemoHeader."Ship-to Contact";
            //Phone := ServiceCrMemoHeader."Ship-to Phone No.";
            //Email := ServiceCrMemoHeader."Ship-to E-Mail";
            SEWParcelCreate."Shipping Agent Code" := ServiceCrMemoHeader."Shipping Agent Code";
            SEWParcelCreate."Shipping Agent Service Code" := ServiceCrMemoHeader."Shipping Agent Service Code";
            SEWParcelCreate."Your Reference" := ServiceCrMemoHeader."Your Reference";
            SEWParcelCreate."SC Order Nbr." := ServiceCrMemoHeader."No.";
        end;
    end;


    local procedure GetFromVendor(var SEWParcelCreate: Record "SEW Parcel"; xSourceNo: Code[20])
    var
        Vendor: Record Vendor;
    begin
        if Vendor.Get(xSourceNo) then begin
            SEWParcelCreate."Ship-to Name 1" := Vendor.Name;
            SEWParcelCreate."Ship-to Name 2" := Vendor."Name 2";
            SEWParcelCreate."Ship-to Address 1" := Vendor.Address;
            SEWParcelCreate."Ship-to Address 2" := Vendor."Address 2";
            SEWParcelCreate."Ship-to Post Code" := Vendor."Post Code";
            SEWParcelCreate."Ship-to City" := Vendor.City;
            SEWParcelCreate."Ship-to Country Code" := Vendor."Country/Region Code";
            SEWParcelCreate."Ship-to County" := Vendor.County;
            SEWParcelCreate."Ship-to Contact Name" := Vendor.Contact;
            SEWParcelCreate."Ship-to Phone" := Vendor."Phone No.";
            SEWParcelCreate."Ship-to Email" := Vendor."E-Mail";
            SEWParcelCreate."SC Order Nbr." := Vendor."No.";
        end;
    end;

    local procedure GetFromVendorOrderAddress(var SEWParcelCreate: Record "SEW Parcel"; xSourceNo: Code[20]; xSourceSubNo: Code[10])
    var
        OrderAddress: Record "Order Address";
    begin
        if OrderAddress.Get(xSourceNo, xSourceSubNo) then begin
            SEWParcelCreate."Ship-to Name 1" := OrderAddress.Name;
            SEWParcelCreate."Ship-to Name 2" := OrderAddress."Name 2";
            SEWParcelCreate."Ship-to Address 1" := OrderAddress.Address;
            SEWParcelCreate."Ship-to Address 2" := OrderAddress."Address 2";
            SEWParcelCreate."Ship-to Post Code" := OrderAddress."Post Code";
            SEWParcelCreate."Ship-to City" := OrderAddress.City;
            SEWParcelCreate."Ship-to Country Code" := OrderAddress."Country/Region Code";
            SEWParcelCreate."Ship-to County" := OrderAddress.County;
            SEWParcelCreate."Ship-to Contact Name" := OrderAddress.Contact;
            SEWParcelCreate."Ship-to Phone" := OrderAddress."Phone No.";
            SEWParcelCreate."Ship-to Email" := OrderAddress."E-Mail";
            SEWParcelCreate."SC Order Nbr." := OrderAddress."Vendor No.";
        end;
    end;

    local procedure GetFromPurchaseHeader(var SEWParcelCreate: Record "SEW Parcel"; xSourceNo: Code[20]; xDocType: Enum "Purchase Document Type")
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        if PurchaseHeader.Get(xDocType, xSourceNo) then begin
            SEWParcelCreate."Ship-to Name 1" := PurchaseHeader."Ship-to Name";
            SEWParcelCreate."Ship-to Name 2" := PurchaseHeader."Ship-to Name 2";
            SEWParcelCreate."Ship-to Address 1" := PurchaseHeader."Ship-to Address";
            SEWParcelCreate."Ship-to Address 2" := PurchaseHeader."Ship-to Address 2";
            SEWParcelCreate."Ship-to Post Code" := PurchaseHeader."Ship-to Post Code";
            SEWParcelCreate."Ship-to City" := PurchaseHeader."Ship-to City";
            SEWParcelCreate."Ship-to Country Code" := PurchaseHeader."Ship-to Country/Region Code";
            SEWParcelCreate."Ship-to County" := PurchaseHeader."Ship-to County";
            SEWParcelCreate."Ship-to Contact Name" := PurchaseHeader."Ship-to Contact";
            //Phone := PurchaseHeader."Ship-to Phone No.";
            //Email := PurchaseHeader."Sell-to E-Mail";
            SEWParcelCreate."SC Order Nbr." := PurchaseHeader."No.";
        end;
    end;

    local procedure GetFromPurchaseInvoiceHeader(var SEWParcelCreate: Record "SEW Parcel"; xSourceNo: Code[20])
    var
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        if PurchInvHeader.Get(xSourceNo) then begin
            SEWParcelCreate."Ship-to Name 1" := PurchInvHeader."Ship-to Name";
            SEWParcelCreate."Ship-to Name 2" := PurchInvHeader."Ship-to Name 2";
            SEWParcelCreate."Ship-to Address 1" := PurchInvHeader."Ship-to Address";
            SEWParcelCreate."Ship-to Address 2" := PurchInvHeader."Ship-to Address 2";
            SEWParcelCreate."Ship-to Post Code" := PurchInvHeader."Ship-to Post Code";
            SEWParcelCreate."Ship-to City" := PurchInvHeader."Ship-to City";
            SEWParcelCreate."Ship-to Country Code" := PurchInvHeader."Ship-to Country/Region Code";
            SEWParcelCreate."Ship-to County" := PurchInvHeader."Ship-to County";
            SEWParcelCreate."Ship-to Contact Name" := PurchInvHeader."Ship-to Contact";
            //Phone := PurchInvHeader."Ship-to Phone No.";
            //Email := PurchInvHeader."Ship-to E-Mail";
            SEWParcelCreate."SC Order Nbr." := PurchInvHeader."No.";
        end;
    end;

    local procedure GetFromPurchaseReturnShipment(var SEWParcelCreate: Record "SEW Parcel"; xSourceNo: Code[20])
    var
        ReturnReceiptHeader: Record "Return Receipt Header";
    begin
        if ReturnReceiptHeader.Get(xSourceNo) then begin
            SEWParcelCreate."Ship-to Name 1" := ReturnReceiptHeader."Ship-to Name";
            SEWParcelCreate."Ship-to Name 2" := ReturnReceiptHeader."Ship-to Name 2";
            SEWParcelCreate."Ship-to Address 1" := ReturnReceiptHeader."Ship-to Address";
            SEWParcelCreate."Ship-to Address 2" := ReturnReceiptHeader."Ship-to Address 2";
            SEWParcelCreate."Ship-to Post Code" := ReturnReceiptHeader."Ship-to Post Code";
            SEWParcelCreate."Ship-to City" := ReturnReceiptHeader."Ship-to City";
            SEWParcelCreate."Ship-to Country Code" := ReturnReceiptHeader."Ship-to Country/Region Code";
            SEWParcelCreate."Ship-to County" := ReturnReceiptHeader."Ship-to County";
            SEWParcelCreate."Ship-to Contact Name" := ReturnReceiptHeader."Ship-to Contact";
            SEWParcelCreate."Ship-to Phone" := ReturnReceiptHeader."Ship-to Phone No.";
            //Email := ReturnReceiptHeader."Sell-to E-Mail";
            SEWParcelCreate."SC Order Nbr." := ReturnReceiptHeader."No.";
        end;
    end;

    local procedure GetFromPurchaseCreditMemoHeader(var SEWParcelCreate: Record "SEW Parcel"; xSourceNo: Code[20])
    var
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
    begin
        if PurchCrMemoHdr.Get(xSourceNo) then begin
            SEWParcelCreate."Ship-to Name 1" := PurchCrMemoHdr."Ship-to Name";
            SEWParcelCreate."Ship-to Name 2" := PurchCrMemoHdr."Ship-to Name 2";
            SEWParcelCreate."Ship-to Address 1" := PurchCrMemoHdr."Ship-to Address";
            SEWParcelCreate."Ship-to Address 2" := PurchCrMemoHdr."Ship-to Address 2";
            SEWParcelCreate."Ship-to Post Code" := PurchCrMemoHdr."Ship-to Post Code";
            SEWParcelCreate."Ship-to City" := PurchCrMemoHdr."Ship-to City";
            SEWParcelCreate."Ship-to Country Code" := PurchCrMemoHdr."Ship-to Country/Region Code";
            SEWParcelCreate."Ship-to County" := PurchCrMemoHdr."Ship-to County";
            SEWParcelCreate."Ship-to Contact Name" := PurchCrMemoHdr."Ship-to Contact";
            //Phone := PurchCrMemoHdr."Ship-to Phone No.";
            //Email := PurchCrMemoHdr."Ship-to E-Mail";
            SEWParcelCreate."SC Order Nbr." := PurchCrMemoHdr."No.";
        end;
    end;

    local procedure GetFromPurchaseReceiptHeader(var SEWParcelCreate: Record "SEW Parcel"; xSourceNo: Code[20])
    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
    begin
        if PurchRcptHeader.Get(xSourceNo) then begin
            SEWParcelCreate."Ship-to Name 1" := PurchRcptHeader."Ship-to Name";
            SEWParcelCreate."Ship-to Name 2" := PurchRcptHeader."Ship-to Name 2";
            SEWParcelCreate."Ship-to Address 1" := PurchRcptHeader."Ship-to Address";
            SEWParcelCreate."Ship-to Address 2" := PurchRcptHeader."Ship-to Address 2";
            SEWParcelCreate."Ship-to Post Code" := PurchRcptHeader."Ship-to Post Code";
            SEWParcelCreate."Ship-to City" := PurchRcptHeader."Ship-to City";
            SEWParcelCreate."Ship-to Country Code" := PurchRcptHeader."Ship-to Country/Region Code";
            SEWParcelCreate."Ship-to County" := PurchRcptHeader."Ship-to County";
            SEWParcelCreate."Ship-to Contact Name" := PurchRcptHeader."Ship-to Contact";
            //Phone := PurchRcptHeader."Ship-to Phone No.";
            //Email := PurchRcptHeader."Sell-to E-Mail";
            SEWParcelCreate."SC Order Nbr." := PurchRcptHeader."No.";
        end;
    end;

    local procedure GetFromVendorRemitAddress(var SEWParcelCreate: Record "SEW Parcel"; xSourceNo: Code[20]; xSourceSubNo: Code[10])
    var
        RemitAddress: Record "Remit Address";
    begin
        if RemitAddress.Get(xSourceSubNo, xSourceNo) then begin
            SEWParcelCreate."Ship-to Name 1" := RemitAddress.Name;
            SEWParcelCreate."Ship-to Name 2" := RemitAddress."Name 2";
            SEWParcelCreate."Ship-to Address 1" := RemitAddress.Address;
            SEWParcelCreate."Ship-to Address 2" := RemitAddress."Address 2";
            SEWParcelCreate."Ship-to Post Code" := RemitAddress."Post Code";
            SEWParcelCreate."Ship-to City" := RemitAddress.City;
            SEWParcelCreate."Ship-to Country Code" := RemitAddress."Country/Region Code";
            SEWParcelCreate."Ship-to County" := RemitAddress.County;
            SEWParcelCreate."Ship-to Contact Name" := RemitAddress.Contact;
            SEWParcelCreate."Ship-to Phone" := RemitAddress."Phone No.";
            SEWParcelCreate."Ship-to Email" := RemitAddress."E-Mail";
            SEWParcelCreate."SC Order Nbr." := RemitAddress."Vendor No.";
        end;
    end;


    local procedure GetFromLocation(var SEWParcelCreate: Record "SEW Parcel"; xSourceNo: Code[20])
    var
        Location: Record Location;
    begin
        if Location.Get(CopyStr(xSourceNo, 1, MaxStrLen(Location.Code))) then begin
            SEWParcelCreate."Ship-to Name 1" := Location.Name;
            SEWParcelCreate."Ship-to Name 2" := Location."Name 2";
            SEWParcelCreate."Ship-to Address 1" := Location.Address;
            SEWParcelCreate."Ship-to Address 2" := Location."Address 2";
            SEWParcelCreate."Ship-to Post Code" := Location."Post Code";
            SEWParcelCreate."Ship-to City" := Location.City;
            SEWParcelCreate."Ship-to Country Code" := Location."Country/Region Code";
            SEWParcelCreate."Ship-to County" := Location.County;
            //ContactName := Location.Contact;
            SEWParcelCreate."Ship-to Phone" := Location."Phone No.";
            SEWParcelCreate."Ship-to Email" := Location."E-Mail";
            SEWParcelCreate."SC Order Nbr." := Location.Code;
        end;
    end;

    local procedure GetFromWarehouseTransferHeader(var SEWParcelCreate: Record "SEW Parcel"; xSourceNo: Code[20])
    var
        WarehouseTransferHeader: Record "Transfer Header";
    begin
        if WarehouseTransferHeader.Get(xSourceNo) then begin
            SEWParcelCreate."Ship-to Name 1" := WarehouseTransferHeader."Transfer-to Name";
            SEWParcelCreate."Ship-to Name 2" := WarehouseTransferHeader."Transfer-to Name 2";
            SEWParcelCreate."Ship-to Address 1" := WarehouseTransferHeader."Transfer-to Address";
            SEWParcelCreate."Ship-to Address 2" := WarehouseTransferHeader."Transfer-to Address 2";
            SEWParcelCreate."Ship-to Post Code" := WarehouseTransferHeader."Transfer-to Post Code";
            SEWParcelCreate."Ship-to City" := WarehouseTransferHeader."Transfer-to City";
            SEWParcelCreate."Ship-to Country Code" := WarehouseTransferHeader."Trsf.-to Country/Region Code";
            SEWParcelCreate."Ship-to County" := WarehouseTransferHeader."Transfer-to County";
            SEWParcelCreate."Ship-to Contact Name" := WarehouseTransferHeader."Transfer-to Contact";
            //Phone := WarehouseTransferHeader."Transfer-To Phone No.";
            //Email := WarehouseTransferHeader."Sell-to E-Mail";
            SEWParcelCreate."Shipping Agent Code" := WarehouseTransferHeader."Shipping Agent Code";
            SEWParcelCreate."Shipping Agent Service Code" := WarehouseTransferHeader."Shipping Agent Service Code";
            SEWParcelCreate."SC Order Nbr." := WarehouseTransferHeader."No.";
        end;
    end;

    local procedure GetFromWarehouseTransferShipmentHeader(var SEWParcelCreate: Record "SEW Parcel"; xSourceNo: Code[20])
    var
        WarehouseTransferShipmentHeader: Record "Transfer Shipment Header";
    begin
        if WarehouseTransferShipmentHeader.Get(xSourceNo) then begin
            SEWParcelCreate."Ship-to Name 1" := WarehouseTransferShipmentHeader."Transfer-to Name";
            SEWParcelCreate."Ship-to Name 2" := WarehouseTransferShipmentHeader."Transfer-to Name 2";
            SEWParcelCreate."Ship-to Address 1" := WarehouseTransferShipmentHeader."Transfer-to Address";
            SEWParcelCreate."Ship-to Address 2" := WarehouseTransferShipmentHeader."Transfer-to Address 2";
            SEWParcelCreate."Ship-to Post Code" := WarehouseTransferShipmentHeader."Transfer-to Post Code";
            SEWParcelCreate."Ship-to City" := WarehouseTransferShipmentHeader."Transfer-to City";
            SEWParcelCreate."Ship-to Country Code" := WarehouseTransferShipmentHeader."Trsf.-to Country/Region Code";
            SEWParcelCreate."Ship-to County" := WarehouseTransferShipmentHeader."Transfer-to County";
            SEWParcelCreate."Ship-to Contact Name" := WarehouseTransferShipmentHeader."Transfer-to Contact";
            //Phone := WarehouseTransferShipmentHeader."Transfer-To Phone No.";
            //Email := WarehouseTransferShipmentHeader."Sell-to E-Mail";
            SEWParcelCreate."Shipping Agent Code" := WarehouseTransferShipmentHeader."Shipping Agent Code";
            SEWParcelCreate."Shipping Agent Service Code" := WarehouseTransferShipmentHeader."Shipping Agent Service Code";
            SEWParcelCreate."SC Order Nbr." := WarehouseTransferShipmentHeader."No.";
        end;
    end;

    local procedure GetFromWarehouseTransferReceiptHeader(var SEWParcelCreate: Record "SEW Parcel"; xSourceNo: Code[20])
    var
        WarehouseTransferReceiptHeader: Record "Transfer Receipt Header";
    begin
        if WarehouseTransferReceiptHeader.Get(xSourceNo) then begin
            SEWParcelCreate."Ship-to Name 1" := WarehouseTransferReceiptHeader."Transfer-from Name";
            SEWParcelCreate."Ship-to Name 2" := WarehouseTransferReceiptHeader."Transfer-from Name 2";
            SEWParcelCreate."Ship-to Address 1" := WarehouseTransferReceiptHeader."Transfer-from Address";
            SEWParcelCreate."Ship-to Address 2" := WarehouseTransferReceiptHeader."Transfer-from Address 2";
            SEWParcelCreate."Ship-to Post Code" := WarehouseTransferReceiptHeader."Transfer-from Post Code";
            SEWParcelCreate."Ship-to City" := WarehouseTransferReceiptHeader."Transfer-from City";
            SEWParcelCreate."Ship-to Country Code" := WarehouseTransferReceiptHeader."Trsf.-from Country/Region Code";
            SEWParcelCreate."Ship-to County" := WarehouseTransferReceiptHeader."Transfer-from County";
            SEWParcelCreate."Ship-to Contact Name" := WarehouseTransferReceiptHeader."Transfer-from Contact";
            //Phone := WarehouseTransferReceiptHeader."Trsf.-from Phone No.";
            //Email := WarehouseTransferReceiptHeader."Sell-from E-Mail";
            SEWParcelCreate."Shipping Agent Code" := WarehouseTransferReceiptHeader."Shipping Agent Code";
            SEWParcelCreate."Shipping Agent Service Code" := WarehouseTransferReceiptHeader."Shipping Agent Service Code";
            SEWParcelCreate."SC Order Nbr." := WarehouseTransferReceiptHeader."No.";
        end;
    end;

    local procedure GetFromWarehouseDirectTransferHeader(var SEWParcelCreate: Record "SEW Parcel"; xSourceNo: Code[20])
    var
        WarehouseDirectTransHeader: Record "Direct Trans. Header";
    begin
        if WarehouseDirectTransHeader.Get(xSourceNo) then begin
            SEWParcelCreate."Ship-to Name 1" := WarehouseDirectTransHeader."Transfer-to Name";
            SEWParcelCreate."Ship-to Name 2" := WarehouseDirectTransHeader."Transfer-to Name 2";
            SEWParcelCreate."Ship-to Address 1" := WarehouseDirectTransHeader."Transfer-to Address";
            SEWParcelCreate."Ship-to Address 2" := WarehouseDirectTransHeader."Transfer-to Address 2";
            SEWParcelCreate."Ship-to Post Code" := WarehouseDirectTransHeader."Transfer-to Post Code";
            SEWParcelCreate."Ship-to City" := WarehouseDirectTransHeader."Transfer-to City";
            SEWParcelCreate."Ship-to Country Code" := WarehouseDirectTransHeader."Trsf.-to Country/Region Code";
            SEWParcelCreate."Ship-to County" := WarehouseDirectTransHeader."Transfer-to County";
            SEWParcelCreate."Ship-to Contact Name" := WarehouseDirectTransHeader."Transfer-to Contact";
            //Phone := WarehouseDirectTransHeader."Transfer-To Phone No.";
            //Email := WarehouseDirectTransHeader."Sell-to E-Mail";
            SEWParcelCreate."SC Order Nbr." := WarehouseDirectTransHeader."No.";
        end;
    end;

    local procedure GetFromWarehouseShipmentHeader()
    var
    //WarehouseShipmentHeader: Record "Warehouse Shipment Header";
    begin
        Error(ErrMsgNotImplementedLbl);
        // if WarehouseShipmentHeader.Get(xDocNo) then begin
        //     // Name1 := WarehouseShipmentHeader."Ship-to Name";
        //     // Name2 := WarehouseShipmentHeader."Ship-to Name 2";
        //     // Address1 := WarehouseShipmentHeader."Ship-to Address";
        //     // Address2 := WarehouseShipmentHeader."Ship-to Address 2";
        //     // PostalCode := WarehouseShipmentHeader."Ship-to Post Code";
        //     // City := WarehouseShipmentHeader."Ship-to City";
        //     // CountryCode := WarehouseShipmentHeader."Ship-to Country/Region Code";
        //     // CountryState := WarehouseShipmentHeader."Ship-to County";
        //     // ContactName := WarehouseShipmentHeader."Ship-to Contact";
        //     //Phone := WarehouseShipmentHeader."Ship-to Phone No.";
        //     //Email := WarehouseShipmentHeader."Sell-to E-Mail";
        // end;
    end;

    local procedure GetFromWarehouseReceiptHeader()
    var
    //WarehouseReceiptHeader: Record "Warehouse Receipt Header";
    begin
        Error(ErrMsgNotImplementedLbl);
        // if WarehouseReceiptHeader.Get(xDocNo) then begin
        //     // Name1 := WarehouseReceiptHeader."Receipt-from Name";
        //     // Name2 := WarehouseReceiptHeader."Receipt-from Name 2";
        //     // Address1 := WarehouseReceiptHeader."Receipt-from Address";
        //     // Address2 := WarehouseReceiptHeader."Receipt-from Address 2";
        //     // PostalCode := WarehouseReceiptHeader."Receipt-from Post Code";
        //     // City := WarehouseReceiptHeader."Receipt-from City";
        //     // CountryCode := WarehouseReceiptHeader."Rcpt.-from Country/Region Code";
        //     // CountryState := WarehouseReceiptHeader."Receipt-from County";
        //     // ContactName := WarehouseReceiptHeader."Receipt-from Contact";
        //     //Phone := WarehouseReceiptHeader."Rcpt.-from Phone No.";
        //     //Email := WarehouseReceiptHeader."Sell-from E-Mail";
        // end;
    end;

    local procedure GetFromWarehouseActivityHeader(var SEWParcelCreate: Record "SEW Parcel"; xSourceNo: Code[20]; xType: Enum "Warehouse Activity Type")
    var
        WarehouseActivityHeader: Record "Warehouse Activity Header";
    begin
        if WarehouseActivityHeader.Get(xType, xSourceNo) then
            if WarehouseActivityHeader.Type = WarehouseActivityHeader.Type::"Invt. Pick" then
                case WarehouseActivityHeader."Source Document" of

                    "Warehouse Activity Source Document"::"Sales Order":
                        GetFromSalesHeader(SEWParcelCreate, WarehouseActivityHeader."Source No.", "Sales Document Type"::Order);

                    "Warehouse Activity Source Document"::"Sales Return Order":
                        GetFromSalesHeader(SEWParcelCreate, WarehouseActivityHeader."Source No.", "Sales Document Type"::"Return Order");

                    "Warehouse Activity Source Document"::"Service Order":
                        GetFromServiceHeader(SEWParcelCreate, WarehouseActivityHeader."Source No.", "Service Document Type"::Order);

                    "Warehouse Activity Source Document"::"Purchase Order":
                        GetFromPurchaseHeader(SEWParcelCreate, WarehouseActivityHeader."Source No.", "Purchase Document Type"::Order);

                    "Warehouse Activity Source Document"::"Purchase Return Order":
                        GetFromPurchaseHeader(SEWParcelCreate, WarehouseActivityHeader."Source No.", "Purchase Document Type"::"Return Order");

                    "Warehouse Activity Source Document"::"Inbound Transfer":
                        GetFromWarehouseTransferHeader(SEWParcelCreate, WarehouseActivityHeader."Source No.");

                    "Warehouse Activity Source Document"::"Outbound Transfer":
                        GetFromWarehouseTransferHeader(SEWParcelCreate, WarehouseActivityHeader."Source No.");
                end;
    end;

    local procedure GetFromResource(var SEWParcelCreate: Record "SEW Parcel"; xSourceNo: Code[20])
    var
        Resource: Record Resource;
    begin
        if Resource.Get(xSourceNo) then begin
            SEWParcelCreate."Ship-to Name 1" := Resource.Name;
            SEWParcelCreate."Ship-to Name 2" := Resource."Name 2";
            SEWParcelCreate."Ship-to Address 1" := Resource.Address;
            SEWParcelCreate."Ship-to Address 2" := Resource."Address 2";
            SEWParcelCreate."Ship-to Post Code" := Resource."Post Code";
            SEWParcelCreate."Ship-to City" := Resource.City;
            SEWParcelCreate."Ship-to Country Code" := Resource."Country/Region Code";
            SEWParcelCreate."Ship-to County" := Resource.County;
            //ContactName := Resource.Contact;
            //Phone := Resource."Phone No.";
            //Email := Resource."E-Mail";
            SEWParcelCreate."SC Order Nbr." := Resource."No.";
        end;
    end;

    local procedure GetFromEmployee(var SEWParcelCreate: Record "SEW Parcel"; xSourceNo: Code[20])
    var
        Employee: Record Employee;
    begin
        if Employee.Get(xSourceNo) then begin
            SEWParcelCreate."Ship-to Name 1" := Employee."First Name" + ' ' + Employee."Last Name";
            //            Name2 := Employee."Name 2";
            SEWParcelCreate."Ship-to Address 1" := Employee.Address;
            SEWParcelCreate."Ship-to Address 2" := Employee."Address 2";
            SEWParcelCreate."Ship-to Post Code" := Employee."Post Code";
            SEWParcelCreate."Ship-to City" := Employee.City;
            SEWParcelCreate."Ship-to Country Code" := Employee."Country/Region Code";
            SEWParcelCreate."Ship-to County" := Employee.County;
            //ContactName := Employee.Contact;
            SEWParcelCreate."Ship-to Phone" := Employee."Phone No.";
            SEWParcelCreate."Ship-to Email" := Employee."E-Mail";
            SEWParcelCreate."SC Order Nbr." := Employee."No.";
        end;
    end;

    local procedure GetFromRecipientAddress(var SEWParcelCreate: Record "SEW Parcel"; xSourceNo: Code[20])
    var
        SEWRecipientAddress: Record "SEW Recipient Address";
    begin
        if SEWRecipientAddress.Get(xSourceNo) then begin
            SEWParcelCreate."Ship-to Name 1" := SEWRecipientAddress."Name 1";
            SEWParcelCreate."Ship-to Name 2" := SEWRecipientAddress."Name 2";
            SEWParcelCreate."Ship-to Address 1" := SEWRecipientAddress.Street;
            SEWParcelCreate."Ship-to House Nbr." := SEWRecipientAddress."House Nbr.";
            SEWParcelCreate."Ship-to Post Code" := SEWRecipientAddress."PostalCode";
            SEWParcelCreate."Ship-to City" := SEWRecipientAddress.City;
            SEWParcelCreate."Ship-to Country Code" := SEWRecipientAddress."CountryCode";
            SEWParcelCreate."Ship-to County" := SEWRecipientAddress.CountryState;
            SEWParcelCreate."Ship-to Contact Name" := SEWRecipientAddress.ContactName;
            SEWParcelCreate."Ship-to Phone" := SEWRecipientAddress."Phone";
            SEWParcelCreate."Ship-to Email" := SEWRecipientAddress."Email";
            SEWParcelCreate."SC Order Nbr." := SEWRecipientAddress."Recipient No.";
        end;
    end;

    var
        ErrMsgNotImplementedLbl: Label 'This Function is not implemented yet.';

}
