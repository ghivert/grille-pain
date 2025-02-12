import gleam/bool
import gleam/int
import gleam/list
import grille_pain/internals/css.{var} as _
import grille_pain/internals/data/model.{type Model, Model}
import grille_pain/internals/data/msg.{type Msg, Hide, Resume, Stop}
import grille_pain/internals/data/toast.{type Toast}
import grille_pain/internals/view/progress_bar
import grille_pain/internals/view/theme
import grille_pain/toast/level.{type Level}
import lustre/attribute
import lustre/event
import sketch/css
import sketch/css/length.{px}
import sketch/lustre/element
import sketch/lustre/element/html

pub fn view(model: Model) {
  let toasts = model.toasts
  element.keyed(html.div_([attribute.class("grille-pain")], _), {
    use toast <- list.map(toasts)
    let id = int.to_string(toast.id)
    #(id, view_toast(toast))
  })
}

fn view_toast(toast: Toast) {
  let on_hide = select_on_click_action(toast)
  toast_wrapper(toast, [wrapper_dom_classes(toast)], [
    toast_container(toast, [
      toast_content([on_hide], [html.text(toast.message)]),
      toast_progress_bar(toast),
    ]),
  ])
}

fn select_on_click_action(toast: Toast) {
  use <- bool.lazy_guard(when: toast.sticky, return: attribute.none)
  event.on_click(Hide(toast.id, toast.iteration))
}

fn toast_container(toast: Toast, children: List(element.Element(Msg))) {
  let mouse_enter = event.on_mouse_enter(Stop(toast.id))
  let mouse_leave = event.on_mouse_leave(Resume(toast.id))
  [toast_colors(toast.level), toast_class()]
  |> list.map(css.compose)
  |> css.class
  |> html.div([mouse_enter, mouse_leave], children)
}

fn toast_progress_bar(toast: Toast) {
  use <- bool.lazy_guard(when: toast.sticky, return: element.none)
  progress_bar.view(toast)
}

fn toast_wrapper(toast: Toast, attributes, children) {
  let min_bot = int.max(0, toast.bottom)
  css.class([
    css.padding(px(12)),
    css.position("fixed"),
    css.top(px(min_bot)),
    css.transition("right 0.7s, top 0.7s"),
    css.z_index(1_000_000),
    case toast.displayed {
      True -> css.right(px(0))
      False -> {
        let width = var("grille_pain-width", "320px")
        css.right_("calc(-1 * " <> width <> " - 100px)")
      }
    },
  ])
  |> html.div(attributes, children)
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
  css.class([
    css.display("flex"),
    css.flex_direction("column"),
    // Sizes
    css.width_(var("grille_pain-toast-width", "320px")),
    css.min_height_(var("grille_pain-toast-min-height", "64px")),
    css.max_height_(var("grille_pain-toast-max-height", "800px")),
    // Spacings
    css.border_radius_(var("grille_pain-toast-border-radius", "6px")),
    // Colors
    css.box_shadow("0px 4px 12px rgba(0, 0, 0, 0.1)"),
    // Animation
    css.overflow("hidden"),
    css.cursor("pointer"),
  ])
}

fn toast_colors(level: Level) {
  let #(background, text_color) = theme.color(from: level)
  let level = level.to_string(level)
  let background_ = "grille_pain-" <> level <> "-background"
  let text = "grille_pain-" <> level <> "-text-color"
  css.class([
    css.background(var(background_, background)),
    css.color(var(text, text_color)),
  ])
}

fn toast_content(attributes, children) {
  css.class([
    css.display("flex"),
    css.align_items("center"),
    css.flex("1"),
    css.padding_("8px 16px"),
    css.font_size(px(14)),
  ])
  |> html.div(attributes, children)
}
