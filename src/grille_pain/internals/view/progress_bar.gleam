import gleam/int
import grille_pain/internals/css.{var} as _
import grille_pain/internals/data/toast.{type Toast}
import grille_pain/internals/view/theme
import grille_pain/toast/level.{type Level}
import lustre/attribute
import lustre/element/html

pub fn view(toast: Toast) {
  let animation_duration = int.to_string(toast.animation_duration)
  let play_state = toast.running_to_string(toast.running)
  let duration = #("animation-duration", animation_duration <> "ms")
  let background = #("background", pb_background_color(toast.level))
  let play_state = #("animation-play-state", play_state)
  let style = attribute.style([duration, background, play_state])
  html.div([attribute.class("progress-bar"), style], [])
}

fn pb_background_color(level: Level) {
  let back_color = background_color(from: level)
  let level = level.to_string(level)
  let variable = "grille_pain-" <> level <> "-progress-bar"
  var(variable, back_color)
}

fn background_color(from level: level.Level) {
  case level {
    level.Info -> theme.color_transparent
    level.Success -> theme.color_transparent
    level.Warning -> theme.color_transparent
    level.Error -> theme.color_transparent
    level.Standard ->
      case theme.is_dark() {
        True -> theme.dark_transparent
        False -> theme.light_transparent
      }
  }
}
