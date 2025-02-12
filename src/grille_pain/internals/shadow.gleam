import grille_pain/internals/element.{type Element}

pub type Shadow

@external(javascript, "./element.ffi.mjs", "attachShadow")
pub fn attach(element: Element) -> Result(Shadow, Nil)

@external(javascript, "./element.ffi.mjs", "appendChild")
pub fn append_child(root: Shadow, element: Element) -> Shadow

@external(javascript, "./element.ffi.mjs", "addKeyframe")
pub fn add_keyframe(root: Shadow) -> Result(Shadow, Nil)
