@target(javascript)
import gleam/dynamic
import gleam/result
import grille_pain/error
import grille_pain/internals/data/model.{type Model}
@target(javascript)
import grille_pain/internals/element
import grille_pain/internals/shadow.{type Shadow}
@target(javascript)
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
  use shadow <- result.try(shadow.append_child(shadow, lustre_root_))
  use shadow <- result.try(shadow.add_keyframe(shadow))
  use body <- result.try(element.body())
  let _ = element.append_child(body, node)
  Ok(#(lustre_root, shadow))
}

@target(erlang)
fn do_mount() -> Result(#(String, Shadow), Nil) {
  Error(Nil)
}

pub fn view(shadow: Shadow) {
  let container = container(shadow)
  sketch.stylesheet(strategy: sketch.Persistent)
  |> error.sketch
  |> result.map(fn(stylesheet) {
    fn(model: Model) {
      use <- sketch_lustre.render(stylesheet, in: [container])
      view.view(model)
    }
  })
}

@target(javascript)
fn container(shadow: Shadow) -> sketch_lustre.Container {
  sketch_lustre.shadow(dynamic.from(shadow))
}

@target(erlang)
fn container(_shadow: Shadow) -> sketch_lustre.Container {
  sketch_lustre.node()
}
