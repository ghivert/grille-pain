import gleam/int
import gleam/list
import grille_pain/internals/data/model.{type Model, Model}
import grille_pain/internals/data/msg.{type Msg, Hide, Resume, Stop}
import grille_pain/internals/data/toast.{type Toast}
import grille_pain/internals/view/colors
import grille_pain/internals/view/progress_bar
import grille_pain/toast/level.{type Level}
import lustre/attribute
import lustre/event
import sketch
import sketch/lustre/element
import sketch/lustre/element/html
import sketch/size.{px}

pub fn view(model: Model) {
  let toasts = model.toasts
  element.keyed(html.div_([attribute.class("grille-pain")], _), {
    use toast <- list.map(toasts)
    let id = int.to_string(toast.id)
    #(id, view_toast_wrapper(toast))
  })
}

fn view_toast_wrapper(toast: Toast) {
  let on_hide = case toast.sticky {
    False -> event.on_click(Hide(toast.id, toast.iteration))
    True -> attribute.none()
  }
  html.div(wrapper_position_style(toast), [wrapper_dom_classes(toast)], [
    view_toast(toast, [
      html.div(text_wrapper(), [on_hide], [html.text(toast.message)]),
      case toast.sticky {
        False -> progress_bar.view(toast)
        True -> element.none()
      },
    ]),
  ])
}

fn view_toast(toast: Toast, children: List(element.Element(Msg))) {
  let mouse_enter = event.on_mouse_enter(Stop(toast.id))
  let mouse_leave = event.on_mouse_leave(Resume(toast.id))
  [toast_colors(toast.level), toast_class()]
  |> list.map(sketch.compose)
  |> sketch.class
  |> html.div([mouse_enter, mouse_leave], children)
}

fn wrapper_position_style(toast: Toast) {
  let min_bot = int.max(0, toast.bottom)
  sketch.class([
    sketch.padding(px(12)),
    sketch.position("fixed"),
    sketch.top(px(min_bot)),
    sketch.transition("right 0.7s, top 0.7s"),
    sketch.z_index(1_000_000),
    case toast.displayed {
      True -> sketch.right(px(0))
      False ->
        sketch.right_("calc(-1 * var(--grille_pain-width, 320px) - 100px)")
    },
  ])
}

fn wrapper_dom_classes(toast: Toast) {
  let displayed = case toast.displayed {
    True -> "visible"
    False -> "hidden"
  }
  attribute.classes([
    #("grille_pain-toast", True),
    #("grille_pain-toast-" <> int.to_string(toast.id), True),
    #("grille_pain-toast-" <> displayed, True),
  ])
}

fn toast_class() {
  sketch.class([
    sketch.display("flex"),
    sketch.flex_direction("column"),
    // Sizes
    sketch.width_("var(--grille_pain-toast-width, 320px)"),
    sketch.min_height_("var(--grille_pain-toast-min-height, 64px)"),
    sketch.max_height_("var(--grille_pain-toast-max-height, 800px)"),
    // Spacings
    sketch.border_radius_("var(--grille_pain-toast-border-radius, 6px)"),
    // Colors
    sketch.box_shadow("0px 4px 12px rgba(0, 0, 0, 0.1)"),
    // Animation
    sketch.overflow("hidden"),
    sketch.cursor("pointer"),
  ])
}

fn toast_colors(level: Level) {
  let #(background, text_color) = colors.from_level(level)
  let level = level.to_string(level)
  sketch.class([
    sketch.background(
      "var(--grille_pain-" <> level <> "-background, " <> background <> ")",
    ),
    sketch.color(
      "var(--grille_pain-" <> level <> "-text-color, " <> text_color <> ")",
    ),
  ])
}

fn text_wrapper() {
  sketch.class([
    sketch.display("flex"),
    sketch.align_items("center"),
    sketch.flex("1"),
    sketch.padding_("8px 16px"),
    sketch.font_size(px(14)),
  ])
}
