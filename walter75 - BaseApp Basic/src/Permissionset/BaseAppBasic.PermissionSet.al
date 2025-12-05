permissionset 80001 "SEW BaseApp Basic"
{
    Assignable = true;
    Caption = 'BaseApp Basic', MaxLength = 30;

    IncludedPermissionSets = "SEW AutoDimension", "SEW Area CRM", "SEW Area Inventory", "SEW Area Manufactu", "SEW Area Sales", "SEW Area Purchase";

    Permissions =
        codeunit "SEW BA Single Instance" = X,
        codeunit "SEW Install" = X,
        codeunit "SEW Install - Upgrade" = X,
        codeunit "SEW BA Event Subs" = X,
        codeunit "SEW Report Functions" = X,
        codeunit "SEW Toolbox Enable Features" = X,
        page "SEW Toolbox Setup" = X,
        table "SEW Toolbox Setup" = X,
        tabledata "SEW Toolbox Setup" = RMID,
        page "SEW User Management" = X;
}
