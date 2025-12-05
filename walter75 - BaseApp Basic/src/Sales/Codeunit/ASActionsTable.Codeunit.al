codeunit 80004 "SEW AS Actions Table"
{
    Permissions = tabledata Customer = rmid;

    procedure CustomerSearchDescription(var Customer: Record "Customer")
    begin
        Customer."SEW Search Description" := CopyStr(Customer."Search Name" + ' ' + Customer."Post Code", 1, MaxStrLen(Customer."SEW Search Description"));
        Customer.Modify(false);
    end;

    procedure CustomerMasterNo(var Customer: Record "Customer")
    begin
        if Customer."SEW No. Master" = '' then
            Customer."SEW No. Master" := Customer."No.";
        Customer.Modify(false);
    end;
}
