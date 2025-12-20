# Farm Animal Tracker (FAT APP) - Documentation

This directory contains all the documentation for the Farm Animal Tracker application.

## 📋 Documentation Index

### Planning & Design
- **[Project_Plan.md](Project_Plan.md)** - Complete project plan including:
  - Project goals and business model
  - Membership & organizational structure
  - Animal categories and classifications
  - Health management and services
  - Provider management
  - Technology stack
  - **Complete database schema with field definitions**
  - Core features and roadmap
- **[CLAUDE_CLI_INSTRUCTIONS.md](CLAUDE_CLI_INSTRUCTIONS.md)** - Documentation management guidelines for Claude CLI

### Firebase Setup
- **[Firebase_Setup_Guide.md](Firebase_Setup_Guide.md)** - Step-by-step Firebase configuration guide
- **[firestore.rules](firestore.rules)** - Firestore security rules (role-based access control)
- **[storage.rules](storage.rules)** - Firebase Storage security rules (file upload rules)
- **[firebase.json](firebase.json)** - Firebase project configuration
- **[firestore.indexes.json](firestore.indexes.json)** - Database indexes for optimal query performance

## 🚀 Quick Start

### For Developers Setting Up the Environment:

1. **Read the Project Plan** first to understand the application structure
2. **Follow the Firebase Setup Guide** to configure Firebase services
3. **Deploy security rules** using the provided configuration files
4. **Reference the database schema** when building data models

### For Claude CLI:

When setting up the development environment or working on features, reference:
- Database schema in `Project_Plan.md` (Section 5) for field definitions
- Security rules in `firestore.rules` for permission logic
- Firebase configuration files for deployment

## 📊 Database Schema Quick Reference

The complete schema is in `Project_Plan.md`, but here's a quick overview:

### Top-Level Collections (18):
- `owners` - Account holders with billing information
- `users` - User profiles with farm role assignments (includes favoriteProviders)
- `licenses` - User licenses billed to owners
- `farms` - Farm information and settings
- `animals` - Animal profiles (main collection)
- `veterinarians` - Vet contact information
- `blacksmiths` - Farrier/blacksmith contacts
- `feedSuppliers` - Feed supplier information
- `breedingStock` - External bulls/sires/bucks for breeding
- `providers` - Provider consortium members (vets, nutritionists, farriers, etc.)
- `providerCredentials` - Credential verification documents
- `providerAttestations` - Digital attestation signatures
- `consultations` - Telemedicine consultation sessions with binary feedback and recording
- `onSiteVisits` - In-person visits scheduled through platform
- `providerEarnings` - Provider earnings tracking
- `messages` - Provider-client messaging with 1-year retention
- `providerNotes` - Provider's private notes on clients/animals
- `feed` - Feed types and nutritional info

### Animal Subcollections (12):
- `healthRecords` - General health events
- `medications` - Medication tracking
- `breedingEvents` - Breeding records
- `birthRecords` - Birth and offspring information
- `weaningSchedules` - Weaning information
- `lactationRecords` - Milk production tracking
- `services` - Veterinary and other services
- `blacksmithVisits` - Farrier visits
- `movementRecords` - Farm-to-farm transfers
- `feedingRecords` - Daily feeding logs
- `documents` - File uploads (registration, health records, images)
- `scheduledServices` - Upcoming appointments
- `incidentReports` - Incident reports to vets

### Provider Subcollections (2):
- `feedSuppliers/{supplierId}/orders` - Order history
- `breedingStock/{stockId}/breedings` - Breeding history

## 🔐 Role-Based Permissions

| Role | Create Farms | Manage Animals | Manage Providers | Move Animals | Read Only |
|------|-------------|----------------|-----------------|--------------|-----------|
| **Owner** | ✓ | ✓ | ✓ | ✓ | - |
| **Manager** | - | ✓ | ✓ | ✓ | - |
| **Lead** | - | ✓ | - | - | - |
| **Farm Hand** | - | - | - | - | ✓ |

## 🎯 Key Features

### MVP Features:
- Dashboard with filtering and metrics
- Offline mode for rural areas (SQLite + Firestore sync)
- Animal management (CRUD + tracking)
- Health & medical records
- Breeding management with bloodline tracking
- Lactation tracking for dairy animals
- Service scheduling
- Provider management
- Incident reporting to veterinarians
- Document management with file uploads

### Future Features:
- Multi-Factor Authentication (MFA)
- Provider consortium marketplace with telemedicine
  - Veterinarians, nutritionists, farriers, breeding consultants, and more
  - Comprehensive credentialing and verification system
  - Video consultations with competitive pricing ($35-$125)
  - Weighted queue system for fair provider distribution
  - Favorite providers feature for direct requests
  - Binary feedback system ("Was helpful?" / "Would return?")
  - Session recording with transcription (90-day free retention)
  - Premium video archives ($2.99/year or $9.99/month unlimited)
  - Provider-client messaging system
  - Provider client management dashboard with private notes
  - On-site visit scheduling with automated notifications
  - 10% platform fee (providers keep 90%)
- Machine Learning predictive analytics (3 phases)
- Advanced analytics and reporting
- Automated alerts and notifications

## 💰 Business Model

- **Primary**: User licensing at $5/month per user per owner
  - Each user assigned to a farm requires a separate license
  - Multi-owner users billed separately to each owner
- **Future**: Provider marketplace revenue
  - 10% platform fee on telemedicine consultations
  - $5/month provider membership (free first month)
  - 0% fee on in-person visits (data collection value)
- **Future**: Premium video archive revenue
  - $2.99/year per consultation video archive
  - $9.99/month unlimited video archive subscription
  - Free 90-day retention (platform absorbs cost)
- **Future**: Premium ML features as optional add-on
- **Future**: Anonymized data insights for agricultural research

## 🛠️ Technology Stack

- **Frontend**: Flutter (Web, Android, iOS)
- **Backend**: Firebase (Cloud Functions, FCM)
- **Database**: Cloud Firestore + SQLite (offline)
- **Storage**: Firebase Storage
- **Authentication**: Firebase Authentication
- **Payment Processing**: Stripe (future)
- **Video & Transcription**: WebRTC, Google Speech-to-Text API (future)

## 📱 Target Platforms

- Web (primary)
- Android mobile
- iOS mobile

All from a single Flutter codebase.

## 🌐 Offline Support

Critical for rural farm operations:
- Full offline functionality using SQLite
- Automatic sync when connection restored
- Conflict resolution for offline changes
- Visual sync status indicators

## 🔄 Development Workflow

1. **Planning** - Reference `Project_Plan.md` for requirements
2. **Firebase Setup** - Follow `Firebase_Setup_Guide.md`
3. **Local Development** - Use Firebase Emulators
4. **Testing** - Test with emulators before production
5. **Deployment** - Deploy rules and code separately

## 📞 Support & Resources

- Firebase Documentation: https://firebase.google.com/docs
- FlutterFire Documentation: https://firebase.flutter.dev
- Flutter Documentation: https://flutter.dev/docs

---

**Last Updated**: December 2024  
**Project Status**: Planning & Setup Phase  
**Next Phase**: Flutter project structure and data models
