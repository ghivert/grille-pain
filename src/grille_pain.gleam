//// `grille_pain` provides a simili effect manager to display and manage your
//// toasts. You should instanciate at most one grille-pain on your applications.
////
//// This package exposes two entrypoints: `simple` and `setup`. The first one
//// should be appropriated for most use-cases. Reach for the next one if you
//// really need to customise options.

import gleam/bool
import gleam/list
import gleam/option
import gleam/pair
import gleam/result
import grille_pain/error
import grille_pain/internals/data/model.{type Model, Model}
import grille_pain/internals/data/msg.{type Msg}
import grille_pain/internals/data/toast
import grille_pain/internals/effect_manager
import grille_pain/internals/global
import grille_pain/internals/lustre/schedule.{schedule}
import grille_pain/internals/setup
import grille_pain/internals/view
import grille_pain/options.{type Options}
import lustre
import lustre/effect

/// Setup a new `grille_pain` instance. You should not instanciate two instances
/// on the page, as `grille_pain` expect to run as a singleton.
/// Use `grille_pain/options` to provide and customise options.
pub fn setup(opts: Options) {
  use #(lustre_root, shadow) <- result.try(setup.mount())
  use dispatcher <- result.map({
    fn(_) { #(model.new(shadow, opts.timeout), effect.none()) }
    |> lustre.application(update, view.view)
    |> lustre.start(lustre_root, Nil)
    |> error.lustre
  })
  effect_manager.register(dispatcher)
}

/// Setup a new `grille_pain` instance. You should not instanciate two instances
/// on the page, as `grille_pain` expect to run as a singleton.
/// Setup with default settings, meaning 5s of timeout.
pub fn simple() {
  options.default()
  |> setup()
}

fn update(model: Model, msg: Msg) {
  case msg {
    msg.ToastHidDisplay(id) -> {
      let model = model.remove(model, id)
      let update = update_display(model)
      #(model, update)
    }

    msg.UserEnteredToast(id) -> {
      let model = model.stop(model, id)
      #(model, effect.none())
    }

    msg.UserHidToast(uuid:) -> {
      case list.find(model.toasts, toast.by_uuid(_, uuid)) {
        Error(_) -> #(model, effect.none())
        Ok(toast) -> #(model, {
          use dispatch <- effect.from()
          dispatch(msg.ToastTimedOut(toast.id, toast.iteration))
        })
      }
    }

    msg.ToastTimedOut(id, iteration) -> {
      case list.find(model.toasts, toast.by_iteration(_, id, iteration)) {
        Error(_) -> #(model, effect.none())
        Ok(toast) -> {
          let model = model.hide(model, toast.id)
          let to_remove = schedule(1000, msg.ToastHidDisplay(id))
          let update = update_display(model)
          #(model, effect.batch([to_remove, update]))
        }
      }
    }

    msg.UserLeavedToast(id) -> {
      case list.find(model.toasts, toast.by_id(_, id)) {
        Error(_) -> #(model, effect.none())
        Ok(toast.Toast(sticky:, remaining:, iteration:, ..)) -> {
          let new_model = model.resume(model, id)
          #(new_model, schedule_hide(sticky, remaining, id, iteration))
        }
      }
    }

    msg.UserAddedToast(uuid:, message:, level:, timeout:, sticky:) -> {
      model.add(uuid:, model:, message:, level:, timeout:, sticky:)
      |> pair.new(update_display(model))
    }

    // Called after a requestAnimationFrame call.
    // Avoid to call an infinity of animation frames.
    msg.LustreRequestedAnimationFrame(frame) -> {
      let next_frame = option.Some(frame)
      let model = Model(..model, next_frame:)
      #(model, effect.none())
    }

    // Recompute positions of every toast, and schedule a management of
    // model to recompute next positions.
    msg.BrowserUpdatedToasts -> {
      let model = Model(..model, next_frame: option.None)
      let model = model.update_bottom_positions(model)
      #(model, update_toasts(model))
    }

    // Compute the new state of toasts.
    msg.LustreComputedToasts -> {
      let model = Model(..model, next_frame: option.None)
      case model.to_show {
        [] -> #(model, effect.none())
        showable -> {
          let model = Model(..model, to_show: [])
          #(model, update_display(model))
          |> list.fold(showable, _, fn(model, showable) {
            let model.ToShow(toast_id:, timeout:, sticky:) = showable
            let #(model, effs) = model
            let #(model, eff) = show(model, toast_id, timeout, sticky)
            #(model, effect.batch([effs, eff]))
          })
        }
      }
    }
  }
}

fn show(model: Model, id: Int, timeout: option.Option(Int), sticky: Bool) {
  let time = option.unwrap(timeout, model.timeout)
  let new_model = model.show(model, id)
  let eff = schedule_hide(sticky, time, id, 0)
  #(new_model, eff)
}

fn schedule_hide(sticky, timeout, id, iteration) {
  use <- bool.lazy_guard(when: sticky, return: effect.none)
  schedule(timeout, msg.ToastTimedOut(id, iteration))
}

fn update_display(model: Model) {
  case model.next_frame {
    option.Some(_) -> effect.none()
    option.None -> {
      use dispatch <- effect.from()
      dispatch({
        msg.LustreRequestedAnimationFrame({
          use <- global.request_animation_frame()
          dispatch(msg.BrowserUpdatedToasts)
        })
      })
    }
  }
}

fn update_toasts(model: Model) {
  case model.next_frame {
    option.Some(_) -> effect.none()
    option.None -> {
      use dispatch <- effect.from()
      dispatch({
        msg.LustreRequestedAnimationFrame({
          use <- global.request_animation_frame()
          dispatch(msg.LustreComputedToasts)
        })
      })
    }
  }
}
