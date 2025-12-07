page 90820 "SEW Calc Templates"
{
    Caption = 'Calculation Templates';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "SEW Calc Template";
    CardPageId = "SEW Calc Template Card";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Price Source Item"; Rec."Price Source Item")
                {
                }
                field("Include Material"; Rec."Include Material")
                {
                }
                field("Include Labor"; Rec."Include Labor")
                {
                }
                field("Include Overhead"; Rec."Include Overhead")
                {
                }
                field("Last Modified Date"; Rec."Last Modified Date")
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(EditTemplate)
            {
                ApplicationArea = All;
                Caption = 'Edit';
                ToolTip = 'Edit the selected template.';
                Image = Edit;

                trigger OnAction()
                begin
                    Page.Run(Page::"SEW Calc Template Card", Rec);
                end;
            }
        }

        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(EditTemplate_Promoted; EditTemplate)
                {
                }
            }
        }
    }
}
