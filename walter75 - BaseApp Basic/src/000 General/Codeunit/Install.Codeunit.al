codeunit 80028 "SEW Install"
{
    Subtype = Install;
    Access = Internal;

    Permissions = tabledata "SEW Auto Dimension Setup" = rimd,
                  tabledata "SEW Toolbox Setup" = rimd;


    trigger OnInstallAppPerCompany()
    var
        // Add variables here that you need in the trigger.
        SEWAutoDimensionSetup: Record "SEW Auto Dimension Setup";
        SEWToolboxSetup: Record "SEW Toolbox Setup";
    begin
        // Add code here that you want to run when the app is installed in a company.
        if not SEWAutoDimensionSetup.Get() then
            SEWAutoDimensionSetup.InsertIfNotExists();

        if not SEWToolboxSetup.Get() then
            SEWToolboxSetup.InsertIfNotExists();

    end;

}