enum 91703 "SEW Lead Assignment Type"
{
    Caption = 'Lead Assignment Type';
    Extensible = false;

    value(0; "")
    {
        Caption = '', Locked = true;
    }
    value(1; Salesperson)
    {
        Caption = 'Salesperson';
    }
    value(2; Team)
    {
        Caption = 'Team';
    }
}
