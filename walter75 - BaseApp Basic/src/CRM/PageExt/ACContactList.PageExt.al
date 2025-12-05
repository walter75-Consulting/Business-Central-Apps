pageextension 80017 "SEW AC Contact List" extends "Contact List"
{
    layout
    {
        addafter("Territory Code")
        {
            field("SEW Service Zone Code"; Rec."SEW Service Zone Code")
            {
                ApplicationArea = Service;
            }

        }
        addlast(Control1)
        {

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