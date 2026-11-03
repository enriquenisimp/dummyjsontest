enum AppRoute {
  splash(path: '/splash', name: 'splash'),
  login(path: '/login', name: 'login'),
  products(path: '/products', name: 'products'),
  productDetail(path: '/products/:id', name: 'productDetail');

  const AppRoute({required this.path, required this.name});

  final String path;
  final String name;

  /// Resolves [path] by substituting `:param` segments from [pathParameters].
  String location({Map<String, String> pathParameters = const {}}) {
    var resolved = path;
    for (final entry in pathParameters.entries) {
      resolved = resolved.replaceAll(':${entry.key}', entry.value);
    }
    return resolved;
  }
}
