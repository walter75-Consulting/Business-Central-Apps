table 91715 "SEW Lead Scoring Rule"
{
    Caption = 'Lead Scoring Rule';
    DataClassification = CustomerContent;
    LookupPageId = "SEW Lead Scoring Rules";
    DrillDownPageId = "SEW Lead Scoring Rules";

    fields
    {
        field(1; "Rule Code"; Code[20])
        {
            Caption = 'Rule Code';
            ToolTip = 'Specifies the unique code for the scoring rule.';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(2; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            ToolTip = 'Specifies the scoring model this rule belongs to.';
            TableRelation = "SEW Lead Scoring Model";
            DataClassification = CustomerContent;
        }
        field(10; Attribute; Enum "SEW Scoring Attribute")
        {
            Caption = 'Attribute';
            ToolTip = 'Specifies which lead attribute to evaluate.';
            DataClassification = CustomerContent;
        }
        field(11; Operator; Enum "SEW Scoring Operator")
        {
            Caption = 'Operator';
            ToolTip = 'Specifies the comparison operator.';
            DataClassification = CustomerContent;
        }
        field(12; Value; Text[100])
        {
            Caption = 'Value';
            ToolTip = 'Specifies the value to match against.';
            DataClassification = CustomerContent;
        }
        field(20; "Score Delta"; Integer)
        {
            Caption = 'Score Delta';
            ToolTip = 'Specifies the points to add (positive) or subtract (negative) when rule matches.';
            DataClassification = CustomerContent;
        }
        field(30; "Is Fit Score"; Boolean)
        {
            Caption = 'Is Fit Score';
            ToolTip = 'Specifies whether this contributes to Fit score (true) or Intent score (false).';
            DataClassification = CustomerContent;
            InitValue = true;
        }
    }

    keys
    {
        key(PK; "Rule Code", "Model Code")
        {
            Clustered = true;
        }
        key(SK1; "Model Code", "Is Fit Score")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Rule Code", Attribute, Operator, "Score Delta")
        {
        }
    }
}
