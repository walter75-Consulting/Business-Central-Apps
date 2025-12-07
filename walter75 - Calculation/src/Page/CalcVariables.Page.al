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
                }
                field(Description; Rec.Description)
                {
                }
                field(Type; Rec.Type)
                {
                }
                field(Value; Rec.Value)
                {
                }
                field(Base; Rec.Base)
                {
                }
                field("Valid From Date"; Rec."Valid From Date")
                {
                }
                field("Valid To Date"; Rec."Valid To Date")
                {
                }
                field(Global; Rec.Global)
                {
                }
            }
        }
    }
}
