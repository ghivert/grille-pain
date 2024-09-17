//// `grille_pain` provides a simili effect manager to display and manage your
//// toasts. You should instanciate at most one grille-pain on your applications.
////
//// This package exposes two entrypoints: `simple` and `setup`. The first one
//// should be appropriated for most use-cases. Reach for the next one if you
//// really need to customise options.

import gleam/list
import gleam/option
import gleam/pair
import gleam/result
import grille_pain/error
import grille_pain/internals/data/model.{type Model, Model}
import grille_pain/internals/data/msg.{type Msg}
import grille_pain/internals/ffi
import grille_pain/internals/lustre/schedule.{schedule}
import grille_pain/internals/view.{view}
import grille_pain/options.{type Options}
import lustre
import lustre/effect
import plinth/browser/document
import plinth/browser/element
import plinth/browser/shadow
import sketch as s
import sketch/lustre as sketch

/// Setup a new `grille_pain` instance. You should not instanciate two instances
/// on the page, as `grille_pain` expect to run as a singleton.
/// Use `grille_pain/options` to provide and customise options.
pub fn setup(opts: Options) {
  let node = document.create_element("grille-pain")
  let lustre_root_ = document.create_element("div")
  let shadow_root = shadow.attach_shadow(node, shadow.Open)
  let lustre_root = ffi.coerce(lustre_root_)
  shadow.append_child(shadow_root, lustre_root_)
  document.body() |> element.append_child(node)
  ffi.add_keyframe(shadow_root)

  use view <- result.try({
    let shadow = sketch.shadow(shadow_root)
    s.cache(strategy: s.Ephemeral)
    |> result.map_error(error.SketchError)
    |> result.map(sketch.compose(shadow, view, _))
  })

  use dispatcher <- result.map({
    fn(_) { #(model.new(shadow_root, opts.timeout), effect.none()) }
    |> lustre.application(update, view)
    |> lustre.start(lustre_root, Nil)
    |> result.map_error(error.LustreError)
  })

  ffi.store_dispatcher(dispatcher)
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
    msg.Remove(id) -> #(model.remove(model, id), effect.none())
    msg.Stop(id) -> #(model.stop(model, id), effect.none())

    msg.Show(id:, timeout:, sticky:) -> {
      let time = option.unwrap(timeout, model.timeout)
      let new_model = model.show(model, id)
      let eff = case sticky {
        True -> effect.none()
        False -> schedule(time, msg.Hide(id, 0))
      }
      #(new_model, eff)
    }

    msg.ExternalHide(uuid:) ->
      model.toasts
      |> list.find(fn(toast) { toast.external_id == uuid })
      |> result.map(fn(toast) {
        schedule(1000, msg.Hide(toast.id, toast.iteration))
      })
      |> result.map(pair.new(model, _))
      |> result.unwrap(#(model, effect.none()))

    msg.Hide(id, iteration) ->
      model.toasts
      |> list.find(fn(toast) { toast.id == id && toast.iteration == iteration })
      |> result.map(fn(toast) {
        model
        |> model.hide(toast.id)
        |> model.decrease_bottom(toast.id)
        |> pair.new(schedule(1000, msg.Remove(id)))
      })
      |> result.unwrap(#(model, effect.none()))

    msg.Resume(id) -> {
      let new_model = model.resume(model, id)
      model.toasts
      |> list.find(fn(toast) { toast.id == id })
      |> result.map(fn(t) {
        case t.sticky {
          True -> effect.none()
          False -> schedule(t.remaining, msg.Hide(id, t.iteration))
        }
      })
      |> result.map(fn(eff) { #(new_model, eff) })
      |> result.unwrap(#(new_model, effect.none()))
    }

    msg.New(uuid:, message:, level:, timeout:, sticky:) -> {
      let old_id = model.id
      let new_model =
        model.add(uuid:, model:, message:, level:, timeout:, sticky:)
      #(new_model, schedule(100, msg.Show(old_id, timeout, sticky:)))
    }
  }
}
