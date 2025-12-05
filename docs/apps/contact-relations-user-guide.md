# walter75 - Contact Relations
## User Guide

**Version:** 26.2.0  
**Publisher:** walter75 Consulting  
**Platform:** Microsoft Dynamics 365 Business Central Cloud

---

## Table of Contents

1. [Introduction](#introduction)
2. [Setup](#setup)
3. [Defining Relationship Types](#defining-relationship-types)
4. [Creating Contact Relationships](#creating-contact-relationships)
5. [Managing Decision Makers](#managing-decision-makers)
6. [Visualizing Networks](#visualizing-networks)
7. [Troubleshooting](#troubleshooting)

---

## Introduction

The **walter75 - Contact Relations** extension enhances Business Central's CRM capabilities with advanced relationship mapping, contact hierarchies, and decision maker tracking. Build comprehensive views of your business network.

### Key Features

- 🔗 **Relationship Mapping**: Link contacts with meaningful relationships
- 👥 **Contact Hierarchies**: Organizational structures and reporting lines
- 🎯 **Decision Maker Tracking**: Identify key influencers and approvers
- 📝 **Interaction History**: Track communication and relationship strength
- 🗺️ **Network Visualization**: Graphical representation of relationships
- 📊 **Influence Scoring**: Quantify contact importance
- 🔍 **Smart Search**: Find contacts by relationship or role

---

## Setup

### Step 1: Contact Relations Setup

1. Search for **"Contact Relations Setup"**
2. Configure general settings:
   - **Enable Relationship Tracking**: Activate feature
   - **Auto-Create Reverse Relations**: Automatically create bidirectional links
   - **Default Relationship Strength**: Initial strength value (1-5)
   - **Interaction Scoring**: Points for emails, meetings, calls
   - **Decision Maker Levels**: Number of hierarchy levels

![Screenshot: Contact Relations Setup]
*Placeholder for screenshot of setup page*

### Step 2: Import Existing Contacts

If you have existing Business Central contacts:

1. System can import from:
   - Contact list
   - Customer contacts
   - Vendor contacts
2. Click **Actions** → **"Import Contacts"**
3. Select source and filters
4. Review and confirm import

![Screenshot: Import Contacts Dialog]
*Placeholder for screenshot of contact import*

---

## Defining Relationship Types

### Standard Relationship Types

The system includes predefined types:

**Professional Relationships:**
- Reports To / Manager Of
- Colleague / Peer
- Customer / Supplier
- Partner / Collaborator
- Consultant / Advisor

**Personal Relationships:**
- Friend
- Family Member
- Alumni
- Association Member

![Screenshot: Relationship Types List]
*Placeholder for screenshot of predefined relationship types*

### Creating Custom Relationship Types

1. Search for **"Relationship Types"**
2. Click **+ New**
3. Define:
   - **Code**: Unique identifier (e.g., "MENTOR")
   - **Description**: Relationship name (e.g., "Mentor/Mentee")
   - **Reverse Description**: Opposite perspective (e.g., "Mentored By")
   - **Category**: Professional, Personal, Family
   - **Importance Level**: How significant this relationship type is (1-5)
   - **Color**: For visual distinction in diagrams

![Screenshot: Custom Relationship Type]
*Placeholder for screenshot of custom relationship type creation*

### Relationship Strength Indicators

Define what each strength level means:

| Level | Description | Examples |
|-------|-------------|----------|
| 1 | Weak | Met once, cold contact |
| 2 | Acquaintance | Occasional interaction |
| 3 | Regular Contact | Monthly communication |
| 4 | Strong Relationship | Weekly interaction, trusted |
| 5 | Key Relationship | Daily contact, strategic importance |

---

## Creating Contact Relationships

### Method 1: From Contact Card

1. Open **Contact Card**
2. Navigate to **Relations** tab or FactBox
3. Click **+ New Relation**
4. Enter:
   - **Related Contact**: Select contact to link
   - **Relationship Type**: Select type
   - **Strength**: 1-5 scale
   - **Start Date**: When relationship began
   - **Notes**: Additional context

![Screenshot: Create Relation from Contact]
*Placeholder for screenshot of relationship creation*

### Method 2: Quick Relationship Creation

Use the relationship wizard:

1. Search for **"Create Contact Relationship"**
2. Enter **Contact 1** and **Contact 2**
3. Select **Relationship Type**
4. System creates relationship (and reverse if enabled)

![Screenshot: Relationship Wizard]
*Placeholder for screenshot of quick relationship wizard*

### Method 3: Organizational Hierarchy

For company structures:

1. Open **Contact Card** for company
2. Navigate to **Organization** FastTab
3. Define:
   - **Parent Company**: If subsidiary
   - **Division/Department**: Organizational unit
4. Click **"Define Org Structure"**
5. Add reporting relationships:
   - CEO → VPs → Directors → Managers

![Screenshot: Org Structure Builder]
*Placeholder for screenshot of organizational structure tool*

### Relationship Attributes

Enhance relationships with additional data:

**Common Attributes:**
- **Primary Contact**: Is this the main contact at company?
- **Decision Authority**: Can they approve purchases?
- **Budget Owner**: Control over spending?
- **Technical Influencer**: Technical decision input?
- **Contract Signer**: Authority to sign contracts?
- **Preferred Communication**: Email, phone, in-person?

![Screenshot: Relationship Attributes]
*Placeholder for screenshot of relationship attribute fields*

---

## Managing Decision Makers

### Identifying Decision Makers

1. Open **Customer** or **Opportunity**
2. Navigate to **Decision Makers** tab
3. See list of contacts with decision influence
4. System shows:
   - Name and role
   - Decision authority level
   - Relationship strength
   - Last interaction date
   - Influence score

![Screenshot: Decision Makers List]
*Placeholder for screenshot of decision makers view*

### Adding Decision Maker

1. From customer/opportunity, click **Add Decision Maker**
2. Select contact
3. Define their role:
   - **Type**: Economic Buyer, Technical Buyer, User, Coach, Gatekeeper
   - **Influence Level**: Low, Medium, High, Critical
   - **Stage Involvement**: Which sales stages they're active in
   - **Support Level**: Champion, Supporter, Neutral, Skeptic, Blocker

![Screenshot: Add Decision Maker]
*Placeholder for screenshot of decision maker configuration*

### Decision Maker Matrix

View all stakeholders on opportunity:

1. Open **Opportunity Card**
2. Click **"Decision Maker Matrix"**
3. Visual grid shows:
   - Rows: Decision maker types
   - Columns: Influence and support level
   - Cell color: Relationship strength
4. Identify gaps (e.g., no champion at high influence)

![Screenshot: Decision Maker Matrix]
*Placeholder for screenshot of stakeholder matrix*

### Tracking Interactions with Decision Makers

Log communication:

1. On contact card, click **New Interaction**
2. Record:
   - **Type**: Meeting, Call, Email, Event
   - **Date & Time**
   - **Subject/Topic**
   - **Outcome**: Positive, Neutral, Negative
   - **Next Action**: Follow-up required
3. System updates relationship strength based on interaction frequency

![Screenshot: Log Interaction]
*Placeholder for screenshot of interaction logging*

---

## Visualizing Networks

### Relationship Network Diagram

View graphical representation:

1. Open **Contact Card**
2. Click **"Show Network Diagram"**
3. Diagram displays:
   - Central contact (focal point)
   - Connected contacts (nodes)
   - Relationship lines (edges)
   - Line thickness = relationship strength
   - Node color = contact type (customer, vendor, prospect)

![Screenshot: Network Diagram]
*Placeholder for screenshot of relationship network visualization*

### Network Navigation

Interact with the diagram:

- **Click node**: Open that contact's card
- **Hover line**: See relationship type and strength
- **Expand node**: Show connections of that contact
- **Filter**: Show only certain relationship types
- **Search**: Highlight specific contact in network

### Organizational Chart

For companies with hierarchies:

1. Open **Company Contact**
2. Click **"Show Org Chart"**
3. Hierarchical tree displays:
   - Top: CEO/President
   - Branches: Departments and divisions
   - Leaves: Individual contacts
   - Click any contact to see details

![Screenshot: Organization Chart]
*Placeholder for screenshot of org chart*

### Influence Map

See who has power in accounts:

1. Open **Customer** or **Opportunity**
2. Click **"Influence Map"**
3. Bubble chart shows:
   - Bubble size = Influence level
   - Bubble color = Support level (green=champion, red=blocker)
   - Position = Relationship strength vs decision authority
4. Focus on large green bubbles (key champions)

![Screenshot: Influence Map]
*Placeholder for screenshot of influence mapping*

---

## Troubleshooting

### Common Issues

#### Issue: "Cannot Create Relationship - Contact Not Found"

**Cause:** Contact doesn't exist or is blocked

**Solution:**
1. Verify contact exists in **Contacts** list
2. Check contact **Status** is not "Inactive"
3. Ensure you have permission to link contacts
4. Search by different fields (email, phone)

#### Issue: "Reverse Relationship Not Created"

**Cause:** Auto-create setting disabled or relationship type not bidirectional

**Solution:**
1. Check **Contact Relations Setup** → **Auto-Create Reverse Relations**
2. Verify relationship type has **Reverse Description** defined
3. Manually create reverse relationship if needed
4. Some relationship types are intentionally one-way

#### Issue: "Organization Chart Shows Incomplete Structure"

**Cause:** Missing "Reports To" relationships

**Solution:**
1. Review all contacts in organization
2. Ensure each has **Reports To** relationship defined
3. Check for circular references (A reports to B, B reports to A)
4. Verify company contact is set as root of hierarchy

#### Issue: "Influence Score Seems Incorrect"

**Cause:** Outdated interaction data or wrong scoring weights

**Solution:**
1. Review recent interactions for contact
2. Check **Contact Relations Setup** → **Interaction Scoring** weights
3. Adjust weights if needed (e.g., meeting = 10 points, email = 2 points)
4. System recalculates scores nightly or click **"Recalculate Scores"**

### Best Practices

✅ **Do:**
- Regularly update relationship strengths after interactions
- Document decision maker changes at accounts
- Use consistent relationship types across team
- Log all significant interactions
- Review org charts quarterly for accuracy
- Identify decision makers early in sales cycle
- Build relationships at multiple levels

❌ **Don't:**
- Create duplicate relationships
- Forget to update when contacts change roles
- Ignore weak relationships (they may strengthen)
- Assume single decision maker (usually multiple)
- Delete relationships (mark inactive instead)
- Over-complicate with too many custom types
- Neglect lower-level contacts (they can influence)

### Maintenance Tasks

**Weekly:**
- Review recent interactions
- Update relationship strengths
- Log upcoming meetings/calls
- Check for new decision makers

**Monthly:**
- Audit customer decision maker lists
- Update org charts for key accounts
- Review influence scores
- Identify relationship gaps

**Quarterly:**
- Deep review of strategic account relationships
- Update all org charts
- Reassess decision maker influence levels
- Archive inactive relationships
- Team review of key relationships

---

## Advanced Features

### Relationship Workflows

Automate actions based on relationships:

1. **Trigger**: New high-value opportunity created
2. **Action**: System identifies decision makers from customer relationships
3. **Action**: Creates tasks for sales team to contact each decision maker
4. **Action**: Sends notification if no champion identified

### Relationship Intelligence

System provides insights:

- **Weak Points**: Accounts with few relationships or only weak ones
- **At Risk**: Relationships with no recent interactions
- **Opportunities**: Contacts who know multiple prospects (referral potential)
- **Succession Planning**: Decision makers nearing retirement
- **Network Effects**: Contacts connected to many customers (influencers)

![Screenshot: Relationship Intelligence Dashboard]
*Placeholder for screenshot of intelligence dashboard*

---

## Support

For technical support or questions:
- **Issues**: [GitHub Issues](https://github.com/walter75-Consulting/Business-Central-Apps/issues)
- **Documentation**: [Main Documentation](contact-relations.md)

---

**Last Updated:** December 2025
