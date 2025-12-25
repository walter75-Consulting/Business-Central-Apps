/// <summary>
/// Page SEW My Learning Assignments (ID 91831).
/// Employee self-service view of their assignments.
/// </summary>
page 91831 "SEW My Learning Assignments"
{
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "SEW Empl. Learning Assign.";
    Caption = 'SEW My Learning Assignments';
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            repeater(Assignments)
            {
                field("Assignment Type"; Rec."Assignment Type")
                {
                }
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
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(MarkStarted)
            {
                Image = Start;

                trigger OnAction()
                var
                    AssignmentMgr: Codeunit "SEW Assignment Manager";
                begin
                    AssignmentMgr.MarkModuleStarted(Rec."Entry No.");
                end;
            }
            action(MarkCompleted)
            {
                Image = Completed;

                trigger OnAction()
                var
                    AssignmentMgr: Codeunit "SEW Assignment Manager";
                    CompletionNotes: Text[250];
                begin
                    if Confirm('Have you completed this training?', true) then begin
                        CompletionNotes := '';
                        AssignmentMgr.MarkModuleCompleted(Rec."Entry No.", CompletionNotes);
                        Message('Assignment marked as completed.');
                    end;
                end;
            }
            action(OpenOnMicrosoftLearn)
            {
                Image = Link;

                trigger OnAction()
                var
                    LearningContent: Record "SEW Learn Cont";
                begin
                    case Rec."Assignment Type" of
                        Rec."Assignment Type"::Module:
                            begin
                                LearningContent.SetRange(UID, Rec."Learn Cont UID");
                                LearningContent.SetRange("Content Type", LearningContent."Content Type"::Module);
                                if LearningContent.FindFirst() then
                                    LearningContent.OpenInBrowser();
                            end;
                        Rec."Assignment Type"::"Learning Path":
                            begin
                                LearningContent.SetRange(UID, Rec."Learn Cont UID");
                                LearningContent.SetRange("Content Type", LearningContent."Content Type"::"Learning Path");
                                if LearningContent.FindFirst() then
                                    LearningContent.OpenInBrowser();
                            end;
                    end;
                end;
            }
        }
    }
}
