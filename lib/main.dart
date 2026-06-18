import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'providers/reel_provider.dart';
import 'screens/home_screen.dart';
import 'screens/browse_screen.dart';
import 'screens/add_edit_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ReelProvider()..loadReels(),
      child: const ReelVaultApp(),
    ),
  );
}

class ReelVaultApp extends StatelessWidget {
  const ReelVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReelVault',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF673AB7),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF673AB7),
        brightness: Brightness.dark,
      ),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  late StreamSubscription _intentSub;

  @override
  void initState() {
    super.initState();
    _listenForSharedUrls();
  }

  void _listenForSharedUrls() {
    // While app is open
    _intentSub =
        ReceiveSharingIntent.instance.getMediaStream().listen((files) {
      _handleSharedFiles(files);
    });

    // App was opened via share
    ReceiveSharingIntent.instance.getInitialMedia().then((files) {
      _handleSharedFiles(files);
      ReceiveSharingIntent.instance.reset();
    });
  }

  void _handleSharedFiles(List<SharedMediaFile> files) {
    final url = files
        .where((f) => f.type == SharedMediaType.url)
        .map((f) => f.path)
        .firstOrNull;
    if (url != null && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddEditScreen(initialUrl: url),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _intentSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [const HomeScreen(), const BrowseScreen()][_index],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddEditScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add reel'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view),
            label: 'Categories',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline),
            selectedIcon: Icon(Icons.bookmark),
            label: 'All saved',
          ),
        ],
      ),
    );
  }
}