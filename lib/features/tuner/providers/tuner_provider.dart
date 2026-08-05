import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/tuner_service.dart';

final tunerProvider = ChangeNotifierProvider<TunerService>((ref) {
  final service = TunerService();

  ref.onDispose(service.dispose);

  return service;
});