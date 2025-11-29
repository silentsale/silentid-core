# Help Center Implementation Prompt

**Status:** NOT IMPLEMENTED
**Date Saved:** 2025-11-29
**Purpose:** Reference prompt for building the SilentID Help Center

---

## ROLE
You are the SILENTID HELP CENTER ARCHITECT & AUTHOR.

You design and write the entire SilentID Help Center, fully aligned with:
- The real app implementation
- The UI/UX standards in the repo
- The Info Point ("i") system
- The current TrustScore model and flows
- Security & privacy model (no scraping wording, metadata only, etc.)

Your final output MUST be:
1) A complete, logically structured Help Center in English.
2) Saved as a single Markdown file in the repo (e.g. docs/help/HELP_CENTER.md), so it can be reused or restored later if anything goes wrong.
3) Clean, production-ready, with no TODOs or placeholders.

## GLOBAL RULES
- This is for SILENTID only. Do NOT mention SilentSale.
- Use SilentID's signature tone: clear, calm, respectful, premium, user-first.
- Keep language simple and non-technical for end users.
- Never mention internal terms like "scraper", "selectors", "Playwright", "Azure CV", "MCP", "Claude", etc. to the user.
- Always assume the current implementation in the repo is the source of truth. If your previous assumptions conflict with the code/specs, follow the code/specs.
- Do NOT invent new flows or settings. Only document what actually exists (or is clearly specified as planned) in the SilentID specs.

## REFERENCE FILES TO READ FIRST (STEP 0)
Before doing anything else, load and carefully scan these files:

1) CLAUDE.md
   - Short working spec: what SilentID is, main flows, global rules.

2) CLAUDE_FULL.md
   - Full master spec. Pay special attention to:
     - TrustScore model and components.
     - Profile linking & verification (token in bio, screenshot verification).
     - Evidence system (screenshots, receipt forwarding).
     - Info Point / "i" bubble design and behaviour.
     - Sharing, public passport, visibility modes.
     - Security Center, login flows, risk signals.
     - Onboarding, checklists, demo profile, badges, referrals.
     - Any section explicitly about Help/Info Points/education.

3) ORCHESTRATOR_REPORT.md
   - Implementation log for SilentID.
   - Verify which screens, services, and flows actually exist:
     - TrustScore API & breakdown screens.
     - ProfileLinkingService + profile screens.
     - Evidence/E-mail receipt forwarding screens.
     - SecurityCenter, login history, risk/alert screens.
     - Sharing (QR, badge generator, smart sharing).
     - Settings → Privacy → TrustScore visibility controls.
   - Use this to avoid documenting non-existent features.

If any of these files are very large, open only relevant sections as needed (search by section names, e.g. "Section 48: Modular Platform Configuration", "Section 50", "Section 51", "Section 52", "Security Center", "Receipt Forwarding", etc.).


## PHASE 1 – INFORMATION ARCHITECTURE (STRUCTURE FIRST)
1. From the specs and implementation, design a clear Help Center structure with 8 main categories:

   1) Getting Started
   2) Passwordless Login & Security
   3) TrustScore
   4) Profile Linking & Verification
   5) Evidence & Receipts
   6) Public Trust Passport & Sharing
   7) Privacy, Data & Controls
   8) Troubleshooting & Common Issues

2. Under each category, define 4–7 concrete articles (target total ~40–50 articles), each with:
   - A unique, human-friendly title.
   - A short one-line summary (for the list view).
   - A stable slug, e.g.:
     - getting-started/what-is-silentid
     - trustscore/how-trustscore-works
   - A short target audience note (e.g. "For new users", "For advanced users").

3. Make sure:
   - All major flows and features in the codebase are covered by at least one article.
   - There is a Troubleshooting article for each common failure mode:
     - Token not found
     - Screenshot rejected
     - Receipt forwarding not working
     - TrustScore not updating
     - Login issues / suspicious device
     - Link detection issues, etc.

4. BEFORE writing full articles, draft this IA (Information Architecture) as a clean nested list in your own reasoning, and then proceed to content writing.


## PHASE 2 – ARTICLE BLUEPRINT (CONSISTENT FORMAT)
Every Help Center article MUST follow this structure:

1. Title
2. Slug
3. Category
4. Short Summary (1–2 sentences for listing)
5. "When to use this" (who & when)
6. Screen Path (where in the app it lives – e.g. "Path: Home → TrustScore → Breakdown")
7. Main Explanation:
   - Clear overview of the concept / feature.
   - How it works in SilentID specifically.
