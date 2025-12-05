pageextension 90707 "SEW Inventory Picks" extends "Inventory Picks"
{
    layout
    {

    }


    actions
    {
        addafter("Assign to me")
        {
            action("SEW Print")
            {

                Caption = 'Print';
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
                Image = Print;
                ApplicationArea = Warehouse;

                trigger OnAction()
                var
                    WarehouseDocumentPrint: Codeunit "Warehouse Document-Print";
                begin
                    WarehouseDocumentPrint.PrintInvtPickHeader(Rec, false);
                end;
            }
        }
        addafter("Assign to me_Promoted")
        {
            actionref("SEW Print_Promoted"; "SEW Print")
            {
            }
        }
    }
}