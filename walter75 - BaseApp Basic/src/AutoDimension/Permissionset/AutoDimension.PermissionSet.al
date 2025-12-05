permissionset 80007 "SEW AutoDimension"
{
    Assignable = true;
    Caption = 'Auto Dimension', MaxLength = 30;
    Permissions =
        table "SEW Auto Dimension Setup" = X,
        tabledata "SEW Auto Dimension Setup" = RMID,
        table "Default Dimension" = X,
        tabledata "Default Dimension" = RMID,
        page "SEW AD Auto Dimension Setup" = X,
        codeunit "SEW AD Dimension Mgmt" = X,
        codeunit "SEW AD Events Table" = X,
        codeunit "SEW AD Events Codeunit" = X;
}
