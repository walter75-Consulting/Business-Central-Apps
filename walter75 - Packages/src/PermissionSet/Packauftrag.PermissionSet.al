permissionset 90700 "SEW Packauftrag"
{
    Caption = 'Packauftrag', MaxLength = 30;
    Assignable = true;
    Permissions =
            table "SEW Parcel" = x,
            table "SEW Package Material" = X,
            table "SEW Package Setup" = X,
            table "SEW Packing Station" = X,
            tabledata "SEW Parcel" = RMID,
            tabledata "SEW Packing Station" = RMID,
            tabledata "SEW Package Setup" = RMID,
            tabledata "SEW Package Material" = RMID,
            page "SEW Packing Station List" = X,
            page "SEW Package Material List" = X,
            page "SEW Package Setup" = X,
            page "SEW Packing Card" = X,
            page "SEW Packing Card Dialog Weight" = X,
            page "SEW Packing Card Dialog Qty" = X,
            page "SEW Packing Card FB Details" = X,
            page "SEW Packing Card FB Parcel" = X,
            codeunit "SEW PK Actions Page" = X,
            codeunit "SEW PK Single Instance" = X,
            codeunit "SEW PK Event Subs" = X,
            codeunit "SEW PK Auto Jobs" = X,
            codeunit "SEW PK Install" = X,
            report "SEW Packing Scan Commands" = X;
}