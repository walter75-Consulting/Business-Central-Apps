/// <summary>
/// Page SEW Employee Skill Matrix (ID 91840).
/// View employee skill matrix with proficiency levels.
/// </summary>
page 91840 "SEW Employee Skill Matrix"
{
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "SEW Employee Skill";
    Caption = 'SEW Employee Skill Matrix';
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            repeater(Skills)
            {
                field("Employee No."; Rec."Employee No.")
                {
                }
                field("Skill Code"; Rec."Skill Code")
                {
                }
                field("Skill Description"; Rec."Skill Description")
                {
                }
                field("Proficiency Level"; Rec."Proficiency Level")
                {
                }
                field(Source; Rec.Source)
                {
                }
                field("Acquired Date"; Rec."Acquired Date")
                {
                }
                field("Last Assessed Date"; Rec."Last Assessed Date")
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(UpdateFromTraining)
            {
                Image = Refresh;

                trigger OnAction()
                var
                    SkillMatrixMgr: Codeunit "SEW Skill Matrix Manager";
                begin
                    if Rec."Employee No." <> '' then begin
                        SkillMatrixMgr.UpdateEmployeeSkills(Rec."Employee No.");
                        Message('Skills updated successfully.');
                    end;
                end;
            }
        }
    }
}
