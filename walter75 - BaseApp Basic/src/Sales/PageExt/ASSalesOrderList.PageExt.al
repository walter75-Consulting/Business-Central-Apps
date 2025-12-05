pageextension 80062 "SEW AS Sales Order List" extends "Sales Order List"
{
    layout
    {
        addbefore(Status)
        {
            field("SEW Blanket Order No."; Rec."SEW Blanket Order No.")
            {
                ApplicationArea = All;
            }
        }
    }
}