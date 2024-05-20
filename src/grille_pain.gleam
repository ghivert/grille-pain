//// `grille_pain` provides a simili effect manager to display and manage your
//// toasts. You should instanciate at most one grille-pain on your applications.
////
//// This package exposes two entrypoints: `simple` and `setup`. The first one
//// should be appropriated for most use-cases. Reach for the next one if you
//// really need to customise options.

import gleam/dynamic
import gleam/function
import gleam/io
import gleam/list
import gleam/option
import gleam/pair
import gleam/result
import grille_pain/internals/data/model.{type Model, Model}
import grille_pain/internals/data/msg.{type Msg} as t
import grille_pain/internals/ffi
import grille_pain/internals/lustre/schedule.{schedule}
import grille_pain/internals/view.{view}
import grille_pain/options.{type Options}
import lustre
import lustre/effect
import plinth/browser/document
import plinth/browser/element
import plinth/browser/shadow
import sketch/lustre as sketch
import sketch/options as sketch_options
import tardis

/// Setup a new `grille_pain` instance. You should not instanciate two instances
/// on the page, as `grille_pain` expect to run as a singleton.
/// Use `grille_pain/options` to provide and customise options.
pub fn setup(opts: Options) {
  let node = document.create_element("grille-pain")
  let lustre_root_ = document.create_element("div")
  let shadow_root = shadow.attach_shadow(node, shadow.Open)
  let lustre_root = dynamic.unsafe_coerce(dynamic.from(lustre_root_))
  shadow.append_child(shadow_root, lustre_root_)
  document.body()
  |> element.append_child(node)
  ffi.add_keyframe(shadow_root)

  let #(wrapper, activate) =
    opts.debug
    |> option.map(tardis.application(_, "grille-pain"))
    |> option.map(fn(d) { #(tardis.wrap(_, d), tardis.activate(_, d)) })
    |> option.unwrap(#(function.identity, function.identity))

  let render =
    sketch_options.shadow(shadow_root)
    |> sketch.setup()
    |> result.map_error(io.debug)
    |> result.map(sketch.compose(view, _))
    |> result.unwrap(view)

  let dispatcher =
    fn(_) { #(model.new(shadow_root, opts.timeout), effect.none()) }
    |> lustre.application(update, render)
    |> wrapper()
    |> lustre.start(lustre_root, Nil)
    |> activate()

  dispatcher
  |> result.map_error(io.debug)
  |> result.map(ffi.store_dispatcher)
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
    t.RemoveToast(id) -> #(model.remove(model, id), effect.none())
    t.StopToast(id) -> #(model.stop(model, id), effect.none())

    t.ShowToast(id, timeout) -> {
      let time = option.unwrap(timeout, model.timeout)
      let new_model = model.show(model, id)
      let eff = schedule(time, t.HideToast(id, 0))
      #(new_model, eff)
    }

    t.HideToast(id, iteration) ->
      model.toasts
      |> list.find(fn(toast) { toast.id == id && toast.iteration == iteration })
      |> result.map(fn(toast) {
        model
        |> model.hide(toast.id)
        |> model.decrease_bottom(toast.id)
        |> pair.new(schedule(1000, t.RemoveToast(id)))
      })
      |> result.unwrap(#(model, effect.none()))

    t.ResumeToast(id) -> {
      let new_model = model.resume(model, id)
      model.toasts
      |> list.find(fn(toast) { toast.id == id })
      |> result.map(fn(t) {
        schedule(t.remaining, t.HideToast(id, t.iteration))
      })
      |> result.map(fn(eff) { #(new_model, eff) })
      |> result.unwrap(#(new_model, effect.none()))
    }

    t.NewToast(content, level, timeout) -> {
      let old_id = model.id
      let new_model = model.add(model, content, level, timeout)
      #(new_model, schedule(100, t.ShowToast(old_id, timeout)))
    }
  }
}
