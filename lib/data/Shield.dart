class Shield {
  double a = 1.0;
  double b = 1.0;
  double c = 1.0;
  double d = 1.0;
  double e = 1.0;
  double f = 1.0;

  Shield(
      {this.a = 1.0,
      this.b = 1.0,
      this.c = 1.0,
      this.d = 1.0,
      this.e = 1.0,
      this.f = 1.0});

  isActive() {
    return a > 0.0 || b > 0.0 || c > 0.0 || d > 0.0 || e > 0.0 || f > 0.0;
  }
}
