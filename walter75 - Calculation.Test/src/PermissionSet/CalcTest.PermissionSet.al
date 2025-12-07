permissionset 90999 "SEW CALC TEST"
{
    Assignable = true;
    Caption = 'SEW Calc Test', MaxLength = 30;

    Permissions =
        // Test Codeunits
        codeunit "SEW Calc Formula Parser Test" = X,
        codeunit "SEW Calc Variable Test" = X,
        codeunit "SEW Calc BOM Routing Test" = X,
        codeunit "SEW Calc Template Test" = X,
        codeunit "SEW Calc Engine Test" = X,
        codeunit "SEW Calc Integration Test" = X,
        codeunit "SEW Calc Sales Integ. Test" = X,
        codeunit "SEW Calc Simulation Test" = X,
        codeunit "SEW Calc Phase 4 Tests" = X,
        codeunit "SEW Calc Test Helper" = X,
        codeunit "SEW Test Assert" = X,
        // Table Access - Full RMID permissions needed for test data creation/cleanup
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
        // Standard BC Tables needed for integration tests
        table "Item" = X,
        tabledata "Item" = RMID,
        table "BOM Component" = X,
        tabledata "BOM Component" = RMID,
        table "Routing Header" = X,
        tabledata "Routing Header" = RMID,
        table "Routing Line" = X,
        tabledata "Routing Line" = RMID,
        table "Sales Header" = X,
        tabledata "Sales Header" = RMID,
        table "Sales Line" = X,
        tabledata "Sales Line" = RMID,
        table "Production Order" = X,
        tabledata "Production Order" = RMID;
}
