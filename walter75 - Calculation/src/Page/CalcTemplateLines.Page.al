page 90822 "SEW Calc Template Lines"
{
    Caption = 'Calculation Template Lines';
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "SEW Calc Template Line";
    AutoSplitKey = true;
    DelayedInsert = true;
    InsertAllowed = true;
    DeleteAllowed = true;
    ModifyAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                IndentationColumn = Rec.Indentation;
                IndentationControls = Description;

                field("Template Code"; Rec."Template Code")
                {
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                }
                field(Description; Rec.Description)
                {
                    StyleExpr = StyleTxt;
                }
                field(Indentation; Rec.Indentation)
                {
                }
                field(Formula; Rec.Formula)
                {
                }
                field("Variable Code"; Rec."Variable Code")
                {
                }
                field(Bold; Rec.Bold)
                {
                }
                field("Show in Report"; Rec."Show in Report")
                {
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
            StyleTxt := Format(PageStyle::Strong);
    end;
}
