import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError());

class ThemeState {
  final ThemeMode themeMode;
  final bool useDynamicColor;

  ThemeState({required this.themeMode, required this.useDynamicColor});

  ThemeState copyWith({ThemeMode? themeMode, bool? useDynamicColor}) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      useDynamicColor: useDynamicColor ?? this.useDynamicColor,
    );
  }
}

class ThemeNotifier extends Notifier<ThemeState> {
  static const _modeKey = 'themeMode';
  static const _dynamicKey = 'useDynamicColor';

  @override
  ThemeState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final modeIndex = prefs.getInt(_modeKey) ?? ThemeMode.system.index;
    final useDyn = prefs.getBool(_dynamicKey) ?? false;
    return ThemeState(
      themeMode: ThemeMode.values[modeIndex],
      useDynamicColor: useDyn,
    );
  }

  void setThemeMode(ThemeMode mode) {
    ref.read(sharedPreferencesProvider).setInt(_modeKey, mode.index);
    state = state.copyWith(themeMode: mode);
  }

  void setDynamicColor(bool useDynamic) {
    ref.read(sharedPreferencesProvider).setBool(_dynamicKey, useDynamic);
    state = state.copyWith(useDynamicColor: useDynamic);
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeState>(ThemeNotifier.new);
