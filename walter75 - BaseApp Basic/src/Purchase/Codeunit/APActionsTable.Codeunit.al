codeunit 80027 "SEW AP Actions Table"
{
    Permissions = tabledata Vendor = rmid;


    procedure VendorSearchDescription(var Vendor: Record "Vendor")
    begin
        Vendor."SEW Search Description" := CopyStr(Vendor."Search Name" + ' ' + Vendor."Post Code", 1, MaxStrLen(Vendor."SEW Search Description"));
        Vendor.Modify(false);
    end;

}
