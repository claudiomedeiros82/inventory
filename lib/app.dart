import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/repositories/file_interface.dart';
import 'data/repositories/file_repository.dart';
import 'services/inventory_service.dart';
import 'ui/controllers/inventory_controller.dart';
import 'ui/main_screen.dart';
import 'ui/theme/app_theme.dart';

class BunkerApp extends StatelessWidget {
  const BunkerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Production injection
        Provider<IFileRepository>(
          create: (_) => FileRepository(),
        ),
        ProxyProvider<IFileRepository, InventoryService>(
          update: (_, repository, __) => InventoryService(repository),
        ),
        ChangeNotifierProvider<InventoryController>(
          create: (context) => InventoryController(
            context.read<InventoryService>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Bunker Inventory System',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const MainScreen(),
      ),
    );
  }
}
