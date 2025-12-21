/// <summary>
/// Query SEW Source Performance (ID 91762).
/// Analyzes lead generation metrics by source.
/// Tracks effectiveness of different lead sources.
/// </summary>
query 91762 "SEW Source Performance"
{
    Caption = 'Source Performance';
    QueryType = Normal;

    elements
    {
        dataitem(Lead; "SEW Lead")
        {
            column(SourceCode; "Source Code")
            {
                Caption = 'Source Code';
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
            column(ScoreBand; "Score Band")
            {
                Caption = 'Score Band';
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
            filter(ScoreBandFilter; "Score Band")
            {
                Caption = 'Score Band Filter';
            }
        }
    }
}
