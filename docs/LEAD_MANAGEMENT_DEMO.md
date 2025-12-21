# Lead Management System - Customer Demo Walkthrough

**Version**: 1.0  
**Duration**: 30-45 minutes  
**Target Audience**: Sales Directors, Sales Operations Managers, CRM Administrators

---

## Demo Overview

This walkthrough demonstrates a complete lead management lifecycle in Microsoft Dynamics 365 Business Central, showcasing:
- ✅ AI-powered lead scoring with multiple models
- ✅ Automated lead routing and assignment
- ✅ Team-based and individual assignments
- ✅ Lead progression and conversion to opportunities
- ✅ Analytics and reporting

---

## Prerequisites

Before starting the demo:
1. Open Business Central in a test environment
2. Navigate to **SEW Demo Data Management** page
3. Click **Create Demo Data** action
4. Confirm demo data creation (creates 20+ sample leads, scoring models, routing rules, teams)

---

## Part 1: Configuration & Setup (5 minutes)

### 1.1 Scoring Models Overview

**Goal**: Show how different scoring strategies prioritize leads differently.

**Steps**:
1. Search for **SEW Lead Scoring Models** in Business Central search
2. Show three pre-configured models:

   **STANDARD Model** (Active):
   - Balanced approach for general sales teams
   - Combines engagement signals (web visits, emails) with company fit
   - Best for: Mid-market sales teams

   **AGGRESSIVE Model** (Inactive):
   - Fast sales focus - higher engagement scores
   - Quick response to any activity (web, email, referrals)
   - Best for: High-velocity sales, volume-based approach
   
   **CONSERVATIVE Model** (Inactive):
   - Selective approach - emphasizes referrals and qualified sources
   - Lower scores for cold web leads
   - Best for: Enterprise sales teams with consultative approach
![alt text](image.png)


3. Click into **STANDARD** model → click **Navigate → Scoring Rules**
4. Show sample rules:
   - `WEB_SOURCE`: +10 points (engagement)
   - `COMPANY_LARGE`: +20 points (Employee Count > 100)
   - `REFERRAL_SOURCE`: +25 points (high-intent)
   - `EMAIL_SOURCE`: +15 points (direct contact)
   - `WEBSITE_VISIT`: +8 points (engagement signal)
   - `EMAIL_OPEN`: +5 points (engagement signal)
![alt text](image-1.png)

**Key Message**: *"Different sales strategies require different scoring. You can switch models or create custom ones without changing any lead data."*

---

### 1.2 Routing Rules Configuration

**Goal**: Demonstrate automated assignment based on business rules.

**Steps**:
1. Search for **SEW Lead Routing Rules**
2. Explain the routing hierarchy:

   | Priority | Rule Type | Condition | Assignment |
   |----------|-----------|-----------|------------|
   | 10 | Score Threshold | Score ≥ 75 | ENTERPRISE Team |
   | 20 | Source-Based | Source = WEB | INBOUND Team |
   | 30 | Source-Based | Source = REFER | Top Salesperson |
   | 40 | Territory | Country = US | US Salesperson |
   | 50 | Score Threshold | Score ≥ 50 | Mid-level Salesperson |
   | 60 | Round Robin | Default | Automatic rotation |
![alt text](image-2.png)

3. Click into **High Value Leads** rule (Priority 10)
   - Show: **Assignment Type** = Team
   - Show: **Assigned To Code** = ENTERPRISE
   - Explain: *"Hot leads (75+ score) automatically go to our enterprise sales team"*

4. Click into **Web Leads** rule (Priority 20)
   - Show: **Assignment Type** = Team
   - Show: **Assigned To Code** = INBOUND
   - Explain: *"All web-sourced leads go to our inbound response team for quick follow-up"*

**Key Message**: *"Rules execute in priority order. First matching rule wins. Mix team and individual assignments based on your sales process."*

---

### 1.3 Team Structure

**Goal**: Show how teams enable collaborative lead management.

**Steps**:
1. Search for **Teams** (standard BC object)
2. Open **INBOUND** team
   - Show members (2-3 salespersons)
   - Explain: *"Inbound team handles all web/email leads for rapid response"*
3. Open **ENTERPRISE** team
   - Show members (2-3 salespersons)
   - Explain: *"Enterprise team handles high-score leads requiring consultative selling"*
