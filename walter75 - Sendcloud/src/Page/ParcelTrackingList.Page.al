page 95714 "SEW Parcel Tracking List"
{
    ApplicationArea = All;
    Caption = 'Parcel Tracking List';
    PageType = List;
    SourceTable = "SEW Parcel Tracking";
    UsageCategory = None;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Editable = false;
    Extensible = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Parcel Status History ID"; Rec."Parcel Status History ID") { }
                field("SC Parcel ID"; Rec."SC Parcel ID") { }
                field("Carrier Update Timestamp"; Rec."Carrier Update Timestamp") { }
                field("Parent Status"; Rec."Parent Status") { }
                field("Carrier Message"; Rec."Carrier Message") { }
            }
        }
    }
}
