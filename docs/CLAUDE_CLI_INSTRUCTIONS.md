# Claude CLI - Documentation Management Instructions

This document provides guidelines for Claude CLI when updating project documentation for the FAT APP (Farm Animal Tracker Application).

## Documentation Structure

All project documentation is located in the `docs/` directory:

```
docs/
├── README.md                    # Master index and quick reference
├── Project_Plan.md              # Complete project specification (PRIMARY DOCUMENT)
├── Firebase_Setup_Guide.md      # Step-by-step Firebase setup
├── firestore.rules              # Security rules for Firestore
├── storage.rules                # Security rules for Storage
├── firebase.json                # Firebase configuration
├── firestore.indexes.json       # Database indexes
└── CLAUDE_CLI_INSTRUCTIONS.md   # This file
```

## Primary Documentation: Project_Plan.md

The `Project_Plan.md` is the **single source of truth** for the project. All requirements, specifications, and design decisions should be documented here.

### Document Sections (in order):

1. **Project Goal** - High-level objectives
2. **Business Model** (1A) - Revenue streams and pricing
3. **Membership & Organizational Structure** (2) - User roles, permissions, authentication
4. **Animal Categories & Classifications** (3) - Species, age categories, gender types
5. **Animal Services & Health Management** (3A) - Medical, breeding, lactation tracking
6. **Providers & External Resources** (3B) - Service providers, breeding stock
7. **Technology Stack** (4) - Flutter, Firebase, SQLite
8. **Database Schema** (5) - Complete field definitions for all collections
9. **Core Features (MVP)** (6) - Features for initial release
10. **Future Features (Roadmap)** (7) - Post-MVP features

## Update Guidelines

### When to Update Project_Plan.md

Update this document when:
- New features are added or changed
- Database schema changes (new collections, fields, or relationships)
- Business rules or permissions change
- User flows or authentication methods change
- Technology stack changes
- Requirements are clarified or refined

### How to Update Project_Plan.md

**Step 1: Identify the Correct Section**
- Read the user's request carefully
- Determine which section(s) need updates
- Check if new sections are needed

**Step 2: Make Precise Updates**
- Use `str_replace` to update existing content
- Preserve formatting and structure
- Keep consistent markdown style
- Maintain section numbering

**Step 3: Update Related Sections**
- If database schema changes, update both:
  - Section 5 (Database Schema)
  - Section 6 (Core Features) if it affects features
- If roles/permissions change, update:
  - Section 2 (Membership & Organizational Structure)
  - firestore.rules file

**Step 4: Verify Consistency**
- Ensure all references to the updated content are consistent across sections
- Check that database field names match in schema and features sections
- Verify security rules align with permission requirements

### Firebase Configuration Files

When updating Firebase-related documentation:

**firestore.rules**
- Update when role permissions change
- Update when new collections are added
- Ensure rules match the database schema
- Test rules before deploying

**storage.rules**
- Update when file upload requirements change
- Update when new file types are supported
- Verify file size limits

**firestore.indexes.json**
- Add indexes when new complex queries are introduced
- Update when dashboard or filtering requirements change

**Firebase_Setup_Guide.md**
- Update when new Firebase services are added
- Update when setup steps change
- Keep package versions current

## Common Update Patterns

### Adding a New Database Collection

1. Add to Section 5 → Top-Level Collections
2. Define all fields with types and descriptions
3. Add to firestore.rules with appropriate permissions
4. Add indexes if needed in firestore.indexes.json
5. Update Core Features section if this enables new functionality

### Adding a New Feature

1. Determine if it's MVP (Section 6) or Future (Section 7)
2. Add feature description with bullet points
3. Update Database Schema if new collections/fields needed
4. Update security rules if permissions required
5. Update Technology Stack if new packages needed

### Changing User Permissions

1. Update Section 2 → User Roles
2. Update firestore.rules to match new permissions
3. Update Section 6 → Core Features if user workflows change

### Adding Animal-Related Fields

1. Update Section 3, 3A, or 3B as appropriate
2. Update Section 5 → animals collection fields
3. Update Section 6 if this affects features (e.g., dashboard metrics)
4. Add to firestore.indexes.json if field is used for filtering

## Formatting Standards

### Markdown Style

**Headers:**
- Use `##` for main sections (numbered)
- Use `###` for subsections
- Use `####` for collection/entity names in schema

**Lists:**
- Use `-` for unordered lists
- Use `1.` for ordered lists
- Indent with 2 spaces for nested items

**Code/Fields:**
- Use backticks for field names: `fieldName`
- Use code blocks for configuration examples