![alt text](image-3.png)

**Key Message**: *"Teams share lead ownership. Any team member can see and work team-assigned leads. Perfect for pod-based selling models."*

---

## Part 2: Lead Lifecycle (10 minutes)

### 2.1 Create a New Lead

**Goal**: Show manual lead creation and automatic scoring.

**Steps**:
1. Search for **SEW Leads** ![alt text](image-5.png)
2. Click **+ New** to create a lead
3. Fill in details:
   - **Quick Company Name**: "Contoso Manufacturing Inc."
   - **Quick Email**: "purchasing@contoso.com"
   - **Quick Phone**: "+1-555-0123"
   - **Source Code**: WEB
   - **Status**: New
   - **Expected Revenue**: 50000
   - **Employee Count**: 250 (in Company Details section)
![alt text](image-6.png)

4. Click **Actions → Calculate Score**
5. Show **Score (Total)** field update (should be ~30 points: WEB_SOURCE +10, COMPANY_LARGE +20)
6. Show **Scoring Details** FactBox on the right:
   - Lists all applied rules
   - Shows engagement vs fit score breakdown
![alt text](image-9.png)

7. Click **Actions → Apply Routing**
8. Show automatic assignment:
   - **Assignment Type**: Team
   - **Assigned To**: INBOUND (because Source = WEB, Priority 20 rule)
   - **Assigned To Name**: "INBOUND Team"
![alt text](image-7.png)

**Key Message**: *"Leads are automatically scored and routed based on your rules. No manual assignment needed unless you want to override."*

---

### 2.2 High-Score Lead Example

**Goal**: Show how high-value leads route differently.

**Steps**:
1. Click **+ New** to create another lead
2. Fill in details:
   - **Quick Company Name**: "Fabrikam Enterprises Ltd."
   - **Quick Email**: "ceo@fabrikam.com"
   - **Quick Phone**: "+1-555-9999"
   - **Source Code**: REFER (referral)
   - **Expected Revenue**: 250000
   - **Employee Count**: 500 (in Company Details section)

3. Enable engagement signals in **Engagement Signals** section:
   - Toggle **Website Visit**: Yes (enable the switch)
   - Toggle **Email Opened**: Yes (enable the switch)
![alt text](image-10.png)

4. Click **Actions → Calculate Score**
5. Show high score (should be ~58 points: REFERRAL_SOURCE +25, COMPANY_LARGE +20, WEBSITE_VISIT +8, EMAIL_OPEN +5)

6. Click **Actions → Apply Routing**
7. Show assignment:
   - **Assignment Type**: Team
   - **Assigned To**: INBOUND (because Source = REFER matches Priority 30 rule, score not high enough for Priority 10)
![alt text](image-11.png)

8. **To demonstrate high-score routing**, manually increase score to 80:
   - Change **Score (Total)** to **80**
   - Click **Actions → Apply Routing** again
   - Now shows **Assigned To**: ENTERPRISE (because Score ≥ 75, Priority 10 rule)

**Key Message**: *"High-score leads automatically escalate to your best team. Routing priority ensures hot leads get immediate attention."*

---

### 2.3 Lead Qualification & Progression

**Goal**: Show how leads move through the sales pipeline.

**Steps**:
1. Navigate to **SEW Leads** 
2. Apply filters to see only your leads:
   - Open **Filter Pane** (right side)
   - Filter **Assignment Type** = "Salesperson"
   - Filter **Salesperson Code** = your salesperson code
   - Alternatively: Filter **Assignment Type** = "Team" and show team-assigned leads
![alt text](image-12.png)
3. Explain filter logic: *"You can filter to see leads assigned to you individually, or to any team you're a member of"*
4. Open the "Contoso Manufacturing" lead created earlier
5. **Create/Link Contact** (required before qualifying):
   - Click **Actions → Create/Link Contact**
   - System creates a BC Contact record from the lead's Quick fields
   - Show the **Contact No.** field is now populated
   - Explain: *"A Contact is required to qualify a lead - this integrates with BC's standard CRM"*
![alt text](image-13.png)
6. Change **Status** from "New" to "Qualified"
   - Explain status meanings:
     - **New**: Just received, not yet reviewed
     - **Contacted**: Sales rep made first contact
     - **Qualified**: Meets criteria, ready for opportunity (requires Contact)
     - **Disqualified**: Not a fit, archived
