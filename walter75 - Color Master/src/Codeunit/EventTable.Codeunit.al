codeunit 91602 "SEW Event Table"
{
    Permissions = tabledata "Production BOM Line" = rimd,
                    tabledata Item = rimd,
                    tabledata "Production BOM Header" = rimd,
                    tabledata "Routing Header" = rimd;

    // Table Production BOM Line
    procedure ItemColorTemplateOnValidate(var ProductionBOMLine: Record "Production BOM Line")
    var
        Item: Record Item;
    begin
        if ProductionBOMLine."SEW Item Color Template" then begin
            if not Item.Get(ProductionBOMLine."No.") then
                Error(ErrItemNotFoundLbl, ProductionBOMLine."No.");

            if not Item."SEW Item Color Template" then begin
                ProductionBOMLine."SEW Item Color Template" := false;
                Error(ErrItemNotColorTemplateLbl, ProductionBOMLine."No.");
            end;
        end;
    end;

    //Table Item
    procedure ReplenishmentSystemOnAfterValidate(var Item: Record Item)
    var
        SEWProductionBOMHeader: Record "Production BOM Header";
        SEWRoutingHeader: Record "Routing Header";
    begin
        case Item."Replenishment System" of
            "Replenishment System"::"Prod. Order":
                begin
                    if not SEWProductionBOMHeader.Get(Item."No.") then begin
                        SEWProductionBOMHeader.Init();
                        SEWProductionBOMHeader."No." := Item."No.";
                        SEWProductionBOMHeader.Description := Item.Description;
                        SEWProductionBOMHeader."Search Name" := Item.Description;
                        SEWProductionBOMHeader."Unit of Measure Code" := Item."Base Unit of Measure";
                        SEWProductionBOMHeader.Insert(true);
                    end;

                    if not SEWRoutingHeader.Get(Item."No.") then begin
                        SEWRoutingHeader.Init();
                        SEWRoutingHeader."No." := Item."No.";
                        SEWRoutingHeader.Description := Item.Description;
                        SEWRoutingHeader."Search Description" := Item.Description;
                        SEWRoutingHeader.Insert(true);
                    end;

                    Item."Production BOM No." := Item."No.";
                    Item."Routing No." := Item."No.";

                end;
        end;
    end;

    var
        ErrItemNotFoundLbl: Label 'Item %1 not found.', Comment = 'Error message when the item %1 is not found.';
        ErrItemNotColorTemplateLbl: Label 'Item %1 is not a Color Template Item.', Comment = 'Error message when the item %1 is not a color template.';
}