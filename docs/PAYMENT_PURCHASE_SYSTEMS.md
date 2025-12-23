# FAT APP - Payment & Purchase Systems Architecture

**Document Version:** 1.0  
**Last Updated:** December 20, 2025  
**Status:** Specification Complete - Ready for Implementation

---

## Table of Contents

1. [Overview](#overview)
2. [App Purchase System (Hybrid IAP)](#app-purchase-system-hybrid-iap)
3. [Telemedicine Payment System (Stripe)](#telemedicine-payment-system-stripe)
4. [Database Schema Additions](#database-schema-additions)
5. [Cloud Functions Required](#cloud-functions-required)
6. [Security Considerations](#security-considerations)
7. [Implementation Checklist](#implementation-checklist)

---

## Overview

FAT APP has **two separate payment systems**:

1. **App Purchase System** - One-time $49.99 purchase to unlock full app features
2. **Telemedicine Payment System** - Pre-payment for provider consultations with platform fees

These systems are completely independent but share the Firebase backend.

### Revenue Model Summary

**App Purchases:**
- iOS: $49.99 (net $34.99 first year, $42.49 after)
- Android: $49.99 (net $42.49)
- Web: $49.99 (net $48.24)

**Telemedicine Platform Fees:**
- 10% platform fee on all consultations
- Payments processed via Stripe
- Pre-payment model (funds held in escrow)

---

## App Purchase System (Hybrid IAP)

### Pricing Strategy

**Confirmed Pricing:** $49.99 across all platforms
- Consistent branding
- Platform fee differences absorbed by company
- No promotional pricing at launch
- Future seasonal sales (Black Friday, etc.)

### Purchase Implementation by Platform

#### iOS (Apple In-App Purchase)

**Product Configuration:**
- Product ID: `fatapp_full_version`
- Type: Non-consumable
- Price: $49.99 (Tier XX)
- Family Sharing: **Enabled**

**Purchase Flow:**
```
App Launch
    ↓
Check Firebase for license status
    ↓
If unlocked → Full access
If locked → Show purchase screen
    ↓
User taps "Purchase $49.99"
    ↓
Apple IAP triggered (Face ID/Touch ID)
    ↓
Apple processes payment (30% fee year 1, 15% after)
    ↓
Receipt received
    ↓
Flutter sends receipt to Cloud Function
    ↓
Cloud Function:
    - Verifies with Apple servers
    - Generates license key
    - Updates Firebase user document
    - Sends confirmation email
    ↓
App unlocked + email sent with license key
```

**Implementation Notes:**
- Use `in_app_purchase` Flutter package
- Verify receipts server-side (never trust client)
- Store Apple receipt in Firebase for restore
- Handle receipt expiration edge cases

#### Android (Google Play Billing)

**Product Configuration:**
- Product ID: `fatapp_full_version`
- Type: Non-consumable
- Price: $49.99
- Google Play fee: 15% (for revenue <$1M/year)

**Purchase Flow:**
```
Same as iOS but:
    - Google Play Billing instead of Apple IAP
    - Verify with Google Play servers
    - Store purchase token for restore
```

**Implementation Notes:**
- Use same `in_app_purchase` Flutter package
- Google Play Developer API for verification
- Handle subscription status edge cases
- Test with Google Play test accounts

#### Web (Stripe Checkout)

**Product Configuration:**
- Stripe Product: "FAT APP Full Version"
- Price: $49.99 one-time
- Stripe fee: 2.9% + $0.30

**Purchase Flow:**
```
User visits app.fatapp.com
    ↓
Create account / Sign in
    ↓
"Unlock Full Version" button
    ↓
Stripe Checkout modal opens
    ↓
User pays (Card/Google Pay/Apple Pay)
    ↓
Stripe processes payment
    ↓
Webhook fires to Cloud Function
    ↓
Cloud Function:
    - Generates license key
    - Updates Firebase
    - Sends confirmation email
    ↓
Web app unlocked + email sent
```

**Implementation Notes:**
- Stripe Checkout Session API
- Webhook signature verification required
- Handle failed payments gracefully
- Provide clear error messages

### Cross-Platform License System

**License Key Format:**
```
FAT-[YEAR]-[SEG1]-[SEG2]-[SEG3]

Example: FAT-2025-A1B2-C3D4-E5F6
```

**Generation Rules:**
- Alphanumeric only
- Exclude confusing characters (0, O, I, 1)
- Character set: `23456789ABCDEFGHJKLMNPQRSTUVWXYZ`
- 4 characters per segment
- Total length: 24 characters with hyphens

**Cross-Platform Unlock Methods:**

1. **Automatic (Recommended)**
   - User signs in with same email
   - App queries Firebase for existing license
   - Auto-unlocks if found

2. **License Key Entry**
   - User selects "I Already Purchased"
   - Enters license key
   - App validates with Firebase
   - Links to account and unlocks

3. **Platform Restore**
   - iOS: Queries Apple for purchase
   - Android: Queries Google Play
   - Web: N/A (uses Method 1)

### Device Activation Tracking

**Device Limits:**
- Maximum 3 active devices per license
- Prevents excessive sharing
- User can deactivate old devices

**Device Tracking Schema:**
```javascript
activeDevices: [
  {
    deviceId: "unique_device_id",
    platform: "ios|android|web",
    activatedAt: timestamp,
    lastSeenAt: timestamp,
    deviceInfo: {
      model: "iPhone 14 Pro",
      osVersion: "iOS 17.1"
    }
  }
]
```

### Free Tier Limitations

**Free users get:**
- Up to 5 animals
- Basic record keeping
- View-only dashboard
- No reports/analytics
- No telemedicine access
- Watermarked exports

**Paid users get:**
- Unlimited animals
- Full record keeping
- Advanced reports and analytics
- Telemedicine access
- Clean exports
- Multi-user farm management

**Watermark Format:**
```
Diagonal "TRIAL VERSION" across document
Footer: "Generated with FAT APP Free - Unlock full version at fatapp.com"
```

### Family Sharing (iOS Only)

**Configuration:**
- **Enabled** despite reservations
- 1 purchase → up to 6 family members
- Good for family farm operations
- Builds goodwill in target market

**Implementation:**
- Apple handles automatically
- No additional development needed
- May reduce per-family revenue
- Strategic marketing advantage

### Refund Policy

**iOS/Android:**
- Handled by Apple/Google
- Platform decides refunds
- Webhook notifies of refunds
- License auto-revoked

**Web (Stripe):**
- **14-day money-back guarantee**
- Customer emails support
- You decide on refund
- Process through Stripe dashboard
- License auto-revoked

### Confirmation Email Template

```
Subject: Welcome to FAT APP - Your Purchase Confirmation

Hi [Name],

Thank you for purchasing FAT APP! Your farm management platform is now fully unlocked.

PURCHASE DETAILS:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Product: FAT APP - Full Version
Amount: $49.99
Date: [Date]
Transaction ID: [ID]

YOUR LICENSE KEY:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
FAT-2025-A1B2-C3D4-E5F6

Use this license key to unlock FAT APP on other devices:
1. Open FAT APP on your other device
2. Sign in with this email ([email])
3. The app will automatically unlock

OR manually enter your license key:
1. Tap "I Already Purchased"
2. Enter: FAT-2025-A1B2-C3D4-E5F6

WHAT'S INCLUDED:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ Unlimited animal tracking
✓ Advanced reports and analytics
✓ Telemedicine consultations
✓ Multi-user farm management
✓ Offline access
✓ Clean exports

GETTING STARTED:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Visit our help center: help.fatapp.com
Watch tutorials: fatapp.com/tutorials
Contact support: support@fatapp.com

Thank you for choosing FAT APP!

- The FAT APP Team
```

---

## Telemedicine Payment System (Stripe)

### Payment Processor: Stripe

**Why Stripe:**
- Industry-standard reliability
- Native support for fund holding (escrow)
- Easy platform fee splits (Stripe Connect)
- Supports all payment methods (card, Google Pay, Apple Pay)
- Built-in invoice/receipt generation
- PCI compliance handled
- Excellent Flutter/web SDKs

### Pre-Payment Model

**Payment Flow:**
```
Client Books Consultation
    ↓
Selects payment method (Card/Google Pay/Apple Pay)
    ↓
Payment processed IMMEDIATELY
    ↓
Funds held in escrow by Stripe
    ↓
Consultation completed
    ↓
Provider marks complete
    ↓
Stripe automatically splits:
    - Platform fee (10%) → ThisByte account
    - Remaining (90%) → Provider account
    ↓
Receipts generated for both parties
```

### Payment Methods

**MVP Payment Methods:**
1. Manual credit card entry
2. Google Pay
3. Apple Pay

**Future Payment Methods:**
- Venmo
- PayPal
- ACH/Bank Transfer (for larger transactions)

### Provider Onboarding (Stripe Connect)

**Onboarding Flow:**
```
Provider completes credentialing
    ↓
Provider initiates Stripe Connect onboarding
    ↓
Stripe collects:
    - Bank account information
    - Tax ID (EIN or SSN)
    - Identity verification
    - Business information
    ↓
Provider account status:
    Pending → Verified → Active
    ↓
Provider can now receive bookings
```

**Stripe Connect Account Types:**
- Use **Express** accounts for providers
- Faster onboarding
- Stripe handles compliance
- Automatic payouts available

### Consultation Booking & Payment

**Booking Flow:**
```
1. Client selects provider
2. Selects service type
3. Reviews pricing:
   - Consultation Fee: $XX.XX
   - Platform Fee (10%): $X.XX
   - Total: $XX.XX
4. Chooses payment method
5. Payment processed
6. Booking confirmed
7. Both parties notified
```

**Payment Breakdown Example:**
```
Consultation Fee: $100.00
Platform Fee (10%): $10.00
Total Client Pays: $110.00

After completion:
- Provider receives: $90.00 (after Stripe fees)
- Platform receives: $10.00 (minus Stripe fees)
- Stripe fees: ~$3.50 total (2.9% + $0.30)
```

### Consultation Completion & Payout

**Completion Flow:**
```
Consultation delivered
    ↓
Provider marks "Complete" in app
    ↓
Client receives feedback request
    ↓
Platform fee deducted automatically
    ↓
Provider payment released to Stripe account
    ↓
Final receipts issued
```

**Payout Schedule Options:**
- **Instant**: Immediate (1% fee, optional)
- **Daily**: Automatic daily batch (standard)
- **Weekly**: Weekly batch (provider preference)

### Edge Case Handling

**Client No-Show:**
```
15-minute grace period
    ↓
Provider marks "Client No-Show"
    ↓
Full payment released to provider
    ↓
Platform fee still applies
    ↓
Client charged cancellation fee
```

**Provider No-Show:**
```
Client waits 15 minutes
    ↓
Marks "Provider No-Show"
    ↓
Full refund processed automatically
    ↓
Provider account flagged/penalized
    ↓
Platform fee waived
```

**Cancellation Policy:**
- **24+ hours notice**: Full refund, no platform fee
- **2-24 hours notice**: 50% refund, platform keeps fee
- **<2 hours notice**: No refund, full payment to provider
- **Provider cancels**: Full refund always, provider penalized

**Dispute Resolution:**
```
Either party flags transaction (48-hour window)
    ↓
Payment held in escrow
    ↓
Platform reviews:
    - Video recording
    - Transcription
    - Chat logs
    ↓
Decision within 5 business days
    ↓
Funds released accordingly
```

### Invoice & Receipt Generation

**Client Receipt:**
```
FAT APP - Farm Animal Tracker
Telemedicine Consultation Receipt

Date: [Date/Time]
Consultation ID: [Unique ID]

Provider: Dr. [Name], [Credentials]
Service: [Type] - [Duration]
Animal: [Species] - [Name/ID]

Consultation Fee:        $XXX.XX
Platform Fee:            $XX.XX
--------------------------------
Total Paid:              $XXX.XX

Payment Method: [Card/Google/Apple Pay - last 4 digits]
Transaction ID: [Stripe ID]

Thank you for using FAT APP!
```

**Provider Invoice:**
```
FAT APP - Provider Payment Invoice

Date: [Date/Time]
Consultation ID: [Unique ID]

Client: [Farm Name] - [Client ID]
Service: [Type] - [Duration]
Animal: [Species]

Consultation Fee:        $XXX.XX
Platform Fee (10%):     -$XX.XX
--------------------------------
Net Payment:             $XXX.XX

Payout Method: [Bank - last 4 digits]
Expected Payout: [Date]
Transaction ID: [Stripe ID]
```

### Tax Documentation

**For Providers (Annual):**
- 1099-K form if earnings >$600/year
- Detailed transaction history (CSV export)
- Platform fee summary for expense deduction

**For Platform (ThisByte):**
- Revenue tracking for all platform fees
- Stripe processing fees
- Refund/dispute tracking

### Accounting Features

**Client Dashboard (FAT APP):**
- Transaction history (all consultations)
- Downloadable receipts (PDF)
- Annual expense report for taxes
- Filter by date, provider, service type

**Provider Dashboard (Consortium App):**
- Earnings summary (daily/weekly/monthly/annual)
- Transaction details with platform fee breakdown
- Pending vs completed payouts
- Downloadable invoices/receipts (PDF)
- Tax documents (1099-K)
- Client payment status per consultation

**Platform Admin Dashboard:**
- Total revenue and platform fees collected
- Transaction volume metrics
- Failed payment tracking
- Dispute resolution queue
- Provider payout reconciliation
- Financial reporting

---

## Database Schema Additions

### User License Collection

```javascript
// users/{userId}
{
  // ... existing user fields ...
  
  license: {
    status: "active|expired|refunded|trial",
    licenseKey: "FAT-2025-A1B2-C3D4-E5F6",
    purchaseDate: timestamp,
    purchasePlatform: "ios|android|web",
    transactionId: "platform_specific_id",
    
    // Cross-platform tracking
    unlockedPlatforms: ["ios", "web"],
    
    // Receipt backup
    platformReceipts: {
      ios: "base64_receipt_data",
      android: "purchase_token",
      web: "stripe_charge_id"
    },
    
    // Device tracking
    activeDevices: [
      {
        deviceId: "unique_id",
        platform: "ios|android|web",
        activatedAt: timestamp,
        lastSeenAt: timestamp,
        deviceInfo: {
          model: "iPhone 14 Pro",
          osVersion: "iOS 17.1"
        }
      }
    ],
    maxDevices: 3,
    
    // Free tier tracking
    animalCount: 0,
    animalLimit: 5
  }
}
```

### Consultation Payments Collection

```javascript
// consultationPayments/{paymentId}
{
  paymentId: "auto_generated",
  consultationId: "ref_to_consultation",
  clientId: "ref_to_user",
  providerId: "ref_to_provider",
  
  // Payment details
  consultationFee: 100.00,
  platformFee: 10.00,
  totalAmount: 110.00,
  
  // Stripe details
  stripeChargeId: "ch_xxxxx",
  stripeTransferId: "tr_xxxxx",
  paymentMethod: "card|google_pay|apple_pay",
  paymentMethodDetails: {
    type: "card",
    last4: "4242",
    brand: "visa"
  },
  
  // Status tracking
  status: "pending|completed|refunded|disputed",
  paidAt: timestamp,
  completedAt: timestamp,
  refundedAt: timestamp,
  
  // Payout tracking
  providerPayoutAmount: 90.00,
  providerPayoutStatus: "pending|paid|failed",
  providerPayoutDate: timestamp,
  providerPayoutMethod: "instant|daily|weekly",
  
  // Receipts
  clientReceiptUrl: "url_to_pdf",
  providerInvoiceUrl: "url_to_pdf",
  
  // Dispute handling
  disputedAt: timestamp,
  disputeReason: "string",
  disputeResolvedAt: timestamp,
  disputeResolution: "refund_client|pay_provider|split",
  
  createdAt: timestamp,
  updatedAt: timestamp
}
```

### Provider Stripe Accounts Collection

```javascript
// providers/{providerId}/stripeAccount
{
  stripeAccountId: "acct_xxxxx",
  accountStatus: "pending|verified|active|restricted",
  
  onboardingComplete: true,
  
  bankAccount: {
    last4: "6789",
    bankName: "Chase Bank",
    routingNumber: "encrypted"
  },
  
  taxInfo: {
    taxId: "encrypted_ein_or_ssn",
    taxIdVerified: true,
    form1099Required: true
  },
  
  payoutPreference: "instant|daily|weekly",
  
  // Earnings tracking
  totalEarnings: 5000.00,
  pendingPayouts: 250.00,
  completedPayouts: 4750.00,
  
  createdAt: timestamp,
  updatedAt: timestamp
}
```

### Transaction Audit Log Collection

```javascript
// transactionAuditLog/{logId}
{
  logId: "auto_generated",
  type: "purchase|consultation_payment|refund|payout",
  
  // Reference IDs
  userId: "ref_to_user",
  consultationId: "ref_if_applicable",
  paymentId: "ref_if_applicable",
  
  // Financial details
  amount: 49.99,
  platformFee: 0.00,
  stripeFee: 1.75,
  netAmount: 48.24,
  
  // Platform tracking
  platform: "ios|android|web",
  transactionId: "platform_specific_id",
  
  // Status
  status: "success|failed|refunded",
  failureReason: "string_if_failed",
  
  metadata: {
    // Additional context
  },
  
  timestamp: timestamp
}
```

---

## Cloud Functions Required

### Purchase Verification Functions

#### verifyAppleReceipt
```javascript
/**
 * Verifies Apple App Store receipt
 * @param {string} receiptData - Base64 encoded receipt
 * @param {string} userId - User ID
 * @returns {Promise<Object>} License details
 */
async function verifyAppleReceipt(receiptData, userId) {
  // 1. Send to Apple verification server
  // 2. Check response status
  // 3. Verify transaction is unique (not already used)
  // 4. Generate license key
  // 5. Update user document
  // 6. Send confirmation email
  // 7. Log transaction
}
```

#### verifyGooglePurchase
```javascript
/**
 * Verifies Google Play purchase
 * @param {string} purchaseToken - Purchase token
 * @param {string} productId - Product ID
 * @param {string} userId - User ID
 * @returns {Promise<Object>} License details
 */
async function verifyGooglePurchase(purchaseToken, productId, userId) {
  // 1. Verify with Google Play Developer API
  // 2. Check purchase state
  // 3. Verify transaction is unique
  // 4. Generate license key
  // 5. Update user document
  // 6. Send confirmation email
  // 7. Log transaction
}
```

#### handleStripeWebhook
```javascript
/**
 * Handles Stripe webhook events
 * @param {Object} event - Stripe webhook event
 * @returns {Promise<void>}
 */
async function handleStripeWebhook(event) {
  // Verify webhook signature
  // Handle event types:
  //   - checkout.session.completed (app purchase)
  //   - charge.succeeded (consultation payment)
  //   - charge.refunded (refund processed)
  //   - payout.paid (provider payout completed)
  // Update relevant documents
  // Send notifications
  // Log events
}
```

### License Management Functions

#### validateLicenseKey
```javascript
/**
 * Validates and activates a license key
 * @param {string} licenseKey - License key to validate
 * @param {string} userId - User ID attempting activation
 * @returns {Promise<Object>} Validation result
 */
async function validateLicenseKey(licenseKey, userId) {
  // 1. Lookup license key in database
  // 2. Verify it's not already fully activated
  // 3. Check device limit
  // 4. Activate for user
  // 5. Update user document
  // 6. Return success
}
```

#### checkLicenseStatus
```javascript
/**
 * Checks license status on app launch
 * @param {string} userId - User ID
 * @returns {Promise<Object>} License status
 */
async function checkLicenseStatus(userId) {
  // 1. Get user document
  // 2. Check license.status
  // 3. Verify not expired/refunded
  // 4. Update lastSeenAt for device
  // 5. Return status
}
```

#### deactivateDevice
```javascript
/**
 * Deactivates a device from a license
 * @param {string} userId - User ID
 * @param {string} deviceId - Device to deactivate
 * @returns {Promise<void>}
 */
async function deactivateDevice(userId, deviceId) {
  // 1. Get user document
  // 2. Remove device from activeDevices
  // 3. Update document
  // 4. Send notification to user
}
```

### Consultation Payment Functions

#### processConsultationPayment
```javascript
/**
 * Processes payment for consultation booking
 * @param {string} consultationId - Consultation ID
 * @param {string} paymentMethodId - Stripe payment method
 * @returns {Promise<Object>} Payment result
 */
async function processConsultationPayment(consultationId, paymentMethodId) {
  // 1. Get consultation details
  // 2. Calculate total (fee + platform fee)
  // 3. Create Stripe payment intent
  // 4. Hold funds in escrow
  // 5. Create payment record
  // 6. Update consultation status
  // 7. Send confirmation to both parties
  // 8. Generate receipts
}
```

#### completeConsultationPayment
```javascript
/**
 * Releases payment after consultation completion
 * @param {string} consultationId - Consultation ID
 * @returns {Promise<void>}
 */
async function completeConsultationPayment(consultationId) {
  // 1. Get consultation and payment records
  // 2. Transfer funds to provider (minus platform fee)
  // 3. Update payment status
  // 4. Update provider earnings
  // 5. Generate final invoices/receipts
  // 6. Send notifications
  // 7. Update analytics
}
```

#### processRefund
```javascript
/**
 * Processes refund for cancelled/disputed consultation
 * @param {string} paymentId - Payment ID
 * @param {number} refundAmount - Amount to refund
 * @param {string} reason - Refund reason
 * @returns {Promise<void>}
 */
async function processRefund(paymentId, refundAmount, reason) {
  // 1. Get payment record
  // 2. Create Stripe refund
  // 3. Update payment status
  // 4. Update provider earnings if needed
  // 5. Send notification to client
  // 6. Log refund
}
```

### Tax & Reporting Functions

#### generate1099K
```javascript
/**
 * Generates annual 1099-K for providers
 * @param {string} providerId - Provider ID
 * @param {number} year - Tax year
 * @returns {Promise<Object>} 1099-K data
 */
async function generate1099K(providerId, year) {
  // 1. Query all payments for provider in year
  // 2. Calculate total earnings
  // 3. Get provider tax info from Stripe
  // 4. Generate 1099-K form data
  // 5. Store in provider documents
  // 6. Send notification
}
```

#### generateAnnualReport
```javascript
/**
 * Generates annual expense report for clients
 * @param {string} userId - User ID
 * @param {number} year - Tax year
 * @returns {Promise<Object>} Annual report data
 */
async function generateAnnualReport(userId, year) {
  // 1. Query all consultations for user in year
  // 2. Sum total expenses
  // 3. Categorize by service type
  // 4. Generate PDF report
  // 5. Store in user documents
  // 6. Send notification
}
```

---

## Security Considerations

### Purchase Fraud Prevention

1. **Receipt Validation**
   - Always verify receipts server-side
   - Never trust client-reported purchases
   - Check for duplicate transaction IDs
   - Validate receipt signatures

2. **License Key Protection**
   - Generate cryptographically secure keys
   - Store hashed versions in database
   - Rate-limit validation attempts
   - Monitor for suspicious patterns

3. **Device Limit Enforcement**
   - Track unique device IDs
   - Enforce maximum device limit
   - Allow manual deactivation
   - Alert on excessive activation attempts

### Payment Security

1. **PCI Compliance**
   - Never store credit card numbers
   - Use Stripe.js for card collection
   - Tokenize all payment methods
   - Follow PCI-DSS guidelines

2. **Webhook Verification**
   - Always verify Stripe signatures
   - Use HTTPS endpoints only
   - Implement idempotency keys
   - Log all webhook events

3. **Fund Protection**
   - Use Stripe Connect for escrow
   - Implement dispute resolution process
   - Set appropriate payout delays
   - Monitor for fraudulent patterns

### Data Privacy

1. **Financial Data**
   - Encrypt sensitive payment data
   - Minimize data retention
   - Comply with financial regulations
   - Implement data access controls

2. **Provider Information**
   - Encrypt tax IDs and SSNs
   - Restrict access to financial data
   - Audit all data access
   - Implement role-based permissions

---

## Implementation Checklist

### Phase 1: App Purchase System

**iOS Setup:**
- [ ] Create App Store Connect product
- [ ] Configure in-app purchase
- [ ] Set up shared secret for receipt validation
- [ ] Enable Family Sharing
- [ ] Test with sandbox accounts
- [ ] Implement purchase flow in Flutter
- [ ] Implement restore purchase
- [ ] Create receipt verification Cloud Function
- [ ] Set up email notifications
- [ ] Test refund handling

**Android Setup:**
- [ ] Create Google Play Console product
- [ ] Configure in-app purchase
- [ ] Set up service account for API access
- [ ] Test with test accounts
- [ ] Implement purchase flow in Flutter
- [ ] Implement restore purchase
- [ ] Create purchase verification Cloud Function
- [ ] Set up email notifications
- [ ] Test refund handling

**Web Setup:**
- [ ] Create Stripe account
- [ ] Create Stripe product
- [ ] Set up webhook endpoint
- [ ] Configure success/cancel URLs
- [ ] Implement Stripe Checkout
- [ ] Test payment flow
- [ ] Create webhook handler Cloud Function
- [ ] Implement refund process
- [ ] Set up email notifications

**License System:**
- [ ] Implement license key generation
- [ ] Create license validation Cloud Function
- [ ] Implement cross-platform unlock
- [ ] Implement device tracking
- [ ] Test device limit enforcement
- [ ] Create deactivation UI
- [ ] Test license key entry flow

**Free Tier:**
- [ ] Implement animal limit (5)
- [ ] Implement feature restrictions
- [ ] Create watermark for exports
- [ ] Add upgrade prompts
- [ ] Test upgrade flow

### Phase 2: Telemedicine Payment System

**Stripe Connect Setup:**
- [ ] Enable Stripe Connect in account
- [ ] Create Express account onboarding flow
- [ ] Implement account verification
- [ ] Test payout configuration
- [ ] Implement bank account linking
- [ ] Test tax information collection

**Payment Integration:**
- [ ] Implement consultation booking flow
- [ ] Create payment method collection UI
- [ ] Implement Google Pay integration
- [ ] Implement Apple Pay integration
- [ ] Test payment processing
- [ ] Implement payment confirmation
- [ ] Create receipt generation

**Payout System:**
- [ ] Implement automatic splits (90/10)
- [ ] Configure payout schedules
- [ ] Test instant payouts
- [ ] Test daily/weekly batches
- [ ] Implement payout notifications

**Edge Cases:**
- [ ] Implement no-show handling (client)
- [ ] Implement no-show handling (provider)
- [ ] Create cancellation policy logic
- [ ] Implement dispute resolution workflow
- [ ] Test refund processing

**Accounting:**
- [ ] Create client transaction history
- [ ] Create provider earnings dashboard
- [ ] Implement receipt downloads
- [ ] Create annual expense reports
- [ ] Implement 1099-K generation
- [ ] Create platform admin dashboard

### Testing & Launch

**Purchase System Testing:**
- [ ] Test iOS purchase (sandbox)
- [ ] Test Android purchase (test)
- [ ] Test web purchase (Stripe test mode)
- [ ] Test cross-platform unlock
- [ ] Test license key entry
- [ ] Test device limit
- [ ] Test family sharing (iOS)
- [ ] Test refunds (all platforms)
- [ ] Load test Cloud Functions
- [ ] Security audit

**Payment System Testing:**
- [ ] Test provider onboarding
- [ ] Test consultation booking
- [ ] Test payment processing
- [ ] Test consultation completion
- [ ] Test no-show scenarios
- [ ] Test cancellations
- [ ] Test refunds
- [ ] Test dispute resolution
- [ ] Test payout processing
- [ ] Load test payment system
- [ ] Security audit

**Documentation:**
- [ ] User guide for purchases
- [ ] User guide for consultations
- [ ] Provider onboarding guide
- [ ] Refund policy documentation
- [ ] FAQ for common issues
- [ ] Admin procedures
- [ ] Support team training

**Monitoring:**
- [ ] Set up purchase analytics
- [ ] Set up payment analytics
- [ ] Configure error alerting
- [ ] Set up fraud detection
- [ ] Configure uptime monitoring
- [ ] Set up revenue dashboards

---

## Notes for Future Enhancement

### Potential Features

1. **Subscription Model** (Alternative to one-time purchase)
   - Monthly/annual subscription
   - Tiered pricing (Basic/Pro/Enterprise)
   - Easier revenue forecasting

2. **Volume Discounts** (For large farms)
   - Bulk animal pricing
   - Multi-farm discounts
   - Enterprise agreements

3. **Provider Tiers** (For consultations)
   - Standard vs Premium providers
   - Pricing based on experience
   - Specialization premiums

4. **Payment Plans** (For consultations)
   - Split payment over time
   - Pre-paid consultation packages
   - Subscription for unlimited consults

5. **Loyalty Programs**
   - Discount for frequent users
   - Referral bonuses
   - Anniversary rewards

### Analytics to Track

1. **Purchase Metrics**
   - Conversion rate (free → paid)
   - Platform distribution (iOS/Android/Web)
   - Time to purchase after signup
   - Refund rate by platform
   - Device activation patterns

2. **Payment Metrics**
   - Average consultation fee
   - Platform fee revenue
   - Provider earnings distribution
   - Payment method preferences
   - Dispute/refund rates
   - Client retention rate

3. **Provider Metrics**
   - Onboarding completion rate
   - Time to first consultation
   - Average earnings per provider
   - Payout preference distribution
   - Active vs inactive providers

---

**End of Document**

This specification is ready for implementation. All systems are designed to be compliant, secure, and scalable. Proceed with Phase 1 (App Purchase System) first, then Phase 2 (Telemedicine Payments) after FAT APP MVP is stable.
