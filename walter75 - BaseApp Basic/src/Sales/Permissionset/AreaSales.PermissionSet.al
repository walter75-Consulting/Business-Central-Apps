permissionset 80011 "SEW Area Sales"
{
    Assignable = true;
    Caption = 'Area Sales', MaxLength = 30;
    Permissions =
        codeunit "SEW BA Single Instance" = X,
        codeunit "SEW AS Actions Page" = X,
        codeunit "SEW AS Actions Table" = X,
        codeunit "SEW AS Event Subs" = X,
        codeunit "SEW AS Functions" = X,
        codeunit "SEW Report Functions" = X,
        codeunit "SEW Sales Line Avail Mgt." = X,
        page "SEW Customer Group List" = X,
        page "SEW FB Item SellOut History" = X,
        page "SEW Ship-to Address List" = X,
        page "SEW Document Text Sales" = X,
        query "SEW FB Item SellOut" = X,
        table "SEW Customer Group" = X,
        tabledata "SEW Customer Group" = RMID,
        table "SEW Document Text Sales" = X,
        tabledata "SEW Document Text Sales" = RMID;


}