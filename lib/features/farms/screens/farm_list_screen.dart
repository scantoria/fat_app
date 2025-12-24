import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/farm_provider.dart';
import '../../../core/theme/app_colors.dart';
import 'create_farm_screen.dart';
import 'farm_detail_screen.dart';

class FarmListScreen extends StatelessWidget {
  const FarmListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Farms'),
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              return PopupMenuButton(
                icon: CircleAvatar(
                  backgroundImage: authProvider.user?.photoURL != null
                      ? NetworkImage(authProvider.user!.photoURL!)
                      : null,
                  child: authProvider.user?.photoURL == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Profile'),
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: Navigate to profile screen
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Sign Out'),
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        Navigator.pop(context);
                        authProvider.signOut();
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<FarmProvider>(
        builder: (context, farmProvider, _) {
          if (farmProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!farmProvider.hasFarms) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.agriculture,
                    size: 80,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No farms yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text('Create your first farm to get started'),
                ],
              ),
            );
          }

          return Column(
            children: [
              if (farmProvider.selectedFarm != null)
                Container(
                  color: AppColors.primary.withOpacity(0.1),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.agriculture, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              farmProvider.selectedFarm!.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              '${farmProvider.selectedFarm!.stats['totalAnimals'] ?? 0} animals',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FarmDetailScreen(
                                farm: farmProvider.selectedFarm!,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: farmProvider.farms.length,
                  itemBuilder: (context, index) {
                    final farm = farmProvider.farms[index];
                    final isSelected =
                        farm.farmId == farmProvider.selectedFarm?.farmId;

                    return Card(
                      elevation: isSelected ? 4 : 1,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          child: const Icon(Icons.agriculture,
                              color: Colors.white),
                        ),
                        title: Text(
                          farm.name,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (farm.city != null && farm.state != null)
                              Text('${farm.city}, ${farm.state}'),
                            Text(
                              '${farm.stats['totalAnimals'] ?? 0} animals',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle,
                                color: AppColors.primary)
                            : null,
                        onTap: () {
                          farmProvider.selectFarm(farm);
                        },
                        onLongPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FarmDetailScreen(farm: farm),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateFarmScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Farm'),
      ),
    );
  }
}
