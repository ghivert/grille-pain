import grille_pain/toast/level

pub const info = "#3498db"

pub const success = "#07bc0c"

pub const warning = "#f1c40f"

pub const error = "#e74c3c"

pub const color_transparent = "rgba(255, 255, 255, 0.7)"

pub const light_transparent = "rgb(0, 0, 0, 0.7)"

pub const dark_transparent = "rgb(255, 255, 255, 0.7)"

pub const dark = "#121212"

pub const light = "#fff"

pub fn color(from level: level.Level) {
  case level {
    level.Standard -> standard()
    level.Info -> #(info, light)
    level.Success -> #(success, light)
    level.Warning -> #(warning, light)
    level.Error -> #(error, light)
  }
}

@external(javascript, "./theme.ffi.mjs", "isDark")
pub fn is_dark() -> Bool

fn standard() {
  case is_dark() {
    True -> #(dark, light)
    False -> #(light, dark)
  }
}
