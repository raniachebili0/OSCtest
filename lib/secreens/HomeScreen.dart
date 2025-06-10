import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orange_test/services/MarvelApiService.dart';
import 'package:orange_test/widgets/marvel_characters_grid.dart';
import '../theme/app_strings.dart';
import '../theme/app_colors.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MarvelApiService _apiService = MarvelApiService();
  List<Map<String, dynamic>> _characters = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  Future<void> _loadCharacters() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final characters = await _apiService.getCharacters();
      setState(() {
        _characters = characters.map((character) => character as Map<String, dynamic>).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erreur lors du chargement des personnages';
        _isLoading = false;
      });
    }
  }

  void _onCharacterTap(Map<String, dynamic> character) {
    print('Character tapped: ${character['name']}');
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProvider(),
      child: Consumer<HomeProvider>(
        builder: (context, provider, _) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/marvel-background-web.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.error != null
                      ? Center(child: Text(provider.error!))
                      : MarvelCharactersGrid(
                          characters: provider.characters,
                          isLoading: provider.isLoading,
                          error: provider.error,
                          onCharacterTap: (character) => provider.onCharacterTap(context, character),
                          onRefresh: provider.loadCharacters,
                        ),
            ),
          );
        },
      ),
    );
  }
}
