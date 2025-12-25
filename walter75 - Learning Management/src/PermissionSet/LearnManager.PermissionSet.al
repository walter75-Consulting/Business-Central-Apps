/// <summary>
/// PermissionSet SEW LEARN-MANAGER (ID 91902).
/// Manager operations (assign training to team).
/// </summary>
permissionset 91882 "SEW LEARN-MANAGER"
{
    Assignable = true;
    Caption = 'Learning Management - Manager';

    IncludedPermissionSets = "SEW LEARN-USER";

    Permissions =
    tabledata "SEW Empl. Learning Assign." = RIMD,
    tabledata "SEW Assignment Module Progress" = RIMD,
    tabledata "User Task" = RI;
}
