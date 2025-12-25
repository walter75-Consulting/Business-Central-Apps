/// <summary>
/// Page SEW Module Parent Paths (ID 91861).
/// Shows Learning Paths that contain a specific Module.
/// </summary>
page 91861 "SEW Module Parent Paths"
{
    PageType = ListPart;
    SourceTable = "SEW Learn Cont Path Mod";
    Caption = 'Learning Paths';
    Editable = false;
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(Paths)
            {
                field(Sequence; Rec.Sequence)
                {

                }
                field("Learning Path UID"; Rec."Learning Path UID")
                {


                    trigger OnDrillDown()
                    var
                        LearningContent: Record "SEW Learn Cont";
                    begin
                        LearningContent.SetRange(UID, Rec."Learning Path UID");
                        LearningContent.SetRange("Content Type", LearningContent."Content Type"::"Learning Path");
                        if LearningContent.FindFirst() then
                            Page.Run(Page::"SEW Learn Cont Card", LearningContent);
                    end;
                }
                field("Learning Path Title"; Rec."Module Title")
                {

                }
            }
        }
    }
}
