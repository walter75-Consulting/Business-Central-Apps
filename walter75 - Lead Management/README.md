# walter75 - Lead Management

Contact-centric CRM Lead Management for Microsoft Dynamics 365 Business Central.

## Overview

This extension enables SMBs to manage sales leads within Business Central without requiring external systems. It provides a complete lead qualification workflow with Contact integration, AI-powered scoring, automated routing, team collaboration, and conversion to Opportunities.

## Key Features

### Lead Management
- **Quick Capture**: Fast lead entry with company/email/phone fields
- **Hybrid Contact Pattern**: Optional Contact reference, auto-created on engagement
- **Status Workflow**: New → Contacted → Nurturing → Qualified → Converted/Disqualified
- **Deduplication**: Exact match by email and Contact reference
- **GDPR Compliance**: Marketing consent tracking with timestamp and source
- **BC Integration**: Native Contact, Opportunity, Campaign, Activity integration

### Multi-Model Scoring
- **Configurable Models**: STANDARD, AGGRESSIVE, CONSERVATIVE scoring strategies
- **Rule-Based Engine**: Source, company size, engagement signal scoring
- **Score Bands**: Hot (70+), Warm (40-69), Cold (<40) with visual indicators
- **Real-Time Calculation**: Instant score updates with transparent rule breakdown
- **A/B Testing**: Switch models without changing lead data

### Intelligent Routing
- **Priority-Based Rules**: First-match routing with precedence control
- **Assignment Types**: Individual salesperson or team-based collaboration
- **Rule Conditions**: Score threshold, source-based, territory, round-robin
- **Automatic Distribution**: Fair workload balancing across team members
- **Manual Override**: Reassignment with full audit trail

### Team Collaboration
- **Shared Ownership**: Team-assigned leads visible to all members
- **Individual Handoff**: Convert team leads to individual opportunities
- **Assignment History**: Complete audit trail of all assignment changes
- **Communication Tracking**: Notes and activities shared across team

### Pipeline Management
- **Custom Stages**: Configure pipeline with sequence and probability
- **Kanban Board**: Drag-and-drop visual pipeline management
- **Color Coding**: Score band visualization (Hot/Warm/Cold)
- **Stage Filtering**: Filter by owner, score band, source code
- **Progress Tracking**: Average days in stage analysis

### Analytics & Reporting
- **Real-Time Dashboard**: Active leads, pipeline value, conversion metrics
- **Performance Queries**: Funnel analysis, source performance, user performance, campaign ROI
- **Power BI Export**: Native query export for advanced analytics
- **Role Center Integration**: Cue tiles for quick access to key metrics
- **Drill-Down Navigation**: Click any metric to view filtered lead list

### API & Integration
- **OData/REST APIs**: Full CRUD operations on leads
- **UTM Attribution**: Marketing campaign tracking with Google Analytics parameters
- **Document Attachments**: Link files and documents to leads
- **Lead→Opportunity Mapping**: Conversion tracking for ROI analysis
- **Power Automate**: Trigger flows on lead events (new, qualified, converted)

## Object ID Range

**91700-91799** (100 objects)

## Architecture

- **Hybrid Pattern**: Leads optionally reference BC Contacts, auto-created when Status → Working
- **System Audit**: Leverages BC's SystemCreatedBy/At, SystemModifiedBy/At
- **Extensibility**: All enums marked Extensible = true
- **Target**: BC Cloud, Platform 27.0, Runtime 16.0


## Installation

1. Download symbols: `Ctrl+Shift+P` → AL: Download Symbols
2. Build: `Ctrl+Shift+B`
3. Publish: `Ctrl+F5`

## Configuration

1. Open **Lead Setup** page
2. Configure:
   - Lead No. Series
   - Default Owner (optional)
   - Auto Create Contact On Working (recommended: Yes)
   - Enable Quick Capture (recommended: Yes)
   - SLA First Response hours

3. Create **Lead Sources** (e.g., WEB-CONTACT, EVENT-TRADESHOW, REFERRAL, EMAIL)

## Usage

### Creating a Lead (Quick Capture)
1. Open **Lead List** → New
2. Enter Quick Company Name, Quick Email, Quick Phone
3. Select Source Code
4. Status = New (auto-set)

### Working a Lead
1. Change Status to **Working**
2. System auto-creates Contact from quick fields
3. Quick fields cleared, Contact linked

### Qualifying a Lead
1. Ensure Contact exists (mandatory for Qualified status)
2. Enter Expected Revenue and Probability %
3. Change Status to **Qualified**

### Converting to Opportunity
1. From qualified Lead Card, action: **Convert to Opportunity**
2. System creates Opportunity with Contact, Revenue, Probability
3. Lead Status → Converted

## Support

- Documentation: https://www.walter75.de
- Contact: walter75 - München

## Version History

See [CHANGELOG.md](CHANGELOG.md) for detailed version history.

## Support & Documentation

- **Technical Documentation**: See GitHub Pages documentation
- **User Guide**: Comprehensive guide for sales teams
- **Issue Tracking**: GitHub Issues
- **Contact**: walter75 - München

## License

(c) 2024 walter75 - München. All rights reserved.
