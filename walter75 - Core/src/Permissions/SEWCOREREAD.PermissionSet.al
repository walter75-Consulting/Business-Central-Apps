/// <summary>
/// Basic read permissions for Core App.
/// Allows viewing error logs and checking feature status.
/// </summary>
permissionset 71000 "SEW-CORE-READ"
{
    Assignable = true;
    Caption = 'SEW Core Read', MaxLength = 30;

    Permissions =
    tabledata "SEW Error Log" = R,
    tabledata "SEW Feature" = R,
    table "SEW Error Log" = X,
    table "SEW Feature" = X,
    codeunit "SEW Error Logger" = X,
    codeunit "SEW Feature Management" = X,
    page "SEW Error Log List" = X,
    page "SEW Error Log Card" = X,
    page "SEW Feature Management" = X,
    page "SEW Feature Card" = X;
}
