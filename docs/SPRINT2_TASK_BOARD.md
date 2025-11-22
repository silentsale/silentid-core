# SilentID Sprint 2 - Task Board

**Sprint Goal:** Build core MVP features - Stripe Identity, Evidence Collection, TrustScore Engine
**Sprint Duration:** 3 weeks
**Start Date:** 2025-11-21
**Target End Date:** 2025-12-12
**Status:** ACTIVE

---

## SPRINT 2 OVERVIEW

**What We're Building:**
1. Stripe Identity integration (user verification)
2. Evidence collection system (receipts, screenshots, profile links)
3. TrustScore calculation engine (0-1000 scoring)
4. Risk engine foundation (anti-fraud basics)
5. Admin account type support
6. Security hardening (Redis, SendGrid)

**What Sprint 1 Delivered:**
- ✅ Backend authentication (Email OTP working)
- ✅ Flutter app foundation (4 screens, navigation)
- ✅ Test suite (80% coverage, 53 tests)
- ✅ Security hardened (secrets secured, CORS configured)

**Sprint 2 Success Criteria:**
- [ ] Users can verify identity via Stripe
- [ ] Users can upload evidence (receipts, screenshots)
- [ ] TrustScore displays correctly in app
- [ ] Risk engine flags suspicious evidence
- [ ] Admin role functional
- [ ] All critical services production-ready (email, storage)

---

## AGENT STATUS SUMMARY

### Agent A (Architect & Coordinator) - ACTIVE
**Current Focus:** Task board maintenance, conflict resolution, documentation
**Status:** ✅ Ready to coordinate
**Blockers:** None

### Agent B (Backend Engineer) - READY
**Current Focus:** Stripe Identity integration
**Status:** ⏳ Awaiting task assignment
**Blockers:** Need Stripe test API keys, SendGrid API key

### Agent C (Frontend Engineer) - READY
**Current Focus:** Identity verification screens
**Status:** ⏳ Awaiting backend endpoints
**Blockers:** Waiting for Stripe Identity endpoints

### Agent D (QA Engineer) - READY
**Current Focus:** Integration testing
**Status:** ⏳ Awaiting features to test
**Blockers:** None

---

## CRITICAL INFRASTRUCTURE (Priority P0)

### AGENT B - Backend Infrastructure

| ID | Task | Priority | Status | Owner | Time Est | Dependencies | Notes |
|----|------|----------|--------|-------|----------|--------------|-------|
| B-INF.1 | Configure SendGrid for email | P0 | TODO | Agent B | 30-60m | None | Replace console stub |
| B-INF.2 | Add Admin to AccountType enum | P0 | TODO | Agent B | 5m | None | Required for Section 14 |
| B-INF.3 | Create migration for Admin type | P0 | TODO | Agent B | 5m | B-INF.2 | Auto-apply in dev |
| B-INF.4 | Move secrets to user secrets | P0 | TODO | Agent B | 15m | None | JWT, DB credentials |
| B-INF.5 | Configure CORS for Flutter | P0 | TODO | Agent B | 10m | None | Allow mobile API calls |
| B-INF.6 | Switch OTP storage to Redis | P1 | TODO | Agent B | 1-2h | None | Scalability requirement |
| B-INF.7 | Switch rate limiting to Redis | P1 | TODO | Agent B | 30m | B-INF.6 | Same as OTP |
| B-INF.8 | Add global error middleware | P1 | TODO | Agent B | 30m | None | Consistent error responses |
| B-INF.9 | Configure structured logging | P1 | TODO | Agent B | 30m | None | Serilog integration |

**Agent B Total Time Estimate:** 4-6 hours

---

## PHASE 3: STRIPE IDENTITY INTEGRATION (Priority P0)

### AGENT B - Backend Tasks

| ID | Task | Priority | Status | Owner | Time Est | Dependencies | Notes |
|----|------|----------|--------|-------|----------|--------------|-------|
| B-3.1 | Install Stripe.net package | P0 | TODO | Agent B | 5m | None | NuGet package |
| B-3.2 | Get Stripe test API keys | P0 | TODO | Agent B | 15m | None | Stripe dashboard signup |
| B-3.3 | Create IdentityVerification model | P0 | TODO | Agent B | 20m | None | Section 8 schema |
| B-3.4 | Create migration for IdentityVerification | P0 | TODO | Agent B | 10m | B-3.3 | Auto-apply |
| B-3.5 | Create StripeIdentityService | P0 | TODO | Agent B | 1h | B-3.1, B-3.2 | Wrap Stripe API |
| B-3.6 | Implement POST /v1/identity/stripe/session | P0 | TODO | Agent B | 45m | B-3.5 | Create verification session |
| B-3.7 | Implement GET /v1/identity/status | P0 | TODO | Agent B | 30m | B-3.5 | Return verification status |
| B-3.8 | Implement Stripe webhooks handler | P1 | TODO | Agent B | 1h | B-3.5 | Verification completion |
| B-3.9 | Add Stripe config to user secrets | P0 | TODO | Agent B | 10m | B-3.2 | Secure API key |

