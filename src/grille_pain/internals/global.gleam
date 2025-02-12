@external(javascript, "../../global.ffi.mjs", "setTimeout")
pub fn set_timeout(_timeout: Int, _callback: fn() -> Nil) -> Nil {
  Nil
}
