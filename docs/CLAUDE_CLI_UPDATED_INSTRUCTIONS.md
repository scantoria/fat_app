# FAT APP - Claude CLI Updated Instructions

**Version:** 2.0  
**Last Updated:** December 23, 2025  
**Status:** Ready for MVP Development

---

## Overview

This document provides Claude CLI with complete instructions for building the FAT APP MVP. All specifications, database schema, payment systems, and build priorities are now fully documented and ready for implementation.

---

## Available Documentation

### Core Documentation (Required Reading)

1. **PROJECT_PLAN.md** (Master Specification)
   - Single source of truth for all features
   - Business model and revenue strategy
   - Complete user roles and permissions
   - All animal species and classifications
   - Phase 1 (MVP) and Phase 2 (Provider Consortium) scope
   - Machine learning strategy
   - Security and compliance requirements

2. **DATABASE_SCHEMA.md** (Database Design)
   - Complete Firestore collection structure
   - All fields with types and descriptions
   - Subcollections and relationships
   - Required indexes
   - Security rules summary
   - Phase 2 collections (Provider Consortium)

3. **PAYMENT_PURCHASE_SYSTEMS.md** (Payment Architecture)
   - Hybrid IAP system (iOS/Android/Web)
   - Cross-platform licensing
   - Stripe integration for telemedicine
   - Pre-payment workflow
   - Provider onboarding via Stripe Connect
   - Complete payment flows and edge cases
   - Cloud Functions required
   - Security considerations

4. **MVP_BUILD_CHECKLIST.md** (Development Roadmap)
   - Week-by-week development plan (18 weeks)
   - Feature priorities (P0, P1, P2)
   - Testing requirements
   - Beta testing program with 5 testers
   - Launch readiness criteria

### Supporting Documentation

5. **FAT_APP_CLI_INSTRUCTIONS.md** (v1.0 - Original)
   - Development guidelines
   - Code organization
   - Naming conventions
   - Trunk-based development approach
   - Documentation protocols
   - GitHub repository: https://github.com/scantoria/fat_app

---

## Project Context

### Key Information

**Project Name:** FAT APP (Farm Animal Tracker Application)  
**Company:** ThisByte LLC  
**Developer:** Stephen  
**Firebase Project ID:** fat-app-c7ef0  
**GitHub Repository:** https://github.com/scantoria/fat_app  
**Domains:**
- thefatapp.com (Client app)
- thefatapi.com (Provider Consortium - Phase 2)

**Tech Stack:**
- Flutter 3.x (Web, iOS, Android)
- Firebase (Auth, Firestore, Storage, Functions)
- SQLite (Offline storage)
- Stripe (Payments)
- WebRTC (Video consultations - Phase 2)
- Google Speech-to-Text (Transcription - Phase 2)

**Business Model:**
- Phase 1: $49.99 one-time purchase (all platforms)
- Phase 2: 10% platform fee on telemedicine consultations

---

## Development Approach

### Phase 1: MVP Only (Current Focus)

**DO Build:**
- User authentication (email, Google, Apple)
- Farm and animal management
- Health records
- Breeding management
- Dashboard
- Offline sync
- Purchase system (hybrid IAP)
- Optional: Lactation tracking, service scheduling, weight tracking

**DO NOT Build (Phase 2):**
- Provider registration
- Provider credentialing
- Telemedicine consultations
- Video calling
- Provider queue system
- Anything related to thefatapi.com

**Important:** No "Request Consultation" button in Phase 1!

### Trunk-Based Development

- Single `main` branch
- Frequent small commits
- Feature flags for incomplete features
- Automated testing before merge
- See GitHub repository for current code

---

## MVP Build Priorities

### Week-by-Week Plan

Refer to **MVP_BUILD_CHECKLIST.md** for detailed week-by-week plan.

**Summary:**
- **Weeks 1-2:** Project setup, authentication
- **Weeks 3-4:** User and farm management
- **Weeks 5-6:** Animal management
- **Weeks 7-8:** Health records
- **Weeks 9:** Breeding management
- **Weeks 10:** Dashboard
- **Weeks 11-12:** Offline functionality
- **Weeks 13-14:** Purchase system
- **Weeks 15-16:** Optional features (lactation, services, weights)
- **Weeks 17-18:** Polish and bug fixes

### Must-Have (P0) Features

Cannot launch without these:

1. Authentication
2. User management with roles
3. Farm management
4. Animal profiles (all 5 species)
5. Health records
6. Breeding management
7. Dashboard
8. Offline sync
9. Photo upload
10. Purchase system

### Should-Have (P1) Features

Important but can add post-launch:

- Lactation tracking (critical for dairy farmers)
- Service scheduling
- Weight tracking
- Document management
- Search & filter
- Bloodline tracking
- Vaccination reminders

