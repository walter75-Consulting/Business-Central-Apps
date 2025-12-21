/// <summary>
/// Query SEW Lead Funnel Analysis (ID 91761).
/// Analyzes lead counts and pipeline value by stage.
/// Use for Power BI reports, Excel exports, or funnel visualization.
/// </summary>
query 91761 "SEW Lead Funnel Analysis"
{
    Caption = 'Lead Funnel Analysis';
    QueryType = Normal;

    elements
    {
        dataitem(Lead; "SEW Lead")
        {
            column(StageCode; "Stage Code")
            {
                Caption = 'Stage Code';
            }
            column(LeadNo; "No.")
            {
                Caption = 'Lead No.';
            }
            column(ExpectedRevenue; "Expected Revenue")
            {
                Caption = 'Expected Revenue';
            }
            column(TotalScore; "Score (Total)")
            {
                Caption = 'Total Score';
            }
            column(Status; Status)
            {
                Caption = 'Status';
            }
            filter(StatusFilter; Status)
            {
                Caption = 'Status Filter';
            }
            filter(CreatedDateFilter; SystemCreatedAt)
            {
                Caption = 'Created Date Filter';
            }
        }
    }
}
