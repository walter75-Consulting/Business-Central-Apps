codeunit 91725 "SEW Routing Engine"
{
    Permissions = tabledata "SEW Lead" = rm,
                  tabledata "SEW Lead Routing Rule" = r,
                  tabledata "SEW Lead Assignment Log" = rim;

    procedure AssignLead(var SEWLeadRec: Record "SEW Lead")
    var
        SEWLeadRoutingRuleRec: Record "SEW Lead Routing Rule";
        RuleApplied: Boolean;
    begin
        // Find applicable rules (active, sorted by priority)
        SEWLeadRoutingRuleRec.SetRange(Active, true);
        SEWLeadRoutingRuleRec.SetCurrentKey(Active, Priority);
        SEWLeadRoutingRuleRec.Ascending(true);

        if SEWLeadRoutingRuleRec.FindSet() then
            repeat
                if RuleMatchesLead(SEWLeadRoutingRuleRec, SEWLeadRec) then begin
                    ExecuteRule(SEWLeadRoutingRuleRec, SEWLeadRec);
                    RuleApplied := true;
                end;
            until (SEWLeadRoutingRuleRec.Next() = 0) or RuleApplied;

        if not RuleApplied then
            AssignToDefault(SEWLeadRec);
    end;

    local procedure RuleMatchesLead(SEWLeadRoutingRuleRec: Record "SEW Lead Routing Rule"; SEWLeadRec: Record "SEW Lead"): Boolean
    begin
        case SEWLeadRoutingRuleRec."Rule Type" of
            SEWLeadRoutingRuleRec."Rule Type"::RoundRobin:
                exit(true); // Always applicable

            SEWLeadRoutingRuleRec."Rule Type"::Territory:
                // Territory matching would require Territory field on Lead or Contact
                // Simplified: match if Territory Code is blank (applies to all)
                exit(SEWLeadRoutingRuleRec."Territory Code" = '');

            SEWLeadRoutingRuleRec."Rule Type"::ScoreThreshold:
                exit((SEWLeadRec."Score (Total)" >= SEWLeadRoutingRuleRec."Min Score") and
                     (SEWLeadRec."Score (Total)" <= SEWLeadRoutingRuleRec."Max Score"));

            SEWLeadRoutingRuleRec."Rule Type"::SourceBased:
                exit(SEWLeadRec."Source Code" = SEWLeadRoutingRuleRec."Source Code");
        end;

        exit(false);
    end;

    local procedure ExecuteRule(var SEWLeadRoutingRuleRec: Record "SEW Lead Routing Rule"; var SEWLeadRec: Record "SEW Lead")
    var
        OldAssignmentType: Enum "SEW Lead Assignment Type";
        OldSalespersonCode: Code[20];
    begin
        OldAssignmentType := SEWLeadRec."Assignment Type";
        OldSalespersonCode := SEWLeadRec."Salesperson Code";

        case SEWLeadRoutingRuleRec."Rule Type" of
            SEWLeadRoutingRuleRec."Rule Type"::RoundRobin:
                ExecuteRoundRobinRule(SEWLeadRoutingRuleRec, SEWLeadRec);

            SEWLeadRoutingRuleRec."Rule Type"::Territory:
                ExecuteTerritoryRule(SEWLeadRoutingRuleRec, SEWLeadRec);

            SEWLeadRoutingRuleRec."Rule Type"::ScoreThreshold:
                ExecuteScoreThresholdRule(SEWLeadRoutingRuleRec, SEWLeadRec);

            SEWLeadRoutingRuleRec."Rule Type"::SourceBased:
                ExecuteSourceBasedRule(SEWLeadRoutingRuleRec, SEWLeadRec);
        end;

        if (SEWLeadRec."Assignment Type" <> OldAssignmentType) or (SEWLeadRec."Salesperson Code" <> OldSalespersonCode) then begin
            SEWLeadRec.Modify(true);
            // Log automatic routing with rule code
            SEWLeadRec.LogAssignmentChange(SEWLeadRoutingRuleRec."Rule Code", 'Automatic Routing');
        end;
    end;

    local procedure ExecuteRoundRobinRule(var SEWLeadRoutingRuleRec: Record "SEW Lead Routing Rule"; var SEWLeadRec: Record "SEW Lead")
    begin
        // Assign using rule's Assignment Type and Assigned To Code
        if SEWLeadRoutingRuleRec."Assigned To Code" <> '' then begin
            SEWLeadRec."Assignment Type" := SEWLeadRoutingRuleRec."Assignment Type";
            SEWLeadRec."Salesperson Code" := SEWLeadRoutingRuleRec."Assigned To Code";
        end;
    end;

    local procedure ExecuteTerritoryRule(SEWLeadRoutingRuleRec: Record "SEW Lead Routing Rule"; var SEWLeadRec: Record "SEW Lead")
    begin
        if SEWLeadRoutingRuleRec."Assigned To Code" <> '' then begin
            SEWLeadRec."Assignment Type" := SEWLeadRoutingRuleRec."Assignment Type";
            SEWLeadRec."Salesperson Code" := SEWLeadRoutingRuleRec."Assigned To Code";
        end;
    end;

    local procedure ExecuteScoreThresholdRule(SEWLeadRoutingRuleRec: Record "SEW Lead Routing Rule"; var SEWLeadRec: Record "SEW Lead")
    begin
        if SEWLeadRoutingRuleRec."Assigned To Code" <> '' then begin
            SEWLeadRec."Assignment Type" := SEWLeadRoutingRuleRec."Assignment Type";
            SEWLeadRec."Salesperson Code" := SEWLeadRoutingRuleRec."Assigned To Code";
        end;
    end;

    local procedure ExecuteSourceBasedRule(SEWLeadRoutingRuleRec: Record "SEW Lead Routing Rule"; var SEWLeadRec: Record "SEW Lead")
    begin
        if SEWLeadRoutingRuleRec."Assigned To Code" <> '' then begin
            SEWLeadRec."Assignment Type" := SEWLeadRoutingRuleRec."Assignment Type";
            SEWLeadRec."Salesperson Code" := SEWLeadRoutingRuleRec."Assigned To Code";
        end;
    end;

    local procedure AssignToDefault(var SEWLeadRec: Record "SEW Lead")
    begin
        // No default assignment - manual assignment required
    end;
}
