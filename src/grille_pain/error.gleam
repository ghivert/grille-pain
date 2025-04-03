import gleam/result
import lustre

pub type GrillePainError {
  LustreError(lustre.Error)
  ContextError(String)
}

pub fn lustre(res: Result(a, lustre.Error)) {
  result.map_error(res, LustreError)
}

pub fn context(res: Result(a, b), context: String) {
  result.replace_error(res, ContextError(context))
}
