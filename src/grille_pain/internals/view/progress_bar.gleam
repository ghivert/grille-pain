import gleam/int
import grille_pain/internals/css.{var} as _
import grille_pain/internals/data/toast.{type Toast}
import grille_pain/internals/view/theme
import grille_pain/toast/level.{type Level}
import sketch/css
import sketch/css/length.{px}
import sketch/lustre/element/html

pub fn view(toast: Toast) {
  css.class([
    css.compose(pb_base()),
    css.compose(pb_background_color(toast.level)),
    css.compose(pb_animation(toast.animation_duration)),
    css.compose(pb_play_state(toast.running)),
  ])
  |> html.div([], [])
}

fn pb_base() {
  css.class([css.animation_fill_mode("forwards"), css.height(px(5))])
}

fn pb_animation(duration: Int) {
  let duration = int.to_string(duration / 1000)
  let animation = duration <> "s linear 0s progress_bar"
  css.class([css.animation(animation)])
}

fn pb_background_color(level: Level) {
  let back_color = background_color(from: level)
  let level = level.to_string(level)
  let background = var("grille_pain-" <> level <> "-progress-bar", back_color)
  css.class([css.background(background)])
}

fn pb_play_state(running: Bool) {
  let running_str = toast.running_to_string(running)
  css.class([css.animation_play_state(running_str) |> css.important])
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
