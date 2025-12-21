page 91723 "SEW Lead Scoring Rules"
{
    Caption = 'Lead Scoring Rules';
    PageType = List;
    SourceTable = "SEW Lead Scoring Rule";
    UsageCategory = None;
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
                    ToolTip = 'Specifies the unique code for the scoring rule.';
                }
                field("Model Code"; Rec."Model Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the scoring model this rule belongs to.';
                }
                field(Attribute; Rec.Attribute)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies which lead attribute to evaluate.';
                }
                field(Operator; Rec.Operator)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the comparison operator.';
                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value to match against.';
                }
                field("Score Delta"; Rec."Score Delta")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the points to add (positive) or subtract (negative) when rule matches.';
                }
                field("Is Fit Score"; Rec."Is Fit Score")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this contributes to Fit score (true) or Intent score (false).';
                }
            }
        }
    }
}
