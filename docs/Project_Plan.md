# Project: Farm Animal Tracker Application

This document outlines the refined plan for the Farm Animal Tracker application, summarizing the project's goals, technology stack, and core features.

## 1. Project Goal

The goal of the Farm Animal Tracker application is to provide a comprehensive, centralized platform for managing the health, breeding, and logistics of horses, cattle, goats, sheep, and donkeys across multiple farm locations. The application will track critical information for each animal, including health records, breeding events, and feeding regimens, to facilitate data-driven decision-making and improve farm management efficiency.

## 1A. Business Model

The application is designed to be accessible to small and rural farmers while creating sustainable revenue streams through provider services.

### Revenue Streams

**Primary Subscription:**
- $5.00/month per farm - Base subscription for core farm management features
- Affordable pricing to ensure accessibility for small farmers
- Includes full animal tracking, health records, breeding management, and offline capabilities

**User Licensing:**
- Each user assigned to an Owner's farm requires a separate license
- Owner is billed for each user license at $5.00/month per user
- If a user works for multiple owners, each owner pays for that user's license separately
  - Example: Farm Hand works for Owner A and Owner B
  - Owner A pays one license fee for that user
  - Owner B pays one license fee for that same user
  - Total: 2 licenses billed (one to each owner)
- Owner and designated Managers can assign user licenses
- Billing is per active user per owner account

**Provider Consortium Services (Future):**
- **Platform Transaction Fees**: Commission on telemedicine consultations and services (e.g., 15-20% of consultation fee)
- **Provider Subscriptions**: Veterinarians and nutritionists pay monthly fee to be listed in the consortium
- **Premium Consultations**: Higher-tier providers can charge premium rates
- **Custom Programs**: Nutritionists can sell custom feeding/growth programs through the platform
- **Payment Processing Fees**: Standard transaction fees (2.9% + $0.30 per transaction)

**Value Proposition:**
- Farmers: Affordable farm management + access to provider network
- Providers: New client acquisition channel + telemedicine revenue stream
- Platform: Scalable marketplace model with recurring revenue

## 2. Membership & Organizational Structure

The application supports a multi-tenant organizational hierarchy where an Owner can manage multiple farms, each with its own staff, animals, and resources.

### Organizational Hierarchy

- **Owner**: Top-level account holder who can create and manage multiple farms
  - Can own multiple farms
  - Has full administrative access across all owned farms
  - Can assign users to specific farms with designated roles

- **Farm**: Individual farm entity with its own profile and resources
  - Each farm has its own assigned users
  - Each farm has its own animals
  - Each farm can have assigned veterinarians
  - Farm-specific settings and configurations

### User Roles

- **Owner**: Full access across all owned farms
  - Create and manage farms
  - Manage animals
  - Manage providers (veterinarians, blacksmiths, feed suppliers, breeding stock)
  - Manage users and role assignments
  - Can move animals between farms owned by the same Owner
  
- **Manager**: Farm-level administrator with full access to assigned farm(s)
  - Manage animals
  - Manage providers
  - Can move animals between farms owned by the same Owner
  
- **Lead**: Supervisory role with elevated permissions on assigned farm(s)
  - Manage animals (CRUD operations, health records, breeding, services)
  - Cannot manage providers
  
- **Farm Hand**: Basic access for day-to-day operations on assigned farm(s)
  - Read-only access to view animal information and records
  - Cannot create, edit, or delete records

### Key Relationships

- One Owner → Many Farms
- One Farm → Many Users (with assigned roles)
- One Farm → Many Animals
- **One Animal → One Farm** (an animal can only be assigned to one farm at a time)
- One Farm → Many Veterinarians (assigned)
- One User → Many Farms (with different roles per farm)
- **Licensing**: Each owner who assigns a user must license that user separately ($5/month per user per owner)

## 3. Animal Categories & Classifications

The application tracks five species with standardized age categories and gender-specific types.

### Species
- Horses
- Cattle
- Goats
- Sheep
- Donkeys

### Age Categories (Universal across all species)
- **Baby**: Foal (horse), Calf (cattle/donkey), Kid (goat), Lamb (sheep)
- **Weanling**: Recently weaned from mother
- **Yearling**: Between 1-2 years old
- **Adult**: Mature animal (2+ years)

### Gender/Type Classifications by Species

**Horses:**
- Colt (intact male)
- Gelding (castrated male)
- Filly (young female)
- Mare (adult female)
- Stallion (intact adult male)

**Cattle:**
- Bull (intact male)
- Steer (castrated male)
- Heifer (young female, not yet calved)
- Cow (adult female, has calved)

**Goats:**
- Buckling (young intact male)
- Buck (adult intact male)
- Wether (castrated male)
- Doeling (young female)
- Doe/Nanny (adult female)

**Sheep:**
- Ram (intact male)
- Wether (castrated male)
- Ewe (female)

**Donkeys:**
- Jack (intact male)
- Gelding (castrated male)
- Jenny (female)

## 3A. Animal Services & Health Management

### Medical Administration Permissions
- **Owner, Manager, Lead**: Can administer basic over-the-counter medication
- **Owner, Manager**: Can record advanced medication/services and reference the veterinarian who performed the service
- **Veterinarian Required**: Advanced medication and prescriptions (recorded by Owner/Manager)

### Services Tracked
- Routine shots/vaccinations
- Castration
- Dehorning
- Blacksmith/Farrier services
- Pregnancy checks
- Hormone treatments
- Veterinary services (general)
- **Lactation tracking** (for dairy animals: cattle, goats, sheep):
  - Lactation round/year (manually initiated when milking begins)
  - A lactation year only counts if the animal is actively milked
  - If baby is left to nurse, that year does not count as a lactation round
  - Frequency of milking per day (typically twice daily)
  - **Amount collected per milking session** (critical metric)
  - **Milk production tracking**: High producers have greater value and produce more valuable offspring
  - Daily, weekly, monthly, and yearly production totals
  - **Important for show animals**: Milking protects the udder from deformation caused by rough nursing
  - Track whether animal is being milked vs. nursing baby

### Breeding & Reproduction Tracking
- **Breeding Events**: Natural or AI (Artificial Insemination)
- **Breeding Status**: Bred or Open
- **Heat Status**: 
  - Manual entry of heat cycles
  - Automatic calculation/prediction of next heat cycle based on historical data
  - Reminders when heat is expected
- **Birthing Schedule**: Expected due dates
- **Weaning Schedule**: Weaning dates and methods

### Health Records
- Medication administration (OTC and prescription)
- Treatment records
- General health events and observations

