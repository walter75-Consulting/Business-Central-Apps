permissionset 60500 "SEW XML Fileimport"
{
    Assignable = true;
    Caption = 'XML Fileimport', MaxLength = 30;
    Permissions =
        table "SEW XML Fileimport" = X,
        tabledata "SEW XML Fileimport" = RMID,
        table "SEW XML Fileimport Line" = X,
        tabledata "SEW XML Fileimport Line" = RMID,
        table "SEW XML Fileimport Address" = X,
        tabledata "SEW XML Fileimport Address" = RMID,
        table "SEW XML Fileimport Cost" = X,
        tabledata "SEW XML Fileimport Cost" = RMID,
        page "SEW XML Fileimport XMLBuffer" = X,
        page "SEW XML Fileimport Line" = X,
        page "SEW XML Fileimport Address" = X,
        page "SEW XML Fileimport Cost" = X,
        page "SEW XML Fileimport Card" = X,
        page "SEW XML Fileimport" = X,
        page "SEW XML Fileimport Card Sub" = X,
        //page "SEW API FileTransfer Deliver" = X,
        //page "SEW API FileTransfer Invoice" = X,
        codeunit "SEW XML Fileimport Handl" = X,
        codeunit "SEW XML Fileimport Proc" = X;
}
