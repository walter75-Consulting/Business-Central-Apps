/// <summary>
/// Page SEW Empl. Learning Assigns. (ID 91830).
/// View all learning assignments (administrator view).
/// </summary>
page 91830 "SEW Empl. Learning Assigns."
{
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "SEW Empl. Learning Assign.";
    Caption = 'SEW Empl. Learning Assigns.';
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            repeater(Assignments)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Employee No."; Rec."Employee No.")
                {
                }
                field("Employee Name"; Rec."Employee Name")
                {
                }
                field("Assignment Type"; Rec."Assignment Type")
                {
                }
                field("Learn Cont UID"; Rec."Learn Cont UID") { }
                field("Content Title"; Rec."Content Title")
                {
                }
                field("Assigned Date"; Rec."Assigned Date")
                {
                }
                field("Due Date"; Rec."Due Date")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Progress Percentage"; Rec."Progress Percentage")
                {
                }
                field("Completed Date"; Rec."Completed Date")
                {
                }
                field("Version Outdated"; Rec."Version Outdated")
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(MarkCompleted)
            {
                Image = Completed;

                trigger OnAction()
                var
                    AssignmentMgr: Codeunit "SEW Assignment Manager";
                begin
                    AssignmentMgr.MarkModuleCompleted(Rec."Entry No.", '');
                end;
            }
        }
    }
}
