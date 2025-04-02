import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import grille_pain
import grille_pain/internals/view/theme
import grille_pain/lustre/toast
import grille_pain/toast/level
import layout
import lustre
import lustre/attribute
import lustre/effect
import lustre/event
import sketch
import sketch/lustre as sketch_lustre
import sketch/lustre/element/html

pub const base_content = " toast! Click it to hide, or try to display many toasts at once!"

pub const base_sticky = " toast! It will stick here until you hide it."

pub type Model {
  Model(timeout: Int, stickys: List(String))
}

pub type Msg {
  DisplayBasicToast(content: String, toast: fn(String) -> effect.Effect(Msg))
  DisplayCustomToast(level: level.Level)
  DisplayStickyToast(level: level.Level)
  HideStickyToasts
  UpdateStickyToastId(id: String)
  UpdateTimeout(timeout: Int)
}

pub fn main() {
  let init = fn(_) { #(Model(timeout: 0, stickys: []), effect.none()) }
  let assert Ok(_) = grille_pain.simple()
  let assert Ok(stylesheet) = sketch.stylesheet(strategy: sketch.Ephemeral)
  let assert Ok(_) =
    view(_, stylesheet)
    |> lustre.application(init, update, _)
    |> lustre.start("#app", Nil)
}

fn update(model: Model, msg: Msg) {
  case msg {
    DisplayBasicToast(content, toast) -> #(model, toast(content))
    DisplayCustomToast(level) -> {
      pair.new(model, {
        effect.batch({
          list.repeat(0, 10)
          |> list.map(fn(_) {
            let content = level.to_string(level)
            toast.options()
            |> toast.timeout(model.timeout * int.max(100, int.random(1000)))
            |> toast.level(level)
            |> toast.custom(content <> base_content)
          })
        })
      })
    }
    DisplayStickyToast(level) -> {
      let content = level.to_string(level)
      toast.options()
      |> toast.sticky
      |> toast.level(level)
      |> toast.notify(UpdateStickyToastId)
      |> toast.custom(content <> base_sticky)
      |> pair.new(model, _)
    }
    HideStickyToasts -> {
      list.map(model.stickys, toast.hide)
      |> effect.batch
      |> pair.new(Model(..model, stickys: []), _)
    }
    UpdateStickyToastId(id:) -> {
      [id, ..model.stickys]
      |> fn(stickys) { Model(..model, stickys:) }
      |> pair.new(effect.none())
    }
    UpdateTimeout(timeout:) -> #(Model(..model, timeout:), effect.none())
  }
}

fn header() {
  layout.header_wrapper([], [
    layout.lucy([attribute.src("./priv/images/lucy.svg")]),
    layout.title_wrapper([], [
      layout.title([], [html.text("Hello Grille-Pain!")]),
      layout.subtitle([], [
        html.text(
          "This is a page example for grille_pain package in gleam, illustrating the different possibilities for toast display!",
        ),
      ]),
    ]),
  ])
}

fn simple_toasts() {
  layout.section([], [
    layout.section_title([], [html.text("Simple toasts")]),
    layout.section_description([], [
      html.text(
        "You can use grille_pain in an easy way, with some defaults! Clicking on one of those buttons will display a toast, without any further configuration! Try it directly!",
      ),
    ]),
    layout.actions_wrapper([], [
      layout.toast_button(
        theme.light,
        layout.palette.black,
        [event.on_click(DisplayBasicToast("Toast", toast.toast))],
        [html.text("Toast")],
      ),
      layout.toast_button(
        theme.success,
        layout.palette.white,
        [event.on_click(DisplayBasicToast("Success", toast.success))],
        [html.text("Success")],
      ),
      layout.toast_button(
        theme.info,
        layout.palette.white,
        [event.on_click(DisplayBasicToast("Info", toast.info))],
        [html.text("Info")],
      ),
      layout.toast_button(
        theme.warning,
        layout.palette.white,
        [event.on_click(DisplayBasicToast("Warning", toast.warning))],
        [html.text("Warning")],
      ),
      layout.toast_button(
        theme.error,
        layout.palette.white,
        [event.on_click(DisplayBasicToast("Error", toast.error))],
        [html.text("Error")],
      ),
    ]),
  ])
}

fn custom_toasts(model: Model) {
  layout.section([], [
    layout.section_title([], [html.text("Custom toasts")]),
    layout.section_description([], [
      html.text(
        "Choose the duration for the toast to be displayed! You can choose different settings, and run the different toasts with individual settings.",
      ),
    ]),
    html.div_([], [
      html.text("Timeout (in seconds): "),
      html.text(int.to_string(model.timeout)),
    ]),
    html.input_([
      attribute.value(int.to_string(model.timeout)),
      attribute.type_("range"),
      event.on_input(fn(value) {
        int.parse(value)
        |> result.map(UpdateTimeout)
        |> result.unwrap(UpdateTimeout(model.timeout))
      }),
    ]),
    layout.actions_wrapper([], [
      layout.toast_button(
        theme.light,
        layout.palette.black,
        [event.on_click(DisplayCustomToast(level.Standard))],
        [html.text("Toast")],
      ),
      layout.toast_button(
        theme.success,
        layout.palette.white,
        [event.on_click(DisplayCustomToast(level.Success))],
        [html.text("Success")],
      ),
      layout.toast_button(
        theme.info,
        layout.palette.white,
        [event.on_click(DisplayCustomToast(level.Info))],
        [html.text("Info")],
      ),
      layout.toast_button(
        theme.warning,
        layout.palette.white,
        [event.on_click(DisplayCustomToast(level.Warning))],
        [html.text("Warning")],
      ),
      layout.toast_button(
        theme.error,
        layout.palette.white,
        [event.on_click(DisplayCustomToast(level.Error))],
        [html.text("Error")],
      ),
    ]),
  ])
}

fn sticky_toasts() {
  layout.section([], [
    layout.section_title([], [html.text("Sticky toasts")]),
    layout.section_description([], [
      html.text(
        "Here, you can choose the duration for the toast to be displayed! You can choose different settings, and run the different toasts with individual settings.",
      ),
    ]),
    layout.actions_wrapper([], [
      layout.toast_button(
        theme.light,
        layout.palette.black,
        [event.on_click(DisplayStickyToast(level.Standard))],
        [html.text("Toast")],
      ),
      layout.toast_button(
        theme.success,
        layout.palette.white,
        [event.on_click(DisplayStickyToast(level.Success))],
        [html.text("Success")],
      ),
      layout.toast_button(
        theme.info,
        layout.palette.white,
        [event.on_click(DisplayStickyToast(level.Info))],
        [html.text("Info")],
      ),
      layout.toast_button(
        theme.warning,
        layout.palette.white,
        [event.on_click(DisplayStickyToast(level.Warning))],
        [html.text("Warning")],
      ),
      layout.toast_button(
        theme.error,
        layout.palette.white,
        [event.on_click(DisplayStickyToast(level.Error))],
        [html.text("Error")],
      ),
    ]),
    html.br_([]),
    layout.actions_wrapper([], [
      layout.toast_button(
        theme.error,
        layout.palette.white,
        [event.on_click(HideStickyToasts)],
        [html.text("Hide sticky toasts")],
      ),
    ]),
  ])
}

fn view(model: Model, stylesheet: sketch.StyleSheet) {
  use <- sketch_lustre.render(stylesheet, in: [sketch_lustre.node()])
  layout.body([], [
    layout.main([], [
      header(),
      simple_toasts(),
      custom_toasts(model),
      sticky_toasts(),
    ]),
  ])
}
