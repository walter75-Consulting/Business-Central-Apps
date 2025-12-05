pageextension 80067 "SEW AS Posted Sales Shipment" extends "Posted Sales Shipment"
{


    layout
    {

    }
    actions
    {
        addafter("&Print")
        {
            action("SEW eMail")
            {
                Caption = '&E-Mail';
                ToolTip = 'Send the posted sales shipment as an e-mail.';
                ApplicationArea = All;
                Image = SendMail;
                trigger OnAction()
                var
                    SalesShipmentHeader: Record "Sales Shipment Header";
                begin
                    SalesShipmentHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesShipmentHeader);
                    SalesShipmentHeader.EmailRecords(true);
                end;
            }
        }

        addafter("&Print_Promoted")
        {
            actionref(SEW_eMail; "SEW eMail") { }
        }
    }
}
