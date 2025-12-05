---
layout: default
title: OAuth 2.0 User Guide
---

<div class="hero-section">
  <h1>🔐 OAuth 2.0 User Guide</h1>
  <p class="hero-tagline">Complete setup and usage instructions</p>
  <div class="badge-container">
    <span class="badge">v26.2.0</span>
    <span class="badge">walter75 Consulting</span>
    <span class="badge">BC Cloud</span>
  </div>
</div>

---

<div class="info-box info-box-primary">
  <h3>📚 Quick Navigation</h3>
  <ul style="columns: 2; -webkit-columns: 2; -moz-columns: 2;">
    <li><a href="#introduction">Introduction</a></li>
    <li><a href="#setup">Setup</a></li>
    <li><a href="#creating-an-oauth-application">Creating an OAuth Application</a></li>
    <li><a href="#managing-access-tokens">Managing Access Tokens</a></li>
    <li><a href="#troubleshooting">Troubleshooting</a></li>
  </ul>
</div>

---

## Introduction

The **walter75 - OAuth 2.0** extension provides a comprehensive OAuth 2.0 authentication framework for integrating Microsoft Dynamics 365 Business Central with external APIs and services.

<div class="feature-grid">
  <div class="feature-card">
    <h3>🔐 Secure Authentication</h3>
    <p>Industry-standard OAuth 2.0 protocol</p>
  </div>
  <div class="feature-card">
    <h3>🔄 Automatic Token Refresh</h3>
    <p>Handles token expiration automatically</p>
  </div>
  <div class="feature-card">
    <h3>📊 Token Management</h3>
    <p>Track and manage access tokens centrally</p>
  </div>
  <div class="feature-card">
    <h3>🔗 Multi-Service Support</h3>
    <p>Configure multiple API connections</p>
  </div>
  <div class="feature-card">
    <h3>🛡️ Credential Security</h3>
    <p>Encrypted storage of sensitive data</p>
  </div>
</div>

---

## Setup

<div class="info-box info-box-warning">
  <h3>📋 Prerequisites</h3>
  <p>Before using OAuth 2.0 authentication, you need:</p>
  <ul>
    <li>API credentials from the external service (Client ID, Client Secret)</li>
    <li>OAuth endpoints (Authorization URL, Token URL)</li>
    <li>Required scopes/permissions</li>
  </ul>
</div>

---

## Creating an OAuth Application

<div class="step-container">
  <div class="step">
    <div class="step-number">1</div>
    <div class="step-content">
      <h4>Open OAuth Applications</h4>
      <p>Search for <strong>"OAuth Applications"</strong> in Business Central and click <strong>+ New</strong> to create a new application</p>
    </div>
  </div>

  <div class="step">
    <div class="step-number">2</div>
    <div class="step-content">
      <h4>Configure Basic Settings</h4>
      <p><strong>General Information:</strong></p>
      <ul>
        <li><strong>Code</strong>: Unique identifier (e.g., "SENDCLOUD", "PRINTNODE")</li>
        <li><strong>Description</strong>: Descriptive name (e.g., "SendCloud Shipping API")</li>
        <li><strong>Active</strong>: Enable to activate the application</li>
      </ul>
    </div>
  </div>

  <div class="step">
    <div class="step-number">3</div>
    <div class="step-content">
      <h4>Configure OAuth Endpoints</h4>
      <p><strong>Authentication Settings:</strong></p>
      <ul>
        <li><strong>Authorization URL</strong>: OAuth authorization endpoint<br>
        <code>https://api.example.com/oauth/authorize</code></li>
        <li><strong>Token URL</strong>: Token exchange endpoint<br>
        <code>https://api.example.com/oauth/token</code></li>
        <li><strong>Scope</strong>: Required permissions (space-separated)<br>
        <code>read write shipping</code></li>
      </ul>
    </div>
  </div>

  <div class="step">
    <div class="step-number">4</div>
    <div class="step-content">
      <h4>Enter Credentials</h4>
      <p><strong>Client Credentials:</strong></p>
      <ul>
        <li><strong>Client ID</strong>: Application client identifier</li>
        <li><strong>Client Secret</strong>: Secret key (stored encrypted)</li>
      </ul>
      <div class="info-box info-box-warning" style="margin-top: 15px;">
        <p>⚠️ <strong>Security Note:</strong> The Client Secret is stored encrypted. Never share these credentials publicly.</p>
      </div>
    </div>
  </div>

  <div class="step">
    <div class="step-number">5</div>
    <div class="step-content">
      <h4>Configure Grant Type</h4>
      <p><strong>Select OAuth 2.0 flow:</strong></p>
      <ul>
        <li><strong>Authorization Code</strong>: User-based authentication</li>
        <li><strong>Client Credentials</strong>: Service-to-service (recommended)</li>
        <li><strong>Password</strong>: Username/password flow</li>
        <li><strong>Refresh Token</strong>: Automatic refresh</li>
      </ul>
    </div>
  </div>

  <div class="step">
    <div class="step-number">6</div>
    <div class="step-content">
      <h4>Save and Test</h4>
      <ol>
        <li>Click <strong>OK</strong> to save the configuration</li>
        <li>Use the <strong>"Request Token"</strong> action to test</li>
        <li>If successful, an access token will be generated</li>
      </ol>
    </div>
  </div>
