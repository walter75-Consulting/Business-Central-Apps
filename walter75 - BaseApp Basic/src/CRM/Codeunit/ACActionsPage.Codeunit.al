codeunit 80026 "SEW AC Actions Page"
{

    Permissions = tabledata Customer = R,
                  tabledata Vendor = R;


    procedure OpenVendorCard(VendorNo: Code[20])
    var
        Vendor: Record Vendor;
    begin
        if VendorNo <> '' then begin
            Vendor.SetRange("No.", VendorNo);
            if Vendor.FindFirst() then
                Page.Run(Page::"Vendor Card", Vendor);
        end;
    end;

    procedure OpenCustomerCard(CustomerNo: Code[20])
    var
        Customer: Record Customer;
    begin
        if CustomerNo <> '' then begin
            Customer.SetRange("No.", CustomerNo);
            if Customer.FindFirst() then
                Page.Run(Page::"Customer Card", Customer);
        end;
    end;

}