# Sprint 4 Kickoff - Final Push to 100%

**Date:** 2025-11-22
**Orchestrator:** Team Lead
**Status:** 🚀 ACTIVE
**Goal:** Complete final 7 screens (100% feature complete)

---

## Sprint 4 Objectives

**Current State:** 32/39 screens (82%)
**Target State:** 39/39 screens (100%)
**Remaining Screens:** 7

### High Priority (Critical for MVP)

1. **Mutual Verification Module** (4 screens)
   - MutualVerificationHomeScreen
   - CreateVerificationScreen
   - IncomingRequestsScreen
   - VerificationDetailsScreen

2. **Safety Reports Module** (3 screens)
   - ReportUserScreen
   - MyReportsListScreen
   - ReportDetailsScreen

### Medium Priority (Monetization)

Already have UI for:
- UpgradeToPremiumScreen (needs backend)
- UpgradeToProScreen (needs backend)

### Backend Status Check

**Existing Controllers:**
- ✅ AuthController (OTP, session management)
- ✅ EvidenceController (receipts, screenshots, profile links)
- ✅ IdentityController (Stripe verification)
- ❌ MutualVerificationController (NOT IMPLEMENTED)
- ❌ ReportsController (NOT IMPLEMENTED)
- ❌ SubscriptionsController (NOT IMPLEMENTED)
- ❌ TrustScoreController (NOT IMPLEMENTED)
- ❌ UsersController (NOT IMPLEMENTED)

---

## Agent Task Assignments

### AGENT A - ARCHITECT & COORDINATOR

**Current Task:** Planning Sprint 4 architecture
**Deliverables:**
1. API contract definitions for new endpoints
2. Database migration planning (new tables needed)
3. Integration sequence planning
4. Update ARCHITECTURE.md with new modules

**Action Items:**
- [ ] Define MutualVerification API contracts
- [ ] Define Safety Reports API contracts
- [ ] Define TrustScore API contracts
- [ ] Plan database migrations for new tables
- [ ] Create SPRINT_4_TASK_BOARD.md
- [ ] Coordinate parallel work streams

---

### AGENT B - BACKEND ENGINEER

**Current Focus:** Implement missing backend endpoints
**Priority Order:**
1. TrustScore endpoints (needed for existing screens)
2. Mutual Verification endpoints
3. Safety Reports endpoints
4. Subscriptions endpoints (Stripe integration)

**Deliverables:**

#### Phase 1: TrustScore Implementation (2-3 hours)
```
Files to create:
- Controllers/TrustScoreController.cs
- Services/TrustScoreService.cs
- Models/TrustScoreSnapshot.cs (already in DB)

Endpoints needed:
- GET /v1/trustscore/me
- GET /v1/trustscore/me/breakdown
- GET /v1/trustscore/me/history
```

#### Phase 2: Mutual Verification (3-4 hours)
```
Files to create:
- Controllers/MutualVerificationController.cs
- Services/MutualVerificationService.cs
- Models/MutualVerification.cs (already in DB)

Endpoints needed:
- POST /v1/mutual-verifications (create request)
- GET /v1/mutual-verifications/incoming
- POST /v1/mutual-verifications/{id}/respond
- GET /v1/mutual-verifications
```

#### Phase 3: Safety Reports (2-3 hours)
```
Files to create:
- Controllers/ReportsController.cs
- Services/ReportService.cs
- Models/Report.cs (already in DB)
- Models/ReportEvidence.cs (already in DB)

Endpoints needed:
- POST /v1/reports (create report)
- POST /v1/reports/{id}/evidence (upload evidence)
- GET /v1/reports/mine
- GET /v1/reports/{id}
```

#### Phase 4: Subscriptions (2-3 hours)
```
Files to create:
- Controllers/SubscriptionsController.cs
- Services/SubscriptionService.cs
- Services/StripeService.cs

Endpoints needed:
- GET /v1/subscriptions/me
- POST /v1/subscriptions/upgrade
- POST /v1/subscriptions/cancel
- POST /v1/subscriptions/webhook (Stripe webhooks)
```

**Action Items:**
- [ ] Check if TrustScoreSnapshot table exists in DB
- [ ] Check if MutualVerification table exists in DB
- [ ] Check if Report/ReportEvidence tables exist in DB
- [ ] Check if Subscription table exists in DB
- [ ] Create missing migrations if needed
- [ ] Implement TrustScore calculation logic
- [ ] Implement all CRUD operations
- [ ] Add proper error handling
- [ ] Log all operations
- [ ] Update BACKEND_CHANGELOG.md after each phase

---

### AGENT C - FRONTEND ENGINEER (YOU!)

