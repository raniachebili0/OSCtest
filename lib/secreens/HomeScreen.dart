import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orange_test/services/MarvelApiService.dart';
import 'package:orange_test/widgets/marvel_characters_list.dart';
import '../theme/app_strings.dart';
import '../theme/app_colors.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';
import '../widgets/search_bar_widget.dart';
import '../models/MarvelCharacter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MarvelApiService _apiService = MarvelApiService();
  List<MarvelCharacter> _characters = [];
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
        _characters = characters;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error loading characters';
        _isLoading = false;
      });
    }
  }

  void _onCharacterTap(MarvelCharacter character) {
    print('Character tapped: ${character.name}');
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProvider(),
      child: Consumer<HomeProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            backgroundColor: AppColors.marvelBlue,
            appBar: AppBar(
              backgroundColor: AppColors.marvelBlue,
              elevation: 2,
              title: Text(
                'Marvel Characters',
                style: TextStyle(
                  color: AppColors.marvelRed,
                  fontFamily: 'Anton',
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              centerTitle: true,
            ),
            body: Column(
              children: [
                SearchBarWidget(
                  hintText: 'Search characters...',
                  searchQuery: provider.searchQuery,
                  onChanged: provider.updateSearchQuery,
                  onClear: () => provider.updateSearchQuery(''),
                ),
                Expanded(
                  child: provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : provider.error != null
                          ? Center(child: Text(provider.error!))
                          : MarvelCharactersList(
                              characters: provider.characters,
                              isLoading: provider.isLoading,
                              error: provider.error,
                              onCharacterTap: (character) => provider.onCharacterTap(context, character),
                              onRefresh: provider.loadCharacters,
                            ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
