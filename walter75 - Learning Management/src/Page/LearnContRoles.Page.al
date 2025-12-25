/// <summary>
/// Page SEW Learn Cont Roles (ID 91854).
/// List page for browsing and managing target roles.
/// </summary>
page 91880 "SEW Learn Cont Roles"
{
    PageType = List;
    UsageCategory = None;
    SourceTable = "SEW Learn Cont Roles";
    Caption = 'Learn Content Roles';
    ApplicationArea = All;
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(Roles)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the role code.';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the display name of the role.';
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
                ToolTip = 'View all learning content assigned to this role.';
                Image = ShowList;

                trigger OnAction()
                var
                    ContentRoleMapping: Record "SEW Learn Cont Roles Map";
                    LearningContent: Record "SEW Learn Cont";
                begin
                    ContentRoleMapping.SetRange("Role Code", Rec."Code");
                    if ContentRoleMapping.FindSet() then
                        repeat
                            LearningContent.SetRange(UID, ContentRoleMapping."Content UID");
                            if LearningContent.FindFirst() then;
                        until ContentRoleMapping.Next() = 0;
                    Page.Run(Page::"SEW Learn Cont List", LearningContent);
                end;
            }
        }
    }
}
