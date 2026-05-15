import 'package:flutter/material.dart';

class DashboardMetric {
  const DashboardMetric({
    required this.label,
    required this.value,
    required this.detail,
    required this.icon,
    required this.trend,
  });

  final String label;
  final String value;
  final String detail;
  final IconData icon;
  final String trend;
}
