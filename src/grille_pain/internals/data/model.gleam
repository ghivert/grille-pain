import gleam/list
import gleam/option.{type Option}
import grille_pain/internals/data/toast.{type Toast, Toast}
import grille_pain/internals/global
import grille_pain/internals/shadow.{type Shadow}
import grille_pain/toast/level.{type Level}

pub type Model {
  Model(
    toasts: List(Toast),
    id: Int,
    timeout: Int,
    root: Shadow,
    next_frame: Option(global.AnimationFrame),
    to_show: List(ToShow),
  )
}

pub type ToShow {
  ToShow(toast_id: Int, timeout: Option(Int), sticky: Bool)
}

pub fn new(root: Shadow, timeout: Int) {
  let toasts = []
  let id = 0
  Model(toasts:, id:, timeout:, root:, to_show: [], next_frame: option.None)
}

pub fn add(
  model model: Model,
  uuid external_id: String,
  message message: String,
  level level: Level,
  sticky sticky: Bool,
  timeout timeout: Option(Int),
) {
  let animation_duration = option.unwrap(timeout, model.timeout)
  let new_toast =
    toast.new(
      external_id:,
      id: model.id,
      message:,
      level:,
      animation_duration:,
      root: model.root,
      sticky:,
    )
  let new_toasts = [new_toast, ..model.toasts]
  let new_id = model.id + 1
  let to_show = [ToShow(new_toast.id, timeout, sticky), ..model.to_show]
  Model(..model, toasts: new_toasts, id: new_id, to_show:)
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
  let now = global.now()
  Toast(..toast, displayed: toast.Show, running: True, last_schedule: now)
}

pub fn hide(model: Model, id: Int) {
  use toast <- update_toast(model, id)
  Toast(..toast, displayed: toast.WillHide)
}

pub fn stop(model: Model, id: Int) {
  use toast <- update_toast(model, id)
  let now = global.now()
  let duration = now - toast.last_schedule
  let remaining = toast.remaining - duration
  let iteration = toast.iteration + 1
  Toast(..toast, running: False, remaining:, iteration:)
}

pub fn resume(model: Model, id: Int) {
  use toast <- update_toast(model, id)
  let now = global.now()
  Toast(..toast, running: True, last_schedule: now)
}

pub fn remove(model: Model, id: Int) {
  let new_toasts = list.filter(model.toasts, fn(toast) { toast.id != id })
  Model(..model, toasts: new_toasts)
}

pub fn update_bottom_positions(model: Model) {
  Model(..model, toasts: {
    use toast <- list.map(model.toasts)
    case toast.displayed {
      toast.WillHide -> toast
      toast.Show | toast.WillShow -> {
        toast.Toast(
          ..toast,
          bottom: toast.compute_bottom_position(model.root, toast.id),
        )
      }
    }
  })
}
