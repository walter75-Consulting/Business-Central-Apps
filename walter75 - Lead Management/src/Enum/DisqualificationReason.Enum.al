enum 91729 "SEW Disqualification Reason"
{
    Caption = 'Disqualification Reason';
    Extensible = true;

    value(0; "")
    {
        Caption = '', Locked = true;
    }
    value(1; NoBudget)
    {
        Caption = 'No Budget';
    }
    value(2; NoAuthority)
    {
        Caption = 'No Authority';
    }
    value(3; NoNeed)
    {
        Caption = 'No Need';
    }
    value(4; NoTimeline)
    {
        Caption = 'No Timeline';
    }
    value(5; Duplicate)
    {
        Caption = 'Duplicate';
    }
    value(6; Invalid)
    {
        Caption = 'Invalid';
    }
    value(7; Other)
    {
        Caption = 'Other';
    }
}
