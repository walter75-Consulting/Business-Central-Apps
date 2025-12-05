permissionset 80014 "SEW Area Inventory"
{
    Assignable = true;
    Caption = 'Area Inventory', MaxLength = 30;

    Permissions =
        codeunit "SEW BA Single Instance" = X,
        codeunit "SEW AI Actions Page" = X,
        codeunit "SEW AI Actions Table" = X,
        codeunit "SEW AI Event Subs" = X,
        codeunit "SEW Report Functions" = X;
}
