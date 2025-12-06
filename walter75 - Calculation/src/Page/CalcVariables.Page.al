page 90823 "SEW Calc Variables"
{
    Caption = 'Calculation Variables';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "SEW Calc Variable";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique code for the variable';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the variable';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of variable';
                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the variable';
                }
                field(Base; Rec.Base)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies what the variable is based on';
                }
                field("Valid From Date"; Rec."Valid From Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies from which date this variable value is valid';
                }
                field("Valid To Date"; Rec."Valid To Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies until which date this variable value is valid';
                }
                field(Global; Rec.Global)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this variable is globally available';
                }
            }
        }
    }
}
