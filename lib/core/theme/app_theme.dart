import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ponytail: google_fonts baixa Manrope/Inter em runtime e faz cache local;
// no primeiro uso sem rede ele cai no fallback do sistema (sem crash), mas
// para produção considere empacotar os .ttf como assets locais via
// pubspec (GoogleFonts.config.allowRuntimeFetching = false) para zero
// dependência de rede na primeira abertura do app.

/// Material 3 tokens — direção "Trilha": o roadmap como caminho visual.
///
/// Psicologia das cores aplicada a um app de trilha de carreira:
/// - Verde (seed/deep): crescimento e avanço — já é a marca GoRoute, mantido.
/// - Âmbar (trailMarker): conquista e destaque — reservado para o "próximo
///   marco" e estados de recompensa, nunca usado como cor de erro.
/// - Coral (signal): mantido *exclusivamente* como erro/alerta, para não
///   misturar o sinal de "atenção" com o de "conquista".
abstract final class AppTheme {
  static const Color seed = Color(0xFF0F6E56);
  static const Color deep = Color(0xFF0A4F3D);
  static const Color signal = Color(0xFFE85D4C);
  static const Color trailMarker = Color(0xFFB8720E);
  static const Color lightBg = Color(0xFFF4F7F6);
  static const Color darkBg = Color(0xFF0E1412);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
      primary: seed,
      tertiary: trailMarker,
      error: signal,
    );
    return _base(scheme, scaffoldBackgroundColor: lightBg);
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
      primary: const Color(0xFF3FB58C),
      tertiary: trailMarker,
      error: signal,
    );
    return _base(scheme, scaffoldBackgroundColor: darkBg);
  }

  /// Manrope nos títulos (geométrica, lembra marcos/placas de trilha) +
  /// Inter no corpo (alta legibilidade para listas e dados).
  static TextTheme _textTheme(TextTheme base) {
    final body = GoogleFonts.interTextTheme(base);
    final display = GoogleFonts.manropeTextTheme(base);
    return body.copyWith(
      displayLarge: display.displayLarge,
      displayMedium: display.displayMedium,
      displaySmall: display.displaySmall,
      headlineLarge: display.headlineLarge,
      headlineMedium: display.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
      headlineSmall: display.headlineSmall,
      titleLarge: display.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      titleMedium: display.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    );
  }

  static ThemeData _base(
    ColorScheme scheme, {
    required Color scaffoldBackgroundColor,
  }) {
    final textTheme = _textTheme(
      ThemeData(brightness: scheme.brightness).textTheme,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: scaffoldBackgroundColor,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        height: 68,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.55)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
