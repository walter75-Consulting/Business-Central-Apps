page 90702 "SEW Packing Card Dialog Qty"
{
    Caption = 'Capture Item Quantity';
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
                    Caption = 'Current Item';
                    ShowCaption = false;
                    field(Description; DlgItemNo)
                    {
                        Caption = 'Item No.';
                        ToolTip = 'Specifies the item number.';
                        Editable = false;
                    }
                    field(ItemDescription; DlgItemDescription)
                    {
                        Caption = 'Description';
                        ToolTip = 'Specifies the item description.';
                        Editable = false;
                    }
                    field(ItemQty; DlgItemQty)
                    {
                        Caption = 'Qty to Pack';
                        ToolTip = 'Specifies the quantity to pack.';
                        Editable = false;
                    }
                }
            }
            group(CaptureQuantity)
            {
                Caption = 'Capture Quantity';
                ShowCaption = false;
                field(WorklogDateFrom; DlgInputQuantity)
                {
                    Caption = 'Quantity';
                    ToolTip = 'Specifies the quantity.';
                    trigger OnValidate()
                    begin
                        SEWPKSingleInstance.DialogItemQuantitySet(DlgInputQuantity);
                        SEWPKSingleInstance.DialogItemQuantityClose();
                    end;
                }
            }
        }
    }

    procedure SetItemValues(xDlgItemNo: Code[20]; xDlgItemDescription: Text[100]; xDlgItemQty: Decimal)
    begin
        DlgItemNo := xDlgItemNo;
        DlgItemDescription := xDlgItemDescription;
        DlgItemQty := xDlgItemQty;
    end;

    var
        SEWPKSingleInstance: Codeunit "SEW PK Single Instance";
        DlgItemQty: Decimal;
        DlgInputQuantity: Integer;
        DlgItemNo: Code[20];
        DlgItemDescription: Text[100];

}