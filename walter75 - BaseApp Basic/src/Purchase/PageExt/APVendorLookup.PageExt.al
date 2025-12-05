pageextension 80019 "SEW AP Vendor Lookup" extends "Vendor Lookup"
{
    layout
    {
        addafter("Name")
        {
            field("SEW Name 2"; Rec."Name 2")
            {
                ToolTip = 'Specifies the value of Name 2 Field.';
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