**Current Focus:** Build remaining 7 screens
**Priority Order:**
1. Mutual Verification screens (4 screens) - 4-6 hours
2. Safety Reports screens (3 screens) - 3-4 hours
3. Connect to backend APIs - 2-3 hours
4. Polish and testing - 2 hours

**Deliverables:**

#### Phase 1: Mutual Verification Module (4 screens)

**1A. MutualVerificationHomeScreen**
```dart
Location: lib/features/mutual_verification/screens/mutual_verification_home_screen.dart

Features:
- Tab bar: "Create" | "Incoming" (with badge)
- List of all mutual verifications
- FAB: "New Verification" button
- Pull-to-refresh
- Navigate to CreateVerificationScreen
```

**1B. CreateVerificationScreen**
```dart
Location: lib/features/mutual_verification/screens/create_verification_screen.dart

Form fields:
- Other person's username/email
- Item/Service name
- Amount (with currency selector: GBP, USD, EUR)
- Your role (Buyer/Seller toggle)
- Transaction date (date picker)
- Optional evidence upload
- "Request Verification" button

API: POST /v1/mutual-verifications
```

**1C. IncomingRequestsScreen**
```dart
Location: lib/features/mutual_verification/screens/incoming_requests_screen.dart

Features:
- List of pending verification requests
- Card per request showing:
  - From: @username
  - Item, amount, role, date
  - Status badge
  - [Confirm] [Reject] buttons
- Empty state: "No pending requests"

API: GET /v1/mutual-verifications/incoming
API: POST /v1/mutual-verifications/{id}/respond
```

**1D. VerificationDetailsScreen**
```dart
Location: lib/features/mutual_verification/screens/verification_details_screen.dart

Features:
- Full verification details
- Participants (User A, User B)
- Transaction details
- Evidence viewer
- Timeline component
- Status badge
- Action buttons (if pending)

API: GET /v1/mutual-verifications/{id}
```

#### Phase 2: Safety Reports Module (3 screens)

**2A. ReportUserScreen**
```dart
Location: lib/features/safety/screens/report_user_screen.dart

Form fields:
- Who are you reporting? (username input or QR scan)
- Category dropdown:
  - Item never arrived
  - Evidence suggests misrepresentation
  - Aggressive behaviour
  - Payment issue
  - Other concern
- Description (text area, required)
- Upload evidence (screenshots, chat logs, receipts)
- Warning: "False reports may result in suspension"
- "Submit Report" button

API: POST /v1/reports
API: POST /v1/reports/{id}/evidence
```

**2B. MyReportsListScreen**
```dart
Location: lib/features/safety/screens/my_reports_list_screen.dart

Features:
- List of reports filed by user
- Card per report:
  - Reported user
  - Category
  - Status (Pending, Under Review, Verified, Dismissed)
  - Filed date
  - Tap for details
- Status color coding
- Empty state: "You haven't filed any reports"

API: GET /v1/reports/mine
```

**2C. ReportDetailsScreen**
```dart
Location: lib/features/safety/screens/report_details_screen.dart

Features:
- Status badge
- Report info
- Your description
- Evidence gallery
- Admin response (if any)
- Timeline component
- Detailed status updates

API: GET /v1/reports/{id}
```

#### Phase 3: Backend Integration

**Update existing screens to use real APIs:**

1. TrustScoreOverviewScreen → GET /v1/trustscore/me
2. TrustScoreBreakdownScreen → GET /v1/trustscore/me/breakdown
3. TrustScoreHistoryScreen → GET /v1/trustscore/me/history
4. MyPublicProfileScreen → GET /v1/users/me

**Create new service files:**
```dart
lib/services/
- mutual_verification_service.dart
- safety_service.dart
- trustscore_service.dart
- subscription_service.dart
```

#### Phase 4: Polish

1. Add real logo (replace "S" placeholder)
2. Add loading skeletons (shimmer package)
3. Improve error handling (retry logic)
4. Add accessibility labels
5. Test all navigation flows
6. Verify brand consistency

**Action Items:**
- [ ] Build all 7 screens
- [ ] Create all service files
- [ ] Connect screens to backend APIs
- [ ] Add proper error handling
- [ ] Test all user flows
- [ ] Update FRONTEND_NOTES.md
- [ ] Mark all screens 100% complete

---

### AGENT D - QA & TESTING

**Current Focus:** Test new features as they're built
**Priority Order:**
1. Test backend endpoints (Postman/curl)
2. Test Flutter screens (manual)
3. Test integration flows
4. Security testing

**Deliverables:**

#### Phase 1: Backend API Testing
```
Test each endpoint as Agent B implements:
- POST /v1/mutual-verifications
- GET /v1/mutual-verifications/incoming
- POST /v1/mutual-verifications/{id}/respond
- POST /v1/reports
- GET /v1/reports/mine
- GET /v1/trustscore/me
```