### Document Management
Each animal profile supports file uploads for:
- **Registration Papers**: Official breed registration documents
- **Health Records**: Test results, medical reports, treatment history
- **Images**: Photos of ailments/injuries, progress photos
- **Supporting Documentation**: Other relevant files
- **Animal Avatar**: Primary photo for visual identification

**File Management**:
- Documents categorized by type
- Multiple files allowed per category
- File size limits enforced per upload

## 3B. Providers & External Resources

The application tracks various service providers and external resources used across farms.

### Provider Types

**Blacksmiths/Farriers**
- Contact information
- Service areas
- Service history with farm animals

**Veterinarians**
- Contact information
- Specializations
- Service history with farm animals
- Referenced when recording advanced medical services

**Nutritionists** (for future consortium feature)
- Contact information
- Specializations (dairy, beef, equine, small ruminants)
- Credentials and certifications
- Available for consultation requests
- Can create custom feeding programs

**Feed Suppliers**
- Contact information
- Product catalog with pricing per feed type
- Order history
- Delivery schedules

**Breeding Stock (Bulls/Sires/Bucks)**
- Animals available for lease or breeding services
- Not owned by the farm but used for breeding programs
- Owner/source contact information
- Breed, genetics, and lineage tracking
- Lease terms and costs
- Performance records
- **Bloodline tracking to prevent inbreeding**

### Key Relationships
- Providers can service multiple farms
- Farms can work with multiple providers
- Breeding stock can be referenced across multiple breeding events
- Service records link animals to specific providers

## 4. Technology Stack

- **Frontend**: **Flutter**
  - A cross-platform framework for building responsive applications that compile to web, Android, and iOS from a single codebase.

- **Backend & Notifications**: **Firebase Cloud Functions** & **Firebase Cloud Messaging (FCM)**
  - Firebase Cloud Functions will handle all server-side logic, and FCM will power automated push notifications for critical events.

- **Database**: **Firebase Cloud Firestore**
  - A NoSQL, document-based database providing a flexible schema to store and retrieve all animal, farm, and record data.
  - **Offline Support**: Firestore has built-in offline persistence for mobile apps

- **Local Database**: **SQLite**
  - Local database for mobile apps (Android/iOS) to support offline operations in rural areas without cellular signal
  - Stores critical data locally when offline
  - Automatic synchronization with Firestore when connection is restored
  - Conflict resolution strategy for data modified offline

- **File Storage**: **Firebase Storage**
  - Secure cloud storage for animal avatars, registration papers, health records, and supporting documents.

- **Payment Processing**: **Stripe**
  - Handles telemedicine consultation payments
  - Provider membership billing ($5/month)
  - Automatic 90/10 revenue split
  - Payout processing for providers
  - PCI compliance handled by Stripe

- **Video Recording & Transcription**:
  - WebRTC for live video streaming
  - Google Cloud Speech-to-Text API for real-time transcription
  - Firebase Storage for video recordings
  - Cloud Functions for automatic transcript generation
  - Automatic key term extraction (NLP)

- **Authentication**: **Firebase Authentication**
  - A fully managed service to handle user registration, login, and secure access to the application.

- **Development Environment**: **Visual Studio Code (VS Code)**
  - The primary Integrated Development Environment (IDE) for building the application.

## 4A. Data Retention & Storage Policy

### Video Recording Retention:

**Free Tier (Platform-Provided):**
- Video recordings stored for **90 days** from consultation date
- Platform absorbs storage costs
- Automatic deletion after 90 days
- 7-day warning before deletion
- Download option available anytime during 90-day period

**Premium Archive Options:**
- **Single Archive**: $2.99 per consultation video for 1 year
- **Unlimited Archive Subscription**: $9.99/month for all videos
- Either farmer or provider can purchase archive
- Shared cost available (each party pays 50%)
- Videos accessible anytime during archive period
- Annual renewal option after 1 year

**Archive Renewal:**
- Notification sent 7 days before archive expiration
- Renewal price: $2.99 for 1 additional year
- No limit on renewals
- If not renewed, video permanently deleted

### Permanent Storage (No Expiration):

**Always Kept:**
- Audio transcripts (text)
- Health records
- Consultation notes
- Photos and images
- Provider-entered treatment plans
- Prescription records
- Feedback and ratings

**Minimal Storage Cost:**
- Text data: ~10KB per consultation
- Photos: ~2MB average per consultation
- Sustainable with platform revenue

### Message Retention:

**Messages auto-delete after:**
- 1 year from send date
- Export option before deletion
- Health-related messages archived in animal records (permanent)

### Provider Notes:

**Private notes:**
- Kept as long as provider is active on platform
- 30 days after provider leaves platform
- Export option for providers

### Data Export:

**Farmers can export:**
- All animal health records
- All consultation transcripts
- All photos and documents
- Complete CSV of all data

**Providers can export:**
- Their consultation history
- Their client list
- Their private notes
- Earnings history

### GDPR/Privacy Compliance:

- Users can request complete data deletion
- 30-day grace period before permanent deletion
- Anonymized data retained for platform analytics
- Consultation videos deleted immediately on request
- No data sold or shared with third parties

## 5. Database Schema

The **Cloud Firestore** schema is structured with top-level collections for primary entities and subcollections for all related records. Below are the detailed field definitions for each collection.

### Top-Level Collections

#### **owners**
Stores owner account information.

**Fields:**
- `ownerId` (string) - Unique identifier (Firebase Auth UID)
- `email` (string) - Owner's email address
- `displayName` (string) - Owner's full name
- `phoneNumber` (string) - Contact phone number
- `subscriptionStatus` (string) - "active", "past_due", "cancelled"
- `subscriptionPlan` (string) - "basic" (currently only one plan)
- `billingEmail` (string) - Email for billing notifications
- `licensedUserCount` (number) - Number of active user licenses
- `monthlyBillingAmount` (number) - Total monthly bill (base + user licenses)
- `nextBillingDate` (timestamp) - Next billing date
- `paymentMethod` (object) - Payment method details (Stripe/payment processor reference)
- `createdAt` (timestamp) - Account creation date
- `updatedAt` (timestamp) - Last update timestamp

---

#### **users**
Stores user profiles and farm role assignments.

**Fields:**
- `userId` (string) - Unique identifier (Firebase Auth UID)
- `email` (string) - User's email address
- `displayName` (string) - User's full name
- `phoneNumber` (string) - Contact phone number
- `ownerId` (string) - Reference to owner account
- `farmAssignments` (array of objects) - List of farm assignments
  - `farmId` (string) - Reference to farm
  - `role` (string) - "Owner", "Manager", "Lead", "Farm Hand"
