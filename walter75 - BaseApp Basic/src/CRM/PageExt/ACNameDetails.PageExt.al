pageextension 80003 "SEW AC Name Details" extends "Name Details"
{
    layout
    {
        addafter(Initials)
        {
            field("SEW Contact Title"; Rec."SEW Contact Title")
            {
                ApplicationArea = All;
                trigger OnValidate()
                var
                    TempSEWContactTitle: Record "SEW Contact Title" temporary;
                begin
                    if not TempSEWContactTitle.Get(Rec."SEW Contact Title") then
                        Error(ErrNoContactTitleLbl, Rec."SEW Contact Title");
                    Rec.Initials := TempSEWContactTitle.Description;
                end;
            }
        }

        modify(Initials)
        {
            Visible = false;
            Editable = false;
        }
    }
    var
        ErrNoContactTitleLbl: Label 'No Contact Title found for %1', Comment = '%1 - SEW Contact Title';
}
