import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musicscroll_pitch/musicscroll_pitch_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelMusicscrollPitch platform = MethodChannelMusicscrollPitch();
  const MethodChannel channel = MethodChannel('musicscroll_pitch');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          return '42';
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
