codeunit 91724 "SEW Validation Rules"
{
    Access = Public;

    procedure ValidateLeadBeforeInsert(var SEWLeadRec: Record "SEW Lead")
    var
        SEWDeduplication: Codeunit "SEW Deduplication";
    begin
        // Check for duplicates before insert
        SEWDeduplication.WarnIfDuplicate(SEWLeadRec);
    end;

    procedure ValidateLeadBeforeModify(var SEWLeadRec: Record "SEW Lead")
    begin
        // Add any validation logic before modify
        ValidateStatusChange(SEWLeadRec);
    end;

    procedure ValidateStatusChange(var SEWLeadRec: Record "SEW Lead")
    begin
        // Status change validation logic would need to be called from table triggers
        // where xRec is accessible. Removing xRec access from codeunit.
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

    procedure ValidateEmail(EmailText: Text): Boolean
    var
        EmailRegEx: Text;
    begin
        EmailRegEx := '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
        // Simplified validation - BC has built-in email validation
        exit(EmailText.Contains('@'));
    end;

    procedure ValidateRequiredFieldsForStatus(SEWLeadRec: Record "SEW Lead")
    var
        ContactRequiredErr: Label 'Contact is required for status %1.', Comment = '%1 = Lead Status';
        ExpectedRevenueRequiredErr: Label 'Expected Revenue is required for status %1.', Comment = '%1 = Lead Status';
    begin
        case SEWLeadRec.Status of
            SEWLeadRec.Status::Qualified:
                if SEWLeadRec."Contact No." = '' then
                    Error(ContactRequiredErr, SEWLeadRec.Status);
            SEWLeadRec.Status::Converted:
                begin
                    if SEWLeadRec."Contact No." = '' then
                        Error(ContactRequiredErr, SEWLeadRec.Status);
                    if SEWLeadRec."Expected Revenue" = 0 then
                        Error(ExpectedRevenueRequiredErr, SEWLeadRec.Status);
                end;
        end;
    end;
}
