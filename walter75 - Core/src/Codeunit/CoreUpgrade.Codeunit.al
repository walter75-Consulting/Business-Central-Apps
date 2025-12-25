/// <summary>
/// Upgrade handler for Core App.
/// Handles version upgrades and data migrations.
/// </summary>
codeunit 71001 "SEW Core Upgrade"
{
    Subtype = Upgrade;
    Access = Internal;
    Permissions = tabledata "SEW Error Log" = rimd,
                tabledata "SEW Feature" = rimd;

    trigger OnUpgradePerDatabase()
    begin
        // Schema upgrades for future versions
    end;

    trigger OnUpgradePerCompany()
    begin
        // Data migrations for future versions
    end;
}
