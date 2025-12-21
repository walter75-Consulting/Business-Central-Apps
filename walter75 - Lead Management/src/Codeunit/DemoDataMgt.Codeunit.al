codeunit 91799 "SEW Demo Data Mgt."
{
    Permissions = tabledata "SEW Lead" = rimd,
                  tabledata "SEW Lead Stage" = rimd,
                  tabledata "SEW Lead Source" = rimd,
                  tabledata "SEW Lead Activity" = rimd,
                  tabledata "SEW Lead Setup" = rm,
                  tabledata "SEW UTM Attribution" = rimd,
                  tabledata "SEW Lead Routing Rule" = rimd,
                  tabledata "SEW Lead Scoring Model" = rimd,
                  tabledata "SEW Lead Scoring Rule" = rimd,
                  tabledata "SEW Lost Reason" = rimd,
                  tabledata Team = rimd,
                  tabledata "Team Salesperson" = rimd,
                  tabledata "Industry Group" = rimd,
                  tabledata "No. Series" = ri,
                  tabledata "No. Series Line" = ri;

    procedure CreateDemoData()
    var
        ConfirmMsg: Label 'This will create demo data including:\- Number series setup\- Lead stages and sources\- Sample leads with activities\- UTM tracking data\- Routing rules\- Scoring models and rules\- Lost reasons\\Existing demo data will be deleted.\\Continue?';
        SuccessMsg: Label 'Demo data created successfully!\%1 leads created\%2 stages created\%3 sources created\%4 activities created', Comment = '%1=lead count, %2=stage count, %3=source count, %4=activity count';
        LeadCount, StageCount, SourceCount, ActivityCount : Integer;
    begin
        if not Confirm(ConfirmMsg) then
            exit;

        // Delete existing demo data
        DeleteExistingDemoData();

        // Create setup data
        CreateNumberSeries();
        StageCount := CreateLeadStages();
        SourceCount := CreateLeadSources();
        CreateDemoTeams();
        CreateIndustryGroups();
        CreateLostReasons();
        CreateRoutingRules();
        CreateScoringModels();
        CreateScoringRules();

        // Create sample leads
        LeadCount := CreateSampleLeads();

        // Create activities for leads
        ActivityCount := CreateSampleActivities();

        Commit(); // Commit the transaction

        Message(SuccessMsg, LeadCount, StageCount, SourceCount, ActivityCount);
    end;

    local procedure DeleteExistingDemoData()
    var
        Lead: Record "SEW Lead";
        LeadActivity: Record "SEW Lead Activity";
        UTM: Record "SEW UTM Attribution";
    begin
        // Delete ALL activities (not just demo ones, to clean up relationships)
        LeadActivity.Reset();
        LeadActivity.DeleteAll(true);

        // Delete ALL UTM data
        UTM.Reset();
        UTM.DeleteAll(true);

        // Delete ALL leads (fresh start for demo)
        Lead.Reset();
        Lead.DeleteAll(true);

        Commit();
    end;

    local procedure CreateNumberSeries()
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
        LeadSetup: Record "SEW Lead Setup";
    begin
        // Create number series for leads
        if not NoSeries.Get('LEAD') then begin
            NoSeries.Init();
            NoSeries.Code := 'LEAD';
            NoSeries.Description := 'Lead Numbers';
            NoSeries."Default Nos." := true;
            NoSeries."Manual Nos." := false;
            NoSeries.Insert(true);

            // Create number series line
            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := 'LEAD';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := 'LEAD-10000';
            NoSeriesLine."Ending No." := 'LEAD-99999';
            NoSeriesLine."Increment-by No." := 1;
            NoSeriesLine."Starting Date" := WorkDate();
            NoSeriesLine.Insert(true);
        end;

        // Update setup
        if not LeadSetup.Get() then begin
            LeadSetup.Init();
            LeadSetup.Insert();
        end;
        LeadSetup."Lead No. Series" := 'LEAD';
        LeadSetup.Modify(true);

        Commit();
    end;

    local procedure CreateLeadStages(): Integer
    var
        LeadStage: Record "SEW Lead Stage";
        LeadSetup: Record "SEW Lead Setup";
    begin
        // New
        if not LeadStage.Get('NEW') then begin
            LeadStage.Init();
            LeadStage."Stage Code" := 'NEW';
            LeadStage.Description := 'New';
            LeadStage.Sequence := 10;
            LeadStage."Is Closed" := false;
            LeadStage."Is Won" := false;
            LeadStage.Insert(true);
        end;

        // Contacted
        if not LeadStage.Get('CONTACT') then begin
            LeadStage.Init();
            LeadStage."Stage Code" := 'CONTACT';
            LeadStage.Description := 'Contacted';
            LeadStage.Sequence := 20;
            LeadStage."Is Closed" := false;
            LeadStage."Is Won" := false;
            LeadStage.Insert(true);
        end;

        // Qualified
        if not LeadStage.Get('QUALIFIED') then begin
            LeadStage.Init();
            LeadStage."Stage Code" := 'QUALIFIED';
            LeadStage.Description := 'Qualified';
            LeadStage.Sequence := 30;
            LeadStage."Is Closed" := false;
            LeadStage."Is Won" := false;
            LeadStage.Insert(true);
        end;

        // Proposal
        if not LeadStage.Get('PROPOSAL') then begin
            LeadStage.Init();
            LeadStage."Stage Code" := 'PROPOSAL';
            LeadStage.Description := 'Proposal Sent';
            LeadStage.Sequence := 40;
            LeadStage."Is Closed" := false;
            LeadStage."Is Won" := false;
            LeadStage.Insert(true);
        end;

        // Negotiation
        if not LeadStage.Get('NEGO') then begin
            LeadStage.Init();
            LeadStage."Stage Code" := 'NEGO';
            LeadStage.Description := 'Negotiation';
            LeadStage.Sequence := 50;
            LeadStage."Is Closed" := false;
            LeadStage."Is Won" := false;
            LeadStage.Insert(true);
        end;

        // Set default stage
        if LeadSetup.Get() then begin
            LeadSetup."Default Stage Code" := 'NEW';
            LeadSetup.Modify(true);
        end;

        exit(5);
    end;

    local procedure CreateLeadSources(): Integer
    var
        LeadSource: Record "SEW Lead Source";
    begin
        // Website
        if not LeadSource.Get('WEB') then begin
            LeadSource.Init();
            LeadSource."Source Code" := 'WEB';
            LeadSource.Description := 'Website';
            LeadSource.Channel := LeadSource.Channel::Web;
            LeadSource.Active := true;
            LeadSource.Insert(true);
        end;

        // Email Campaign
        if not LeadSource.Get('EMAIL') then begin
            LeadSource.Init();
            LeadSource."Source Code" := 'EMAIL';
            LeadSource.Description := 'Email Campaign';
            LeadSource.Channel := LeadSource.Channel::Outbound;
            LeadSource.Active := true;
            LeadSource.Insert(true);
        end;

        // Phone
        if not LeadSource.Get('PHONE') then begin
            LeadSource.Init();
            LeadSource."Source Code" := 'PHONE';
            LeadSource.Description := 'Phone Inquiry';
            LeadSource.Channel := LeadSource.Channel::InboundCall;
            LeadSource.Active := true;
            LeadSource.Insert(true);
        end;

        // Trade Show
        if not LeadSource.Get('TRADE') then begin
            LeadSource.Init();
            LeadSource."Source Code" := 'TRADE';
            LeadSource.Description := 'Trade Show';
            LeadSource.Channel := LeadSource.Channel::"Event";
            LeadSource.Active := true;
            LeadSource.Insert(true);
        end;

        // Referral
        if not LeadSource.Get('REFER') then begin
            LeadSource.Init();
            LeadSource."Source Code" := 'REFER';
            LeadSource.Description := 'Referral';
            LeadSource.Channel := LeadSource.Channel::Referral;
            LeadSource.Active := true;
            LeadSource.Insert(true);
        end;

        // Social Media
        if not LeadSource.Get('SOCIAL') then begin
            LeadSource.Init();
            LeadSource."Source Code" := 'SOCIAL';
            LeadSource.Description := 'Social Media';
            LeadSource.Channel := LeadSource.Channel::Social;
            LeadSource.Active := true;
            LeadSource.Insert(true);
        end;

        exit(6);
    end;

    local procedure CreateSampleLeads(): Integer
    var
        Lead: Record "SEW Lead";
        Counter: Integer;
    begin
        Counter := 0;

        // Lead 1: Hot prospect
        Clear(Lead);
        Lead.Init();
        Lead."No." := '';
        Lead.Insert(true);
        Lead."Quick Company Name" := 'Acme Corporation';
        Lead."Quick Email" := 'john.smith@acme.com';
        Lead."Quick Phone" := '+1-555-0100';
        Lead."Source Code" := 'WEB';
        Lead."Stage Code" := 'QUALIFIED';
        Lead.Status := Lead.Status::Working;
        Lead."Expected Revenue" := 50000;
        Lead."Score (Total)" := 85;
        Lead."Score Band" := Lead."Score Band"::Hot;
        Lead.SetLeadDescription('Interested in our enterprise solution. Budget approved for Q1.');
        Lead.Modify(true);
        Counter += 1;

        // Create UTM for Lead 1
        CreateUTMAttribution(Lead."No.", 'spring-campaign', 'google', 'cpc', 'enterprise-ad');

        // Lead 2: Medium prospect
        Clear(Lead);
        Lead.Init();
        Lead."No." := '';
        Lead.Insert(true);
        Lead."Quick Company Name" := 'TechStart Inc.';
        Lead."Quick Email" := 'sarah@techstart.com';
        Lead."Quick Phone" := '+1-555-0101';
        Lead."Source Code" := 'EMAIL';
        Lead."Stage Code" := 'CONTACT';
        Lead.Status := Lead.Status::Working;
        Lead."Expected Revenue" := 25000;
        Lead."Employee Count" := 75;
        Lead."Industry Group Code" := 'RETAIL';
        Lead."Email Opened" := true;
        Lead."Score (Total)" := 60;
        Lead."Score Band" := Lead."Score Band"::Warm;
        Lead.SetLeadDescription('Responded to email campaign. Needs more information about pricing.');
        Lead.Modify(true);
        Counter += 1;

        CreateUTMAttribution(Lead."No.", 'email-nurture', 'mailchimp', 'email', 'newsletter');

        // Lead 3: New lead
        Clear(Lead);
        Lead.Init();
        Lead."No." := '';
        Lead.Insert(true);
        Lead."Quick Company Name" := 'Global Enterprises';
        Lead."Quick Email" := 'mchen@global-ent.com';
        Lead."Quick Phone" := '+1-555-0102';
        Lead."Source Code" := 'PHONE';
        Lead."Stage Code" := 'NEW';
        Lead.Status := Lead.Status::New;
        Lead."Expected Revenue" := 35000;
        Lead."Employee Count" := 120;
        Lead."Industry Group Code" := 'FINANCE';
        Lead."Score (Total)" := 45;
        Lead."Score Band" := Lead."Score Band"::Cold;
        Lead.SetLeadDescription('Called about product demo. Needs to schedule meeting.');
        Lead.Modify(true);
        Counter += 1;

        // Lead 4: Trade show lead
        Clear(Lead);
        Lead.Init();
        Lead."No." := '';
        Lead.Insert(true);
        Lead."Quick Company Name" := 'Manufacturing Co.';
        Lead."Quick Email" := 'lisa.anderson@mfgco.com';
        Lead."Quick Phone" := '+1-555-0103';
        Lead."Source Code" := 'TRADE';
        Lead."Stage Code" := 'PROPOSAL';
        Lead.Status := Lead.Status::Working;
        Lead."Expected Revenue" := 75000;
        Lead."Employee Count" := 500;
        Lead."Industry Group Code" := 'MFG';
        Lead."Website Visit" := true;
        Lead."Email Opened" := true;
        Lead."Score (Total)" := 90;
        Lead."Score Band" := Lead."Score Band"::Hot;
        Lead.SetLeadDescription('Met at TechExpo 2025. Very interested. Sent proposal on Dec 15.');
        Lead.Modify(true);
        Counter += 1;

        // Lead 5: Referral
        Clear(Lead);
        Lead.Init();
        Lead."No." := '';
        Lead.Insert(true);
        Lead."Quick Company Name" := 'Innovation Labs';
        Lead."Quick Email" := 'dpark@innolabs.com';
        Lead."Quick Phone" := '+1-555-0104';
        Lead."Source Code" := 'REFER';
        Lead."Stage Code" := 'NEGO';
        Lead.Status := Lead.Status::Working;
        Lead."Expected Revenue" := 60000;
        Lead."Employee Count" := 300;
        Lead."Industry Group Code" := 'TECH';
        Lead."Website Visit" := true;
        Lead."Score (Total)" := 88;
        Lead."Score Band" := Lead."Score Band"::Hot;
        Lead.SetLeadDescription('Referred by existing customer. Ready to negotiate terms.');
        Lead.Modify(true);
        Counter += 1;

        // Lead 6: Social media lead
        Clear(Lead);
        Lead.Init();
        Lead."No." := '';
        Lead.Insert(true);
        Lead."Quick Company Name" := 'Digital Solutions';
        Lead."Quick Email" := 'ewilson@digitalsol.com';
        Lead."Quick Phone" := '+1-555-0105';
        Lead."Source Code" := 'SOCIAL';
        Lead."Stage Code" := 'CONTACT';
        Lead.Status := Lead.Status::Working;
        Lead."Expected Revenue" := 15000;
        Lead."Employee Count" := 15;
        Lead."Industry Group Code" := 'RETAIL';
        Lead."Website Visit" := true;
        Lead."Score (Total)" := 55;
        Lead."Score Band" := Lead."Score Band"::Warm;
        Lead.SetLeadDescription('Engaged with LinkedIn post. Small business looking for starter package.');
        Lead.Modify(true);
        Counter += 1;

        CreateUTMAttribution(Lead."No.", 'social-campaign', 'linkedin', 'social', 'product-post');

        // Lead 6A: Lead with existing contact
        CreateLeadWithContact(Counter);

        // Lead 6B: Second lead with existing contact
        CreateLeadWithContact(Counter);

        // Lead 7: Converted lead (for historical data)
        Clear(Lead);
        Lead.Init();
        Lead."No." := '';
        Lead.Insert(true);
        Lead."Quick Company Name" := 'Success Corp';
        Lead."Quick Email" := 'rtaylor@successcorp.com';
        Lead."Quick Phone" := '+1-555-0106';
        Lead."Source Code" := 'WEB';
        Lead."Stage Code" := 'QUALIFIED';
        Lead.Status := Lead.Status::Converted;
        Lead."Expected Revenue" := 100000;
        Lead."Employee Count" := 1000;
        Lead."Website Visit" := true;
        Lead."Email Opened" := true;
        Lead."Score (Total)" := 95;
        Lead."Score Band" := Lead."Score Band"::Hot;
        Lead."Converted Date" := CalcDate('<-15D>', WorkDate());
        Lead.SetLeadDescription('Converted to opportunity. Deal signed!');
        Lead.Modify(true);
        Counter += 1;

        // Lead 8: Disqualified lead
        Clear(Lead);
        Lead.Init();
        Lead."No." := '';
        Lead.Insert(true);
        Lead."Quick Company Name" := 'Budget Limited';
        Lead."Quick Email" := 'tharris@budgetltd.com';
        Lead."Quick Phone" := '+1-555-0107';
        Lead."Source Code" := 'PHONE';
        Lead."Stage Code" := 'CONTACT';
        Lead.Status := Lead.Status::Disqualified;
        Lead."Expected Revenue" := 5000;
        Lead."Employee Count" := 8;
        Lead."Score (Total)" := 20;
        Lead."Score Band" := Lead."Score Band"::Cold;
        Lead.SetLeadDescription('No budget available. Not a fit for our solution.');
        Lead.Modify(true);
        Counter += 1;

        exit(Counter);
    end;

    local procedure CreateLeadWithContact(var Counter: Integer)
    var
        Lead: Record "SEW Lead";
        Contact: Record Contact;
        SourceCodes: List of [Code[20]];
        StatusValues: List of [Enum "SEW Lead Status"];
        RandomIndex: Integer;
    begin
        // Find first available company contact
        Contact.SetRange(Type, Contact.Type::Company);
        if not Contact.FindFirst() then
            exit;

        // Create lead linked to contact
        Clear(Lead);
        Lead.Init();
        Lead."No." := '';
        Lead.Insert(true);
        Lead.Validate("Contact No.", Contact."No."); // This syncs contact data to lead

        // Randomize source and status
        SourceCodes.Add('WEB');
        SourceCodes.Add('EMAIL');
        SourceCodes.Add('PHONE');
        SourceCodes.Add('REFER');
        RandomIndex := (Counter mod SourceCodes.Count) + 1;
        Lead."Source Code" := SourceCodes.Get(RandomIndex);

        StatusValues.Add(Lead.Status::New);
        StatusValues.Add(Lead.Status::Working);
        StatusValues.Add(Lead.Status::Nurturing);
        RandomIndex := (Counter mod StatusValues.Count) + 1;
        Lead.Status := StatusValues.Get(RandomIndex);

        Lead."Stage Code" := 'CONTACT';
        Lead."Expected Revenue" := 30000 + (Counter * 5000);
        Lead."Score (Total)" := 65 + (Counter * 5);
        Lead."Score Band" := Lead."Score Band"::Warm;
        Lead.SetLeadDescription('Demo lead connected to existing BC contact: ' + Contact.Name);
        Lead.Modify(true);
        Counter += 1;
    end;

    local procedure CreateUTMAttribution(LeadNo: Code[20]; Campaign: Text[100]; Source: Text[50]; Medium: Text[50]; Content: Text[100])
    var
        UTM: Record "SEW UTM Attribution";
    begin
        if LeadNo = '' then
            exit;

        UTM.Init();
        UTM."Lead No." := LeadNo;
        UTM."UTM Campaign" := Campaign;
        UTM."UTM Source" := Source;
        UTM."UTM Medium" := Medium;
        UTM."UTM Content" := Content;
        UTM.Insert(true);
    end;

    local procedure CreateSampleActivities(): Integer
    var
        Lead: Record "SEW Lead";
        Activity: Record "SEW Lead Activity";
        Counter: Integer;
    begin
        Counter := 0;

        // Find first few leads to add activities
        Lead.SetFilter(Status, '<>%1', Lead.Status::Disqualified);
        if Lead.FindSet() then
            repeat
                // Create a phone call activity
                Clear(Activity);
                Activity.Init();
                Activity.Insert(true);
                Activity."Lead No." := Lead."No.";
                Activity."Type" := Activity."Type"::Call;
                Activity.Subject := 'Initial phone call';
                Activity."Due Date" := CalcDate('<-2D>', WorkDate());
                Activity.Completed := true;
                Activity."Completed Date" := CalcDate('<-2D>', WorkDate());
                Activity.Notes := 'Discussed requirements and timeline. Very positive conversation.';
                Activity.Modify(true);
                Counter += 1;

                // Create an email activity
                Clear(Activity);
                Activity.Init();
                Activity.Insert(true);
                Activity."Lead No." := Lead."No.";
                Activity."Type" := Activity."Type"::Email;
                Activity.Subject := 'Follow-up email with information';
                Activity."Due Date" := CalcDate('<-1D>', WorkDate());
                Activity.Completed := true;
                Activity."Completed Date" := CalcDate('<-1D>', WorkDate());
                Activity.Notes := 'Sent detailed product information and pricing sheet.';
                Activity.Modify(true);
                Counter += 1;

                // Create a future meeting for active leads
                if Lead.Status = Lead.Status::Working then begin
                    Clear(Activity);
                    Activity.Init();
                    Activity.Insert(true);
                    Activity."Lead No." := Lead."No.";
                    Activity."Type" := Activity."Type"::Meeting;
                    Activity.Subject := 'Product demonstration';
                    Activity."Due Date" := CalcDate('<+3D>', WorkDate());
                    Activity.Completed := false;
                    Activity.Notes := 'Schedule product demo with decision makers.';
                    Activity.Modify(true);
                    Counter += 1;
                end;

            until (Lead.Next() = 0) or (Counter >= 20);

        exit(Counter);
    end;

    local procedure CreateLostReasons()
    var
        LostReason: Record "SEW Lost Reason";
    begin
        if not LostReason.Get('NO_BUDGET') then begin
            LostReason.Init();
            LostReason."Reason Code" := 'NO_BUDGET';
            LostReason.Description := 'No Budget Available';
            LostReason.Insert(true);
        end;

        if not LostReason.Get('COMPETITOR') then begin
            LostReason.Init();
            LostReason."Reason Code" := 'COMPETITOR';
            LostReason.Description := 'Chose Competitor Solution';
            LostReason.Insert(true);
        end;

        if not LostReason.Get('NO_NEED') then begin
            LostReason.Init();
            LostReason."Reason Code" := 'NO_NEED';
            LostReason.Description := 'No Current Need';
            LostReason.Insert(true);
        end;

        if not LostReason.Get('TIMING') then begin
            LostReason.Init();
            LostReason."Reason Code" := 'TIMING';
            LostReason.Description := 'Wrong Timing';
            LostReason.Insert(true);
        end;

        if not LostReason.Get('NO_RESPONSE') then begin
            LostReason.Init();
            LostReason."Reason Code" := 'NO_RESPONSE';
            LostReason.Description := 'No Response from Contact';
            LostReason.Insert(true);
        end;
    end;

    local procedure CreateRoutingRules()
    var
        RoutingRule: Record "SEW Lead Routing Rule";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        SalesPersonCode: Code[20];
    begin
        // Get first salesperson if available
        if SalespersonPurchaser.FindFirst() then
            SalesPersonCode := SalespersonPurchaser.Code;

        // Example 1: Score-Based Routing - High Value Leads
        if not RoutingRule.Get('HIGH_VALUE') then begin
            RoutingRule.Init();
            RoutingRule."Rule Code" := 'HIGH_VALUE';
            RoutingRule.Name := 'High Value Leads (Score 70+)';
            RoutingRule."Rule Type" := RoutingRule."Rule Type"::ScoreThreshold;
            RoutingRule.Active := true;
            RoutingRule.Priority := 10;
            RoutingRule."Min Score" := 70;
            RoutingRule."Max Score" := 100;
            RoutingRule."Assignment Type" := RoutingRule."Assignment Type"::Team;
            RoutingRule."Assigned To Code" := 'ENTERPRISE'; // Enterprise team for high-value leads
            RoutingRule.Insert(true);
        end;

        // Example 2: Score-Based Routing - Medium Value Leads
        if not RoutingRule.Get('MEDIUM_VALUE') then begin
            RoutingRule.Init();
            RoutingRule."Rule Code" := 'MEDIUM_VALUE';
            RoutingRule.Name := 'Medium Value Leads (Score 40-69)';
            RoutingRule."Rule Type" := RoutingRule."Rule Type"::ScoreThreshold;
            RoutingRule.Active := true;
            RoutingRule.Priority := 20;
            RoutingRule."Min Score" := 40;
            RoutingRule."Max Score" := 69;
            if SalesPersonCode <> '' then begin
                RoutingRule."Assignment Type" := RoutingRule."Assignment Type"::Salesperson;
                RoutingRule."Assigned To Code" := SalesPersonCode;
            end;
            RoutingRule.Insert(true);
        end;

        // Example 3: Source-Based Routing - Website Leads to Inbound Team
        if not RoutingRule.Get('WEB_LEADS') then begin
            RoutingRule.Init();
            RoutingRule."Rule Code" := 'WEB_LEADS';
            RoutingRule.Name := 'Website Leads to Inbound Team';
            RoutingRule."Rule Type" := RoutingRule."Rule Type"::SourceBased;
            RoutingRule.Active := true;
            RoutingRule.Priority := 30;
            RoutingRule."Source Code" := 'WEB';
            RoutingRule."Assignment Type" := RoutingRule."Assignment Type"::Team;
            RoutingRule."Assigned To Code" := 'INBOUND'; // Inbound team for web leads
            RoutingRule.Insert(true);
        end;

        // Example 4: Source-Based Routing - Email Campaign Leads
        if not RoutingRule.Get('EMAIL_LEADS') then begin
            RoutingRule.Init();
            RoutingRule."Rule Code" := 'EMAIL_LEADS';
            RoutingRule.Name := 'Email Campaign Handler';
            RoutingRule."Rule Type" := RoutingRule."Rule Type"::SourceBased;
            RoutingRule.Active := true;
            RoutingRule.Priority := 35;
            RoutingRule."Source Code" := 'EMAIL';
            if SalesPersonCode <> '' then begin
                RoutingRule."Assignment Type" := RoutingRule."Assignment Type"::Salesperson;
                RoutingRule."Assigned To Code" := SalesPersonCode;
            end;
            RoutingRule.Insert(true);
        end;

        // Example 5: Round Robin Routing - Fair Distribution to Team
        if not RoutingRule.Get('ROUND_ROBIN') then begin
            RoutingRule.Init();
            RoutingRule."Rule Code" := 'ROUND_ROBIN';
            RoutingRule.Name := 'Round Robin to Inbound Team';
            RoutingRule."Rule Type" := RoutingRule."Rule Type"::RoundRobin;
            RoutingRule.Active := false;
            RoutingRule.Priority := 50;
            RoutingRule."Assignment Type" := RoutingRule."Assignment Type"::Team;
            RoutingRule."Assigned To Code" := 'INBOUND';
            RoutingRule.Insert(true);
        end;

        // Example 6: Territory-Based Routing (demonstration)
        if not RoutingRule.Get('TERRITORY') then begin
            RoutingRule.Init();
            RoutingRule."Rule Code" := 'TERRITORY';
            RoutingRule.Name := 'Territory Assignment';
            RoutingRule."Rule Type" := RoutingRule."Rule Type"::Territory;
            RoutingRule.Active := false;
            RoutingRule.Priority := 40;
            if SalesPersonCode <> '' then begin
                RoutingRule."Assignment Type" := RoutingRule."Assignment Type"::Salesperson;
                RoutingRule."Assigned To Code" := SalesPersonCode;
            end;
            RoutingRule.Insert(true);
        end;
    end;

    local procedure CreateScoringModels()
    var
        ScoringModel: Record "SEW Lead Scoring Model";
    begin
        // Model 1: Standard B2B Scoring
        if not ScoringModel.Get('STANDARD') then begin
            ScoringModel.Init();
            ScoringModel."Model Code" := 'STANDARD';
            ScoringModel.Name := 'Standard B2B Scoring';
            ScoringModel.Active := true;
            ScoringModel."Decay Per Day" := 2;
            ScoringModel."Band Hot Threshold" := 80;
            ScoringModel."Band Warm Threshold" := 40;
            ScoringModel.Insert(true);
        end;

        // Model 2: Aggressive Fast-Sales Scoring
        if not ScoringModel.Get('AGGRESSIVE') then begin
            ScoringModel.Init();
            ScoringModel."Model Code" := 'AGGRESSIVE';
            ScoringModel.Name := 'Aggressive Fast-Sales Model';
            ScoringModel.Active := false;
            ScoringModel."Decay Per Day" := 1;
            ScoringModel."Band Hot Threshold" := 70;
            ScoringModel."Band Warm Threshold" := 30;
            ScoringModel.Insert(true);
        end;

        // Model 3: Conservative Enterprise Scoring
        if not ScoringModel.Get('CONSERVATIVE') then begin
            ScoringModel.Init();
            ScoringModel."Model Code" := 'CONSERVATIVE';
            ScoringModel.Name := 'Conservative Enterprise Model';
            ScoringModel.Active := false;
            ScoringModel."Decay Per Day" := 3;
            ScoringModel."Band Hot Threshold" := 90;
            ScoringModel."Band Warm Threshold" := 50;
            ScoringModel.Insert(true);
        end;
    end;

    local procedure CreateScoringRules()
    var
        ScoringRule: Record "SEW Lead Scoring Rule";
    begin
        // Engagement Scoring Rules (source-based)
        if not ScoringRule.Get('WEB_SOURCE', 'STANDARD') then begin
            ScoringRule.Init();
            ScoringRule."Rule Code" := 'WEB_SOURCE';
            ScoringRule."Model Code" := 'STANDARD';
            ScoringRule.Attribute := ScoringRule.Attribute::Source;
            ScoringRule.Operator := ScoringRule.Operator::Equals;
            ScoringRule.Value := 'WEB';
            ScoringRule."Score Delta" := 10;
            ScoringRule."Is Fit Score" := false;
            ScoringRule.Insert(true);
        end;

        if not ScoringRule.Get('EMAIL_SOURCE', 'STANDARD') then begin
            ScoringRule.Init();
            ScoringRule."Rule Code" := 'EMAIL_SOURCE';
            ScoringRule."Model Code" := 'STANDARD';
            ScoringRule.Attribute := ScoringRule.Attribute::Source;
            ScoringRule.Operator := ScoringRule.Operator::Equals;
            ScoringRule.Value := 'EMAIL';
            ScoringRule."Score Delta" := 15;
            ScoringRule."Is Fit Score" := false;
            ScoringRule.Insert(true);
        end;

        if not ScoringRule.Get('REFERRAL_SOURCE', 'STANDARD') then begin
            ScoringRule.Init();
            ScoringRule."Rule Code" := 'REFERRAL_SOURCE';
            ScoringRule."Model Code" := 'STANDARD';
            ScoringRule.Attribute := ScoringRule.Attribute::Source;
            ScoringRule.Operator := ScoringRule.Operator::Equals;
            ScoringRule.Value := 'REFER';
            ScoringRule."Score Delta" := 25;
            ScoringRule."Is Fit Score" := false;
            ScoringRule.Insert(true);
        end;

        // Fit Scoring Rules (employee count as proxy for company size)
        if not ScoringRule.Get('COMPANY_LARGE', 'STANDARD') then begin
            ScoringRule.Init();
            ScoringRule."Rule Code" := 'COMPANY_LARGE';
            ScoringRule."Model Code" := 'STANDARD';
            ScoringRule.Attribute := ScoringRule.Attribute::EmployeeCount;
            ScoringRule.Operator := ScoringRule.Operator::Greater;
            ScoringRule.Value := '100';
            ScoringRule."Score Delta" := 20;
            ScoringRule."Is Fit Score" := true;
            ScoringRule.Insert(true);
        end;

        if not ScoringRule.Get('COMPANY_MEDIUM', 'STANDARD') then begin
            ScoringRule.Init();
            ScoringRule."Rule Code" := 'COMPANY_MEDIUM';
            ScoringRule."Model Code" := 'STANDARD';
            ScoringRule.Attribute := ScoringRule.Attribute::EmployeeCount;
            ScoringRule.Operator := ScoringRule.Operator::Greater;
            ScoringRule.Value := '50';
            ScoringRule."Score Delta" := 10;
            ScoringRule."Is Fit Score" := true;
            ScoringRule.Insert(true);
        end;

        if not ScoringRule.Get('COMPANY_SMALL', 'STANDARD') then begin
            ScoringRule.Init();
            ScoringRule."Rule Code" := 'COMPANY_SMALL';
            ScoringRule."Model Code" := 'STANDARD';
            ScoringRule.Attribute := ScoringRule.Attribute::EmployeeCount;
            ScoringRule.Operator := ScoringRule.Operator::Less;
            ScoringRule.Value := '20';
            ScoringRule."Score Delta" := -5;
            ScoringRule."Is Fit Score" := true;
            ScoringRule.Insert(true);
        end;

        // Additional Engagement Rules
        if not ScoringRule.Get('WEBSITE_VISIT', 'STANDARD') then begin
            ScoringRule.Init();
            ScoringRule."Rule Code" := 'WEBSITE_VISIT';
            ScoringRule."Model Code" := 'STANDARD';
            ScoringRule.Attribute := ScoringRule.Attribute::WebsiteVisit;
            ScoringRule.Operator := ScoringRule.Operator::Equals;
            ScoringRule.Value := 'true';
            ScoringRule."Score Delta" := 8;
            ScoringRule."Is Fit Score" := false;
            ScoringRule.Insert(true);
        end;

        if not ScoringRule.Get('EMAIL_OPEN', 'STANDARD') then begin
            ScoringRule.Init();
            ScoringRule."Rule Code" := 'EMAIL_OPEN';
            ScoringRule."Model Code" := 'STANDARD';
            ScoringRule.Attribute := ScoringRule.Attribute::EmailOpen;
            ScoringRule.Operator := ScoringRule.Operator::Equals;
            ScoringRule.Value := 'true';
            ScoringRule."Score Delta" := 5;
            ScoringRule."Is Fit Score" := false;
            ScoringRule.Insert(true);
        end;

        // AGGRESSIVE MODEL - Fast Sales Focus (higher engagement scores)
        if not ScoringRule.Get('AGG_WEB', 'AGGRESSIVE') then begin
            ScoringRule.Init();
            ScoringRule."Rule Code" := 'AGG_WEB';
            ScoringRule."Model Code" := 'AGGRESSIVE';
            ScoringRule.Attribute := ScoringRule.Attribute::Source;
            ScoringRule.Operator := ScoringRule.Operator::Equals;
            ScoringRule.Value := 'WEB';
            ScoringRule."Score Delta" := 20; // Higher than STANDARD
            ScoringRule."Is Fit Score" := false;
            ScoringRule.Insert(true);
        end;

        if not ScoringRule.Get('AGG_REFERRAL', 'AGGRESSIVE') then begin
            ScoringRule.Init();
            ScoringRule."Rule Code" := 'AGG_REFERRAL';
            ScoringRule."Model Code" := 'AGGRESSIVE';
            ScoringRule.Attribute := ScoringRule.Attribute::Source;
            ScoringRule.Operator := ScoringRule.Operator::Equals;
            ScoringRule.Value := 'REFER';
            ScoringRule."Score Delta" := 35; // Very high for hot leads
            ScoringRule."Is Fit Score" := false;
            ScoringRule.Insert(true);
        end;

        if not ScoringRule.Get('AGG_WEBSITE', 'AGGRESSIVE') then begin
            ScoringRule.Init();
            ScoringRule."Rule Code" := 'AGG_WEBSITE';
            ScoringRule."Model Code" := 'AGGRESSIVE';
            ScoringRule.Attribute := ScoringRule.Attribute::WebsiteVisit;
            ScoringRule.Operator := ScoringRule.Operator::Equals;
            ScoringRule.Value := 'true';
            ScoringRule."Score Delta" := 15; // Higher engagement value
            ScoringRule."Is Fit Score" := false;
            ScoringRule.Insert(true);
        end;

        if not ScoringRule.Get('AGG_EMAIL', 'AGGRESSIVE') then begin
            ScoringRule.Init();
            ScoringRule."Rule Code" := 'AGG_EMAIL';
            ScoringRule."Model Code" := 'AGGRESSIVE';
            ScoringRule.Attribute := ScoringRule.Attribute::EmailOpen;
            ScoringRule.Operator := ScoringRule.Operator::Equals;
            ScoringRule.Value := 'true';
            ScoringRule."Score Delta" := 10; // Quick response to engagement
            ScoringRule."Is Fit Score" := false;
            ScoringRule.Insert(true);
        end;

        if not ScoringRule.Get('AGG_SIZE', 'AGGRESSIVE') then begin
            ScoringRule.Init();
            ScoringRule."Rule Code" := 'AGG_SIZE';
            ScoringRule."Model Code" := 'AGGRESSIVE';
            ScoringRule.Attribute := ScoringRule.Attribute::EmployeeCount;
            ScoringRule.Operator := ScoringRule.Operator::Greater;
            ScoringRule.Value := '10'; // Any viable company
            ScoringRule."Score Delta" := 10;
            ScoringRule."Is Fit Score" := true;
            ScoringRule.Insert(true);
        end;

        // CONSERVATIVE MODEL - Enterprise Focus (higher fit scores, selective)
        if not ScoringRule.Get('CON_ENTERPRISE', 'CONSERVATIVE') then begin
            ScoringRule.Init();
            ScoringRule."Rule Code" := 'CON_ENTERPRISE';
            ScoringRule."Model Code" := 'CONSERVATIVE';
            ScoringRule.Attribute := ScoringRule.Attribute::EmployeeCount;
            ScoringRule.Operator := ScoringRule.Operator::Greater;
            ScoringRule.Value := '500'; // Enterprise only
            ScoringRule."Score Delta" := 40; // Very high fit score
            ScoringRule."Is Fit Score" := true;
            ScoringRule.Insert(true);
        end;

        if not ScoringRule.Get('CON_LARGE', 'CONSERVATIVE') then begin
            ScoringRule.Init();
            ScoringRule."Rule Code" := 'CON_LARGE';
            ScoringRule."Model Code" := 'CONSERVATIVE';
            ScoringRule.Attribute := ScoringRule.Attribute::EmployeeCount;
            ScoringRule.Operator := ScoringRule.Operator::Greater;
            ScoringRule.Value := '200';
            ScoringRule."Score Delta" := 25;
            ScoringRule."Is Fit Score" := true;
            ScoringRule.Insert(true);
        end;

        if not ScoringRule.Get('CON_REFERRAL', 'CONSERVATIVE') then begin
            ScoringRule.Init();
            ScoringRule."Rule Code" := 'CON_REFERRAL';
            ScoringRule."Model Code" := 'CONSERVATIVE';
            ScoringRule.Attribute := ScoringRule.Attribute::Source;
            ScoringRule.Operator := ScoringRule.Operator::Equals;
            ScoringRule.Value := 'REFER';
            ScoringRule."Score Delta" := 30; // Trusted referrals valued
            ScoringRule."Is Fit Score" := false;
            ScoringRule.Insert(true);
        end;

        if not ScoringRule.Get('CON_SMALL', 'CONSERVATIVE') then begin
            ScoringRule.Init();
            ScoringRule."Rule Code" := 'CON_SMALL';
            ScoringRule."Model Code" := 'CONSERVATIVE';
            ScoringRule.Attribute := ScoringRule.Attribute::EmployeeCount;
            ScoringRule.Operator := ScoringRule.Operator::Less;
            ScoringRule.Value := '50';
            ScoringRule."Score Delta" := -20; // Heavily deprioritize small companies
            ScoringRule."Is Fit Score" := true;
            ScoringRule.Insert(true);
        end;

        if not ScoringRule.Get('CON_WEB', 'CONSERVATIVE') then begin
            ScoringRule.Init();
            ScoringRule."Rule Code" := 'CON_WEB';
            ScoringRule."Model Code" := 'CONSERVATIVE';
            ScoringRule.Attribute := ScoringRule.Attribute::Source;
            ScoringRule.Operator := ScoringRule.Operator::Equals;
            ScoringRule.Value := 'WEB';
            ScoringRule."Score Delta" := 5; // Lower engagement value
            ScoringRule."Is Fit Score" := false;
            ScoringRule.Insert(true);
        end;
    end;

    local procedure CreateIndustryGroups()
    var
        IndustryGroup: Record "Industry Group";
    begin
        // Technology - High score
        if not IndustryGroup.Get('TECH') then begin
            IndustryGroup.Init();
            IndustryGroup.Code := 'TECH';
            IndustryGroup.Description := 'Technology';
            IndustryGroup."SEW Lead Score" := 20;
            IndustryGroup.Insert(true);
        end else begin
            IndustryGroup."SEW Lead Score" := 20;
            IndustryGroup.Modify(true);
        end;

        // Manufacturing - Medium-high score
        if not IndustryGroup.Get('MFG') then begin
            IndustryGroup.Init();
            IndustryGroup.Code := 'MFG';
            IndustryGroup.Description := 'Manufacturing';
            IndustryGroup."SEW Lead Score" := 15;
            IndustryGroup.Insert(true);
        end else begin
            IndustryGroup."SEW Lead Score" := 15;
            IndustryGroup.Modify(true);
        end;

        // Healthcare - Medium score
        if not IndustryGroup.Get('HEALTH') then begin
            IndustryGroup.Init();
            IndustryGroup.Code := 'HEALTH';
            IndustryGroup.Description := 'Healthcare';
            IndustryGroup."SEW Lead Score" := 12;
            IndustryGroup.Insert(true);
        end else begin
            IndustryGroup."SEW Lead Score" := 12;
            IndustryGroup.Modify(true);
        end;

        // Finance - Medium score
        if not IndustryGroup.Get('FINANCE') then begin
            IndustryGroup.Init();
            IndustryGroup.Code := 'FINANCE';
            IndustryGroup.Description := 'Finance';
            IndustryGroup."SEW Lead Score" := 10;
            IndustryGroup.Insert(true);
        end else begin
            IndustryGroup."SEW Lead Score" := 10;
            IndustryGroup.Modify(true);
        end;

        // Retail - Low score
        if not IndustryGroup.Get('RETAIL') then begin
            IndustryGroup.Init();
            IndustryGroup.Code := 'RETAIL';
            IndustryGroup.Description := 'Retail';
            IndustryGroup."SEW Lead Score" := 5;
            IndustryGroup.Insert(true);
        end else begin
            IndustryGroup."SEW Lead Score" := 5;
            IndustryGroup.Modify(true);
        end;
    end;

    local procedure CreateDemoTeams()
    var
        Team: Record Team;
        TeamSalesperson: Record "Team Salesperson";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
    begin
        // Create Inbound Sales Team
        if not Team.Get('INBOUND') then begin
            Team.Init();
            Team.Code := 'INBOUND';
            Team.Name := 'Inbound Sales Team';
            Team.Insert(true);

            // Add first two salespersons to team
            if SalespersonPurchaser.FindFirst() then begin
                if not TeamSalesperson.Get('INBOUND', SalespersonPurchaser.Code) then begin
                    TeamSalesperson.Init();
                    TeamSalesperson."Team Code" := 'INBOUND';
                    TeamSalesperson."Salesperson Code" := SalespersonPurchaser.Code;
                    TeamSalesperson.Insert(true);
                end;

                // Add second salesperson if available
                if SalespersonPurchaser.Next() <> 0 then begin
                    if not TeamSalesperson.Get('INBOUND', SalespersonPurchaser.Code) then begin
                        TeamSalesperson.Init();
                        TeamSalesperson."Team Code" := 'INBOUND';
                        TeamSalesperson."Salesperson Code" := SalespersonPurchaser.Code;
                        TeamSalesperson.Insert(true);
                    end;
                end;
            end;
        end;

        // Create Enterprise Sales Team
        if not Team.Get('ENTERPRISE') then begin
            Team.Init();
            Team.Code := 'ENTERPRISE';
            Team.Name := 'Enterprise Sales Team';
            Team.Insert(true);

            // Add second and third salespersons to enterprise team
            SalespersonPurchaser.Reset();
            if SalespersonPurchaser.FindSet() then begin
                // Skip first, add second and third
                if SalespersonPurchaser.Next() <> 0 then begin
                    if not TeamSalesperson.Get('ENTERPRISE', SalespersonPurchaser.Code) then begin
                        TeamSalesperson.Init();
                        TeamSalesperson."Team Code" := 'ENTERPRISE';
                        TeamSalesperson."Salesperson Code" := SalespersonPurchaser.Code;
                        TeamSalesperson.Insert(true);
                    end;

                    if SalespersonPurchaser.Next() <> 0 then begin
                        if not TeamSalesperson.Get('ENTERPRISE', SalespersonPurchaser.Code) then begin
                            TeamSalesperson.Init();
                            TeamSalesperson."Team Code" := 'ENTERPRISE';
                            TeamSalesperson."Salesperson Code" := SalespersonPurchaser.Code;
                            TeamSalesperson.Insert(true);
                        end;
                    end;
                end;
            end;
        end;
    end;
}