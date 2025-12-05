permissionset 91300 "SEW Contact Relation"
{
    Assignable = true;
    Caption = 'Contact Relation', MaxLength = 30;
    Permissions =
        table "SEW Contact Relation Type" = X,
        table "SEW Contact Relations" = X,
        tabledata "SEW Contact Relation Type" = RMID,
        tabledata "SEW Contact Relations" = RMID,
        page "SEW Contact Relation Type" = X,
        page "SEW Contact Relation" = X,
        page "SEW FB Contact Relation" = X;
}