- `favoriteProviders` (array of strings) - providerIds marked as favorites
- `createdAt` (timestamp) - Account creation date
- `updatedAt` (timestamp) - Last update timestamp

---

#### **licenses**
Tracks user licenses billed to owners.

**Fields:**
- `licenseId` (string) - Unique identifier
- `ownerId` (string) - Reference to owner being billed
- `userId` (string) - Reference to licensed user
- `userEmail` (string) - User's email
- `userName` (string) - User's display name
- `status` (string) - "active", "suspended", "cancelled"
- `assignedBy` (string) - userId who created the license
- `farmAssignments` (array of strings) - farmIds this license covers
- `licenseStartDate` (timestamp) - When license became active
- `licenseEndDate` (timestamp) - When license ends (null if active)
- `monthlyRate` (number) - Monthly cost (currently $5.00)
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

---

#### **farms**
Stores information for each farm.

**Fields:**
- `farmId` (string) - Unique identifier
- `ownerId` (string) - Reference to owner
- `farmName` (string) - Name of the farm
- `address` (object)
  - `street` (string)
  - `city` (string)
  - `state` (string)
  - `zipCode` (string)
  - `country` (string)
- `phoneNumber` (string) - Farm contact number
- `email` (string) - Farm contact email
- `totalAcres` (number) - Total farm acreage
- `settings` (object) - Farm-specific configurations
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

---

#### **animals**
Stores the main profile for each animal.

**Fields:**
- `animalId` (string) - Unique identifier
- `farmId` (string) - Current farm assignment (required)
- `ownerId` (string) - Reference to owner
- `species` (string) - "Horse", "Cattle", "Goat", "Sheep", "Donkey"
- `name` (string) - Animal's name
- `earTagNumber` (string) - Ear tag identification number (for commercial livestock)
- `registrationNumber` (string) - Official registration number (if applicable)
- `isShowAnimal` (boolean) - Designation for show animals
- `dateOfBirth` (timestamp) - Birth date
- `ageCategory` (string) - "Baby", "Weanling", "Yearling", "Adult"
- `gender` (string) - "Male", "Female"
- `genderType` (string) - Species-specific type (e.g., "Mare", "Bull", "Doe", "Ram", "Jenny")
- `breed` (string) - Breed name
- `color` (string) - Primary color/markings
- `microchipNumber` (string) - Microchip ID (if applicable)
- `avatarUrl` (string) - URL to primary photo
- `damId` (string) - Reference to mother animal (if owned)
- `sireId` (string) - Reference to father (animalId or breedingStockId)
- `bloodline` (object) - Genetic lineage information
  - `maternalLine` (array of strings) - Maternal ancestor IDs
  - `paternalLine` (array of strings) - Paternal ancestor IDs
- `currentStatus` (string) - "Active", "Sold", "Deceased", "Transferred"
- `breedingStatus` (string) - "Open", "Bred", "Pregnant", "Not Breeding"
- `isLactating` (boolean) - Currently being milked
- `currentLactationRound` (number) - Current lactation year number
- `healthStatus` (string) - "Healthy", "Sick", "Under Treatment", "Recovering"
- `weight` (number) - Current weight
- `weightUnit` (string) - "lbs" or "kg"
- `notes` (string) - General notes about the animal
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

---

#### **veterinarians**
Stores information for each veterinarian.

**Fields:**
- `veterinarianId` (string) - Unique identifier
- `firstName` (string)
- `lastName` (string)
- `clinicName` (string)
- `email` (string)
- `phoneNumber` (string)
- `address` (object)
  - `street` (string)
  - `city` (string)
  - `state` (string)
  - `zipCode` (string)
- `specializations` (array of strings) - Areas of expertise
- `serviceAreas` (array of strings) - Geographic areas served
- `licenseNumber` (string)
- `emergencyAvailable` (boolean)
- `notes` (string)
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

---

#### **blacksmiths**
Stores information for each blacksmith/farrier.

**Fields:**
- `blacksmithId` (string) - Unique identifier
- `firstName` (string)
- `lastName` (string)
- `businessName` (string)
- `email` (string)
- `phoneNumber` (string)
- `address` (object)
  - `street` (string)
  - `city` (string)
  - `state` (string)
  - `zipCode` (string)
- `serviceAreas` (array of strings) - Geographic areas served
- `certifications` (array of strings)
- `specialties` (array of strings) - e.g., "Corrective Shoeing", "Hot Shoeing"
- `notes` (string)
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

---

#### **feedSuppliers**
Stores information for feed suppliers.

**Fields:**
- `supplierId` (string) - Unique identifier
- `companyName` (string)
- `contactName` (string)
- `email` (string)
- `phoneNumber` (string)
- `address` (object)
  - `street` (string)
  - `city` (string)
  - `state` (string)
  - `zipCode` (string)
- `website` (string)
- `deliveryAvailable` (boolean)
- `minimumOrder` (number)
- `paymentTerms` (string)
- `notes` (string)
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

---

#### **breedingStock**
Stores information for bulls/sires/bucks available for lease or breeding.

**Fields:**
- `breedingStockId` (string) - Unique identifier
- `name` (string) - Animal's name
- `species` (string) - "Horse", "Cattle", "Goat", "Sheep", "Donkey"
- `breed` (string)
- `registrationNumber` (string)
- `dateOfBirth` (timestamp)
- `color` (string)
- `ownerName` (string) - External owner
- `ownerContact` (object)
  - `email` (string)
  - `phoneNumber` (string)
  - `address` (string)
- `bloodline` (object) - Genetic lineage
  - `sire` (string)
  - `dam` (string)
  - `paternalLine` (array of strings)
  - `maternalLine` (array of strings)
- `performanceRecords` (object)
  - `showWins` (array of strings)
  - `offspringCount` (number)
  - `offspringPerformance` (string)
- `leaseTerms` (object)
  - `availabilityStatus` (string) - "Available", "Leased", "Unavailable"
  - `leaseRate` (number)
  - `leasePeriod` (string)
  - `conditions` (string)
- `geneticTesting` (array of strings) - Test results/certifications
- `photos` (array of strings) - URLs to photos
- `notes` (string)
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

---

#### **providers**
Stores provider profiles for consortium members.

