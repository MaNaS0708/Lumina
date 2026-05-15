import 'package:flutter/material.dart';

import '../../models/app_user.dart';
import '../../models/audit_log.dart';
import '../../models/dashboard_metric.dart';
import '../../models/goal.dart';
import '../../models/team_member.dart';

class MockData {
  const MockData._();

  static const employee = AppUser(
    id: 'u-101',
    name: 'Aarav Sharma',
    email: 'aarav.sharma@northwind.in',
    role: AppRole.employee,
    department: 'Sales Operations',
    managerName: 'Meera Iyer',
    organizationName: 'Northwind Labs',
  );

  static const manager = AppUser(
    id: 'u-201',
    name: 'Meera Iyer',
    email: 'meera.iyer@northwind.in',
    role: AppRole.manager,
    department: 'Commercial Excellence',
    managerName: 'Rohan Sethi',
    organizationName: 'Northwind Labs',
  );

  static const admin = AppUser(
    id: 'u-301',
    name: 'Kavya Nair',
    email: 'kavya.nair@northwind.in',
    role: AppRole.admin,
    department: 'People Operations',
    managerName: 'CHRO Office',
    organizationName: 'Northwind Labs',
  );

  static const goals = [
    Goal(
      id: 'g-01',
      title: 'Improve enterprise renewal pipeline',
      description:
          'Build a healthier Q2 renewal pipeline for strategic accounts.',
      thrustArea: 'Revenue Growth',
      uomType: UomType.numeric,
      direction: GoalDirection.higherIsBetter,
      targetLabel: 'Rs. 1.2 Cr pipeline',
      targetValue: 120,
      actualValue: 84,
      weightage: 25,
      status: GoalStatus.onTrack,
      progress: 70,
    ),
    Goal(
      id: 'g-02',
      title: 'Reduce quote turnaround time',
      description: 'Lower average quote cycle time for priority deal desks.',
      thrustArea: 'Process Excellence',
      uomType: UomType.numeric,
      direction: GoalDirection.lowerIsBetter,
      targetLabel: '48 hours',
      targetValue: 48,
      actualValue: 42,
      weightage: 20,
      status: GoalStatus.completed,
      progress: 100,
    ),
    Goal(
      id: 'g-03',
      title: 'Launch partner enablement playbook',
      description:
          'Publish the playbook and run enablement for regional partners.',
      thrustArea: 'Partner Success',
      uomType: UomType.timeline,
      direction: GoalDirection.deadlineBased,
      targetLabel: '30 Sep 2026',
      targetValue: 273,
      actualValue: 268,
      weightage: 20,
      status: GoalStatus.onTrack,
      progress: 82,
    ),
    Goal(
      id: 'g-04',
      title: 'Maintain zero critical compliance gaps',
      description: 'Close quarterly evidence requests with no critical misses.',
      thrustArea: 'Governance',
      uomType: UomType.zeroBased,
      direction: GoalDirection.zeroIsSuccess,
      targetLabel: '0 critical gaps',
      targetValue: 0,
      actualValue: 0,
      weightage: 15,
      status: GoalStatus.completed,
      progress: 100,
    ),
    Goal(
      id: 'g-05',
      title: 'Increase forecast accuracy',
      description: 'Improve rolling forecast accuracy for committed revenue.',
      thrustArea: 'Planning',
      uomType: UomType.percentage,
      direction: GoalDirection.higherIsBetter,
      targetLabel: '92%',
      targetValue: 92,
      actualValue: 86,
      weightage: 20,
      status: GoalStatus.onTrack,
      progress: 93,
    ),
  ];

  static const employeeMetrics = [
    DashboardMetric(
      label: 'Goal Cycle Status',
      value: 'Approved',
      detail: 'Locked after manager approval',
      icon: Icons.lock_rounded,
      trend: 'FY 2026',
    ),
    DashboardMetric(
      label: 'Total Weightage',
      value: '100%',
      detail: '5 goals distributed',
      icon: Icons.pie_chart_rounded,
      trend: 'Valid',
    ),
    DashboardMetric(
      label: 'Goals Completed',
      value: '2 / 5',
      detail: '3 goals on track',
      icon: Icons.verified_rounded,
      trend: '+1 this quarter',
    ),
    DashboardMetric(
      label: 'Next Check-in',
      value: 'Q2',
      detail: 'Window opens in October',
      icon: Icons.calendar_month_rounded,
      trend: '12 days left',
    ),
  ];

