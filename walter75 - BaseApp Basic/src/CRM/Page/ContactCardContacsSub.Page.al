page 80001 "SEW ContactCard Contacs Sub"
{

    Caption = 'Contact Subpage';
    PageType = ListPart;
    SourceTable = Contact;
    SourceTableView = sorting("Surname") order(descending);
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    RefreshOnActivate = true;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {

                    ToolTip = 'Specifies the contact number.';
                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"Contact Card", Rec);
                    end;
                }
                field("Salutation Code"; Rec."Salutation Code")
                {

                    ToolTip = 'Specifies the salutation code for the contact.';
                }
                field(Initials; Rec.Initials)
                {

                    ToolTip = 'Specifies the initials of the contact.';
                }
                field("First Name"; Rec."First Name")
                {

                    ToolTip = 'Specifies the first name of the contact.';
                }
                field("Middle Name"; Rec."Middle Name")
                {

                    ToolTip = 'Specifies the middle name of the contact.';
                    Visible = false;
                }
                field(Surname; Rec.Surname)
                {

                    ToolTip = 'Specifies the surname of the contact.';
                }
                field("Phone No."; Rec."Phone No.")
                {

                    ToolTip = 'Specifies the phone number of the contact.';
                }
                field("E-Mail"; Rec."E-Mail")
                {

                    ToolTip = 'Specifies the email address of the contact.';
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {

                    ToolTip = 'Specifies the mobile phone number of the contact.';
                }
                field(Type; Rec.Type)
                {

                    ToolTip = 'Specifies the type of contact.';
                    Visible = false;
                }
                field("Company No."; Rec."Company No.")
                {

                    ToolTip = 'Specifies the company number associated with the contact.';
                    Visible = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("SEW CreatePersonContact")
            {
                Caption = 'create Contact Person';
                ToolTip = 'Executes the action "create Contact Person".';

                Image = ContactPerson;
                RunObject = page "Contact Card";
                RunPageMode = Create;
                RunPageLink = "Company No." = field("Company No."), "Type" = filter(Type::Person);
            }
        }

    }
}