**Agent B Total Time Estimate:** 4-5 hours

### AGENT C - Frontend Tasks

| ID | Task | Priority | Status | Owner | Time Est | Dependencies | Notes |
|----|------|----------|--------|-------|----------|--------------|-------|
| C-3.1 | Build Identity Intro screen | P0 | TODO | Agent C | 1h | None | Explain Stripe verification |
| C-3.2 | Build Stripe WebView screen | P0 | TODO | Agent C | 1.5h | B-3.6 | Display Stripe Identity UI |
| C-3.3 | Build Identity Status screen | P0 | TODO | Agent C | 1h | B-3.7 | Show verification result |
| C-3.4 | Implement Stripe session flow | P0 | TODO | Agent C | 1h | C-3.1, C-3.2 | Call backend, show WebView |
| C-3.5 | Add Identity badge to Home screen | P1 | TODO | Agent C | 30m | C-3.3 | "Identity Verified" badge |

**Agent C Total Time Estimate:** 5 hours

### AGENT D - QA Tasks

| ID | Task | Priority | Status | Owner | Time Est | Dependencies | Notes |
|----|------|----------|--------|-------|----------|--------------|-------|
| D-3.1 | Test Stripe session creation endpoint | P0 | TODO | Agent D | 30m | B-3.6 | Use test mode |
| D-3.2 | Test Stripe verification flow E2E | P0 | TODO | Agent D | 1h | C-3.4 | Test with fake ID |
| D-3.3 | Validate NO ID documents stored | P0 | TODO | Agent D | 20m | D-3.2 | CRITICAL security check |
| D-3.4 | Test webhook handling | P1 | TODO | Agent D | 30m | B-3.8 | Mock Stripe webhooks |
| D-3.5 | Verify status endpoint accuracy | P1 | TODO | Agent D | 20m | B-3.7 | Check all status states |

**Agent D Total Time Estimate:** 2.5 hours

---

## PHASE 4: DATABASE SCHEMA EXPANSION (Priority P0)

### AGENT B - Backend Tasks

| ID | Task | Priority | Status | Owner | Time Est | Dependencies | Notes |
|----|------|----------|--------|-------|----------|--------------|-------|
| B-4.1 | Create ReceiptEvidence model | P0 | TODO | Agent B | 30m | None | Section 8 |
| B-4.2 | Create ScreenshotEvidence model | P0 | TODO | Agent B | 30m | None | Section 8 |
| B-4.3 | Create ProfileLinkEvidence model | P0 | TODO | Agent B | 30m | None | Section 8 |
| B-4.4 | Create MutualVerifications model | P0 | TODO | Agent B | 30m | None | Section 8 |
| B-4.5 | Create TrustScoreSnapshots model | P0 | TODO | Agent B | 20m | None | Section 8 |
| B-4.6 | Create RiskSignals model | P0 | TODO | Agent B | 30m | None | Section 8 |
| B-4.7 | Create Reports model | P1 | TODO | Agent B | 30m | None | Section 8 |
| B-4.8 | Create ReportEvidence model | P1 | TODO | Agent B | 20m | B-4.7 | Section 8 |
| B-4.9 | Create Subscriptions model | P2 | TODO | Agent B | 20m | None | Section 8 |
| B-4.10 | Create AdminAuditLogs model | P2 | TODO | Agent B | 20m | None | Section 8 |
| B-4.11 | Create SecurityAlerts model | P2 | TODO | Agent B | 20m | None | Section 15 |
| B-4.12 | Generate comprehensive migration | P0 | TODO | Agent B | 30m | B-4.1 to B-4.11 | All tables at once |
| B-4.13 | Apply migration to dev database | P0 | TODO | Agent B | 10m | B-4.12 | Verify success |

**Agent B Total Time Estimate:** 5 hours

### AGENT D - QA Tasks

