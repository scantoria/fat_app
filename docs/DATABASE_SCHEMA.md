# FAT APP - Database Schema

**Version:** 1.0  
**Last Updated:** December 23, 2025  
**Database:** Cloud Firestore (Firebase)

---

## Table of Contents

1. [Schema Overview](#schema-overview)
2. [Collection Structure](#collection-structure)
3. [Top-Level Collections](#top-level-collections)
4. [Subcollections](#subcollections)
5. [Indexes](#indexes)
6. [Security Rules Summary](#security-rules-summary)
7. [Data Retention](#data-retention)
8. [Migration Strategy](#migration-strategy)

---

## Schema Overview

### Design Principles

- **Multi-tenant by Design:** All data isolated by owner
- **Subcollections for Related Data:** One-to-many relationships use subcollections
- **Denormalization Where Appropriate:** Balance between normalized structure and query performance
- **Timestamps on Everything:** Created and updated timestamps for audit trails
- **Soft Deletes:** Mark records as deleted rather than hard delete (for data recovery)

### Firestore Hierarchy

```
Root
├── owners (top-level)
├── users (top-level)
├── farms (top-level)
│   └── {farmId}
│       └── animals (subcollection)
│           └── {animalId}
│               ├── healthRecords (subcollection)
│               ├── breedingEvents (subcollection)
│               ├── lactationRounds (subcollection)
│               ├── services (subcollection)
│               ├── weights (subcollection)
│               └── photos (subcollection)
├── providers (top-level) [Phase 2]
├── consultations (top-level) [Phase 2]
└── consultationPayments (top-level) [Phase 2]
```

---

## Collection Structure

### Naming Conventions

- **Collections:** camelCase, plural (e.g., `healthRecords`)
- **Documents:** Auto-generated IDs unless meaningful ID exists
- **Fields:** camelCase (e.g., `firstName`, `dateOfBirth`)
- **Timestamps:** Firestore `Timestamp` type
- **References:** Document references or ID strings with clear naming (e.g., `ownerId`, `farmId`)

### Common Fields

All documents include these fields:

```javascript
{
  createdAt: timestamp,
  updatedAt: timestamp,
  createdBy: string (userId),
  updatedBy: string (userId),
  isDeleted: boolean (default: false),
  deletedAt: timestamp (if deleted),
  deletedBy: string (if deleted)
}
```

---

## Top-Level Collections

### 1. owners

Stores owner account information.

**Document ID:** Firebase Auth UID

```javascript
{
  ownerId: string,              // Same as document ID (Firebase Auth UID)
  email: string,
  displayName: string,
  phoneNumber: string,
  photoURL: string (optional),
  
  // Purchase information
  license: {
    status: string,             // "trial|active|expired|refunded"
    licenseKey: string,         // "FAT-2025-XXXX-XXXX-XXXX"
    purchaseDate: timestamp,
    purchasePlatform: string,   // "ios|android|web"
    transactionId: string,
    
    // Cross-platform tracking
    unlockedPlatforms: array,   // ["ios", "web"]
    
    // Receipt backup
    platformReceipts: {
      ios: string (base64 receipt),
      android: string (purchase token),
      web: string (Stripe charge ID)
    },
    
    // Device tracking
    activeDevices: [
      {
        deviceId: string,
        platform: string,       // "ios|android|web"
        activatedAt: timestamp,
        lastSeenAt: timestamp,
        deviceInfo: {
          model: string,
          osVersion: string
        }
      }
    ],
    maxDevices: number,         // 3
    
    // Free tier tracking
    animalCount: number,
    animalLimit: number         // 5 for free tier
  },
  
  // Settings
  preferences: {
    units: string,              // "imperial|metric"
    timezone: string,
    currency: string,
    notifications: {
      email: boolean,
      push: boolean,
      sms: boolean
    }
  },
  
  // Audit
  createdAt: timestamp,
  updatedAt: timestamp,
  lastLoginAt: timestamp,
  isDeleted: boolean
}
```

**Indexes:**
- `email` (ascending) - for login lookup
- `licenseKey` (ascending) - for license validation

---

### 2. users

Stores user profiles and farm role assignments.

**Document ID:** Firebase Auth UID

```javascript
{
  userId: string,               // Same as document ID
  email: string,
  displayName: string,
  phoneNumber: string,
  photoURL: string (optional),
  ownerId: string,              // Reference to owner
  
  // Farm assignments
  farmAssignments: [
    {
      farmId: string,
      role: string,             // "Owner|Manager|Lead|Farm Hand"
      assignedAt: timestamp,
      assignedBy: string (userId)
    }
  ],
  
  // Invitation tracking (if invited user)
  invitedBy: string (userId, optional),
  invitationAcceptedAt: timestamp (optional),
  
  // Settings
  preferences: {
    units: string,
    timezone: string,
    notifications: {
      email: boolean,
      push: boolean,
      sms: boolean
    }
  },
  
  // Audit
  createdAt: timestamp,
  updatedAt: timestamp,
  lastLoginAt: timestamp,
  isDeleted: boolean
}
```

**Indexes:**
- `email` (ascending)
- `ownerId` (ascending), `farmAssignments.farmId` (ascending) - for team queries

---

### 3. farms

Stores farm information.

**Document ID:** Auto-generated

```javascript
{
  farmId: string,               // Same as document ID
  ownerId: string,              // Owner who created this farm
  
  // Farm details
  name: string,
  address: {
    street: string (optional),
    city: string (optional),
    state: string (optional),
    zipCode: string (optional),
    country: string
  },
  
  farmType: string,             // "Dairy|Beef|Horse|Goat|Sheep|Mixed|Other"
  totalAcres: number (optional),
  numberOfPastures: number (optional),
  
  // Contact
  contactPhone: string (optional),
  contactEmail: string (optional),
  
  // Settings
  defaultUnits: string,         // "imperial|metric"
  
  // Statistics (denormalized for performance)
  stats: {
    totalAnimals: number,
    animalsBySpecies: {
      horses: number,
      cattle: number,
      goats: number,
      sheep: number,
      donkeys: number
    },
    pregnantAnimals: number,
    sickAnimals: number,
    teamMembers: number
  },
  
  // Audit
  createdAt: timestamp,
  updatedAt: timestamp,
  createdBy: string (userId),
  updatedBy: string (userId),
  isDeleted: boolean,
  deletedAt: timestamp (optional),
  deletedBy: string (optional)
}
```

**Subcollections:**
- `animals` - All animals on this farm
- `invitations` - Pending team member invitations

**Indexes:**
- `ownerId` (ascending), `isDeleted` (ascending) - for owner's farm list
- `ownerId` (ascending), `farmType` (ascending) - for filtering

---

## Subcollections

### farms/{farmId}/animals

Individual animal profiles.

**Document ID:** Auto-generated

```javascript
{
  animalId: string,             // Same as document ID
  farmId: string,               // Parent farm
  ownerId: string,              // Owner for security rules
  
  // Identification
  name: string,
  earTagNumber: string (optional),
  registrationNumber: string (optional),
  microchipNumber: string (optional),
  
  // Classification
  species: string,              // "Horse|Cattle|Goat|Sheep|Donkey"
  breed: string,
  color: string,
  genderType: string,           // Species-specific (e.g., "Mare", "Cow", "Buck")
  ageCategory: string,          // "Baby|Weanling|Yearling|Adult"
  
  // Dates
  dateOfBirth: timestamp (optional),
  estimatedAge: number (optional), // In years if DOB unknown
  acquisitionDate: timestamp,
  acquisitionSource: string (optional),
  
  // Physical
  currentWeight: number (optional),
  currentWeightUnit: string,    // "lbs|kg"
  height: number (optional),    // For horses, in hands
  bodyConditionScore: number (optional), // 1-9 scale
  
  // Status
  currentStatus: string,        // "Active|Sold|Deceased|Retired"
  currentLocation: string,      // "Barn 1, Pasture 3", etc.
  pregnancyStatus: string,      // "Not Pregnant|Pregnant|Recently Gave Birth"
  expectedDueDate: timestamp (optional),
  healthStatus: string,         // "Healthy|Sick|Chronic Condition|Recovering"
  
  // Relationships
  sireId: string (optional),    // Father's animalId
  damId: string (optional),     // Mother's animalId
  siblings: array (optional),   // Array of animalIds
  offspring: array (optional),  // Array of animalIds
  
  // Media
  profilePhotoURL: string (optional),
  photoGalleryURLs: array (optional),
  
  // Notes
  notes: string (optional),
  
  // Audit
  createdAt: timestamp,
  updatedAt: timestamp,
  createdBy: string (userId),
  updatedBy: string (userId),
  isDeleted: boolean,
  deletedAt: timestamp (optional),
  deletedBy: string (optional),
  
  // Deletion reason (if sold or deceased)
  deletionReason: string (optional),
  deletionNotes: string (optional)
}
```

**Subcollections:**
- `healthRecords`
- `breedingEvents`
- `lactationRounds`
- `services`
- `weights`
- `photos`
- `documents`

**Indexes:**
- `farmId` (ascending), `isDeleted` (ascending), `species` (ascending)
- `farmId` (ascending), `pregnancyStatus` (ascending), `expectedDueDate` (ascending)
- `farmId` (ascending), `healthStatus` (ascending)
- `ownerId` (ascending), `isDeleted` (ascending)
- `earTagNumber` (ascending) - for lookup
- `registrationNumber` (ascending) - for lookup
- `microchipNumber` (ascending) - for lookup

---

### farms/{farmId}/animals/{animalId}/healthRecords

Health and medical records.

**Document ID:** Auto-generated

```javascript
{
  recordId: string,
  animalId: string,
  farmId: string,
  ownerId: string,
  
  // Record details
  recordType: string,           // "Health Check|Illness|Injury|Surgery|Vaccination|Deworming|Hoof Care|Dental|Lab Results|Other"
  date: timestamp,
  title: string,
  description: string,
  
  // Provider
  providerName: string (optional),
  providerId: string (optional), // Reference to provider (Phase 2)
  
  // Treatment
  treatmentProvided: string (optional),
  medicationsPrescribed: array (optional), // Array of medication names
  
  // Follow-up
  followUpRequired: boolean,
  followUpDate: timestamp (optional),
  followUpNotes: string (optional),
  
  // Resolution
  resolutionStatus: string,     // "Open|In Treatment|Resolved|Chronic"
  resolvedDate: timestamp (optional),
  
  // Cost
  cost: number (optional),
  costCurrency: string (optional),
  
  // Media
  photoURLs: array (optional),
  documentURLs: array (optional),
  
  // Vaccination specific
  vaccineName: string (optional),
  nextDueDate: timestamp (optional),
  lotNumber: string (optional),
  
  // Lab results specific
  labName: string (optional),
  testType: string (optional),
  results: string (optional),
  
  // Audit
  createdAt: timestamp,
  updatedAt: timestamp,
  createdBy: string (userId),
  updatedBy: string (userId),
  isDeleted: boolean
}
```

**Indexes:**
- `animalId` (ascending), `date` (descending)
- `animalId` (ascending), `recordType` (ascending), `date` (descending)
- `animalId` (ascending), `resolutionStatus` (ascending)
- `animalId` (ascending), `nextDueDate` (ascending) - for vaccination reminders

---

### farms/{farmId}/animals/{animalId}/breedingEvents

Breeding events and pregnancy tracking.

**Document ID:** Auto-generated

```javascript
{
  eventId: string,
  animalId: string,              // Dam
  farmId: string,
  ownerId: string,
  
  // Breeding details
  breedingDate: timestamp,
  breedingMethod: string,        // "Natural|AI|Embryo Transfer"
  sireId: string (optional),     // Reference to sire animal
  sireName: string,
  sireRegistrationNumber: string (optional),
  
  // Location
  breedingLocation: string (optional),
  
  // Pregnancy tracking
  pregnancyConfirmed: boolean,
  confirmationDate: timestamp (optional),
  confirmationMethod: string (optional), // "Ultrasound|Blood Test|Palpation"
  expectedDueDate: timestamp,    // Auto-calculated or manual
  
  // Pregnancy checks
  pregnancyChecks: [
    {
      checkDate: timestamp,
      checkType: string,         // "Ultrasound|Palpation|Visual"
      findings: string,
      performedBy: string (optional),
      photoURLs: array (optional)
    }
  ],
  
  // Outcome
  outcomeStatus: string,         // "Pending|Live Birth|Stillbirth|Miscarriage|Aborted"
  outcomeDate: timestamp (optional),
  
  // Birth details (if live birth)
  birthDate: timestamp (optional),
  birthTime: string (optional),
  numberOfOffspring: number (optional),
  offspringIds: array (optional), // References to offspring animals
  easeOfBirth: string (optional), // "Normal|Assisted|Difficult|Caesarean"
  birthWeight: number (optional),
  birthWeightUnit: string (optional),
  
  // Dam condition
  damConditionPostBirth: string (optional), // "Good|Fair|Poor|Complications"
  
  // Notes
  notes: string (optional),
  complications: string (optional),
  
  // Media
  photoURLs: array (optional),
  documentURLs: array (optional),
  
  // Audit
  createdAt: timestamp,
  updatedAt: timestamp,
  createdBy: string (userId),
  updatedBy: string (userId),
  isDeleted: boolean
}
```

**Indexes:**
- `animalId` (ascending), `breedingDate` (descending)
- `animalId` (ascending), `expectedDueDate` (ascending)
- `animalId` (ascending), `outcomeStatus` (ascending)
- `sireId` (ascending) - for breeding history

---

### farms/{farmId}/animals/{animalId}/lactationRounds

Lactation rounds and milk production tracking.

**Document ID:** Auto-generated

```javascript
{
  roundId: string,
  animalId: string,
  farmId: string,
  ownerId: string,
  
  // Round details
  roundNumber: number,
  startDate: timestamp,
  endDate: timestamp (optional), // Null if currently active
  status: string,                // "Active|Complete"
  
  // Production goals
  dailyProductionGoal: number (optional),
  dailyProductionGoalUnit: string, // "gallons|liters|lbs|kg"
  
  // Statistics (denormalized for performance)
  totalProduction: number,
  averageDailyProduction: number,
  peakProduction: number,
  peakProductionDate: timestamp (optional),
  daysInMilk: number,
  
  // Notes
  notes: string (optional),
  
  // Audit
  createdAt: timestamp,
  updatedAt: timestamp,
  createdBy: string (userId),
  updatedBy: string (userId),
  isDeleted: boolean
}
```

**Subcollection:**
- `productionRecords` - Individual milk production records

---

### farms/{farmId}/animals/{animalId}/lactationRounds/{roundId}/productionRecords

Individual milk production records.

**Document ID:** Auto-generated

```javascript
{
  recordId: string,
  roundId: string,
  animalId: string,
  farmId: string,
  ownerId: string,
  
  // Production details
  date: timestamp,
  time: string (optional),       // "06:30 AM"
  volumeCollected: number,
  volumeUnit: string,            // "gallons|liters|lbs|kg"
  frequency: number,             // Times milked that day
  
  // Quality
  qualityNotes: string (optional),
  temperature: number (optional),
  temperatureUnit: string (optional),
  
  // Storage
  storageLocation: string (optional),
  
  // Notes
  notes: string (optional),
  
  // Audit
  createdAt: timestamp,
  updatedAt: timestamp,
  createdBy: string (userId),
  updatedBy: string (userId),
  isDeleted: boolean
}
```

**Indexes:**
- `roundId` (ascending), `date` (descending)
- `animalId` (ascending), `date` (descending)

---

### farms/{farmId}/animals/{animalId}/services

Scheduled and completed services (vet, farrier, etc.).

**Document ID:** Auto-generated

```javascript
{
  serviceId: string,
  animalId: string,
  farmId: string,
  ownerId: string,
  
  // Service details
  serviceType: string,           // "Veterinary|Farrier|Dental|Breeding|Nutrition|Training|Show|Other"
  status: string,                // "Scheduled|In Progress|Completed|Cancelled"
  
  // Scheduling
  scheduledDate: timestamp,
  scheduledTime: string (optional),
  duration: number (optional),   // In minutes
  
  // Completion
  completedDate: timestamp (optional),
  completedTime: string (optional),
  
  // Provider
  providerName: string,
  providerPhone: string (optional),
  providerEmail: string (optional),
  providerId: string (optional), // Reference to provider (Phase 2)
  
  // Location
  location: string (optional),   // "Farm|Off-site|Clinic"
  locationDetails: string (optional),
  
  // Service details
  purpose: string (optional),
  servicesProvided: array (optional), // Array of service descriptions
  notes: string (optional),
  
  // Cost
  estimatedCost: number (optional),
  actualCost: number (optional),
  costCurrency: string,
  
  // Follow-up
  nextServiceRecommended: boolean,
  nextServiceDate: timestamp (optional),
  nextServiceNotes: string (optional),
  
  // Recurring service
  isRecurring: boolean,
  recurringInterval: string (optional), // "Weekly|Biweekly|Monthly|Quarterly|Annually"
  recurringEndDate: timestamp (optional),
  
  // Media
  photoURLs: array (optional),
  documentURLs: array (optional),
  
  // Audit
  createdAt: timestamp,
  updatedAt: timestamp,
  createdBy: string (userId),
  updatedBy: string (userId),
  isDeleted: boolean
}
```

**Indexes:**
- `animalId` (ascending), `scheduledDate` (ascending)
- `animalId` (ascending), `status` (ascending), `scheduledDate` (ascending)
- `farmId` (ascending), `scheduledDate` (ascending) - for farm-wide schedule
- `providerId` (ascending), `scheduledDate` (ascending) - for provider schedule (Phase 2)

---

### farms/{farmId}/animals/{animalId}/weights

Weight tracking over time.

**Document ID:** Auto-generated

```javascript
{
  weightId: string,
  animalId: string,
  farmId: string,
  ownerId: string,
  
  // Weight details
  date: timestamp,
  weight: number,
  weightUnit: string,            // "lbs|kg"
  
  // Method
  measuredBy: string (optional),
  measurementMethod: string (optional), // "Scale|Tape|Visual Estimate"
  
  // Context
  bodyConditionScore: number (optional), // 1-9
  notes: string (optional),
  
  // Audit
  createdAt: timestamp,
  updatedAt: timestamp,
  createdBy: string (userId),
  isDeleted: boolean
}
```

**Indexes:**
- `animalId` (ascending), `date` (descending)

---

### farms/{farmId}/animals/{animalId}/photos

Photo gallery for animals.

**Document ID:** Auto-generated

```javascript
{
  photoId: string,
  animalId: string,
  farmId: string,
  ownerId: string,
  
  // Photo details
  photoURL: string,              // Firebase Storage URL
  thumbnailURL: string (optional),
  caption: string (optional),
  dateTaken: timestamp,
  
  // Metadata
  isProfilePhoto: boolean,
  fileSize: number,              // Bytes
  width: number (optional),
  height: number (optional),
  
  // Organization
  tags: array (optional),
  category: string (optional),   // "Health|Show|General|Breeding"
  
  // Audit
  createdAt: timestamp,
  uploadedBy: string (userId),
  isDeleted: boolean
}
```

**Indexes:**
- `animalId` (ascending), `dateTaken` (descending)
- `animalId` (ascending), `isProfilePhoto` (descending)

---

### farms/{farmId}/animals/{animalId}/documents

Document attachments for animals.

**Document ID:** Auto-generated

```javascript
{
  documentId: string,
  animalId: string,
  farmId: string,
  ownerId: string,
  
  // Document details
  fileName: string,
  fileURL: string,               // Firebase Storage URL
  fileType: string,              // "pdf|doc|docx|jpg|png"
  fileSize: number,              // Bytes
  
  // Organization
  category: string,              // "Registration|Health Certificate|Purchase Receipt|Insurance|Other"
  description: string (optional),
  tags: array (optional),
  
  // Dates
  documentDate: timestamp (optional), // Date on the document itself
  expirationDate: timestamp (optional),
  
  // Audit
  createdAt: timestamp,
  uploadedBy: string (userId),
  isDeleted: boolean
}
```

**Indexes:**
- `animalId` (ascending), `category` (ascending)
- `animalId` (ascending), `expirationDate` (ascending) - for expiration alerts

---

### farms/{farmId}/invitations

Pending team member invitations.

**Document ID:** Auto-generated

```javascript
{
  invitationId: string,
  farmId: string,
  ownerId: string,
  
  // Invitee
  email: string,
  role: string,                  // "Manager|Lead|Farm Hand"
  
  // Invitation
  invitedBy: string (userId),
  invitedAt: timestamp,
  expiresAt: timestamp,          // 7 days from invitedAt
  
  // Status
  status: string,                // "Pending|Accepted|Expired|Cancelled"
  acceptedAt: timestamp (optional),
  acceptedBy: string (optional), // userId created when accepted
  
  // Token
  invitationToken: string,       // Secure token for registration link
  
  // Audit
  createdAt: timestamp,
  updatedAt: timestamp,
  isDeleted: boolean
}
```

**Indexes:**
- `farmId` (ascending), `status` (ascending)
- `email` (ascending), `status` (ascending)
- `invitationToken` (ascending) - for token validation

---

## Phase 2 Collections (Provider Consortium)

### 4. providers

Provider profiles (Phase 2).

**Document ID:** Firebase Auth UID

```javascript
{
  providerId: string,
  email: string,
  displayName: string,
  phoneNumber: string,
  photoURL: string (optional),
  
  // Professional details
  professionalType: string,      // "Veterinarian|Nutritionist|Farrier|Breeding Consultant|Feed Specialist|Training Consultant|Other"
  businessName: string (optional),
  yearsExperience: number,
  specializations: array,
  
  // Licensing
  licenseNumber: string,
  licenseState: string,
  licenseExpiration: timestamp,
  licenseVerified: boolean,
  
  // Service areas
  serviceStates: array,          // States where licensed to practice
  serviceRadius: number (optional), // Miles for on-site visits
  
  // Credentialing
  credentialStatus: string,      // "Pending|Approved|Rejected|Suspended"
  credentialingStarted: timestamp,
  credentialingCompleted: timestamp (optional),
  
  // Queue status
  isAvailable: boolean,
  availabilityToggled: timestamp,
  
  // Stripe Connect
  stripeAccountId: string,
  stripeAccountStatus: string,   // "Pending|Verified|Active|Restricted"
  
  // Statistics
  stats: {
    totalConsultations: number,
    positiveRating: number,      // Thumbs up count
    negativeRating: number,      // Thumbs down count
    ratingPercentage: number,    // Positive / (Positive + Negative)
    totalEarnings: number,
    clientCount: number
  },
  
  // Audit
  createdAt: timestamp,
  updatedAt: timestamp,
  lastLoginAt: timestamp,
  isDeleted: boolean
}
```

**Subcollections:**
- `credentials` - Uploaded documents
- `attestations` - Digital signatures
- `clients` - Client roster
- `earnings` - Payment records

**Indexes:**
- `professionalType` (ascending), `credentialStatus` (ascending)
- `credentialStatus` (ascending), `serviceStates` (array-contains)
- `isAvailable` (ascending), `credentialStatus` (ascending)

---

### 5. consultations

Telemedicine consultations (Phase 2).

**Document ID:** Auto-generated

```javascript
{
  consultationId: string,
  
  // Parties
  clientId: string (userId),
  providerId: string,
  farmId: string,
  animalId: string,
  
  // Consultation details
  serviceType: string,
  concernDescription: string,
  animalInfo: object,            // Snapshot of animal data
  
  // Scheduling
  requestDate: timestamp,
  scheduledDate: timestamp,
  scheduledTime: string,
  duration: number,              // Minutes
  
  // Status
  status: string,                // "Pending|Scheduled|In Progress|Completed|Cancelled|No Show Client|No Show Provider"
  completedDate: timestamp (optional),
  
  // Session details
  sessionStarted: timestamp (optional),
  sessionEnded: timestamp (optional),
  actualDuration: number (optional),
  
  // Recording
  recordingEnabled: boolean,
  recordingType: string (optional), // "Video+Transcript|Transcript Only|None"
  recordingURL: string (optional),
  transcriptURL: string (optional),
  
  // Archive
  isArchived: boolean,
  archivedBy: string (optional), // "client|provider"
  archivePaymentStatus: string (optional), // "Paid|Subscription"
  
  // Feedback
  clientFeedback: string (optional), // "positive|negative"
  clientFeedbackText: string (optional),
  providerFeedback: string (optional),
  
  // Payment
  paymentId: string,             // Reference to consultationPayments
  paymentStatus: string,         // "Pending|Paid|Refunded"
  
  // Notes
  providerNotes: string (optional), // Private to provider
  sharedNotes: string (optional),   // Visible to both
  
  // Media
  clientPhotoURLs: array (optional), // Photos uploaded by client
  providerPhotoURLs: array (optional),
  
  // On-site visit request
  onSiteVisitRequested: boolean,
  onSiteVisitScheduled: timestamp (optional),
  
  // Audit
  createdAt: timestamp,
  updatedAt: timestamp,
  isDeleted: boolean
}
```

**Indexes:**
- `clientId` (ascending), `status` (ascending), `requestDate` (descending)
- `providerId` (ascending), `status` (ascending), `scheduledDate` (ascending)
- `animalId` (ascending), `status` (ascending) - for animal health record integration
- `status` (ascending), `scheduledDate` (ascending) - for admin dashboard

---

### 6. consultationPayments

Payment records for consultations (Phase 2).

**Document ID:** Auto-generated

```javascript
{
  paymentId: string,
  consultationId: string,
  clientId: string,
  providerId: string,
  
  // Payment details
  consultationFee: number,
  platformFee: number,
  totalAmount: number,
  currency: string,              // "USD"
  
  // Stripe details
  stripeChargeId: string,
  stripeTransferId: string (optional),
  paymentMethod: string,         // "card|google_pay|apple_pay"
  paymentMethodDetails: {
    type: string,
    last4: string,
    brand: string
  },
  
  // Status tracking
  status: string,                // "Pending|Completed|Refunded|Disputed"
  paidAt: timestamp,
  completedAt: timestamp (optional),
  refundedAt: timestamp (optional),
  
  // Payout tracking
  providerPayoutAmount: number,
  providerPayoutStatus: string,  // "Pending|Paid|Failed"
  providerPayoutDate: timestamp (optional),
  providerPayoutMethod: string,  // "instant|daily|weekly"
  
  // Receipts
  clientReceiptURL: string (optional),
  providerInvoiceURL: string (optional),
  
  // Dispute handling
  disputedAt: timestamp (optional),
  disputeReason: string (optional),
  disputeResolvedAt: timestamp (optional),
  disputeResolution: string (optional), // "refund_client|pay_provider|split"
  
  // Audit
  createdAt: timestamp,
  updatedAt: timestamp,
  isDeleted: boolean
}
```

**Indexes:**
- `consultationId` (ascending)
- `clientId` (ascending), `paidAt` (descending)
- `providerId` (ascending), `providerPayoutStatus` (ascending)
- `status` (ascending), `paidAt` (descending)

---

## Indexes

### Composite Indexes

Firestore requires composite indexes for queries with multiple filters or orderings. These should be defined in `firestore.indexes.json`:

```json
{
  "indexes": [
    {
      "collectionGroup": "animals",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "farmId", "order": "ASCENDING" },
        { "fieldPath": "isDeleted", "order": "ASCENDING" },
        { "fieldPath": "species", "order": "ASCENDING" }
      ]
    },
    {
      "collectionGroup": "animals",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "farmId", "order": "ASCENDING" },
        { "fieldPath": "pregnancyStatus", "order": "ASCENDING" },
        { "fieldPath": "expectedDueDate", "order": "ASCENDING" }
      ]
    },
    {
      "collectionGroup": "healthRecords",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "animalId", "order": "ASCENDING" },
        { "fieldPath": "date", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "breedingEvents",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "animalId", "order": "ASCENDING" },
        { "fieldPath": "expectedDueDate", "order": "ASCENDING" }
      ]
    },
    {
      "collectionGroup": "services",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "farmId", "order": "ASCENDING" },
        { "fieldPath": "scheduledDate", "order": "ASCENDING" }
      ]
    },
    {
      "collectionGroup": "consultations",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "providerId", "order": "ASCENDING" },
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "scheduledDate", "order": "ASCENDING" }
      ]
    }
  ]
}
```

---

## Security Rules Summary

**See SECURITY_RULES.md for complete Firestore rules.**

### Key Security Principles

1. **Multi-tenant Isolation:** Users can only access their owner's data
2. **Role-based Access:** Permissions enforced based on user role in farm
3. **Owner Supremacy:** Owners have full access to all their data
4. **No Cross-Owner Access:** Users cannot access data from other owners
5. **Soft Delete Protection:** Deleted records remain inaccessible but recoverable

### Rule Hierarchy

```
Owner → Can access all farms, all animals, all records
Manager → Can access assigned farms, all animals in those farms
Lead → Can read/write animals and records in assigned farms
Farm Hand → Can read only in assigned farms
```

---

## Data Retention

### Retention Policies

**Active Data:**
- No automatic deletion
- Soft delete only (isDeleted flag)
- Owner can permanently delete via support request

**Deleted Data:**
- Soft deleted records retained for 90 days
- After 90 days, owner can request permanent deletion
- Or records can be restored within 90 days

**Account Deletion:**
- Upon owner account deletion:
  - All farms soft deleted immediately
  - All animals and records soft deleted
  - Data retained for 30 days for recovery
  - After 30 days, permanent deletion
  - Payment/transaction data retained for 7 years (legal requirement)

**Consultation Recordings:**
- Archived recordings: Retained indefinitely (until archive subscription ends)
- Non-archived recordings: Deleted after 30 days
- Transcripts: Always retained with health records

---

## Migration Strategy

### Phase 1 to Phase 2 Migration

**No Breaking Changes:**
- All Phase 1 collections remain unchanged
- New collections added for Phase 2
- Existing apps continue to work

**Additive Changes:**
- Add `providerId` fields to services (optional, backward compatible)
- Add consultation-related fields to animals (optional)
- Link health records to consultations (optional foreign key)

### Future Migrations

**Version Control:**
- Schema version stored in owner document
- Migration scripts for data transformations
- Backward compatibility maintained for 2 versions

**Testing:**
- All migrations tested in staging environment
- Rollback plan for failed migrations
- User notification before breaking changes (if any)

---

**END OF DATABASE SCHEMA**

This schema supports all MVP features and is designed to scale to Phase 2 (Provider Consortium) without breaking changes. All queries are optimized with appropriate indexes, and security is enforced through Firestore rules.
