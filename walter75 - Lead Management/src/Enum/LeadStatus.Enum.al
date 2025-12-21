enum 91700 "SEW Lead Status"
{
    Caption = 'Lead Status';
    Extensible = true;

    value(0; "")
    {
        Caption = '', Locked = true;
    }
    value(1; New)
    {
        Caption = 'New';
    }
    value(2; Working)
    {
        Caption = 'Working';
    }
    value(3; Nurturing)
    {
        Caption = 'Nurturing';
    }
    value(4; Qualified)
    {
        Caption = 'Qualified';
    }
    value(5; Disqualified)
    {
        Caption = 'Disqualified';
    }
    value(6; Converted)
    {
        Caption = 'Converted';
    }
}
