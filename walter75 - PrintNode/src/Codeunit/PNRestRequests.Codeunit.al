codeunit 92717 "SEW PN Rest Requests"
{
    procedure GetComputers(): Boolean
    var
        HttpResponseMessage: HttpResponseMessage;
        Parameters: Dictionary of [Text, Text];
        result: Text;
        PagingLoop: Boolean;
        JArrayPaging: JsonArray;
        JToken: JsonToken;
        JObject: JsonObject;
        PrintNodeLatestComputerId: Integer;
        JTokenCopy: JsonToken;
        JArrayProcess: JsonArray;
    begin
        Parameters.Add('baseurl', APIBaseUrl());
        Parameters.Add('path', 'computers');
        Parameters.Add('restmethod', 'GET');
        Parameters.Add('username', GetAPIKey());
        Parameters.Add('limit', '100');     // same as default value from PrintNode: 100

        PagingLoop := true;
        while PagingLoop do begin

            SEWPNRestClient.SubmitRESTRequest(Parameters, HttpResponseMessage);
            HttpResponseMessage.Content().ReadAs(result);

            if not TryParseArray(result, JArrayPaging) then
                Error(PrintNodeConnectionErrorLbl, result);

            if (JArrayPaging.Count() > 0) then begin
                JArrayPaging.Get(JArrayPaging.Count() - 1, JToken);
                JObject := JToken.AsObject();
                PrintNodeLatestComputerId := JObject.GetInteger('id');

                foreach JTokenCopy in JArrayPaging do
                    JArrayProcess.Add(JTokenCopy);

                if Parameters.ContainsKey('after') then
                    Parameters.Remove('after');
                Parameters.Add('after', PrintNodeLatestComputerId.ToText());
            end else
                PagingLoop := false;
        end;

        //Process Array is completed in PN Rest JSON Mgmt Codeunit
        SEWPNRestJSONMgmt.ProcessComputersArray(JArrayProcess);
        exit(true);
    end;

    procedure GetPrinters(): Boolean
    var
        HttpResponseMessage: HttpResponseMessage;
        Parameters: Dictionary of [Text, Text];
        result: Text;
        PagingLoop: Boolean;
        JArrayPaging: JsonArray;
        JToken: JsonToken;
        JObject: JsonObject;
        PrintNodeLatestComputerId: Integer;
        JTokenCopy: JsonToken;
        JArrayProcess: JsonArray;
    begin
        Parameters.Add('baseurl', APIBaseUrl());
        Parameters.Add('path', 'printers');
        Parameters.Add('restmethod', 'GET');
        Parameters.Add('username', GetAPIKey());
        Parameters.Add('limit', '100');     // same as default value from PrintNode: 100

        PagingLoop := true;
        while PagingLoop do begin

            SEWPNRestClient.SubmitRESTRequest(Parameters, HttpResponseMessage);
            HttpResponseMessage.Content().ReadAs(result);

            if not TryParseArray(result, JArrayPaging) then
                Error(PrintNodeConnectionErrorLbl, result);

            if (JArrayPaging.Count() > 0) then begin
                JArrayPaging.Get(JArrayPaging.Count() - 1, JToken);
                JObject := JToken.AsObject();
                PrintNodeLatestComputerId := JObject.GetInteger('id');

                foreach JTokenCopy in JArrayPaging do
                    JArrayProcess.Add(JTokenCopy);

                if Parameters.ContainsKey('after') then
                    Parameters.Remove('after');
                Parameters.Add('after', PrintNodeLatestComputerId.ToText());
            end else
                PagingLoop := false;
        end;

        //Process Array is completed in PN Rest JSON Mgmt Codeunit
        SEWPNRestJSONMgmt.ProcessPrintersArray(JArrayProcess);
        exit(true);
    end;

    procedure GetComputerScales(xComputerID: Integer): Boolean
    var
        HttpResponseMessage: HttpResponseMessage;
        Parameters: Dictionary of [Text, Text];
        result: Text;
        JsonArray: JsonArray;
    begin
        Parameters.Add('baseurl', APIBaseUrl());
        Parameters.Add('path', 'computer/' + xComputerID.ToText() + '/scales');
        Parameters.Add('restmethod', 'GET');
        Parameters.Add('username', GetAPIKey());

        SEWPNRestClient.SubmitRESTRequest(Parameters, HttpResponseMessage);
        HttpResponseMessage.Content().ReadAs(result);

        if JsonArray.ReadFrom(result) then
            SEWPNRestJSONMgmt.ProcessComputerScalesArray(JsonArray, xComputerID, false);

        exit(true);
    end;

    procedure ActivateTestScale(): Boolean
    var
        HttpResponseMessage: HttpResponseMessage;
        Parameters: Dictionary of [Text, Text];
        result: Text;
    begin
        Parameters.Add('baseurl', APIBaseUrl());
        Parameters.Add('path', 'scale');
        Parameters.Add('restmethod', 'PUT');
        Parameters.Add('username', GetAPIKey());

        SEWPNRestClient.SubmitRESTRequest(Parameters, HttpResponseMessage);
        HttpResponseMessage.Content().ReadAs(result);

        exit(true);
    end;

    procedure GetScaleValue(xComputerID: Integer; xScaleName: Text[150]): Decimal
    var
        HttpResponseMessage: HttpResponseMessage;
        Parameters: Dictionary of [Text, Text];
        result: Text;
        JsonArray: JsonArray;
        JsonTokenLoop: JsonToken;
        JsonObjectLoop: JsonObject;
        xdec: Decimal;
    begin
        ActivateTestScale();

        Parameters.Add('baseurl', APIBaseUrl());
        Parameters.Add('path', 'computer/' + xComputerID.ToText() + '/scales/' + xScaleName);
        Parameters.Add('restmethod', 'GET');
        Parameters.Add('username', GetAPIKey());

        SEWPNRestClient.SubmitRESTRequest(Parameters, HttpResponseMessage);
        HttpResponseMessage.Content().ReadAs(result);

        JsonArray.ReadFrom(result);
        JsonArray.Get(0, JsonTokenLoop);
        JsonObjectLoop := JsonTokenLoop.AsObject();
        JsonObjectLoop.SelectToken('mass', JsonTokenLoop);

        xdec := JsonTokenLoop.AsArray().GetDecimal(0);
        exit(xdec);
    end;


    procedure NewPrintJob(PrinterId: Integer; InStream: InStream; FileName: Text): Text
    var
        Base64Convert: Codeunit "Base64 Convert";
        lHttpResponseMessage: HttpResponseMessage;
        JObject: JsonObject;
        Parameters: Dictionary of [Text, Text];
        request: Text;
        result: Text;
    begin
        JObject.Add('printerId', Format(PrinterId));
        JObject.Add('title', FileName);
        JObject.Add('contentType', 'pdf_base64');
        JObject.Add('content', Base64Convert.ToBase64(InStream));

        JObject.Add('source', UserId());
        JObject.WriteTo(request);

        Parameters.Add('baseurl', APIBaseUrl());
        Parameters.Add('path', 'printjobs');
        Parameters.Add('restmethod', 'POST');
        Parameters.Add('username', GetAPIKey());
        Parameters.Add('httpcontent', request);

        SEWPNRestClient.SubmitRESTRequest(Parameters, lHttpResponseMessage);

        lHttpResponseMessage.Content().ReadAs(result);

        if not lHttpResponseMessage.IsSuccessStatusCode() then
            Error(PrintNodeConnectionErrorLbl, result);

        exit(result);
    end;

    procedure NewPrintJobRAW(PrinterId: Integer; InStream: InStream; FileName: Text): Text
    var
        Base64Convert: Codeunit "Base64 Convert";
        lHttpResponseMessage: HttpResponseMessage;
        JObject: JsonObject;
        JToken: JsonToken;
        TempText: Text;
        Parameters: Dictionary of [Text, Text];
        request: Text;
        result: Text;
    begin
        JObject.Add('printerId', Format(PrinterId));
        JObject.Add('title', FileName);
        JObject.Add('contentType', 'raw_base64');
        JObject.Add('content', Base64Convert.ToBase64(InStream));
        JObject.Get('content', JToken);
        JToken.WriteTo(TempText);

        JObject.Add('source', UserId());
        JObject.WriteTo(request);

        Parameters.Add('baseurl', APIBaseUrl());
        Parameters.Add('path', 'printjobs');
        Parameters.Add('restmethod', 'POST');
        Parameters.Add('username', GetAPIKey());
        Parameters.Add('httpcontent', request);

        SEWPNRestClient.SubmitRESTRequest(Parameters, lHttpResponseMessage);

        lHttpResponseMessage.Content().ReadAs(result);

        if not lHttpResponseMessage.IsSuccessStatusCode() then
            Error(PrintNodeConnectionErrorLbl, result);

        exit(result);
    end;


    #region "Helpers"

    local procedure APIBaseUrl(): Text
    var
        SEWPrintNodeSetup: Record "SEW PrintNode Setup";
    begin
        if SEWPrintNodeSetup.Get() then
            if SEWPrintNodeSetup."PrintNode Base URL" = '' then
                exit('https://api.printnode.com/')
            else
                exit(SEWPrintNodeSetup."PrintNode Base URL");
    end;

    local procedure GetAPIKey(): Text
    var
        SEWPrintNodeSetup: Record "SEW PrintNode Setup";
    begin
        if not SEWPrintNodeSetup.Get() then
            Error(PrintNodeSetupMissingLbl);
        SEWPrintNodeSetup.TestField("API Key");
        exit(SEWPrintNodeSetup."API Key");
    end;

    [TryFunction]
    procedure TryParseArray(json: Text; var JArray: JsonArray)
    begin
        JArray.ReadFrom(json);
    end;

    #endregion

    var
        SEWPNRestClient: Codeunit "SEW PN Rest Client";
        SEWPNRestJSONMgmt: Codeunit "SEW PN Rest JSON Mgmt";
        PrintNodeConnectionErrorLbl: Label 'Can not connect to PrintNode. Error: %1', Comment = '%1 Explains the Error';
        PrintNodeSetupMissingLbl: Label 'No PrintNode API Key defined. Please setup the PrintNode API Key in the PrintNode Setup.';
}
