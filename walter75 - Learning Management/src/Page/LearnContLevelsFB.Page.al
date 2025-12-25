/// <summary>
/// Page SEW Content Level FactBox (ID 91857).
/// Shows levels assigned to learning content.
/// </summary>
page 91857 "SEW Learn Cont Levels FB"
{
    PageType = ListPart;
    SourceTable = "SEW Learn Cont Levels Map";
    Caption = 'Learn Content Levels';
    ApplicationArea = All;
    Editable = false;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(Levels)
            {
                field("Level Code"; Rec."Level Code")
                {

                }
            }
        }
    }
}
