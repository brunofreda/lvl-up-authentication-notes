import 'package:flutter/foundation.dart' show immutable;

typedef ClosedLoadingScreen = bool Function();
typedef UpdateLoadingScreen = bool Function(String text);

@immutable
class LoadingScreenController {
  const LoadingScreenController({
    required this.close,
    required this.update,
  });

  final ClosedLoadingScreen close;
  final UpdateLoadingScreen update;
}
