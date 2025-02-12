pub type Element

@external(javascript, "../../element.ffi.mjs", "create")
pub fn create(_tag: String) -> Result(Element, Nil) {
  Error(Nil)
}

/// Append a child to an element, and return the parent element.
@external(javascript, "../../element.ffi.mjs", "appendChild")
pub fn append_child(_element: Element, _child: Element) -> Result(Element, Nil) {
  Error(Nil)
}

@external(javascript, "../../element.ffi.mjs", "body")
pub fn body() -> Result(Element, Nil) {
  Error(Nil)
}
