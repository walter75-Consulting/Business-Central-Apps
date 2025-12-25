/// <summary>
/// Enum SEW Learning Content Type (ID 91819).
/// Distinguishes between modules and learning paths.
/// </summary>
enum 91819 "SEW Learning Content Type"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(1; Module)
    {
        Caption = 'Module';
    }
    value(2; "Learning Path")
    {
        Caption = 'Learning Path';
    }
}