</div>

---

## Managing Access Tokens

<div class="info-box">
  <h3>🔑 Viewing Active Tokens</h3>
  <ol>
    <li>Open your <strong>OAuth Application Card</strong></li>
    <li>Navigate to <strong>Related</strong> → <strong>Access Tokens</strong></li>
    <li>View all generated tokens with their expiration times</li>
  </ol>
  
  <p><strong>Token Information Displayed:</strong></p>
  <ul>
    <li><strong>Token ID</strong>: Unique identifier</li>
    <li><strong>Created At</strong>: When the token was issued</li>
    <li><strong>Expires At</strong>: Token expiration timestamp</li>
    <li><strong>Status</strong>: Active, Expired, Revoked</li>
    <li><strong>Scopes</strong>: Granted permissions</li>
  </ul>
</div>

### Automatic Token Refresh

<div class="info-box info-box-primary">
  <p>The system automatically refreshes tokens before they expire if:</p>
  <ul>
    <li>✅ Refresh tokens are available</li>
    <li>✅ The OAuth application is configured with "Refresh Token" grant type</li>
    <li>✅ The API supports token refresh</li>
  </ul>
</div>

### Manual Token Refresh

<div class="step-container">
  <div class="step">
    <div class="step-number">1</div>
    <div class="step-content">
      <h4>Open OAuth Application</h4>
      <p>Navigate to the OAuth Application Card</p>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">2</div>
    <div class="step-content">
      <h4>Refresh Token</h4>
      <p>Click <strong>Actions</strong> → <strong>Refresh Token</strong></p>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">3</div>
    <div class="step-content">
      <h4>Verify Success</h4>
      <p>The system will request a new token using the refresh token</p>
    </div>
  </div>
</div>

### Revoking Tokens

<div class="info-box info-box-warning">
  <h4>🚫 To invalidate a token:</h4>
  <ol>
    <li>Navigate to <strong>Related</strong> → <strong>Access Tokens</strong></li>
    <li>Select the token to revoke</li>
    <li>Click <strong>Revoke Token</strong></li>
    <li>Confirm the action</li>
  </ol>
</div>

---

## Troubleshooting