---

## Database Implementation

### Firestore Collections

Refer to **DATABASE_SCHEMA.md** for complete schema.

**Top-Level Collections:**
- `owners` - Owner accounts with license information
- `users` - User profiles and farm assignments
- `farms` - Farm information and settings

**Subcollections (farms/{farmId}):**
- `animals` - Animal profiles
  - `healthRecords` - Health and medical records
  - `breedingEvents` - Breeding and pregnancy tracking
  - `lactationRounds` - Lactation rounds
    - `productionRecords` - Daily milk production
  - `services` - Scheduled services
  - `weights` - Weight measurements
  - `photos` - Photo gallery
  - `documents` - Document attachments
- `invitations` - Pending team member invitations

**Phase 2 Collections (Do Not Implement Yet):**
- `providers`
- `consultations`
- `consultationPayments`

### Required Indexes

See `firestore.indexes.json` template in **DATABASE_SCHEMA.md**.

Critical indexes for MVP:
- Animals: `farmId + isDeleted + species`
- Animals: `farmId + pregnancyStatus + expectedDueDate`
- Health Records: `animalId + date`
- Breeding Events: `animalId + expectedDueDate`
- Services: `farmId + scheduledDate`

### Security Rules

**See SECURITY_RULES.md (to be created) for complete rules.**

