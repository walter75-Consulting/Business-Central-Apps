page 90832 "SEW Calc Lines"
{
    Caption = 'Calculation Lines';
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "SEW Calc Line";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                IndentationColumn = Rec.Indentation;
                ShowAsTree = true;

                field("Calc No."; Rec."Calc No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the calculation number this line belongs to';
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
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source type';
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source number';
                }
                field(Formula; Rec.Formula)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the formula for calculation';
                }
                field("Base Value"; Rec."Base Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the base value for calculation';
                }
                field("Factor / Percentage"; Rec."Factor / Percentage")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the factor or percentage applied';
                }
                field("Calculated Value"; Rec."Calculated Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the calculated result value';
                    StyleExpr = StyleTxt;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity';
                    Visible = false;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit cost';
                    Visible = false;
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
