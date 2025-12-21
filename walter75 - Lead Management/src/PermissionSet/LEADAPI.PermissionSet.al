permissionset 91702 "SEW LEAD-API"
{
    Caption = 'Lead API', Locked = true;
    Assignable = true;

    Permissions =
    table "SEW Lead" = X,
    tabledata "SEW Lead" = RIMD,
    table "SEW Lead Source" = X,
    tabledata "SEW Lead Source" = R,
    table "SEW Lost Reason" = X,
    tabledata "SEW Lost Reason" = R,
    table "SEW Lead Status History" = X,
    tabledata "SEW Lead Status History" = RI,
    codeunit "SEW Lead Management" = X,
    codeunit "SEW Lead-Contact Sync" = X,
    codeunit "SEW Deduplication" = X,
    codeunit "SEW Conversion Manager" = X,
    codeunit "SEW Validation Rules" = X;
}
