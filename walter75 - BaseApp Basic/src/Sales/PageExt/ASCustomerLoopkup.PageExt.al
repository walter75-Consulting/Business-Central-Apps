pageextension 80015 "SEW AS Customer Loopkup" extends "Customer Lookup"
{
    layout
    {
        addafter("Name")
        {
            field("SEW Name 2"; Rec."Name 2")
            {
                ApplicationArea = All;
            }
        }
        addlast(Group)
        {
            field("SEW SearchDescription"; Rec."SEW Search Description")
            {
                ApplicationArea = All;
            }
        }
    }
}
