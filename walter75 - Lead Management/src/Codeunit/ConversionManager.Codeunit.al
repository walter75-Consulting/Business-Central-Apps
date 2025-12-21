codeunit 91722 "SEW Conversion Manager"
{
    Access = Public;

    procedure ConvertLeadToOpportunity(var SEWLeadRec: Record "SEW Lead")
    var
        ContactRec: Record Contact;
        OpportunityRec: Record Opportunity;
        SEWLeadManagement: Codeunit "SEW Lead Management";
        ContactNotLinkedErr: Label 'Cannot convert lead without a linked Contact. Please link or create a Contact first.';
        LeadNotQualifiedErr: Label 'Only Qualified leads can be converted to opportunities. Current status: %1.', Comment = '%1 = Lead Status';
        OpportunityCreatedMsg: Label 'Opportunity %1 has been created from lead %2.', Comment = '%1 = Opportunity No., %2 = Lead No.';
        ConvertedToOpportunityTxt: Label 'Converted to Opportunity %1', Comment = '%1 = Opportunity No.';
    begin
        // Validate prerequisites
        if SEWLeadRec.Status <> SEWLeadRec.Status::Qualified then
            Error(LeadNotQualifiedErr, SEWLeadRec.Status);

        if SEWLeadRec."Contact No." = '' then
            Error(ContactNotLinkedErr);

        if not ContactRec.Get(SEWLeadRec."Contact No.") then
            Error(ContactNotLinkedErr);

        // Create Opportunity - BC's OnInsert trigger handles Sales Cycle and Entries
        OpportunityRec.Init();
        OpportunityRec.Validate("Contact No.", SEWLeadRec."Contact No.");

        // Handle assignment based on type
        if SEWLeadRec."Assignment Type" = SEWLeadRec."Assignment Type"::Salesperson then
            OpportunityRec.Validate("Salesperson Code", SEWLeadRec."Salesperson Code")
        else
            AssignSalespersonFromTeam(SEWLeadRec, OpportunityRec);

        if SEWLeadRec."Campaign No." <> '' then
            OpportunityRec.Validate("Campaign No.", SEWLeadRec."Campaign No.");

        OpportunityRec.Insert(true); // BC automatically sets Sales Cycle and creates first Opportunity Entry

        // Update Lead with Opportunity reference
        SEWLeadRec."Opportunity No." := OpportunityRec."No.";
        SEWLeadRec.Status := SEWLeadRec.Status::Converted;
        SEWLeadRec.Modify(true);

        // Create status history
        SEWLeadManagement.CreateStatusHistory(
          SEWLeadRec,
          SEWLeadRec.Status::Qualified,
          SEWLeadRec.Status::Converted,
          StrSubstNo(ConvertedToOpportunityTxt, OpportunityRec."No.")
        );

        // Create Lead→Opportunity mapping (Phase 3)
        CreateLeadOpportunityMap(SEWLeadRec, OpportunityRec);

        Message(OpportunityCreatedMsg, OpportunityRec."No.", SEWLeadRec."No.");
    end;

    local procedure CreateLeadOpportunityMap(SEWLeadRec: Record "SEW Lead"; OpportunityRec: Record Opportunity)
    var
        SEWLeadOpportunityMap: Record "SEW Lead→Opportunity Map";
    begin
        SEWLeadOpportunityMap.Init();
        SEWLeadOpportunityMap."Lead No." := SEWLeadRec."No.";
        SEWLeadOpportunityMap."Opportunity No." := OpportunityRec."No.";
        SEWLeadOpportunityMap."Contact No." := SEWLeadRec."Contact No.";
        SEWLeadOpportunityMap."Expected Revenue" := SEWLeadRec."Expected Revenue";
        SEWLeadOpportunityMap."Campaign No." := SEWLeadRec."Campaign No.";
        SEWLeadOpportunityMap.Insert(true);
    end;

    local procedure AssignSalespersonFromTeam(SEWLeadRec: Record "SEW Lead"; var OpportunityRec: Record Opportunity)
    var
        TeamSalesperson: Record "Team Salesperson";
        UserSetup: Record "User Setup";
        SelectSalespersonLbl: Label 'Lead %1 is assigned to team %2. Select the salesperson for the opportunity:', Comment = '%1 = Lead No., %2 = Team Code';
        NoTeamMembersErr: Label 'Team %1 has no members. Cannot convert lead to opportunity.', Comment = '%1 = Team Code';
    begin
        // Check if current user is in the team - use them automatically
        if UserSetup.Get(UserId) then
            if UserSetup."Salespers./Purch. Code" <> '' then begin
                TeamSalesperson.SetRange("Team Code", SEWLeadRec."Salesperson Code");
                TeamSalesperson.SetRange("Salesperson Code", UserSetup."Salespers./Purch. Code");
                if TeamSalesperson.FindFirst() then begin
                    // Current user is in the team - use their salesperson code
                    OpportunityRec.Validate("Salesperson Code", UserSetup."Salespers./Purch. Code");
                    exit;
                end;
            end;

        // Current user not in team - show selection
        TeamSalesperson.Reset();
        TeamSalesperson.SetRange("Team Code", SEWLeadRec."Salesperson Code");
        if not TeamSalesperson.FindSet() then
            Error(NoTeamMembersErr, SEWLeadRec."Salesperson Code");

        // If only one team member, use them automatically
        if TeamSalesperson.Count = 1 then begin
            OpportunityRec.Validate("Salesperson Code", TeamSalesperson."Salesperson Code");
            exit;
        end;

        // Multiple team members - let user choose
        Message(SelectSalespersonLbl, SEWLeadRec."No.", SEWLeadRec."Salesperson Code");
        if Page.RunModal(0, TeamSalesperson) = Action::LookupOK then
            OpportunityRec.Validate("Salesperson Code", TeamSalesperson."Salesperson Code")
        else
            // User cancelled - use first team member
            if TeamSalesperson.FindFirst() then
                OpportunityRec.Validate("Salesperson Code", TeamSalesperson."Salesperson Code");
    end;

    procedure CanConvertLead(SEWLeadRec: Record "SEW Lead"): Boolean
    begin
        exit((SEWLeadRec.Status = SEWLeadRec.Status::Qualified) and (SEWLeadRec."Contact No." <> ''));
    end;
}
