/// <summary>
/// Page SEW Learning Path Modules (ID 91854).
/// Subpage showing modules in a learning path.
/// </summary>
page 91854 "SEW Learn Cont Path Mod"
{
    PageType = ListPart;
    SourceTable = "SEW Learn Cont Path Mod";
    Caption = 'Learn Content Path Modules';
    ApplicationArea = All;
    UsageCategory = None;

    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Modules)
            {
                field(Sequence; Rec.Sequence)
                {
                }
                field("Module UID"; Rec."Module UID")
                {
                }
                field("Module Title"; Rec."Module Title")
                {
                }
            }
        }
    }
}
