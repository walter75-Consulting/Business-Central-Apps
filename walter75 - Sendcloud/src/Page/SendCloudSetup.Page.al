page 95709 "SEW SendCloud Setup"
{
    Caption = 'SendCloud Setup';

    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;

    SourceTable = "SEW SendCloud Setup";
    InsertAllowed = false;
    DeleteAllowed = false;

    Extensible = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Recipient No. Series"; Rec."Recipient No. Series") { }
                field("Parcel No. Series"; Rec."Parcel No. Series") { }
                field("Default SenderID"; Rec."Default SenderID") { }
                field("Default PrintNode PrinterID"; Rec."Default PrintNode PrinterID") { }
            }
            group(API)
            {
                Caption = 'API';
                field("API Public Key"; Rec."API Public Key") { }
                field("API Secret Key"; Rec."API Secret Key") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SendCloudCarriers)
            {
                Caption = 'SendCloud Carriers';
                ToolTip = 'Open SendCloud Carriers page.';
                Image = CreatePutawayPick;
                trigger OnAction()
                begin
                    Page.Run(Page::"SEW Carrier");
                end;
            }
            action(SendCloudParcelStatuses)
            {
                Caption = 'SendCloud Parcel Statuses';
                ToolTip = 'Open SendCloud Parcel Statuses page.';
                Image = CheckList;
                trigger OnAction()
                begin
                    Page.Run(Page::"SEW Parcel Status");
                end;
            }
            action(SendCloudSenders)
            {
                Caption = 'SendCloud Senders';
                ToolTip = 'Open SendCloud Senders page.';
                Image = Addresses;
                trigger OnAction()
                begin
                    Page.Run(Page::"SEW Sender Address");
                end;
            }
        }
        area(Promoted)
        {
            actionref(SendCloudCarriersPrm; SendCloudCarriers) { }
            actionref(SendCloudParcelStatusesPrm; SendCloudParcelStatuses) { }
            actionref(SendCloudSendersPrm; SendCloudSenders) { }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.InsertIfNotExists();
    end;

}
