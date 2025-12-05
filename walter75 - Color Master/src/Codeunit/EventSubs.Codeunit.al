codeunit 91601 "SEW PK Event Subs"
{
    [EventSubscriber(ObjectType::Table, Database::"Production BOM Line", OnValidateNoOnAfterAssignItemFields, '', false, false)]
    local procedure OnValidateNoOnAfterAssignItemFields(var ProductionBOMLine: Record "Production BOM Line"; Item: Record Item; var xProductionBOMLine: Record "Production BOM Line"; CallingFieldNo: Integer)
    begin
        if Item."SEW Item Color Template" then
            ProductionBOMLine."SEW Item Color Template" := true
        else
            ProductionBOMLine."SEW Item Color Template" := false;
    end;

}