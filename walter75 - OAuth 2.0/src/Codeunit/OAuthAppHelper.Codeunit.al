codeunit 90000 "SEW OAuth App Helper"
{
    Permissions = tabledata "SEW OAuth Application" = rm;

    var
        SEWOAuthAuthorization: Codeunit "SEW OAuth Authorization";

    /// <summary>
    /// Requests a new access token for the OAuth application or returns existing valid token.
    /// Automatically refreshes expired tokens or acquires new token through full OAuth flow.
    /// Updates the application status and authorization timestamp.
    /// </summary>
    /// <param name="SEWOAuthApplication">VAR: The OAuth application record to authenticate</param>
    /// <param name="MessageTxt">VAR: Output parameter containing error description if request fails</param>
    /// <returns>True if access token is acquired or already valid, false on error</returns>
    /// <example>
    /// var
    ///     OAuthApp: Record "SEW OAuth Application";
    ///     ErrorMsg: Text;
    /// begin
    ///     OAuthApp.Get('MY_APP');
    ///     if RequestAccessToken(OAuthApp, ErrorMsg) then
    ///         Message('Token ready')
    ///     else
    ///         Error(ErrorMsg);
    /// end;
    /// </example>
    procedure RequestAccessToken(var SEWOAuthApplication: Record "SEW OAuth Application"; var MessageTxt: Text): Boolean
    var
        IsSuccess: Boolean;
        JAccessToken: JsonObject;
        ElapsedSecs: Integer;
    begin
        if SEWOAuthApplication.Status = "SEW Auth App Status"::Connected then begin
            ElapsedSecs := Round((CurrentDateTime() - SEWOAuthApplication."Authorization Time") / 1000, 1, '>');
            if ElapsedSecs < SEWOAuthApplication."Expires In" then
                exit(true)
            else
                if RefreshAccessToken(SEWOAuthApplication, MessageTxt) then
                    exit(true);
        end;

        SEWOAuthApplication."Authorization Time" := CurrentDateTime();
        IsSuccess := SEWOAuthAuthorization.AcquireAuthorizationToken(
            SEWOAuthApplication."Grant Type",
            SEWOAuthApplication."User Name",
            SEWOAuthApplication.Password,
            SEWOAuthApplication."Client ID",
            SEWOAuthApplication."Client Secret",
            SEWOAuthApplication."Authorization URL",
            SEWOAuthApplication."Access Token URL",
            SEWOAuthApplication."Redirect URL",
            SEWOAuthApplication."Auth. URL Parms",
            SEWOAuthApplication.Scope,
            JAccessToken);

        if IsSuccess then begin
            ReadTokenJson(SEWOAuthApplication, JAccessToken);
            SEWOAuthApplication.Status := "SEW Auth App Status"::Connected;
        end else begin
            MessageTxt := GetErrorDescription(JAccessToken);
            SEWOAuthApplication.Status := "SEW Auth App Status"::Error;
        end;

        SEWOAuthApplication.Modify(false);
        exit(IsSuccess);
    end;

    /// <summary>
    /// Refreshes an expired access token using the refresh token stored in the OAuth application.
    /// Updates the application with new token data and resets the authorization timestamp.
    /// </summary>
    /// <param name="SEWOAuthApplication">VAR: The OAuth application record to refresh</param>
    /// <param name="MessageTxt">VAR: Output parameter containing error description if refresh fails</param>
    /// <returns>True if token refresh succeeds, false otherwise</returns>
    /// <example>
    /// var
    ///     OAuthApp: Record "SEW OAuth Application";
    ///     ErrorMsg: Text;
    /// begin
    ///     OAuthApp.Get('MY_APP');
    ///     if not RefreshAccessToken(OAuthApp, ErrorMsg) then
    ///         Error('Failed to refresh: %1', ErrorMsg);
    /// end;
    /// </example>
    procedure RefreshAccessToken(var SEWOAuthApplication: Record "SEW OAuth Application"; var MessageTxt: Text): Boolean
    var
        JAccessToken: JsonObject;
        RefreshToken: Text;
        IsSuccess: Boolean;
    begin
        RefreshToken := GetRefreshToken(SEWOAuthApplication);
        if RefreshToken = '' then
            exit;

        SEWOAuthApplication."Authorization Time" := CurrentDateTime();
        IsSuccess := SEWOAuthAuthorization.AcquireTokenByRefreshToken(
            SEWOAuthApplication."Access Token URL",
            SEWOAuthApplication."Client ID",
            SEWOAuthApplication."Client Secret",
            SEWOAuthApplication."Redirect URL",
            RefreshToken,
            JAccessToken);

        if IsSuccess then begin
            ReadTokenJson(SEWOAuthApplication, JAccessToken);
            SEWOAuthApplication.Status := "SEW Auth App Status"::Connected;
        end else begin
            MessageTxt := GetErrorDescription(JAccessToken);
            SEWOAuthApplication.Status := "SEW Auth App Status"::Error;
        end;

        SEWOAuthApplication.Modify(false);
        exit(IsSuccess);
    end;

    /// <summary>
    /// Retrieves the current access token from the OAuth application.
    /// Reads the token from the blob field and returns it as plain text.
    /// </summary>
    /// <param name="SEWOAuthApplication">VAR: The OAuth application record containing the access token</param>
    /// <returns>The access token as text, or empty string if no token exists</returns>
    /// <example>
    /// var
    ///     OAuthApp: Record "SEW OAuth Application";
    ///     Token: Text;
    /// begin
    ///     OAuthApp.Get('MY_APP');
    ///     Token := GetAccessToken(OAuthApp);
    ///     // Use token in API calls
    /// end;
    /// </example>
    procedure GetAccessToken(var SEWOAuthApplication: Record "SEW OAuth Application"): Text
    var
        InStream: InStream;
        Buffer: TextBuilder;
        Line: Text;
    begin
        SEWOAuthApplication.CalcFields("Access Token");
        if SEWOAuthApplication."Access Token".HasValue() then begin
            SEWOAuthApplication."Access Token".CreateInStream(InStream, TextEncoding::UTF8);
            while not InStream.EOS() do begin
                InStream.ReadText(Line, 1024);
                Buffer.Append(Line);
            end;
        end;

        exit(Buffer.ToText())
    end;

    /// <summary>
    /// Retrieves the refresh token from the OAuth application.
    /// Reads the token from the blob field and returns it as plain text for token refresh operations.
    /// </summary>
    /// <param name="SEWOAuthApplication">VAR: The OAuth application record containing the refresh token</param>
    /// <returns>The refresh token as text, or empty string if no refresh token exists</returns>
    /// <example>
    /// var
    ///     OAuthApp: Record "SEW OAuth Application";
    ///     RefreshToken: Text;
    /// begin
    ///     OAuthApp.Get('MY_APP');
    ///     RefreshToken := GetRefreshToken(OAuthApp);
    /// end;
    /// </example>
    procedure GetRefreshToken(var SEWOAuthApplication: Record "SEW OAuth Application"): Text
    var
        InStream: InStream;
        Buffer: TextBuilder;
        Line: Text;
    begin
        SEWOAuthApplication.CalcFields("Refresh Token");
        if SEWOAuthApplication."Refresh Token".HasValue() then begin
            SEWOAuthApplication."Refresh Token".CreateInStream(InStream, TextEncoding::UTF8);
            while not InStream.EOS() do begin
                InStream.ReadText(Line, 1024);
                Buffer.Append(Line);
            end;
        end;

        exit(Buffer.ToText())
    end;

    local procedure GetErrorDescription(JAccessToken: JsonObject): Text
    var
        JToken: JsonToken;
    begin
        if (JAccessToken.Get('error_description', JToken)) then
            exit(JToken.AsValue().AsText());
    end;

    local procedure ReadTokenJson(var SEWOAuthApplication: Record "SEW OAuth Application"; JAccessToken: JsonObject)
    var
        JToken: JsonToken;
        Property: Text;
        OutStream: OutStream;
        ErrorLbl: Label 'Invalid Access Token Property %1, Value:  %2', Comment = '%1 = The property name, %2 = The property value';
    begin
        foreach Property in JAccessToken.Keys() do begin
            JAccessToken.Get(Property, JToken);
            case Property of
                'token_type',
                'scope':
                    ; // do nothing
                'expires_in':
                    SEWOAuthApplication."Expires In" := JToken.AsValue().AsInteger();
                'ext_expires_in':
                    SEWOAuthApplication."Ext. Expires In" := JToken.AsValue().AsInteger();
                'access_token':
                    begin
                        SEWOAuthApplication."Access Token".CreateOutStream(OutStream, TextEncoding::UTF8);
                        OutStream.WriteText(JToken.AsValue().AsText());
                    end;
                'refresh_token':
                    begin
                        SEWOAuthApplication."Refresh Token".CreateOutStream(OutStream, TextEncoding::UTF8);
                        OutStream.WriteText(JToken.AsValue().AsText());
                    end;
                else
                    Error(ErrorLbl, Property, JToken.AsValue().AsText());
            end;
        end;
    end;
}