import grille_pain/internals/data/msg.{type Msg}
import lustre.{type Action, type ClientSpa}
import plinth/browser/shadow.{type ShadowRoot}

pub type Dispatch =
  fn(Action(Msg, ClientSpa)) -> Nil

@external(javascript, "../../grille_pain.ffi.mjs", "storeDispatcher")
pub fn store_dispatcher(dispatcher: Dispatch) -> Dispatch {
  dispatcher
}

@external(javascript, "../../grille_pain.ffi.mjs", "getDispatcher")
pub fn dispatcher() -> Dispatch {
  fn(_) { Nil }
}

@external(javascript, "../../grille_pain.ffi.mjs", "isDarkTheme")
pub fn is_dark_theme() -> Bool {
  False
}

@external(javascript, "../../grille_pain.ffi.mjs", "computeToastSize")
pub fn compute_toast_size(_id: Int, _root: ShadowRoot) -> Int {
  0
}

@external(javascript, "../../grille_pain.ffi.mjs", "addKeyframe")
pub fn add_keyframe(_root: ShadowRoot) -> Nil {
  Nil
}

@external(javascript, "../../grille_pain.ffi.mjs", "computeBottomPosition")
pub fn compute_bottom_position(_root: ShadowRoot) -> Int {
  0
}

@external(javascript, "../../grille_pain.ffi.mjs", "setTimeout")
pub fn set_timeout(_timeout: Int, _callback: fn() -> Nil) -> Nil {
  Nil
}

@external(erlang, "grille_pain_ffi", "coerce")
@external(javascript, "../../grille_pain.ffi.mjs", "coerce")
pub fn coerce(a: a) -> b
