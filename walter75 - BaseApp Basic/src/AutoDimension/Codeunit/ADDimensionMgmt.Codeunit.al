codeunit 80017 "SEW AD Dimension Mgmt"
{
    Permissions = tabledata "Default Dimension" = rimd,
                    tabledata "Dimension Value" = rimd,
                    tabledata "SEW Auto Dimension Setup" = rmid,
                    tabledata "Default Dimension Priority" = rmid,
                    tabledata "Dimension Set Entry" = rmid;

    local procedure GetDimensionCodeFromSetup(TableNo: Integer) DimensionCode: Code[20]
    var
        SEWAutoDimensionSetup: Record "SEW Auto Dimension Setup";
    begin
        SEWAutoDimensionSetup.Get();

        case TableNo of
            Database::Customer:
                DimensionCode := SEWAutoDimensionSetup."Customer Dimension";
            Database::"Salesperson/Purchaser":
                DimensionCode := SEWAutoDimensionSetup."Salesperson Dimension";
            Database::"Item":
                DimensionCode := SEWAutoDimensionSetup."Item Dimension";
            Database::"Territory":
                DimensionCode := SEWAutoDimensionSetup."Territory Dimension";
            Database::"Item Category":
                DimensionCode := SEWAutoDimensionSetup."Item Category Dimension";
            Database::Campaign:
                DimensionCode := SEWAutoDimensionSetup."Campaign Dimension";
            else
                OnGetDimensionForMasterData(TableNo, DimensionCode);
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGetDimensionForMasterData(TableNo: Integer; var DimensionCode: Code[20])
    begin
    end; //NOTE: Also subscribe to OnUpdateAllDimensionValueDescriptions when adding new Tables with dimensions

    procedure CreateDimensionForMasterData(TableNoMasterData: Integer; CurrentKeyValue: Code[20])
    var
        DimensionValue: Record "Dimension Value";
        DefaultDimension: Record "Default Dimension";
        DimensionCode: Code[20];
        DimensionValueCode: Code[20];
    begin
        DimensionValueCode := CurrentKeyValue;
        DimensionCode := GetDimensionCodeFromSetup(TableNoMasterData);

        DefaultDimension.SetRange("Table ID", TableNoMasterData);
        DefaultDimension.SetRange("No.", CurrentKeyValue);
        DefaultDimension.SetRange("Dimension Code", DimensionCode);
        if not DefaultDimension.IsEmpty() then
            exit;

        if (DimensionCode <> '') and (DimensionValueCode <> '') then begin
            DimensionValue.Init();
            DimensionValue."Dimension Code" := DimensionCode;
            DimensionValue.Code := DimensionValueCode;
            DimensionValue.Name := DimensionValueCode;
            if DimensionValue.Insert(true) then; //???

            DefaultDimension.Reset();
            DefaultDimension.Init();
            DefaultDimension."Table ID" := TableNoMasterData;
            DefaultDimension."No." := CurrentKeyValue;
            DefaultDimension."Dimension Code" := DimensionCode;
            DefaultDimension."Dimension Value Code" := DimensionValueCode;
            if DefaultDimension.Insert(true) then; //???
        end;
    end;

    procedure CreateAndUpdateAllDefaultDimensions()
    var
        Customer: Record Customer;
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        Item: Record "Item";
        Territory: Record "Territory";
        ItemCategory: Record "Item Category";
        Campaign: Record Campaign;
        TempAllObjWithCaption: Record AllObjWithCaption temporary;
        Dimensionmanagement: Codeunit DimensionManagement;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        Dimensionmanagement.DefaultDimObjectNoWithGlobalDimsList(TempAllObjWithCaption);
        if TempAllObjWithCaption.FindSet() then
            repeat
                if TempAllObjWithCaption."Object Type" = TempAllObjWithCaption."Object Type"::Table then begin
                    Clear(RecordRef);
                    RecordRef.Open(TempAllObjWithCaption."Object ID");
                    if RecordRef.FindSet() then
                        repeat
                            FieldRef := RecordRef.KeyIndex(1).FieldIndex(1);
                            if StrLen(Format(FieldRef.Value())) <= 20 then
                                CreateDimensionForMasterData(TempAllObjWithCaption."Object ID", CopyStr(Format(FieldRef.Value()), 1, 20));
                        until RecordRef.Next() = 0;

                    case RecordRef.Number() of
                        Database::Customer:
                            if RecordRef.FindSet() then
                                repeat
                                    RecordRef.SetTable(Customer);
                                    UpdateDimensionValueDescription(Database::Customer, Customer."No.", Customer.Name);
                                until RecordRef.Next() = 0;
                        Database::"Salesperson/Purchaser":
                            if RecordRef.FindSet() then
                                repeat
                                    RecordRef.SetTable(SalespersonPurchaser);
                                    UpdateDimensionValueDescription(Database::"Salesperson/Purchaser", SalespersonPurchaser.Code, SalespersonPurchaser.Name);
                                until RecordRef.Next() = 0;
                        Database::"Item":
                            if RecordRef.FindSet() then
                                repeat
                                    RecordRef.SetTable(Item);
                                    UpdateDimensionValueDescription(Database::"Item", Item."No.", Item.Description);
                                until RecordRef.Next() = 0;
                        Database::"Territory":
                            if RecordRef.FindSet() then
                                repeat
                                    RecordRef.SetTable(Territory);
                                    UpdateDimensionValueDescription(Database::"Territory", Territory.Code, Territory.Name);
                                until RecordRef.Next() = 0;
                        Database::"Item Category":
                            if RecordRef.FindSet() then
                                repeat
                                    RecordRef.SetTable(ItemCategory);
                                    UpdateDimensionValueDescription(Database::"Item Category", ItemCategory.Code, ItemCategory.Description);
                                until RecordRef.Next() = 0;
                        Database::Campaign:
                            if RecordRef.FindSet() then
                                repeat
                                    RecordRef.SetTable(Campaign);
                                    UpdateDimensionValueDescription(Database::Campaign, Campaign."No.", Campaign.Description);
                                until RecordRef.Next() = 0;
                        else
                            OnUpdateAllDimensionValueDescriptions(RecordRef.Number());
                    end;
                end;
            until TempAllObjWithCaption.Next() = 0;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdateAllDimensionValueDescriptions(TableNo: Integer)
    begin
    end;

    procedure UpdateDimensionValueDescription(TableNo: Integer; DimensionValueCode: Code[20]; Description: Text)
    var
        //SEWAutoDimensionSetup: Record "SEW Auto Dimension Setup";
        DimensionValue: Record "Dimension Value";
        DimensionCode: Code[20];
    begin
        DimensionCode := GetDimensionCodeFromSetup(TableNo);

        if DimensionValue.Get(DimensionCode, DimensionValueCode) then begin
            // if TableNo = Database::"DSZ Employee" then begin
            //     SEWAutoDimensionSetup.Get();
            //     if SEWAutoDimensionSetup."Employee Dim. without Name" then
            //         Description := DimensionValueCode;
            // end;

            if Description = '' then
                Description := DimensionValueCode;

            DimensionValue.Validate(Name, CopyStr(Description, 1, MaxStrLen(DimensionValue.Name)));
            DimensionValue.Modify(true);
        end;
    end;

    procedure DeleteMasterDataDefaultDimension(TableNo: Integer; CurrentCode: Code[20])
    var
        DefaultDimension: Record "Default Dimension";
        DimensionValue: Record "Dimension Value";
        DimCode: Code[20];
    begin
        DimCode := GetDimensionCodeFromSetup(TableNo);
        if DimensionValue.Get(DimCode, CurrentCode) then
            if not DimensionValue.CheckIfDimValueUsed() then
                DimensionValue.Delete(true);


        DefaultDimension.Reset();
        DefaultDimension.SetRange("Table ID", TableNo);
        DefaultDimension.SetRange("No.", CurrentCode);
        DefaultDimension.DeleteAll(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::DimensionManagement, OnAfterSetupObjectNoList, '', true, false)]
    local procedure CU408_OnAfterSetupObjectNoList(var TempAllObjWithCaption: Record AllObjWithCaption temporary)
    var
        RecRef: RecordRef;
        TableIdList: List of [Integer];
        TableId: Integer;
    begin
        TableIdList.Add(Database::"Territory");
        TableIdList.Add(Database::"Item Category");

        foreach TableId in TableIdList do begin
            RecRef.Open(TableId);

            TempAllObjWithCaption.Init();
            TempAllObjWithCaption."Object Type" := TempAllObjWithCaption."Object Type"::Table;
            TempAllObjWithCaption."Object ID" := RecRef.Number();
            TempAllObjWithCaption."Object Caption" := CopyStr(RecRef.Caption(), 1, MaxStrLen(TempAllObjWithCaption."Object Caption"));
            TempAllObjWithCaption.Insert(false);

            RecRef.Close();
        end;
    end;

    procedure GetDefaultDimID(DefaultDimensionSource: Dictionary of [Integer, Code[20]]; SourceCode: Code[10]): Integer
    var
        NewDimSetID: Integer;
    begin
        NewDimSetID := GetDefaultDimID(DefaultDimensionSource, SourceCode, 0, 0);
        exit(NewDimSetID);
    end;

    procedure GetDefaultDimID(DefaultDimensionSource: Dictionary of [Integer, Code[20]]; SourceCode: Code[10]; InheritFromDimSetID: Integer; InheritFromTableNo: Integer): Integer
    var
        TempDimensionBuffer: Record "Dimension Buffer" temporary;
    begin
        exit(this.GetDefaultDimID(DefaultDimensionSource, SourceCode, InheritFromDimSetID, InheritFromTableNo, TempDimensionBuffer));
    end;

    procedure GetDefaultDimID(DefaultDimensionSource: Dictionary of [Integer, Code[20]]; SourceCode: Code[10]; InheritFromDimSetID: Integer; InheritFromTableNo: Integer; var TempDimensionBuffer: Record "Dimension Buffer" temporary): Integer
    var
        DimensionValue: Record "Dimension Value";
        DefaultDimensionPriority1: Record "Default Dimension Priority";
        DefaultDimensionPriority2: Record "Default Dimension Priority";
        DefaultDimension: Record "Default Dimension";
        TempDimensionSetEntry: Record "Dimension Set Entry" temporary;
        TempDimensionSetEntryFirst: Record "Dimension Set Entry" temporary;
        Dimensionmanagement: Codeunit DimensionManagement;
        NewDimSetID: Integer;
        DimSourceTable: Integer;
        DimSourceValue: Code[20];
    begin
        if InheritFromDimSetID > 0 then
            GetDimensionSet(TempDimensionSetEntryFirst, InheritFromDimSetID);
        if TempDimensionSetEntryFirst.FindSet() then
            repeat
                TempDimensionBuffer.Init();
                TempDimensionBuffer."Table ID" := InheritFromTableNo;
                TempDimensionBuffer."Entry No." := 0;
                TempDimensionBuffer."Dimension Code" := TempDimensionSetEntryFirst."Dimension Code";
                TempDimensionBuffer."Dimension Value Code" := TempDimensionSetEntryFirst."Dimension Value Code";
                TempDimensionBuffer.Insert(false);
            until TempDimensionSetEntryFirst.Next() = 0;

        foreach DimSourceTable in DefaultDimensionSource.Keys() do begin
            DimSourceValue := DefaultDimensionSource.Get(DimSourceTable);
            if (DimSourceTable <> 0) and (DimSourceValue <> '') then begin
                DefaultDimension.SetRange("Table ID", DimSourceTable);
                DefaultDimension.SetRange("No.", DimSourceValue);
                if DefaultDimension.FindSet() then
                    repeat
                        if DefaultDimension."Dimension Value Code" <> '' then begin
                            TempDimensionBuffer.SetRange("Dimension Code", DefaultDimension."Dimension Code");
                            if not TempDimensionBuffer.FindFirst() then begin
                                TempDimensionBuffer.Init();
                                TempDimensionBuffer."Table ID" := DefaultDimension."Table ID";
                                TempDimensionBuffer."Entry No." := 0;
                                TempDimensionBuffer."Dimension Code" := DefaultDimension."Dimension Code";
                                TempDimensionBuffer."Dimension Value Code" := DefaultDimension."Dimension Value Code";
                                TempDimensionBuffer.Insert(false);
                            end else
                                if DefaultDimensionPriority1.Get(SourceCode, DefaultDimension."Table ID") then
                                    if DefaultDimensionPriority2.Get(SourceCode, TempDimensionBuffer."Table ID") then begin
                                        if DefaultDimensionPriority1.Priority < DefaultDimensionPriority2.Priority then begin
                                            TempDimensionBuffer.Delete(false);
                                            TempDimensionBuffer."Table ID" := DefaultDimension."Table ID";
                                            TempDimensionBuffer."Entry No." := 0;
                                            TempDimensionBuffer."Dimension Value Code" := DefaultDimension."Dimension Value Code";
                                            TempDimensionBuffer.Insert(false);
                                        end;
                                    end else begin
                                        TempDimensionBuffer.Delete(false);
                                        TempDimensionBuffer."Table ID" := DefaultDimension."Table ID";
                                        TempDimensionBuffer."Entry No." := 0;
                                        TempDimensionBuffer."Dimension Value Code" := DefaultDimension."Dimension Value Code";
                                        TempDimensionBuffer.Insert(false);
                                    end;
                        end;
                    until DefaultDimension.Next() = 0;
            end;
        end;

        TempDimensionBuffer.Reset();
        if TempDimensionBuffer.FindSet() then begin
            repeat
                DimensionValue.Get(TempDimensionBuffer."Dimension Code", TempDimensionBuffer."Dimension Value Code");
                TempDimensionSetEntry."Dimension Code" := TempDimensionBuffer."Dimension Code";
                TempDimensionSetEntry."Dimension Value Code" := TempDimensionBuffer."Dimension Value Code";
                TempDimensionSetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
                TempDimensionSetEntry.Insert(false);
            until TempDimensionBuffer.Next() = 0;

            OnBeforeGetDimensionSetID(TempDimensionSetEntry);

            NewDimSetID := Dimensionmanagement.GetDimensionSetID(TempDimensionSetEntry);
        end;

        exit(NewDimSetID);
    end;

    procedure GetRecDefaultDimID(RecVariant: Variant; DefaultDimensionSource: Dictionary of [Integer, Code[20]]; SourceCode: Code[10]): Integer
    var
        DefaultDimID: Integer;
    begin
        DefaultDimID := GetDefaultDimID(DefaultDimensionSource, SourceCode);
        exit(DefaultDimID);
    end;

    procedure GetRecDefaultDimID(RecVariant: Variant; DefaultDimensionSource: Dictionary of [Integer, Code[20]]; SourceCode: Code[10]; InheritFromDimSetID: Integer; InheritFromTableNo: Integer): Integer
    var
        DefaultDimID: Integer;
    begin
        DefaultDimID := GetDefaultDimID(DefaultDimensionSource, SourceCode, InheritFromDimSetID, InheritFromTableNo);
        exit(DefaultDimID);
    end;

    #region EventSubscriber für Global Dimension Change
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Change Global Dimensions", OnChangeDimsOnRecord, '', true, false)]
    local procedure OnChangeDimsOnRecord(var RecRef: RecordRef; var IsHandled: Boolean)
    begin
        //Unsere Dimensionen haben keine Globale 1 & 2 Felder
        if RecRef.Number() in [
            Database::"Territory",
            Database::"Item Category"
        ] then
            IsHandled := true;
    end;
    #endregion

    #region Ableiten von anderem Dimension Set
    local procedure GetDimensionSet(var TempDimensionSetEntry: Record "Dimension Set Entry" temporary; DimSetID: Integer)
    var
        DimensionSetEntry: Record "Dimension Set Entry";
    begin
        TempDimensionSetEntry.DeleteAll(false);

        DimensionSetEntry.SetRange("Dimension Set ID", DimSetID);
        if DimensionSetEntry.FindSet() then
            repeat
                TempDimensionSetEntry := DimensionSetEntry;
                TempDimensionSetEntry.Insert(false);
            until DimensionSetEntry.Next() = 0;
    end;
    #endregion

    procedure JoinDimensionSets(PrimaryDimSet: Integer; SecondaryDimSet: Integer) ResultDimSet: Integer
    var
        DimensionValue: Record "Dimension Value";
        TempDimensionBuffer: Record "Dimension Buffer" temporary;
        TempPrimaryDimensionSetEntrys: Record "Dimension Set Entry" temporary;
        TempSecondaryDimensionSetEntrys: Record "Dimension Set Entry" temporary;
        TempNewDimensionSetEntrys: Record "Dimension Set Entry" temporary;
        Dimensionmanagement: Codeunit DimensionManagement;
    begin
        Dimensionmanagement.GetDimensionSet(TempPrimaryDimensionSetEntrys, PrimaryDimSet);
        if TempPrimaryDimensionSetEntrys.FindSet() then
            repeat
                TempDimensionBuffer.Init();
                TempDimensionBuffer."Entry No." := 0;
                TempDimensionBuffer."Dimension Code" := TempPrimaryDimensionSetEntrys."Dimension Code";
                TempDimensionBuffer."Dimension Value Code" := TempPrimaryDimensionSetEntrys."Dimension Value Code";
                TempDimensionBuffer.Insert(false);
            until TempPrimaryDimensionSetEntrys.Next() = 0;

        Dimensionmanagement.GetDimensionSet(TempSecondaryDimensionSetEntrys, SecondaryDimSet);
        if TempSecondaryDimensionSetEntrys.FindSet() then
            repeat
                TempDimensionBuffer.Reset();
                TempDimensionBuffer.SetRange("Dimension Code", TempSecondaryDimensionSetEntrys."Dimension Code");
                if TempDimensionBuffer.IsEmpty() then begin
                    TempDimensionBuffer.Init();
                    TempDimensionBuffer."Entry No." := 0;
                    TempDimensionBuffer."Dimension Code" := TempSecondaryDimensionSetEntrys."Dimension Code";
                    TempDimensionBuffer."Dimension Value Code" := TempSecondaryDimensionSetEntrys."Dimension Value Code";
                    TempDimensionBuffer.Insert(false);
                end;
            until TempSecondaryDimensionSetEntrys.Next() = 0;

        TempDimensionBuffer.Reset();
        if TempDimensionBuffer.FindSet() then begin
            repeat
                DimensionValue.Get(TempDimensionBuffer."Dimension Code", TempDimensionBuffer."Dimension Value Code");
                TempNewDimensionSetEntrys."Dimension Code" := TempDimensionBuffer."Dimension Code";
                TempNewDimensionSetEntrys."Dimension Value Code" := TempDimensionBuffer."Dimension Value Code";
                TempNewDimensionSetEntrys."Dimension Value ID" := DimensionValue."Dimension Value ID";
                TempNewDimensionSetEntrys.Insert(false);
            until TempDimensionBuffer.Next() = 0;
            ResultDimSet := Dimensionmanagement.GetDimensionSetID(TempNewDimensionSetEntrys);
        end;
        exit(ResultDimSet);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetDimensionSetID(var TempDimensionSetEntry: Record "Dimension Set Entry" temporary)
    begin
    end;
}