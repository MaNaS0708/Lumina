import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/app/app_routes.dart';
import 'package:lumina/app/lumina_app.dart';
import 'package:lumina/controllers/navigation_controller.dart';
import 'package:lumina/models/app_user.dart';

void main() {
  testWidgets('Lumina authentication screen renders', (tester) async {
    await tester.pumpWidget(
      LuminaApp(
        navigationController: NavigationController(),
        authStateChanges: Stream.value(null),
      ),
    );
    await tester.pump();

    expect(find.text('Lumina'), findsWidgets);
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Continue to workspace'), findsOneWidget);
    expect(find.text('Create account'), findsOneWidget);
  });

  test('employee role lands on employee dashboard', () {
    final controller = NavigationController();

    controller.setAuthenticatedUser(_user(role: AppRole.employee));

    expect(controller.activeRole, AppRole.employee);
    expect(controller.activePage, AppPage.employeeDashboard);
    expect(controller.pagesForActiveRole, contains(AppPage.employeeGoals));
    expect(
      controller.pagesForActiveRole,
      isNot(contains(AppPage.adminDashboard)),
    );
  });

  test('manager role lands on manager dashboard', () {
    final controller = NavigationController();

    controller.setAuthenticatedUser(_user(role: AppRole.manager));

    expect(controller.activeRole, AppRole.manager);
    expect(controller.activePage, AppPage.managerDashboard);
    expect(
      controller.pagesForActiveRole,
      contains(AppPage.managerApprovalDetail),
    );
    expect(
      controller.pagesForActiveRole,
      isNot(contains(AppPage.adminDashboard)),
    );
  });

  test('hr role lands on admin dashboard area', () {
    final controller = NavigationController();

    controller.setAuthenticatedUser(_user(role: AppRole.hr));

    expect(controller.activeRole, AppRole.hr);
    expect(controller.activePage, AppPage.adminDashboard);
    expect(controller.pagesForActiveRole, contains(AppPage.adminReports));
  });

  test('admin role lands on admin dashboard area', () {
    final controller = NavigationController();

    controller.setAuthenticatedUser(_user(role: AppRole.admin));

    expect(controller.activeRole, AppRole.admin);
    expect(controller.activePage, AppPage.adminDashboard);
    expect(
      controller.pagesForActiveRole,
      contains(AppPage.adminIdentitySettings),
    );
  });

  test('navigation ignores pages outside active role', () {
    final controller = NavigationController();

    controller.setAuthenticatedUser(_user(role: AppRole.employee));
    controller.navigateTo(AppPage.adminDashboard);

    expect(controller.activePage, AppPage.employeeDashboard);
  });
}

AppUser _user({required AppRole role}) {
  return AppUser(
    id: 'test-user',
    name: 'Test User',
    email: 'test@example.com',
    role: role,
    department: 'Engineering',
    managerName: 'Manager',
    organizationId: 'lumina',
    organizationName: 'Lumina',
  );
}
