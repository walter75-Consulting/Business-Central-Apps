/// <summary>
/// Page SEW Content Role FactBox (ID 91858).
/// Shows roles assigned to learning content.
/// </summary>
page 91881 "SEW Learn Cont Roles FB"
{
    PageType = ListPart;
    SourceTable = "SEW Learn Cont Roles Map";
    Caption = 'Learn Content Roles';
    Editable = false;
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(Roles)
            {
                field("Role Code"; Rec."Role Code")
                {
                    ToolTip = 'Specifies the role code.';

                    trigger OnDrillDown()
                    var
                        Role: Record "SEW Learn Cont Roles";
                    begin
                        if Role.Get(Rec."Role Code") then
                            Page.Run(Page::"SEW Learn Cont Roles", Role);
                    end;
                }
            }
        }
    }
}
