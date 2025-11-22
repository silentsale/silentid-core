# SilentID Sprint 2 - Risk Assessment & Mitigation

**Sprint:** Sprint 2 (Core MVP Features)
**Duration:** 2025-11-21 to 2025-12-12 (3 weeks)
**Risk Level:** MEDIUM

---

## RISK SUMMARY

**Overall Risk Assessment:** 🟡 MEDIUM

**Risk Breakdown:**
- Technical Risk: 🟢 LOW (solid foundation from Sprint 1)
- Delivery Risk: 🟡 MEDIUM (ambitious scope, external dependencies)
- Resource Risk: 🟢 LOW (3 agents available, parallel development)
- Security Risk: 🟢 LOW (passwordless compliance verified)
- Integration Risk: 🟡 MEDIUM (multiple external services)

---

## CRITICAL RISKS (P0)

### RISK-1: External Service Dependencies

**Description:** Sprint 2 requires 4 external services that may block progress

**Impact:** HIGH
**Probability:** MEDIUM

**Dependencies:**
1. **Stripe Identity API** - Required for Phase 3
   - Need test API keys
   - Need to understand Stripe Identity flow
   - Webhook setup complexity

2. **Azure Blob Storage** - Required for Phase 5
   - Need Azure account
   - Need storage credentials
   - Need to configure CORS

3. **Azure Cognitive Services (OCR)** - Required for Phase 5
   - Need Azure account
   - Need OCR API keys
   - OCR accuracy may vary

4. **SendGrid** - Required for infrastructure
   - Need SendGrid account
   - Need API key
   - Email deliverability concerns

**Mitigation:**

**Immediate Actions (Agent B):**
- [ ] Sign up for Stripe test account (15 minutes)
- [ ] Sign up for SendGrid free tier (15 minutes)
- [ ] Sign up for Azure free tier (30 minutes)
- [ ] Document all API keys in user secrets

**Fallback Plans:**
- Stripe Identity: Stub implementation with manual admin approval
- Azure Blob: Local file system storage for dev
- Azure OCR: Tesseract open-source OCR fallback
- SendGrid: Console logging for dev (already implemented)

**Owner:** Agent B (Backend)
**Target Resolution:** Day 1 of Sprint 2

---

### RISK-2: Scope Creep

**Description:** Sprint 2 has 84 hours of work across 3 agents - risk of not completing all features

**Impact:** MEDIUM
**Probability:** MEDIUM

**Scope Breakdown:**
- Agent B: 44-46 hours (5-6 days)
- Agent C: 23.75 hours (3 days)
- Agent D: 16 hours (2 days)

**Risk Factors:**
- Underestimated complexity of TrustScore calculation
- OCR integration may take longer than planned
- Risk engine false positive rate requires tuning
- Frontend UI polish not accounted for

**Mitigation:**

**Priority Tiers:**

**MUST HAVE (P0) - Cannot ship without:**
- ✅ Stripe Identity integration
- ✅ Evidence upload (receipts, screenshots)
- ✅ TrustScore basic calculation
- ✅ Database schema complete

**SHOULD HAVE (P1) - Important but can defer:**
- ⏳ Risk engine basic implementation
- ⏳ Profile link scraping
- ⏳ TrustScore history
- ⏳ Admin enum addition

**NICE TO HAVE (P2) - Sprint 3 if needed:**
- 🔄 Weekly TrustScore recalculation job
- 🔄 Advanced screenshot forensics
- 🔄 Collusion detection

**Decision Protocol:**
- End of Week 2: Assess completion %
- If < 60% P0 tasks complete → Cut P2, defer P1
- If < 80% P0 tasks complete by end of Week 2 → Extend sprint 1 week

**Owner:** Agent A (Architect)
**Review Frequency:** Daily standup

---

### RISK-3: Integration Test Coverage

**Description:** 53 tests exist for Sprint 1, but Sprint 2 adds 11 new tables and 13 new endpoints - test suite must grow

**Impact:** MEDIUM
**Probability:** LOW

**Current Coverage:** 80%
**Target Coverage:** 80% (maintain)

**New Tests Required:**
- Stripe Identity integration tests (5 tests)
- Evidence upload integration tests (10 tests)
- TrustScore calculation unit tests (15 tests)
- Risk engine unit tests (10 tests)
- Database schema validation tests (5 tests)

**Total New Tests:** ~45 tests (doubling test suite)

**Mitigation:**

**Agent D Workload:**
- Week 1: Write Stripe + database tests (10 tests)
- Week 2: Write evidence upload tests (10 tests)
- Week 3: Write TrustScore + risk tests (25 tests)

**Parallel Testing:**
- Agent D writes tests as Agent B implements features
- No feature marked "complete" until tests pass

**Continuous Integration:**
- Run test suite on every commit
- Fail build if coverage drops below 75%

**Owner:** Agent D (QA)
**Target:** Maintain 80% coverage

---

## HIGH RISKS (P1)

### RISK-4: Stripe Identity Learning Curve

**Description:** Team has no prior Stripe Identity experience - implementation may take longer than estimated

**Impact:** MEDIUM
**Probability:** MEDIUM

