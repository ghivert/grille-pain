pub type Level {
  Standard
  Info
  Warning
  Error
  Success
}

pub fn to_string(level: Level) {
  case level {
    Standard -> "standard"
    Info -> "info"
    Warning -> "warning"
    Error -> "error"
    Success -> "succes"
  }
}
