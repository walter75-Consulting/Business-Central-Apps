permissionset 90100 "SEW Calc"
{
    Caption = 'Calculation';
    Assignable = true;
    Permissions =
        table "SEW CalcHeader" = x,
        table "SEW Calc Master Header" = x,
        table "SEW CalcLine" = x,
        table "SEW Calc Master Line" = x,
        table "SEW Calc Variables" = x,

        tabledata "SEW CalcHeader" = RIMD,
        tabledata "SEW Calc Master Header" = RIMD,
        tabledata "SEW CalcLine" = RIMD,
        tabledata "SEW Calc Master Line" = RMID,
        tabledata "SEW Calc Variables" = RMID;

}