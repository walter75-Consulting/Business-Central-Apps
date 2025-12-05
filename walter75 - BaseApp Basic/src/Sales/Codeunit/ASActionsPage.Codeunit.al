codeunit 80001 "SEW AS Actions Page"
{
    Permissions = tabledata Item = r,
                    tabledata "Comment Line" = r;



    procedure CheckItemAutoExplodeBOM(ItemNo: Code[20]): Boolean
    var
        Item: Record Item;
    begin
        if Item.Get(ItemNo) then begin
            Item.CalcFields("Assembly BOM");
            if Item."Assembly BOM" then
                if Item."SEW Auto-Explode AssemblyBOM" then
                    exit(true);
        end;
    end;



}