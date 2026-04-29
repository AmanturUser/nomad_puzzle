import 'package:flutter/material.dart';

class KgShapeIcon extends StatelessWidget {
  const KgShapeIcon({
    super.key,
    required this.color,
    this.height = 18,
    this.filled = true,
    this.strokeWidth = 1.6,
  });

  final Color color;

  /// Vertical size of the silhouette. Width is derived automatically from the
  /// country's natural aspect ratio (~2.83) so the shape fills the canvas
  /// without stretching or empty padding.
  final double height;
  final bool filled;
  final double strokeWidth;

  /// width / height ratio of the simplified Kyrgyzstan outline below.
  static const double aspect = 2.83;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(height * aspect, height),
      painter: _KgPainter(
        color: color,
        filled: filled,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

/// Real Kyrgyzstan silhouette derived from Natural Earth 1:10m data
/// (public domain, decimated to 87 vertices). Coordinates are normalised
/// 0..1 within the shape's own bounding box, so the shape fills the
/// canvas exactly with no padding.
class _KgPainter extends CustomPainter {
  _KgPainter({
    required this.color,
    required this.filled,
    required this.strokeWidth,
  });

  final Color color;
  final bool filled;
  final double strokeWidth;

  static const List<Offset> _outline = [
    Offset(0.9981, 0.4167),
    Offset(0.9514, 0.3921),
    Offset(0.9101, 0.3766),
    Offset(0.8909, 0.3652),
    Offset(0.8513, 0.3566),
    Offset(0.8181, 0.3553),
    Offset(0.7774, 0.3525),
    Offset(0.7430, 0.3503),
    Offset(0.7025, 0.3440),
    Offset(0.6616, 0.3508),
    Offset(0.6154, 0.3505),
    Offset(0.5834, 0.3606),
    Offset(0.4987, 0.3430),
    Offset(0.4573, 0.3234),
    Offset(0.4248, 0.3311),
    Offset(0.3877, 0.3526),
    Offset(0.3823, 0.3862),
    Offset(0.3717, 0.3890),
    Offset(0.3284, 0.3834),
    Offset(0.2786, 0.3647),
    Offset(0.2242, 0.3601),
    Offset(0.1911, 0.3669),
    Offset(0.1615, 0.3827),
    Offset(0.1489, 0.4047),
    Offset(0.1682, 0.4083),
    Offset(0.1591, 0.4299),
    Offset(0.1321, 0.4429),
    Offset(0.0838, 0.4745),
    Offset(0.1279, 0.4823),
    Offset(0.1456, 0.5021),
    Offset(0.1821, 0.5077),
    Offset(0.1995, 0.5100),
    Offset(0.2191, 0.4856),
    Offset(0.2244, 0.4841),
    Offset(0.2500, 0.5070),
    Offset(0.2689, 0.5210),
    Offset(0.2960, 0.5274),
    Offset(0.3275, 0.5364),
    Offset(0.3559, 0.5398),
    Offset(0.3233, 0.5548),
    Offset(0.3053, 0.5694),
    Offset(0.2908, 0.5739),
    Offset(0.2611, 0.5769),
    Offset(0.2372, 0.5930),
    Offset(0.2151, 0.5976),
    Offset(0.1869, 0.5885),
    Offset(0.1578, 0.5984),
    Offset(0.1273, 0.6162),
    Offset(0.0981, 0.6079),
    Offset(0.0675, 0.5964),
    Offset(0.0250, 0.6227),
    Offset(0.0000, 0.6382),
    Offset(0.0169, 0.6588),
    Offset(0.0549, 0.6578),
    Offset(0.0823, 0.6565),
    Offset(0.1003, 0.6544),
    Offset(0.1344, 0.6648),
    Offset(0.1620, 0.6694),
    Offset(0.1940, 0.6531),
    Offset(0.2078, 0.6648),
    Offset(0.2260, 0.6754),
    Offset(0.2566, 0.6730),
    Offset(0.2808, 0.6766),
    Offset(0.3279, 0.6741),
    Offset(0.3582, 0.6742),
    Offset(0.4004, 0.6657),
    Offset(0.4241, 0.6419),
    Offset(0.4287, 0.6183),
    Offset(0.4490, 0.6059),
    Offset(0.4852, 0.5932),
    Offset(0.5053, 0.5774),
    Offset(0.5423, 0.5755),
    Offset(0.5802, 0.5690),
    Offset(0.5928, 0.5876),
    Offset(0.6224, 0.5800),
    Offset(0.6427, 0.5833),
    Offset(0.6661, 0.5642),
    Offset(0.6856, 0.5368),
    Offset(0.7172, 0.5237),
    Offset(0.7669, 0.5246),
    Offset(0.8132, 0.5152),
    Offset(0.8436, 0.4834),
    Offset(0.8788, 0.4678),
    Offset(0.9158, 0.4532),
    Offset(0.9593, 0.4425),
    Offset(1.0000, 0.4308),
  ];

  // Pre-computed bounding box of _outline so we can stretch it edge-to-edge
  // inside the rendered Size.
  static const double _minX = 0.0000;
  static const double _maxX = 1.0000;
  static const double _minY = 0.3234;
  static const double _maxY = 0.6766;

  @override
  void paint(Canvas canvas, Size size) {
    final dx = _maxX - _minX;
    final dy = _maxY - _minY;
    final path = Path();
    for (var i = 0; i < _outline.length; i++) {
      final p = _outline[i];
      final pt = Offset(
        ((p.dx - _minX) / dx) * size.width,
        ((p.dy - _minY) / dy) * size.height,
      );
      if (i == 0) {
        path.moveTo(pt.dx, pt.dy);
      } else {
        path.lineTo(pt.dx, pt.dy);
      }
    }
    path.close();

    if (filled) {
      canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill
          ..isAntiAlias = true,
      );
    } else {
      canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round
          ..isAntiAlias = true,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _KgPainter old) =>
      old.color != color ||
      old.filled != filled ||
      old.strokeWidth != strokeWidth;
}
