codeunit 95707 "SEW SC Rest Requests"
{

    Permissions = tabledata "SEW Parcel" = rmd,
                  tabledata "SEW Parcel Status" = rmi,
                  tabledata "SEW Sender Address" = rmi,
                  tabledata "SEW SendCloud Setup" = r;

    procedure RequestParcelPost(var SEWParcel: Record "SEW Parcel"; withLabelReqeust: Boolean): Boolean
    var
        lHttpResponseMessage: HttpResponseMessage;
        JsonResponse: JsonObject;
        JsonObjectLoop: JsonObject;
        JsonToken: JsonToken;
        Parameters: Dictionary of [Text, Text];
        request: Text;
        result: Text;
    begin
        SEWSCRestJSONMgmt.CreateParcelPostObject(SEWParcel, request, withLabelReqeust);

        Parameters.Add('baseurl', 'https://panel.sendcloud.sc/api/v2/');
        Parameters.Add('path', 'parcels');
        Parameters.Add('restmethod', 'POST');
        Parameters.Add('username', GetAPIKey());
        Parameters.Add('password', GetAPISecretKey());
        Parameters.Add('httpcontent', request);

        SEWSCRestClient.SubmitRESTRequest(Parameters, lHttpResponseMessage);
        lHttpResponseMessage.Content().ReadAs(result);

        if not lHttpResponseMessage.IsSuccessStatusCode() then
            Error(ErrMsgConnectionErrorLbl, result);

        JsonResponse.ReadFrom(result);
        if JsonResponse.Get('parcel', JsonToken) then begin
            JsonObjectLoop := JsonToken.AsObject();
            SEWSCRestJSONMgmt.ProcessParcelObject(JsonObjectLoop);
        end;

        exit(true);

    end;

    procedure RequestParcelCancel(xParcelID: Integer): Boolean
    var
        SEWParcel: Record "SEW Parcel";
        lHttpResponseMessage: HttpResponseMessage;
        Parameters: Dictionary of [Text, Text];
        result: Text;
        ResponseMessage: Text;
    begin
        // JsonObjectParcel.Add('id', xParcelID);
        // JsonObjectParcel.Add('request_label', true);
        // JsonObjectRequest.Add('parcel', JsonObjectParcel);
        // JsonObjectRequest.WriteTo(request);

        Parameters.Add('baseurl', 'https://panel.sendcloud.sc/api/v2/');
        Parameters.Add('path', 'parcels/' + xParcelID.ToText() + '/cancel');
        Parameters.Add('restmethod', 'POST');
        Parameters.Add('username', GetAPIKey());
        Parameters.Add('password', GetAPISecretKey());
        //Parameters.Add('httpcontent', request);

        SEWSCRestClient.SubmitRESTRequest(Parameters, lHttpResponseMessage);
        lHttpResponseMessage.Content().ReadAs(result);

        case lHttpResponseMessage.HttpStatusCode() of
            200:
                begin
                    // The parcel was successfully cancelled.
                    ResponseMessage := 'The parcel was successfully cancelled.';
                    SEWParcel.SetRange("SC ID", xParcelID);
                    if SEWParcel.FindFirst() then
                        SEWParcel.Delete(true);
                    exit(true);

                end;

            202:
                begin
                    // The parcel could not be cancelled because it is already in process.
                    ResponseMessage := 'The parcel could not be cancelled because it is already in process.';
                    SEWParcel.SetRange("SC ID", xParcelID);
                    if SEWParcel.FindFirst() then begin
                        SEWParcel."SC Status ID" := 1999;
                        SEWParcel."SC Parcel Status" := 'Cancellation requested';
                        SEWParcel.Modify(false);
                    end;
                    exit(false);
                end;

            400:
                begin
                    // The parcel could not be cancelled because it has already been shipped.
                    ResponseMessage := 'The parcel could not be cancelled because it has already been shipped.';
                    SEWParcel.SetRange("SC ID", xParcelID);
                    if SEWParcel.FindFirst() then begin
                        SEWParcel."SC Status ID" := 94;
                        SEWParcel."SC Parcel Status" := 'Cancellation failed - already shipped';
                        SEWParcel.Modify(false);
                    end;
                    exit(false);
                end;

            404:
                begin
                    // The parcel could not be found.
                    ResponseMessage := 'The parcel could not be found.';
                    SEWParcel.SetRange("SC ID", xParcelID);
                    if SEWParcel.FindFirst() then
                        SEWParcel.Delete(true);
                    exit(true);
                end;

            410:
                begin
                    // The parcel could not be cancelled because it has already been deleted.
                    ResponseMessage := 'The parcel could not be cancelled because it has already been deleted.';
                    SEWParcel.SetRange("SC ID", xParcelID);
                    if SEWParcel.FindFirst() then
                        SEWParcel.Delete(true);
                    exit(true);
                end;

        end;
    end;

    procedure RequestParcelLabel(xParcelID: Integer)
    var
        lHttpResponseMessage: HttpResponseMessage;
        JsonObjectRequest: JsonObject;
        JsonObjectParcel: JsonObject;
        JsonResponse: JsonObject;
        JsonObjectLoop: JsonObject;
        JsonToken: JsonToken;
        Parameters: Dictionary of [Text, Text];
        request: Text;
        result: Text;
    begin
        JsonObjectParcel.Add('id', xParcelID);
        JsonObjectParcel.Add('request_label', true);
        JsonObjectRequest.Add('parcel', JsonObjectParcel);
        JsonObjectRequest.WriteTo(request);

        Parameters.Add('baseurl', 'https://panel.sendcloud.sc/api/v2/');
        Parameters.Add('path', 'parcels');
        Parameters.Add('restmethod', 'PUT');
        Parameters.Add('username', GetAPIKey());
        Parameters.Add('password', GetAPISecretKey());
        Parameters.Add('httpcontent', request);

        SEWSCRestClient.SubmitRESTRequest(Parameters, lHttpResponseMessage);
        lHttpResponseMessage.Content().ReadAs(result);

        if not lHttpResponseMessage.IsSuccessStatusCode() then
            Error(ErrMsgConnectionErrorLbl, result);

        JsonResponse.ReadFrom(result);
        if JsonResponse.Get('parcel', JsonToken) then begin
            JsonObjectLoop := JsonToken.AsObject();

            SEWSCRestJSONMgmt.ProcessParcelObject(JsonObjectLoop);

        end;

    end;

    procedure GetParcelLabel(var SEWParcel: Record "SEW Parcel"): Boolean
    var
        lHttpResponseMessage: HttpResponseMessage;
        Parameters: Dictionary of [Text, Text];
        InStream: InStream;
        OutStream: OutStream;
        result: Text;
    begin
        Parameters.Add('baseurl', 'https://panel.sendcloud.sc/api/v2/');
        Parameters.Add('path', 'labels/label_printer/' + SEWParcel."SC ID".ToText());
        Parameters.Add('restmethod', 'GET');
        Parameters.Add('username', GetAPIKey());
        Parameters.Add('password', GetAPISecretKey());
        Parameters.Add('accept', 'application/pdf, application/json');
        //Parameters.Add('httpcontent', request);

        SEWSCRestClient.SubmitRESTRequest(Parameters, lHttpResponseMessage);
        lHttpResponseMessage.Content().ReadAs(result);
        lHttpResponseMessage.Content().ReadAs(InStream);

        if not lHttpResponseMessage.IsSuccessStatusCode() then
            Error(ErrMsgConnectionErrorLbl, result);

        // Parcel-Status verarbeiten
        SEWParcel."Label PDF".CreateOutStream(OutStream, TextEncoding::UTF8);
        CopyStream(OutStream, InStream);
        SEWParcel.Modify(false);

        exit(true);
    end;

    procedure GetPacelTracking(xSendCloudTrackingNumber: Text)
    var
        lHttpResponseMessage: HttpResponseMessage;
        Parameters: Dictionary of [Text, Text];
        JsonResponse: JsonObject;
        JsonToken: JsonToken;
        JsonArray: JsonArray;
        JsonTokenLoop: JsonToken;
        JsonObjectLoop: JsonObject;
        result: Text;
        SendCloudParcelID: Integer;
    begin
        Parameters.Add('baseurl', 'https://panel.sendcloud.sc/api/v2/');
        Parameters.Add('path', 'tracking/' + xSendCloudTrackingNumber);
        Parameters.Add('restmethod', 'GET');
        Parameters.Add('username', GetAPIKey());
        Parameters.Add('password', GetAPISecretKey());
        Parameters.Add('accept', 'application/json');
        //Parameters.Add('httpcontent', request);

        SEWSCRestClient.SubmitRESTRequest(Parameters, lHttpResponseMessage);
        lHttpResponseMessage.Content().ReadAs(result);

        if not lHttpResponseMessage.IsSuccessStatusCode() then
            Error(ErrMsgConnectionErrorLbl, result);

        // Parcel-Status verarbeiten
        JsonResponse.ReadFrom(result);
        SendCloudParcelID := JsonResponse.GetInteger('parcel_id', true);

        if JsonResponse.Get('statuses', JsonToken) then begin
            JsonArray := JsonToken.AsArray();

            foreach JsonTokenLoop in JsonArray do begin
                JsonObjectLoop := JsonTokenLoop.AsObject();

                SEWSCRestJSONMgmt.ProcessTrackingObject(JsonObjectLoop, SendCloudParcelID);
            end;

        end;
    end;

    procedure GetPacelList(xLastRun: DateTime)
    var
        lHttpResponseMessage: HttpResponseMessage;
        Parameters: Dictionary of [Text, Text];
        JsonResponse: JsonObject;
        JsonToken: JsonToken;
        JsonArray: JsonArray;
        JsonTokenLoop: JsonToken;
        JsonObjectLoop: JsonObject;
        result: Text;
        PrintNodeConnectionErrorLbl: Label 'Can not connect to SendCloud. Error: %1', Comment = '%1 Explains the Error';
    begin
        Parameters.Add('baseurl', 'https://panel.sendcloud.sc/api/v2/');

        if xLastRun <> 0DT then
            Parameters.Add('path', 'parcels?created_after=' + Format(xLastRun, 0, '<Year>-<Month,2>-<Day,2>T<Hour,2>:<Minute,2>:<Second,2>'))
        else
            Parameters.Add('path', 'parcels');

        Parameters.Add('restmethod', 'GET');
        Parameters.Add('username', GetAPIKey());
        Parameters.Add('password', GetAPISecretKey());
        Parameters.Add('accept', 'application/json');
        //Parameters.Add('httpcontent', request);

        SEWSCRestClient.SubmitRESTRequest(Parameters, lHttpResponseMessage);
        lHttpResponseMessage.Content().ReadAs(result);

        if not lHttpResponseMessage.IsSuccessStatusCode() then
            Error(PrintNodeConnectionErrorLbl, result);

        // Parcel-Status verarbeiten
        JsonResponse.ReadFrom(result);
        if JsonResponse.Get('parcels', JsonToken) then begin
            JsonArray := JsonToken.AsArray();

            foreach JsonTokenLoop in JsonArray do begin
                JsonObjectLoop := JsonTokenLoop.AsObject();

                SEWSCRestJSONMgmt.ProcessParcelObject(JsonObjectLoop);
            end;

        end;
    end;



    procedure GetSendCloudSenderAddresses()
    var
        SEWSenderAddress: Record "SEW Sender Address";
        lHttpResponseMessage: HttpResponseMessage;
        Parameters: Dictionary of [Text, Text];
        JsonResponse: JsonObject;
        JsonToken: JsonToken;
        JsonArray: JsonArray;
        JsonTokenLoop: JsonToken;
        JsonObjectLoop: JsonObject;
        JsonValue: JsonValue;
        addressID: Integer;

        result: Text;
    begin
        Parameters.Add('baseurl', 'https://panel.sendcloud.sc/api/v2/');
        Parameters.Add('path', 'user/addresses/sender');
        Parameters.Add('restmethod', 'GET');
        Parameters.Add('username', GetAPIKey());
        Parameters.Add('password', GetAPISecretKey());
        Parameters.Add('accept', 'application/json');
        //Parameters.Add('httpcontent', request);

        SEWSCRestClient.SubmitRESTRequest(Parameters, lHttpResponseMessage);
        lHttpResponseMessage.Content().ReadAs(result);

        if not lHttpResponseMessage.IsSuccessStatusCode() then
            Error(ErrMsgConnectionErrorLbl, result);

        // Parcel-Status verarbeiten
        JsonResponse.ReadFrom(result);
        if JsonResponse.Get('sender_addresses', JsonToken) then begin
            JsonArray := JsonToken.AsArray();

            foreach JsonTokenLoop in JsonArray do begin
                JsonObjectLoop := JsonTokenLoop.AsObject();

                if JsonObjectLoop.Get('id', JsonTokenLoop) then begin
                    JsonValue := JsonTokenLoop.AsValue();
                    if not JsonValue.IsNull() then
                        addressID := JsonValue.AsInteger();
                end;

                if not SEWSenderAddress.Get(addressID) then begin
                    SEWSenderAddress.Init();
                    SEWSenderAddress.ID := addressID;
                    SEWSenderAddress.Insert(false);
                end;

                if JsonObjectLoop.Get('company_name', JsonTokenLoop) then begin
                    JsonValue := JsonTokenLoop.AsValue();
                    if not JsonValue.IsNull() then
                        SEWSenderAddress."Company Name" := CopyStr(JsonValue.AsText(), 1, MaxStrLen(SEWSenderAddress."Company Name"));
                end;

                if JsonObjectLoop.Get('contact_name', JsonTokenLoop) then begin
                    JsonValue := JsonTokenLoop.AsValue();
                    if not JsonValue.IsNull() then
                        SEWSenderAddress."Contact Name" := CopyStr(JsonValue.AsText(), 1, MaxStrLen(SEWSenderAddress."Contact Name"));
                end;

                if JsonObjectLoop.Get('email', JsonTokenLoop) then begin
                    JsonValue := JsonTokenLoop.AsValue();
                    if not JsonValue.IsNull() then
                        SEWSenderAddress.eMail := CopyStr(JsonValue.AsText(), 1, MaxStrLen(SEWSenderAddress.eMail));
                end;

                if JsonObjectLoop.Get('telephone', JsonTokenLoop) then begin
                    JsonValue := JsonTokenLoop.AsValue();
                    if not JsonValue.IsNull() then
                        SEWSenderAddress.Phone := CopyStr(JsonValue.AsText(), 1, MaxStrLen(SEWSenderAddress.Phone));
                end;

                if JsonObjectLoop.Get('street', JsonTokenLoop) then begin
                    JsonValue := JsonTokenLoop.AsValue();
                    if not JsonValue.IsNull() then
                        SEWSenderAddress.Street := CopyStr(JsonValue.AsText(), 1, MaxStrLen(SEWSenderAddress.Street));
                end;

                if JsonObjectLoop.Get('house_number', JsonTokenLoop) then begin
                    JsonValue := JsonTokenLoop.AsValue();
                    if not JsonValue.IsNull() then
                        SEWSenderAddress."House Nbr" := CopyStr(JsonValue.AsText(), 1, MaxStrLen(SEWSenderAddress."House Nbr"));
                end;

                if JsonObjectLoop.Get('postal_box', JsonTokenLoop) then begin
                    JsonValue := JsonTokenLoop.AsValue();
                    if not JsonValue.IsNull() then
                        SEWSenderAddress."Postal Box" := CopyStr(JsonValue.AsText(), 1, MaxStrLen(SEWSenderAddress."Postal Box"));
                end;

                if JsonObjectLoop.Get('postal_code', JsonTokenLoop) then begin
                    JsonValue := JsonTokenLoop.AsValue();
                    if not JsonValue.IsNull() then
                        SEWSenderAddress."Postal Code" := CopyStr(JsonValue.AsText(), 1, MaxStrLen(SEWSenderAddress."Postal Code"));
                end;

                if JsonObjectLoop.Get('city', JsonTokenLoop) then begin
                    JsonValue := JsonTokenLoop.AsValue();
                    if not JsonValue.IsNull() then
                        SEWSenderAddress.City := CopyStr(JsonValue.AsText(), 1, MaxStrLen(SEWSenderAddress.City));
                end;

                if JsonObjectLoop.Get('country', JsonTokenLoop) then begin
                    JsonValue := JsonTokenLoop.AsValue();
                    if not JsonValue.IsNull() then
                        SEWSenderAddress.Country := CopyStr(JsonValue.AsText(), 1, MaxStrLen(SEWSenderAddress.Country));
                end;

                if JsonObjectLoop.Get('country_state', JsonTokenLoop) then begin
                    JsonValue := JsonTokenLoop.AsValue();
                    if not JsonValue.IsNull() then
                        SEWSenderAddress."Country State" := CopyStr(JsonValue.AsText(), 1, MaxStrLen(SEWSenderAddress."Country State"));
                end;

                if JsonObjectLoop.Get('country', JsonTokenLoop) then begin
                    JsonValue := JsonTokenLoop.AsValue();
                    if not JsonValue.IsNull() then
                        SEWSenderAddress.Country := CopyStr(JsonValue.AsText(), 1, MaxStrLen(SEWSenderAddress.Country));
                end;
                if JsonObjectLoop.Get('vat_number', JsonTokenLoop) then begin
                    JsonValue := JsonTokenLoop.AsValue();
                    if not JsonValue.IsNull() then
                        SEWSenderAddress."VAT Number" := CopyStr(JsonValue.AsText(), 1, MaxStrLen(SEWSenderAddress."VAT Number"));
                end;
                if JsonObjectLoop.Get('eori_number', JsonTokenLoop) then begin
                    JsonValue := JsonTokenLoop.AsValue();
                    if not JsonValue.IsNull() then
                        SEWSenderAddress."EORI Number" := CopyStr(JsonValue.AsText(), 1, MaxStrLen(SEWSenderAddress."EORI Number"));
                end;
                if JsonObjectLoop.Get('brand_id', JsonTokenLoop) then begin
                    JsonValue := JsonTokenLoop.AsValue();
                    if not JsonValue.IsNull() then
                        SEWSenderAddress.brandID := JsonValue.AsInteger();
                end;
                if JsonObjectLoop.Get('label', JsonTokenLoop) then begin
                    JsonValue := JsonTokenLoop.AsValue();
                    if not JsonValue.IsNull() then
                        SEWSenderAddress.Label := CopyStr(JsonValue.AsText(), 1, MaxStrLen(SEWSenderAddress.Label));
                end;
                if JsonObjectLoop.Get('signature_full_name', JsonTokenLoop) then begin
                    JsonValue := JsonTokenLoop.AsValue();
                    if not JsonValue.IsNull() then
                        SEWSenderAddress."Signature full Name" := CopyStr(JsonValue.AsText(), 1, MaxStrLen(SEWSenderAddress."Signature full Name"));
                end;
                if JsonObjectLoop.Get('signature_initials', JsonTokenLoop) then begin
                    JsonValue := JsonTokenLoop.AsValue();
                    if not JsonValue.IsNull() then
                        SEWSenderAddress."Signature Initials" := CopyStr(JsonValue.AsText(), 1, MaxStrLen(SEWSenderAddress."Signature Initials"));
                end;
                SEWSenderAddress.Modify(false);
                Clear(addressID);
                Clear(SEWSenderAddress);

            end;

        end;
    end;

    procedure GetSendCloudParcelStatus()
    var
        SEWParcelStatus: Record "SEW Parcel Status";
        lHttpResponseMessage: HttpResponseMessage;
        Parameters: Dictionary of [Text, Text];
        JsonArray: JsonArray;
        JsonTokenLoop: JsonToken;
        JsonObjectLoop: JsonObject;
        JsonValue: JsonValue;
        statusID: Integer;
        statusMessage: Text;
        //request: Text;
        result: Text;
    begin
        Parameters.Add('baseurl', 'https://panel.sendcloud.sc/api/v2/');
        Parameters.Add('path', 'parcels/statuses');
        Parameters.Add('restmethod', 'GET');
        Parameters.Add('username', GetAPIKey());
        Parameters.Add('password', GetAPISecretKey());
        Parameters.Add('accept', 'application/json');
        //Parameters.Add('httpcontent', request);

        SEWSCRestClient.SubmitRESTRequest(Parameters, lHttpResponseMessage);
        lHttpResponseMessage.Content().ReadAs(result);

        if not lHttpResponseMessage.IsSuccessStatusCode() then
            Error(ErrMsgConnectionErrorLbl, result);

        // Parcel-Status verarbeiten
        JsonArray.ReadFrom(result);

        foreach JsonTokenLoop in JsonArray do begin
            JsonObjectLoop := JsonTokenLoop.AsObject();

            if JsonObjectLoop.Get('id', JsonTokenLoop) then begin
                JsonValue := JsonTokenLoop.AsValue();
                statusID := JsonValue.AsInteger();
            end;

            if JsonObjectLoop.Get('message', JsonTokenLoop) then begin
                JsonValue := JsonTokenLoop.AsValue();
                statusMessage := JsonValue.AsText();
            end;

            if not SEWParcelStatus.Get(statusID) then begin
                SEWParcelStatus.Init();
                SEWParcelStatus."SC Status ID" := statusID;
                SEWParcelStatus.Message := CopyStr(statusMessage, 1, MaxStrLen(SEWParcelStatus.Message));
                SEWParcelStatus.Insert(false);
            end else begin
                SEWParcelStatus.Message := CopyStr(statusMessage, 1, MaxStrLen(SEWParcelStatus.Message));
                SEWParcelStatus.Modify(false);
            end;
            Clear(statusID);
            Clear(statusMessage);
        end;

        if not SEWParcelStatus.Get(0) then begin
            SEWParcelStatus.Init();
            SEWParcelStatus."SC Status ID" := 0;
            SEWParcelStatus.Message := 'Not submitted to SendCloud';
            SEWParcelStatus.Insert(false);
        end;

    end;

    procedure GetSendCloudShippingMethods()
    var
        lHttpResponseMessage: HttpResponseMessage;
        Parameters: Dictionary of [Text, Text];
        result: Text;
    begin
        Parameters.Add('baseurl', 'https://panel.sendcloud.sc/api/v2/');
        Parameters.Add('path', 'shipping_methods');
        Parameters.Add('restmethod', 'GET');
        Parameters.Add('username', GetAPIKey());
        Parameters.Add('password', GetAPISecretKey());
        Parameters.Add('accept', 'application/json');
        //Parameters.Add('httpcontent', request);

        SEWSCRestClient.SubmitRESTRequest(Parameters, lHttpResponseMessage);
        lHttpResponseMessage.Content().ReadAs(result);

        if not lHttpResponseMessage.IsSuccessStatusCode() then
            Error(ErrMsgConnectionErrorLbl, result);

        SEWSCRestJSONMgmt.ProcessShippingProcess(result);

    end;

    local procedure GetAPIKey(): Text
    var
        SEWSendCloudSetup: Record "SEW SendCloud Setup";
    begin
        if SEWSendCloudSetup.Get() then
            exit(SEWSendCloudSetup."API Public Key")
        else
            exit('');
    end;

    local procedure GetAPISecretKey(): Text
    var
        SEWSendCloudSetup: Record "SEW SendCloud Setup";
    begin
        if SEWSendCloudSetup.Get() then
            exit(SEWSendCloudSetup."API Secret Key")
        else
            exit('');
    end;



    var
        SEWSCRestClient: Codeunit "SEW SC Rest Client";
        SEWSCRestJSONMgmt: Codeunit "SEW SC Rest JSON Mgmt";
        ErrMsgConnectionErrorLbl: Label 'Can not connect to SendCloud. Error: %1', Comment = '%1 Explains the Error';

}