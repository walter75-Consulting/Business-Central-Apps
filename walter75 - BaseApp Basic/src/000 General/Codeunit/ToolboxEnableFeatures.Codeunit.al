codeunit 80035 "SEW Toolbox Enable Features"
{
    Permissions = tabledata "SEW Toolbox Setup" = R;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Application Area Mgmt.", OnGetBasicExperienceAppAreas, '', false, false)]
    local procedure EnableModuleOnGetBasicExperienceAppAreas(var TempApplicationAreaSetup: Record "Application Area Setup" temporary)
    begin
        EnableApplicationArea(TempApplicationAreaSetup);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Application Area Mgmt.", OnGetEssentialExperienceAppAreas, '', false, false)]
    local procedure EnableModuleOnGetEssentialExperienceAppAreas(var TempApplicationAreaSetup: Record "Application Area Setup" temporary)
    begin
        EnableApplicationArea(TempApplicationAreaSetup);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Application Area Mgmt.", OnGetPremiumExperienceAppAreas, '', false, false)]
    local procedure EnableOnGetPremiumExperienceAppAreas(var TempApplicationAreaSetup: Record "Application Area Setup" temporary)
    begin
        EnableApplicationArea(TempApplicationAreaSetup);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Application Area Mgmt.", OnValidateApplicationAreas, '', false, false)]
    local procedure VerifyApplicationAreasOnValidateApplicationAreas(ExperienceTierSetup: Record "Experience Tier Setup"; TempApplicationAreaSetup: Record "Application Area Setup" temporary)
    begin
        EnableApplicationArea(TempApplicationAreaSetup);
    end;

    local procedure EnableApplicationArea(var TempApplicationAreaSetup: Record "Application Area Setup" temporary)
    var
        SEWToolboxSetup: Record "SEW Toolbox Setup";
    begin
        if SEWToolboxSetup.Get() then begin
            TempApplicationAreaSetup.SEWCRMFeatures := SEWToolboxSetup.SEWCRMFeatures;
            TempApplicationAreaSetup.SEWFinanceFeatures := SEWToolboxSetup.SEWFinanceFeatures;
            TempApplicationAreaSetup.SEWInventoryFeatures := SEWToolboxSetup.SEWInventoryFeatures;
            TempApplicationAreaSetup.SEWManufacturingFeatures := SEWToolboxSetup.SEWManufacturingFeatures;
            TempApplicationAreaSetup.SEWPurchaseFeatures := SEWToolboxSetup.SEWPurchaseFeatures;
            TempApplicationAreaSetup.SEWSalesFeatures := SEWToolboxSetup.SEWSalesFeatures;
        end;
    end;

    procedure EnableExampleExtension()
    var
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
    begin
        ApplicationAreaMgmtFacade.RefreshExperienceTierCurrentCompany();
    end;
}