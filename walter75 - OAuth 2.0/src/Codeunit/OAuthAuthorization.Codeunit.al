codeunit 90001 "SEW OAuth Authorization"
{
    var
        DotNetUriBuilder: Codeunit Uri;


    /// <summary>
    /// Acquires an OAuth 2.0 authorization token using the specified grant type and credentials.
    /// Supports Authorization Code and other grant types. Handles the full OAuth flow including
    /// authorization code acquisition when needed.
    /// </summary>
    /// <param name="GrantType">The OAuth 2.0 grant type (e.g., Authorization Code, Client Credentials)</param>
    /// <param name="UserName">Username for resource owner password credentials grant type</param>
    /// <param name="Password">Password for resource owner password credentials grant type</param>
    /// <param name="ClientId">OAuth client identifier from the service provider</param>
    /// <param name="ClientSecret">OAuth client secret from the service provider</param>
    /// <param name="AuthorizationURL">URL for authorization endpoint</param>
    /// <param name="AccessTokenURL">URL for token endpoint</param>
    /// <param name="RedirectURL">Redirect URI registered with the OAuth provider</param>
    /// <param name="AuthURLParms">Additional parameters to append to authorization URL</param>
    /// <param name="Scope">Space-delimited list of OAuth scopes</param>
    /// <param name="JAccessToken">Output JSON object containing the access token and related data</param>
    /// <returns>True if token acquisition succeeds, false otherwise</returns>
    /// <example>
    /// if AcquireAuthorizationToken(GrantType::"Authorization Code", '', '', 'client123', 'secret456', 
    ///    'https://oauth.example.com/authorize', 'https://oauth.example.com/token', 
    ///    'https://myapp.com/callback', '', 'read write', JAccessToken) then
    ///     Message('Token acquired successfully');
    /// </example>
    procedure AcquireAuthorizationToken(
        GrantType: Enum "SEW Auth Grant Type";
        UserName: Text;
        Password: Text;
        ClientId: Text;
        ClientSecret: Text;
        AuthorizationURL: Text;
        AccessTokenURL: Text;
        RedirectURL: Text;
        AuthURLParms: Text;
        Scope: Text;
        JAccessToken: JsonObject): Boolean
    var
        AuthCode: Text;
    begin
        if GrantType = GrantType::"Authorization Code" then begin
            AuthCode := this.AcquireAuthorizationCode(
                ClientId,
                //ClientSecret,
                AuthorizationURL,
                RedirectURL,
                AuthURLParms,
                Scope);

            if AuthCode = '' then
                exit;
        end;

        exit(
            this.AcquireToken(
                GrantType,
                AuthCode,
                UserName,
                Password,
                ClientId,
                ClientSecret,
                Scope,
                RedirectURL,
                AccessTokenURL,
                JAccessToken));
    end;

    local procedure AcquireAuthorizationCode(
        ClientId: Text;
        //ClientSecret: Text;
        AuthorizationURL: Text;
        RedirectURL: Text;
        AuthURLParms: Text;
        Scope: Text): Text
    var
        SEWOAuthConsentDialog: Page "SEW OAuth Consent Dialog";
        State: Text;
        AuthRequestURL: Text;
    begin
        State := Format(CreateGuid(), 0, 4);

        AuthRequestURL := this.GetAuthRequestURL(
            ClientId,
            //ClientSecret,
            AuthorizationURL,
            RedirectURL,
            State,
            Scope,
            AuthURLParms);

        if AuthRequestURL = '' then
            exit;

        SEWOAuthConsentDialog.SetOAuth2CodeFlowGrantProperties(AuthRequestURL, State);
        SEWOAuthConsentDialog.RunModal();

        exit(SEWOAuthConsentDialog.GetAuthCode());
    end;

    local procedure AcquireToken(
        GrantType: Enum "SEW Auth Grant Type";
        AuthorizationCode: Text;
        UserName: Text;
        Password: Text;
        ClientId: Text;
        ClientSecret: Text;
        Scope: Text;
        RedirectURL: Text;
        TokenEndpointURL: Text;
        JAccessToken: JsonObject): Boolean
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpContent: HttpContent;
        ContentHeaders: HttpHeaders;
        ContentText: Text;
        ResponseText: Text;
        IsSuccess: Boolean;
    begin
        case GrantType of
            GrantType::"Authorization Code":
                ContentText := 'grant_type=authorization_code' +
                    '&code=' + AuthorizationCode +
                    '&redirect_uri=' + DotNetUriBuilder.EscapeDataString(RedirectURL) +
                    '&client_id=' + DotNetUriBuilder.EscapeDataString(ClientId) +
                    '&client_secret=' + DotNetUriBuilder.EscapeDataString(ClientSecret);
            GrantType::"Password Credentials":
                ContentText := 'grant_type=password' +
                    '&username=' + DotNetUriBuilder.EscapeDataString(UserName) +
                    '&password=' + DotNetUriBuilder.EscapeDataString(Password) +
                    '&client_id=' + DotNetUriBuilder.EscapeDataString(ClientId) +
                    '&client_secret=' + DotNetUriBuilder.EscapeDataString(ClientSecret) +
                    '&scope=' + DotNetUriBuilder.EscapeDataString(Scope);
            GrantType::"Client Credentials":
                ContentText := 'grant_type=client_credentials' +
                    '&client_id=' + DotNetUriBuilder.EscapeDataString(ClientId) +
                    '&client_secret=' + DotNetUriBuilder.EscapeDataString(ClientSecret) +
                    '&scope=' + DotNetUriBuilder.EscapeDataString(Scope);
        end;
        HttpContent.WriteFrom(ContentText);

        HttpContent.GetHeaders(ContentHeaders);
        ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');

        HttpRequestMessage.Method := 'POST';
        HttpRequestMessage.SetRequestUri(TokenEndpointURL);
        HttpRequestMessage.Content(HttpContent);

        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then
            if HttpResponseMessage.IsSuccessStatusCode() then begin
                if HttpResponseMessage.Content().ReadAs(ResponseText) then
                    IsSuccess := JAccessToken.ReadFrom(ResponseText);
            end else
                if HttpResponseMessage.Content().ReadAs(ResponseText) then
                    JAccessToken.ReadFrom(ResponseText);

        exit(IsSuccess);
    end;


    procedure AcquireTokenByRefreshToken(
        TokenEndpointURL: Text;
        ClientId: Text;
        ClientSecret: Text;
        RedirectURL: Text;
        RefreshToken: Text;
        JAccessToken: JsonObject): Boolean
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpContent: HttpContent;
        ContentHeaders: HttpHeaders;
        ContentText: Text;
        ResponseText: Text;
        IsSuccess: Boolean;
    begin
        ContentText := 'grant_type=refresh_token' +
            '&refresh_token=' + DotNetUriBuilder.EscapeDataString(RefreshToken) +
            '&redirect_uri=' + DotNetUriBuilder.EscapeDataString(RedirectURL) +
            '&client_id=' + DotNetUriBuilder.EscapeDataString(ClientId) +
            '&client_secret=' + DotNetUriBuilder.EscapeDataString(ClientSecret);
        HttpContent.WriteFrom(ContentText);

        HttpContent.GetHeaders(ContentHeaders);
        ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');

        HttpRequestMessage.Method := 'POST';
        HttpRequestMessage.SetRequestUri(TokenEndpointURL);
        HttpRequestMessage.Content(HttpContent);

        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then
            if HttpResponseMessage.IsSuccessStatusCode() then begin
                if HttpResponseMessage.Content().ReadAs(ResponseText) then
                    IsSuccess := JAccessToken.ReadFrom(ResponseText);
            end else
                if HttpResponseMessage.Content().ReadAs(ResponseText) then
                    JAccessToken.ReadFrom(ResponseText);

        exit(IsSuccess);
    end;

    procedure GetOAuthProperties(AuthorizationCode: Text; var CodeOut: Text; var StateOut: Text)
    begin
        if AuthorizationCode = '' then
            exit;

        ReadAuthCodeFromJson(AuthorizationCode);
        CodeOut := this.GetPropertyFromCode(AuthorizationCode, 'code');
        StateOut := this.GetPropertyFromCode(AuthorizationCode, 'state');
    end;

    local procedure GetAuthRequestURL(
        ClientId: Text;
        //ClientSecret: Text;
        AuthRequestURL: Text;
        RedirectURL: Text;
        State: Text;
        Scope: Text;
        AuthURLParms: Text): Text
    begin
        if (ClientId = '') or (RedirectURL = '') or (State = '') then
            exit('');

        AuthRequestURL := AuthRequestURL + '?' +
            'client_id=' + DotNetUriBuilder.EscapeDataString(ClientId) +
            '&redirect_uri=' + DotNetUriBuilder.EscapeDataString(RedirectURL) +
            '&state=' + DotNetUriBuilder.EscapeDataString(State) +
            '&scope=' + DotNetUriBuilder.EscapeDataString(Scope) +
            '&response_type=code';

        if AuthURLParms <> '' then
            AuthRequestURL := AuthRequestURL + '&' + AuthURLParms;

        exit(AuthRequestURL);
    end;

    local procedure ReadAuthCodeFromJson(var AuthorizationCode: Text)
    var
        JObject: JsonObject;
        JToken: JsonToken;
    begin
        if not JObject.ReadFrom(AuthorizationCode) then
            exit;

        if not JObject.Get('code', JToken) then
            exit;

        if not JToken.IsValue() then
            exit;

        if not JToken.WriteTo(AuthorizationCode) then
            exit;

        AuthorizationCode := AuthorizationCode.TrimStart('"').TrimEnd('"');
    end;

    local procedure GetPropertyFromCode(CodeTxt: Text; Property: Text): Text
    var
        PosProperty: Integer;
        PosValue: Integer;
        PosEnd: Integer;
    begin
        PosProperty := StrPos(CodeTxt, Property);
        if PosProperty = 0 then
            exit('');

        PosValue := PosProperty + StrPos(CopyStr(CodeTxt, PosProperty), '=');
        PosEnd := PosValue + StrPos(CopyStr(CodeTxt, PosValue), '&');

        if PosEnd = PosValue then
            exit(CopyStr(CodeTxt, PosValue, StrLen(CodeTxt) - 1));

        exit(CopyStr(CodeTxt, PosValue, PosEnd - PosValue - 1));
    end;
}