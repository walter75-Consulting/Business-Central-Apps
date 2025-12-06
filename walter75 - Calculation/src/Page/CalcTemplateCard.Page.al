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
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique code for the calculation template';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the calculation template';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies additional description for the calculation template';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the template';
                }
            }

            group(Settings)
            {
                Caption = 'Settings';
                Editable = Rec.Status = Rec.Status::Draft;

                field("Price Source Item"; Rec."Price Source Item")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the price source for material costs';
                }
                field("Price Source Capacity"; Rec."Price Source Capacity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the price source for capacity costs';
                }
                field("Include Material"; Rec."Include Material")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether to include material costs from BOM';
                }
                field("Include Labor"; Rec."Include Labor")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether to include labor costs from Routing';
                }
                field("Include Overhead"; Rec."Include Overhead")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether to include overhead costs';
                }
            }

            part(Lines; "SEW Calc Template Lines")
            {
                ApplicationArea = All;
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
                ToolTip = 'Release the template to make it available for calculations';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;

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
                ToolTip = 'Reopen the template for editing';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Draft;
                    Rec.Modify(true);
                    CurrPage.Update(false);
                    Message('Template has been reopened.');
                end;
            }
        }
    }
}
