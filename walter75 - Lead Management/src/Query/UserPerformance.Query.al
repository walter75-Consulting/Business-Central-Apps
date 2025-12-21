/// <summary>
/// Query SEW User Performance (ID 91763).
/// Tracks individual user/salesperson performance metrics.
/// Measures lead volume and pipeline value.
/// </summary>
query 91763 "SEW User Performance"
{
    Caption = 'User Performance';
    QueryType = Normal;

    elements
    {
        dataitem(Lead; "SEW Lead")
        {
            column(SalespersonCode; "Salesperson Code")
            {
                Caption = 'Salesperson';
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
