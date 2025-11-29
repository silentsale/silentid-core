# Report a Concern & Contact Support - Feature Specification

**Version:** 1.0.0
**Date:** 2025-11-29
**Status:** Implementation Guide

---

## Overview

This document specifies two new global system features for SilentID:

1. **Report a Concern** - Safety flagging on public profiles
2. **Contact Support** - Unified help system accessible anywhere

Both features must integrate end-to-end while preserving all existing functionality.

---

## 0. SYSTEM-WIDE RULES

### 0.1 Absolutes (Must Never Break)

- Passkeys, OTP, Apple/Google login
- Profile linking & verification flows
- Email receipt forwarding
- Public Passport & Sharing
- TrustScore (Identity 250 + Evidence 400 + Behaviour 350)
- Safety Center
- Onboarding system
- Admin Panel
- All routes and existing endpoints

### 0.2 Safety & Wording

| ❌ Never Use | ✅ Use Instead |
|-------------|----------------|
| scam | concern |
| scammer | inconsistent |
| fraud | unsafe feeling |
| fake profile | requires review |

Reports and support tickets must remain **private** and visible only to admins.

### 0.3 Privacy & GDPR

- Never reveal the reporter's identity
- Store metadata only as required (IP, timestamp, device)
- All data must follow SilentID's privacy model

### 0.4 Non-Breaking Integration

- No renaming or removing of existing fields, classes, screens, endpoints, migrations, or models
- Only additive, safe, forward-compatible changes
- All new elements must follow existing architecture

---

## 1. FEATURE A — REPORT A CONCERN

### 1.1 Purpose

Add a global safety feature accessible on every Public Trust Passport allowing users to flag concerns about profiles in a non-accusatory manner.

### 1.2 UI Integration

**Location:** Public Profile Viewer screen

**Element:** Small tertiary button labeled "Report a concern"

**Design Requirements:**
- Follow Section 53 spacing (16px grid)
- Royal Purple #5A3EB8 accents only
- Inter font typography
- Must not dominate the UI

### 1.3 Report Concern Flow

```
Step 1 - Intro Screen
├── Safe language explanation
├── "Use this if something on this profile seems incorrect or unsafe."
└── "Reports are reviewed privately to keep SilentID trustworthy."

Step 2 - Choose a Reason
├── "Profile might not belong to this person"
├── "Suspicious or inconsistent information"
├── "Something feels unsafe"
└── "Other safety concern"

Step 3 - Optional Notes
├── Brief message box
└── Max 400 characters

Step 4 - Confirmation
└── "Thanks — our team will privately review this concern."
```

### 1.4 Backend Requirements

#### Data Model: ProfileConcern

| Field | Type | Description |
|-------|------|-------------|
| Id | GUID | Primary key |
| ReportedUserId | GUID | User being reported |
| ReporterUserId | GUID? | User who reported (nullable for anonymous) |
| Reason | Enum | Category of concern |
| Notes | string? | Optional details (max 400 chars) |
| ReporterIpAddress | string | IP address of reporter |
| ReporterDeviceInfo | string | Device fingerprint |
| Status | Enum | New, UnderReview, Reviewed, Dismissed |
| AdminNotes | string? | Internal notes |
| ReviewedByAdminId | GUID? | Admin who reviewed |
| ReviewedAt | DateTime? | When reviewed |
| CreatedAt | DateTime | When reported |

#### Reason Enum

```csharp
public enum ConcernReason
{
    ProfileOwnership = 1,      // "Profile might not belong to this person"
    InconsistentInformation = 2, // "Suspicious or inconsistent information"
    UnsafeFeeling = 3,         // "Something feels unsafe"
    OtherSafetyConcern = 4     // "Other safety concern"
}
```

#### Status Enum

```csharp
public enum ConcernStatus
{
    New = 1,
    UnderReview = 2,
    Reviewed = 3,
    Dismissed = 4
}
```

#### Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /api/concerns | Submit a new concern |
| GET | /api/admin/concerns | List all concerns (admin) |
| GET | /api/admin/concerns/{id} | Get concern details (admin) |
| PUT | /api/admin/concerns/{id}/review | Update concern status (admin) |

#### Rate Limiting

- Max 3 reports per user per 24 hours
- Max 1 report per user per profile per 7 days

#### Risk Signal Integration

- Concerns feed into Behaviour as a **soft internal risk signal only**
- Do NOT modify TrustScore directly
- Signal weight: Very low (informational only)
- Multiple concerns from different reporters may increase signal weight

### 1.5 Admin Panel Module

**Module Name:** Profile Concerns Review

**Features:**
- List of all concerns with pagination
- Filters: status, date range, reason, reported user
- Detail view with full information
- Add admin notes
- Mark as reviewed/dismissed
- No automatic punitive actions

### 1.6 Info Points

Add educational content for:
- What "Report a Concern" means
- Why concerns are private
- How SilentID reviews concerns
- Safe wording / non-accusatory nature

---

## 2. FEATURE B — CONTACT SUPPORT

### 2.1 Purpose

Add a unified help system accessible anywhere in the app for user assistance.

### 2.2 UI Integration Points

Add "Contact Support" entry to:
- Settings Screen
- Public Profile bottom section
- Login problems context
- Verification issues context
- Inside the "Report Concern" flow

### 2.3 Support Flow

```
Support Screen
├── Category Selection
│   ├── Account/Login
│   ├── Verification Help
│   ├── Technical Issue
│   └── General Question
├── Message Box
│   └── Free text input
├── Auto-attached Info
│   ├── Device info
│   ├── App version
│   └── Environment
└── Confirmation
    └── "Thanks — our support team will review this shortly."
```

### 2.4 Backend Requirements

#### Data Model: SupportTicket

