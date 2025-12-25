/// <summary>
/// PermissionSet SEW LEARN-USER (ID 91901).
/// Standard user operations (mark assignments started/completed).
/// </summary>
permissionset 91881 "SEW LEARN-USER"
{
    Assignable = true;
    Caption = 'Learning Management - User';

    IncludedPermissionSets = "SEW LEARN-READ";

    Permissions =
    tabledata "SEW Empl. Learning Assign." = RM,
    tabledata "SEW Assignment Module Progress" = RM;
}
