permissionset 90999 "SEW CALC TEST"
{
    Assignable = true;
    Caption = 'SEW Calc Test', MaxLength = 30;

    Permissions =
        codeunit "SEW Calc Formula Parser Test" = X,
        codeunit "SEW Calc Test Helper" = X,
        codeunit "SEW Test Assert" = X;
}
