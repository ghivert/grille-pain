import birl
import grille_pain/internals/ffi
import grille_pain/toast/level.{type Level}
import plinth/browser/shadow.{type ShadowRoot}

pub type Toast {
  Toast(
    external_id: String,
    id: Int,
    sticky: Bool,
    message: String,
    displayed: Bool,
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
  root root: ShadowRoot,
) {
  Toast(
    external_id:,
    id:,
    message:,
    sticky:,
    displayed: False,
    running: False,
    remaining:,
    last_schedule: birl.utc_now(),
    iteration: 0,
    bottom: ffi.compute_bottom_position(root),
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
