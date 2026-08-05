import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'musicscroll_pitch_method_channel.dart';

abstract class MusicscrollPitchPlatform extends PlatformInterface {
  /// Constructs a MusicscrollPitchPlatform.
  MusicscrollPitchPlatform() : super(token: _token);

  static final Object _token = Object();

  static MusicscrollPitchPlatform _instance = MethodChannelMusicscrollPitch();

  /// The default instance of [MusicscrollPitchPlatform] to use.
  ///
  /// Defaults to [MethodChannelMusicscrollPitch].
  static MusicscrollPitchPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MusicscrollPitchPlatform] when
  /// they register themselves.
  static set instance(MusicscrollPitchPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