Key principles:
- Multi-tenant isolation (users only see their owner's data)
- Role-based permissions strictly enforced
- Owner has full access
- Manager can manage assigned farms
- Lead can read/write in assigned farms
- Farm Hand is read-only

Example rule structure:
```
match /farms/{farmId} {
  allow read: if isOwnerOrAssignedUser(farmId);
  allow write: if isOwnerOrManagerOrLead(farmId);
  allow delete: if isOwner();
}
```

---

## Payment System Implementation

### Overview

Refer to **PAYMENT_PURCHASE_SYSTEMS.md** for complete specifications.

**Two Separate Systems:**
1. App purchase (one-time $49.99) - Implement in Phase 1
2. Telemedicine payments (Stripe Connect) - Phase 2 only

### Phase 1: App Purchase System

**iOS (Apple In-App Purchase):**
- Product ID: `fatapp_full_version`
- Non-consumable purchase
- Family Sharing enabled
- Receipt verification via Cloud Function
- License key generation
- Store receipt in user document

**Android (Google Play Billing):**
- Same product ID: `fatapp_full_version`
- Non-consumable purchase
- Receipt verification via Cloud Function
- License key generation
- Store purchase token in user document

**Web (Stripe Checkout):**
- Stripe product: "FAT APP Full Version"
- $49.99 one-time payment
- Webhook verification
- License key generation
- Store charge ID in user document

### License System

**License Key Format:**
```
FAT-[YEAR]-[SEG1]-[SEG2]-[SEG3]
Example: FAT-2025-A1B2-C3D4-E5F6
```

**Device Limits:**
- Maximum 3 active devices per license
- Track in `owners.license.activeDevices`
- Allow user to deactivate old devices

**Cross-Platform Unlock:**
- Automatic: Sign in with same email
- Manual: Enter license key
- Platform restore: iOS/Android only

### Free Tier Enforcement

**Free Tier Limits:**
- 5 animals maximum
- Basic record keeping only
- No reports
- No telemedicine (Phase 2)
- Watermarked exports

**Check at:**
- Animal creation (block if at limit)
- Feature access (prompt to upgrade)
- Export generation (add watermark)

### Cloud Functions Required

**Purchase Verification:**
```
verifyAppleReceipt(receiptData, userId)
verifyGooglePurchase(purchaseToken, productId, userId)
handleStripeWebhook(event)
```

**License Management:**
```
validateLicenseKey(licenseKey, userId)
checkLicenseStatus(userId)
deactivateDevice(userId, deviceId)
```

---

## Beta Testing Setup

### Beta Testers (5 People)

Refer to **MVP_BUILD_CHECKLIST.md** for complete beta testing plan.

1. Stephen (Owner/Developer)
2. Stephen's wife
3. Horse trainer friend
4. Cattle farmer friend
5. Veterinarian friend

### Beta Access Configuration

**Whitelist Beta Testers:**
```javascript
const BETA_TESTERS = [
  'stephen@thisbyte.com',
  '[wife email]',
  '[trainer email]',
  '[farmer email]',
  '[vet email]'
];
```

**Grant Full Access:**
- Bypass free tier (unlimited animals)
- No purchase required
- All features unlocked
- Beta tester flag in user document

**Beta Access Cloud Function:**
```javascript
functions.auth.user().onCreate(async (user) => {
  if (BETA_TESTERS.includes(user.email)) {
    await firestore.collection('owners').doc(user.uid).set({
      isBetaTester: true,
      license: {
        status: 'active',
        licenseKey: 'BETA-2025-XXXX-XXXX-XXXX',
        purchasePlatform: 'beta',
        purchaseDate: FieldValue.serverTimestamp(),
        animalLimit: 999999
      }
    }, { merge: true });
  }
});
```

### Beta Testing Platforms

**iOS (TestFlight):**
- Create beta group "MVP Beta Testers"
- Add 5 tester emails
- Upload beta builds
- Testers install via TestFlight app

**Android (Google Play Beta):**
- Create closed testing track "Beta Testers"
- Add 5 tester emails
- Upload beta APK/AAB
- Testers opt-in and install

**Web (Beta Subdomain):**
- Deploy to beta.thefatapp.com
- Share URL with testers
- Whitelist emails for free access

---

## Offline Functionality

### Critical for Rural Users

Offline capability is a **core differentiator** and must work flawlessly.

**Requirements:**
- Full read access offline (all animals and records)
- Create/edit animals offline
- Add health records offline
- Photo upload queue
- Sync when connection restored
- Conflict resolution
- Visual sync indicators

**Implementation:**
- SQLite for local storage
- Sync queue for pending changes
- Connectivity monitoring
- Background sync
- Retry logic for failures
- Last-write-wins conflict resolution (with user prompt)

**Testing Priority:**
- Test extensively in airplane mode
- Test with large offline change sets
- Test sync after extended offline period
- Test conflict scenarios

---

## Code Organization

### Flutter Project Structure

```
lib/
├── main.dart
├── core/
│   ├── constants/
│   ├── theme/
│   ├── utils/
│   └── services/
│       ├── auth_service.dart
│       ├── database_service.dart
│       ├── storage_service.dart
│       ├── purchase_service.dart
│       └── sync_service.dart
├── features/
│   ├── auth/
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── auth_provider.dart
│   ├── farms/
│   ├── animals/
│   ├── health_records/
│   ├── breeding/
│   ├── dashboard/
│   └── users/
├── models/
│   ├── owner.dart
│   ├── user.dart
│   ├── farm.dart
│   ├── animal.dart
│   ├── health_record.dart
│   └── breeding_event.dart
├── providers/ (state management)
│   ├── auth_provider.dart
│   ├── farm_provider.dart
│   └── animal_provider.dart
└── widgets/ (shared components)
    ├── animal_card.dart
    ├── farm_selector.dart
    └── loading_indicator.dart
```

### Naming Conventions

- **Files:** `snake_case.dart`
- **Classes:** `PascalCase`
- **Variables/Functions:** `camelCase`
- **Constants:** `SCREAMING_SNAKE_CASE`
- **Private members:** `_leadingUnderscore`

### State Management

Use **Provider** package for state management:
- Simple and Flutter-recommended
- Easy to test
- Good performance
- Familiar to most developers

---

## Testing Requirements

### Unit Tests

Test all business logic:
- Data models (serialization/deserialization)
- Service layer functions
- Utility functions
- Validation logic

**Target:** 80%+ code coverage

### Widget Tests

Test critical UI components:
- Form validation
- User interactions
- State updates
- Navigation

### Integration Tests

Test complete user flows:
- Registration and login
- Creating farm and animals
- Adding health records
- Offline sync
- Purchase flow

### Security Rules Tests

Test Firestore security rules:
- Multi-tenant isolation
- Role-based permissions
- Owner-only operations
- Cross-owner access denial

**Use Firebase Emulator for rules testing.**

---

## Documentation Updates

### When to Update Docs

**Update PROJECT_PLAN.md when:**
- Feature requirements change
- New features added
- Business model changes
- User roles modified

**Update DATABASE_SCHEMA.md when:**
- Collections added/removed
- Fields added/removed/changed
- Indexes changed
- Security rules changed

**Update MVP_BUILD_CHECKLIST.md when:**
- Features completed (check off)
- Timeline adjusted
- Priorities changed
- Beta testing progress

### How to Update

1. Make changes to relevant document(s)
2. Update "Last Updated" date
3. Add entry to version history (if applicable)
4. Commit changes with descriptive message
5. Push to GitHub repository

---

## Critical Reminders

### Phase Separation

**Phase 1 (Current):**
- Farm management only
- No provider features
- No consultation features
- No telemedicine anything

**Phase 2 (Future):**
- Provider consortium
- Video consultations
- Payment processing for consultations
- Separate web application (thefatapi.com)

**DO NOT mix phases!** Build Phase 1 completely first.

### Security First

- Never commit API keys or secrets
- Use environment variables for sensitive config
- Firestore security rules tested thoroughly
- Multi-tenant isolation strictly enforced
- Role-based permissions respected everywhere

### Offline First

- Assume users have no internet connection
- All core features work offline
- Sync is background process, not blocking
- Clear indicators of sync status
- Graceful error handling for sync failures

### User Experience

- Simple, intuitive interfaces
- Consistent design language
- Fast performance (no jank)
- Clear error messages
- Helpful empty states
- Confirmation for destructive actions

### Rural Focus

- Offline capability critical
- Simple language (no jargon)
- Large touch targets (for use in barn/field)
- Works in bright sunlight (contrast)
- Works with gloves (if possible)

---

## Getting Started (Claude CLI)

### Step 1: Read All Documentation

Before writing any code, read completely:
1. PROJECT_PLAN.md
2. DATABASE_SCHEMA.md
3. PAYMENT_PURCHASE_SYSTEMS.md
4. MVP_BUILD_CHECKLIST.md

### Step 2: Set Up Development Environment

1. Clone repository: `git clone https://github.com/scantoria/fat_app.git`
2. Install Flutter dependencies: `flutter pub get`
3. Configure Firebase: `flutterfire configure --project=fat-app-c7ef0`
4. Verify setup: `flutter doctor -v`
5. Run on web: `flutter run -d chrome`

### Step 3: Follow MVP Build Checklist

Work through **MVP_BUILD_CHECKLIST.md** systematically:
- Start with Week 1-2: Project setup and authentication
- Complete each phase before moving to next
- Check off completed items
- Test thoroughly at each phase

### Step 4: Implement Beta Testing

Once MVP features complete:
1. Set up TestFlight and Play Console
2. Configure beta tester whitelist
3. Deploy beta builds
4. Invite 5 beta testers
5. Collect feedback weekly
6. Iterate based on feedback

### Step 5: Prepare for Launch

Follow launch readiness checklist in **MVP_BUILD_CHECKLIST.md**:
- Complete all P0 features
- Fix all critical bugs
- Pass security audit
- Test cross-platform
- Prepare app store listings
- Set up support infrastructure

---

## Support & Questions

### Documentation Questions

If documentation is unclear or contradictory:
1. Refer to PROJECT_PLAN.md as single source of truth
2. Check if other docs are outdated
3. Flag inconsistency for Stephen to resolve

### Technical Questions

For technical implementation questions:
1. Check Flutter documentation
2. Check Firebase documentation
3. Review similar implementations in existing code
4. Ask Stephen if still unclear

### Business Questions

For business logic or requirements questions:
1. Refer to PROJECT_PLAN.md
2. If not covered, ask Stephen
3. Document decision for future reference

---

## Success Criteria

### MVP Success

**Technical:**
- All P0 features working on iOS, Android, Web
- Zero critical bugs
- Offline sync reliable
- Purchase system functional
- <1% crash rate

**User:**
- All 5 beta testers actively using
- Positive feedback from beta testers
- 4.5+ star rating potential
- Would recommend to others

**Business:**
- Beta testers become paying customers
- Positive word-of-mouth
- Ready for public launch
- Foundation for Phase 2

---

## Next Steps After MVP

### Phase 2 Planning

After successful MVP launch (1-2 months):
1. Gather user feedback
2. Iterate on MVP features
3. Fix post-launch bugs
4. Monitor usage patterns
5. Validate provider marketplace demand
6. Begin Phase 2 development

**Phase 2 will introduce:**
- Provider registration and credentialing
- Telemedicine consultations
- Video calling (WebRTC)
- Stripe Connect for payments
- Separate provider web app (thefatapi.com)

**Phase 2 documentation already complete!** Refer to:
- PROJECT_PLAN.md (Provider Consortium section)
- DATABASE_SCHEMA.md (Phase 2 collections)
- PAYMENT_PURCHASE_SYSTEMS.md (Telemedicine payments)

---

## Conclusion

You now have everything needed to build FAT APP MVP:

✅ Complete specifications (PROJECT_PLAN.md)  
✅ Database schema (DATABASE_SCHEMA.md)  
✅ Payment systems (PAYMENT_PURCHASE_SYSTEMS.md)  
✅ Development roadmap (MVP_BUILD_CHECKLIST.md)  
✅ Beta testing plan (5 testers ready)  
✅ Phase 2 design (ready when MVP succeeds)

**Start with Phase 1A (Week 1-2) in MVP_BUILD_CHECKLIST.md and work systematically through the plan.**

**Remember:** Build Phase 1 completely first. No Phase 2 features yet!

Good luck building! 🚀

---

**END OF CLAUDE CLI UPDATED INSTRUCTIONS**

All documentation is complete and ready. Claude CLI can now begin MVP development with clear guidance, priorities, and specifications.
