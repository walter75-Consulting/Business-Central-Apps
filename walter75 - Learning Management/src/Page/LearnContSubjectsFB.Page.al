/// <summary>
/// Page SEW Content Subject FactBox (ID 91859).
/// Shows subjects assigned to learning content.
/// </summary>
page 91882 "SEW Learn Cont Subjects FB"
{
    PageType = ListPart;
    SourceTable = "SEW Learn Cont Subjects Map";
    Caption = 'Learn Content Subjects Mapping';
    Editable = false;
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(Subjects)
            {
                field("Subject Code"; Rec."Subject Code")
                {
                    ToolTip = 'Specifies the subject code.';

                    trigger OnDrillDown()
                    var
                        Subject: Record "SEW Learn Cont Subjects";
                    begin
                        if Subject.Get(Rec."Subject Code") then
                            Page.Run(Page::"SEW Learn Cont Subjects", Subject);
                    end;
                }
            }
        }
    }
}
