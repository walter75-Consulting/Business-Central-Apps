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
        table "SEW Calc Simulation Header" = X,
        tabledata "SEW Calc Simulation Header" = RMID,
        table "SEW Calc Simulation Line" = X,
        tabledata "SEW Calc Simulation Line" = RMID,
        table "SEW Calc History Entry" = X,
        tabledata "SEW Calc History Entry" = RMID,
        table "SEW Calc Cue" = X,
        tabledata "SEW Calc Cue" = RMID,
        // Pages
        page "SEW Calc Templates" = X,
        page "SEW Calc Template Card" = X,
        page "SEW Calc Template Lines" = X,
        page "SEW Calc Variables" = X,
        page "SEW Calc Headers" = X,
        page "SEW Calc Card" = X,
        page "SEW Calc Lines" = X,
        page "SEW Calc Simulation Card" = X,
        page "SEW Calc Simulation List" = X,
        page "SEW Calc Simulation Subform" = X,
        page "SEW Calc Simulation FactBox" = X,
        page "SEW Calc Cost Breakdown FB" = X,
        page "SEW Calc History List" = X,
        page "SEW Calc Activities" = X,
        pageextension "SEW Order Processor RC Ext" = X,
        // Codeunits
        codeunit "SEW Calc Engine" = X,
        codeunit "SEW Calc Formula Parser" = X,
        codeunit "SEW Calc Price Management" = X,
        codeunit "SEW Calc Template Management" = X,
        codeunit "SEW Calc Integration Mgt." = X,
        codeunit "SEW Calc Simulation Mgt." = X,
        codeunit "SEW Calc Production Integ" = X,
        codeunit "SEW Calc Post-Calculation" = X,
        codeunit "SEW Calc Export Management" = X,
        // Report
        report "SEW Calculation Report" = X;
}