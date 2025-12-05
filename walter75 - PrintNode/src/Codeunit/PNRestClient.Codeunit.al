

codeunit 92716 "SEW PN Rest Client"
{


    procedure SubmitRESTRequest(var Parameters: Dictionary of [Text, Text]; var pHttpResponseMessage: HttpResponseMessage): Boolean
    var
        Base64Convert: Codeunit "Base64 Convert";
        HttpClient: HttpClient;
        RequestHeader: HttpHeaders;
        HttpContent: HttpContent;
        HttpRequestMessage: HttpRequestMessage;

        AuthText: Text;
        ParameterStringGetMethod: Text;

    begin
        Clear(HttpClient);
        Clear(HttpRequestMessage);

        //Create Webrequest
        HttpRequestMessage.Method := UpperCase(Parameters.Get('restmethod'));

        // parameters for paging
        if Parameters.ContainsKey('limit') then
            ParameterStringGetMethod += '?limit=' + Parameters.Get('limit');
        if Parameters.ContainsKey('after') then
            ParameterStringGetMethod += '&after=' + Parameters.Get('after');

        HttpRequestMessage.SetRequestUri(StrSubstNo('%1%2', Parameters.Get('baseurl'), Parameters.Get('path') + ParameterStringGetMethod));
        HttpRequestMessage.GetHeaders(RequestHeader);


        if Parameters.ContainsKey('accept') then
            RequestHeader.Add('Accept', Format(Parameters.Get('accept')));

        if Parameters.ContainsKey('username') then
            if Parameters.ContainsKey('password') then
                AuthText := StrSubstNo('%1:%2', Parameters.Get('username'), Parameters.Get('password'))
            else
                AuthText := StrSubstNo('%1:%2', Parameters.Get('username'), '');

        RequestHeader.Add('Authorization', SecretStrSubstNo('Basic %1', Base64Convert.ToBase64(AuthText)));

        if Parameters.ContainsKey('etag') then
            RequestHeader.Add('IfMatch', Parameters.Get('etag'));

        //Check Payload
        if Parameters.ContainsKey('httpcontent') then begin
            //Get Request Content
            HttpContent.WriteFrom(Parameters.Get('httpcontent'));

            HttpContent.GetHeaders(RequestHeader);
            RequestHeader.Remove('Content-Type');
            RequestHeader.Add('Content-Type', 'application/json');
            HttpRequestMessage.Content := HttpContent;
        end;

        //Send webservice query
        HttpClient.Send(HttpRequestMessage, pHttpResponseMessage);

        exit(pHttpResponseMessage.IsSuccessStatusCode());
    end;



}
