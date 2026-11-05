/// Compile-time switch for Event Discovery V2.
///
/// Production builds leave this off and keep calling the existing routes.
/// A V2 build is created with:
/// `--dart-define=DISCOVERY_V2_ENABLED=true`
///
/// Rollback is the same binary built without that define, or with `false`.
class DiscoveryConfig {
  const DiscoveryConfig({required this.enabled});

  final bool enabled;

  static const compileTime = DiscoveryConfig(
    enabled: bool.fromEnvironment(
      'DISCOVERY_V2_ENABLED',
      defaultValue: false,
    ),
  );

  static const recommendedV2 = 'v2/events/recommended';
  static const searchV2 = 'v2/events/search';
  static const recommendedV1 = 'recommended-for-you-events';
  static const searchV1 = 'search-events';
  static const disabledCode = 'discovery_v2_disabled';
  static const recommendedInvalidationKey = 'v2-events-recommended';
  static const searchInvalidationKey = 'v2-events-search';

  static const activityCatalogType = 'activity_choice';
  static const musicCatalogType = 'music_genre';
}
