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
    msg.Remove(id) -> Ok(#(model.remove(model, id), effect.none()))
    msg.Stop(id) -> Ok(#(model.stop(model, id), effect.none()))
    msg.Show(..) -> show(model, msg)
    msg.ExternalHide(uuid:) -> external_hide(model, uuid)
    msg.Hide(id, iteration) -> hide(model, id, iteration)
    msg.Resume(id) -> resume(model, id)
    msg.New(..) -> new(model, msg)
  }
  |> result.unwrap(#(model, effect.none()))
}

fn show(model: Model, msg: msg.Msg) {
  let assert msg.Show(id:, timeout:, sticky:) = msg
  let time = option.unwrap(timeout, model.timeout)
  let new_model = model.show(model, id)
  let eff = schedule_hide(sticky, time, id, 0)
  Ok(#(new_model, eff))
}

fn external_hide(model: Model, uuid: String) {
  let toast = model.toasts |> list.find(toast.by_uuid(_, uuid))
  use toast <- result.map(toast)
  #(model, schedule(1000, msg.Hide(toast.id, toast.iteration)))
}

fn hide(model: Model, id: Int, iteration: Int) {
  let toast = model.toasts |> list.find(toast.by_iteration(_, id, iteration))
  use toast <- result.map(toast)
  model
  |> model.hide(toast.id)
  |> model.decrease_bottom(toast.id)
  |> pair.new(schedule(1000, msg.Remove(id)))
}

fn resume(model: Model, id: Int) {
  let new_model = model.resume(model, id)
  let toast = model.toasts |> list.find(toast.by_id(_, id))
  use toast.Toast(sticky:, remaining:, iteration:, ..) <- result.map(toast)
  #(new_model, schedule_hide(sticky, remaining, id, iteration))
}

fn new(model: Model, msg: Msg) {
  let assert msg.New(uuid:, message:, level:, timeout:, sticky:) = msg
  let old_id = model.id
  let new_model = model.add(uuid:, model:, message:, level:, timeout:, sticky:)
  Ok(#(new_model, schedule(100, msg.Show(old_id, timeout, sticky:))))
}

fn schedule_hide(sticky, timeout, id, iteration) {
  use <- bool.lazy_guard(when: sticky, return: effect.none)
  schedule(timeout, msg.Hide(id, iteration))
}
