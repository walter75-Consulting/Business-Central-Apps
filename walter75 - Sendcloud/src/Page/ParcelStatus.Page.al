page 95706 "SEW Parcel Status"
{
    ApplicationArea = All;
    Caption = 'SendCloud Parcel Status';
    PageType = List;
    SourceTable = "SEW Parcel Status";
    UsageCategory = None;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("SC Status ID"; Rec."SC Status ID")
                {
                }
                field("Message"; Rec.Message)
                {
                }
            }
        }
    }


    actions
    {
        area(Processing)
        {
            action(GetParcelStatus)
            {
                Caption = 'Get Parcel Status from SendCloud';
                ToolTip = 'Get the latest Parcel Status from SendCloud.';
                Image = Refresh;
                ApplicationArea = All;

                trigger OnAction()
                var
                    SEWSCRestRequests: Codeunit "SEW SC Rest Requests";
                begin
                    SEWSCRestRequests.GetSendCloudParcelStatus();
                    CurrPage.Update();
                end;
            }
        }

        area(Promoted)
        {
            actionref(GetParcelStatusPrm; GetParcelStatus) { }
        }
    }
}

