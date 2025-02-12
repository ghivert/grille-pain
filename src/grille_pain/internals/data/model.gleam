import birl
import birl/duration.{Duration}
import gleam/list
import gleam/option.{type Option}
import grille_pain/internals/data/toast.{type Toast, Toast}
import grille_pain/internals/shadow.{type Shadow}
import grille_pain/toast/level.{type Level}

pub type Model {
  Model(toasts: List(Toast), id: Int, timeout: Int, root: Shadow)
}

pub fn new(root: Shadow, timeout: Int) {
  let toasts = []
  let id = 0
  Model(toasts: toasts, id: id, timeout: timeout, root: root)
}

pub fn add(
  model model: Model,
  uuid external_id: String,
  message message: String,
  level level: Level,
  sticky sticky: Bool,
  timeout timeout: Option(Int),
) {
  let timeout = option.unwrap(timeout, model.timeout)
  let new_toast =
    toast.new(
      external_id:,
      id: model.id,
      message:,
      level:,
      animation_duration: timeout,
      root: model.root,
      sticky:,
    )
  let new_toasts = [new_toast, ..model.toasts]
  let new_id = model.id + 1
  Model(..model, toasts: new_toasts, id: new_id)
}

fn update_toast(model: Model, id: Int, updater: fn(Toast) -> Toast) {
  let toasts = {
    use toast <- list.map(model.toasts)
    case id == toast.id {
      True -> updater(toast)
      False -> toast
    }
  }
  Model(..model, toasts:)
}

pub fn show(model: Model, id: Int) {
  use toast <- update_toast(model, id)
  let now = birl.utc_now()
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
        let bottom = toast.compute_size(id, model.root)
        let bottom = toast.bottom - bottom
        Toast(..toast, bottom:)
      }
      _, _ -> toast
    }
  }
  Model(..model, toasts: new_toasts)
}

pub fn stop(model: Model, id: Int) {
  use toast <- update_toast(model, id)
  let now = birl.utc_now()
  let Duration(elapsed_time) = birl.difference(now, toast.last_schedule)
  let remaining = toast.remaining - elapsed_time / 1000
  let iteration = toast.iteration + 1
  Toast(..toast, running: False, remaining:, iteration:)
}

pub fn resume(model: Model, id: Int) {
  use toast <- update_toast(model, id)
  let now = birl.utc_now()
  Toast(..toast, running: True, last_schedule: now)
}

pub fn remove(model: Model, id: Int) {
  let new_toasts = list.filter(model.toasts, fn(toast) { toast.id != id })
  Model(..model, toasts: new_toasts)
}
