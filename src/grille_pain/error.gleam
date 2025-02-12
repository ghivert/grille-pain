import gleam/result
import lustre
import sketch/error

pub type GrillePainError {
  SketchError(error.SketchError)
  LustreError(lustre.Error)
  ContextError(String)
}

pub fn sketch(res: Result(a, error.SketchError)) {
  result.map_error(res, SketchError)
}

pub fn lustre(res: Result(a, lustre.Error)) {
  result.map_error(res, LustreError)
}

pub fn context(res: Result(a, b), context: String) {
  result.replace_error(res, ContextError(context))
}
