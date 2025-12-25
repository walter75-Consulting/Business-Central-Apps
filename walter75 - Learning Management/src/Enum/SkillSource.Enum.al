/// <summary>
/// Enum SEW Skill Source (ID 91841).
/// Defines how a skill proficiency was determined or acquired.
/// </summary>
enum 91841 "SEW Skill Source"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(1; "Training Completion")
    {
        Caption = 'Training Completion';
    }
    value(2; "Manager Assessment")
    {
        Caption = 'Manager Assessment';
    }
    value(3; "Self-Assessment")
    {
        Caption = 'Self-Assessment';
    }
    value(4; "Certification")
    {
        Caption = 'Certification';
    }
}
