permissionset 92700 "SEW PrintNode"
{
    Assignable = true;
    Caption = 'PrintNode', MaxLength = 30;
    Permissions =
        table "SEW PrintNode Setup" = X,
        tabledata "SEW PrintNode Setup" = RMID,
        table "SEW PrintNode Computer" = X,
        tabledata "SEW PrintNode Computer" = RMID,
        table "SEW PrintNode Printer" = X,
        tabledata "SEW PrintNode Printer" = RMID,
        table "SEW PrintNode Paper Size" = X,
        tabledata "SEW PrintNode Paper Size" = RMID,
        table "SEW PrintNode Scale" = X,
        tabledata "SEW PrintNode Scale" = RMID,
        table "SEW PrintNode Print Setting" = X,
        tabledata "SEW PrintNode Print Setting" = RMID,
        page "SEW PrintNode Setup" = X,
        page "SEW PrintNode Computer List" = X,
        page "SEW PrintNode Printer List" = X,
        page "SEW PrintNode Paper Size" = X,
        page "SEW PrintNode Scales" = X,
        codeunit "SEW PN Install" = X,
        codeunit "SEW PN Event Subs" = X,
        codeunit "SEW PN Rest Requests" = X,
        codeunit "SEW PN Rest Client" = X,
        codeunit "SEW PN Rest JSON Mgmt" = X;
}
