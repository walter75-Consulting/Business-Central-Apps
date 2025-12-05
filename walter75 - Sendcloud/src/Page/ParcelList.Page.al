page 95710 "SEW Parcel List"
{
    ApplicationArea = All;
    Caption = 'SendCloud Parcel List';
    PageType = List;
    CardPageId = "SEW Parcel Card";
    SourceTable = "SEW Parcel";
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    Permissions = tabledata "SEW SendCloud Setup" = r;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Parcel No."; Rec."Parcel No.")
                {
                    DrillDown = true;
                }
                field("Source Type"; Rec."Source Type") { }
                field("Source Type Sub"; Rec."Source Type Sub") { }
                field("Source No."; Rec."Source No.") { }
                field("SC ID"; Rec."SC ID") { }
                field("SC Status ID"; Rec."SC Status ID")
                {
                    Visible = false;
                }
                field("SC Parcel Status"; Rec."SC Parcel Status") { }
                field("SC Tracking Number"; Rec."SC Tracking Number") { }
                field("SC Parcel Tracking Activities"; Rec."SC Parcel Tracking Activities") { }
                field("SC Tracking URL"; Rec."SC Tracking URL") { }
                field("Ship-to Name 1"; Rec."Ship-to Name 1") { }
                field("Ship-to Name 2"; Rec."Ship-to Name 2") { }
                field("Ship-to Address 1"; Rec."Ship-to Address 1") { }
                field("Ship-to Address 2"; Rec."Ship-to Address 2") { }
                field("Ship-to House Nbr."; Rec."Ship-to House Nbr.") { }
                field("Ship-to Country"; Rec."Ship-to Country Code") { }
                field("Ship-to Post Code"; Rec."Ship-to Post Code") { }
                field("Ship-to City"; Rec."Ship-to City") { }
                field("Ship-to County"; Rec."Ship-to County") { }
                field("Ship-to Email"; Rec."Ship-to Email") { }
                field("Ship-to Phone"; Rec."Ship-to Phone") { }

                field("Shipping Agent Code"; Rec."Shipping Agent Code") { }
                field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code") { }
                field("Your Reference"; Rec."Your Reference") { }
                field("SC Order Nbr."; Rec."SC Order Nbr.") { }
                field("Parcel Weight"; Rec."Parcel Weight") { }

                field("SC sender ID"; Rec."SC Sender ID") { }
                field("Sender Name1"; Rec."Sender Name 1") { }
                field("Sender Name2"; Rec."Sender Name 2") { }
                field("Sender Address1"; Rec."Sender Address 1") { }
                field("Sender Address2"; Rec."Sender Address 2") { }
                field("Sender Country Code"; Rec."Sender Country Code") { }
                field("Sender PostCode"; Rec."Sender Post Code") { }
                field("Sender City"; Rec."Sender City") { }
                field("Sender County"; Rec."Sender County") { }
                field("Sender Email"; Rec."Sender Email") { }
                field("Sender Phone"; Rec."Sender Phone") { }

                field("Parcel Length"; Rec."Parcel Length") { }
                field("Parcel Width"; Rec."Parcel Width") { }
                field("Parcel Height"; Rec."Parcel Height") { }
                field("Label URL"; Rec."SC Label URL") { }
                field("SC Date announced"; Rec."SC Date announced") { }
                field("SC Date created"; Rec."SC Date created") { }
                field("SC Date Updated"; Rec."SC Date Updated") { }
                field("SC Note"; Rec."SC Note") { }
                field("SC Shipment uuid"; Rec."SC Shipment uuid") { }
                field("SC External Order Id"; Rec."SC External Order Id") { }
                field("SC External Shipment Id"; Rec."SC External Shipment Id") { }
                field("SC Colli uuid"; Rec."SC Colli uuid") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RefreshList)
            {
                Caption = 'Refresh List';
                ToolTip = 'Refresh the list of parcels from Sendcloud.';
                Image = Refresh;
                trigger OnAction()
                var
                    SEWSCRestRequests: Codeunit "SEW SC Rest Requests";
                begin
                    SEWSCRestRequests.GetPacelList(0DT);
                end;
            }
            action(UpdateParcelTracking)
            {
                Caption = 'Update Tracking';
                ToolTip = 'Update the tracking information for the selected parcel from Sendcloud.';
                Image = View;
                trigger OnAction()
                var
                    SEWSCRestRequests: Codeunit "SEW SC Rest Requests";
                    ErrMsgParcelLbl: Label 'No parcel selected.';
                begin
                    if Rec."SC Tracking Number" = '' then
                        Error(ErrMsgParcelLbl);
                    SEWSCRestRequests.GetPacelTracking(Rec."SC Tracking Number");
                end;
            }
            action(NewParcel)
            {
                Caption = 'New Parcel';
                ToolTip = 'Create a new parcel.';
                Image = New;
                RunObject = page "SEW Parcel Card";
                RunPageMode = Create;
            }
            action(ParcelSubmit)
            {
                Caption = 'Submit Parcel';
                ToolTip = 'Submit the parcel to Sendcloud.';
                Image = SendElectronicDocument;
                trigger OnAction()
                var
                    SEWSCRestRequests: Codeunit "SEW SC Rest Requests";
                begin
                    SEWSCRestRequests.RequestParcelPost(Rec, true);
                end;
            }
            action(ParcelGetLabel)
            {
                Caption = 'Get Label';
                ToolTip = 'Get the parcel label from Sendcloud.';
                Image = Insert;
                trigger OnAction()
                var
                    SEWSCRestRequests: Codeunit "SEW SC Rest Requests";
                begin
                    SEWSCRestRequests.GetParcelLabel(Rec);
                end;
            }
            action(PrintLabel)
            {
                Caption = 'Print Label';
                ToolTip = 'Print the parcel label.';
                Image = Print;
                trigger OnAction()
                var
                    SEWSendCloudSetup: Record "SEW SendCloud Setup";
                    SEWPNRestRequests: Codeunit "SEW PN Rest Requests";
                    InStream: InStream;
                    FileName: Text;
                begin
                    if SEWSendCloudSetup.Get() then begin
                        Rec.CalcFields("Label PDF");
                        if Rec."Label PDF".HasValue() then begin
                            Rec."Label PDF".CreateInStream(InStream);
                            FileName := 'Label_' + Rec."Parcel No." + '.pdf';
                            SEWPNRestRequests.NewPrintJob(SEWSendCloudSetup."Default PrintNode PrinterID", InStream, FileName);
                        end;
                    end;
                end;
            }
            action(downloadLabel)
            {
                Caption = 'Download Label';
                ToolTip = 'Download the parcel label from Sendcloud.';
                Image = Download;
                trigger OnAction()
                var
                    InStream: InStream;
                    FileName: Text;
                    ErrMsgNoLabelAvailableLbl: Label 'No Label available. Please create the parcel and get the label first.';
                begin
                    Rec.CalcFields(Rec."Label PDF");
                    if Rec."Label PDF".HasValue() then begin
                        Rec."Label PDF".CreateInStream(InStream);
                        FileName := 'Label_' + Rec."Parcel No." + '.pdf';
                        DownloadFromStream(InStream, 'Download File', '', '*.*', FileName);
                    end else
                        Message(ErrMsgNoLabelAvailableLbl);
                end;
            }
            action(ParcelCancel)
            {
                Caption = 'Cancel Parcel';
                ToolTip = 'Cancel the selected parcel in Sendcloud.';
                Image = Delete;
                trigger OnAction()
                begin
                    Rec.TryParcelCancel();
                end;
            }
            action(DeleteAllParcels)
            {
                Caption = 'Delete All Parcels';
                ToolTip = 'Delete all parcels from the list.';
                Image = Delete;
                trigger OnAction()
                var
                    SEWParcel: Record "SEW Parcel";
                begin
                    SEWParcel.Reset();
                    if SEWParcel.FindSet() then
                        repeat
                            SEWParcel.Delete();
                        until SEWParcel.Next() = 0;
                end;
            }
        }

        area(Promoted)
        {
            actionref(RefreshListPrm; RefreshList) { }
            actionref(UpdateParcelTrackingPrm; UpdateParcelTracking) { }
            actionref(NewParcelPrm; NewParcel) { }
            actionref(ParcelSubmitPrm; ParcelSubmit) { }
            actionref(ParcelGetLabelPrm; ParcelGetLabel) { }
            actionref(downloadLabelPrm; downloadLabel) { }
            actionref(PrintLabelPrm; PrintLabel) { }
            actionref(ParcelCancelPrm; ParcelCancel) { }
        }
    }

}

