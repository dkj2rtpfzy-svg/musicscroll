import 'package:flutter_test/flutter_test.dart';
import 'package:musicscroll_pitch/musicscroll_pitch.dart';
import 'package:musicscroll_pitch/musicscroll_pitch_platform_interface.dart';
import 'package:musicscroll_pitch/musicscroll_pitch_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMusicscrollPitchPlatform
    with MockPlatformInterfaceMixin
    implements MusicscrollPitchPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final MusicscrollPitchPlatform initialPlatform = MusicscrollPitchPlatform.instance;

  test('$MethodChannelMusicscrollPitch is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMusicscrollPitch>());
  });

  test('getPlatformVersion', () async {
    MusicscrollPitch musicscrollPitchPlugin = MusicscrollPitch();
    MockMusicscrollPitchPlatform fakePlatform = MockMusicscrollPitchPlatform();
    MusicscrollPitchPlatform.instance = fakePlatform;

    expect(await musicscrollPitchPlugin.getPlatformVersion(), '42');
  });
}
