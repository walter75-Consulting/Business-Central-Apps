codeunit 92713 "SEW PN Install"
{
    Subtype = Install;
    Access = Internal;
    Permissions = tabledata "SEW PrintNode Setup" = rimd;




    trigger OnInstallAppPerCompany()
    var
        SEWPrintNodeSetup: Record "SEW PrintNode Setup";
    begin
        SEWPrintNodeSetup.InsertIfNotExists();

        if not SEWPrintNodeSetup.Get() then
            SEWPrintNodeSetup.InsertIfNotExists();

        SEWPrintNodeSetup."PrintNode Base URL" := 'https://api.printnode.com/';
        SEWPrintNodeSetup."API Key" := 'utC_b5GLiuUf348WOcOmtbePebVr8YUQDmd3daBM9SI';
        SEWPrintNodeSetup.Modify(false);
    end;
}

