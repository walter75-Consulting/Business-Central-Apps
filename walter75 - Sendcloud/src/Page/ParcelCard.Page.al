page 95711 "SEW Parcel Card"
{
    ApplicationArea = All;
    Caption = 'SendCloud Parcel';
    PageType = Card;
    SourceTable = "SEW Parcel";
    UsageCategory = None;
    InsertAllowed = true;
    ModifyAllowed = true;
    DeleteAllowed = false;

    Permissions = tabledata "SEW SendCloud Setup" = r;

    layout
    {
        area(Content)
        {
            group(ParcelSourceInformation)
            {
                Caption = 'Source Information';
                grid(MyGrid)
                {
                    ShowCaption = false;
                    group(SourceType)
                    {
                        Caption = 'Source Information';
                        field("Source Type"; Rec."Source Type")
                        {
                            trigger OnValidate()
                            begin
                                Rec.InitRecord();
                                Clear(Rec."Source Type Sub");
                                Clear(Rec."Source No.");
                                UpdateVisibility();
                            end;
                        }
                        group("Sub Contact")
                        {
                            Visible = VisibilityContact;
                            ShowCaption = false;
                            field("Source Type Sub Contact"; Rec."Source Type Sub")
                            {
                                ValuesAllowed = 0, 101;
                                trigger OnValidate()
                                begin
                                    Clear(Rec."Source No. Sub");
                                    UpdateSourceSubNoVisibility();
                                end;
                            }

                        }
                        group("Sub Customer")
                        {
                            Visible = VisibilityCustomer;
                            ShowCaption = false;
                            field("Source Type Sub Customer"; Rec."Source Type Sub")
                            {
                                ValuesAllowed = 0, 201, 202, 203, 204, 205, 206, 207, 208, 209, 220, 221, 230, 231, 240, 241, 242, 243, 246, 248, 249;
                                trigger OnValidate()
                                begin
                                    Clear(Rec."Source No. Sub");
                                    UpdateSourceSubNoVisibility();
                                end;
                            }
                        }
                        group("Sub Vendor")
                        {
                            Visible = VisibilityVendor;
                            ShowCaption = false;
                            field("Source Type Sub Vendor"; Rec."Source Type Sub")
                            {
                                ValuesAllowed = 0, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 320;
                                trigger OnValidate()
                                begin
                                    Clear(Rec."Source No. Sub");
                                    UpdateSourceSubNoVisibility();
                                end;
                            }
                        }
                        group("Sub Warehouse")
                        {
                            Visible = VisibilityWarehouse;
                            ShowCaption = false;
                            field("Source Type Sub Warehouse"; Rec."Source Type Sub")
                            {
                                ValuesAllowed = 401, 402, 403, 404, 405, 406, 407, 408;
                                trigger OnValidate()
                                begin
                                    Clear(Rec."Source No. Sub");
                                    UpdateSourceSubNoVisibility();
                                end;
                            }
                        }
                        group("Sub other")
                        {
                            Visible = VisibilityOther;
                            ShowCaption = false;
                            field("Source Type Sub other"; Rec."Source Type Sub")
                            {
                                ValuesAllowed = 501, 502, 503;
                                trigger OnValidate()
                                begin
                                    Clear(Rec."Source No. Sub");
                                    UpdateSourceSubNoVisibility();
                                end;
                            }
                        }
                    }
                    group(SourceNo)
                    {
                        Caption = 'Source No.';
                        field("Source No."; Rec."Source No.")
                        {
                        }
                        group(SourceSubNo)
                        {
                            Visible = VisibilitySourceSubNo;
                            ShowCaption = false;
                            field("Source No. Sub"; Rec."Source No. Sub")
                            {
                            }
                        }
                    }
                }

            }
            group(AddressInformation)
            {
                Caption = 'Address Information';
                grid(AddressGrid)
                {
                    ShowCaption = false;
                    group(AddressReceiver)
                    {
                        Caption = 'Receiver Address';

                        field(FieldPlaceholder1; FieldPlaceholder)
                        {
                            Caption = 'Field Placeholder';
                            ToolTip = 'Specifies a placeholder field to force the group AddressReceiver to be shown when it is empty.';
                            ShowCaption = false;
                            Editable = false;
                        }
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
                    }


                    group(AddressSender)
                    {
                        Caption = 'Sender Address';
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
                    }
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping Information';

                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                }
                field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
                {
                }
                field("Your Reference"; Rec."Your Reference")
                {
                }
                field("SC Order Nbr."; Rec."SC Order Nbr.")
                {
                }
            }
            group(Parcel)
            {
                Caption = 'Parcel Information';

                field("Parcel Weight"; Rec."Parcel Weight")
                {
                }
                field("Parcel Length"; Rec."Parcel Length")
                {
                }
                field("Parcel Width"; Rec."Parcel Width")
                {
                }
                field("Parcel Height"; Rec."Parcel Height")
                {
                }
            }
            group(ID)
            {
                Caption = 'ID';


                field("Parcel No."; Rec."Parcel No.")
                {
                }
            }
            group(SendCloudResponseInformation)
            {
                Caption = 'SendCloud Data';

                field("SC ID"; Rec."SC ID")
                {
                    Editable = false;
                }
                field("SC Status ID"; Rec."SC Status ID")
                {
                    Editable = false;
                }
                field("SC Tracking Number"; Rec."SC Tracking Number")
                {
                    Editable = false;
                }
                field("SC Note"; Rec."SC Note")
                {
                    Editable = false;
                }
                field("SC Shipment uuid"; Rec."SC Shipment uuid")
                {
                    Editable = false;
                }
                field("SC External Order Id"; Rec."SC External Order Id")
                {
                    Editable = false;
                }
                field("SC External Shipment Id"; Rec."SC External Shipment Id")
                {
                    Editable = false;
                }
                field("SC Colli uuid"; Rec."SC Colli uuid")
                {
                    Editable = false;
                }

            }

        }
    }

    actions
    {
        area(Processing)
        {
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
        }

        area(Promoted)
        {
            actionref(ParcelSubmitPrm; ParcelSubmit) { }
            actionref(ParcelGetLabelPrm; ParcelGetLabel) { }
            actionref(downloadLabelPrm; downloadLabel) { }
            actionref(PrintLabelPrm; PrintLabel) { }
            actionref(ParcelCancelPrm; ParcelCancel) { }
            actionref(UpdateParcelTrackingPrm; UpdateParcelTracking) { }
        }
    }




    var
        VisibilityContact: Boolean;
        VisibilityCustomer: Boolean;
        VisibilityVendor: Boolean;
        VisibilityWarehouse: Boolean;
        VisibilityOther: Boolean;
        VisibilitySourceSubNo: Boolean;
        FieldPlaceholder: Text[1];

    trigger OnOpenPage()
    begin
        InitVisibility();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        UpdateSourceSubNoVisibility();
        //CurrPage.Update(false);
    end;

    procedure InitVisibility()
    begin
        VisibilityContact := false;
        VisibilityCustomer := false;
        VisibilityVendor := false;
        VisibilityWarehouse := false;
        VisibilityOther := false;
        VisibilitySourceSubNo := false;
    end;

    procedure UpdateVisibility()
    begin
        InitVisibility();
        case Rec."Source Type" of

            Rec."Source Type"::Contact:
                VisibilityContact := true;

            Rec."Source Type"::Customer:
                VisibilityCustomer := true;

            Rec."Source Type"::Vendor:
                VisibilityVendor := true;

            Rec."Source Type"::Warehouse:
                VisibilityWarehouse := true;

            Rec."Source Type"::Other:
                VisibilityOther := true;
        end;
    end;

    procedure UpdateSourceSubNoVisibility()
    begin
        InitVisibility();
        UpdateVisibility(); // Ensure main visibility is set

        case Rec."Source Type Sub" of

            Rec."Source Type Sub"::"Contact Alt. Address",
            Rec."Source Type Sub"::"Customer Ship-to",
            Rec."Source Type Sub"::"Vendor Order Address",
            Rec."Source Type Sub"::"Vendor Remit Address":
                VisibilitySourceSubNo := true;

            else
                VisibilitySourceSubNo := false;
        end;
    end;
}
