import birl
import grille_pain/internals/ffi
import grille_pain/toast/level.{type Level}
import plinth/browser/shadow.{type ShadowRoot}

pub type Toast {
  Toast(
    id: Int,
    content: String,
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
  id: Int,
  content: String,
  level: Level,
  animation_duration: Int,
  root: ShadowRoot,
) {
  Toast(
    id: id,
    content: content,
    displayed: False,
    running: False,
    remaining: animation_duration,
    last_schedule: birl.now(),
    iteration: 0,
    bottom: ffi.compute_bottom_position(root),
    level: level,
    animation_duration: animation_duration,
  )
}

pub fn running_to_string(running: Bool) {
  case running {
    True -> "running"
    False -> "paused"
  }
}
