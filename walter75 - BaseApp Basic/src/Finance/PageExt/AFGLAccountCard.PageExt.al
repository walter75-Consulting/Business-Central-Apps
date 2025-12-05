pageextension 80057 "SEW AF G/L Account Card" extends "G/L Account Card"
{
    layout
    {
        addafter(General)
        {
            group("SEW AddInfo")
            {
                Caption = 'Additional Info';
                field("SEW Account purpose"; Rec."SEW Account purpose")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}