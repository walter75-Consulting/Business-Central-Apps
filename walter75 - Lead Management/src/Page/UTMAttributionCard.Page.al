page 91725 "SEW UTM Attribution Card"
{
    Caption = 'UTM Attribution';
    PageType = CardPart;
    SourceTable = "SEW UTM Attribution";
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Lead No."; Rec."Lead No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the lead number for this attribution data.';
                }
            }
            group(UTMParameters)
            {
                Caption = 'UTM Parameters';

                field("UTM Source"; Rec."UTM Source")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the referrer (e.g., google, facebook, newsletter).';
                }
                field("UTM Medium"; Rec."UTM Medium")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the marketing medium (e.g., cpc, email, social).';
                }
                field("UTM Campaign"; Rec."UTM Campaign")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the campaign name (e.g., spring-promo-2024).';
                }
                field("UTM Term"; Rec."UTM Term")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the paid search keywords.';
                }
                field("UTM Content"; Rec."UTM Content")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ad variant or content identifier.';
                }
            }
            group(TechnicalDetails)
            {
                Caption = 'Technical Details';

                field("Landing Page URL"; Rec."Landing Page URL")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the page where the lead landed.';
                }
                field("Referrer URL"; Rec."Referrer URL")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the referring page URL.';
                }
                field("IP Address"; Rec."IP Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the IP address of the visitor.';
                }
                field("User Agent"; Rec."User Agent")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the browser user agent string.';
                }
            }
        }
    }
}
