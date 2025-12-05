pageextension 95700 "SEW Shipping Agents" extends "Shipping Agents"
{
    layout
    {
        addafter(Name)
        {
            field("SEW Sendcloud ID"; Rec."SEW sendCloudID")
            {
                ApplicationArea = All;
            }
        }
    }


}
