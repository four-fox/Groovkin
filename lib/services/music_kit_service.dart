import 'package:music_kit/music_kit.dart';

class MusicKitService {
  static Future<List<String>> getUserMusicGenres() async {
    try {
      // Request authorization to access MusicKit
      final status = await MusicKit().authorizationStatus;
      if (status != AuthorizationStatus.authorized) {
        await MusicKit().requestAuthorization();
      }

      // Get user's music preferences
      final userToken = await MusicKit().userToken;
      if (userToken == null) {
        throw Exception('Failed to get user token');
      }

      // Get user's library
      final library = await MusicKit().library;

      // Get user's top genres
      final genres = <String>{};
      for (final item in library) {
        if (item.genre != null) {
          genres.add(item.genre!);
        }
      }

      return genres.toList();
    } catch (e) {
      print('Error getting music genres: $e');
      return [];
    }
  }

  static Future<List<String>> getAvailableGenres() async {
    try {
      // Get available genres from MusicKit
      final genres = await MusicKit().genres;
      return genres.map((genre) => genre.name).toList();
    } catch (e) {
      print('Error getting available genres: $e');
      return [];
    }
  }
}
