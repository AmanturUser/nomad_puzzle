import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Renders an image from either a network URL or a bundled asset based on
/// the prefix of [source]. `asset:` paths are treated as `Image.asset`,
/// everything else goes through [CachedNetworkImage].
///
/// Examples:
///   SmartImage(source: 'asset:images/challenges/berkut.PNG')
///   SmartImage(source: 'https://example.com/photo.jpg')
class SmartImage extends StatelessWidget {
  const SmartImage({
    super.key,
    required this.source,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  final String source;
  final BoxFit fit;
  final Widget Function(BuildContext)? placeholder;
  final Widget Function(BuildContext)? errorWidget;

  static const _assetPrefix = 'asset:';

  bool get _isAsset => source.startsWith(_assetPrefix);

  String get _assetPath => source.substring(_assetPrefix.length);

  @override
  Widget build(BuildContext context) {
    if (_isAsset) {
      return Image.asset(
        _assetPath,
        fit: fit,
        errorBuilder: (ctx, _, _) =>
            errorWidget?.call(ctx) ?? const ColoredBox(color: Colors.black12),
      );
    }
    return CachedNetworkImage(
      imageUrl: source,
      fit: fit,
      placeholder: (ctx, _) =>
          placeholder?.call(ctx) ?? const ColoredBox(color: Colors.black12),
      errorWidget: (ctx, _, _) =>
          errorWidget?.call(ctx) ?? const ColoredBox(color: Colors.black12),
    );
  }
}
