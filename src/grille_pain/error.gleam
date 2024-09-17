import lustre
import sketch/error

pub type GrillePainError {
  SketchError(error.SketchError)
  LustreError(lustre.Error)
}
