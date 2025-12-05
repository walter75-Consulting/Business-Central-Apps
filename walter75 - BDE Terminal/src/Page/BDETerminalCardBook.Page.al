page 90603 "SEW BDE Terminal Card Book"
{
    Caption = 'Bookings';
    //AutoSplitKey = true;
    //DelayedInsert = false;
    LinksAllowed = false;
    //MultipleNewLines = false;
    PageType = ListPart;
    SourceTable = "SEW BDE Booking";
    //Editable = false;
    //InsertAllowed = false;
    //DeleteAllowed = false;
    RefreshOnActivate = true;



    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Caption = 'Bookings';
                //ShowCaption = false;
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    ApplicationArea = All;
                }
                field("Operation No."; Rec."Operation No.")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("BDE Rout. Line Status Start"; Rec."BDE Rout. Line Status Start")
                {
                    ApplicationArea = All;
                }
                field("User Start"; Rec."User Start")
                {
                    ApplicationArea = All;
                }
                field("Starting Date/Time"; Rec."Starting Date/Time")
                {
                    ApplicationArea = All;
                }
                field("BDE Rout. Line Status Stop"; Rec."BDE Rout. Line Status Stop")
                {
                    ApplicationArea = All;
                }
                field("User Stop"; Rec."User Stop")
                {
                    ApplicationArea = All;
                }
                field("Ending Date/Time"; Rec."Ending Date/Time")
                {
                    ApplicationArea = All;
                }
                field("Duration Minutes"; Rec."Duration Minutes")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}