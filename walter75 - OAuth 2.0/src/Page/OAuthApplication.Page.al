page 90001 "SEW OAuth Application"
{
    Caption = 'OAuth 2.0 Application';
    LinksAllowed = false;
    ShowFilter = false;
    SourceTable = "SEW OAuth Application";
    UsageCategory = Administration;

    ApplicationArea = All;

    //Editable = false;


    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code"; Rec.Code) { }
                field(Description; Rec.Description) { }
                field("Grant Type"; Rec."Grant Type") { }
            }

            group("oAuth Credentials")
            {
                Caption = 'oAuth Credentials';
                Visible = oAuthFieldVisible;

                field("Client ID"; Rec."Client ID") { }
                field("Client Secret"; Rec."Client Secret") { }
                field("Redirect URL"; Rec."Redirect URL") { }
                field(Scope; Rec.Scope) { }
            }
            group("Password Credentials")
            {
                Caption = 'Password Credentials';
                Visible = Rec."Grant Type" = Rec."Grant Type"::"Password Credentials";

                field("User Name"; Rec."User Name") { }
                field(Password; Rec."Password")
                {

                }
            }
            group("API Key Credentials")
            {
                Caption = 'Password Credentials';
                Visible = Rec."Grant Type" = Rec."Grant Type"::"API Key";

                field("API Key Name"; Rec."API Key Name") { }
                field("API Key Value"; Rec."API Key Value") { }
                field("App API Header"; Rec."App API Header") { }
            }
            group(Endpoints)
            {
                Caption = 'Endpoints';

                field("Authorization URL"; Rec."Authorization URL") { }
                field("Access Token URL"; Rec."Access Token URL") { }
                field("Auth. URL Parms"; Rec."Auth. URL Parms") { }
                field("App API URL"; Rec."App API URL") { }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RequestAccessToken)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Request Access Token';
                Image = EncryptionKeys;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Open the service authorization web page. Login credentials will be prompted. The authorization code must be copied into the Enter Authorization Code field.';

                trigger OnAction()
                var
                    MessageTxt: Text;
                    ErrorMsgLbl: Label 'Error occurred for Message: %1', Comment = '%1 = Message text';
                begin
                    if not SEWOAuthAppHelper.RequestAccessToken(Rec, MessageTxt) then begin
                        Commit(); // save new "Status" value
                        Error(ErrorMsgLbl, MessageTxt);
                    end else
                        Message(SuccessfulMsg);
                end;
            }
            action(RefreshAccessToken)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Refresh Access Token';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Refresh the access and refresh tokens.';

                trigger OnAction()
                var
                    MessageText: Text;
                    ErrorMsgLbl: Label 'Error occurred for Message: %1', Comment = '%1 = Message text';
                begin
                    if SEWOAuthAppHelper.GetRefreshToken(Rec) = '' then
                        Error(NoRefreshTokenErr);

                    if not SEWOAuthAppHelper.RefreshAccessToken(Rec, MessageText) then begin
                        Commit(); // save new "Status" value
                        Error(ErrorMsgLbl, MessageText);
                    end else
                        Message(SuccessfulMsg);
                end;
            }
        }
    }


    trigger OnOpenPage()
    begin

        case Rec."Grant Type" of
            Rec."Grant Type"::"API Key":
                SetFieldsVisible(false);
            Rec."Grant Type"::"Password Credentials":
                SetFieldsVisible(false);
            Rec."Grant Type"::"Authorization Code":
                SetFieldsVisible(true);
            Rec."Grant Type"::"Client Credentials":
                SetFieldsVisible(true);
        end;

    end;

    local procedure SetFieldsVisible(xoAuthFieldVisible: Boolean)
    begin
        oAuthFieldVisible := xoAuthFieldVisible;

    end;


    var
        SEWOAuthAppHelper: Codeunit "SEW OAuth App Helper";
        SuccessfulMsg: Label 'Access Token updated successfully.';
        NoRefreshTokenErr: Label 'No Refresh Token avaiable';
        oAuthFieldVisible: Boolean;

}

