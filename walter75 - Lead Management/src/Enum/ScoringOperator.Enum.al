enum 91708 "SEW Scoring Operator"
{
    Caption = 'Scoring Operator';
    Extensible = true;

    value(0; "")
    {
        Caption = '', Locked = true;
    }
    value(1; Equals)
    {
        Caption = 'Equals';
    }
    value(2; Contains)
    {
        Caption = 'Contains';
    }
    value(3; Greater)
    {
        Caption = 'Greater Than';
    }
    value(4; Less)
    {
        Caption = 'Less Than';
    }
    value(5; Between)
    {
        Caption = 'Between';
    }
}
