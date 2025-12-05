page 95701 "SEW Carrier Ship Met"
{
    Caption = 'SEW Shipping Method List';

    PageType = List;
    ApplicationArea = All;
    UsageCategory = None;

    SourceTable = "SEW Carrier Ship Met";
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
                field("Carrier Code"; Rec."Carrier Code")
                {
                }
                field("Shipment Method Name"; Rec."Shipment Method Name")
                {
                }
                field("Weight min"; Rec."Weight min")
                {
                }
                field("Weight max"; Rec."Weight max")
                {
                }

                field("Service Point Input"; Rec."Service Point Input")
                {
                }
                field("Nbr of Countries"; Rec."Nbr of Countries")
                {
                }
            }
        }
    }


    actions
    {

    }
}
