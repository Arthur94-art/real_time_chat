import 'package:go_router/go_router.dart';
import 'package:real_time_chat/core/router/routes_paths.dart';
import 'package:real_time_chat/core/widgets/gradient_background.dart';
import 'package:real_time_chat/features/auth/presentation/pages/auth_page.dart';
import 'package:real_time_chat/features/auth/presentation/pages/auth_redirect.dart';
import 'package:real_time_chat/features/chat/presentation/pages/chat_page.dart';

class NavigationConfig {
  static final _router = GoRouter(
    routes: [
      GoRoute(
        path: RoutesPaths.initial,
        builder: (context, state) =>
            const GradientAppWrapper(child: AuthRedirector()),
      ),
      GoRoute(
        path: RoutesPaths.auth,
        builder: (context, state) =>
            const GradientAppWrapper(child: AuthPage()),
      ),
      GoRoute(
        path: RoutesPaths.chat,
        builder: (context, state) => const GradientAppWrapper(
          child: ChatPage(),
        ),
      ),
    ],
  );

  static GoRouter get router => _router;
}
