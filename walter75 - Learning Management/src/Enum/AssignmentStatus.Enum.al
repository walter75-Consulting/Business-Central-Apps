/// <summary>
/// Enum SEW Assignment Status (ID 91831).
/// Tracks the lifecycle status of a learning assignment.
/// </summary>
enum 91831 "SEW Assignment Status"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(1; "Not Started")
    {
        Caption = 'Not Started';
    }
    value(2; "In Progress")
    {
        Caption = 'In Progress';
    }
    value(3; "Completed")
    {
        Caption = 'Completed';
    }
    value(4; "Outdated")
    {
        Caption = 'Outdated';
    }
}
