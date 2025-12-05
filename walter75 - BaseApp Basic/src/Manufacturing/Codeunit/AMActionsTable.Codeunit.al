codeunit 80007 "SEW AM Actions Table"
{

    Permissions = tabledata "Production BOM Header" = rimd,
                    tabledata "Routing Header" = rimd,
                    tabledata Item = rmd;

    procedure CheckItemBOMHeader(var Item: Record Item): Boolean
    var
        ProductionBOMHeader: Record "Production BOM Header";
    begin
        if not ProductionBOMHeader.Get(Item."No.") then begin
            ProductionBOMHeader.Init();
            ProductionBOMHeader."No." := Item."No.";
            ProductionBOMHeader.Description := Item.Description;
            ProductionBOMHeader."Search Name" := Item.Description;
            ProductionBOMHeader."Unit of Measure Code" := Item."Base Unit of Measure";
            ProductionBOMHeader.Insert(true);
            exit(true);
        end;
        exit(false);
    end;

    procedure CheckItemRoutingHeader(var Item: Record Item): Boolean
    var
        RoutingHeader: Record "Routing Header";
    begin
        if not RoutingHeader.Get(Item."No.") then begin
            RoutingHeader.Init();
            RoutingHeader."No." := Item."No.";
            RoutingHeader.Description := Item.Description;
            RoutingHeader."Search Description" := Item.Description;
            RoutingHeader.Insert(true);
            exit(true);
        end;
        exit(false);
    end;
}