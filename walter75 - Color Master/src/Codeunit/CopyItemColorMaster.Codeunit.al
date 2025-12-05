codeunit 91600 "SEW Copy Item Color Master"
{
    Permissions = tabledata "SEW Item Colors" = r,
                    tabledata "Item" = rmid,
                    tabledata "Production BOM Header" = rmid,
                    tabledata "Production BOM Line" = rmid,
                    tabledata "Extended Text Header" = rmid,
                    tabledata "Extended Text Line" = rmid,
                    tabledata "Default Dimension" = rmid,
                    tabledata "Price List Line" = rmid;


    //Page Events
    /// <summary>
    /// Checks if the item is a color template and creates color variant items for all defined colors.
    /// For each color in the Item Colors table, creates a new item with the pattern: OriginalItemNo-ColorCode.
    /// Only creates items that don't already exist.
    /// </summary>
    /// <param name="Item">VAR: The template item to check and copy for each color</param>
    /// <example>
    /// var
    ///     TemplateItem: Record Item;
    /// begin
    ///     TemplateItem.Get('TEMPLATE-001');
    ///     CheckMasterColorItem(TemplateItem); // Creates TEMPLATE-001-RED, TEMPLATE-001-BLUE, etc.
    /// end;
    /// </example>
    procedure CheckMasterColorItem(var Item: Record Item)
    var
        SEWItemColors: Record "SEW Item Colors";
        ItemCheck: Record Item;
        TargetItemNo: Code[20];
    begin
        if Item."SEW Item Color Template" = false then begin
            Message('This is not an Color Template Item');
            exit;
        end;
        if SEWItemColors.FindSet() then
            repeat
                Clear(TargetItemNo);
                TargetItemNo := CopyStr(Item."No." + '-' + SEWItemColors.Code, 1, MaxStrLen(TargetItemNo));

                ItemCheck.Reset();
                if not ItemCheck.Get(TargetItemNo) then
                    CopyItem(Item, TargetItemNo, CopyStr(Item.Description + ' - ' + SEWItemColors.Description, 1, MaxStrLen(Item.Description)), SEWItemColors.Code);

            until SEWItemColors.Next() = 0;
    end;


    // Copy Main Prozedur
    // Benutzt die Standard Kopier-Funktion aus der CodeUnit CopyItem
    /// <summary>
    /// Copies an item and creates a new item variant with the specified color code.
    /// Includes copying of units of measure, dimensions, pricing, discounts, translations, extended texts,
    /// vendors, and production BOM if applicable. Updates BOM components to use color-specific items.
    /// </summary>
    /// <param name="SourceItem">VAR: The source item to copy from</param>
    /// <param name="TargetItemNo">The new item number for the color variant</param>
    /// <param name="TargetItemDescription">The description for the new item variant</param>
    /// <param name="TargetColorCode">The color code to assign to the new item</param>
    /// <example>
    /// var
    ///     SourceItem: Record Item;
    /// begin
    ///     SourceItem.Get('TEMPLATE-001');
    ///     CopyItem(SourceItem, 'TEMPLATE-001-RED', 'Template Item - Red', 'RED');
    /// end;
    /// </example>
    procedure CopyItem(var SourceItem: Record Item; TargetItemNo: Code[20]; TargetItemDescription: Text[100]; TargetColorCode: Code[10])
    var
        TargetItem: Record Item;
    begin
        //Parameter setzen
        TempCopyItemBuffer.Init();
        TempCopyItemBuffer."Number of Copies" := 1;
        TempCopyItemBuffer."Source Item No." := SourceItem."No.";
        TempCopyItemBuffer."Target Item No." := TargetItemNo;
        TempCopyItemBuffer."General Item Information" := true;
        TempCopyItemBuffer."Units of Measure" := true;
        TempCopyItemBuffer.Dimensions := true;
        TempCopyItemBuffer."Sales Prices" := true;
        TempCopyItemBuffer."Sales Line Discounts" := true;
        TempCopyItemBuffer."Purchase Prices" := true;
        TempCopyItemBuffer."Purchase Line Discounts" := true;
        TempCopyItemBuffer."Translations" := true;
        TempCopyItemBuffer."Extended Texts" := true;
        TempCopyItemBuffer."Item Vendors" := true;
        TempCopyItemBuffer.Insert(false);

        //Target Item initialisieren
        TargetItem.TransferFields(SourceItem);
        TargetItem."No." := TargetItemNo;
        TargetItem.Description := TargetItemDescription;
        TargetItem."SEW Item Color" := TargetColorCode;
        TargetItem."SEW Item Color Template" := false;
        TargetItem."Last Date Modified" := Today();
        TargetItem."Created From Nonstock Item" := false;
        if TargetItem."Replenishment System" = "Replenishment System"::"Prod. Order" then begin
            CopyItemBOM(SourceItem."No.", TargetItemNo, TargetItemDescription, TargetColorCode);
            TargetItem."Production BOM No." := TargetItemNo;
        end;

        //Kopieren der Daten von Quell-Artikel
        if not (TempCopyItemBuffer."Sales Line Discounts" or TempCopyItemBuffer."Purchase Line Discounts") then
            TargetItem."Item Disc. Group" := '';

        CopyItemPicture(SourceItem, TargetItem);
        CopyItemUnisOfMeasure(SourceItem, TargetItem);
        CopyItemGlobalDimensions(SourceItem, TargetItem);

        TargetItem.Insert(false);

        //Kopieren der Zusatzdaten
        CopyExtendedTexts(SourceItem."No.", TargetItem);
        CopyItemDimensions(SourceItem, TargetItem."No.");
        CopyItemTranslations(SourceItem."No.", TargetItem."No.");
        CopyItemVendors(SourceItem."No.", TargetItem."No.");
        CopyItemPriceListLines(SourceItem."No.", TargetItem."No.");

        //Parameter Puffer leeren für den nächsten Artikel
        TempCopyItemBuffer.DeleteAll(false);
    end;




    local procedure CopyItemBOM(BOMNo: Code[20]; NewBOMNo: Code[20]; TargetItemDescription: Text[100]; TargetColorCode: Code[10])
    var
        ProductionBOMHeader: Record "Production BOM Header";
        ProductionBOMHeaderINS: Record "Production BOM Header";
        ProductionBOMLine: Record "Production BOM Line";
        ProductionBOMCopy: Codeunit "Production BOM-Copy";
        ErrBOMNotFoundLbl: Label 'BOM %1 not found.', Comment = 'BOM %1 not found.';
    begin
        if not ProductionBOMHeader.Get(BOMNo) then
            Error(ErrBOMNotFoundLbl, BOMNo);

        ProductionBOMHeaderINS.Init();
        ProductionBOMHeaderINS.TransferFields(ProductionBOMHeader);
        ProductionBOMHeaderINS."No." := NewBOMNo;
        ProductionBOMHeaderINS.Description := TargetItemDescription;
        ProductionBOMHeaderINS.Insert(true);

        ProductionBOMCopy.CopyBOM(ProductionBOMHeader."No.", '', ProductionBOMHeaderINS, '');

        // Update Color Template Lines
        ProductionBOMLine.Reset();
        ProductionBOMLine.SetRange("Production BOM No.", NewBOMNo);
        ProductionBOMLine.SetRange("SEW Item Color Template", true);
        if ProductionBOMLine.FindSet() then
            repeat
                ProductionBOMLine.Validate("No.", CopyStr(ProductionBOMLine."No." + '-' + TargetColorCode, 1, MaxStrLen(ProductionBOMLine."No.")));
                ProductionBOMLine."SEW Item Color Template" := false;
                ProductionBOMLine.Modify(false)
            until ProductionBOMLine.Next() = 0;
    end;



    local procedure CopyItemPicture(FromItem: Record Item; var ToItem: Record Item)
    begin
        if TempCopyItemBuffer.Picture then
            ToItem.Picture := FromItem.Picture
        else
            Clear(ToItem.Picture);
    end;

    local procedure CopyItemUnisOfMeasure(FromItem: Record Item; var ToItem: Record Item)
    var
        ItemUnitOfMeasure: Record "Item Unit of Measure";
        RecordRef: RecordRef;
    begin
        if TempCopyItemBuffer."Units of Measure" then begin
            ItemUnitOfMeasure.SetRange("Item No.", FromItem."No.");
            RecordRef.GetTable(ItemUnitOfMeasure);
            CopyItemRelatedTableFromRecRef(RecordRef, ItemUnitOfMeasure.FieldNo("Item No."), FromItem."No.", ToItem."No.");
        end else begin
            ToItem."Base Unit of Measure" := '';
            ToItem."Sales Unit of Measure" := '';
            ToItem."Purch. Unit of Measure" := '';
            ToItem."Put-away Unit of Measure Code" := '';
        end;
    end;

    local procedure CopyItemGlobalDimensions(FromItem: Record Item; var ToItem: Record Item)
    begin
        if TempCopyItemBuffer.Dimensions then begin
            ToItem."Global Dimension 1 Code" := FromItem."Global Dimension 1 Code";
            ToItem."Global Dimension 2 Code" := FromItem."Global Dimension 2 Code";
        end else begin
            ToItem."Global Dimension 1 Code" := '';
            ToItem."Global Dimension 2 Code" := '';
        end;
    end;

    local procedure CopyExtendedTexts(FromItemNo: Code[20]; var TargetItem: Record Item)
    var
        ExtendedTextHeader: Record "Extended Text Header";
        ExtendedTextLine: Record "Extended Text Line";
        NewExtendedTextHeader: Record "Extended Text Header";
        NewExtendedTextLine: Record "Extended Text Line";
    begin
        if not TempCopyItemBuffer."Extended Texts" then
            exit;

        ExtendedTextHeader.SetRange("Table Name", ExtendedTextHeader."Table Name"::Item);
        ExtendedTextHeader.SetRange("No.", FromItemNo);
        if ExtendedTextHeader.FindSet() then
            repeat
                ExtendedTextLine.SetRange("Table Name", ExtendedTextHeader."Table Name");
                ExtendedTextLine.SetRange("No.", ExtendedTextHeader."No.");
                ExtendedTextLine.SetRange("Language Code", ExtendedTextHeader."Language Code");
                ExtendedTextLine.SetRange("Text No.", ExtendedTextHeader."Text No.");
                if ExtendedTextLine.FindSet() then
                    repeat
                        NewExtendedTextLine.TransferFields(ExtendedTextLine);
                        NewExtendedTextLine."No." := TargetItem."No.";
                        NewExtendedTextLine.Insert(false);
                    until ExtendedTextLine.Next() = 0;

                NewExtendedTextHeader.TransferFields(ExtendedTextHeader);
                NewExtendedTextHeader."No." := TargetItem."No.";
                NewExtendedTextHeader.Insert(false);
            until ExtendedTextHeader.Next() = 0;


    end;

    local procedure CopyItemDimensions(FromItem: Record Item; ToItemNo: Code[20])
    var
        DefaultDimension: Record "Default Dimension";
        DefaultDimensionNew: Record "Default Dimension";
    begin
        if TempCopyItemBuffer.Dimensions then begin
            DefaultDimension.SetRange("Table ID", Database::Item);
            DefaultDimension.SetRange("No.", FromItem."No.");
            if DefaultDimension.FindSet() then
                repeat
                    DefaultDimensionNew.TransferFields(DefaultDimension);
                    DefaultDimensionNew."No." := ToItemNo;
                    DefaultDimensionNew.Insert(false);
                until DefaultDimension.Next() = 0;
        end;
    end;

    local procedure CopyItemTranslations(FromItemNo: Code[20]; ToItemNo: Code[20])
    var
        ItemTranslation: Record "Item Translation";
        RecordRef: RecordRef;
    begin
        if not TempCopyItemBuffer.Translations then
            exit;

        ItemTranslation.SetRange("Item No.", FromItemNo);
        if not TempCopyItemBuffer."Item Variants" then
            ItemTranslation.SetRange("Variant Code", '');

        RecordRef.GetTable(ItemTranslation);
        CopyItemRelatedTableFromRecRef(RecordRef, ItemTranslation.FieldNo("Item No."), FromItemNo, ToItemNo);
    end;

    local procedure CopyItemVendors(FromItemNo: Code[20]; ToItemNo: Code[20])
    var
        ItemVendor: Record "Item Vendor";
    begin
        if not TempCopyItemBuffer."Item Vendors" then
            exit;

        CopyItemRelatedTable(Database::"Item Vendor", ItemVendor.FieldNo("Item No."), FromItemNo, ToItemNo);
    end;



    local procedure CopyItemPriceListLines(FromItemNo: Code[20]; ToItemNo: Code[20])
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        if TempCopyItemBuffer."Sales Prices" then
            CopyItemPriceListLines(FromItemNo, ToItemNo, Enum::"Price Type"::Sale, Enum::"Price Amount Type"::Price);
        if TempCopyItemBuffer."Sales Line Discounts" then
            CopyItemPriceListLines(FromItemNo, ToItemNo, Enum::"Price Type"::Sale, Enum::"Price Amount Type"::Discount);
        if TempCopyItemBuffer."Sales Prices" or TempCopyItemBuffer."Sales Line Discounts" then
            CopyItemPriceListLines(FromItemNo, ToItemNo, Enum::"Price Type"::Sale, Enum::"Price Amount Type"::Any);

        if TempCopyItemBuffer."Purchase Prices" then
            CopyItemPriceListLines(FromItemNo, ToItemNo, Enum::"Price Type"::Purchase, Enum::"Price Amount Type"::Price);
        if TempCopyItemBuffer."Purchase Line Discounts" then
            CopyItemPriceListLines(FromItemNo, ToItemNo, Enum::"Price Type"::Purchase, Enum::"Price Amount Type"::Discount);
        if TempCopyItemBuffer."Purchase Prices" or TempCopyItemBuffer."Purchase Line Discounts" then
            CopyItemPriceListLines(FromItemNo, ToItemNo, Enum::"Price Type"::Purchase, Enum::"Price Amount Type"::Any);
    end;

    local procedure CopyItemPriceListLines(FromItemNo: Code[20]; ToItemNo: Code[20]; PriceType: Enum "Price Type"; AmountType: Enum "Price Amount Type")
    var
        NewPriceListLine: Record "Price List Line";
        PriceListLine: Record "Price List Line";
    begin
        PriceListLine.SetRange("Price Type", PriceType);
        PriceListLine.SetRange("Amount Type", AmountType);
        PriceListLine.SetRange("Asset Type", PriceListLine."Asset Type"::Item);
        PriceListLine.SetRange("Asset No.", FromItemNo);
        if PriceListLine.FindSet() then
            repeat
                NewPriceListLine := PriceListLine;
                NewPriceListLine.SetAssetNo(ToItemNo);
                NewPriceListLine.SetNextLineNo();
                NewPriceListLine.Insert(false);
            until PriceListLine.Next() = 0;
    end;




    procedure CopyItemRelatedTableFromRecRef(var RecordRefSource: RecordRef; FieldNo: Integer; FromItemNo: Code[20]; ToItemNo: Code[20])
    var
        RecordRefTarget: RecordRef;
        SourceFieldRef: FieldRef;
        TargetFieldRef: FieldRef;
    begin
        SourceFieldRef := RecordRefSource.Field(FieldNo);
        SourceFieldRef.SetRange(FromItemNo);
        if RecordRefSource.FindSet() then
            repeat
                RecordRefTarget := RecordRefSource.Duplicate();
                TargetFieldRef := RecordRefTarget.Field(FieldNo);
                TargetFieldRef.Value(ToItemNo);
                RecordRefTarget.Insert(false);
            until RecordRefSource.Next() = 0;
    end;

    procedure CopyItemRelatedTable(TableId: Integer; FieldNo: Integer; FromItemNo: Code[20]; ToItemNo: Code[20])
    var
        RecordRefSource: RecordRef;
        RecordRefTarget: RecordRef;
        SourceFieldRef: FieldRef;
        TargetFieldRef: FieldRef;
    begin
        RecordRefSource.Open(TableId);
        SourceFieldRef := RecordRefSource.Field(FieldNo);
        SourceFieldRef.SetRange(FromItemNo);
        if RecordRefSource.FindSet() then
            repeat
                RecordRefTarget := RecordRefSource.Duplicate();
                TargetFieldRef := RecordRefTarget.Field(FieldNo);
                TargetFieldRef.Value(ToItemNo);
                RecordRefTarget.Insert(false);
            until RecordRefSource.Next() = 0;
    end;

    var
        TempCopyItemBuffer: Record "Copy Item Buffer" temporary;

}