| ID | Task | Priority | Status | Owner | Time Est | Dependencies | Notes |
|----|------|----------|--------|-------|----------|--------------|-------|
| D-4.1 | Validate all tables match CLAUDE.md | P0 | TODO | Agent D | 1h | B-4.13 | Section 8 compliance |
| D-4.2 | Check UUIDs, indexes, constraints | P0 | TODO | Agent D | 30m | B-4.13 | Verify schema quality |
| D-4.3 | Test cascade deletes | P1 | TODO | Agent D | 30m | B-4.13 | User deletion cascades |
| D-4.4 | Test foreign key relationships | P1 | TODO | Agent D | 30m | B-4.13 | All FKs valid |

**Agent D Total Time Estimate:** 2.5 hours

---

## PHASE 5: EVIDENCE COLLECTION APIS (Priority P0)

### AGENT B - Backend Tasks

| ID | Task | Priority | Status | Owner | Time Est | Dependencies | Notes |
|----|------|----------|--------|-------|----------|--------------|-------|
| B-5.1 | Configure Azure Blob Storage | P0 | TODO | Agent B | 30m | None | For evidence files |
| B-5.2 | Create FileStorageService | P0 | TODO | Agent B | 1.5h | B-5.1 | Upload/download files |
| B-5.3 | Create ReceiptParsingService (stub) | P1 | TODO | Agent B | 1h | None | AI extraction (stub MVP) |
| B-5.4 | Create OcrService (Azure Cognitive) | P1 | TODO | Agent B | 1.5h | None | Screenshot OCR |
| B-5.5 | Create ProfileScraperService (stub) | P2 | TODO | Agent B | 1h | None | Playwright scraping |
| B-5.6 | POST /v1/evidence/receipts/manual | P0 | TODO | Agent B | 1h | B-5.3 | Manual receipt upload |
| B-5.7 | GET /v1/evidence/receipts | P0 | TODO | Agent B | 30m | B-5.6 | List user receipts |
| B-5.8 | POST /v1/evidence/screenshots/upload-url | P0 | TODO | Agent B | 45m | B-5.2 | Signed upload URL |
| B-5.9 | POST /v1/evidence/screenshots | P0 | TODO | Agent B | 1.5h | B-5.4 | Process screenshot |
| B-5.10 | GET /v1/evidence/screenshots/{id} | P0 | TODO | Agent B | 30m | B-5.9 | Get screenshot |
| B-5.11 | POST /v1/evidence/profile-links | P1 | TODO | Agent B | 1h | B-5.5 | Submit profile URL |
| B-5.12 | GET /v1/evidence/profile-links/{id} | P1 | TODO | Agent B | 30m | B-5.11 | Get scraped data |

**Agent B Total Time Estimate:** 11 hours

### AGENT C - Frontend Tasks

| ID | Task | Priority | Status | Owner | Time Est | Dependencies | Notes |
|----|------|----------|--------|-------|----------|--------------|-------|
| C-5.1 | Build Evidence Overview screen | P0 | TODO | Agent C | 1.5h | None | Receipts, screenshots, profiles |
| C-5.2 | Build Receipt List screen | P0 | TODO | Agent C | 1h | B-5.7 | Display receipts |
| C-5.3 | Build Manual Receipt Upload screen | P0 | TODO | Agent C | 1.5h | B-5.6 | Form + submit |
| C-5.4 | Build Screenshot Upload screen | P0 | TODO | Agent C | 2h | B-5.9 | Image picker + upload |
| C-5.5 | Build Screenshot Details screen | P1 | TODO | Agent C | 1h | B-5.10 | Show OCR results |
| C-5.6 | Build Profile Link screen | P1 | TODO | Agent C | 1.5h | B-5.11 | Paste URL, scrape |
| C-5.7 | Implement evidence upload flows | P0 | TODO | Agent C | 2h | C-5.3, C-5.4 | Connect to backend |

**Agent C Total Time Estimate:** 10.5 hours

### AGENT D - QA Tasks

| ID | Task | Priority | Status | Owner | Time Est | Dependencies | Notes |
|----|------|----------|--------|-------|----------|--------------|-------|
| D-5.1 | Test receipt upload E2E | P0 | TODO | Agent D | 45m | B-5.6, C-5.7 | Full flow |
| D-5.2 | Test screenshot upload + OCR | P0 | TODO | Agent D | 1h | B-5.9, C-5.4 | Verify OCR works |
| D-5.3 | Test profile scraping | P1 | TODO | Agent D | 45m | B-5.11 | Public test profiles |
| D-5.4 | Verify Azure Blob storage | P0 | TODO | Agent D | 30m | D-5.1, D-5.2 | Files stored correctly |
| D-5.5 | Test authorization on endpoints | P0 | TODO | Agent D | 45m | B-5.12 | User-scoped access |
| D-5.6 | Test evidence listing pagination | P1 | TODO | Agent D | 30m | B-5.7 | Large datasets |

