pub fn tap(a: a, next: fn(a) -> b) -> a {
  next(a)
  a
}
