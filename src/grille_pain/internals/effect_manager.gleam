import grille_pain/internals/data/msg.{type Msg}
import lustre.{type Action, type ClientSpa}

pub type Dispatch =
  fn(Action(Msg, ClientSpa)) -> Nil

@external(javascript, "../../effect_manager.ffi.mjs", "register")
pub fn register(dispatcher: Dispatch) -> Dispatch {
  dispatcher
}

@external(javascript, "../../effect_manager.ffi.mjs", "call")
pub fn call(_callback: fn(Dispatch) -> Nil) -> Nil {
  Nil
}
