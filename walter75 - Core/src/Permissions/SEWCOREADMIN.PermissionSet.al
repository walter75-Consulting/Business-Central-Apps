/// <summary>
/// Administrator permissions for Core App.
/// Full control over error logs, features, and configuration.
/// </summary>
permissionset 71002 "SEW-CORE-ADMIN"
{
    Assignable = true;
    Caption = 'SEW Core Admin', MaxLength = 30;

    IncludedPermissionSets = "SEW-CORE-USER";

    Permissions =
    tabledata "SEW Error Log" = RIMD,
    tabledata "SEW Feature" = RIMD,
    tabledata "Activity Log" = RIMD,
    table "SEW Error Log" = X,
    table "SEW Feature" = X,
    codeunit "SEW Error Logger" = X,
    codeunit "SEW Activity Log Helper" = X,
    codeunit "SEW Feature Management" = X,
    codeunit "SEW Core Install" = X,
    codeunit "SEW Core Upgrade" = X,
    page "SEW Error Log List" = X,
    page "SEW Error Log Card" = X,
    page "SEW Feature Management" = X,
    page "SEW Feature Card" = X;
}