**Emphasis:**
- Use `**bold**` for important terms, field categories
- Use `*italic*` sparingly
- Use `✅` for completed items
- Use `---` for horizontal rules between schema entities

### Database Schema Format

Each collection should follow this template:

```markdown
#### **collectionName**
Brief description of what this collection stores.

**Fields:**
- `fieldName` (dataType) - Description of field
- `anotherField` (dataType) - Description
  - For objects/arrays, indent nested structure
  - `nestedField` (dataType)

---
```

### Feature Description Format

```markdown
- **Feature Name**:
  - Sub-feature or capability
  - Another sub-feature
  - **Important detail** in bold
```

## Collaboration with User

### When User Adds Requirements

1. **Acknowledge** the new requirement
2. **Ask clarifying questions** if needed:
   - "Should this be MVP or Future?"
   - "Which user roles can access this?"
   - "What fields do we need to track?"
3. **Show what will be updated** before making changes
4. **Make the updates** using str_replace
5. **Confirm completion** and present updated file

### When User Changes Requirements

1. **Identify all affected sections**
2. **Explain the impact** of the change
3. **Update consistently** across all affected areas
4. **Verify no conflicts** with existing design

### When User Asks Questions

1. **Reference the documentation** to answer
2. **Quote specific sections** when relevant
3. **Suggest updates** if documentation is unclear
4. **Update docs** if answer reveals missing information

## Version Control Best Practices

### Making Updates

- Make atomic changes (one logical update at a time)
- Update all related sections in the same operation
- Test str_replace patterns before applying
- Always present updated files to user

### Avoiding Errors

- Always use `view` to check current content before str_replace
- Use unique, specific strings for str_replace
- If str_replace fails, view the section and try again with exact text
- Never assume content - always verify

## Common Mistakes to Avoid

❌ **Don't:**
- Update only one section when multiple sections are affected
- Use generic strings in str_replace that might match multiple places
- Forget to update security rules when permissions change
- Add features without updating database schema
- Change section numbering without updating all references

✅ **Do:**
- Update all related sections consistently
- Use specific, unique strings in str_replace
- Update security rules with permission changes
- Add database fields when adding features
- Maintain consistent section numbering

## Special Considerations

### Dairy Animal Features
- Lactation tracking is critical for animal valuation
- Milk production amounts are measured per session
- Lactation rounds only count when actively milked (not nursing)
- Nursing can deform udders (critical for show animals)

### Rural/Offline Support
- Offline functionality is essential for rural areas
- SQLite for local storage on mobile
- Automatic sync when connection restored
- File uploads must queue when offline

### Multi-Tenant Architecture
- Owner → Farms → Users hierarchy must be maintained
- One animal can only be assigned to one farm at a time
- Users can belong to multiple owner accounts
- Each owner must separately license any user assigned to their farms
- User licensing is billed per owner, not per user globally
- Example: Same user working for 2 owners = 2 licenses billed (one to each owner)
- Role-based permissions are strictly enforced

### Incident Reporting
- Critical feature for rural farmers without regular vet access
- Photos captured offline must sync when online
- Future: Vet consortium marketplace with telemedicine

### Provider Consortium
- Credentialing process leads to future separate web application
- Automate verification as much as possible (license APIs, identity services)
- 10% platform fee on telemedicine (very competitive)
- No platform fee on in-person visits (builds goodwill, enables data collection)
- Same pricing nationwide - no geographic pricing (benefit for rural farmers)
- On-site visit scheduling manages notifications automatically
- Data collection from consultations and visits feeds ML training
- Provider types must provide value via video consultation
- Annual re-verification required for all credentials

## Questions to Ask When Updating

Before making updates, consider:

1. **Scope**: Is this MVP or Future feature?
2. **Permissions**: Which roles can access this?
3. **Data**: What database fields are needed?
4. **Impact**: What other sections are affected?
5. **Security**: Do firestore.rules need updates?
6. **Offline**: Does this need offline support?
7. **Platform**: Web, mobile, or both?

## Emergency Recovery

If documentation gets inconsistent:

1. Stop making changes
2. Review all affected sections
3. Identify conflicts or inconsistencies
4. Create a plan to fix all sections
5. Make coordinated updates to restore consistency
6. Verify with user

## Summary

The key principle: **Keep Project_Plan.md as the single source of truth, and keep all documentation consistent with it.**

When in doubt:
1. Ask the user for clarification
2. Reference existing documentation
3. Make updates systematically
4. Verify consistency across all files
5. Present changes for user review

---

**Last Updated**: December 2024
**Maintained By**: Claude CLI
**Purpose**: Ensure high-quality, consistent project documentation
