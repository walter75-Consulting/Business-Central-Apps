/// <summary>
/// Installation handler for Core App.
/// Registers Error Log table for retention policy.
/// </summary>
codeunit 71000 "SEW Core Install"
{
    Subtype = Install;
    Access = Internal;
    Permissions = tabledata "SEW Error Log" = rimd,
                tabledata "SEW Feature" = rimd;

    trigger OnInstallAppPerDatabase()
    begin
        // Per-database initialization (no company context)
        // Retention policy registration requires company context - see OnInstallAppPerCompany
    end;

    trigger OnInstallAppPerCompany()
    begin
        // Register retention policy table in company context
        RegisterRetentionPolicyTable();
    end;

    local procedure RegisterRetentionPolicyTable()
    var
        RetenPolAllowedTables: Codeunit "Reten. Pol. Allowed Tables";
    begin
        // Register Error Log table for retention policy
        // Allows admins to configure retention via standard BC Retention Policy UI
        // Recommended: 30 days, but admin can adjust as needed
        RetenPolAllowedTables.AddAllowedTable(Database::"SEW Error Log");
    end;
}
