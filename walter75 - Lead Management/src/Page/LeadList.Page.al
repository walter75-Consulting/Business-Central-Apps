page 91710 "SEW Lead List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "SEW Lead";
    CardPageId = "SEW Lead Card";
    Caption = 'Leads';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(LeadRows)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique number assigned to the lead.';
                }
                field("Quick Company Name"; Rec."Quick Company Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the company name for quick capture. Cleared when Contact is linked.';
                }
                field("Quick Email"; Rec."Quick Email")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the email address for quick capture. Cleared when Contact is linked.';
                }
                field("Contact No."; Rec."Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the linked Business Central Contact.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current status of the lead.';
                }
                field("Score (Total)"; Rec."Score (Total)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total lead score.';
                }
                field("Score Band"; Rec."Score Band")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the score band classification.';
                }
                field("Assignment Type"; Rec."Assignment Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether assigned to individual or team.';
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                    Caption = 'Assigned To';
                    ToolTip = 'Specifies the salesperson or team assigned to this lead.';
                }
                field("Assigned To Name"; Rec."Assigned To Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the assigned salesperson or team.';
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = All;
                    Caption = 'Source Code';
                    ToolTip = 'Specifies the source that generated this lead.';
                }
                field("Expected Revenue"; Rec."Expected Revenue")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the expected revenue from this lead.';
                }
                field("Next Activity Date"; Rec."Next Activity Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of the next planned activity.';
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Links; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CreateLead)
            {
                ApplicationArea = All;
                Caption = 'Create Lead';
                Image = New;
                ToolTip = 'Create a new lead record.';

                trigger OnAction()
                var
                    SEWLeadRec: Record "SEW Lead";
                    SEWLeadManagement: Codeunit "SEW Lead Management";
                begin
                    SEWLeadManagement.CreateLead(SEWLeadRec);
                    Page.Run(Page::"SEW Lead Card", SEWLeadRec);
                end;
            }
            action(ConvertToOpportunity)
            {
                ApplicationArea = All;
                Caption = 'Convert to Opportunity';
                Image = MakeAgreement;
                ToolTip = 'Convert the selected lead to a Business Central opportunity.';
                Enabled = Rec.Status = Rec.Status::Qualified;

                trigger OnAction()
                var
                    SEWConversionManager: Codeunit "SEW Conversion Manager";
                begin
                    SEWConversionManager.ConvertLeadToOpportunity(Rec);
                end;
            }
            action(UpdateScoreBand)
            {
                ApplicationArea = All;
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
            action(AutoAssign)
            {
                ApplicationArea = All;
                Caption = 'Auto-Assign';
                Image = Allocate;
                ToolTip = 'Automatically assign the lead using routing rules.';

                trigger OnAction()
                var
                    SEWRoutingEngine: Codeunit "SEW Routing Engine";
                begin
                    SEWRoutingEngine.AssignLead(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(ShowMyLeads)
            {
                ApplicationArea = All;
                Caption = 'My Leads';
                Image = FilterLines;
                ToolTip = 'Show only leads assigned to me individually.';

                trigger OnAction()
                begin
                    ApplyMyLeadsFilter();
                    CurrPage.Update(false);
                end;
            }
            action(ShowMyTeamsLeads)
            {
                ApplicationArea = All;
                Caption = 'My Teams Leads';
                Image = Allocate;
                ToolTip = 'Show only leads assigned to teams I belong to.';

                trigger OnAction()
                begin
                    ApplyMyTeamsLeadsFilter();
                    CurrPage.Update(false);
                end;
            }
            action(ClearFilters)
            {
                ApplicationArea = All;
                Caption = 'Show All Leads';
                Image = ClearFilter;
                ToolTip = 'Clear personal filters and show all leads.';

                trigger OnAction()
                begin
                    Rec.Reset();
                    CurrPage.Update(false);
                end;
            }
        }
        area(Navigation)
        {
            action(LeadStatusHistory)
            {
                ApplicationArea = All;
                Caption = 'Status History';
                Image = History;
                ToolTip = 'View the status change history for this lead.';
                RunObject = page "SEW Lead Status History";
                RunPageLink = "Lead No." = field("No.");
            }
        }
        area(Promoted)
        {
            group(Category_New)
            {
                Caption = 'New';
                actionref(CreateLead_Promoted; CreateLead) { }
            }
            group(Category_Process)
            {
                Caption = 'Process';
                actionref(ConvertToOpportunity_Promoted; ConvertToOpportunity) { }
                actionref(UpdateScoreBand_Promoted; UpdateScoreBand) { }
            }
            group(Category_Report)
            {
                Caption = 'Report';
            }
            group(Category_Category4)
            {
                Caption = 'Navigate';
                actionref(LeadStatusHistory_Promoted; LeadStatusHistory) { }
            }
        }
    }

    views
    {
        view(AllLeads)
        {
            Caption = 'All Leads';
        }
        view(ActiveLeads)
        {
            Caption = 'Active Leads';
            Filters = where(Status = filter(New | Working | Nurturing | Qualified));
        }
        view(HotLeads)
        {
            Caption = 'Hot Leads';
            Filters = where("Score Band" = const(Hot));
        }
    }

    trigger OnOpenPage()
    begin
        // Views are static filters defined above
        // Use actions (My Leads, My Teams Leads) for dynamic user-specific filters
    end;

    local procedure ApplyMyLeadsFilter()
    var
        UserSetup: Record "User Setup";
    begin
        // Get current user's salesperson code
        if not UserSetup.Get(UserId) then
            Error('User Setup not found for current user.');

        if UserSetup."Salespers./Purch. Code" = '' then
            Error('No Salesperson Code configured in User Setup.');

        // Filter: Assignment Type = Salesperson AND Salesperson Code = Current User
        Rec.FilterGroup(0);
        Rec.SetRange("Assignment Type", Rec."Assignment Type"::Salesperson);
        Rec.SetRange("Salesperson Code", UserSetup."Salespers./Purch. Code");
        Rec.SetFilter(Status, '%1|%2|%3|%4', Rec.Status::New, Rec.Status::Working, Rec.Status::Nurturing, Rec.Status::Qualified);
    end;

    local procedure ApplyMyTeamsLeadsFilter()
    var
        UserSetup: Record "User Setup";
        TeamSalesperson: Record "Team Salesperson";
        TeamFilter: Text;
    begin
        // Get current user's salesperson code
        if not UserSetup.Get(UserId) then
            Error('User Setup not found for current user.');

        if UserSetup."Salespers./Purch. Code" = '' then
            Error('No Salesperson Code configured in User Setup.');

        // Build filter for teams the user belongs to
        TeamSalesperson.SetRange("Salesperson Code", UserSetup."Salespers./Purch. Code");
        if TeamSalesperson.FindSet() then
            repeat
                if TeamFilter <> '' then
                    TeamFilter += '|';
                TeamFilter += TeamSalesperson."Team Code";
            until TeamSalesperson.Next() = 0;

        if TeamFilter = '' then
            Error('You are not a member of any teams.');

        // Filter: Assignment Type = Team AND Salesperson Code IN User's Teams
        Rec.FilterGroup(0);
        Rec.SetRange("Assignment Type", Rec."Assignment Type"::Team);
        Rec.SetFilter("Salesperson Code", TeamFilter);
        Rec.SetFilter(Status, '%1|%2|%3|%4', Rec.Status::New, Rec.Status::Working, Rec.Status::Nurturing, Rec.Status::Qualified);
    end;
}