**Fields:**
- `providerId` (string) - Unique identifier
- `userId` (string) - Reference to user account (if they log in)
- `providerType` (string) - "Veterinarian", "Nutritionist", "Farrier", "Breeding Consultant", etc.
- `firstName` (string)
- `lastName` (string)
- `email` (string) - Contact and login email
- `phoneNumber` (string)
- `businessName` (string) - Practice or business name
- `yearsExperience` (number)
- `specializations` (array of strings) - Areas of expertise
- `serviceRadius` (number) - Miles willing to travel for on-site visits
- `profilePhotoUrl` (string)
- `bio` (string) - Provider biography
- `licenseNumber` (string) - Provider license number
- `licenseState` (string) - State of licensure
- `licenseExpiration` (timestamp)
- `insurancePolicyNumber` (string)
- `insuranceExpiration` (timestamp)
- `credentialStatus` (string) - "pending", "verified", "expired", "suspended", "rejected"
- `verifiedAt` (timestamp) - When credentials were verified
- `lastVerificationDate` (timestamp) - Most recent re-verification
- `nextVerificationDue` (timestamp) - When re-verification needed
- `membershipStatus` (string) - "trial", "active", "past_due", "cancelled"
- `membershipStartDate` (timestamp) - When they joined
- `membershipFee` (number) - Monthly fee ($5.00)
- `trialEndDate` (timestamp) - End of free trial period
- `experiencePremium` (number) - Additional charge for expertise ($0-25)
- `isBoardCertified` (boolean)
- `boardCertifications` (array of strings)
- `totalConsultations` (number) - Total completed consultations
- `helpfulCount` (number) - Number of "Yes" to helpful
- `helpfulnessRate` (number) - Percentage (0-100)
- `returnCount` (number) - Number of "Yes" to would return
- `returnRate` (number) - Percentage (0-100)
- `concernsReported` (number) - Total concern reports
- `lastReviewDate` (timestamp) - Last admin quality review
- `qualityStatus` (string) - "good_standing", "warning", "probation", "suspended"
- `totalOnSiteVisits` (number) - Total completed on-site visits
- `responseTimeAvg` (number) - Average response time in minutes
- `acceptanceRate` (number) - % of consultation requests accepted
- `favoritedByCount` (number) - Number of farmers who favorited
- `favoritedBy` (array of strings) - userIds who favorited this provider
- `totalClients` (number) - Unique farmers consulted
- `activeClientsThisMonth` (number) - Consulted in last 30 days
- `newClientsThisMonth` (number) - First consultation in last 30 days
- `address` (object) - Business address
  - `street` (string)
  - `city` (string)
  - `state` (string)
  - `zipCode` (string)
- `serviceAreas` (array of strings) - States/regions served
- `availability` (object) - General availability schedule
  - `monday` (array) - Time slots
  - `tuesday` (array)
  - `wednesday` (array)
  - `thursday` (array)
  - `friday` (array)
  - `saturday` (array)
  - `sunday` (array)
- `emergencyAvailable` (boolean) - Accepts emergency consultations
- `notes` (string) - Internal admin notes
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

---

#### **providerCredentials**
Stores uploaded credential documents for verification.

**Fields:**
- `credentialId` (string) - Unique identifier
- `providerId` (string) - Reference to provider
- `documentType` (string) - "License", "Education", "Insurance", "ID", "Certification"
- `documentName` (string) - Original filename
- `fileUrl` (string) - Firebase Storage URL
- `fileSize` (number) - In bytes
- `uploadedAt` (timestamp)
- `verificationStatus` (string) - "pending", "verified", "rejected"
- `verifiedBy` (string) - Admin userId who verified
- `verifiedAt` (timestamp)
- `expirationDate` (timestamp) - For licenses, insurance
- `rejectionReason` (string) - If rejected
- `notes` (string)

---

#### **providerAttestations**
Stores signed digital attestations.

**Fields:**
- `attestationId` (string) - Unique identifier
- `providerId` (string) - Reference to provider
- `attestationText` (string) - Full attestation statement
- `signatureImageUrl` (string) - Digital signature image
- `ipAddress` (string) - IP where signed
- `userAgent` (string) - Browser/device info
- `signedAt` (timestamp)
- `attestationType` (string) - "initial", "annual_renewal"

---

#### **consultations**
Stores telemedicine consultation sessions.

**Fields:**
- `consultationId` (string) - Unique identifier
- `providerId` (string) - Reference to provider
- `providerName` (string)
- `farmerId` (string) - Reference to farmer/user
- `farmerName` (string)
- `animalId` (string) - Reference to animal (if applicable)
- `animalName` (string)
- `consultationType` (string) - "quick", "video", "emergency", "follow-up"
- `requestDate` (timestamp) - When consultation was requested
- `scheduledDate` (timestamp) - Scheduled time
- `startTime` (timestamp) - Actual start time
- `endTime` (timestamp) - Actual end time
- `duration` (number) - Minutes
- `status` (string) - "requested", "scheduled", "in-progress", "completed", "cancelled", "no-show"
- `farmerIssueDescription` (string) - Farmer's description of problem
- `symptoms` (array of strings) - Reported symptoms
- `photos` (array of strings) - URLs to uploaded photos
- `providerNotes` (string) - Provider's consultation notes
- `diagnosis` (string) - Provider's diagnosis
- `treatmentPlan` (string) - Recommended treatment
- `prescriptions` (array of objects) - If medications prescribed
  - `medication` (string)
  - `dosage` (string)
  - `frequency` (string)
  - `duration` (string)
- `followUpRecommended` (boolean)
- `followUpDate` (timestamp) - Recommended follow-up date
- `onSiteVisitRecommended` (boolean)
- `basePrice` (number) - Base consultation fee
- `experiencePremium` (number) - Additional fee for expertise
- `totalPrice` (number) - Total charged to farmer
- `platformFee` (number) - 10% platform fee
- `providerEarnings` (number) - 90% to provider
- `paymentStatus` (string) - "pending", "completed", "refunded"
- `paymentDate` (timestamp)
- `wasHelpful` (boolean) - Farmer's response to "Was this helpful?"
- `wouldReturn` (boolean) - Farmer's response to "Would return?"
- `farmerFeedbackComment` (string) - Optional text feedback
- `feedbackSubmittedAt` (timestamp)
- `concernReported` (boolean) - Did farmer report a concern?
- `concernDescription` (string) - Details of concern
- `recordingConsent` (object)
  - `farmerConsented` (boolean)
  - `providerConsented` (boolean)
  - `bothAgreed` (boolean)
  - `consentTimestamp` (timestamp)
