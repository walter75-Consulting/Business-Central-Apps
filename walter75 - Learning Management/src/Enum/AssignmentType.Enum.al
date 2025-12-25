/// <summary>
/// Enum SEW Assignment Type (ID 91830).
/// Defines whether an assignment is for an individual module or a complete learning path.
/// </summary>
enum 91830 "SEW Assignment Type"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(1; "Module")
    {
        Caption = 'Module';
    }
    value(2; "Learning Path")
    {
        Caption = 'Learning Path';
    }
}