**Agent D Total Time Estimate:** 4.5 hours

---

## PHASE 6: TRUSTSCORE ENGINE (Priority P0)

### AGENT B - Backend Tasks

| ID | Task | Priority | Status | Owner | Time Est | Dependencies | Notes |
|----|------|----------|--------|-------|----------|--------------|-------|
| B-6.1 | Create TrustScoreService | P0 | TODO | Agent B | 2h | B-4.13 | Core calculation logic |
| B-6.2 | Implement Identity scoring (200 pts) | P0 | TODO | Agent B | 1h | B-6.1, B-3.5 | Stripe verification |
| B-6.3 | Implement Evidence scoring (300 pts) | P0 | TODO | Agent B | 2h | B-6.1, B-5.12 | Count receipts/screenshots |
| B-6.4 | Implement Behaviour scoring (300 pts) | P0 | TODO | Agent B | 1.5h | B-6.1 | Account age, reports |
| B-6.5 | Implement Peer scoring (200 pts) | P1 | TODO | Agent B | 1h | B-6.1 | Mutual verifications |
| B-6.6 | GET /v1/trustscore/me | P0 | TODO | Agent B | 45m | B-6.5 | Return current score |
| B-6.7 | GET /v1/trustscore/me/breakdown | P0 | TODO | Agent B | 1h | B-6.6 | Component breakdown |
| B-6.8 | GET /v1/trustscore/me/history | P1 | TODO | Agent B | 45m | B-6.6 | Historical snapshots |
| B-6.9 | Create background job for weekly recalc | P2 | TODO | Agent B | 1.5h | B-6.5 | IHostedService |

**Agent B Total Time Estimate:** 11.5 hours

### AGENT C - Frontend Tasks

| ID | Task | Priority | Status | Owner | Time Est | Dependencies | Notes |
|----|------|----------|--------|-------|----------|--------------|-------|
| C-6.1 | Build TrustScore Overview screen | P0 | TODO | Agent C | 2h | B-6.6 | Big score display |
| C-6.2 | Build TrustScore Breakdown screen | P0 | TODO | Agent C | 2h | B-6.7 | Component breakdown |
| C-6.3 | Build TrustScore History screen | P1 | TODO | Agent C | 1.5h | B-6.8 | Timeline view |
| C-6.4 | Implement TrustScore API calls | P0 | TODO | Agent C | 1h | C-6.1, C-6.2 | Fetch from backend |
| C-6.5 | Add TrustScore to Home screen | P0 | TODO | Agent C | 1h | C-6.1 | Display on main tab |
| C-6.6 | Create TrustScore badge component | P1 | TODO | Agent C | 45m | None | Reusable widget |

**Agent C Total Time Estimate:** 8.25 hours

### AGENT D - QA Tasks

| ID | Task | Priority | Status | Owner | Time Est | Dependencies | Notes |
|----|------|----------|--------|-------|----------|--------------|-------|
| D-6.1 | Test TrustScore calculation accuracy | P0 | TODO | Agent D | 1.5h | B-6.5 | Verify math |
| D-6.2 | Test 0-1000 range enforcement | P0 | TODO | Agent D | 30m | D-6.1 | Never exceeds |
| D-6.3 | Test breakdown endpoint schema | P0 | TODO | Agent D | 30m | B-6.7 | Response format |
| D-6.4 | Test score updates after evidence | P1 | TODO | Agent D | 1h | D-5.1, D-6.1 | Dynamic recalc |
| D-6.5 | Test UI displays correctly | P0 | TODO | Agent D | 45m | C-6.5 | App shows score |

**Agent D Total Time Estimate:** 4.25 hours

---

## PHASE 7: RISK ENGINE FOUNDATION (Priority P1)

### AGENT B - Backend Tasks