![alt text](image-14.png) 

7. Show **Lead Card** tabs:
   - **General**: Core info and assignment
   - **Company Details**: Firmographic data for scoring
   - **Communication**: Contact history
   - **Scoring**: Score breakdown

8. Add a note in **Communication** section:
   - "Called 12/21. Interested in demo. Follow up next week."
![alt text](image-15.png)
**Key Message**: *"Track lead progression and keep all communication history in one place. Your team sees the same view for team-assigned leads."*

---

### 2.4 Lead Reassignment

**Goal**: Show manual reassignment flexibility.

**Steps**:
1. Still on the "Contoso Manufacturing" lead
2. Show current assignment: **INBOUND Team**
3. Click **Actions → Reassign Lead**
4. In dialog:
   - Change **Assignment Type** to "Salesperson"
   - Select a specific salesperson from lookup
   - Add **Reason**: "Lead requires enterprise expertise"
   - Click **OK**

5. Navigate to **Related → Assignment History**
6. Show log entry:
   - **From**: INBOUND Team
   - **To**: [Salesperson Name]
   - **Reason**: "Lead requires enterprise expertise"
   - **Timestamp**: Current date/time
   - **Changed By**: Your user

**Key Message**: *"Override automatic routing anytime. Full audit trail tracks all reassignments for visibility and coaching."*

---

## Part 3: Conversion to Opportunity (5 minutes)

### 3.1 Convert Individual-Assigned Lead

**Goal**: Show standard lead-to-opportunity conversion.

**Steps**:
1. Open a lead assigned to an **individual salesperson** (not a team)
2. Ensure **Status** = "Qualified"
3. Click **Actions → Convert to Opportunity**
4. Show conversion dialog:
   - **Create Contact**: Yes (creates/links BC Contact record)
   - **Salesperson**: Auto-populated from lead assignment
   - **Opportunity Description**: Auto-populated from lead name
![alt text](image-17.png)

5. Click **OK**
6. System navigates to new **Opportunity Card**
7. Show fields populated from lead:
   - Salesperson Code
   - Contact information
   - Description
   - Estimated value (if entered on lead)
![alt text](image-16.png)

8. Navigate back to **SEW Leads** → find original lead
9. Show **Status** = "Converted"
10. Show **Related → Opportunity** link

**Key Message**: *"One-click conversion from qualified lead to BC opportunity. All data transfers automatically."*

---

### 3.2 Convert Team-Assigned Lead

**Goal**: Show team-to-salesperson conversion logic.

**Steps**:
1. Open a lead assigned to a **team** (e.g., ENTERPRISE team)
2. Ensure **Status** = "Qualified"
3. Click **Actions → Convert to Opportunity**
4. Show dialog with **Salesperson Selection**:
   - If you're in the team: Auto-selects your user
   - If you're not in team: Shows all team members to choose from
   - If team has only one member: Auto-selects that member

5. Select salesperson → Click **OK**
6. Show opportunity created with selected salesperson
7. Explain: *"Opportunities in BC require an individual owner. When converting team leads, you select which team member takes ownership."*

**Key Message**: *"Seamless handoff from team collaboration (lead stage) to individual ownership (opportunity stage). Respects BC's opportunity model."*

---

## Part 4: Analytics & Reporting (5 minutes)

### 4.1 Lead Assignment Log

**Goal**: Show audit trail and reassignment analytics.

**Steps**:
1. Search for **SEW Lead Assignment Log**
2. Show columns:
   - Lead No.
   - Lead Name
   - **From Assignment Type** / **From Assigned To**
   - **To Assignment Type** / **To Assigned To**
   - Reason
   - Assigned Date
   - Assigned By

3. Filter by **Reason** = "Automatic Routing" → show system-generated assignments
4. Clear filter → Filter by **Assigned By** = your user → show manual reassignments
5. Explain use cases:
   - Track reassignment frequency (coaching opportunity)
   - Identify bottlenecks (leads bouncing between teams)
   - Audit compliance requirements

**Key Message**: *"Every assignment change is logged. Use this for performance analysis and process improvement."*

---

### 4.2 Lead List Analytics

**Goal**: Show built-in list views and filtering.

