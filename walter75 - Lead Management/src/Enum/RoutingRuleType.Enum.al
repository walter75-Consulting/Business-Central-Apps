enum 91706 "SEW Routing Rule Type"
{
    Caption = 'Routing Rule Type';
    Extensible = true;

    value(0; "")
    {
        Caption = '', Locked = true;
    }
    value(1; RoundRobin)
    {
        Caption = 'Round Robin';
    }
    value(2; Territory)
    {
        Caption = 'Territory';
    }
    value(3; ScoreThreshold)
    {
        Caption = 'Score Threshold';
    }
    value(4; SourceBased)
    {
        Caption = 'Source Based';
    }
}
