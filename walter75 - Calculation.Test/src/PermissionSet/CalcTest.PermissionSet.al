permissionset 90999 "SEW CALC TEST"
{
    Assignable = true;
    Caption = 'SEW Calc Test', MaxLength = 30;

    Permissions =
        codeunit "SEW Calc Formula Parser Test" = X,
        codeunit "SEW Calc Variable Test" = X,
        codeunit "SEW Calc BOM Routing Test" = X,
        codeunit "SEW Calc Template Test" = X,
        codeunit "SEW Calc Engine Test" = X,
        codeunit "SEW Calc Integration Test" = X,
        codeunit "SEW Calc Test Helper" = X,
        codeunit "SEW Test Assert" = X;
}
