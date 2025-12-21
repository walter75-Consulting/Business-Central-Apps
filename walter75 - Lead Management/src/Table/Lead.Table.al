table 91700 "SEW Lead"
{
    Caption = 'Lead';
    DataClassification = CustomerContent;
    LookupPageId = "SEW Lead List";
    DrillDownPageId = "SEW Lead List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            ToolTip = 'Specifies the unique identifier for the lead.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SEWLeadSetup.Get();
                    NoSeriesManagement.TestManual(SEWLeadSetup."Lead No. Series");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Lead ID"; Guid)
        {
            Caption = 'Lead ID';
            ToolTip = 'Specifies the stable identifier used for API integrations.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(3; "External ID"; Text[50])
        {
            Caption = 'External ID';
            ToolTip = 'Specifies the reference ID from external systems (e.g., website forms).';
            DataClassification = CustomerContent;
        }
        field(10; "Contact No."; Code[20])
        {
            Caption = 'Contact No.';
            ToolTip = 'Specifies the Business Central contact associated with this lead.';
            TableRelation = Contact where(Type = const(Company));
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                Contact: Record Contact;
                SEWLeadContactSync: Codeunit "SEW Lead-Contact Sync";
            begin
                if "Contact No." <> '' then begin
                    Contact.Get("Contact No.");
                    // Clear quick capture fields when Contact is linked
                    "Quick Company Name" := '';
                    "Quick Email" := '';
                    "Quick Phone" := '';

                    // Sync contact data to lead
                    SEWLeadContactSync.SyncContactToLead(Rec);
                end;
            end;
        }
        field(11; "Quick Company Name"; Text[100])
        {
            Caption = 'Company Name';
            ToolTip = 'Specifies the company name for quick lead capture (cleared when contact is linked).';
            DataClassification = CustomerContent;
        }
        field(12; "Quick Email"; Text[100])
        {
            Caption = 'Email';
            ToolTip = 'Specifies the email address for quick lead capture (cleared when contact is linked).';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(13; "Quick Phone"; Text[30])
        {
            Caption = 'Phone';
            ToolTip = 'Specifies the phone number for quick lead capture (cleared when contact is linked).';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(20; "Source Code"; Code[20])
        {
            Caption = 'Source Code';
            ToolTip = 'Specifies where this lead originated from.';
            TableRelation = "SEW Lead Source"."Source Code";
            DataClassification = CustomerContent;
        }
        field(21; "Campaign No."; Code[20])
        {
            Caption = 'Campaign No.';
            ToolTip = 'Specifies the campaign associated with this lead.';
            TableRelation = Campaign;
            DataClassification = CustomerContent;
        }
        field(30; Status; Enum "SEW Lead Status")
        {
            Caption = 'Status';
            ToolTip = 'Specifies the current status of the lead in the qualification workflow.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                SEWLeadSetup: Record "SEW Lead Setup";
                SEWLeadContactSync: Codeunit "SEW Lead-Contact Sync";
                SEWLeadManagement: Codeunit "SEW Lead Management";
                OldStatus: Enum "SEW Lead Status";
            begin
                OldStatus := xRec.Status;

                // Auto-create Contact when moving to Working
                if (Status = Status::Working) and ("Contact No." = '') then
                    if SEWLeadSetup.Get() then
                        if SEWLeadSetup."Auto Create Contact On Working" then
                            SEWLeadContactSync.CreateOrLinkContact(Rec);

                // Validate status transition
                ValidateStatusTransition();

                // Create history entry if status changed
                if (OldStatus <> Status) and (xRec."No." <> '') then
                    SEWLeadManagement.CreateStatusHistory(Rec, OldStatus, Status, '');
            end;
        }
        field(32; "Expected Revenue"; Decimal)
        {
            Caption = 'Expected Revenue';
            ToolTip = 'Specifies the forecasted revenue if this lead converts to a sale.';
            DataClassification = CustomerContent;
            AutoFormatType = 1;
        }
        field(33; "Probability %"; Decimal)
        {
            Caption = 'Probability %';
            ToolTip = 'Specifies the estimated probability of conversion (0-100%).';
            DataClassification = CustomerContent;
            MinValue = 0;
            MaxValue = 100;
            DecimalPlaces = 0 : 2;
        }
        field(34; "Stage Code"; Code[20])
        {
            Caption = 'Stage Code';
            ToolTip = 'Specifies the pipeline stage for Kanban view.';
            TableRelation = "SEW Lead Stage";
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                SEWLeadStageRec: Record "SEW Lead Stage";
            begin
                if Rec."Stage Code" <> '' then
                    if SEWLeadStageRec.Get(Rec."Stage Code") then
                        if SEWLeadStageRec."Default Probability %" > 0 then
                            Rec."Probability %" := SEWLeadStageRec."Default Probability %";
            end;
        }
        field(40; "Assignment Type"; Enum "SEW Lead Assignment Type")
        {
            Caption = 'Assignment Type';
            ToolTip = 'Specifies whether this lead is assigned to an individual salesperson or a team.';
            DataClassification = CustomerContent;
            InitValue = Salesperson;

            trigger OnValidate()
            begin
                // Clear assignment when type changes
                if "Assignment Type" <> xRec."Assignment Type" then begin
                    "Salesperson Code" := '';
                    UpdateAssignedToName();
                end;
            end;
        }
        field(41; "Salesperson Code"; Code[20])
        {
            Caption = 'Assigned To';
            ToolTip = 'Specifies the salesperson or team code assigned to this lead (see Assignment Type). Note: Team codes are max 10 characters.';
            TableRelation = if ("Assignment Type" = const(Salesperson)) "Salesperson/Purchaser"
            else if ("Assignment Type" = const(Team)) Team;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                ValidateAssignment();
                UpdateAssignedToName();

                // Log assignment change
                if (xRec."No." <> '') and
                   ((xRec."Assignment Type" <> Rec."Assignment Type") or (xRec."Salesperson Code" <> Rec."Salesperson Code")) then
                    LogAssignmentChange('', '');
            end;

            trigger OnLookup()
            begin
                LookupAssignment();
            end;
        }
        field(42; "Assigned To Name"; Text[100])
        {
            Caption = 'Assigned To';
            ToolTip = 'Specifies the name of the assigned salesperson or team.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50; "Score (Total)"; Integer)
        {
            Caption = 'Total Score';
            ToolTip = 'Specifies the calculated total score for this lead.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(51; "Score Band"; Enum "SEW Score Band")
        {
            Caption = 'Score Band';
            ToolTip = 'Specifies the score band classification (Hot/Warm/Cold).';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(52; "Score (Fit)"; Integer)
        {
            Caption = 'Fit Score';
            ToolTip = 'Specifies the fit score based on company attributes.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(53; "Score (Intent)"; Integer)
        {
            Caption = 'Intent Score';
            ToolTip = 'Specifies the intent score based on engagement activities.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60; "Next Activity Date"; Date)
        {
            Caption = 'Next Activity Date';
            ToolTip = 'Specifies the date of the next planned activity for this lead.';
            DataClassification = CustomerContent;
        }
        field(61; "Last Activity Date"; Date)
        {
            Caption = 'Last Activity Date';
            ToolTip = 'Specifies the date of the last activity for this lead.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(70; "Marketing Consent"; Boolean)
        {
            Caption = 'Marketing Consent';
            ToolTip = 'Specifies whether the lead has opted in to receive marketing communications.';
            DataClassification = CustomerContent;
        }
        field(71; "Consent Given Date"; DateTime)
        {
            Caption = 'Consent Given Date';
            ToolTip = 'Specifies when marketing consent was granted.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(72; "Consent Source"; Text[50])
        {
            Caption = 'Consent Source';
            ToolTip = 'Specifies the source of the marketing consent (e.g., Web Form, Event).';
            DataClassification = CustomerContent;
        }
        field(73; "Consent IP Address"; Text[45])
        {
            Caption = 'Consent IP Address';
            ToolTip = 'Specifies the IP address from which consent was given.';
            DataClassification = EndUserPseudonymousIdentifiers;
            Editable = false;
        }
        field(74; "Employee Count"; Integer)
        {
            Caption = 'Employee Count';
            ToolTip = 'Specifies the number of employees at the lead company for scoring purposes.';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(77; "Industry Group Code"; Code[10])
        {
            Caption = 'Industry Group';
            ToolTip = 'Specifies the industry group for this lead (used for scoring).';
            TableRelation = "Industry Group";
            DataClassification = CustomerContent;
        }
        field(75; "Website Visit"; Boolean)
        {
            Caption = 'Website Visit';
            ToolTip = 'Specifies whether the lead has visited the company website (engagement signal for scoring).';
            DataClassification = CustomerContent;
        }
        field(76; "Email Opened"; Boolean)
        {
            Caption = 'Email Opened';
            ToolTip = 'Specifies whether the lead has opened marketing emails (engagement signal for scoring).';
            DataClassification = CustomerContent;
        }
        field(80; "Disqualification Reason"; Enum "SEW Disqualification Reason")
        {
            Caption = 'Disqualification Reason';
            ToolTip = 'Specifies why this lead was disqualified.';
            DataClassification = CustomerContent;
        }
        field(81; "Disqualification Notes"; Text[250])
        {
            Caption = 'Disqualification Notes';
            ToolTip = 'Specifies additional notes about why this lead was disqualified.';
            DataClassification = CustomerContent;
        }
        field(90; Converted; Boolean)
        {
            Caption = 'Converted';
            ToolTip = 'Specifies whether this lead has been converted to an opportunity.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(91; "Opportunity No."; Code[20])
        {
            Caption = 'Opportunity No.';
            ToolTip = 'Specifies the opportunity created from this lead.';
            TableRelation = Opportunity;
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(92; "Converted Date"; Date)
        {
            Caption = 'Converted Date';
            ToolTip = 'Specifies the date when this lead was converted to an opportunity.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(98; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            ToolTip = 'Specifies the number series used for this lead.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(95; "Lead Description"; Blob)
        {
            Caption = 'Lead Description';
            ToolTip = 'Specifies detailed information about the lead (e.g., notes from call agency).';
            DataClassification = CustomerContent;
        }
        field(96; "Lead Summary"; Blob)
        {
            Caption = 'Lead Summary';
            ToolTip = 'Specifies an AI-generated summary and analysis of the lead.';
            DataClassification = CustomerContent;
        }
        field(100; "System Created By Name"; Code[50])
        {
            Caption = 'Created By';
            ToolTip = 'Specifies the user who created this lead.';
            FieldClass = FlowField;
            CalcFormula = lookup(User."User Name" where("User Security ID" = field(SystemCreatedBy)));
            Editable = false;
        }
        field(101; "System Modified By Name"; Code[50])
        {
            Caption = 'Modified By';
            ToolTip = 'Specifies the user who last modified this lead.';
            FieldClass = FlowField;
            CalcFormula = lookup(User."User Name" where("User Security ID" = field(SystemModifiedBy)));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(SK1; "Lead ID")
        {
        }
        key(SK2; "Contact No.")
        {
        }
        key(SK3; "Quick Email")
        {
            IncludedFields = "Quick Company Name", "Quick Phone";
        }
        key(SK4; Status, "Assignment Type", "Salesperson Code")
        {
        }
        key(SK5; "Source Code", SystemCreatedAt)
        {
        }
        key(SK6; "Score Band", "Next Activity Date")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Quick Company Name", "Contact No.", Status)
        {
        }
        fieldgroup(Brick; "No.", "Quick Company Name", "Quick Email", Status)
        {
        }
    }

    trigger OnInsert()
    begin
        if "Lead ID" = CreateGuid() then;

        if "No." = '' then begin
            SEWLeadSetup.Get();
            SEWLeadSetup.TestField("Lead No. Series");
            "No." := NoSeriesManagement.GetNextNo(SEWLeadSetup."Lead No. Series", 0D, true);
            "No. Series" := SEWLeadSetup."Lead No. Series";
        end;
    end;

    var
        SEWLeadSetup: Record "SEW Lead Setup";
        NoSeriesManagement: Codeunit "No. Series";

    local procedure ValidateAssignment()
    var
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        Team: Record Team;
        AssignmentNotFoundErr: Label 'Cannot find %1 with code %2.', Comment = '%1 = Assignment Type, %2 = Code';
    begin
        if "Salesperson Code" = '' then
            exit;

        case "Assignment Type" of
            "Assignment Type"::Salesperson:
                if not SalespersonPurchaser.Get("Salesperson Code") then
                    Error(AssignmentNotFoundErr, "Assignment Type", "Salesperson Code");

            "Assignment Type"::Team:
                if not Team.Get("Salesperson Code") then
                    Error(AssignmentNotFoundErr, "Assignment Type", "Salesperson Code");
        end;
    end;

    local procedure LookupAssignment()
    var
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        Team: Record Team;
    begin
        case "Assignment Type" of
            "Assignment Type"::Salesperson:
                begin
                    if Page.RunModal(Page::"Salespersons/Purchasers", SalespersonPurchaser) = Action::LookupOK then begin
                        "Salesperson Code" := SalespersonPurchaser.Code;
                        UpdateAssignedToName();
                    end;
                end;

            "Assignment Type"::Team:
                begin
                    if Page.RunModal(Page::Teams, Team) = Action::LookupOK then begin
                        "Salesperson Code" := Team.Code;
                        UpdateAssignedToName();
                    end;
                end;
        end;
    end;

    local procedure UpdateAssignedToName()
    var
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        Team: Record Team;
    begin
        "Assigned To Name" := '';

        if "Salesperson Code" = '' then
            exit;

        case "Assignment Type" of
            "Assignment Type"::Salesperson:
                if SalespersonPurchaser.Get("Salesperson Code") then
                    "Assigned To Name" := SalespersonPurchaser.Name;

            "Assignment Type"::Team:
                if Team.Get("Salesperson Code") then
                    "Assigned To Name" := Team.Name;
        end;
    end;

    local procedure ValidateStatusTransition()
    begin
        // Enforce required fields based on status
        case Status of
            Status::Qualified, Status::Converted:
                TestField("Contact No.");
        end;
    end;

    procedure SetLeadDescription(NewDescription: Text)
    var
        OutStream: OutStream;
    begin
        Clear("Lead Description");
        "Lead Description".CreateOutStream(OutStream, TextEncoding::UTF8);
        OutStream.WriteText(NewDescription);
    end;

    procedure GetLeadDescription(): Text
    var
        InStream: InStream;
        DescriptionText: Text;
    begin
        CalcFields("Lead Description");
        "Lead Description".CreateInStream(InStream, TextEncoding::UTF8);
        InStream.ReadText(DescriptionText);
        exit(DescriptionText);
    end;

    procedure SetLeadSummary(NewSummary: Text)
    var
        OutStream: OutStream;
    begin
        Clear("Lead Summary");
        "Lead Summary".CreateOutStream(OutStream, TextEncoding::UTF8);
        OutStream.WriteText(NewSummary);
    end;

    procedure GetLeadSummary(): Text
    var
        InStream: InStream;
        SummaryText: Text;
    begin
        CalcFields("Lead Summary");
        "Lead Summary".CreateInStream(InStream, TextEncoding::UTF8);
        InStream.ReadText(SummaryText);
        exit(SummaryText);
    end;

    procedure LogAssignmentChange(RuleCode: Code[20]; Reason: Text[250])
    var
        AssignmentLog: Record "SEW Lead Assignment Log";
    begin
        // Only log if this is an existing record with an assignment change
        if "No." = '' then
            exit;

        AssignmentLog.Init();
        AssignmentLog."Lead No." := "No.";
        AssignmentLog."Rule Code" := RuleCode;
        AssignmentLog."From Assignment Type" := xRec."Assignment Type";
        AssignmentLog."From Assigned To" := xRec."Salesperson Code";
        AssignmentLog."From Assigned To Name" := xRec."Assigned To Name";
        AssignmentLog."To Assignment Type" := "Assignment Type";
        AssignmentLog."To Assigned To" := "Salesperson Code";
        AssignmentLog."To Assigned To Name" := "Assigned To Name";
        AssignmentLog.Reason := Reason;
        AssignmentLog.Insert(true);
    end;
}
