page 95704 "SEW Carrier"
{
    Caption = 'SendCloud Carrier';

    PageType = List;
    ApplicationArea = All;
    UsageCategory = None;

    SourceTable = "SEW Carrier";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                }
                field("Carrier Name"; Rec."Carrier Name")
                {
                }
                field("Nbr of Methods"; Rec."Nbr of Methods")
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ImportFromSendCloud)
            {
                Caption = 'Import from SendCloud';
                ToolTip = 'Imports the Carriers from SendCloud.';
                Image = Refresh;

                trigger OnAction()
                var
                    SEWSCRestRequests: Codeunit "SEW SC Rest Requests";
                begin
                    SEWSCRestRequests.GetSendCloudShippingMethods();
                end;
            }
        }
        area(Navigation)
        {
            action(ShippingMethods)
            {
                Caption = 'Shipping Methods';
                ToolTip = 'Shows the Shipping Methods.';
                Image = List;

                trigger OnAction()
                var
                    SEWCarrierShipMet: Record "SEW Carrier Ship Met";
                begin
                    SEWCarrierShipMet.Reset();
                    SEWCarrierShipMet.SetRange("Carrier Code", Rec.Code);
                    Page.Run(Page::"SEW Carrier Ship Met", SEWCarrierShipMet);
                end;
            }
            action(ShowCarrierFieldCheck)
            {
                Caption = 'Show Carrier Field Check';
                ToolTip = 'Shows the Carrier Field Check.';
                Image = View;

                trigger OnAction()
                var
                    SEWCarrierFieldCheck: Record "SEW Carrier Field Check";
                begin
                    SEWCarrierFieldCheck.Reset();
                    SEWCarrierFieldCheck.SetRange("Carrier Code", Rec.Code);
                    Page.Run(Page::"SEW Carrier Field Check", SEWCarrierFieldCheck);
                end;
            }
        }
        area(Promoted)
        {
            actionref(ImportFromSendCloudPrm; ImportFromSendCloud) { }
            actionref(ShippingMethodsPrm; ShippingMethods) { }
            actionref(ShowCarrierFieldCheckPrm; ShowCarrierFieldCheck) { }
        }
    }
}