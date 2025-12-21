codeunit 91721 "SEW Lead-Contact Sync"
{
    Access = Public;

    procedure CreateOrLinkContact(var SEWLeadRec: Record "SEW Lead")
    var
        ContactRec: Record Contact;
        ContactFound: Boolean;
        SalespersonCode: Code[20];
    begin
        if SEWLeadRec."Contact No." <> '' then
            exit; // Already linked

        // Get current user's salesperson code (needed for contact and assignment)
        SalespersonCode := GetCurrentUserSalespersonCode();

        // Try to find existing contact
        ContactFound := FindExistingContact(SEWLeadRec, ContactRec);

        if ContactFound then begin
            // Link to existing contact
            SEWLeadRec.Validate("Contact No.", ContactRec."No.");
            SEWLeadRec.Modify(true);
            ClearQuickFields(SEWLeadRec);
        end else begin
            // Create new contact
            CreateContactFromLead(SEWLeadRec, ContactRec, SalespersonCode);
            SEWLeadRec.Validate("Contact No.", ContactRec."No.");
            SEWLeadRec.Modify(true);
            ClearQuickFields(SEWLeadRec);
        end;

        // Convert team assignment to individual ownership
        // When someone creates a contact from a team lead, they take personal ownership
        if SEWLeadRec."Assignment Type" = SEWLeadRec."Assignment Type"::Team then begin
            SEWLeadRec.Validate("Assignment Type", SEWLeadRec."Assignment Type"::Salesperson);
            SEWLeadRec.Validate("Salesperson Code", SalespersonCode);
            SEWLeadRec.Modify(true);
            // Log the conversion from team to individual
            SEWLeadRec.LogAssignmentChange('', 'Contact created - team converted to individual ownership');
        end;
    end;

    local procedure FindExistingContact(SEWLeadRec: Record "SEW Lead"; var ContactRec: Record Contact): Boolean
    begin
        // Check by email first (most reliable)
        if SEWLeadRec."Quick Email" <> '' then begin
            ContactRec.SetRange("E-Mail", SEWLeadRec."Quick Email");
            if ContactRec.FindFirst() then
                exit(true);
            ContactRec.SetRange("E-Mail");
        end;

        // Check by company name + phone (secondary)
        if (SEWLeadRec."Quick Company Name" <> '') and (SEWLeadRec."Quick Phone" <> '') then begin
            ContactRec.SetRange(Name, SEWLeadRec."Quick Company Name");
            ContactRec.SetRange("Phone No.", SEWLeadRec."Quick Phone");
            if ContactRec.FindFirst() then
                exit(true);
        end;

        exit(false);
    end;

    local procedure CreateContactFromLead(SEWLeadRec: Record "SEW Lead"; var ContactRec: Record Contact; SalespersonCode: Code[20])
    begin
        ContactRec.Init();
        ContactRec.Validate(Type, ContactRec.Type::Company);
        ContactRec.Validate(Name, CopyStr(SEWLeadRec."Quick Company Name", 1, MaxStrLen(ContactRec.Name)));

        // Set all contact details BEFORE insert
        if SEWLeadRec."Quick Email" <> '' then
            ContactRec.Validate("E-Mail", CopyStr(SEWLeadRec."Quick Email", 1, MaxStrLen(ContactRec."E-Mail")));

        if SEWLeadRec."Quick Phone" <> '' then
            ContactRec.Validate("Phone No.", CopyStr(SEWLeadRec."Quick Phone", 1, MaxStrLen(ContactRec."Phone No.")));

        // Set salesperson from current user (passed as parameter)
        if SalespersonCode <> '' then
            ContactRec.Validate("Salesperson Code", SalespersonCode);

        // Insert once with all fields set
        ContactRec.Insert(true);
    end;

    local procedure GetCurrentUserSalespersonCode(): Code[20]
    var
        UserSetup: Record "User Setup";
        NoUserSetupErr: Label 'User Setup not found for current user. A Salesperson Code is required to create contacts.';
        NoSalespersonErr: Label 'No Salesperson Code configured in User Setup for current user %1. Please configure User Setup.', Comment = '%1 = User ID';
    begin
        if not UserSetup.Get(UserId) then
            Error(NoUserSetupErr);

        if UserSetup."Salespers./Purch. Code" = '' then
            Error(NoSalespersonErr, UserId);

        exit(UserSetup."Salespers./Purch. Code");
    end;

    local procedure ClearQuickFields(var SEWLeadRec: Record "SEW Lead")
    begin
        SEWLeadRec."Quick Company Name" := '';
        SEWLeadRec."Quick Email" := '';
        SEWLeadRec."Quick Phone" := '';
        SEWLeadRec.Modify(true);
    end;

    procedure SyncContactToLead(var SEWLeadRec: Record "SEW Lead")
    var
        ContactRec: Record Contact;
    begin
        if SEWLeadRec."Contact No." = '' then
            exit;

        if not ContactRec.Get(SEWLeadRec."Contact No.") then
            exit;

        // Sync salesperson if not set
        if (SEWLeadRec."Salesperson Code" = '') and (ContactRec."Salesperson Code" <> '') then begin
            SEWLeadRec."Salesperson Code" := ContactRec."Salesperson Code";
            SEWLeadRec.Modify(true);
        end;
    end;

    procedure ValidateContactLink(SEWLeadRec: Record "SEW Lead")
    var
        ContactRec: Record Contact;
        ContactNotFoundErr: Label 'Contact %1 does not exist.', Comment = '%1 = Contact No.';
    begin
        if SEWLeadRec."Contact No." = '' then
            exit;

        if not ContactRec.Get(SEWLeadRec."Contact No.") then
            Error(ContactNotFoundErr, SEWLeadRec."Contact No.");
    end;
}
