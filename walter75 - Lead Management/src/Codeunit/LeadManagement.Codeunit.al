codeunit 91720 "SEW Lead Management"
{
    Access = Public;

    procedure CreateLead(var SEWLeadRec: Record "SEW Lead")
    begin
        SEWLeadRec.Init();
        SEWLeadRec.Insert(true);

        // Create initial status history
        CreateStatusHistory(SEWLeadRec, SEWLeadRec.Status::New , SEWLeadRec.Status, 'Lead created');
    end;

    procedure UpdateLeadStatus(var SEWLeadRec: Record "SEW Lead"; NewStatus: Enum "SEW Lead Status"; Reason: Text[100])
    var
        SEWLeadSetup: Record "SEW Lead Setup";
        SEWLeadContactSync: Codeunit "SEW Lead-Contact Sync";
        OldStatus: Enum "SEW Lead Status";
    begin
        OldStatus := SEWLeadRec.Status;

        if OldStatus = NewStatus then
            exit;

        // Validate transition
        ValidateStatusTransition(SEWLeadRec, NewStatus);

        // Auto-create Contact when moving to Working
        if (NewStatus = NewStatus::Working) and (SEWLeadRec."Contact No." = '') then
            if SEWLeadSetup.Get() then
                if SEWLeadSetup."Auto Create Contact On Working" then
                    SEWLeadContactSync.CreateOrLinkContact(SEWLeadRec);

        // Update status
        SEWLeadRec.Status := NewStatus;
        SEWLeadRec.Modify(true);

        // Create history entry
        CreateStatusHistory(SEWLeadRec, OldStatus, NewStatus, Reason);
    end;

    local procedure ValidateStatusTransition(SEWLeadRec: Record "SEW Lead"; NewStatus: Enum "SEW Lead Status")
    var
        ContactRequiredErr: Label 'Contact is required for status %1.', Comment = '%1 = Lead Status';
        ExpectedRevenueRequiredErr: Label 'Expected Revenue is required for status %1.', Comment = '%1 = Lead Status';
    begin
        case NewStatus of
            NewStatus::Qualified:
                if SEWLeadRec."Contact No." = '' then
                    Error(ContactRequiredErr, NewStatus);
            NewStatus::Converted:
                begin
                    if SEWLeadRec."Contact No." = '' then
                        Error(ContactRequiredErr, NewStatus);
                    if SEWLeadRec."Expected Revenue" = 0 then
                        Error(ExpectedRevenueRequiredErr, NewStatus);
                end;
        end;
    end;

    procedure CreateStatusHistory(SEWLeadRec: Record "SEW Lead"; OldStatus: Enum "SEW Lead Status"; NewStatus: Enum "SEW Lead Status"; Reason: Text[100])
    var
        SEWLeadStatusHistory: Record "SEW Lead Status History";
    begin
        SEWLeadStatusHistory.Init();
        SEWLeadStatusHistory."Lead No." := SEWLeadRec."No.";
        SEWLeadStatusHistory."Old Status" := OldStatus;
        SEWLeadStatusHistory."New Status" := NewStatus;
        SEWLeadStatusHistory.Reason := CopyStr(Reason, 1, MaxStrLen(SEWLeadStatusHistory.Reason));
        SEWLeadStatusHistory.Insert(true);
    end;

    procedure UpdateScoreBand(var SEWLeadRec: Record "SEW Lead")
    var
        SEWScoringEngine: Codeunit "SEW Scoring Engine";
    begin
        // Use scoring engine to calculate and update score
        SEWScoringEngine.CalculateLeadScore(SEWLeadRec);
    end;

    procedure EnforceRequiredFields(SEWLeadRec: Record "SEW Lead")
    var
        FieldRequiredErr: Label '%1 is required for status %2.', Comment = '%1 = Field Name, %2 = Lead Status';
    begin
        case SEWLeadRec.Status of
            SEWLeadRec.Status::Qualified:
                if SEWLeadRec."Contact No." = '' then
                    Error(FieldRequiredErr, SEWLeadRec.FieldCaption("Contact No."), SEWLeadRec.Status);
            SEWLeadRec.Status::Converted:
                begin
                    if SEWLeadRec."Contact No." = '' then
                        Error(FieldRequiredErr, SEWLeadRec.FieldCaption("Contact No."), SEWLeadRec.Status);
                    if SEWLeadRec."Expected Revenue" = 0 then
                        Error(FieldRequiredErr, SEWLeadRec.FieldCaption("Expected Revenue"), SEWLeadRec.Status);
                end;
        end;
    end;
}
