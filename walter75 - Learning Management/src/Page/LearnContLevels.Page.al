/// <summary>
/// Page SEW Learn Cont Levels (ID 91855).
/// List page for browsing and managing difficulty levels.
/// </summary>
page 91855 "SEW Learn Cont Levels"
{
    PageType = List;
UsageCategory = None;
    SourceTable = "SEW Learn Cont Levels";
    Caption = 'Learning Content Levels';
    ApplicationArea = All;
    Editable = true;


    layout
    {
        area(Content)
        {
            repeater(Levels)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the level code.';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the display name of the level.';
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
                ToolTip = 'View all learning content assigned to this level.';
                Image = ShowList;

                trigger OnAction()
                var
                    ContentLevelMapping: Record "SEW Learn Cont Levels Map";
                    LearningContent: Record "SEW Learn Cont";
                begin
                    ContentLevelMapping.SetRange("Level Code", Rec."Code");
                    if ContentLevelMapping.FindSet() then
                        repeat
                            LearningContent.SetRange(UID, ContentLevelMapping."Content UID");
                            if LearningContent.FindFirst() then;
                        until ContentLevelMapping.Next() = 0;
                    Page.Run(Page::"SEW Learn Cont List", LearningContent);
                end;
            }
        }
    }
}