| Field | Type | Description |
|-------|------|-------------|
| Id | GUID | Primary key |
| UserId | GUID? | User who submitted (nullable for pre-auth) |
| Category | Enum | Category of issue |
| Message | string | User's message |
| DeviceInfo | string | Device fingerprint |
| AppVersion | string | App version |
| Platform | string | iOS/Android |
| Status | Enum | New, InReview, Resolved, Closed |
| AdminNotes | string? | Internal notes |
| AssignedToAdminId | GUID? | Admin handling ticket |
| ResolvedAt | DateTime? | When resolved |
| CreatedAt | DateTime | When submitted |

#### Category Enum

```csharp
public enum SupportCategory
{
    AccountLogin = 1,      // "Account/Login"
    VerificationHelp = 2,  // "Verification Help"
    TechnicalIssue = 3,    // "Technical Issue"
    GeneralQuestion = 4    // "General Question"
}
```

#### Status Enum

```csharp
public enum TicketStatus
{
    New = 1,
    InReview = 2,
    Resolved = 3,
    Closed = 4
}
```

#### Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /api/support/tickets | Submit a new ticket |
| GET | /api/support/tickets | List user's own tickets |
| GET | /api/admin/support/tickets | List all tickets (admin) |
| GET | /api/admin/support/tickets/{id} | Get ticket details (admin) |
| PUT | /api/admin/support/tickets/{id} | Update ticket (admin) |

### 2.5 Admin Panel Module

**Module Name:** Support Tickets

**Features:**
- Ticket list with pagination
- Filters: status, category, date range
- Detail view with user info and metadata
- Add internal notes
- Assign to admin
- Mark as resolved/closed

### 2.6 Info Points

Add educational content for:
- Contact Support explanation
- Expected response times
- What information is shared (privacy compliant)

---

## 3. FULL-SYSTEM INTEGRATION CHECKLIST

### 3.1 Flutter Components

- [ ] ReportConcernScreen - Multi-step flow
- [ ] ContactSupportScreen - Support form
- [ ] ConcernService - API integration
- [ ] SupportService - API integration
- [ ] New routes in app_router.dart
- [ ] Integration in PublicProfileViewerScreen
- [ ] Integration in SettingsScreen
- [ ] New info-point data entries

### 3.2 Backend

- [ ] ProfileConcern model
- [ ] SupportTicket model
- [ ] ConcernController
- [ ] SupportController
- [ ] ConcernService
- [ ] SupportService
- [ ] Database migrations
- [ ] Rate limiting logic
- [ ] Audit logging

### 3.3 Admin Panel

- [ ] Profile Concerns module
- [ ] Support Tickets module
- [ ] New admin routes
- [ ] Filter components
- [ ] Detail views

### 3.4 TrustScore & Risk Engine

- [ ] Soft Behaviour signal for concerns
- [ ] Signal does NOT affect Identity/Evidence
- [ ] Internal-only visibility

### 3.5 Documentation

- [ ] Info-points for Report Concern
- [ ] Info-points for Contact Support
- [ ] T&C updates (neutral wording)

---

## 4. NON-BREAKING VERIFICATION

Before completion, verify:

- [ ] No build errors (Flutter + Backend)
- [ ] No route conflicts
- [ ] No naming clashes
- [ ] No broken screens
- [ ] No TrustScore regressions
- [ ] No broken onboarding
- [ ] No broken profile linking
- [ ] No broken email receipt flows
- [ ] No broken admin panel features

---

## 5. ARCHITECTURE DIAGRAM

```
┌─────────────────────────────────────────────────────────────────┐
│                        FLUTTER APP                               │
├─────────────────────────────────────────────────────────────────┤
│  PublicProfileViewer  │  Settings  │  Login/Verification Error  │
│         │                   │                    │               │
│         ▼                   ▼                    ▼               │
│  ┌─────────────────┐  ┌─────────────────┐                       │
│  │ Report Concern  │  │ Contact Support │                       │
│  │     Screen      │  │     Screen      │                       │
│  └────────┬────────┘  └────────┬────────┘                       │
│           │                    │                                 │
│           ▼                    ▼                                 │
│  ┌─────────────────────────────────────┐                        │
│  │         API Services Layer          │                        │
│  │  ConcernService  │  SupportService  │                        │
│  └─────────────────────────────────────┘                        │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      ASP.NET CORE API                           │
├─────────────────────────────────────────────────────────────────┤
│  ┌──────────────────┐  ┌──────────────────┐                     │
│  │ ConcernController│  │ SupportController│                     │
│  └────────┬─────────┘  └────────┬─────────┘                     │
│           │                     │                                │
│           ▼                     ▼                                │
│  ┌──────────────────┐  ┌──────────────────┐                     │
│  │  ConcernService  │  │  SupportService  │                     │
│  └────────┬─────────┘  └────────┬─────────┘                     │
│           │                     │                                │
│           ▼                     ▼                                │
│  ┌─────────────────────────────────────────┐                    │
│  │            PostgreSQL Database          │                    │
│  │  ProfileConcerns  │  SupportTickets     │                    │
│  └─────────────────────────────────────────┘                    │
│                              │                                   │
│                              ▼                                   │
│  ┌─────────────────────────────────────────┐                    │
│  │           Risk Engine (Soft Signal)     │                    │
│  └─────────────────────────────────────────┘                    │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                       ADMIN PANEL                                │
├─────────────────────────────────────────────────────────────────┤
│  ┌──────────────────┐  ┌──────────────────┐                     │
│  │ Profile Concerns │  │  Support Tickets │                     │
│  │     Module       │  │     Module       │                     │
│  └──────────────────┘  └──────────────────┘                     │
└─────────────────────────────────────────────────────────────────┘
```

---

**END OF SPECIFICATION**
