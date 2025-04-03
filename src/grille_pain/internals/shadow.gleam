import grille_pain/internals/element.{type Element}

pub type Shadow

@external(javascript, "./element.ffi.mjs", "attachShadow")
pub fn attach(_element: Element) -> Result(Shadow, Nil) {
  Error(Nil)
}

@external(javascript, "./element.ffi.mjs", "appendChild")
pub fn append_child(_root: Shadow, _element: Element) -> Result(Shadow, Nil) {
  Error(Nil)
}

@external(javascript, "./element.ffi.mjs", "addStyles")
pub fn add_styles(_root: Shadow) -> Result(Shadow, Nil) {
  Error(Nil)
}
