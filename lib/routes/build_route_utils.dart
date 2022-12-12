part of 'app_routes.dart';

PageRoute<T> _buildPageRoute<T>({
  required Widget child,
  RouteSettings? settings,
}) {
  return MaterialPageRoute(
    builder: (context) {
      return child;
    },
    settings: settings,
  );
}
