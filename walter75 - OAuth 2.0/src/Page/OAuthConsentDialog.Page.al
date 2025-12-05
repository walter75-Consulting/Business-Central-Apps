page 90002 "SEW OAuth Consent Dialog"
{
    Extensible = false;
    Caption = 'Waiting for a response - do not close this page';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    UsageCategory = None;


    layout
    {
        area(Content)
        {
            usercontrol(OAuthIntegration; "SEW OAuth Integration")
            {
                ApplicationArea = All;

                trigger AuthorizationCodeRetrieved(code: Text)
                var
                    StateOut: Text;
                begin
                    this.SEWOAuthAuthorization.GetOAuthProperties(code, this.AuthCode, StateOut);

                    if this.AuthCode = '' then
                        this.AuthCodeError := this.NoAuthCodeErr;

                    if this.State = '' then
                        this.AuthCodeError := this.AuthCodeError + this.NoStateErr
                    else
                        if StateOut <> this.State then
                            this.AuthCodeError := this.AuthCodeError + this.NotMatchingStateErr;


                    CurrPage.Close();
                end;

                trigger AuthorizationErrorOccurred(error: Text; desc: Text)
                begin
                    this.AuthCodeError := StrSubstNo(this.AuthCodeErrorLbl, error, desc);
                    CurrPage.Close();
                end;

                trigger ControlAddInReady()
                begin
                    CurrPage.OAuthIntegration.StartAuthorization(this.OAuthRequestUrl);
                end;
            }
        }
    }

    procedure SetOAuth2CodeFlowGrantProperties(AuthRequestUrl: Text; AuthInitialState: Text)
    begin
        this.OAuthRequestUrl := AuthRequestUrl;
        this.State := AuthInitialState;
    end;

    procedure GetAuthCode(): Text
    begin
        exit(this.AuthCode);
    end;

    procedure GetAuthCodeError(): Text
    begin
        exit(this.AuthCodeError);
    end;

    var
        SEWOAuthAuthorization: Codeunit "SEW OAuth Authorization";
        OAuthRequestUrl: Text;
        State: Text;
        AuthCode: Text;
        AuthCodeError: Text;
        NoAuthCodeErr: Label 'No authorization code has been returned';
        NoStateErr: Label 'No state has been returned';
        NotMatchingStateErr: Label 'The state parameter value does not match.';
        AuthCodeErrorLbl: Label 'Error: %1, description: %2', Comment = '%1 = The authorization error message, %2 = The authorization error description';
}