import gleam/bool
import gleam/int
import gleam/list
import grille_pain/internals/css.{var} as _
import grille_pain/internals/data/model.{type Model, Model}
import grille_pain/internals/data/msg.{type Msg}
import grille_pain/internals/data/toast.{type Toast}
import grille_pain/internals/view/progress_bar
import grille_pain/internals/view/theme
import grille_pain/toast/level.{type Level}
import lustre/attribute
import lustre/element
import lustre/element/html
import lustre/event

pub fn view(model: Model) {
  let toasts = model.toasts
  element.keyed(html.div([attribute.class("grille-pain")], _), {
    use toast <- list.map(toasts)
    let id = int.to_string(toast.id)
    #(id, view_toast(toast))
  })
}

fn view_toast(toast: Toast) {
  let on_hide = select_on_click_action(toast)
  toast_wrapper(
    toast,
    [
      wrapper_dom_classes(toast),
      attribute.attribute("data-id", int.to_string(toast.id)),
    ],
    [
      toast_container(toast, [
        toast_content([on_hide], [html.text(toast.message)]),
        toast_progress_bar(toast),
      ]),
    ],
  )
}

fn select_on_click_action(toast: Toast) {
  use <- bool.lazy_guard(when: toast.sticky, return: attribute.none)
  event.on_click(msg.ToastTimedOut(toast.id, toast.iteration))
}

fn toast_container(toast: Toast, children: List(element.Element(Msg))) {
  let mouse_enter = event.on_mouse_enter(msg.UserEnteredToast(toast.id))
  let mouse_leave = event.on_mouse_leave(msg.UserLeavedToast(toast.id))
  let colors = toast_colors(toast.level)
  let toast = attribute.class("toast")
  html.div([mouse_enter, mouse_leave, toast, colors], children)
}

fn toast_progress_bar(toast: Toast) {
  use <- bool.lazy_guard(when: toast.sticky, return: element.none)
  progress_bar.view(toast)
}

fn toast_wrapper(toast: Toast, attributes, children) {
  let transition =
    attribute.class(case toast.displayed {
      toast.Show | toast.WillHide -> "toast-wrapper-all"
      toast.WillShow -> "toast-wrapper-right"
    })
  let right = #("right", case toast.displayed {
    toast.Show -> "0px"
    toast.WillShow | toast.WillHide -> {
      let width = var("grille_pain-width", "320px")
      "calc(-1 * " <> width <> " - 100px)"
    }
  })
  let top = #("top", int.to_string(toast.bottom) <> "px")
  html.div(
    [
      attribute.class("toast-wrapper"),
      transition,
      attribute.style([right, top]),
      ..attributes
    ],
    children,
  )
}

fn wrapper_dom_classes(toast: Toast) {
  let displayed = case toast.displayed {
    toast.Show -> "show"
    toast.WillHide -> "will-hide"
    toast.WillShow -> "will-show"
  }
  attribute.classes([
    #("grille_pain-toast", True),
    #("grille_pain-toast-" <> int.to_string(toast.id), True),
    #("grille_pain-toast-" <> displayed, True),
  ])
}

fn toast_colors(level: Level) {
  let #(background, text_color) = theme.color(from: level)
  let level = level.to_string(level)
  let background_ = "grille_pain-" <> level <> "-background"
  let text = "grille_pain-" <> level <> "-text-color"
  attribute.style([
    #("background", var(background_, background)),
    #("color", var(text, text_color)),
  ])
}

pub fn toast_content(attributes, children) {
  html.div([attribute.class("toast-content"), ..attributes], children)
}
