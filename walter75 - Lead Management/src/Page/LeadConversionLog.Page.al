page 91724 "SEW Lead Conversion Log"
{
    Caption = 'Lead Conversion Log';
    PageType = List;
    SourceTable = "SEW Lead→Opportunity Map";
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique entry number for this conversion record.';
                }
                field("Lead No."; Rec."Lead No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the lead number that was converted.';
                }
                field("Lead Source Code"; Rec."Lead Source Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source code from the converted lead.';
                }
                field("Opportunity No."; Rec."Opportunity No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the opportunity number created from the lead.';
                }
                field("Contact No."; Rec."Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the contact that was created or linked during conversion.';
                }
                field("Contact Name"; Rec."Contact Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the contact.';
                }
                field("Expected Revenue"; Rec."Expected Revenue")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the expected revenue from the lead at conversion time.';
                }
                field("Actual Revenue"; Rec."Actual Revenue")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the actual revenue achieved from the opportunity.';
                }
                field("Campaign No."; Rec."Campaign No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the campaign associated with this conversion.';
                }
                field("Converted By Name"; Rec."Converted By Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user who converted the lead.';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    Caption = 'Converted At';
                    ToolTip = 'Specifies when the lead was converted.';
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
                Image = Document;
                ApplicationArea = All;
                ToolTip = 'Open the lead card.';

                trigger OnAction()
                var
                    SEWLeadRec: Record "SEW Lead";
                begin
                    if SEWLeadRec.Get(Rec."Lead No.") then
                        Page.Run(Page::"SEW Lead Card", SEWLeadRec);
                end;
            }
            action(ViewOpportunity)
            {
                Caption = 'View Opportunity';
                Image = Opportunity;
                ApplicationArea = All;
                ToolTip = 'Open the opportunity card.';

                trigger OnAction()
                var
                    OpportunityRec: Record Opportunity;
                begin
                    if OpportunityRec.Get(Rec."Opportunity No.") then
                        Page.Run(Page::"Opportunity Card", OpportunityRec);
                end;
            }
            action(ViewContact)
            {
                Caption = 'View Contact';
                Image = ContactPerson;
                ApplicationArea = All;
                ToolTip = 'Open the contact card.';

                trigger OnAction()
                var
                    ContactRec: Record Contact;
                begin
                    if ContactRec.Get(Rec."Contact No.") then
                        Page.Run(Page::"Contact Card", ContactRec);
                end;
            }
        }
    }
}
