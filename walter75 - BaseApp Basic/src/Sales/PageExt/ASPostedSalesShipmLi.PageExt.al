pageextension 80068 "SEW AS Posted Sales Shipm Li" extends "Posted Sales Shipments"
{

    layout
    {
        movebefore("Sell-to Customer No."; "Document Date")
        modify("Document Date")
        {
            Visible = true;
        }

        addafter("Document Date")
        {
            field("SEW Order No."; Rec."Order No.")
            {
                ToolTip = 'Specifies the order number associated with the posted sales shipment.';
                ApplicationArea = all;
            }
        }

        modify("Ship-to Name")
        {
            Visible = true;
        }

        addafter("Ship-to Name")
        {
            field("SEW Your Reference"; Rec."Your Reference")
            {
                ToolTip = 'Specifies the customer''s reference for the sales shipment.';
                ApplicationArea = all;
            }
        }

        modify("Salesperson Code")
        {
            Visible = true;
        }



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


    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("No.");
        Rec.Ascending(false);
        if Rec.FindFirst() then; // Positioniere auf den ersten Eintrag
    end;

}
