page 90717 "SEW Packing Card Dialog Weight"
{
    Caption = 'Capture Package Weight';
    PageType = StandardDialog;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            grid(ItemGrid)
            {
                group(Item)
                {
                    Caption = 'Current Package';
                    ShowCaption = false;
                    field(CurrentShipmentOrderNo; CurrentShipmentOrderNo)
                    {
                        Caption = 'Current Shipment Order No.';
                        ToolTip = 'Specifies the current shipment order number.';
                        Editable = false;
                    }
                    field(CurrentShipmentOrderStatus; CurrentShipmentOrderStatus)
                    {
                        Caption = 'Current Shipment Order Status';
                        ToolTip = 'Specifies the current shipment order status.';
                        Editable = false;
                    }
                    field(ItemQty; CurrentPackageMaterial)
                    {
                        Caption = 'Current Package Material';
                        ToolTip = 'Specifies the current package material.';
                        Editable = false;
                    }
                }
            }
            group(CaptureWeight)
            {
                Caption = 'Capture Weight';
                ShowCaption = false;
                field(DlgPackageWeight; DlgPackageWeight)
                {
                    Caption = 'Package Weight';
                    ToolTip = 'Specifies the Package Weight.';
                    trigger OnValidate()
                    begin
                        SEWPKSingleInstance.DialogPackageWeightSet(DlgPackageWeight);
                        SEWPKSingleInstance.DialogPackageWeightClose();
                    end;
                }
            }
        }
    }

    procedure SetPackageValues()
    begin
        CurrentShipmentOrderNo := SEWPKSingleInstance.GetCurrentParcelNo();
        CurrentShipmentOrderStatus := SEWPKSingleInstance.GetCurrentParcelStatus();
        CurrentPackageMaterial := SEWPKSingleInstance.GetCurrentPackageMaterial();
    end;

    var
        SEWPKSingleInstance: Codeunit "SEW PK Single Instance";
        CurrentShipmentOrderNo: Code[20];
        CurrentShipmentOrderStatus: Text[250];
        CurrentPackageMaterial: Code[10];
        DlgPackageWeight: Decimal;
}