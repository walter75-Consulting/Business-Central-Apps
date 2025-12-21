enum 91709 "SEW Activity Type"
{
    Caption = 'Activity Type';
    Extensible = true;

    value(0; "")
    {
        Caption = '', Locked = true;
    }
    value(1; Call)
    {
        Caption = 'Call';
    }
    value(2; Email)
    {
        Caption = 'Email';
    }
    value(3; Meeting)
    {
        Caption = 'Meeting';
    }
    value(4; Task)
    {
        Caption = 'Task';
    }
    value(5; Note)
    {
        Caption = 'Note';
    }
}
