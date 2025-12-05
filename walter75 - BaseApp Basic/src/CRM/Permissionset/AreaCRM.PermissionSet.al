permissionset 80015 "SEW Area CRM"
{
    Assignable = true;
    Caption = 'Area Sales', MaxLength = 30;
    Permissions =
        codeunit "SEW BA Single Instance" = X,
        codeunit "SEW AC Actions Page" = X,
        codeunit "SEW AC Actions Table" = X,
        codeunit "SEW AC Event Subs" = X,
        codeunit "SEW Territories Processing" = X,
        page "SEW Contact Title" = X,
        page "SEW ContactCard Contacs Sub" = X,
        table "SEW Contact Title" = X,
        tabledata "SEW Contact Title" = RMID,
        codeunit "SEW Report Functions" = X;


}