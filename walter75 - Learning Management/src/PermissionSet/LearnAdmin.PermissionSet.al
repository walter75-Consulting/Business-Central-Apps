/// <summary>
/// PermissionSet SEW LEARN-ADMIN (ID 91903).
/// Full administrative access to Learning Management.
/// </summary>
permissionset 91883 "SEW LEARN-ADMIN"
{
    Assignable = true;
    Caption = 'Learning Management - Admin';

    IncludedPermissionSets = "SEW LEARN-MANAGER";

    Permissions =
    tabledata "SEW Learning Mgmt Setup" = RIMD,
    tabledata "SEW Learn Cont" = RIMD,
    tabledata "SEW Learn Cont Path Mod" = RIMD,
    tabledata "SEW Learn Cont Levels" = RIMD,
    tabledata "SEW Learn Cont Roles" = RIMD,
    tabledata "SEW Learn Cont Subjects" = RIMD,
    tabledata "SEW Skill" = RIMD,
    tabledata "SEW Skill Learning Mapping" = RIMD,
    tabledata "SEW Employee Skill" = RIMD,
    tabledata "SEW Role Skill Requirement" = RIMD,
    tabledata "SEW Employee Role" = RIMD;
}
