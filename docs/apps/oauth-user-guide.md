# walter75 - OAuth 2.0
## User Guide

**Version:** 26.2.0  
**Publisher:** walter75 Consulting  
**Platform:** Microsoft Dynamics 365 Business Central Cloud

---

## Table of Contents

1. [Introduction](#introduction)
2. [Setup](#setup)
3. [Creating an OAuth Application](#creating-an-oauth-application)
4. [Managing Access Tokens](#managing-access-tokens)
5. [Troubleshooting](#troubleshooting)

---

## Introduction

The **walter75 - OAuth 2.0** extension provides a comprehensive OAuth 2.0 authentication framework for integrating Microsoft Dynamics 365 Business Central with external APIs and services.

### Key Features

- 🔐 **Secure Authentication**: Industry-standard OAuth 2.0 protocol
- 🔄 **Automatic Token Refresh**: Handles token expiration automatically
- 📊 **Token Management**: Track and manage access tokens centrally
- 🔗 **Multi-Service Support**: Configure multiple API connections
- 🛡️ **Credential Security**: Encrypted storage of sensitive data

---

## Setup

### Prerequisites

Before using OAuth 2.0 authentication, you need:
- API credentials from the external service (Client ID, Client Secret)
- OAuth endpoints (Authorization URL, Token URL)
- Required scopes/permissions

---

## Creating an OAuth Application

### Step 1: Open OAuth Applications

1. Search for **"OAuth Applications"** in Business Central
2. Click **+ New** to create a new application

![Screenshot: OAuth Applications List]
*Placeholder for screenshot of OAuth Applications list page*

### Step 2: Configure Basic Settings

Fill in the following fields:

**General Information:**
- **Code**: Unique identifier for this OAuth application (e.g., "SENDCLOUD", "PRINTNODE")
- **Description**: Descriptive name (e.g., "SendCloud Shipping API")
- **Active**: Enable this checkbox to activate the application

![Screenshot: OAuth Application Card - General]
*Placeholder for screenshot showing general fields*

### Step 3: Configure OAuth Endpoints

**Authentication Settings:**
- **Authorization URL**: The OAuth authorization endpoint from the API provider
  - Example: `https://api.example.com/oauth/authorize`
- **Token URL**: The endpoint to exchange authorization codes for access tokens
  - Example: `https://api.example.com/oauth/token`
- **Scope**: Required permissions/scopes (space-separated)
  - Example: `read write shipping`

![Screenshot: OAuth Application Card - Endpoints]
*Placeholder for screenshot showing endpoint configuration*

### Step 4: Enter Credentials

**Client Credentials:**
- **Client ID**: Your application's client identifier from the API provider
- **Client Secret**: Your application's secret key (stored encrypted)

![Screenshot: OAuth Application Card - Credentials]
*Placeholder for screenshot showing credential fields*

⚠️ **Security Note:** The Client Secret is stored encrypted in the database. Never share these credentials publicly.

### Step 5: Configure Grant Type

**Grant Type**: Select the OAuth 2.0 flow used by the API:
- **Authorization Code**: User-based authentication (redirects to login page)
- **Client Credentials**: Service-to-service authentication (recommended for most APIs)
- **Password**: Username/password flow (less secure, use only if required)
- **Refresh Token**: Automatically refresh expired tokens

![Screenshot: Grant Type Selection]
*Placeholder for screenshot showing grant type options*

### Step 6: Save and Test

1. Click **OK** to save the configuration
2. Use the **"Request Token"** action to test the connection
3. If successful, an access token will be generated

![Screenshot: Request Token Action]
*Placeholder for screenshot showing Request Token button*

---

## Managing Access Tokens

### Viewing Active Tokens

1. Open your **OAuth Application Card**
2. Navigate to **Related** → **Access Tokens**
3. View all generated tokens with their expiration times

![Screenshot: Access Tokens List]
*Placeholder for screenshot of access tokens list*

**Token Information Displayed:**
- **Token ID**: Unique identifier
- **Created At**: When the token was issued
- **Expires At**: Token expiration timestamp
- **Status**: Active, Expired, Revoked
- **Scopes**: Granted permissions

### Automatic Token Refresh

The system automatically refreshes tokens before they expire if:
- Refresh tokens are available
- The OAuth application is configured with "Refresh Token" grant type
- The API supports token refresh

![Screenshot: Token Refresh Settings]
*Placeholder for screenshot showing refresh token configuration*

### Manual Token Refresh

If automatic refresh fails, you can manually refresh:

1. Open the **OAuth Application Card**
2. Click **Actions** → **Refresh Token**
3. The system will request a new token using the refresh token

![Screenshot: Manual Refresh Action]
*Placeholder for screenshot showing manual refresh option*

### Revoking Tokens

To invalidate a token:

1. Navigate to **Related** → **Access Tokens**
2. Select the token to revoke
3. Click **Revoke Token**
4. Confirm the action

![Screenshot: Revoke Token Confirmation]
*Placeholder for screenshot of revoke confirmation dialog*

---

## Troubleshooting

### Common Issues

#### Issue: "Invalid Client Credentials"

**Cause:** Client ID or Client Secret is incorrect

**Solution:**
1. Verify credentials in the API provider's dashboard
2. Update the OAuth Application with correct values
3. Ensure there are no extra spaces in the fields

#### Issue: "Token Expired"

**Cause:** Access token has reached its expiration time

**Solution:**
- The system should automatically refresh the token
- If automatic refresh fails, manually refresh the token
- Check that refresh tokens are enabled

#### Issue: "Invalid Scope"

**Cause:** Requested scopes are not allowed for your application

**Solution:**
1. Check the API documentation for valid scopes
2. Request additional scopes from the API provider
3. Update the Scope field in the OAuth Application

#### Issue: "Authorization Failed"

**Cause:** Multiple possible causes (expired credentials, network issues, API changes)

**Solution:**
1. Check the **OAuth Log** for detailed error messages
2. Verify the Authorization URL and Token URL are correct
3. Test the API connection outside Business Central
4. Contact the API provider's support

### Checking OAuth Logs

For detailed troubleshooting:

1. Search for **"OAuth Log Entries"**
2. Filter by your OAuth Application code
3. Review error messages and response codes
4. Use timestamps to correlate with failed requests

![Screenshot: OAuth Log Entries]
*Placeholder for screenshot of OAuth log entries list*

### Best Practices

✅ **Do:**
- Use descriptive codes and descriptions for applications
- Regularly review and revoke unused tokens
- Test OAuth connections after API provider updates
- Keep Client Secrets secure and change them periodically
- Monitor token expiration times

❌ **Don't:**
- Share Client Secrets in emails or documentation
- Use the same OAuth application for multiple unrelated services
- Ignore token refresh failures
- Disable error logging (needed for troubleshooting)

---

## Support

For technical support or questions:
- **Issues**: [GitHub Issues](https://github.com/walter75-Consulting/Business-Central-Apps/issues)
- **Documentation**: [Main Documentation](oauth.md)

---

**Last Updated:** December 2025
