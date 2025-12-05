permissionset 90600 "SEW BDE"
{
    Caption = 'BDE Terminal';
    Assignable = true;
    Permissions =
        tabledata "SEW BDE Terminal Center" = RMID,
        tabledata "SEW BDE Terminal" = RMID,
        tabledata "SEW BDE Booking" = RMID,
        table "SEW BDE Terminal" = X,
        table "SEW BDE Terminal Center" = X,
        table "SEW BDE Booking" = X,
        page "SEW BDE Terminal Card" = X,
        page "SEW BDE Terminal Card Book" = X,
        page "SEW BDE Terminal Card ToDo" = X,
        page "SEW BDE Terminals" = X,
        page "SEW BDE Terminals Center" = X,
        page "SEW BDE Booking" = X,
        page "SEW BDE Booking Dialog" = X,
        page "SEW Routing Lines List" = X,
        codeunit "SEW BDE Terminal" = X;
}