#### Phase 2: Frontend Testing
```
Test each screen as Agent C builds:
- Navigation works
- Forms validate properly
- API calls succeed
- Error states display
- Loading states appear
- Success notifications show
```

#### Phase 3: Integration Testing
```
End-to-end flows:
1. Create mutual verification → other user confirms
2. Submit safety report → view in list
3. View TrustScore → see breakdown → see history
4. Upgrade to Premium → verify features unlocked
```

#### Phase 4: Security Testing
```
Security checks:
- Unauthorized access blocked
- CSRF protection works
- Rate limiting enforced
- Input validation prevents injection
- JWT tokens expire properly
```

**Action Items:**
- [ ] Test all new backend endpoints
- [ ] Test all new frontend screens
- [ ] Run integration tests
- [ ] Run security tests
- [ ] Document bugs in BUG_TRACKER.md
- [ ] Update QA_CHECKLIST.md
- [ ] Create test reports

---

## Coordination Rules

### Before ANY Code Change:
1. Check existing code with MCP filesystem tools
2. Verify no duplicate logic exists
3. Confirm API contracts match between frontend/backend
4. Update architecture docs if needed

### After Code Changes:
1. Update relevant changelog (BACKEND_CHANGELOG.md or FRONTEND_NOTES.md)
2. Notify other agents of completed work
3. Create git commit with clear message
4. Update task board

### Communication Pattern:
- Agent A: Update TASK_BOARD.md with status
- Agent B: Update BACKEND_CHANGELOG.md after each endpoint
- Agent C: Update FRONTEND_NOTES.md after each screen
- Agent D: Update QA_CHECKLIST.md after each test

---

## Success Criteria

### Must Have (100% Required):
- ✅ 39/39 screens implemented
- ✅ All backend endpoints functional
- ✅ All screens connected to real APIs
- ✅ No compilation errors
- ✅ All critical user flows work

### Should Have (90% Target):
- ✅ All endpoints properly tested
- ✅ Error handling comprehensive
- ✅ Loading states on all async operations
- ✅ Brand consistency verified
- ✅ Documentation updated

### Nice to Have (Bonus):
- ✅ Automated tests written
- ✅ Real logo added
- ✅ Loading skeletons implemented
- ✅ Accessibility improvements
- ✅ Dark mode support

---

## Timeline Estimate

**Total Effort:** 15-20 hours
**Parallel Work:** Can reduce to 8-10 hours wall time

**Agent B (Backend):** 10-12 hours
- TrustScore: 2-3 hours
- Mutual Verification: 3-4 hours
- Safety Reports: 2-3 hours
- Subscriptions: 2-3 hours

**Agent C (Frontend):** 10-12 hours
- Mutual Verification screens: 4-6 hours
- Safety Reports screens: 3-4 hours
- Backend integration: 2-3 hours
- Polish: 2 hours

**Agent D (QA):** 6-8 hours
- Backend testing: 2-3 hours
- Frontend testing: 2-3 hours
- Integration testing: 2-3 hours

**Agent A (Architect):** 2-3 hours
- Planning: 1 hour
- Coordination: 1-2 hours

---

## Dependencies & Blockers

### Critical Dependencies:
1. Agent C needs Agent B's API contracts before building services
2. Agent D needs both Agent B and C to finish before integration testing
3. All agents need Agent A's architecture decisions

### Potential Blockers:
1. Database migrations needed for new tables
2. Stripe integration for subscriptions (may need test keys)
3. Real-time updates (may need websockets or polling)

### Mitigation:
- Use mock data initially in frontend
- Implement database migrations first
- Use Stripe test mode
- Defer real-time updates to Phase 2

---

## Next Steps

### Immediate Actions (Next 30 minutes):

**Agent A:**
1. Read existing API_CONTRACTS.md
2. Define new endpoint contracts
3. Create SPRINT_4_TASK_BOARD.md
4. Assign specific tasks to agents

**Agent B:**
1. Check database schema for missing tables
2. Create TrustScoreController skeleton
3. Start implementing GET /v1/trustscore/me

**Agent C:**
1. Create mutual_verification folder structure
2. Start building MutualVerificationHomeScreen
3. Define MutualVerification model classes

**Agent D:**
1. Set up Postman collection for new endpoints
2. Prepare test data
3. Review QA_CHECKLIST.md

---

## Communication Checkpoints

**Every 2 hours:**
- All agents update task board
- Report blockers
- Coordinate dependencies

**Every 4 hours:**
- Agent A reviews progress
- Adjusts timeline if needed
- Resolves conflicts

**End of day:**
- All agents commit code
- Update documentation
- Plan next day

---

**Status:** 🚀 Sprint 4 Active
**Target Completion:** 2025-11-23 (tomorrow)
**Let's finish this!** 💪
