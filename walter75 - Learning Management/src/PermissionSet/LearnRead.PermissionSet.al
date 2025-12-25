/// <summary>
/// PermissionSet SEW LEARN-READ (ID 91880).
/// Read-only access to Learning Management objects.
/// </summary>
permissionset 91880 "SEW LEARN-READ"
{
    Assignable = true;
    Caption = 'Learning Management - Read';

    Permissions =
    tabledata "SEW Learning Mgmt Setup" = R,
    tabledata "SEW Learn Cont" = R,
    tabledata "SEW Learn Cont Path Mod" = R,
    tabledata "SEW Learn Cont Levels" = R,
    tabledata "SEW Learn Cont Roles" = R,
    tabledata "SEW Learn Cont Subjects" = R,
    tabledata "SEW Empl. Learning Assign." = R,
    tabledata "SEW Assignment Module Progress" = R,
    tabledata "SEW Skill" = R,
    tabledata "SEW Skill Learning Mapping" = R,
    tabledata "SEW Employee Skill" = R,
    tabledata "SEW Role Skill Requirement" = R,
    tabledata "SEW Employee Role" = R;
}
