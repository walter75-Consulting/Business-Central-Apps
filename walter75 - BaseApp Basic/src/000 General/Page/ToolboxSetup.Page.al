page 80006 "SEW Toolbox Setup"
{
    ApplicationArea = All;
    Caption = 'Toolbox Setup';
    PageType = Card;
    SourceTable = "SEW Toolbox Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Disable / Enable Features';
                group("SEW CRM Features")
                {
                    Caption = 'CRM Features';
                    field(SEWCRMFeatures; Rec.SEWCRMFeatures)
                    {
                        trigger OnValidate()
                        begin
                            RefreshExperienceTier();
                        end;
                    }
                }
                group("SEW Finance Features")
                {
                    Caption = 'Finance Features';
                    field(SEWFinanceFeatures; Rec.SEWFinanceFeatures)
                    {
                        trigger OnValidate()
                        begin
                            RefreshExperienceTier();
                        end;
                    }
                }
                group("SEW Inventory Features")
                {
                    Caption = 'Inventory Features';
                    field(SEWInventoryFeatures; Rec.SEWInventoryFeatures)
                    {
                        trigger OnValidate()
                        begin
                            RefreshExperienceTier();
                        end;
                    }
                }
                group("SEW Manufacturing Features")
                {
                    Caption = 'Manufacturing Features';
                    field(SEWManufacturingFeatures; Rec.SEWManufacturingFeatures)
                    {
                        trigger OnValidate()
                        begin
                            RefreshExperienceTier();
                        end;
                    }
                }
                group("SEW Purchase Features")
                {
                    Caption = 'Purchase Features';
                    field(SEWPurchaseFeatures; Rec.SEWPurchaseFeatures)
                    {
                        trigger OnValidate()
                        begin
                            RefreshExperienceTier();
                        end;
                    }
                }

                group("SEW Sales Features")
                {
                    Caption = 'Sales Features';
                    field(SEWSalesFeatures; Rec.SEWSalesFeatures)
                    {
                        trigger OnValidate()
                        begin
                            RefreshExperienceTier();
                        end;
                    }
                }

            }
        }
    }



    trigger OnOpenPage()
    begin
        Rec.InsertIfNotExists();
    end;

    trigger OnClosePage()

    begin
        RefreshExperienceTier();
    end;

    local procedure RefreshExperienceTier()
    var
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
    begin
        ApplicationAreaMgmtFacade.RefreshExperienceTierCurrentCompany();
    end;

    // var
    //     SEWDimensionManagement: Codeunit "SEW Dimension Management";


}

