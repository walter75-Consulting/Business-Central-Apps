/// <summary>
/// Page SEW Lead Analytics Role Center (ID 91766).
/// Role Center part for embedding analytics into user home pages.
/// Can be added to custom Role Centers or used as standalone dashboard.
/// </summary>
page 91766 "SEW Lead Analytics RC"
{
    PageType = CardPart;
    Caption = 'Lead Analytics';
    SourceTable = "SEW Lead";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            cuegroup(Pipeline)
            {
                Caption = 'Pipeline';

                field("Active Leads"; ActiveLeadsCount)
                {
                    ApplicationArea = All;
                    Caption = 'Active Leads';
                    ToolTip = 'Number of active leads in the pipeline.';
                    DrillDownPageId = "SEW Lead List";
                    StyleExpr = 'Favorable';

                    trigger OnDrillDown()
                    var
                        Lead: Record "SEW Lead";
                    begin
                        Lead.SetFilter(Status, '<>%1&<>%2', Lead.Status::Converted, Lead.Status::Disqualified);
                        Page.Run(Page::"SEW Lead List", Lead);
                    end;
                }
                field("Hot Leads"; HotLeadsCount)
                {
                    ApplicationArea = All;
                    Caption = 'Hot Leads';
                    ToolTip = 'Leads with high engagement score.';
                    DrillDownPageId = "SEW Lead List";
                    StyleExpr = 'Attention';

                    trigger OnDrillDown()
                    var
                        Lead: Record "SEW Lead";
                    begin
                        Lead.SetRange("Score Band", Lead."Score Band"::Hot);
                        Lead.SetFilter(Status, '<>%1&<>%2', Lead.Status::Converted, Lead.Status::Disqualified);
                        Page.Run(Page::"SEW Lead List", Lead);
                    end;
                }
                field("New Leads"; NewLeadsCount)
                {
                    ApplicationArea = All;
                    Caption = 'New Leads (7d)';
                    ToolTip = 'Leads created in the last 7 days.';
                    DrillDownPageId = "SEW Lead List";

                    trigger OnDrillDown()
                    var
                        Lead: Record "SEW Lead";
                    begin
                        Lead.SetRange(SystemCreatedAt, CreateDateTime(CalcDate('<-7D>', Today()), 0T), CreateDateTime(Today(), 235959T));
                        Page.Run(Page::"SEW Lead List", Lead);
                    end;
                }
            }
            cuegroup(Activities)
            {
                Caption = 'Activities';

                field("Open Activities"; OpenActivitiesCount)
                {
                    ApplicationArea = All;
                    Caption = 'Open Activities';
                    ToolTip = 'Incomplete lead activities.';
                    DrillDownPageId = "SEW Lead Activity List";
                    StyleExpr = 'Attention';

                    trigger OnDrillDown()
                    var
                        Activity: Record "SEW Lead Activity";
                    begin
                        Activity.SetRange(Completed, false);
                        Page.Run(Page::"SEW Lead Activity List", Activity);
                    end;
                }
                field("Overdue"; OverdueActivitiesCount)
                {
                    ApplicationArea = All;
                    Caption = 'Overdue';
                    ToolTip = 'Activities past their due date.';
                    DrillDownPageId = "SEW Lead Activity List";
                    StyleExpr = 'Unfavorable';

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
            cuegroup(Performance)
            {
                Caption = 'Performance';

                field("Converted (30d)"; ConvertedLeadsCount)
                {
                    ApplicationArea = All;
                    Caption = 'Converted (30d)';
                    ToolTip = 'Leads converted to opportunities in the last 30 days.';
                    StyleExpr = 'Favorable';

                    trigger OnDrillDown()
                    var
                        LeadToOppMap: Record "SEW Lead→Opportunity Map";
                    begin
                        LeadToOppMap.SetRange(SystemCreatedAt, CreateDateTime(CalcDate('<-30D>', Today()), 0T), CreateDateTime(Today(), 235959T));
                        Page.Run(Page::"SEW Lead Conversion Log", LeadToOppMap);
                    end;
                }
                field("Conversion Rate"; ConversionRatePct)
                {
                    ApplicationArea = All;
                    Caption = 'Conversion Rate';
                    ToolTip = 'Overall lead to opportunity conversion rate.';
                    DecimalPlaces = 1 : 1;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(LeadList)
            {
                ApplicationArea = All;
                Caption = 'Lead List';
                ToolTip = 'Open the lead list.';
                Image = List;
                RunObject = page "SEW Lead List";
            }
            action(Analytics)
            {
                ApplicationArea = All;
                Caption = 'Analytics Dashboard';
                ToolTip = 'Open the full analytics dashboard.';
                Image = Statistics;
                RunObject = page "SEW Lead Analytics";
            }
            action(Kanban)
            {
                ApplicationArea = All;
                Caption = 'Kanban Board';
                ToolTip = 'Open the Kanban board.';
                Image = TaskList;
                RunObject = page "SEW Lead Kanban";
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.FindFirst() then
            Rec.Init();
        CalculateCues();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CalculateCues();
    end;

    local procedure CalculateCues()
    var
        Lead: Record "SEW Lead";
        LeadToOppMap: Record "SEW Lead→Opportunity Map";
        Activity: Record "SEW Lead Activity";
        TotalLeads: Integer;
    begin
        // Active leads
        Lead.SetFilter(Status, '<>%1&<>%2', Lead.Status::Converted, Lead.Status::Disqualified);
        ActiveLeadsCount := Lead.Count();

        // Hot leads
        Lead.SetRange("Score Band", Lead."Score Band"::Hot);
        HotLeadsCount := Lead.Count();
        Lead.SetRange("Score Band");

        // New leads (last 7 days)
        Lead.SetRange(SystemCreatedAt, CreateDateTime(CalcDate('<-7D>', Today()), 0T), CreateDateTime(Today(), 235959T));
        NewLeadsCount := Lead.Count();
        Lead.SetRange(SystemCreatedAt);

        // Activities
        Activity.SetRange(Completed, false);
        OpenActivitiesCount := Activity.Count();
        Activity.SetFilter("Due Date", '<%1', Today());
        OverdueActivitiesCount := Activity.Count();

        // Conversion metrics
        LeadToOppMap.SetRange(SystemCreatedAt, CreateDateTime(CalcDate('<-30D>', Today()), 0T), CreateDateTime(Today(), 235959T));
        ConvertedLeadsCount := LeadToOppMap.Count();

        // Overall conversion rate
        Lead.Reset();
        TotalLeads := Lead.Count();
        if TotalLeads > 0 then begin
            LeadToOppMap.Reset();
            ConversionRatePct := (LeadToOppMap.Count() / TotalLeads) * 100;
        end else
            ConversionRatePct := 0;
    end;

    var
        ActiveLeadsCount: Integer;
        HotLeadsCount: Integer;
        NewLeadsCount: Integer;
        OpenActivitiesCount: Integer;
        OverdueActivitiesCount: Integer;
        ConvertedLeadsCount: Integer;
        ConversionRatePct: Decimal;
}
