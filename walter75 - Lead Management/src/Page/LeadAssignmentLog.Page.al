page 91721 "SEW Lead Assignment Log"
{
    Caption = 'Lead Assignment Log';
    PageType = List;
    SourceTable = "SEW Lead Assignment Log";
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique entry number for the assignment log.';
                }
                field("Lead No."; Rec."Lead No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the lead that was assigned.';
                }
                field("Rule Code"; Rec."Rule Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies which routing rule triggered the assignment.';
                }
                field("From Assignment Type"; Rec."From Assignment Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the previous assignment type.';
                }
                field("From Assigned To Name"; Rec."From Assigned To Name")
                {
                    ApplicationArea = All;
                    Caption = 'From';
                    ToolTip = 'Specifies who the lead was assigned from.';
                }
                field("To Assignment Type"; Rec."To Assignment Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the new assignment type.';
                }
                field("To Assigned To Name"; Rec."To Assigned To Name")
                {
                    ApplicationArea = All;
                    Caption = 'To';
                    ToolTip = 'Specifies the name of the new owner.';
                }
                field(Reason; Rec.Reason)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the reason for the assignment.';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    Caption = 'Assigned At';
                    ToolTip = 'Specifies when the assignment occurred.';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(ViewLead)
            {
                Caption = 'View Lead';
                Image = List;
                ToolTip = 'View the associated lead.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    SEWLeadRec: Record "SEW Lead";
                begin
                    if SEWLeadRec.Get(Rec."Lead No.") then
                        Page.Run(Page::"SEW Lead Card", SEWLeadRec);
                end;
            }
        }
    }
}
