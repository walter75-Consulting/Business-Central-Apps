pageextension 95701 "SEW Shipping Agent Services" extends "Shipping Agent Services"
{
    layout
    {
        addafter(Description)
        {
            field("SEW Sendcloud ID"; Rec."SEW sendCloudID")
            {
                ApplicationArea = All;
            }
        }
    }


}
