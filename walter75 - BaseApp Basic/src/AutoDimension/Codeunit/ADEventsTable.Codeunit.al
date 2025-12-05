codeunit 80018 "SEW AD Events Table"
{
    Permissions = tabledata "Customer" = rimd,
                    tabledata "Salesperson/Purchaser" = rimd;


    #region Customer Events
    [EventSubscriber(ObjectType::Table, Database::Customer, OnAfterInsertEvent, '', true, false)]
    local procedure OnAfterInsertCustomer(var Rec: Record Customer; RunTrigger: Boolean)
    var
        SEWDimensionManagement: Codeunit "SEW AD Dimension Mgmt";
    begin
        if Rec.IsTemporary() then
            exit;

        if RunTrigger then begin
            SEWDimensionManagement.CreateDimensionForMasterData(Database::Customer, Rec."No.");
            SEWDimensionManagement.UpdateDimensionValueDescription(Database::Customer, Rec."No.", Rec.Name);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, OnBeforeModifyEvent, '', false, false)]
    local procedure OnBeforeModifyCustomer(var Rec: Record Customer; var xRec: Record Customer; RunTrigger: Boolean)
    begin
        if Rec.IsTemporary() then
            exit;
        if not RunTrigger then
            exit;
        SelectLatestVersion();
        if xRec.Get(Rec."No.") then; // To get the latest version of the record
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, OnAfterModifyEvent, '', true, false)]
    local procedure OnAfterModifyCustomer(var Rec: Record Customer; var xRec: Record Customer; RunTrigger: Boolean)
    var
        SEWDimensionManagement: Codeunit "SEW AD Dimension Mgmt";
    begin
        if Rec.IsTemporary() then
            exit;

        if RunTrigger then
            SEWDimensionManagement.UpdateDimensionValueDescription(Database::Customer, Rec."No.", Rec.Name);
    end;



    [EventSubscriber(ObjectType::Table, Database::Customer, OnAfterDeleteEvent, '', true, false)]
    local procedure OnAfterDeleteCustomer(var Rec: Record Customer; RunTrigger: Boolean)
    var

        SEWDimensionManagement: Codeunit "SEW AD Dimension Mgmt";
    begin
        if Rec.IsTemporary() then
            exit;

        if RunTrigger then
            SEWDimensionManagement.DeleteMasterDataDefaultDimension(Database::Customer, Rec."No.");
    end;

    #endregion

    #region New Salesperson/Purchaser Events

    [EventSubscriber(ObjectType::Table, Database::"Salesperson/Purchaser", OnAfterInsertEvent, '', true, false)]
    local procedure OnAfterInsertSalesperson(var Rec: Record "Salesperson/Purchaser"; RunTrigger: Boolean)
    var
        SEWDimensionManagement: Codeunit "SEW AD Dimension Mgmt";
    begin
        if Rec.IsTemporary() then
            exit;

        if RunTrigger then
            SEWDimensionManagement.CreateDimensionForMasterData(Database::"Salesperson/Purchaser", Rec.Code);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Salesperson/Purchaser", OnBeforeModifyEvent, '', false, false)]
    local procedure OnBeforeModifySalesperson(var Rec: Record "Salesperson/Purchaser"; var xRec: Record "Salesperson/Purchaser"; RunTrigger: Boolean)
    begin
        if Rec.IsTemporary() then
            exit;
        if not RunTrigger then
            exit;
        SelectLatestVersion();
        if xRec.Get(Rec.Code) then; // To get the latest version of the record
    end;

    [EventSubscriber(ObjectType::Table, Database::"Salesperson/Purchaser", OnAfterModifyEvent, '', true, false)]
    local procedure OnAfterModifySalesperson(var Rec: Record "Salesperson/Purchaser"; var xRec: Record "Salesperson/Purchaser"; RunTrigger: Boolean)
    var
        SEWDimensionManagement: Codeunit "SEW AD Dimension Mgmt";
    begin
        if Rec.IsTemporary() then
            exit;

        if RunTrigger then
            SEWDimensionManagement.UpdateDimensionValueDescription(Database::"Salesperson/Purchaser", Rec.Code, Rec.Name);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Salesperson/Purchaser", OnAfterDeleteEvent, '', true, false)]
    local procedure OnAfterDeleteSalesperson(var Rec: Record "Salesperson/Purchaser"; RunTrigger: Boolean)
    var
        SEWDimensionManagement: Codeunit "SEW AD Dimension Mgmt";
    begin
        if Rec.IsTemporary() then
            exit;

        if RunTrigger then
            SEWDimensionManagement.DeleteMasterDataDefaultDimension(Database::"Salesperson/Purchaser", Rec.Code);
    end;
    #endregion


    #region New Item Events
    [EventSubscriber(ObjectType::Table, Database::"Item", OnAfterValidateItemCategoryCode, '', true, true)]
    local procedure OnAfterValidateItemCategoryCode(var Item: Record Item; xItem: Record Item)
    begin

    end;

    #endregion
}