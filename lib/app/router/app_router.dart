import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth_screen.dart';
import '../../features/auth/email_verification_screen.dart';
import '../../features/auth/forgot_password_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/education/education_screen.dart';
import '../../features/education/article_detail_screen.dart';
import '../../features/family/family_screen.dart';
import '../../features/insights/care_insights_screen.dart';
import '../../features/onboarding/onboarding_flow.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/quick_actions/quick_actions_screen.dart';
import '../../features/reminders/reminder_form_screen.dart';
import '../../features/notifications/notifications_screen.dart';
import '../../features/shell/home_shell.dart';
import '../../features/sleep/sleep_routine_screen.dart';
import '../../features/vaccines/vaccine_calendar_screen.dart';
import '../../features/tracker/tracker_screen.dart';
import '../../features/journal/journal_screen.dart';
import '../../features/tracker/record_form_screen.dart';
import '../app_controller.dart';

class AppRouteNames {
  static const login = 'login';
  static const register = 'register';
  static const forgotPassword = 'forgot-password';
  static const verifyEmail = 'verify-email';
  static const onboarding = 'onboarding';
  static const growth = 'growth';
  static const tracker = 'tracker';
  static const journal = 'journal';
  static const family = 'family';
  static const addRecord = 'add-record';
  static const reminder = 'reminder';
  static const sleep = 'sleep';
  static const education = 'education';
  static const profile = 'profile';
  static const quickActions = 'quick-actions';
  static const notifications = 'notifications';
  static const articleDetail = 'article-detail';
  static const vaccines = 'vaccines';
  static const insights = 'insights';
}

GoRouter buildAppRouter(AppController controller) {
  return GoRouter(
    refreshListenable: controller,
    initialLocation: '/growth',
    redirect: (context, state) {
      final location = state.matchedLocation;
      final authFlow =
          location == '/login' ||
          location == '/register' ||
          location == '/forgot-password';
      if (controller.isLoading) return null;
      if (!controller.isAuthenticated && !authFlow) return '/login';
      if (controller.isAuthenticated &&
          controller.snapshot.user?.emailVerified != true &&
          location != '/verify-email') {
        return '/verify-email';
      }
      if (controller.isAuthenticated &&
          controller.snapshot.user?.emailVerified == true &&
          location == '/verify-email') {
        return controller.onboardingComplete ? '/growth' : '/onboarding';
      }
      if (controller.isAuthenticated &&
          controller.snapshot.user?.emailVerified == true &&
          !controller.onboardingComplete &&
          location != '/onboarding') {
        return '/onboarding';
      }
      if (controller.isAuthenticated &&
          controller.snapshot.user?.emailVerified == true &&
          controller.onboardingComplete &&
          (location == '/login' ||
              location == '/register' ||
              location == '/forgot-password' ||
              location == '/verify-email' ||
              location == '/onboarding')) {
        return '/growth';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: AppRouteNames.login,
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/register',
        name: AppRouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: AppRouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/verify-email',
        name: AppRouteNames.verifyEmail,
        builder: (context, state) => const EmailVerificationScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: AppRouteNames.onboarding,
        builder: (context, state) => const OnboardingFlow(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => HomeShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/growth',
                name: AppRouteNames.growth,
                builder: (context, state) => const GrowthRootScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tracker',
                name: AppRouteNames.tracker,
                builder: (context, state) => const TrackerScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/vaccines',
                name: AppRouteNames.vaccines,
                builder: (context, state) => const VaccineCalendarScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/education',
                name: AppRouteNames.education,
                builder: (context, state) => const EducationScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/family',
                name: AppRouteNames.family,
                builder: (context, state) => const FamilyScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/add/:type',
        name: AppRouteNames.addRecord,
        pageBuilder: (context, state) => MaterialPage(
          fullscreenDialog: true,
          child: RecordFormScreen(
            typeName: state.pathParameters['type'],
            recordId: state.uri.queryParameters['id'],
          ),
        ),
      ),
      GoRoute(
        path: '/journal',
        name: AppRouteNames.journal,
        builder: (context, state) => const JournalScreen(),
      ),
      GoRoute(
        path: '/reminder/new',
        name: AppRouteNames.reminder,
        builder: (context, state) =>
            ReminderFormScreen(reminderId: state.uri.queryParameters['id']),
      ),
      GoRoute(
        path: '/sleep',
        name: AppRouteNames.sleep,
        builder: (context, state) => const SleepRoutineScreen(),
      ),
      GoRoute(
        path: '/education/article/:id',
        name: AppRouteNames.articleDetail,
        builder: (context, state) =>
            ArticleDetailScreen(articleId: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: '/notifications',
        name: AppRouteNames.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/quick-actions',
        name: AppRouteNames.quickActions,
        builder: (context, state) => const QuickActionsScreen(),
      ),
      GoRoute(
        path: '/insights',
        name: AppRouteNames.insights,
        builder: (context, state) => const CareInsightsScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: AppRouteNames.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
}
