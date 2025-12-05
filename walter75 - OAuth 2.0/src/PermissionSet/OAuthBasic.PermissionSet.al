permissionset 90000 "SEW OAuth Basic"
{
    Caption = 'OAuth Basic', MaxLength = 30;
    Assignable = true;
    Permissions =
        table "SEW OAuth Application" = X,
        tabledata "SEW OAuth Application" = RMID,
        page "SEW OAuth Application" = X,
        page "SEW OAuth Applications" = X,
        page "SEW OAuth Consent Dialog" = X,
        codeunit "SEW OAuth Authorization" = X,
        codeunit "SEW OAuth App Helper" = X;

}