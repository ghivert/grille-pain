pub type Level {
  Standard
  Info
  Warning
  Error
  Success
}

pub fn to_string(level: Level) {
  case level {
    Standard -> "Standard"
    Info -> "Info"
    Warning -> "Warning"
    Error -> "Error"
    Success -> "Success"
  }
}
