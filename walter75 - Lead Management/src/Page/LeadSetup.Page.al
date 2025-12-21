page 91712 "SEW Lead Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "SEW Lead Setup";
    Caption = 'Lead Setup';
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(Numbering)
            {
                Caption = 'Numbering';
                field("Lead No. Series"; Rec."Lead No. Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series used for lead numbering.';
                }
            }
            group(Defaults)
            {
                Caption = 'Defaults';
                field("Auto Create Contact On Working"; Rec."Auto Create Contact On Working")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether to automatically create a Contact when lead status changes to Working.';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            group(Configuration)
            {
                Caption = 'Configuration';
                Image = Setup;

                action(LeadStages)
                {
                    ApplicationArea = All;
                    Caption = 'Lead Stages';
                    ToolTip = 'Configure lead pipeline stages.';
                    Image = Stages;
                    RunObject = page "SEW Lead Stages";
                }
                action(LeadSources)
                {
                    ApplicationArea = All;
                    Caption = 'Lead Sources';
                    ToolTip = 'Configure lead sources and channels.';
                    Image = SNInfo;
                    RunObject = page "SEW Lead Sources";
                }
                action(LostReasons)
                {
                    ApplicationArea = All;
                    Caption = 'Lost Reasons';
                    ToolTip = 'Configure reasons for disqualifying leads.';
                    Image = ErrorLog;
                    RunObject = page "SEW Lost Reasons";
                }
            }
            group(Automation)
            {
                Caption = 'Automation';
                Image = SetupList;

                action(RoutingRules)
                {
                    ApplicationArea = All;
                    Caption = 'Routing Rules';
                    ToolTip = 'Configure automatic lead assignment rules.';
                    Image = Route;
                    RunObject = page "SEW Lead Routing Rules";
                }
                action(ScoringModels)
                {
                    ApplicationArea = All;
                    Caption = 'Scoring Models';
                    ToolTip = 'Configure lead scoring models and rules.';
                    Image = Calculate;
                    RunObject = page "SEW Lead Scoring Models";
                }
            }
            group(Reports)
            {
                Caption = 'Reports & Analytics';
                Image = "Report";

                action(LeadList)
                {
                    ApplicationArea = All;
                    Caption = 'All Leads';
                    ToolTip = 'View all leads in the system.';
                    Image = List;
                    RunObject = page "SEW Lead List";
                }
                action(LeadAnalytics)
                {
                    ApplicationArea = All;
                    Caption = 'Lead Analytics';
                    ToolTip = 'View lead analytics and KPIs.';
                    Image = Statistics;
                    RunObject = page "SEW Lead Analytics";
                }
                action(LeadKanban)
                {
                    ApplicationArea = All;
                    Caption = 'Lead Kanban Board';
                    ToolTip = 'View leads in Kanban board format.';
                    Image = TaskList;
                    RunObject = page "SEW Lead Kanban";
                }
                action(ConversionLog)
                {
                    ApplicationArea = All;
                    Caption = 'Conversion Log';
                    ToolTip = 'View lead to opportunity conversion history.';
                    Image = Entries;
                    RunObject = page "SEW Lead Conversion Log";
                }
                action(AssignmentLog)
                {
                    ApplicationArea = All;
                    Caption = 'Assignment Log';
                    ToolTip = 'View automatic lead assignment history.';
                    Image = AssemblyBOM;
                    RunObject = page "SEW Lead Assignment Log";
                }
            }
        }
        area(Processing)
        {
            action(CreateDemoData)
            {
                ApplicationArea = All;
                Caption = 'Create Demo Data';
                ToolTip = 'Creates demo data including number series, stages, sources, sample leads, and activities for testing and demonstration purposes.';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    DemoDataMgt: Codeunit "SEW Demo Data Mgt.";
                begin
                    DemoDataMgt.CreateDemoData();
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
