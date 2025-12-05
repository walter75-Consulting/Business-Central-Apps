page 95712 "SEW Recipient Address List"
{
    ApplicationArea = All;
    Caption = 'Recipient Address List';
    PageType = List;
    SourceTable = "SEW Recipient Address";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
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