**Complexity Factors:**
- Stripe Identity SDK unfamiliar
- Webhook signature verification tricky
- Mobile WebView integration complex
- Test mode vs production mode differences

**Mitigation:**

**Learning Resources:**
- [ ] Agent B reads Stripe Identity docs (1 hour)
- [ ] Agent B follows Stripe quickstart (30 minutes)
- [ ] Agent B tests with Stripe test mode first
- [ ] Agent C reviews Stripe WebView Flutter integration

**Estimated Time Buffer:**
- Initial estimate: 4-5 hours
- Add 50% buffer: 6-7.5 hours
- Total allocated: 8 hours

**Owner:** Agent B (Backend), Agent C (Frontend)
**Timeline:** Week 1

---

### RISK-5: OCR Accuracy

**Description:** Azure Cognitive Services OCR may not accurately extract text from screenshots

**Impact:** MEDIUM
**Probability:** MEDIUM

**Accuracy Concerns:**
- Low-quality screenshots (blurry, dark)
- Non-English text
- Handwritten text
- Complex layouts (tables, columns)

**Mitigation:**

**Quality Requirements:**
- Accept only PNG/JPG images
- Minimum resolution: 800x600
- Maximum file size: 10MB
- Warn users to upload clear screenshots

**Fallback Strategy:**
- If OCR confidence < 70% → Flag for manual review
- Store raw screenshot even if OCR fails
- Allow admin to manually extract text

**Testing:**
- Agent D tests with variety of screenshot types
- Measure OCR accuracy across platforms (Vinted, eBay, Depop)
- Document which platforms work best

**Owner:** Agent B (Backend), Agent D (QA)
**Timeline:** Week 2

---

### RISK-6: TrustScore Calculation Complexity

**Description:** TrustScore formula is complex (4 components, 1000-point scale) - implementation bugs likely

**Impact:** HIGH
**Probability:** MEDIUM

**Complexity Factors:**
- Identity score: 200 points (Stripe verification status)
- Evidence score: 300 points (receipts + screenshots + profiles)
- Behaviour score: 300 points (account age, reports, consistency)
- Peer score: 200 points (mutual verifications)

**Edge Cases:**
- New user (0 evidence) → should still get basic score
- User with reports → score penalty calculation
- Score cap enforcement (never exceed 1000)
- Negative scores (should floor at 0)

**Mitigation:**

**Unit Testing:**
- [ ] Agent D writes 15+ TrustScore calculation tests
- [ ] Test each component independently
- [ ] Test edge cases (0 evidence, max evidence, reports)
- [ ] Test score range enforcement

**Code Review:**
- [ ] Agent A reviews TrustScoreService logic
- [ ] Verify formula matches CLAUDE.md Section 12
- [ ] Verify breakdown JSON format correct

**Manual Validation:**
- Create test users with known evidence
- Calculate expected score manually
- Compare with system-generated score

**Owner:** Agent B (Backend), Agent D (QA)
**Timeline:** Week 2-3

---

### RISK-7: Mobile WebView Integration

**Description:** Stripe Identity requires mobile WebView - Flutter WebView integration may have platform-specific issues

**Impact:** MEDIUM
**Probability:** MEDIUM

**Platform Issues:**
- iOS WebView may have security restrictions
- Android WebView requires specific permissions
- Deep linking back to app after verification
- Session cookies not shared between WebView and app

**Mitigation:**

**Flutter Packages:**
- Use `webview_flutter` official package
- Test on both iOS and Android
- Handle WebView errors gracefully

**Deep Linking:**
- Configure iOS Universal Links
- Configure Android App Links
- Test return URL: `silentid://identity-verification-complete`

**Fallback:**
- If WebView fails → Open in external browser
- User manually returns to app after verification

**Owner:** Agent C (Frontend)
**Timeline:** Week 1

---

## MEDIUM RISKS (P2)

### RISK-8: Azure Blob Storage Costs

**Description:** Evidence uploads could generate unexpected Azure costs if not managed

**Impact:** LOW
**Probability:** LOW

**Cost Factors:**
- 10MB max per screenshot
- Free tier: 100 users × 5 screenshots = 500MB (within free limits)
- Premium tier: unlimited uploads (cost risk)

**Mitigation:**

**Usage Limits:**
- Free tier: 250MB evidence vault
- Premium tier: 100GB evidence vault
- Pro tier: 500GB evidence vault

**Cost Monitoring:**
- Set Azure budget alerts
- Monitor storage usage weekly
- Implement cleanup job (delete evidence after account deletion)

**Owner:** Agent B (Backend)
**Timeline:** Week 2

---

### RISK-9: Database Migration Failures

**Description:** Adding 11 new tables in single migration - migration failure could block development

**Impact:** MEDIUM
**Probability:** LOW

**Migration Complexity:**
- 11 new tables
- Multiple foreign keys
- JSON columns (JSONB)
- Indexes on critical fields

**Mitigation:**

**Migration Strategy:**
- [ ] Agent B creates migration locally first
- [ ] Agent B tests migration on clean database
- [ ] Agent B tests rollback (down migration)
- [ ] Agent D validates schema matches CLAUDE.md

