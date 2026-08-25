import 'package:flutter/material.dart';

class AppTextScale {
  AppTextScale._();

  static const double baseWidth = 390;

  static const List<double> _steps = [
    0.825,
    0.850,
    0.875,
    0.900,
    0.925,
    0.950,
    0.975,
    1.000,
    1.025,
    1.050,
    1.075,
    1.100,
    1.125,
    1.150,
    1.175,
    1.200,
    1.250,
  ];

  static double _snapToStep(double raw) {
    return _steps.reduce(
      (closest, step) => (step - raw).abs() < (closest - raw).abs() ? step : closest,
    );
  }

  static Widget builder(BuildContext context, Widget? child) {
    if (child == null) return const SizedBox.shrink();

    final mediaQuery = MediaQuery.of(context);
    final raw = mediaQuery.size.width / baseWidth;
    final stepped = _snapToStep(raw);

    return MediaQuery(
      data: mediaQuery.copyWith(textScaler: TextScaler.linear(stepped)),
      child: child,
    );
  }
}