**Steps**:
1. Navigate to **SEW Leads** (full list)
2. Use **Filter Pane** (right side):
   - Filter **Status** = "New" → show unworked leads
   - Filter **Assignment Type** = "Team" → show all team-assigned leads
   - Filter **Score** ≥ 70 → show high-priority leads

3. Show **Sorting**:
   - Sort by **Score** (descending) → highest priority first
   - Sort by **Created Date** → oldest leads first (prevent aging)

4. Show **FactBoxes** (right side):
   - Scoring Details
   - Contact Information
   - Activities (if integrated)

5. Explain: *"Standard BC list views. Users can save personal filters and create custom views."*

**Key Message**: *"All the power of Business Central list pages. Filter, sort, export to Excel, or integrate with Power BI."*

---

### 4.3 Scoring Model Comparison

**Goal**: Show how changing models affects lead prioritization.

**Steps**:
1. Navigate to **SEW Lead Scoring Models**
2. Open **STANDARD** model → Click **Set Active** if not already
3. Navigate to **SEW Leads** → sort by **Score** descending
4. Note the top 5 leads and their scores (write them down or screenshot)

5. Go back to **SEW Lead Scoring Models**
6. Open **AGGRESSIVE** model → Click **Set Active**
7. Navigate back to **SEW Leads**
8. Click **Actions → Recalculate All Scores** (mass action)
9. Show how lead rankings changed:
   - Engagement-heavy leads moved up (more web visits, more referrals)
   - Higher scores for any activity

10. Repeat with **CONSERVATIVE** model:
    - Referrals valued much higher
    - Web leads scored lower
    - More selective scoring approach

11. Switch back to **STANDARD** model → **Recalculate All Scores**

**Key Message**: *"Switch scoring strategies without changing lead data. Test different models before committing. Perfect for A/B testing your sales process."*

---

## Part 5: Advanced Features (5-10 minutes)

### 5.1 Round Robin Assignment

**Goal**: Show automatic workload distribution.

**Steps**:
1. Navigate to **SEW Lead Routing Rules**
2. Find the lowest priority rule (Priority 60): **Default Assignment**
3. Show **Rule Type** = "Round Robin"
4. Explain: *"If no other rules match, leads are distributed evenly across all active salespersons"*

5. Create 3 new leads quickly:
   - Use source "PHONE" (not matched by other rules)
   - Leave score low (< 50)
   - Don't enter territory

6. For each lead, click **Actions → Apply Routing**
7. Show each lead assigned to a different salesperson in rotation
8. Explain tracking: *"System tracks last assigned user and rotates to next. Ensures fair distribution."*

**Key Message**: *"Prevent lead hoarding. Round robin ensures equitable workload distribution for unqualified or inbound leads."*

---

### 5.2 Manual Scoring Override

**Goal**: Show flexibility for edge cases.

**Steps**:
1. Open any lead
2. Show calculated **Score** (e.g., 45)
3. Manually change **Score** to 100
4. Click **Actions → Apply Routing**
5. Show lead routes to ENTERPRISE team (high score rule)
6. Explain use cases:
   - Strategic accounts (CEO referral)
   - Event-driven urgency (trade show VIP)
   - Executive override

7. Click **Actions → Calculate Score** to revert to rule-based scoring

**Key Message**: *"Automation with flexibility. Override anytime for strategic decisions. Recalculate to restore rule-based scoring."*

---

### 5.3 Bulk Operations

**Goal**: Show efficiency features for high-volume lead management.

**Steps**:
1. Navigate to **SEW Leads**
2. Select multiple leads (Ctrl+Click or checkboxes if enabled)
3. Show available bulk actions:
   - **Recalculate Scores**: Update all selected leads
   - **Apply Routing**: Auto-assign all selected leads
   - **Change Status**: Mass update (e.g., New → Contacted)
   - **Export to Excel**: For external analysis

4. Select 5 "New" leads → Click **Actions → Apply Routing**
5. Show all 5 leads assigned automatically based on their individual attributes

**Key Message**: *"Process 100 leads as easily as 1. Built-in bulk actions for high-velocity sales teams."*

---

## Part 6: Integration Points (5 minutes)

### 6.1 Contact Creation

**Goal**: Show CRM integration with standard BC.

