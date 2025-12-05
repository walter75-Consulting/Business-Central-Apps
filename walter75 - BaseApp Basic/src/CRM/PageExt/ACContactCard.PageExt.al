pageextension 80002 "SEW AC Contact Card" extends "Contact Card"
{
    layout
    {
        addafter("Territory Code")
        {
            field("SEW Territory manually"; Rec."SEW Territory manually")
            {
                ApplicationArea = All;
            }
            field("SEW Service Zone Code"; Rec."SEW Service Zone Code")
            {
                ApplicationArea = Service;
            }
            field("SEW Service Zone manually"; Rec."SEW Service Zone manually")
            {
                ApplicationArea = Service;
            }
        }
        addafter("Salesperson Code")
        {
            field("SEW Salesperson manually"; Rec."SEW Salesperson manually")
            {
                ApplicationArea = All;
            }
        }
        addafter(General)
        {
            part(SEWPersonSubform; "SEW ContactCard Contacs Sub")
            {
                Visible = SEWIsCompanyContact;
                ApplicationArea = all;
                Caption = 'Contact Persons';
                SubPageLink = "Company No." = field("Company No."), Type = const("Contact Type"::Person);
            }
        }
        addlast(General)
        {
            group("SEW Customer")
            {
                Caption = 'Customer / Vendor';

                field("SEW Customer No."; Rec."SEW Customer No.")
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        SEWACActionsPage: Codeunit "SEW AC Actions Page";
                    begin
                        SEWACActionsPage.OpenCustomerCard(Rec."SEW Customer No.");
                    end;
                }
                field("SEW Vendor No."; Rec."SEW Vendor No.")
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        SEWACActionsPage: Codeunit "SEW AC Actions Page";
                    begin
                        SEWACActionsPage.OpenVendorCard(Rec."SEW Vendor No.");
                    end;
                }
            }
        }
    }

    actions
    {
        addlast(processing)
        {
            action("SEW CreatePersonContact")
            {
                Caption = 'create Contact Person';
                ToolTip = 'Executes the action "create Contact Person".';
                ApplicationArea = All;
                Visible = SEWIsCompanyContact;
                Image = ContactPerson;
                RunObject = page "Contact Card";
                RunPageMode = Create;
                RunPageLink = "Company No." = field("No."), "Type" = filter(Type::Person);
            }
        }
        addlast(Category_Process)
        {
            actionref(CreatePersonContact_Promoted; "SEW CreatePersonContact") { }
        }
    }


    trigger OnAfterGetCurrRecord()
    begin
        SEWIsCompanyContact := false;
        SEWIsCompanyContact := (Rec.Type = Rec.Type::Company);
    end;

    var
        SEWIsCompanyContact: Boolean;
}
