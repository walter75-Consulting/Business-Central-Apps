enum 91704 "SEW Activity Outcome"
{
    Caption = 'Activity Outcome';
    Extensible = true;

    value(0; "")
    {
        Caption = '', Locked = true;
    }
    value(1; Connected)
    {
        Caption = 'Connected';
    }
    value(2; NoAnswer)
    {
        Caption = 'No Answer';
    }
    value(3; LeftVM)
    {
        Caption = 'Left Voicemail';
    }
    value(4; Positive)
    {
        Caption = 'Positive';
    }
    value(5; Negative)
    {
        Caption = 'Negative';
    }
    value(6; Rescheduled)
    {
        Caption = 'Rescheduled';
    }
}
