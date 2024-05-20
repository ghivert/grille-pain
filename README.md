# 🍞 Grille-Pain

`grille_pain` is a toaster for lustre, and gleam in a more general manner.

## Installation

```sh
gleam add grille_pain
```

## Quickstart

```gleam
import gleam/pair
import grille_pain
import grille_pain/lustre/toast
import grille_pain/toast/level
import lustre
import lustre/attribute
import lustre/effect
import lustre/element/html
import lustre/event
import sketch/lustre as sketch_lustre
import sketch/options as sketch_options

pub type Model =
  Int

pub type Msg {
  DisplayBasicToast(content: String)
}


pub fn main() {
  let assert Ok(_) = grille_pain.simple()
  let assert Ok(_) =
    lustre.application(init, update, view)
    |> lustre.start("#app", Nil)
}

fn init(_flags) {
  #(0, effect.none())
}

fn update(model: Model, msg: Msg) {
  case msg {
    DisplayBasicToast(content) ->
      #(model, toast.toast(content))
  }
}

fn view(model: Model) {
  html.div([], [
    html.button([event.on_click(DisplayBasicToast("Success"))], [
      html.text("Display toast")
    ])
  ])
}
```

## Styling

`--grille_pain-width`
`--grille_pain-toast-width,`
`--grille_pain-toast-min-height`
`--grille_pain-toast-max-height`
`--grille_pain-toast-border-radius`

`--grille_pain-Standard-background`
`--grille_pain-Standard-text-color`
`--grille_pain-Standard-progress-bar`
`--grille_pain-Info-background`
`--grille_pain-Info-text-color`
`--grille_pain-Info-progress-bar`
`--grille_pain-Warning-background`
`--grille_pain-Warning-text-color`
`--grille_pain-Warning-progress-bar`
`--grille_pain-Error-background`
`--grille_pain-Error-text-color`
`--grille_pain-Error-progress-bar`
`--grille_pain-Success-background`
`--grille_pain-Success-text-color`
`--grille_pain-Success-progress-bar`
