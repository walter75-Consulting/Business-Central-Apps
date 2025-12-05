pageextension 91600 "SEW Item Card" extends "Item Card"
{
    layout
    {
        addafter(InventoryGrp)
        {
            group("SEW Color Master")
            {
                Caption = 'Color Master Management';

                field("SEW Item Color"; Rec."SEW Item Color")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("SEW Item Color Master"; Rec."SEW Item Color Master")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("SEW Item Color Template"; Rec."SEW Item Color Template")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }

    }

    actions
    {
        addafter("Item Tracing")
        {
            group("SEW ColorMasterActions")
            {
                Caption = 'Color Master Management';
                Image = Tools;

                action("SEW Create Color Items")
                {
                    Caption = 'Create Color Items';
                    ToolTip = 'Create Color Items based on the Color Template Item.';
                    Image = Copy;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        SEWCopyItemColorMaster: Codeunit "SEW Copy Item Color Master";
                        ConfirmManagement: Codeunit "Confirm Management";
                        ConfirmLbl: Label 'Create Sub Items from from this Item?';
                        ErrorLbl: Label 'This is not an Color Template Item';
                    begin
                        if Rec."SEW Item Color Template" = false then
                            Error(ErrorLbl);

                        if not ConfirmManagement.GetResponse(ConfirmLbl, true) then
                            exit;

                        SEWCopyItemColorMaster.CheckMasterColorItem(Rec);
                    end;
                }
            }
        }

        addafter(ApplyTemplate_Promoted)
        {
            actionref(SEWCreateColorItems_Promoted; "SEW Create Color Items")
            {
            }
        }
    }

}