- `videoRecordingUrl` (string) - Firebase Storage URL (if recorded)
- `recordingDuration` (number) - Minutes
- `recordingSize` (number) - MB
- `transcriptText` (string) - Full text transcript
- `transcriptUrl` (string) - URL to formatted transcript document
- `keyTermsExtracted` (array of strings) - Medications, diagnoses, symptoms
- `keyMoments` (array of objects) - Timestamped important moments
  - `timestamp` (number) - Seconds into recording
  - `description` (string) - What happened
  - `type` (string) - "diagnosis", "prescription", "recommendation"
- `recordingRetentionExpires` (timestamp) - When video will be deleted (90 days)
- `recordingArchived` (boolean) - Is video archived beyond 90 days?
- `archivedBy` (string) - userId who paid for archive
- `archiveExpiresAt` (timestamp) - When archive expires
- `archiveCost` (number) - Cost paid for archiving
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

---

#### **onSiteVisits**
Tracks in-person visits scheduled through the platform.

**Fields:**
- `visitId` (string) - Unique identifier
- `consultationId` (string) - Reference to consultation that led to visit
- `providerId` (string) - Reference to provider
- `providerName` (string)
- `farmerId` (string) - Reference to farmer
- `farmerName` (string)
- `farmId` (string) - Reference to farm location
- `farmAddress` (string) - Visit location
- `animalId` (string) - Animal(s) to be examined
- `animalName` (string)
- `requestedDate` (timestamp) - When visit was requested
- `proposedDates` (array of timestamps) - Provider's proposed dates
- `scheduledDate` (timestamp) - Agreed upon date/time
- `status` (string) - "requested", "confirmed", "completed", "cancelled", "rescheduled"
- `servicesNeeded` (array of strings) - Services to be performed
- `estimatedCost` (number) - Provider's cost estimate
- `actualCost` (number) - Final cost after visit
- `estimatedDuration` (number) - Expected visit length (minutes)
- `actualDuration` (number) - Actual visit length
- `providerNotes` (string) - Notes before visit
- `visitReport` (string) - Detailed report after visit
- `servicesPerformed` (array of strings) - What was actually done
- `findings` (string) - Provider's findings
- `followUpRecommended` (boolean)
- `followUpConsultationType` (string) - "telemedicine" or "on-site"
- `followUpDate` (timestamp)
- `farmerPreparationNotes` (string) - What farmer needs to prepare
- `travelDistance` (number) - Miles traveled
- `arrivalTime` (timestamp) - When provider arrived
- `departureTime` (timestamp) - When provider left
- `paymentMethod` (string) - "cash", "check", "card", "other"
- `paymentStatus` (string) - "pending", "completed"
- `farmerRating` (number) - Farmer rates visit (1-5 stars)
- `farmerReview` (string)
- `providerRating` (number) - Provider rates farmer preparedness
- `providerReview` (string)
- `photos` (array of strings) - Documentation photos
- `noShowReason` (string) - If cancelled/no-show
- `rescheduledFrom` (timestamp) - Original date if rescheduled
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

---

#### **providerEarnings**
Tracks provider earnings for accounting and analytics.

**Fields:**
- `earningId` (string) - Unique identifier
- `providerId` (string) - Reference to provider
- `consultationId` (string) - Reference to consultation (if applicable)
- `earningType` (string) - "consultation", "membership_refund", "adjustment"
- `grossAmount` (number) - Total consultation price
- `platformFee` (number) - 10% platform fee
- `netAmount` (number) - Amount earned by provider (90%)
- `payoutStatus` (string) - "pending", "processing", "completed", "failed"
- `payoutDate` (timestamp) - When paid out
- `payoutMethod` (string) - "bank_transfer", "paypal", etc.
- `month` (string) - "YYYY-MM" for monthly aggregation
- `notes` (string)
- `createdAt` (timestamp)

---

#### **messages**
Stores provider-client messages.

**Fields:**
- `messageId` (string) - Unique identifier
- `threadId` (string) - Groups related messages
- `senderId` (string) - userId of sender
- `senderType` (string) - "farmer", "provider"
- `senderName` (string) - Display name
- `recipientId` (string) - userId of recipient
- `recipientType` (string) - "farmer", "provider"
- `messageType` (string) - "text", "photo", "document", "voice"
- `messageText` (string) - Text content
- `fileUrl` (string) - Attached file URL if applicable
- `fileSize` (number) - File size in bytes
- `fileName` (string) - Original filename
- `consultationId` (string) - Related consultation (if applicable)
- `animalId` (string) - Related animal (if applicable)
- `animalName` (string)
- `status` (string) - "sent", "delivered", "read"
- `readAt` (timestamp) - When recipient read message
- `sentAt` (timestamp)
- `expiresAt` (timestamp) - Messages auto-delete after 1 year

---

#### **providerNotes**
Stores provider's private notes about clients/animals.

**Fields:**
- `noteId` (string) - Unique identifier
- `providerId` (string) - Provider who created note
- `targetType` (string) - "client", "animal"
- `targetId` (string) - clientId or animalId
- `targetName` (string) - Client or animal name
- `noteText` (string) - Private note content (500 char max)
- `reminder` (boolean) - Is this a reminder?
- `reminderDate` (timestamp) - When to remind provider
- `tags` (array of strings) - Searchable tags
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

---

#### **feed**
Stores the different types of feed.

**Fields:**
- `feedId` (string) - Unique identifier
- `feedName` (string) - Name/description of feed
- `feedType` (string) - "Hay", "Grain", "Pellets", "Supplement", "Mineral", "Other"
- `brand` (string)
- `supplierId` (string) - Reference to feed supplier
- `currentPrice` (number)
- `priceUnit` (string) - "per bag", "per bale", "per ton"
- `nutritionInfo` (object)
  - `protein` (number) - percentage
  - `fat` (number) - percentage
  - `fiber` (number) - percentage
  - `calories` (number)
- `suitableFor` (array of strings) - Species this feed is suitable for
- `storageRequirements` (string)
- `notes` (string)
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

### Subcollections

#### **Animal Subcollections**

**animals/{animalId}/healthRecords**
Records general health events and observations.

**Fields:**
- `recordId` (string) - Unique identifier
- `recordDate` (timestamp) - Date of health event
- `recordType` (string) - "Observation", "Illness", "Injury", "Checkup", "Other"
- `description` (string) - Details of the health event
- `symptoms` (array of strings) - List of symptoms
- `diagnosis` (string) - If diagnosed
- `treatment` (string) - Treatment provided
- `veterinarianId` (string) - Reference to vet (if applicable)
- `recordedBy` (string) - userId of person recording
- `resolved` (boolean) - Whether issue is resolved
- `resolvedDate` (timestamp)
- `notes` (string)
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

