codeunit 90701 "SEW PK Auto Jobs"
{
    Description = 'Packages Auto Jobs Codeunit';
    TableNo = "Job Queue Entry";
    Permissions = tabledata "Warehouse Activity Header" = r;

    trigger OnRun()
    var
        WarehouseActivityHeader: Record "Warehouse Activity Header";
        WarehouseDocumentPrint: Codeunit "Warehouse Document-Print";
    begin
        case Rec."Parameter String" of
            'PrintPicklist':
                begin
                    Clear(WarehouseActivityHeader);
                    WarehouseActivityHeader.SetRange("No. Printed", 0);
                    if WarehouseActivityHeader.FindSet() then
                        repeat
                            WarehouseDocumentPrint.PrintInvtPickHeader(WarehouseActivityHeader, false);
                        until WarehouseActivityHeader.Next() = 0;
                end;
        end;
    end;

}