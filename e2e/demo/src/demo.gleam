import gleam/int
import gleam/io
import gleam/pair
import gleam/result
import grille_pain
import grille_pain/internals/view/colors
import grille_pain/lustre/toast
import layout
import lustre
import lustre/attribute
import lustre/effect
import lustre/element
import lustre/element/html
import lustre/event
import sketch
import sketch/lustre as sketch_lustre
import sketch/media
import sketch/options as sketch_options
import sketch/size.{px}

pub type Model =
  Int

pub type Msg {
  DisplayBasicToast(effect.Effect(Msg))
  DisplayCustomToast(String)
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
    DisplayBasicToast(toast) -> #(model, toast)
    DisplayCustomToast(content) ->
      toast.options()
      |> toast.timeout(model * 1000)
      |> toast.custom(content)
      |> pair.new(model, _)
  }
}

fn view(model: Model) {
  layout.body([], [
    layout.main([], [
      layout.header_wrapper([], [
        layout.lucy([attribute.src("/priv/images/lucy.svg")]),
        layout.title_wrapper([], [
          layout.title([], [html.text("Hello Grille-Pain!")]),
          layout.subtitle([], [
            html.text(
              "This is a page example for grille_pain package in gleam, illustrating the different possibilities for toast display!",
            ),
          ]),
        ]),
      ]),
      layout.actions_wrapper([], [
        layout.toast_button(
          colors.success,
          [
            event.on_click(
              DisplayBasicToast(toast.success(
                "Success toast! Head over here, or try to display many toasts at once!",
              )),
            ),
          ],
          [html.text("Success")],
        ),
        layout.toast_button(colors.info, [], [html.text("Info")]),
        layout.toast_button(colors.warning, [], [html.text("Warning")]),
        layout.toast_button(colors.error, [], [html.text("Error")]),
      ]),
      html.div([], [html.text(int.to_string(model))]),
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
          colors.success,
          [
            event.on_click(DisplayCustomToast(
              "Success toast! Head over here, or try to display many toasts at once!",
            )),
          ],
          [html.text("Success")],
        ),
        layout.toast_button(colors.info, [], [html.text("Info")]),
        layout.toast_button(colors.warning, [], [html.text("Warning")]),
        layout.toast_button(colors.error, [], [html.text("Error")]),
      ]),
    ]),
  ])
}
