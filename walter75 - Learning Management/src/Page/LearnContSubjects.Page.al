/// <summary>
/// Page SEW Learn Cont Subjects (ID 91856).
/// List page for browsing and managing subject areas.
/// </summary>
page 91856 "SEW Learn Cont Subjects"
{
    PageType = List;
    UsageCategory = None;
    SourceTable = "SEW Learn Cont Subjects";
    Caption = 'Learn Content Subjects';
    ApplicationArea = All;
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(Subjects)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the subject code.';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the display name of the subject.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ViewAssignedContent)
            {
                Caption = 'View Assigned Content';
                ToolTip = 'View all learning content assigned to this subject.';
                Image = ShowList;

                trigger OnAction()
                var
                    ContentSubjectMapping: Record "SEW Learn Cont Subjects Map";
                    LearningContent: Record "SEW Learn Cont";
                begin
                    ContentSubjectMapping.SetRange("Subject Code", Rec."Code");
                    if ContentSubjectMapping.FindSet() then
                        repeat
                            LearningContent.SetRange(UID, ContentSubjectMapping."Content UID");
                            if LearningContent.FindFirst() then;
                        until ContentSubjectMapping.Next() = 0;
                    Page.Run(Page::"SEW Learn Cont List", LearningContent);
                end;
            }
        }
    }
}