---

**animals/{animalId}/medications**
Tracks medication administration.

**Fields:**
- `medicationId` (string) - Unique identifier
- `medicationName` (string)
- `medicationType` (string) - "OTC", "Prescription"
- `dosage` (string)
- `frequency` (string) - e.g., "Twice daily"
- `route` (string) - "Oral", "Injectable", "Topical", "Other"
- `startDate` (timestamp)
- `endDate` (timestamp)
- `prescribedBy` (string) - veterinarianId or "OTC"
- `administeredBy` (string) - userId
- `reason` (string) - Reason for medication
- `sideEffects` (string) - Any observed side effects
- `status` (string) - "Active", "Completed", "Discontinued"
- `notes` (string)
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

---

**animals/{animalId}/breedingEvents**
Records breeding events.

**Fields:**
- `breedingId` (string) - Unique identifier
- `breedingDate` (timestamp)
- `breedingMethod` (string) - "Natural", "AI"
- `sireId` (string) - Reference to breedingStock or owned animal
- `sireName` (string) - Name of sire
- `expectedDueDate` (timestamp) - Calculated from breeding date
- `pregnancyConfirmed` (boolean)
- `confirmationDate` (timestamp)
- `confirmationMethod` (string) - "Ultrasound", "Blood Test", "Palpation"
- `veterinarianId` (string) - Vet who performed confirmation
- `outcome` (string) - "Pregnant", "Open", "Pending", "Miscarried", "Aborted"
- `notes` (string)
- `recordedBy` (string) - userId
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

---

**animals/{animalId}/birthRecords**
Records births and offspring information.

**Fields:**
- `birthId` (string) - Unique identifier
- `birthDate` (timestamp)
- `breedingEventId` (string) - Reference to breeding event
- `offspringCount` (number) - Number of offspring
- `offspring` (array of objects)
  - `animalId` (string) - Reference to offspring animal record
  - `gender` (string)
  - `weight` (number)
  - `status` (string) - "Alive", "Stillborn", "Deceased"
- `birthType` (string) - "Natural", "Assisted", "C-Section"
- `complications` (string) - Any complications during birth
- `veterinarianId` (string) - If vet assisted
- `damCondition` (string) - Mother's condition after birth
- `notes` (string)
- `recordedBy` (string) - userId
- `createdAt` (timestamp)

---

**animals/{animalId}/weaningSchedules**
Records weaning information.

**Fields:**
- `weaningId` (string) - Unique identifier
- `plannedWeaningDate` (timestamp)
- `actualWeaningDate` (timestamp)
- `weaningMethod` (string) - "Abrupt", "Gradual", "Fence Line"
- `weaningAge` (number) - Age in days/months at weaning
- `preWeaningWeight` (number)
- `postWeaningWeight` (number)
- `complications` (string) - Any issues during weaning
- `notes` (string)
- `recordedBy` (string) - userId
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

---

**animals/{animalId}/lactationRecords**
Tracks lactation/milking for dairy animals.

**Fields:**
- `lactationId` (string) - Unique identifier
- `recordDate` (timestamp)
- `lactationRound` (number) - Which lactation year
- `milkingTime` (string) - "Morning", "Evening", "Midday"
- `amountCollected` (number) - Amount in gallons or liters
- `unit` (string) - "gallons", "liters"
- `milkingFrequency` (number) - Times per day (typically 2)
- `milkQuality` (string) - "Normal", "Abnormal" (color, consistency issues)
- `notes` (string)
- `recordedBy` (string) - userId
- `createdAt` (timestamp)

**Aggregated fields (calculated):**
- Daily total
- Weekly total
- Monthly total
- Yearly total
- Average per milking

---

**animals/{animalId}/services**
Records various services performed.

**Fields:**
- `serviceId` (string) - Unique identifier
- `serviceDate` (timestamp)
- `serviceType` (string) - "Vaccination", "Castration", "Dehorning", "Pregnancy Check", "Hormone Treatment", "Other"
- `providerId` (string) - veterinarianId or blacksmithId
- `providerName` (string)
- `description` (string) - Details of service
- `products` (array of objects) - Medications/products used
  - `name` (string)
  - `dosage` (string)
  - `manufacturer` (string)
- `cost` (number)
- `nextServiceDue` (timestamp) - For recurring services
- `results` (string) - Outcome of service
- `complications` (string)
- `notes` (string)
- `recordedBy` (string) - userId
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

---

**animals/{animalId}/blacksmithVisits**
Records farrier/blacksmith visits.

**Fields:**
- `visitId` (string) - Unique identifier
- `visitDate` (timestamp)
- `blacksmithId` (string) - Reference to blacksmith
- `blacksmithName` (string)
- `serviceType` (string) - "Trim", "Shoe", "Reset", "Corrective"
- `hoofCondition` (object)
  - `frontLeft` (string)
  - `frontRight` (string)
  - `backLeft` (string)
  - `backRight` (string)
- `workPerformed` (string) - Details of work
- `shoeType` (string) - If shoeing
- `cost` (number)
- `nextVisitDue` (timestamp)
- `notes` (string)
- `recordedBy` (string) - userId
- `createdAt` (timestamp)

---

**animals/{animalId}/movementRecords**
Tracks movements between farms.

**Fields:**
- `movementId` (string) - Unique identifier
- `movementDate` (timestamp)
- `fromFarmId` (string)
- `fromFarmName` (string)
- `toFarmId` (string)
- `toFarmName` (string)
- `reason` (string) - Reason for transfer
- `transportMethod` (string)
- `movedBy` (string) - userId who initiated move
- `approvedBy` (string) - Manager/Owner who approved
- `notes` (string)
- `createdAt` (timestamp)

---

**animals/{animalId}/feedingRecords**
Records feeding information.

**Fields:**
- `feedingId` (string) - Unique identifier
- `feedingDate` (timestamp)
- `feedId` (string) - Reference to feed type
- `feedName` (string)
- `amount` (number)
- `unit` (string) - "lbs", "kg", "flakes", "scoops"
- `feedingTime` (string) - "Morning", "Midday", "Evening"
- `notes` (string)
- `recordedBy` (string) - userId
- `createdAt` (timestamp)

---

**animals/{animalId}/documents**
Stores uploaded documents for the animal.

