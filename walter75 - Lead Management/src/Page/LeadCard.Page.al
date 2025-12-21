page 91711 "SEW Lead Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "SEW Lead";
    Caption = 'Lead Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.") { }
                field("Lead ID"; Rec."Lead ID") { }
                field(Status; Rec.Status) { }
                field("Assignment Type"; Rec."Assignment Type") { }
                field("Salesperson Code"; Rec."Salesperson Code") { }
                field("Assigned To Name"; Rec."Assigned To Name")
                {
                    Editable = false;
                }
                field("Source Code"; Rec."Source Code") { }
                field("Campaign No."; Rec."Campaign No.") { }
            }
            group(LeadInformation)
            {
                Caption = 'Lead Information';
                field("Quick Company Name"; Rec."Quick Company Name")
                {
                    //Visible = ShowQuickFields;
                }
                field("Quick Email"; Rec."Quick Email")
                {
                    //Visible = ShowQuickFields;
                }
                field("Quick Phone"; Rec."Quick Phone")
                {
                    //Visible = ShowQuickFields;
                }
                field("Contact No."; Rec."Contact No.") { }
                field("Expected Revenue"; Rec."Expected Revenue") { }
                field("Employee Count"; Rec."Employee Count") { }
                field("Industry Group Code"; Rec."Industry Group Code") { }
            }

            group(LeadDescription)
            {
                Caption = 'Lead Description';
                field(LeadDescriptionField; LeadDescriptionText)
                {
                    MultiLine = true;
                    ExtendedDatatype = RichContent;
                    ShowCaption = false;

                    trigger OnValidate()
                    begin
                        Rec.SetLeadDescription(LeadDescriptionText);
                        Rec.Modify(true);
                    end;
                }
            }
            group(LeadSummary)
            {
                Caption = 'Lead Summary';
                field(LeadSummaryField; LeadSummaryText)
                {
                    MultiLine = true;
                    ExtendedDatatype = RichContent;
                    ShowCaption = false;

                    trigger OnValidate()
                    begin
                        Rec.SetLeadSummary(LeadSummaryText);
                        Rec.Modify(true);
                    end;
                }
            }
            group(Qualification)
            {
                Caption = 'Qualification';
                field("Score (Total)"; Rec."Score (Total)") { }
                field("Score Band"; Rec."Score Band") { }
                field("Next Activity Date"; Rec."Next Activity Date") { }
                field("Opportunity No."; Rec."Opportunity No.") { }
            }

            group(EngagementSignals)
            {
                Caption = 'Engagement Signals';
                field("Website Visit"; Rec."Website Visit") { }
                field("Email Opened"; Rec."Email Opened") { }
            }
            group(Disqualification)
            {
                Caption = 'Disqualification';
                Visible = Rec.Status = Rec.Status::Disqualified;
                field("Disqualification Reason"; Rec."Disqualification Reason") { }
                field("Disqualification Notes"; Rec."Disqualification Notes") { }
            }
            group(SystemInfo)
            {
                Caption = 'System Information';
                field("System Created By Name"; Rec."System Created By Name")
                {
                    Editable = false;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the date and time when the record was created.';
                    Editable = false;
                }
                field("System Modified By Name"; Rec."System Modified By Name")
                {
                    Editable = false;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the date and time when the record was last modified.';
                    Editable = false;
                }
            }
        }
        area(FactBoxes)
        {
            part(ScoringDetails; "SEW Lead Scoring Details FB")
            {
                SubPageLink = "No." = field("No.");
                Caption = 'Scoring Details';
            }
            part(Activities; "SEW Lead Activity ListPart")
            {
                SubPageLink = "Lead No." = field("No.");
                Caption = 'Activities';
            }
            part(UTMAttribution; "SEW UTM Attribution Card")
            {
                SubPageLink = "Lead No." = field("No.");
                Caption = 'UTM Attribution';
            }
            systempart(Notes; Notes)
            {
            }
            systempart(Links; Links)
            {
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ConvertToOpportunity)
            {

                Caption = 'Convert to Opportunity';
                Image = MakeAgreement;
                ToolTip = 'Convert this lead to a Business Central opportunity.';
                Enabled = Rec.Status = Rec.Status::Qualified;

                trigger OnAction()
                var
                    SEWConversionManager: Codeunit "SEW Conversion Manager";
                begin
                    SEWConversionManager.ConvertLeadToOpportunity(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(CreateOrLinkContact)
            {

                Caption = 'Create/Link Contact';
                Image = ContactPerson;
                ToolTip = 'Create a new Contact or link to an existing Contact.';
                Enabled = Rec."Contact No." = '';

                trigger OnAction()
                var
                    SEWLeadContactSync: Codeunit "SEW Lead-Contact Sync";
                begin
                    SEWLeadContactSync.CreateOrLinkContact(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(CalculateScore)
            {
                Caption = 'Calculate Score';
                Image = CalculateLines;
                ToolTip = 'Calculate the lead score based on active scoring model and rules.';

                trigger OnAction()
                var
                    SEWScoringEngine: Codeunit "SEW Scoring Engine";
                begin
                    // Save any pending field changes first
                    Rec.Modify(true);

                    SEWScoringEngine.CalculateLeadScore(Rec);
                    CurrPage.Update(false);
                    Message('Lead score calculated: %1 points', Rec."Score (Total)");
                end;
            }
            action(ApplyRouting)
            {
                Caption = 'Apply Routing';
                Image = Allocate;
                ToolTip = 'Apply automatic routing rules to assign this lead to a salesperson or team.';

                trigger OnAction()
                var
                    SEWRoutingEngine: Codeunit "SEW Routing Engine";
                begin
                    SEWRoutingEngine.AssignLead(Rec);
                    CurrPage.Update(false);
                    Message('Lead assigned to: %1', Rec."Assigned To Name");
                end;
            }
            action(UpdateScoreBand)
            {

                Caption = 'Update Score Band';
                Image = Calculate;
                ToolTip = 'Recalculate the score band based on current score.';

                trigger OnAction()
                var
                    SEWLeadManagement: Codeunit "SEW Lead Management";
                begin
                    SEWLeadManagement.UpdateScoreBand(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(ToggleQuickFields)
            {

                Caption = 'Toggle Quick Fields';
                Image = View;
                ToolTip = 'Show or hide the quick capture fields.';

                trigger OnAction()
                begin
                    ShowQuickFields := not ShowQuickFields;
                end;
            }
        }
        area(Navigation)
        {
            action(LeadStatusHistory)
            {

                Caption = 'Status History';
                Image = History;
                ToolTip = 'View the status change history for this lead.';
                RunObject = page "SEW Lead Status History";
                RunPageLink = "Lead No." = field("No.");
            }
            action(AssignmentHistory)
            {
                Caption = 'Assignment History';
                Image = Allocate;
                ToolTip = 'View the assignment change history and routing audit trail for this lead.';
                RunObject = page "SEW Lead Assignment Log";
                RunPageLink = "Lead No." = field("No.");
            }
            action(ViewContact)
            {

                Caption = 'View Contact';
                Image = ContactPerson;
                ToolTip = 'Open the linked Contact card.';
                Enabled = Rec."Contact No." <> '';
                RunObject = page "Contact Card";
                RunPageLink = "No." = field("Contact No.");
            }
            action(ViewOpportunity)
            {

                Caption = 'View Opportunity';
                Image = Opportunity;
                ToolTip = 'Open the converted Opportunity card.';
                Enabled = Rec."Opportunity No." <> '';
                RunObject = page "Opportunity Card";
                RunPageLink = "No." = field("Opportunity No.");
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';
                actionref(CalculateScore_Promoted; CalculateScore) { }
                actionref(ApplyRouting_Promoted; ApplyRouting) { }
                actionref(ConvertToOpportunity_Promoted; ConvertToOpportunity) { }
                actionref(CreateOrLinkContact_Promoted; CreateOrLinkContact) { }
                actionref(UpdateScoreBand_Promoted; UpdateScoreBand) { }
            }
            group(Category_Category4)
            {
                Caption = 'Navigate';
                actionref(LeadStatusHistory_Promoted; LeadStatusHistory) { }
                actionref(ViewContact_Promoted; ViewContact) { }
                actionref(ViewOpportunity_Promoted; ViewOpportunity) { }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        ShowQuickFields := (Rec."Contact No." = '');
        LeadDescriptionText := Rec.GetLeadDescription();
        LeadSummaryText := Rec.GetLeadSummary();
    end;

    var
        ShowQuickFields: Boolean;
        LeadDescriptionText: Text;
        LeadSummaryText: Text;
}
