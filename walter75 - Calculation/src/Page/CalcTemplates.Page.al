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
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique code for the calculation template';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the calculation template';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the template';
                }
                field("Price Source Item"; Rec."Price Source Item")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the price source for material costs';
                }
                field("Include Material"; Rec."Include Material")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether to include material costs';
                }
                field("Include Labor"; Rec."Include Labor")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether to include labor costs';
                }
                field("Include Overhead"; Rec."Include Overhead")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether to include overhead costs';
                }
                field("Last Modified Date"; Rec."Last Modified Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the template was last modified';
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
                ToolTip = 'Edit the selected template';
                Image = Edit;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Page.Run(Page::"SEW Calc Template Card", Rec);
                end;
            }
        }
    }
}
