import 'package:flutter/foundation.dart';
import '../models/farm.dart';
import '../core/services/farm_service.dart';

class FarmProvider with ChangeNotifier {
  final FarmService _farmService = FarmService();

  List<Farm> _farms = [];
  Farm? _selectedFarm;
  bool _isLoading = false;
  String? _errorMessage;

  List<Farm> get farms => _farms;
  Farm? get selectedFarm => _selectedFarm;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasFarms => _farms.isNotEmpty;

  // Load user's farms
  Future<void> loadUserFarms(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Get owned farms
      _farmService.getUserFarms(userId).listen((farms) {
        _farms = farms;
        if (_selectedFarm == null && _farms.isNotEmpty) {
          _selectedFarm = _farms.first;
        }
        _isLoading = false;
        notifyListeners();
      });

      // Also get team member farms
      final teamFarms = await _farmService.getTeamMemberFarms(userId);
      _farms.addAll(teamFarms);

      if (_selectedFarm == null && _farms.isNotEmpty) {
        _selectedFarm = _farms.first;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load farms';
      notifyListeners();
    }
  }

  // Create new farm
  Future<bool> createFarm({
    required String ownerId,
    required String name,
    required String farmType,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? country,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final farm = await _farmService.createFarm(
        ownerId: ownerId,
        name: name,
        farmType: farmType,
        address: address,
        city: city,
        state: state,
        zipCode: zipCode,
        country: country,
      );

      _farms.add(farm);
      _selectedFarm = farm;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to create farm';
      notifyListeners();
      return false;
    }
  }

  // Update farm
  Future<bool> updateFarm(String farmId, Map<String, dynamic> updates) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _farmService.updateFarm(farmId, updates);

      final index = _farms.indexWhere((f) => f.farmId == farmId);
      if (index != -1) {
        final updatedFarm = await _farmService.getFarm(farmId);
        if (updatedFarm != null) {
          _farms[index] = updatedFarm;
          if (_selectedFarm?.farmId == farmId) {
            _selectedFarm = updatedFarm;
          }
        }
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to update farm';
      notifyListeners();
      return false;
    }
  }

  // Delete farm
  Future<bool> deleteFarm(String farmId, String userId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _farmService.deleteFarm(farmId, userId);

      _farms.removeWhere((f) => f.farmId == farmId);
      if (_selectedFarm?.farmId == farmId) {
        _selectedFarm = _farms.isNotEmpty ? _farms.first : null;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to delete farm';
      notifyListeners();
      return false;
    }
  }

  // Select farm
  void selectFarm(Farm farm) {
    _selectedFarm = farm;
    notifyListeners();
  }

  // Invite user to farm
  Future<bool> inviteUser({
    required String farmId,
    required String email,
    required String role,
    required String invitedBy,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _farmService.inviteUserToFarm(
        farmId: farmId,
        email: email,
        role: role,
        invitedBy: invitedBy,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to send invitation';
      notifyListeners();
      return false;
    }
  }

  // Get pending invitations
  Future<List<Map<String, dynamic>>> getPendingInvitations(String email) async {
    return await _farmService.getPendingInvitations(email);
  }

  // Accept invitation
  Future<bool> acceptInvitation(String invitationId, String userId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _farmService.acceptInvitation(invitationId, userId);
      await loadUserFarms(userId);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to accept invitation';
      notifyListeners();
      return false;
    }
  }

  // Get farm team members
  Future<List<Map<String, dynamic>>> getFarmTeamMembers(String farmId) async {
    return await _farmService.getFarmTeamMembers(farmId);
  }

  // Remove team member
  Future<bool> removeTeamMember(String userId, String farmId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _farmService.removeUserFromFarm(userId, farmId);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to remove team member';
      notifyListeners();
      return false;
    }
  }

  // Update team member role
  Future<bool> updateTeamMemberRole(
      String userId, String farmId, String newRole) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _farmService.updateUserRole(userId, farmId, newRole);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to update role';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
