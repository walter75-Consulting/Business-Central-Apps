/// <summary>
/// Page SEW Lead Analytics (ID 91765).
/// Comprehensive analytics dashboard with key performance metrics.
/// Provides overview of lead pipeline health and conversion rates.
/// </summary>
page 91765 "SEW Lead Analytics"
{
    PageType = HeadlinePart;
    Caption = 'Lead Analytics';
    RefreshOnActivate = true;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    layout
    {
        area(Content)
        {
            group(Overview)
            {
                Caption = 'Pipeline Overview';

                field(TotalLeads; TotalLeadsCount)
                {
                    ApplicationArea = All;
                    Caption = 'Total Active Leads';
                    ToolTip = 'Total number of active leads (excluding converted and disqualified).';
                    DrillDown = true;
                    StyleExpr = true;
                    Style = Strong;

                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"SEW Lead List");
                    end;
                }
                field(TotalPipelineValue; TotalPipelineValue)
                {
                    ApplicationArea = All;
                    Caption = 'Pipeline Value';
                    ToolTip = 'Total estimated revenue from active leads.';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"SEW Lead List");
                    end;
                }
                field(HotLeads; HotLeadsCount)
                {
                    ApplicationArea = All;
                    Caption = 'Hot Leads';
                    ToolTip = 'Number of leads with high engagement score.';
                    DrillDown = true;
                    Style = Favorable;
                    StyleExpr = HotLeadsCount > 0;

                    trigger OnDrillDown()
                    var
                        Lead: Record "SEW Lead";
                    begin
                        Lead.SetRange("Score Band", Lead."Score Band"::Hot);
                        Lead.SetFilter(Status, '<>%1&<>%2', Lead.Status::Converted, Lead.Status::Disqualified);
                        Page.Run(Page::"SEW Lead List", Lead);
                    end;
                }
                field(AverageScore; AverageLeadScore)
                {
                    ApplicationArea = All;
                    Caption = 'Average Score';
                    ToolTip = 'Average engagement score across all active leads.';
                    DecimalPlaces = 0 : 0;
                }
            }
            group(Conversion)
            {
                Caption = 'Conversion Metrics';

                field(ConversionRate; ConversionRatePct)
                {
                    ApplicationArea = All;
                    Caption = 'Conversion Rate';
                    ToolTip = 'Percentage of leads converted to opportunities.';
                    DecimalPlaces = 1 : 1;
                    Style = Favorable;
                    StyleExpr = ConversionRatePct >= 10;
                }
                field(ConvertedLeads; ConvertedLeadsCount)
                {
                    ApplicationArea = All;
                    Caption = 'Converted Leads (30d)';
                    ToolTip = 'Number of leads converted to opportunities in the last 30 days.';
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        LeadToOppMap: Record "SEW Lead→Opportunity Map";
                    begin
                        LeadToOppMap.SetRange(SystemCreatedAt, CreateDateTime(CalcDate('<-30D>', Today()), 0T), CreateDateTime(Today(), 235959T));
                        Page.Run(Page::"SEW Lead Conversion Log", LeadToOppMap);
                    end;
                }
                field(TotalOpportunityValue; TotalOpportunityValue)
                {
                    ApplicationArea = All;
                    Caption = 'Opportunity Value (30d)';
                    ToolTip = 'Total value of opportunities created from leads in the last 30 days.';
                }
            }
            group(Activities)
            {
                Caption = 'Activity Metrics';

                field(OpenActivities; OpenActivitiesCount)
                {
                    ApplicationArea = All;
                    Caption = 'Open Activities';
                    ToolTip = 'Number of incomplete lead activities.';
                    Style = Attention;
                    StyleExpr = OpenActivitiesCount > 0;
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        Activity: Record "SEW Lead Activity";
                    begin
                        Activity.SetRange(Completed, false);
                        Page.Run(Page::"SEW Lead Activity List", Activity);
                    end;
                }
                field(OverdueActivities; OverdueActivitiesCount)
                {
                    ApplicationArea = All;
                    Caption = 'Overdue Activities';
                    ToolTip = 'Number of activities past their due date.';
                    Style = Unfavorable;
                    StyleExpr = OverdueActivitiesCount > 0;
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        Activity: Record "SEW Lead Activity";
                    begin
                        Activity.SetRange(Completed, false);
                        Activity.SetFilter("Due Date", '<%1', Today());
                        Page.Run(Page::"SEW Lead Activity List", Activity);
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RefreshData)
            {
                ApplicationArea = All;
                Caption = 'Refresh';
                ToolTip = 'Refresh analytics data.';
                Image = Refresh;

                trigger OnAction()
                begin
                    CalculateMetrics();
                    CurrPage.Update(false);
                end;
            }
            action(LeadList)
            {
                ApplicationArea = All;
                Caption = 'Lead List';
                ToolTip = 'Open the lead list.';
                Image = List;

                trigger OnAction()
                begin
                    Page.Run(Page::"SEW Lead List");
                end;
            }
            action(FunnelReport)
            {
                ApplicationArea = All;
                Caption = 'Funnel Analysis';
                ToolTip = 'View lead funnel analysis query.';

                trigger OnAction()
                var
                    LeadFunnelAnalysis: Query "SEW Lead Funnel Analysis";
                begin
                    LeadFunnelAnalysis.Open();
                    if LeadFunnelAnalysis.Read() then;
                end;
            }
            action(SourcePerformance)
            {
                ApplicationArea = All;
                Caption = 'Source Performance';
                ToolTip = 'View source performance query.';
                Image = SourceDocLine;

                trigger OnAction()
                var
                    SourcePerformance: Query "SEW Source Performance";
                begin
                    SourcePerformance.Open();
                    if SourcePerformance.Read() then;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        CalculateMetrics();
    end;

    local procedure CalculateMetrics()
    var
        Lead: Record "SEW Lead";
        LeadToOppMap: Record "SEW Lead→Opportunity Map";
        Activity: Record "SEW Lead Activity";
        TotalLeads: Integer;
    begin
        // Active leads metrics
        Lead.SetFilter(Status, '<>%1&<>%2', Lead.Status::Converted, Lead.Status::Disqualified);
        TotalLeadsCount := Lead.Count();
        Lead.CalcSums("Expected Revenue", "Score (Total)");
        TotalPipelineValue := Lead."Expected Revenue";
        if TotalLeadsCount > 0 then
            AverageLeadScore := Lead."Score (Total)" / TotalLeadsCount
        else
            AverageLeadScore := 0;

        // Hot leads
        Lead.SetRange("Score Band", Lead."Score Band"::Hot);
        HotLeadsCount := Lead.Count();
        Lead.SetRange("Score Band");

        // All leads for conversion rate calculation
        Lead.Reset();
        TotalLeads := Lead.Count();

        // Conversion metrics (last 30 days)
        LeadToOppMap.SetRange(SystemCreatedAt, CreateDateTime(CalcDate('<-30D>', Today()), 0T), CreateDateTime(Today(), 235959T));
        ConvertedLeadsCount := LeadToOppMap.Count();
        LeadToOppMap.CalcSums("Expected Revenue");
        TotalOpportunityValue := LeadToOppMap."Expected Revenue";

        // Overall conversion rate
        if TotalLeads > 0 then begin
            LeadToOppMap.Reset();
            ConversionRatePct := (LeadToOppMap.Count() / TotalLeads) * 100;
        end else
            ConversionRatePct := 0;

        // Activity metrics
        Activity.SetRange(Completed, false);
        OpenActivitiesCount := Activity.Count();
        Activity.SetFilter("Due Date", '<%1', Today());
        OverdueActivitiesCount := Activity.Count();
    end;

    var
        TotalLeadsCount: Integer;
        TotalPipelineValue: Decimal;
        HotLeadsCount: Integer;
        AverageLeadScore: Decimal;
        ConvertedLeadsCount: Integer;
        TotalOpportunityValue: Decimal;
        ConversionRatePct: Decimal;
        OpenActivitiesCount: Integer;
        OverdueActivitiesCount: Integer;
}
