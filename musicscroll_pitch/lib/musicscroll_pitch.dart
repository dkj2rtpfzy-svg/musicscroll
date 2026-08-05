
import 'musicscroll_pitch_platform_interface.dart';

class MusicscrollPitch {
  Future<String?> getPlatformVersion() {
    return MusicscrollPitchPlatform.instance.getPlatformVersion();
  }
}
