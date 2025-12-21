/// <summary>
/// Query SEW Campaign ROI (ID 91764).
/// Analyzes UTM attribution data for marketing campaigns.
/// Tracks lead generation by campaign source.
/// </summary>
query 91764 "SEW Campaign ROI"
{
    Caption = 'Campaign ROI';
    QueryType = Normal;

    elements
    {
        dataitem(UTMAttribution; "SEW UTM Attribution")
        {
            column(UTMCampaign; "UTM Campaign")
            {
                Caption = 'Campaign';
            }
            column(UTMSource; "UTM Source")
            {
                Caption = 'Traffic Source';
            }
            column(UTMMedium; "UTM Medium")
            {
                Caption = 'Medium';
            }
            column(UTMContent; "UTM Content")
            {
                Caption = 'Content';
            }
            column(LeadNo; "Lead No.")
            {
                Caption = 'Lead No.';
            }
        }
    }
}
