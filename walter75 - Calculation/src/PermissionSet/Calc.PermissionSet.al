permissionset 90899 "SEW Calc"
{
    Caption = 'SEW Calc', MaxLength = 30;
    Assignable = true;
    Permissions =
        // Tables
        table "SEW Calc Template" = X,
        tabledata "SEW Calc Template" = RMID,
        table "SEW Calc Template Line" = X,
        tabledata "SEW Calc Template Line" = RMID,
        table "SEW Calc Variable" = X,
        tabledata "SEW Calc Variable" = RMID,
        table "SEW Calc Header" = X,
        tabledata "SEW Calc Header" = RMID,
        table "SEW Calc Line" = X,
        tabledata "SEW Calc Line" = RMID,
        // Pages
        page "SEW Calc Templates" = X,
        page "SEW Calc Template Card" = X,
        page "SEW Calc Template Lines" = X,
        page "SEW Calc Variables" = X,
        page "SEW Calc Headers" = X,
        page "SEW Calc Card" = X,
        page "SEW Calc Lines" = X,
        // Codeunits
        codeunit "SEW Calc Engine" = X,
        codeunit "SEW Calc Formula Parser" = X,
        codeunit "SEW Calc Price Management" = X,
        codeunit "SEW Calc Template Management" = X,
        codeunit "SEW Calc Integration Mgt." = X,
        // Report
        report "SEW Calculation Report" = X;
}