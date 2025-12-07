page 90821 "SEW Calc Template Card"
{
    Caption = 'Calculation Template Card';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "SEW Calc Template";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Code"; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Description 2"; Rec."Description 2")
                {
                }
                field(Status; Rec.Status)
                {
                }
            }

            group(Settings)
            {
                Caption = 'Settings';
                Editable = Rec.Status = Rec.Status::Draft;

                field("Price Source Item"; Rec."Price Source Item")
                {
                }
                field("Price Source Capacity"; Rec."Price Source Capacity")
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
            }

            part(Lines; "SEW Calc Template Lines")
            {
                Caption = 'Template Lines';
                SubPageLink = "Template Code" = field(Code);
                Editable = Rec.Status = Rec.Status::Draft;
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ReleaseTemplate)
            {
                ApplicationArea = All;
                Caption = 'Release';
                ToolTip = 'Release the template to make it available for calculations.';
                Image = ReleaseDoc;

                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Released;
                    Rec.Modify(true);
                    CurrPage.Update(false);
                    Message('Template has been released.');
                end;
            }

            action(ReopenTemplate)
            {
                ApplicationArea = All;
                Caption = 'Reopen';
                ToolTip = 'Reopen the template for editing.';
                Image = ReOpen;

                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Draft;
                    Rec.Modify(true);
                    CurrPage.Update(false);
                    Message('Template has been reopened.');
                end;
            }
        }

        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(ReleaseTemplate_Promoted; ReleaseTemplate)
                {
                }
                actionref(ReopenTemplate_Promoted; ReopenTemplate)
                {
                }
            }
        }
    }
}
