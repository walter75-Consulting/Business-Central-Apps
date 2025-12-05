page 95702 "SEW Carrier Ship Met Cntry"
{
    Caption = 'SEW Shipping Method Cntry List';

    PageType = List;
    ApplicationArea = All;
    UsageCategory = None;

    SourceTable = "SEW Carrier Ship Met Cntry";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(ID; Rec.ID)
                {
                }
                field("Shipping Method ID"; Rec."Shipping Method ID")
                {
                }
                field("ISO 2"; Rec."ISO 2")
                {
                }
                field("ISO 3"; Rec."ISO 3")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field("Lead Time_Hours"; Rec."Lead Time_Hours")
                {
                }
                field(Price; Rec.Price)
                {
                }
                field("Nbr of Prices"; Rec."Nbr of Prices")
                {
                }
            }
        }
    }
}
