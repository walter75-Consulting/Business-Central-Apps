table 91712 "SEW Lead Routing Rule"
{
    Caption = 'Lead Routing Rule';
    DataClassification = CustomerContent;
    LookupPageId = "SEW Lead Routing Rules";
    DrillDownPageId = "SEW Lead Routing Rules";

    fields
    {
        field(1; "Rule Code"; Code[20])
        {
            Caption = 'Rule Code';
            ToolTip = 'Specifies the unique code for the routing rule.';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
            ToolTip = 'Specifies the descriptive name of the routing rule.';
            DataClassification = CustomerContent;
        }
        field(10; "Rule Type"; Enum "SEW Routing Rule Type")
        {
            Caption = 'Rule Type';
            ToolTip = 'Specifies the type of routing logic to apply.';
            DataClassification = CustomerContent;
        }
        field(11; Active; Boolean)
        {
            Caption = 'Active';
            ToolTip = 'Specifies whether this routing rule is currently active.';
            DataClassification = CustomerContent;
            InitValue = true;
        }
        field(12; Priority; Integer)
        {
            Caption = 'Priority';
            ToolTip = 'Specifies the priority of this rule (1 = highest). Lower numbers are evaluated first.';
            DataClassification = CustomerContent;
            MinValue = 1;
            InitValue = 10;
        }
        field(20; "Min Score"; Integer)
        {
            Caption = 'Min Score';
            ToolTip = 'Specifies the minimum score for ScoreThreshold rule type.';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(21; "Max Score"; Integer)
        {
            Caption = 'Max Score';
            ToolTip = 'Specifies the maximum score for ScoreThreshold rule type.';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(30; "Source Code"; Code[20])
        {
            Caption = 'Source Code';
            ToolTip = 'Specifies the lead source filter for SourceBased rule type.';
            TableRelation = "SEW Lead Source";
            DataClassification = CustomerContent;
        }
        field(31; "Territory Code"; Code[20])
        {
            Caption = 'Territory Code';
            ToolTip = 'Specifies the territory filter for Territory rule type.';
            TableRelation = Territory;
            DataClassification = CustomerContent;
        }
        field(40; "Assignment Type"; Enum "SEW Lead Assignment Type")
        {
            Caption = 'Assignment Type';
            ToolTip = 'Specifies whether to assign to an individual salesperson or a team.';
            DataClassification = CustomerContent;
            InitValue = Salesperson;

            trigger OnValidate()
            begin
                // Clear assignment when type changes
                if "Assignment Type" <> xRec."Assignment Type" then begin
                    "Assigned To Code" := '';
                    UpdateAssignedToName();
                end;
            end;
        }
        field(41; "Assigned To Code"; Code[20])
        {
            Caption = 'Assigned To';
            ToolTip = 'Specifies the salesperson or team code to assign.';
            TableRelation = if ("Assignment Type" = const(Salesperson)) "Salesperson/Purchaser"
            else if ("Assignment Type" = const(Team)) Team;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                UpdateAssignedToName();
            end;
        }
        field(42; "Assigned To Name"; Text[100])
        {
            Caption = 'Assigned To Name';
            ToolTip = 'Specifies the name of the salesperson or team to assign.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50; "Team Code"; Code[20])
        {
            Caption = 'Round Robin Team Code';
            ToolTip = 'Specifies the team queue for round robin assignment (RoundRobin rule type only).';
            DataClassification = CustomerContent;
            ObsoleteState = Pending;
            ObsoleteReason = 'Use Assignment Type and Assigned To Code instead. Kept for backward compatibility.';
        }
        field(51; "Last Assigned User ID"; Guid)
        {
            Caption = 'Last Assigned User ID';
            ToolTip = 'Specifies the last user assigned by round robin logic.';
            TableRelation = User."User Security ID";
            DataClassification = EndUserPseudonymousIdentifiers;
        }
    }

    keys
    {
        key(PK; "Rule Code")
        {
            Clustered = true;
        }
        key(SK1; Active, Priority)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Rule Code", Name, "Rule Type", Active)
        {
        }
    }

    trigger OnDelete()
    var
        SEWLeadAssignmentLogRec: Record "SEW Lead Assignment Log";
        CannotDeleteRuleErr: Label 'Cannot delete routing rule %1 because it has %2 assignment log entries.', Comment = 'DE="Die Routing-Regel %1 kann nicht gelöscht werden, da %2 Zuweisungsprotokolleinträge vorhanden sind."';
    begin
        SEWLeadAssignmentLogRec.SetRange("Rule Code", Rec."Rule Code");
        if not SEWLeadAssignmentLogRec.IsEmpty() then
            Error(CannotDeleteRuleErr, Rec."Rule Code", SEWLeadAssignmentLogRec.Count());
    end;

    local procedure UpdateAssignedToName()
    var
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        Team: Record Team;
    begin
        "Assigned To Name" := '';

        if "Assigned To Code" = '' then
            exit;

        case "Assignment Type" of
            "Assignment Type"::Salesperson:
                if SalespersonPurchaser.Get("Assigned To Code") then
                    "Assigned To Name" := SalespersonPurchaser.Name;

            "Assignment Type"::Team:
                if Team.Get("Assigned To Code") then
                    "Assigned To Name" := Team.Name;
        end;
    end;
}
