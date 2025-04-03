@target(javascript)
import gleam/result
import grille_pain/error
@target(javascript)
import grille_pain/internals/element
import grille_pain/internals/shadow.{type Shadow}
@target(javascript)
import grille_pain/internals/unsafe

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
  use shadow <- result.try(shadow.add_styles(shadow))
  use body <- result.try(element.body())
  let _ = element.append_child(body, node)
  Ok(#(lustre_root, shadow))
}

@target(erlang)
fn do_mount() -> Result(#(String, Shadow), Nil) {
  Error(Nil)
}
