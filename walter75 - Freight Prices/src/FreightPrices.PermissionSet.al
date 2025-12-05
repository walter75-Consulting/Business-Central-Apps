permissionset 91400 "SEW Freight Prices"
{
    Assignable = true;
    Caption = 'Freight Prices', MaxLength = 30;
    Permissions =
        table "SEW Freight Prices" = X,
        tabledata "SEW Freight Prices" = RMID,
        page "SEW Freight Prices" = X,
        codeunit "SEW Freight Events" = X;
}
