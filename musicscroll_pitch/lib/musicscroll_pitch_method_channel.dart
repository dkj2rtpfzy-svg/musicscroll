import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'musicscroll_pitch_platform_interface.dart';

/// An implementation of [MusicscrollPitchPlatform] that uses method channels.
class MethodChannelMusicscrollPitch extends MusicscrollPitchPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('musicscroll_pitch');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
