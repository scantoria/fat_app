import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/farm.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/farm_provider.dart';
import '../../../core/theme/app_colors.dart';
import 'invite_user_screen.dart';

class FarmDetailScreen extends StatefulWidget {
  final Farm farm;

  const FarmDetailScreen({super.key, required this.farm});

  @override
  State<FarmDetailScreen> createState() => _FarmDetailScreenState();
}

class _FarmDetailScreenState extends State<FarmDetailScreen> {
  List<Map<String, dynamic>> _teamMembers = [];
  bool _isLoadingTeam = false;

  @override
  void initState() {
    super.initState();
    _loadTeamMembers();
  }

  Future<void> _loadTeamMembers() async {
    setState(() => _isLoadingTeam = true);
    final farmProvider = Provider.of<FarmProvider>(context, listen: false);
    final members = await farmProvider.getFarmTeamMembers(widget.farm.farmId);
    setState(() {
      _teamMembers = members;
      _isLoadingTeam = false;
    });
  }

  Future<void> _deleteFarm() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Farm'),
        content: Text(
          'Are you sure you want to delete "${widget.farm.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final farmProvider = Provider.of<FarmProvider>(context, listen: false);

      final success = await farmProvider.deleteFarm(
        widget.farm.farmId,
        authProvider.user!.uid,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Farm deleted successfully'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  String _getRoleLabel(String role) {
    switch (role) {
      case 'owner':
        return 'Owner';
      case 'manager':
        return 'Manager';
      case 'lead':
        return 'Lead';
      case 'farm_hand':
        return 'Farm Hand';
      default:
        return role;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.farm.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteFarm,
            tooltip: 'Delete Farm',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoSection(),
            const Divider(height: 1),
            _buildStatsSection(),
            const Divider(height: 1),
            _buildTeamSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Farm Information',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Name', widget.farm.name),
          _buildInfoRow('Type', widget.farm.farmType.toUpperCase()),
          if (widget.farm.address != null)
            _buildInfoRow('Address', widget.farm.address!),
          if (widget.farm.city != null && widget.farm.state != null)
            _buildInfoRow(
                'Location', '${widget.farm.city}, ${widget.farm.state}'),
          if (widget.farm.zipCode != null)
            _buildInfoRow('ZIP Code', widget.farm.zipCode!),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistics',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: [
              _buildStatCard(
                  'Total', widget.farm.stats['totalAnimals'] ?? 0),
              _buildStatCard('Horses', widget.farm.stats['horses'] ?? 0),
              _buildStatCard('Cattle', widget.farm.stats['cattle'] ?? 0),
              _buildStatCard('Goats', widget.farm.stats['goats'] ?? 0),
              _buildStatCard('Sheep', widget.farm.stats['sheep'] ?? 0),
              _buildStatCard('Donkeys', widget.farm.stats['donkeys'] ?? 0),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, int count) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              count.toString(),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Team Members',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          InviteUserScreen(farm: widget.farm),
                    ),
                  ).then((_) => _loadTeamMembers());
                },
                icon: const Icon(Icons.person_add),
                label: const Text('Invite'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isLoadingTeam)
            const Center(child: CircularProgressIndicator())
          else if (_teamMembers.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('No team members yet'),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _teamMembers.length,
              itemBuilder: (context, index) {
                final member = _teamMembers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: member['photoURL'] != null
                        ? NetworkImage(member['photoURL'])
                        : null,
                    child:
                        member['photoURL'] == null ? const Icon(Icons.person) : null,
                  ),
                  title: Text(member['displayName'] ?? 'Unknown'),
                  subtitle: Text(member['email'] ?? ''),
                  trailing: Chip(
                    label: Text(_getRoleLabel(member['role'])),
                    backgroundColor: member['role'] == 'owner'
                        ? AppColors.primary.withOpacity(0.2)
                        : AppColors.textSecondary.withOpacity(0.2),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
