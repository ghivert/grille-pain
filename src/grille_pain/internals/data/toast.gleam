import birl
import grille_pain/internals/shadow.{type Shadow}
import grille_pain/toast/level.{type Level}

pub type DisplayState {
  WillShow
  Show
  WillHide
}

pub type Toast {
  Toast(
    external_id: String,
    id: Int,
    sticky: Bool,
    message: String,
    displayed: DisplayState,
    running: Bool,
    remaining: Int,
    last_schedule: birl.Time,
    iteration: Int,
    bottom: Int,
    level: Level,
    animation_duration: Int,
  )
}

pub fn new(
  external_id external_id: String,
  id id: Int,
  message message: String,
  level level: Level,
  animation_duration remaining: Int,
  sticky sticky: Bool,
  root root: Shadow,
) {
  Toast(
    external_id:,
    id:,
    message:,
    sticky:,
    displayed: WillShow,
    running: False,
    remaining:,
    last_schedule: birl.utc_now(),
    iteration: 0,
    bottom: compute_bottom_position(root, id),
    level:,
    animation_duration: remaining,
  )
}

pub fn running_to_string(running: Bool) {
  case running {
    True -> "running"
    False -> "paused"
  }
}

pub fn by_uuid(toast: Toast, uuid: String) {
  toast.external_id == uuid
}

pub fn by_id(toast: Toast, id: Int) {
  toast.id == id
}

pub fn by_iteration(toast: Toast, id: Int, iteration: Int) {
  toast.id == id && toast.iteration == iteration
}

@external(javascript, "../../../toast.ffi.mjs", "computeToastSize")
pub fn compute_size(_id: Int, _root: Shadow) -> Int {
  // That function can probably never be reached, since `grille_paint` will
  // never be instanciated on the BEAM.
  0
}

@external(javascript, "../../../toast.ffi.mjs", "computeBottomPosition")
pub fn compute_bottom_position(_root: Shadow, _id: Int) -> Int {
  // That function can probably never be reached, since `grille_paint` will
  // never be instanciated on the BEAM.
  0
}