**Steps**:
1. Open a lead
2. Show **Related → Contact** action
3. If no contact exists yet: Click **Actions → Create Contact**
4. Show Contact Card auto-populated:
   - Name
   - Company
   - Email
   - Phone
   - Address

5. Navigate back to lead → show contact now linked
6. Explain: *"Leads feed into standard BC contact management. All your CRM data in one place."*

**Key Message**: *"Not a separate CRM. Native integration with Business Central contacts, opportunities, and sales processes."*

---

### 6.2 Opportunity Tracking

**Goal**: Show pipeline visibility from lead through opportunity.

**Steps**:
1. Navigate to **SEW Leads** → filter **Status** = "Converted"
2. Open a converted lead
3. Click **Related → Opportunity**
4. Show standard BC **Opportunity Card**
5. Navigate to **Sales Opportunities** (standard BC)
6. Show all opportunities including those from leads
7. Explain: *"Once converted, use standard BC opportunity management. Seamless transition."*

**Key Message**: *"Lead Management extends BC, doesn't replace it. Your existing sales process continues unchanged."*

---

### 6.3 Extensibility

**Goal**: Show API and integration capabilities (technical audience).

**Steps**:
1. Explain: *"All lead data accessible via OData/REST APIs"*
2. Show sample API endpoint (if available):
   - `GET /api/v2.0/companies({id})/sewLeads`
   - `POST /api/v2.0/companies({id})/sewLeads`

3. Explain integration scenarios:
   - Marketing automation platforms → create leads automatically
   - Web forms → POST lead data directly
   - Chatbots → capture lead info and score in real-time
   - Power Automate flows → trigger actions on high-score leads

4. Mention: *"Built on BC extensibility. Add custom fields, rules, or integrations without modifying core code."*

**Key Message**: *"Open architecture. Connect to your existing marketing stack. Extend without limits."*

---

### Lead Kanban
![alt text](image-18.png)

## Demo Closing & Q&A

### Summary Recap

✅ **Automated Scoring**: Multiple models, rule-based, transparent
✅ **Intelligent Routing**: Priority-based, team and individual assignments
✅ **Collaborative Selling**: Team-based lead ownership with individual handoff
✅ **Full Lifecycle**: Lead creation → qualification → conversion → opportunity
✅ **Complete Visibility**: Audit trails, analytics, bulk operations
✅ **Native BC Integration**: Contacts, opportunities, salespersons, standard sales process

### Value Proposition

**For Sales Reps**:
- No more manual lead assignment
- Clear priorities via scoring
- "My Leads" view for focus
- One system for leads + opportunities

**For Sales Managers**:
- Fair lead distribution (round robin)
- Performance tracking (assignment logs)
- Flexible scoring strategies
- Team-based accountability

**For Sales Ops**:
- Configurable rules without code
- A/B test scoring models
- Audit trail for compliance
- API integration for automation

### Common Questions

**Q: Can we use our existing scoring rules from [other CRM]?**
A: Yes. Scoring rules are configuration, not code. Import your logic into SEW Lead Scoring Rules.

**Q: What if a lead needs to be assigned outside the rules?**
A: Manual reassignment anytime. Automation is optional, not mandatory.

**Q: How do we report on lead conversion rates?**
A: Standard BC reporting on opportunities. Tag opportunity source as "Lead" and use filters. Power BI integration available.

**Q: Can we add custom fields to leads (e.g., industry, vertical)?**
A: Yes. Standard BC table extension. Add fields, update scoring rules to use them.

**Q: Do we need separate licenses?**
A: Uses standard BC licenses. No additional cost. Salesperson + team functionality built into BC.

---

## Next Steps

1. **Proof of Concept**: 30-day trial in sandbox environment
2. **Configuration Workshop**: Map your existing sales process to routing rules
3. **Integration Setup**: Connect marketing automation and web forms
4. **User Training**: 2-hour session for sales team
5. **Go Live**: Phased rollout (start with new leads, migrate historical data later)

---

## Support Resources

- **Documentation**: See README.md in extension folder
- **Technical Guide**: See TECHNICAL_DOCUMENTATION.md
- **Change Log**: See CHANGELOG.md for version history
- **Issues**: Report at [GitHub repository link]

---

*Demo script version 1.0 | Last updated: December 21, 2025*
