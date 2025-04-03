pub type AnimationFrame

@external(javascript, "./global.ffi.mjs", "setTimeout")
pub fn set_timeout(_timeout: Int, _callback: fn() -> Nil) -> Nil {
  Nil
}

@external(javascript, "./global.ffi.mjs", "now")
pub fn now() -> Int {
  0
}

@external(javascript, "./global.ffi.mjs", "requestAnimationFrame")
pub fn request_animation_frame(next: fn() -> Nil) -> AnimationFrame
