import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/farm.dart';

class FarmService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new farm
  Future<Farm> createFarm({
    required String ownerId,
    required String name,
    required String farmType,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? country,
  }) async {
    final farmRef = _firestore.collection('farms').doc();

    final farm = Farm(
      farmId: farmRef.id,
      ownerId: ownerId,
      name: name,
      address: address,
      city: city,
      state: state,
      zipCode: zipCode,
      country: country ?? 'USA',
      farmType: farmType,
      stats: {
        'totalAnimals': 0,
        'horses': 0,
        'cattle': 0,
        'goats': 0,
        'sheep': 0,
        'donkeys': 0,
        'pregnant': 0,
        'sick': 0,
      },
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      createdBy: ownerId,
      updatedBy: ownerId,
    );

    await farmRef.set(farm.toFirestore());

    // Update user's roles to include Owner role for this farm
    await _firestore.collection('users').doc(ownerId).set({
      'roles': {
        farmRef.id: 'owner',
      },
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return farm;
  }

  // Get all farms for a user (owner or team member)
  Stream<List<Farm>> getUserFarms(String userId) {
    return _firestore
        .collection('farms')
        .where('ownerId', isEqualTo: userId)
        .where('isDeleted', isEqualTo: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Farm.fromFirestore(doc)).toList());
  }

  // Get farms where user is a team member
  Future<List<Farm>> getTeamMemberFarms(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    final roles = userDoc.data()?['roles'] as Map<String, dynamic>? ?? {};

    final List<Farm> farms = [];
    for (String farmId in roles.keys) {
      final farmDoc = await _firestore.collection('farms').doc(farmId).get();
      if (farmDoc.exists && farmDoc.data()?['isDeleted'] != true) {
        farms.add(Farm.fromFirestore(farmDoc));
      }
    }
    return farms;
  }

  // Update farm details
  Future<void> updateFarm(String farmId, Map<String, dynamic> updates) async {
    updates['updatedAt'] = FieldValue.serverTimestamp();
    await _firestore.collection('farms').doc(farmId).update(updates);
  }

  // Soft delete farm
  Future<void> deleteFarm(String farmId, String userId) async {
    await _firestore.collection('farms').doc(farmId).update({
      'isDeleted': true,
      'deletedAt': FieldValue.serverTimestamp(),
      'deletedBy': userId,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Get single farm
  Future<Farm?> getFarm(String farmId) async {
    final doc = await _firestore.collection('farms').doc(farmId).get();
    if (doc.exists) {
      return Farm.fromFirestore(doc);
    }
    return null;
  }

  // Get user role for a farm
  Future<String?> getUserRoleForFarm(String userId, String farmId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    final roles = userDoc.data()?['roles'] as Map<String, dynamic>? ?? {};
    return roles[farmId];
  }

  // Invite user to farm
  Future<void> inviteUserToFarm({
    required String farmId,
    required String email,
    required String role,
    required String invitedBy,
  }) async {
    final invitationRef = _firestore.collection('invitations').doc();

    await invitationRef.set({
      'invitationId': invitationRef.id,
      'farmId': farmId,
      'email': email.toLowerCase(),
      'role': role,
      'invitedBy': invitedBy,
      'status': 'pending',
      'expiresAt': Timestamp.fromDate(
        DateTime.now().add(const Duration(days: 7)),
      ),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Get pending invitations for email
  Future<List<Map<String, dynamic>>> getPendingInvitations(String email) async {
    final snapshot = await _firestore
        .collection('invitations')
        .where('email', isEqualTo: email.toLowerCase())
        .where('status', isEqualTo: 'pending')
        .get();

    final List<Map<String, dynamic>> invitations = [];
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final expiresAt = (data['expiresAt'] as Timestamp).toDate();

      if (expiresAt.isAfter(DateTime.now())) {
        // Get farm details
        final farmDoc = await _firestore.collection('farms').doc(data['farmId']).get();
        if (farmDoc.exists) {
          invitations.add({
            ...data,
            'farmName': farmDoc.data()?['name'],
          });
        }
      }
    }
    return invitations;
  }

  // Accept invitation
  Future<void> acceptInvitation(String invitationId, String userId) async {
    final invitationDoc = await _firestore.collection('invitations').doc(invitationId).get();
    final data = invitationDoc.data();

    if (data != null) {
      final farmId = data['farmId'];
      final role = data['role'];

      // Add user to farm team
      await _firestore.collection('users').doc(userId).set({
        'roles': {
          farmId: role,
        },
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Update invitation status
      await _firestore.collection('invitations').doc(invitationId).update({
        'status': 'accepted',
        'acceptedBy': userId,
        'acceptedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Remove user from farm
  Future<void> removeUserFromFarm(String userId, String farmId) async {
    await _firestore.collection('users').doc(userId).update({
      'roles.$farmId': FieldValue.delete(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Update user role on farm
  Future<void> updateUserRole(String userId, String farmId, String newRole) async {
    await _firestore.collection('users').doc(userId).update({
      'roles.$farmId': newRole,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Get farm team members
  Future<List<Map<String, dynamic>>> getFarmTeamMembers(String farmId) async {
    final usersSnapshot = await _firestore.collection('users').get();

    final List<Map<String, dynamic>> teamMembers = [];
    for (var doc in usersSnapshot.docs) {
      final roles = doc.data()['roles'] as Map<String, dynamic>? ?? {};
      if (roles.containsKey(farmId)) {
        teamMembers.add({
          'userId': doc.id,
          'displayName': doc.data()['displayName'] ?? 'Unknown',
          'email': doc.data()['email'] ?? '',
          'photoURL': doc.data()['photoURL'],
          'role': roles[farmId],
        });
      }
    }
    return teamMembers;
  }
}
