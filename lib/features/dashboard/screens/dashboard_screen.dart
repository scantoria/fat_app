import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/farm_provider.dart';
import '../../farms/screens/farm_list_screen.dart';
import '../../farms/screens/create_farm_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadFarms();
  }

  Future<void> _loadFarms() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final farmProvider = Provider.of<FarmProvider>(context, listen: false);

    if (authProvider.user != null) {
      await farmProvider.loadUserFarms(authProvider.user!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, FarmProvider>(
      builder: (context, authProvider, farmProvider, _) {
        if (farmProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!farmProvider.hasFarms) {
          return _buildNoFarmsScreen(context, authProvider);
        }

        return const FarmListScreen();
      },
    );
  }

  Widget _buildNoFarmsScreen(BuildContext context, AuthProvider authProvider) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAT APP'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authProvider.signOut(),
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.agriculture,
                size: 100,
                color: Color(0xFF2E7D32),
              ),
              const SizedBox(height: 24),
              Text(
                'Welcome to FAT APP!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Get started by creating your first farm',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateFarmScreen(),
                    ),
                  ).then((_) => _loadFarms());
                },
                icon: const Icon(Icons.add),
                label: const Text('Create Your First Farm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
