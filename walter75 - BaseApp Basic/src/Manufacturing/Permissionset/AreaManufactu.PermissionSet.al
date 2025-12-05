permissionset 80013 "SEW Area Manufactu"
{
    Assignable = true;
    Caption = 'Area Manufacturing', MaxLength = 30;

    Permissions =
        codeunit "SEW BA Single Instance" = X,
        codeunit "SEW AM Actions Page" = X,
        codeunit "SEW AM Actions Table" = X,
        codeunit "SEW AM Event Subs" = X,
        codeunit "SEW Report Functions" = X,
        page "SEW Production Operation Lis" = X;
}
