import grille_pain/toast/level

pub const info = "var(--info)"

pub const success = "var(--success)"

pub const warning = "var(--warning)"

pub const error = "var(--error)"

pub const color_transparent = "var(--color-transparent)"

pub const light_transparent = "var(--light-transparent)"

pub const dark_transparent = "var(--dark-transparent)"

pub const dark = "var(--dark)"

pub const light = "var(--light)"

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
pub fn is_dark() -> Bool {
  // That function can probably never be reached, since `grille_pain` will
  // never be instanciated on the BEAM.
  False
}

fn standard() {
  case is_dark() {
    True -> #(dark, light)
    False -> #(light, dark)
  }
}