| ID | Task | Priority | Status | Owner | Time Est | Dependencies | Notes |
|----|------|----------|--------|-------|----------|--------------|-------|
| B-7.1 | Create RiskEngineService | P1 | TODO | Agent B | 2h | B-4.13 | 0-100 risk scoring |
| B-7.2 | Implement fake screenshot detection | P1 | TODO | Agent B | 2h | B-7.1 | Image forensics |
| B-7.3 | Implement fake receipt detection | P1 | TODO | Agent B | 1.5h | B-7.1 | Basic validation |
| B-7.4 | Integrate risk checks into evidence | P1 | TODO | Agent B | 1.5h | B-7.3, B-5.9 | Auto-flag suspicious |
| B-7.5 | Implement risk score thresholds | P1 | TODO | Agent B | 1h | B-7.4 | Freeze at 70+ |
| B-7.6 | GET /v1/security/risk-score | P2 | TODO | Agent B | 45m | B-7.5 | User's risk data |

**Agent B Total Time Estimate:** 8.75 hours

### AGENT D - QA Tasks

| ID | Task | Priority | Status | Owner | Time Est | Dependencies | Notes |
|----|------|----------|--------|-------|----------|--------------|-------|
| D-7.1 | Test fake screenshot rejection | P1 | TODO | Agent D | 1h | B-7.2 | Upload fake image |
| D-7.2 | Test account freeze on high risk | P1 | TODO | Agent D | 45m | B-7.5 | Verify lockout |
| D-7.3 | Test risk score endpoint | P2 | TODO | Agent D | 30m | B-7.6 | Response format |

**Agent D Total Time Estimate:** 2.25 hours

---

## BACKLOG (Sprint 3+)

### Deferred to Future Sprints:
- Apple Sign-In integration
- Google Sign-In integration
- Passkeys (WebAuthn)
- Mutual Verification system
- Public Profile generation
- Safety Reports system
- Subscriptions & Stripe Billing
- Admin Dashboard UI
- Security Center features
- Collusion detection (advanced)
- Profile scraping (Playwright)

---

## DEPENDENCY GRAPH

```
Infrastructure (SendGrid, Redis, Admin enum)
  ↓
Phase 3: Stripe Identity
  ↓
Phase 4: Database Schema
  ↓
Phase 5: Evidence APIs ← Phase 6: TrustScore
  ↓                        ↓
Phase 7: Risk Engine ← Flutter UI (Evidence, TrustScore screens)
```

---

## TIME ESTIMATES BY AGENT

### Agent B (Backend)
- Infrastructure: 4-6 hours
- Stripe Identity: 4-5 hours
- Database Schema: 5 hours
- Evidence APIs: 11 hours
- TrustScore Engine: 11.5 hours
- Risk Engine: 8.75 hours
- **Total: 44-46 hours (5-6 days)**

### Agent C (Frontend)
- Stripe Identity UI: 5 hours
- Evidence UI: 10.5 hours
- TrustScore UI: 8.25 hours
- **Total: 23.75 hours (3 days)**

### Agent D (QA)
- Stripe tests: 2.5 hours
- Database tests: 2.5 hours
- Evidence tests: 4.5 hours
- TrustScore tests: 4.25 hours
- Risk Engine tests: 2.25 hours
- **Total: 16 hours (2 days)**

**Total Sprint Effort: ~84 hours (10-11 working days across 3 agents in parallel)**

---

## BLOCKERS & RISKS

### Current Blockers:
- None (all agents can start work independently)

### External Dependencies:
1. **Stripe API Keys** - Agent B needs test keys (15 min to obtain)
2. **Azure Blob Storage Account** - Agent B needs credentials (30 min setup)
3. **Azure Cognitive Services** - Agent B needs OCR keys (30 min setup)
4. **SendGrid API Key** - Agent B needs email credentials (15 min setup)

### Risk Mitigation:
- Agent B can use stub implementations where external services unavailable
- All external dependencies documented with fallback plans
- Parallel development possible (agents don't block each other)

---

## DAILY STANDUP SCHEDULE

**Time:** 9:00 AM daily
**Location:** /docs/DAILY_STANDUPS.md
**Participants:** Agent A, B, C, D

**Format:**
- Yesterday's progress
- Today's plan
- Blockers

---

## SUCCESS METRICS

### Sprint Completion Criteria:
- [ ] All P0 tasks marked DONE
- [ ] All tests passing (Agent D verification)
- [ ] No critical findings from Agent A review
- [ ] Documentation updated
- [ ] Git commits with clear messages

### Code Quality Standards:
- [ ] No password-related code
- [ ] All endpoints follow REST conventions
- [ ] All database operations use EF Core
- [ ] All secrets secured
- [ ] Consistent error responses
- [ ] 80%+ test coverage maintained

---

**Task Board Owner:** Agent A (Architect & Coordinator)
**Last Updated:** 2025-11-21
**Next Review:** Daily standup
**Status:** ACTIVE
