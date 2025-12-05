codeunit 95701 "SEW SC Auto Jobs"
{
    Description = 'SendCloud Auto Jobs Codeunit';
    TableNo = "Job Queue Entry";

    Permissions = tabledata "Warehouse Activity Header" = r,
                  tabledata "SEW SendCloud Setup" = r;

    trigger OnRun()
    var
        SEWSendCloudSetup: Record "SEW SendCloud Setup";
        SEWSCRestRequests: Codeunit "SEW SC Rest Requests";
    begin
        if SEWSendCloudSetup.Get() then
            if SEWSendCloudSetup."API Public Key" = '' then
                exit;

        case Rec."Parameter String" of
            'ParcelList':
                SEWSCRestRequests.GetPacelList(0DT);
            
            'ParcelListUpdates':
                SEWSCRestRequests.GetPacelList(CurrentDateTime() - (20 * 60 * 1000)); // Last 20 minutes

            'SenderAddressList':
                SEWSCRestRequests.GetSendCloudSenderAddresses();

            'ShippingMethods':
                SEWSCRestRequests.GetSendCloudShippingMethods();





        end;
    end;

}