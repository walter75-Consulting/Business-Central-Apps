/// <summary>
/// Standard user permissions for Core App.
/// Allows logging errors and activities, checking features.
/// </summary>
permissionset 71001 "SEW-CORE-USER"
{
    Assignable = true;
    Caption = 'SEW Core User', MaxLength = 30;

    IncludedPermissionSets = "SEW-CORE-READ";

    Permissions =
    tabledata "SEW Error Log" = RI,
    tabledata "Activity Log" = RI,
    codeunit "SEW Error Logger" = X,
    codeunit "SEW Activity Log Helper" = X,
    codeunit "SEW Feature Management" = X;
}
