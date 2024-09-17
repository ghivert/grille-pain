import gleam/int
import grille_pain/internals/data/toast.{type Toast}
import grille_pain/internals/view/colors
import grille_pain/toast/level.{type Level}
import sketch
import sketch/lustre/element/html
import sketch/size.{px}

pub fn view(toast: Toast) {
  sketch.class([
    sketch.compose(pb_play_state(toast.running)),
    sketch.compose(pb_background_color(toast.level)),
    sketch.compose(pb_animation(toast.animation_duration)),
    sketch.compose(pb_base()),
  ])
  |> html.div([], [])
}

fn pb_base() {
  sketch.class([sketch.animation_fill_mode("forwards"), sketch.height(px(5))])
}

fn pb_animation(duration: Int) {
  let duration = int.to_string(duration / 1000)
  let animation = duration <> "s linear 0s progress_bar"
  sketch.class([sketch.animation(animation)])
}

fn pb_background_color(level: Level) {
  let back_color = colors.progress_bar_from_level(level)
  let level = level.to_string(level)
  let background =
    "var(--grille_pain-" <> level <> "-progress-bar, " <> back_color <> ")"
  sketch.class([sketch.background(background)])
}

fn pb_play_state(running: Bool) {
  let running_str = toast.running_to_string(running)
  sketch.class([sketch.animation_play_state(running_str)])
}
