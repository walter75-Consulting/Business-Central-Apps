pageextension 91400 "SEW Shipping Agents" extends "Shipping Agents"
{
    layout
    {
        addafter("Account No.")
        {
            field("SEW Freight Billing Type"; Rec."SEW Freight Billing Type")
            {
                ApplicationArea = All;
            }
            field("SEW Freight Billing No."; Rec."SEW Freight Billing No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
