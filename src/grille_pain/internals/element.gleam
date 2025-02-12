pub type Element

@external(javascript, "./element.ffi.mjs", "create")
pub fn create(tag: String) -> Result(Element, Nil)

/// Append a child to an element, and return the parent element.
@external(javascript, "./element.ffi.mjs", "appendChild")
pub fn append_child(element: Element, child: Element) -> Element

@external(javascript, "./element.ffi.mjs", "body")
pub fn body() -> Result(Element, Nil)