**Fields:**
- `documentId` (string) - Unique identifier
- `documentName` (string)
- `documentType` (string) - "Registration", "Health Record", "Image", "Other"
- `fileUrl` (string) - Firebase Storage URL
- `fileSize` (number) - In bytes
- `mimeType` (string)
- `uploadedBy` (string) - userId
- `description` (string)
- `tags` (array of strings) - For organization
- `uploadDate` (timestamp)

---

**animals/{animalId}/scheduledServices**
Tracks upcoming appointments and scheduled services.

**Fields:**
- `scheduleId` (string) - Unique identifier
- `serviceType` (string) - "Vaccination", "Blacksmith", "Vet Visit", "Pregnancy Check", "Other"
- `scheduledDate` (timestamp)
- `providerId` (string) - veterinarianId or blacksmithId
- `providerName` (string)
- `description` (string)
- `status` (string) - "Scheduled", "Completed", "Cancelled", "Rescheduled"
- `completedDate` (timestamp)
- `reminderSent` (boolean)
- `notes` (string)
- `createdBy` (string) - userId
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

---

**animals/{animalId}/incidentReports**
Records incident reports submitted to veterinarians.

**Fields:**
- `incidentId` (string) - Unique identifier
- `incidentDate` (timestamp) - When incident occurred
- `reportedDate` (timestamp) - When report was submitted
- `incidentType` (string) - "Injury", "Illness", "Lameness", "Behavioral", "Emergency", "Other"
- `severity` (string) - "Low", "Medium", "High", "Critical"
- `description` (string) - Farmer's description of incident
- `symptoms` (array of strings) - Observable symptoms
- `photos` (array of strings) - URLs to incident photos
- `location` (string) - Location on animal's body (if applicable)
- `veterinarianId` (string) - Vet the report was sent to
- `veterinarianName` (string)
- `status` (string) - "Submitted", "Acknowledged", "In Review", "Responded", "Resolved"
- `vetResponse` (string) - Veterinarian's response/recommendations
- `vetResponseDate` (timestamp)
- `treatmentRecommendation` (string)
- `urgencyLevel` (string) - "Can Wait", "Soon", "Urgent", "Emergency"
- `followUpRequired` (boolean)
- `followUpDate` (timestamp)
- `linkedHealthRecordId` (string) - Auto-created health record
- `reportedBy` (string) - userId
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

---

#### **Provider Subcollections**

**feedSuppliers/{supplierId}/orders**
Tracks feed orders from suppliers.

**Fields:**
- `orderId` (string) - Unique identifier
- `orderDate` (timestamp)
- `farmId` (string) - Farm placing the order
- `items` (array of objects)
  - `feedId` (string)
  - `feedName` (string)
  - `quantity` (number)
  - `unit` (string)
  - `pricePerUnit` (number)
  - `totalPrice` (number)
- `orderTotal` (number)
- `deliveryDate` (timestamp)
- `deliveryStatus` (string) - "Pending", "Delivered", "Cancelled"
- `deliveryAddress` (string)
- `invoiceNumber` (string)
- `paymentStatus` (string) - "Pending", "Paid", "Partial"
- `notes` (string)
- `orderedBy` (string) - userId
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

---

**breedingStock/{stockId}/breedings**
Tracks breeding events using this breeding stock.

**Fields:**
- `breedingId` (string) - Unique identifier
- `breedingDate` (timestamp)
- `damId` (string) - Reference to female animal
- `damName` (string)
- `farmId` (string) - Farm where breeding occurred
- `method` (string) - "Natural", "AI"
- `outcome` (string) - "Pregnant", "Open", "Pending"
- `expectedDueDate` (timestamp)
- `actualBirthDate` (timestamp)
- `offspringCount` (number)
- `offspringIds` (array of strings) - References to offspring
- `notes` (string)
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

## 6. Core Features (Minimum Viable Product)

The initial version of the application will focus on the following key features:

- **Dashboard**: A landing page displaying key metrics and important information about animals.
  - **Overview Metrics** (across all farms owned):
    - Total number of animals by species
    - Number of pregnant animals by species
    - Number of currently lactating animals (being milked)
    - Number of sick animals
    - Number of animals by gender/type
    - **Top milk producers** (this month/year)
    - **Average milk production** per species
  - **Farm-Specific View**: Same metrics filtered by individual farm
  - Ability to toggle between complete ownership view and individual farm view
  - **Filtering Options**: Filter animals by species, farm, gender/type, or any combination
  - **Animal List Display**:
    - Shows all animals with key information
    - For pregnant animals: displays estimated birthing date
    - For lactating animals: displays current lactation status
    - Clickable to view detailed animal profile

- **User Authentication**: Secure login and logout functionality.

- **Offline Mode** (Mobile Apps):
  - Full functionality in areas without cellular signal using SQLite local storage
  - Automatic data synchronization when connection is restored
  - Conflict resolution for data modified while offline
  - Visual indicators showing online/offline status and pending sync items

- **Animal Management**: Create, read, update, and delete (CRUD) operations for animal profiles.
  - Profile includes: species, age category, gender/type, current farm assignment
  - Show animal designation (important for udder protection and registration tracking)
  - Photo upload for animal avatar
  - Document uploads (registration papers, health records, images, supporting docs)

- **Health & Medical Records**:
  - Logging of general health events and observations
  - Medication tracking (OTC and prescription) with role-based permissions
  - Treatment records
  - Service tracking: routine shots, castration, dehorning, pregnancy checks, hormone treatments

- **Breeding Management**:
  - Recording breeding events (Natural or AI)
  - Reference breeding stock (bulls/sires/bucks) from external sources
  - Tracking breeding status (Bred or Open)
  - Heat cycle monitoring
  - Birthing schedule with expected due dates
  - Weaning schedule and methods
  - **Bloodline tracking and inbreeding prevention**

- **Service Provider Management**:
  - Blacksmith/Farrier visit logging
  - Veterinary service records
  - **Service Scheduling**: Track upcoming and scheduled services (vaccinations, pregnancy checks, blacksmith visits, etc.)

- **Incident Reporting**:
  - Capture photos of animal incidents/injuries
  - Write description and urgent notes
  - Send incident report directly to veterinarian on file
  - Automatically creates health record entry
  - Track incident status and vet response

- **Provider Consortium Access** (Future - Post-MVP):
  - Browse available providers by type and specialization
  - View provider profiles, ratings, and reviews
  - Request telemedicine consultations
  - Schedule video appointments
  - Upload photos and describe issues before consultation
  - Receive consultation notes and treatment plans
  - Rate and review consultations
  - Schedule on-site visits when needed
  - Track consultation history