  static const managerMetrics = [
    DashboardMetric(
      label: 'Pending Approvals',
      value: '7',
      detail: 'Across two departments',
      icon: Icons.pending_actions_rounded,
      trend: '3 urgent',
    ),
    DashboardMetric(
      label: 'Approved Sheets',
      value: '42',
      detail: 'Goal sheets locked',
      icon: Icons.fact_check_rounded,
      trend: '84%',
    ),
    DashboardMetric(
      label: 'Check-ins Due',
      value: '11',
      detail: 'Q2 discussion pending',
      icon: Icons.rate_review_rounded,
      trend: 'Oct window',
    ),
    DashboardMetric(
      label: 'Team Completion',
      value: '78%',
      detail: 'Planned vs actual captured',
      icon: Icons.insights_rounded,
      trend: '+8%',
    ),
  ];

  static const adminMetrics = [
    DashboardMetric(
      label: 'Total Employees',
      value: '1,248',
      detail: 'Across 6 organizations',
      icon: Icons.badge_rounded,
      trend: 'Multi-company',
    ),
    DashboardMetric(
      label: 'Submitted Sheets',
      value: '1,094',
      detail: 'Goal sheets received',
      icon: Icons.upload_file_rounded,
      trend: '87.6%',
    ),
    DashboardMetric(
      label: 'Approved Sheets',
      value: '982',
      detail: 'Locked by managers',
      icon: Icons.lock_rounded,
      trend: '79%',
    ),
    DashboardMetric(
      label: 'Check-in Rate',
      value: '72%',
      detail: 'Q2 completion progress',
      icon: Icons.query_stats_rounded,
      trend: '+6%',
    ),
  ];

  static const teamMembers = [
    TeamMember(
      id: 'u-101',
      name: 'Aarav Sharma',
      department: 'Sales Operations',
      manager: 'Meera Iyer',
      goalStatus: GoalStatus.submitted,
      totalWeightage: 100,
      lastUpdated: 'Today, 10:42 AM',
      completionRate: 72,
    ),
    TeamMember(
      id: 'u-102',
      name: 'Isha Mehta',
      department: 'Customer Success',
      manager: 'Meera Iyer',
      goalStatus: GoalStatus.approved,
      totalWeightage: 100,
      lastUpdated: 'Yesterday',
      completionRate: 88,
    ),
    TeamMember(
      id: 'u-103',
      name: 'Dev Malhotra',
      department: 'Sales Operations',
      manager: 'Meera Iyer',
      goalStatus: GoalStatus.rework,
      totalWeightage: 90,
      lastUpdated: '2 days ago',
      completionRate: 54,
    ),
    TeamMember(
      id: 'u-104',
      name: 'Naina Rao',
      department: 'Partner Success',
      manager: 'Meera Iyer',
      goalStatus: GoalStatus.locked,
      totalWeightage: 100,
      lastUpdated: '5 days ago',
      completionRate: 94,
    ),
  ];

  static const auditLogs = [
    AuditLog(
      timestamp: '16 May 2026, 09:12',
      user: 'Kavya Nair',
      role: AppRole.admin,
      action: 'Unlocked goal sheet',
      fieldChanged: 'locked',
      oldValue: 'true',
      newValue: 'false',
    ),
    AuditLog(
      timestamp: '15 May 2026, 18:24',
      user: 'Meera Iyer',
      role: AppRole.manager,
      action: 'Edited target',
      fieldChanged: 'targetValue',
      oldValue: 'Rs. 1.0 Cr',
      newValue: 'Rs. 1.2 Cr',
    ),
    AuditLog(
      timestamp: '14 May 2026, 11:06',
      user: 'Aarav Sharma',
      role: AppRole.employee,
      action: 'Submitted goal sheet',
      fieldChanged: 'status',
      oldValue: 'Draft',
      newValue: 'Submitted',
    ),
    AuditLog(
      timestamp: '13 May 2026, 16:38',
      user: 'Kavya Nair',
      role: AppRole.admin,
      action: 'Updated role mapping',
      fieldChanged: 'role',
      oldValue: 'Employee',
      newValue: 'Manager',
    ),
  ];
}
