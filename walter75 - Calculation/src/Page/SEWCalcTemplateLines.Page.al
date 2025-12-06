page 90822 "SEW Calc Template Lines"
{
    Caption = 'Calculation Template Lines';
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "SEW Calc Template Line";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                IndentationColumn = Rec.Indentation;
                ShowAsTree = true;

                field("Template Code"; Rec."Template Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the template code this line belongs to';
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line number';
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of calculation line';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the calculation line';
                    StyleExpr = StyleTxt;
                }
                field(Formula; Rec.Formula)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the formula for calculation';
                }
                field("Variable Code"; Rec."Variable Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the variable code used in the formula';
                }
                field(Bold; Rec.Bold)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether to display the line in bold';
                }
                field("Show in Report"; Rec."Show in Report")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether to show this line in reports';
                }
            }
        }
    }

    var
        StyleTxt: Text;

    trigger OnAfterGetRecord()
    begin
        StyleTxt := '';
        if Rec.Bold then
            StyleTxt := 'Strong';
    end;
}
