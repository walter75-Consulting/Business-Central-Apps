permissionset 91600 "SEW Color Master"
{
    Assignable = true;
    Caption = 'Color Master', MaxLength = 30;
    Permissions =
        table "SEW Item Colors" = X,
        tabledata "SEW Item Colors" = RMID,
        page "SEW Item Colors" = X,
        codeunit "SEW PK Event Subs" = X,
        codeunit "SEW Copy Item Color Master" = X,
        codeunit "SEW Event Table" = X;
}
