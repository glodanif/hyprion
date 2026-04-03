enum Transformation {
  normal(0, 0, false, 'Default'),
  rotate90(1, 90, false, 'Rotate 90°'),
  rotate180(2, 180, false, 'Rotate 180°'),
  rotate270(3, 270, false, 'Rotate 270°'),
  flip(4, 0, true, 'Flip'),
  flipRotate90(5, 90, true, 'Flip & Rotate 90°'),
  flipRotate180(6, 180, true, 'Flip & Rotate 180°'),
  flipRotate270(7, 270, true, 'Flip & Rotate 270°');

  final int code;
  final int angle;
  final bool isFlipped;
  final String label;

  const Transformation(this.code, this.angle, this.isFlipped, this.label);
}