**Rollback Plan:**
- If migration fails → revert to previous migration
- Fix migration script
- Test again on clean DB

**Auto-Migration in Dev:**
- Migrations auto-apply on startup in Development
- Manual approval in Production

**Owner:** Agent B (Backend)
**Timeline:** Week 1

---

### RISK-10: Performance Issues

**Description:** TrustScore calculation may be slow with large datasets

**Impact:** LOW
**Probability:** LOW

**Performance Concerns:**
- User with 1000+ receipts → slow calculation
- Weekly recalculation job → database load
- Breakdown query → multiple table joins

**Mitigation:**

**Optimization:**
- Index on foreign keys (UserId)
- Cache TrustScore snapshot (recompute weekly only)
- Pagination on evidence lists
- Background job for weekly recalc (not real-time)

**Performance Testing:**
- [ ] Agent D creates test users with 100+ receipts
- [ ] Measure TrustScore calculation time
- [ ] Target: < 500ms for calculation

**Owner:** Agent B (Backend), Agent D (QA)
**Timeline:** Week 3

---

## LOW RISKS (P3)

### RISK-11: Branding Inconsistencies

**Description:** Flutter app may deviate from royal purple #5A3EB8 branding

**Impact:** LOW
**Probability:** LOW

**Mitigation:**
- Agent C uses custom theme with exact purple
- Agent A reviews screenshots for branding compliance
- Document deviations in FRONTEND_NOTES.md

**Owner:** Agent C (Frontend), Agent A (Architect)

---

### RISK-12: Passwordless Compliance Regression

**Description:** New code might accidentally introduce password fields

**Impact:** CRITICAL (but LOW probability)
**Probability:** VERY LOW

**Mitigation:**
- Automated tests prevent password fields
- 7 security tests verify passwordless compliance
- Agent D runs tests on every commit
- Build fails if password code detected

**Owner:** Agent D (QA)

---

## RISK MONITORING

### Daily Check-in (Agent A)

**Questions to Ask:**
1. Are any agents blocked by external dependencies?
2. Are any tasks taking longer than estimated?
3. Do we need to cut scope to meet sprint deadline?
4. Are tests being written alongside features?

### Weekly Review (Agent A)

**Metrics to Track:**
- % of P0 tasks complete
- % of P1 tasks complete
- Test coverage %
- Number of blockers

**Decision Gates:**
- End of Week 1: Should be 30% complete
- End of Week 2: Should be 70% complete
- End of Week 3: Should be 100% complete

**If Behind Schedule:**
- Identify causes (underestimation, blockers, scope creep)
- Cut P2 tasks
- Defer P1 tasks to Sprint 3
- Extend sprint 1 week if critical

---

## RISK RESPONSE PLAN

### If Stripe Integration Fails

**Trigger:** Cannot get Stripe Identity working by end of Week 1

**Response:**
1. Implement stub IdentityVerification service
2. Admin manually marks users as verified
3. Defer real Stripe integration to Sprint 3
4. Continue with rest of Sprint 2

---

### If Azure Services Fail

**Trigger:** Cannot get Azure Blob or OCR working by end of Week 1

**Response:**
1. Use local file storage for evidence
2. Use Tesseract open-source OCR
3. Defer Azure integration to Sprint 3
4. Continue with rest of Sprint 2

---

### If Test Coverage Drops

**Trigger:** Coverage falls below 75%

**Response:**
1. Agent D prioritizes writing tests
2. Agent B pauses new features
3. No new features until coverage restored
4. Daily review until back above 80%

---

### If Scope Overload

**Trigger:** < 60% complete by end of Week 2

**Response:**
1. Cut all P2 tasks immediately
2. Defer P1 tasks to Sprint 3
3. Focus only on P0 critical path
4. Extend sprint 1 week if needed

---

## EXTERNAL DEPENDENCIES CHECKLIST

**Agent B must obtain by Day 1:**

- [ ] Stripe test account (free)
  - URL: https://dashboard.stripe.com/register
  - Get: Secret Key, Publishable Key
  - Time: 15 minutes

- [ ] SendGrid free tier (free)
  - URL: https://signup.sendgrid.com/
  - Get: API Key
  - Time: 15 minutes

- [ ] Azure free tier (free)
  - URL: https://azure.microsoft.com/free/
  - Get: Blob Storage connection string
  - Get: Cognitive Services OCR key
  - Time: 30 minutes

**Total Setup Time:** 60 minutes
**Owner:** Agent B (Backend)
**Deadline:** 2025-11-21 EOD

---

## RISK ESCALATION

**Escalation Path:**
1. Agent identifies risk
2. Agent reports to Agent A (Architect)
3. Agent A assesses impact
4. Agent A decides mitigation or escalation
5. If critical → notify user immediately

**Critical Risk Definition:**
- Blocks all development for >24 hours
- Requires scope cut >50%
- Security vulnerability discovered
- Data loss or corruption

---

**Document Owner:** Agent A (Architect)
**Last Updated:** 2025-11-21
**Review Frequency:** Daily
**Status:** ACTIVE
