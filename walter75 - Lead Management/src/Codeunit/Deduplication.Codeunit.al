codeunit 91723 "SEW Deduplication"
{
    Access = Public;

    procedure CheckDuplicateLead(SEWLeadRec: Record "SEW Lead"): Boolean
    var
        ExistingSEWLeadRec: Record "SEW Lead";
    begin
        // Check by Quick Email (if no Contact)
        if (SEWLeadRec."Contact No." = '') and (SEWLeadRec."Quick Email" <> '') then begin
            ExistingSEWLeadRec.SetRange("Quick Email", SEWLeadRec."Quick Email");
            ExistingSEWLeadRec.SetFilter("No.", '<>%1', SEWLeadRec."No.");
            ExistingSEWLeadRec.SetFilter(Status, '%1|%2|%3|%4',
              ExistingSEWLeadRec.Status::New,
              ExistingSEWLeadRec.Status::Working,
              ExistingSEWLeadRec.Status::Nurturing,
              ExistingSEWLeadRec.Status::Qualified);
            if not ExistingSEWLeadRec.IsEmpty() then
                exit(true);
        end;

        // Check by Contact No.
        if SEWLeadRec."Contact No." <> '' then begin
            ExistingSEWLeadRec.Reset();
            ExistingSEWLeadRec.SetRange("Contact No.", SEWLeadRec."Contact No.");
            ExistingSEWLeadRec.SetFilter("No.", '<>%1', SEWLeadRec."No.");
            ExistingSEWLeadRec.SetFilter(Status, '%1|%2|%3|%4',
              ExistingSEWLeadRec.Status::New,
              ExistingSEWLeadRec.Status::Working,
              ExistingSEWLeadRec.Status::Nurturing,
              ExistingSEWLeadRec.Status::Qualified);
            if not ExistingSEWLeadRec.IsEmpty() then
                exit(true);
        end;

        exit(false);
    end;

    procedure WarnIfDuplicate(SEWLeadRec: Record "SEW Lead")
    var
        DuplicateWarningQst: Label 'Potential duplicate lead detected. Continue?';
    begin
        if CheckDuplicateLead(SEWLeadRec) then
            if not Confirm(DuplicateWarningQst, false) then
                Error('');
    end;

    procedure GetDuplicateLeads(SEWLeadRec: Record "SEW Lead"; var DuplicateSEWLeadRec: Record "SEW Lead")
    begin
        DuplicateSEWLeadRec.Reset();
        DuplicateSEWLeadRec.DeleteAll();

        // Find by email
        if (SEWLeadRec."Contact No." = '') and (SEWLeadRec."Quick Email" <> '') then begin
            DuplicateSEWLeadRec.SetRange("Quick Email", SEWLeadRec."Quick Email");
            DuplicateSEWLeadRec.SetFilter("No.", '<>%1', SEWLeadRec."No.");
            DuplicateSEWLeadRec.SetFilter(Status, '%1|%2|%3|%4',
              DuplicateSEWLeadRec.Status::New,
              DuplicateSEWLeadRec.Status::Working,
              DuplicateSEWLeadRec.Status::Nurturing,
              DuplicateSEWLeadRec.Status::Qualified);
            if DuplicateSEWLeadRec.FindSet() then;
        end;

        // Find by Contact No.
        if SEWLeadRec."Contact No." <> '' then begin
            DuplicateSEWLeadRec.Reset();
            DuplicateSEWLeadRec.SetRange("Contact No.", SEWLeadRec."Contact No.");
            DuplicateSEWLeadRec.SetFilter("No.", '<>%1', SEWLeadRec."No.");
            DuplicateSEWLeadRec.SetFilter(Status, '%1|%2|%3|%4',
              DuplicateSEWLeadRec.Status::New,
              DuplicateSEWLeadRec.Status::Working,
              DuplicateSEWLeadRec.Status::Nurturing,
              DuplicateSEWLeadRec.Status::Qualified);
            if DuplicateSEWLeadRec.FindSet() then;
        end;
    end;
}
