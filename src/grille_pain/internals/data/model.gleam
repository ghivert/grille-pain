import birl
import birl/duration.{Duration}
import gleam/list
import gleam/option.{type Option}
import grille_pain/internals/data/toast.{type Toast, Toast}
import grille_pain/internals/ffi
import grille_pain/toast/level.{type Level}
import plinth/browser/shadow.{type ShadowRoot}

pub type Model {
  Model(toasts: List(Toast), id: Int, timeout: Int, root: ShadowRoot)
}

pub fn new(root: ShadowRoot, timeout: Int) {
  let toasts = []
  let id = 0
  Model(toasts: toasts, id: id, timeout: timeout, root: root)
}

pub fn add(
  model model: Model,
  message content: String,
  level level: Level,
  timeout timeout: Option(Int),
) {
  let timeout = option.unwrap(timeout, model.timeout)
  let new_toast = toast.new(model.id, content, level, timeout, model.root)
  let new_toasts = [new_toast, ..model.toasts]
  let new_id = model.id + 1
  Model(..model, toasts: new_toasts, id: new_id)
}

fn update_toast(model: Model, id: Int, updater: fn(Toast) -> Toast) {
  Model(
    ..model,
    toasts: {
      use toast <- list.map(model.toasts)
      case id == toast.id {
        True -> updater(toast)
        False -> toast
      }
    },
  )
}

pub fn show(model: Model, id: Int) {
  use toast <- update_toast(model, id)
  let now = birl.now()
  Toast(..toast, displayed: True, running: True, last_schedule: now)
}

pub fn hide(model: Model, id: Int) {
  use toast <- update_toast(model, id)
  Toast(..toast, displayed: False)
}

pub fn decrease_bottom(model: Model, id: Int) {
  let new_toasts = {
    use toast <- list.map(model.toasts)
    case toast.displayed, toast.id > id {
      True, True -> {
        let bottom = ffi.compute_toast_size(id, model.root)
        let new_bottom = toast.bottom - bottom
        Toast(..toast, bottom: new_bottom)
      }
      _, _ -> toast
    }
  }
  Model(..model, toasts: new_toasts)
}

pub fn stop(model: Model, id: Int) {
  use toast <- update_toast(model, id)
  let now = birl.now()
  let Duration(elapsed_time) = birl.difference(now, toast.last_schedule)
  let remaining = toast.remaining - elapsed_time / 1000
  let i = toast.iteration + 1
  Toast(..toast, running: False, remaining: remaining, iteration: i)
}

pub fn resume(model: Model, id: Int) {
  use toast <- update_toast(model, id)
  let now = birl.now()
  Toast(..toast, running: True, last_schedule: now)
}

pub fn remove(model: Model, id: Int) {
  let new_toasts = list.filter(model.toasts, fn(toast) { toast.id != id })
  Model(..model, toasts: new_toasts)
}
