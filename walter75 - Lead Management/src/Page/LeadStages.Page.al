page 91729 "SEW Lead Stages"
{
    Caption = 'Lead Stages';
    PageType = List;
    SourceTable = "SEW Lead Stage";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Stage Code"; Rec."Stage Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique code for the lead stage.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the lead stage.';
                }
                field(Sequence; Rec.Sequence)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the sort order for this stage in the pipeline.';
                }
                field("Default Probability %"; Rec."Default Probability %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default win probability when a lead enters this stage.';
                }
                field("SLA (Hours)"; Rec."SLA (Hours)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the maximum hours a lead should remain in this stage.';
                }
                field("Is Closed"; Rec."Is Closed")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this is a terminal stage.';
                }
                field("Is Won"; Rec."Is Won")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this stage represents a successful close.';
                }
            }
        }
    }
}