- **Provider Management**:
  - Manage contact information for veterinarians, blacksmiths, and feed suppliers
  - Manage breeding stock (bulls/sires/bucks) with genetics and lease terms
  - Track feed supplier pricing, orders, and delivery schedules
  - Link providers to service records

- **User Management** (Owner and Manager roles):
  - Add and remove users from farm assignments
  - Assign roles to users (Manager, Lead, Farm Hand)
  - **User Licensing**: Each user assignment requires a license billed to the owner
  - Multi-owner users require separate licenses from each owner
  - View all licensed users and their assignments

- **Subscription & Billing Management** (Owner only):
  - View current subscription status
  - View licensed user count and monthly charges
  - Manage payment method
  - View billing history
  - Add/remove user licenses (by assigning/removing users)
  - Automatic billing calculation: Base ($5) + (Number of users × $5)

- **Logistics & Feeding**:
  - Tracking the current farm location for each animal.
  - Recording all animal movements between farms.
  - Logging feed types and amounts for each animal.

## 7. Future Features (Roadmap)

Once the core features are complete, the following can be added to the roadmap:

- **Provider Consortium & Telemedicine Platform**:

  **Provider Registration & Credentialing:**
  - Comprehensive 5-step registration process
  - Credential verification (license, education, insurance, ID)
  - Digital attestation with legal signature
  - Automated verification where possible (license APIs, identity services)
  - Annual re-verification with expiration tracking
  - Status management: pending, verified, expired, suspended, rejected
  - Platform orientation and training for new providers

  **Provider Types Supported:**
  - Veterinarians (general practice and specialists)
  - Animal Nutritionists
  - Farriers/Hoof Care Specialists
  - Breeding Consultants
  - Equine Dentists
  - Livestock Behaviorists
  - Reproduction Specialists
  - Farm Business Consultants (future)
  - Agricultural Extension Agents (future)

  **Pricing Model:**
  - Provider membership: FREE first month, then $5/month (or $50/year)
  - Platform fee: 10% on telemedicine consultations
  - No platform fee on in-person visits scheduled through platform
  - Platform-dictated base pricing ensures fairness:
    - Quick consultation (15 min): $35
    - Video consultation (30 min): $65
    - Emergency consultation: $125
    - Follow-up (15 min): $25
  - Experience premium: Board certified providers can add $15-25
  - No geographic pricing - same rates nationwide

  **Video Consultations:**
  - Real-time video/audio for remote diagnosis and treatment guidance
  - Text and photo consultations for quick questions
  - Screen sharing for reviewing records/test results
  - Recording capability (with consent) for documentation

  **On-Site Visit Scheduling:**
  - Providers can schedule in-person visits after consultations
  - Platform manages engagement with automated notifications
  - Reminders: 7 days, 1 day, 2 hours before visit
  - Both parties coordinate directly for visit
  - Post-visit documentation and ratings
  - No platform fee on in-person visits
  - Data collection for analytics and ML training

  **Data Collection & Analytics:**
  - Track telemedicine → in-person conversion rates
  - Service type demand patterns
  - Geographic service gaps identification
  - Provider performance metrics
  - Condition severity predictions (ML training)
  - Cost analysis by service and region
  - Follow-up consultation patterns

  **Rating & Review System:**
  - Farmers rate consultations and on-site visits
  - Providers rate farmer interactions
  - Quality control: <4.0 rating triggers review
  - <3.5 rating results in suspension pending improvement
  - Public ratings visible to farmers choosing providers

  **Billing Integration:**
  - Payment processing for telemedicine consultations
  - Stripe/payment processor integration
  - Automatic 90/10 split (provider/platform)
  - Monthly provider membership billing
  - Direct payment for on-site visits (outside platform)

  **Response Time Requirements:**
  - Standard consultations: Respond within 24 hours
  - Emergency consultations: Respond within 2 hours
  - Missing 3+ scheduled appointments = automatic suspension

  **Provider Tools:**
  - Consultation scheduling and calendar management
  - Patient/animal history access
  - Prescription management (for vets)
  - Follow-up scheduling automation
  - Earnings dashboard and analytics
  - Customer management (repeat clients)

  **Queue & Distribution System:**
  - Weighted queue algorithm for fair provider distribution
  - Scoring based on: time since last consult, acceptance rate, helpfulness, specialization match
  - Presents top 3 providers to farmer for selection
  - New providers get opportunities while quality providers surface naturally

  **Favorite Providers:**
  - Farmers can mark providers as favorites after first consultation
  - Direct request option to favorite providers (2-hour window)
  - Builds provider-farmer relationships and continuity of care
  - Providers see how many farmers have favorited them

  **Feedback System:**
  - Binary feedback: "Was this helpful?" and "Would you return?"
  - Optional text comments
  - Provider sees helpfulness rate and return rate
  - Quality control triggers for providers below 70% helpfulness
  - "Report Concern" option for serious issues

  **Session Recording & Transcription:**
  - Video recording with mutual consent
  - Real-time audio-to-text transcription
  - Key term extraction (diagnoses, medications)
  - Free 90-day retention, premium archive options
  - Download capability for offline storage
  - Transcript kept permanently (minimal cost)

  **Provider-Client Messaging:**
  - Secure messaging between providers and farmers
  - Available during consultations and for follow-ups
  - Photo and document sharing
  - Message threads organized by consultation and animal
  - 1-year message retention with export option

  **Provider Client Management:**
  - "My Clients" dashboard for providers
  - View all clients, animals treated, consultation history
  - Private notes per client/animal (only provider can see)
  - Reminders and follow-up tracking
  - Search and filter capabilities
  - Builds provider's practice within platform

  **Data Retention Policy:**
  - 90-day free video storage (platform absorbs cost)
  - Premium archive: $2.99/year per video or $9.99/month unlimited
  - Permanent transcript and health record storage
  - Automatic deletion with advance warnings
  - Full data export for farmers and providers

- **Veterinarian Portal**: Allow veterinarians to log in and directly enter service records and prescriptions.

- **Automated Alerts**: Send push notifications for upcoming appointments (e.g., vet visits) or breeding cycles.

- **Reporting & Analytics**: 
  - Generate reports on breeding success rates, health trends, and feed consumption analysis.
  - **Milk production analytics**: Track high producers, compare performance across animals, identify valuable breeding stock based on production history.
  - Offspring value prediction based on parent milk production.

- **Mobile App**: Develop a native mobile application to allow for on-the-go data entry and access.
