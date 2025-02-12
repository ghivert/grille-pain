import gleam/dynamic
import gleam/result
import grille_pain/error
import grille_pain/internals/data/model.{type Model}
import grille_pain/internals/element
import grille_pain/internals/shadow.{type Shadow}
import grille_pain/internals/unsafe
import grille_pain/internals/view
import sketch
import sketch/lustre as sketch_lustre

pub fn mount() {
  do_mount() |> error.context("Impossible to mount grille_pain.")
}

@target(javascript)
fn do_mount() -> Result(#(String, Shadow), Nil) {
  use node <- result.try(element.create("grille-pain"))
  use lustre_root_ <- result.try(element.create("div"))
  let lustre_root = unsafe.coerce(lustre_root_)
  use shadow <- result.try(shadow.attach(node))
  let shadow = shadow.append_child(shadow, lustre_root_)
  use shadow <- result.try(shadow.add_keyframe(shadow))
  use body <- result.try(element.body())
  let _ = element.append_child(body, node)
  Ok(#(lustre_root, shadow))
}

@target(erlang)
fn do_mount() -> Result(#(String, Shadow), Nil) {
  Error(Nil)
}

@target(javascript)
pub fn view(shadow: Shadow) {
  let container = sketch_lustre.shadow(dynamic.from(shadow))
  sketch.stylesheet(strategy: sketch.Persistent)
  |> error.sketch
  |> result.map(fn(stylesheet) {
    fn(model: Model) {
      use <- sketch_lustre.render(stylesheet, in: [container])
      view.view(model)
    }
  })
}

@target(erlang)
pub fn view(shadow: Shadow) {
  let container = sketch_lustre.node()
  sketch.stylesheet(strategy: sketch.Persistent)
  |> error.sketch
  |> result.map(fn(stylesheet) {
    fn(model: Model) {
      use <- sketch_lustre.render(stylesheet, in: [container])
      view.view(model)
    }
  })
}
