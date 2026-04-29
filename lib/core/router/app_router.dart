import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/ai_chat/presentation/pages/chat_page.dart';
import '../../features/ai_chat/presentation/pages/chat_sessions_page.dart';
import '../../features/subscription/presentation/pages/subscription_page.dart';
import '../widgets/fab_visibility.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/camera/presentation/pages/camera_page.dart';
import '../../features/challenges/presentation/pages/challenge_details_page.dart';
import '../../features/challenges/presentation/pages/challenges_page.dart';
import '../../features/map/presentation/pages/map_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/tours/presentation/pages/tour_details_page.dart';
import '../../features/tours/presentation/pages/tours_page.dart';
import 'app_routes.dart';
import 'scaffold_with_nav.dart';

class AppRouter {
  AppRouter._();

  static final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  static final _homeKey = GlobalKey<NavigatorState>(debugLabel: 'home');
  static final _challengesKey = GlobalKey<NavigatorState>(debugLabel: 'ch');
  static final _cameraKey = GlobalKey<NavigatorState>(debugLabel: 'camera');
  static final _toursKey = GlobalKey<NavigatorState>(debugLabel: 'tours');
  static final _profileKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

  static GoRouter create(AuthBloc authBloc) {
    return GoRouter(
      navigatorKey: _rootKey,
      initialLocation: AppRoutes.home,
      observers: [FabVisibility.instance],
      refreshListenable: _AuthListenable(authBloc),
      redirect: (context, state) {
        final auth = authBloc.state;
        if (auth.isInitial) return null;
        final loggedIn = auth.isAuthenticated;
        final goingToAuth = state.matchedLocation == AppRoutes.login ||
            state.matchedLocation == AppRoutes.register;
        if (!loggedIn && !goingToAuth) return AppRoutes.login;
        if (loggedIn && goingToAuth) return AppRoutes.home;
        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.login,
          builder: (_, __) => const LoginPage(),
        ),
        GoRoute(
          path: AppRoutes.register,
          builder: (_, __) => const RegisterPage(),
        ),
        GoRoute(
          path: AppRoutes.aiChat,
          builder: (_, __) => const ChatSessionsPage(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (_, state) {
                final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
                return ChatPage(sessionId: id);
              },
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.subscription,
          builder: (_, __) => const SubscriptionPage(),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, shell) =>
              ScaffoldWithNav(navigationShell: shell),
          branches: [
            StatefulShellBranch(
              navigatorKey: _homeKey,
              routes: [
                GoRoute(
                  path: AppRoutes.home,
                  builder: (_, _) => const MapPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _challengesKey,
              routes: [
                GoRoute(
                  path: AppRoutes.challenges,
                  builder: (_, __) => const ChallengesPage(),
                  routes: [
                    GoRoute(
                      path: '${AppRoutes.challengeDetails}/:id',
                      builder: (_, state) => ChallengeDetailsPage(
                        id: state.pathParameters['id']!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _cameraKey,
              routes: [
                GoRoute(
                  path: AppRoutes.camera,
                  builder: (_, __) => const CameraPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _toursKey,
              routes: [
                GoRoute(
                  path: AppRoutes.tours,
                  builder: (_, __) => const ToursPage(),
                  routes: [
                    GoRoute(
                      path: '${AppRoutes.tourDetails}/:id',
                      builder: (_, state) => TourDetailsPage(
                        id: state.pathParameters['id']!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _profileKey,
              routes: [
                GoRoute(
                  path: AppRoutes.profile,
                  builder: (_, __) => const ProfilePage(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

/// Bridges an [AuthBloc]'s state stream to a [Listenable] for go_router's
/// `refreshListenable`, so route redirects re-evaluate on every auth change.
class _AuthListenable extends ChangeNotifier {
  _AuthListenable(AuthBloc bloc) {
    _subscription = bloc.stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
