import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orange_test/services/MarvelApiService.dart';
import 'package:orange_test/widgets/marvel_characters_list.dart';
import '../theme/app_strings.dart';
import '../theme/app_colors.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';
import '../providers/theme_provider.dart';
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final homeProvider = Provider.of<HomeProvider>(context);
    
    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: themeProvider.isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
        elevation: 2,
        title: Text(
          'Marvel Characters',
          style: TextStyle(
            color: themeProvider.isDarkMode ? AppColors.darkText : AppColors.lightText,
            fontFamily: 'Anton',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: themeProvider.isDarkMode ? AppColors.darkText : AppColors.lightText,
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: Column(
        children: [
          SearchBarWidget(
            hintText: 'Search characters...',
            searchQuery: homeProvider.searchQuery,
            onChanged: homeProvider.updateSearchQuery,
            onClear: () => homeProvider.updateSearchQuery(''),
          ),
          Expanded(
            child: homeProvider.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.marvelRed,
                    ),
                  )
                : homeProvider.error != null
                    ? Center(
                        child: Text(
                          homeProvider.error!,
                          style: TextStyle(
                            color: themeProvider.isDarkMode ? AppColors.darkText : AppColors.lightText,
                          ),
                        ),
                      )
                    : MarvelCharactersList(
                        characters: homeProvider.characters,
                        isLoading: homeProvider.isLoading,
                        error: homeProvider.error,
                        onCharacterTap: (character) => homeProvider.onCharacterTap(context, character),
                        onRefresh: homeProvider.loadCharacters,
                      ),
          ),
        ],
      ),
    );
  }
}
