page 90832 "SEW Calc Lines"
{
    Caption = 'Calculation Lines';
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "SEW Calc Line";
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

                field("Calc No."; Rec."Calc No.")
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
                field("Source Type"; Rec."Source Type")
                {
                }
                field("Source No."; Rec."Source No.")
                {
                }
                field(Formula; Rec.Formula)
                {
                }
                field("Base Value"; Rec."Base Value")
                {
                }
                field("Factor / Percentage"; Rec."Factor / Percentage")
                {
                }
                field("Calculated Value"; Rec."Calculated Value")
                {
                    StyleExpr = StyleTxt;
                }
                field(Amount; Rec.Amount)
                {
                    StyleExpr = StyleTxt;
                }
                field(Quantity; Rec.Quantity)
                {
                    Visible = false;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
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
            StyleTxt := Format(PageStyle::Strong);
    end;
}
