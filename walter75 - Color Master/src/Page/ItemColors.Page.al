page 91600 "SEW Item Colors"
{
    Caption = 'Item Colors';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "SEW Item Colors";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
            }
        }
    }
}