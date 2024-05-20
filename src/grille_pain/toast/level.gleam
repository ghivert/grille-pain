//// Define the different levels of toasts.
//// Like logs, toasts have different levels according to their importance.
//// When choosing a level, the toast will use the corresponding theme variables,
//// allowing you to override the default styles.

pub type Level {
  Standard
  Info
  Warning
  Error
  Success
}

/// Mainly internal use, `to_string` allows you to get the exact representation
/// of the level.
pub fn to_string(level: Level) {
  case level {
    Standard -> "Standard"
    Info -> "Info"
    Warning -> "Warning"
    Error -> "Error"
    Success -> "Success"
  }
}
