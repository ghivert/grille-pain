import gleam/int
import gleam/pair
import gleam/result
import grille_pain
import grille_pain/internals/view/colors
import grille_pain/lustre/toast
import grille_pain/toast/level
import layout
import lustre
import lustre/attribute
import lustre/effect
import lustre/element/html
import lustre/event
import sketch/lustre as sketch_lustre
import sketch/options as sketch_options

pub const base_content = " toast! Click it to hide, or try to display many toasts at once!"

pub type Model =
  Int

pub type Msg {
  DisplayBasicToast(String, fn(String) -> effect.Effect(Msg))
  DisplayCustomToast(level.Level)
  UpdateModel(Int)
}

pub fn main() {
  let init = fn(_) { #(0, effect.none()) }

  let assert Ok(_) = grille_pain.simple()
  let assert Ok(cache) =
    sketch_options.node()
    |> sketch_lustre.setup()

  let assert Ok(_) =
    view
    |> sketch_lustre.compose(cache)
    |> lustre.application(init, update, _)
    |> lustre.start("#app", Nil)
}

fn update(model: Model, msg: Msg) {
  case msg {
    UpdateModel(value) -> #(value, effect.none())
    DisplayBasicToast(content, toast) -> #(model, toast(content))
    DisplayCustomToast(level) -> {
      let content = level.to_string(level)
      toast.options()
      |> toast.timeout(model * 1000)
      |> toast.level(level)
      |> toast.custom(content)
      |> pair.new(model, _)
    }
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
    layout.section_description([], [
      html.text(
        "You can use grille_pain in an easy way, with some defaults! Clicking on one of those buttons will display a toast, without any further configuration! Try it directly!",
      ),
    ]),
    layout.actions_wrapper([], [
      layout.toast_button(
        colors.light,
        layout.palette.black,
        [event.on_click(DisplayBasicToast("Toast", toast.toast))],
        [html.text("Toast")],
      ),
      layout.toast_button(
        colors.success,
        layout.palette.white,
        [event.on_click(DisplayBasicToast("Success", toast.success))],
        [html.text("Success")],
      ),
      layout.toast_button(
        colors.info,
        layout.palette.white,
        [event.on_click(DisplayBasicToast("Info", toast.info))],
        [html.text("Info")],
      ),
      layout.toast_button(
        colors.warning,
        layout.palette.white,
        [event.on_click(DisplayBasicToast("Warning", toast.warning))],
        [html.text("Warning")],
      ),
      layout.toast_button(
        colors.error,
        layout.palette.white,
        [event.on_click(DisplayBasicToast("Error", toast.error))],
        [html.text("Error")],
      ),
    ]),
  ])
}

fn custom_toasts(model: Model) {
  layout.section([], [
    layout.section_description([], [
      html.text(
        "Here, you can choose the duration for the toast to be displayed! You can choose different settings, and run the different toasts with individual settings.",
      ),
    ]),
    html.div([], [
      html.text("Timeout (in seconds): "),
      html.text(int.to_string(model)),
    ]),
    html.input([
      attribute.value(int.to_string(model)),
      attribute.type_("range"),
      event.on_input(fn(value) {
        int.parse(value)
        |> result.map(UpdateModel)
        |> result.unwrap(UpdateModel(model))
      }),
    ]),
    layout.actions_wrapper([], [
      layout.toast_button(
        colors.light,
        layout.palette.black,
        [event.on_click(DisplayCustomToast(level.Standard))],
        [html.text("Toast")],
      ),
      layout.toast_button(
        colors.success,
        layout.palette.white,
        [event.on_click(DisplayCustomToast(level.Success))],
        [html.text("Success")],
      ),
      layout.toast_button(
        colors.info,
        layout.palette.white,
        [event.on_click(DisplayCustomToast(level.Info))],
        [html.text("Info")],
      ),
      layout.toast_button(
        colors.warning,
        layout.palette.white,
        [event.on_click(DisplayCustomToast(level.Warning))],
        [html.text("Warning")],
      ),
      layout.toast_button(
        colors.error,
        layout.palette.white,
        [event.on_click(DisplayCustomToast(level.Error))],
        [html.text("Error")],
      ),
    ]),
  ])
}

fn view(model: Model) {
  layout.body([], [
    layout.main([], [header(), simple_toasts(), custom_toasts(model)]),
  ])
}
