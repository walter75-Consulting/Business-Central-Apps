page 90709 "SEW Package Setup"
{
    ApplicationArea = All;
    Caption = 'Package Setup';
    PageType = Card;
    SourceTable = "SEW Package Setup";
    UsageCategory = Administration;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                //field("SEW Parcel Start with Box"; Rec."SEW Parcel Start with Box") { }
                //field("SEW Parcel with pack slip"; Rec."SEW Parcel with pack slip") { }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.InsertIfNotExists();
    end;
}
