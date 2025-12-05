pageextension 91301 "SEW Contact List" extends "Contact List"
{
    layout
    {
        addafter(Control128)
        {
            part(SEWFactBoxContactRelation; "SEW FB Contact Relation")
            {
                Visible = isCompany;
                Caption = 'Contact Relation';
                ApplicationArea = RelationshipMgmt;
                SubPageLink = "Contact No. from" = field("No.");
            }
        }
    }

    actions
    {
        addlast("Related Information")
        {
            action("SEW SEWContactRelations")
            {
                ApplicationArea = Suite;
                Caption = 'Edit Relations';
                ToolTip = 'Edit Relations.';
                Image = EditCustomer;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Visible = isCompany;

                trigger OnAction()
                var
                    SEWContactRelations: Record "SEW Contact Relations";
                begin
                    SEWContactRelations.Reset();
                    SEWContactRelations.SetRange("Contact No. from", Rec."No.");
                    Page.RunModal(Page::"SEW Contact Relation", SEWContactRelations);
                end;
            }
        }

    }

    var
        isCompany: Boolean;

    trigger OnAfterGetCurrRecord()
    begin
        isCompany := false;
        if Rec.Type = "Contact Type"::Company then
            isCompany := true;
    end;
}