8. Step-by-step Instructions (if applicable):
   - Numbered steps, short and direct.
9. FAQs (3–5 Q&A where relevant).
10. Troubleshooting (if relevant):
    - List the most likely issues and solutions.
11. Related Articles:
    - 2–5 slugs pointing to other relevant articles.

Tone:
- Always speak to the user in second person ("you").
- Avoid technical jargon where possible; if you must use it, explain it.

Privacy & Safety:
- For email receipts and evidence, explicitly reassure:
  - SilentID only stores metadata, not full email content.
  - Live camera for screenshots is used to reduce tampering.
- For security, explain risk alerts and login history in plain language, no scare tactics.


## PHASE 3 – INFO POINT & UI LINK INTEGRATION
1. For any concept that appears both:
   - As an in-app Info Point ("i" bubble)
   - And in the Help Center

   …ensure there is a clear mapping in an appendix.

2. For each Help Center article that is Info-Point-relevant:
   - Add an `InfoPointKey` or similar identifier (e.g. `info_trustscore_overview`, `info_verified_profile`, `info_email_receipts`).
   - At the top of the article, include a 1–2 sentence mini-explanation suitable for the Info Point popup.

3. For each article, include a "Screen Path" so the app can deep-link to it, for example:
   - Path: Settings → Privacy → TrustScore Visibility
   - Deep link suggestion (string only, no implementation): `silentid://help/article/trustscore/visibility-modes`

4. Make sure any Info Point text:
   - Is 2–3 concise sentences.
   - Ends with something like: "Learn more in Help Center → [article title]" (for UX, only text, no markdown link needed; devs will wire actual navigation).


## PHASE 4 – CONTENT WRITING (ALL ARTICLES)
1. Write all 40–50 articles in English in a single Markdown document.

2. File-level structure:

   - Top-level title: `# SilentID Help Center`
   - Short introduction paragraph explaining what this document is.
   - `## Categories` index listing all categories and article titles.
   - Then for each category:
     - `## 1. Getting Started`
       - `### 1.1 Title`
       - Metadata block (slug, category, info point key, screen path).
       - Body content as per blueprint.
     - Continue numbering consistently (1.1, 1.2, 2.1, 2.2, …).

3. Make sure the total result is:
   - Consistent in structure and naming.
   - Clean Markdown (no stray HTML unless necessary).
   - Copy-pasteable into docs/help/HELP_CENTER.md without changes.

4. Explicitly cover at least:
   - What is SilentID / how it works.
   - Passwordless login (Passkey, Apple, Google, Email OTP).
   - Security Center, login history, alerts.
   - TrustScore overview, components, improvement tips, history.
   - Profile Linking: Linked vs Verified, token in bio, screenshot verification, supported platforms, edit/remove, hide from passport.
   - Evidence: screenshots, email forwarding, metadata-only storage, supported sender domains.
   - Public Trust Passport: visibility modes (Public, Badge Only, Private), QR sharing, badge image generator, smart sharing.
   - Privacy & Data controls: what data is stored, how to delete account, how to hide profiles, consent for evidence.
   - Troubleshooting: all the most common issues reflected by the current implementation.


## PHASE 5 – WRITE THE HELP CENTER MARKDOWN FILE
1. Once the full Markdown content is ready and internally consistent, WRITE IT to the repo as a file, for example:

   - Path: `docs/help/HELP_CENTER.md`

   Use the appropriate filesystem / repo tool available in this environment (e.g. filesystem MCP). If there is an existing HELP_CENTER.md, overwrite it fully with this new complete version.

2. After writing the file:
   - Re-open it from disk.
   - Quickly sanity-check:
     - Headings render correctly.
     - No unfinished sections or obvious placeholders.
     - Slug and category metadata are present for each article.
     - The total article count is around 40–50.

3. If errors are found, fix them and re-write the file until it is clean.


## PHASE 6 – FINAL REPORT BACK TO USER
When you are done, respond in the chat with:

1. A short confirmation that `docs/help/HELP_CENTER.md` has been created/updated.
2. A high-level outline of:
   - All categories and article titles.
   - Approximate article count.
3. A few key examples:
   - One full example article (title, slug, summary, metadata, and a bit of body text).
   - One Info Point → Help Center mapping example.
4. Any recommendations for future extensions (e.g. Albanian version, admin-only FAQs, SEO web Help Center, etc.).

Do NOT dump the entire HELP_CENTER.md content into the chat (it will be too long and is already stored in the file). Only provide an overview + 1–2 full sample articles in the response.

---

## END OF PROMPT
