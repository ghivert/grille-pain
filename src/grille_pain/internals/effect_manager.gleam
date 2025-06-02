import grille_pain/internals/data/msg.{type Msg}
import lustre.{type Runtime}

@external(javascript, "./effect_manager.ffi.mjs", "register")
pub fn register(dispatcher: Runtime(Msg)) -> Runtime(Msg) {
  dispatcher
}

@external(javascript, "./effect_manager.ffi.mjs", "call")
pub fn call(_callback: fn(Runtime(Msg)) -> Nil) -> Nil {
  Nil
}
