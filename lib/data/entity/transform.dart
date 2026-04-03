enum Transform {
  normal(0),
  rotate90(1),
  rotate180(2),
  rotate270(3),
  flip(4),
  flipRotate90(5),
  flipRotate180(6),
  flipRotate270(7);

  final int code;

  const Transform(this.code);
}
