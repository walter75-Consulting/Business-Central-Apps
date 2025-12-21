page 91760 "SEW Lead Routing Rules"
{
    Caption = 'Lead Routing Rules';
    PageType = List;
    SourceTable = "SEW Lead Routing Rule";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Rule Code"; Rec."Rule Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique code for the routing rule.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the descriptive name of the routing rule.';
                }
                field("Rule Type"; Rec."Rule Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of routing logic to apply.';
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this routing rule is currently active.';
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the priority of this rule (1 = highest).';
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the lead source filter for SourceBased rule type.';
                    Visible = false;
                }
                field("Territory Code"; Rec."Territory Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the territory filter for Territory rule type.';
                    Visible = false;
                }
                field("Min Score"; Rec."Min Score")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the minimum score for ScoreThreshold rule type.';
                    Visible = false;
                }
                field("Max Score"; Rec."Max Score")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the maximum score for ScoreThreshold rule type.';
                    Visible = false;
                }
                field("Assignment Type"; Rec."Assignment Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether to assign to salesperson or team.';
                }
                field("Assigned To Code"; Rec."Assigned To Code")
                {
                    ApplicationArea = All;
                    Caption = 'Assigned To';
                    ToolTip = 'Specifies the salesperson or team code to assign.';
                }
                field("Assigned To Name"; Rec."Assigned To Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the salesperson or team.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(TestRule)
            {
                Caption = 'Test Rule';
                Image = TestReport;
                ToolTip = 'Test this routing rule against existing leads.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    TestRuleMsg: Label 'Testing rule: %1', Comment = 'DE="Teste Regel: %1"';
                begin
                    Message(TestRuleMsg, Rec.Name);
                end;
            }
        }
    }
}
