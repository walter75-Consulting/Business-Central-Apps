pageextension 80018 "SEW AP Vendor List" extends "Vendor List"
{
    layout
    {
        addlast(Control1)
        {
            field("SEW SearchDescription"; Rec."SEW Search Description")
            {
                ApplicationArea = All;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if Rec.FindSet() then
            repeat
                if Rec."SEW Search Description" = '' then begin
                    Rec."SEW Search Description" := CopyStr(Rec."Search Name" + ' ' + Rec."Post Code", 1, MaxStrLen(Rec."SEW Search Description"));
                    Rec.Modify(false);
                end;
            until Rec.Next() = 0;
    end;
}
