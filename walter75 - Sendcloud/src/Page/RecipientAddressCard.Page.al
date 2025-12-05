page 95713 "SEW Recipient Address Card"
{
    ApplicationArea = All;
    Caption = 'Recipient Address Card';
    PageType = Card;
    SourceTable = "SEW Recipient Address";
    DelayedInsert = true;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Recipient No."; Rec."Recipient No.")
                {
                }
                field("Name 1"; Rec."Name 1")
                {
                }
                field("Name 2"; Rec."Name 2")
                {
                }
                field(Street; Rec.Street)
                {
                }
                field("House Nbr."; Rec."House Nbr.")
                {
                }
                field(CountryCode; Rec.CountryCode)
                {
                }
                field(PostalCode; Rec.PostalCode)
                {
                }
                field(City; Rec.City)
                {
                }
                field(CountryState; Rec.CountryState)
                {
                }
                field(ContactName; Rec.ContactName)
                {
                }
                field(Phone; Rec.Phone)
                {
                }
                field(Email; Rec.Email)
                {
                }
            }
        }
    }
}
