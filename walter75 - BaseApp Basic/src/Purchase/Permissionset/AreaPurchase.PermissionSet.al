permissionset 80012 "SEW Area Purchase"
{
    Assignable = true;
    Caption = 'Area Purchase', MaxLength = 30;

    Permissions =
        codeunit "SEW BA Single Instance" = X,
        codeunit "SEW AP Actions Page" = X,
        codeunit "SEW AP Actions Table" = X,
        codeunit "SEW AP Event Subs" = X,
        codeunit "SEW Report Functions" = X;


}
