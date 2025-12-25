/// <summary>
/// Page SEW Skill List (ID 91841).
/// List of available skills.
/// </summary>
page 91841 "SEW Skill List"
{
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "SEW Skill";
    Caption = 'SEW Skill List';
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            repeater(Skills)
            {
                field(Code; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Skill Category"; Rec."Skill Category")
                {
                }
                field("Required for Roles"; Rec."Required for Roles")
                {
                }
            }
        }
    }
}