<div class="feature-grid">
  <div class="feature-card">
    <h3>❌ Invalid Client Credentials</h3>
    <p><strong>Cause:</strong> Client ID or Secret is incorrect</p>
    <p><strong>Solution:</strong></p>
    <ul style="text-align: left; font-size: 0.9em;">
      <li>Verify credentials in API dashboard</li>
      <li>Update OAuth Application</li>
      <li>Check for extra spaces</li>
    </ul>
  </div>
  
  <div class="feature-card">
    <h3>⏰ Token Expired</h3>
    <p><strong>Cause:</strong> Access token reached expiration</p>
    <p><strong>Solution:</strong></p>
    <ul style="text-align: left; font-size: 0.9em;">
      <li>System auto-refreshes normally</li>
      <li>Manually refresh if needed</li>
      <li>Verify refresh tokens enabled</li>
    </ul>
  </div>
  
  <div class="feature-card">
    <h3>🔒 Invalid Scope</h3>
    <p><strong>Cause:</strong> Requested scopes not allowed</p>
    <p><strong>Solution:</strong></p>
    <ul style="text-align: left; font-size: 0.9em;">
      <li>Check API documentation</li>
      <li>Request additional scopes</li>
      <li>Update Scope field</li>
    </ul>
  </div>
  
  <div class="feature-card">
    <h3>🚫 Authorization Failed</h3>
    <p><strong>Cause:</strong> Multiple possible issues</p>
    <p><strong>Solution:</strong></p>
    <ul style="text-align: left; font-size: 0.9em;">
      <li>Check OAuth Log</li>
      <li>Verify URLs are correct</li>
      <li>Test API externally</li>
    </ul>
  </div>
</div>

### Checking OAuth Logs

<div class="info-box">
  <h4>📊 Detailed Troubleshooting</h4>
  <ol>
    <li>Search for <strong>"OAuth Log Entries"</strong></li>
    <li>Filter by your OAuth Application code</li>
    <li>Review error messages and response codes</li>
    <li>Use timestamps to correlate with failed requests</li>
  </ol>
</div>

### Best Practices

<div class="support-box">
  <div class="support-item">
    <h4>✅ Do</h4>
    <ul style="text-align: left;">
      <li>Use descriptive codes</li>
      <li>Review unused tokens</li>
      <li>Test after API updates</li>
      <li>Keep secrets secure</li>
      <li>Monitor expiration</li>
    </ul>
  </div>
  
  <div class="support-item">
    <h4>❌ Don't</h4>
    <ul style="text-align: left;">
      <li>Share Client Secrets</li>
      <li>Reuse applications</li>
      <li>Ignore refresh failures</li>
      <li>Disable error logging</li>
    </ul>
  </div>
</div>

---

<div class="footer-info">
  <h3>💬 Support & Resources</h3>
  <div class="doc-links">
    <a href="https://github.com/walter75-Consulting/Business-Central-Apps/issues" class="doc-link">
      <span class="doc-icon">🐛</span>
      <div>
        <strong>GitHub Issues</strong>
        <p>Report bugs and request features</p>
      </div>
    </a>
    
    <a href="oauth.html" class="doc-link">
      <span class="doc-icon">📚</span>
      <div>
        <strong>Technical Documentation</strong>
        <p>Developer reference and API details</p>
      </div>
    </a>
    
    <a href="../../" class="doc-link">
      <span class="doc-icon">🏠</span>
      <div>
        <strong>All Apps</strong>
        <p>Browse complete app collection</p>
      </div>
    </a>
  </div>
  
  <p style="margin-top: 30px;"><strong>Last Updated:</strong> December 2025 | <strong>Version:</strong> 26.2.0</p>
</div>

---

<div class="footer-info">
  <p>📄 <strong>License:</strong> MIT License | 👤 <strong>Author:</strong> Sebastian Walter (@walter75)</p>
  <p>💬 <strong>Support:</strong> <a href="https://github.com/walter75-Consulting/Business-Central-Apps/issues">GitHub Issues</a> | <a href="https://www.walter75.de">walter75.de</a></p>
  <p style="font-size: 0.9em; color: #666; margin-top: 10px;">Personal open-source project - not a commercial service</p>
</div>
