# 🍞 Grille-Pain

`grille_pain` is a toaster for lustre, and gleam in a more general manner. It
tries to be both simple to use, and simple to customise to adapt to your use
case. Features could be missing, as `grille_pain` is also an experimentation to
add support for effect managers for lustre. It can however completely be used
in your application, even if you're not using lustre. `grille_pain` will never
breaks intentionnally, and will always take care of providing non-breaking minor
updates, but you can potentially expect lot of major updates while design of
effect managers evolve!

[Because a demo is worth thousand words, you can find one directly here.](https://ghivert.github.io/grille-pain/)

In order to work without disturbing your application, `grille_pain` behaves as
an independant component on the page. After setup, `grille_pain` registers a
`<grille_pain>` node in the DOM, and instanciate a Shadow DOM, to make sure
styles won't intervene with yours.

This package is inspired by `react-toastify`, for colors and animations.

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

## Usage

Setup of `grille_pain` is achieved using `grille_pain.simple()` or
`grille_pain.setup()` and passing diverse options, like the default timeout for
toasts. Once setup, if you're using lustre, you should only take care of
`grille_pain/lustre/toast` and use them in your update function, while if not
using lustre, you can use `grille_pain/toast`. But be careful, this module is
side-effectful.

Displaying a toast is as simple as `toast.toast("Content")`, or you can build
your custom toast. [The documentation is hosted on hex](https://hexdocs.pm/grille_pain).

## Styling

Toasts are styled by default, except for fonts. To define a font that suits you,
you have to define a font on the `html`, `body` or `grille-pain` node in the DOM.
Fonts will pierce in the Shadow DOM and apply to the toasts!

If the default appearance of toasts does not please you, you can always style
the toasts! To do it, you have multiple CSS variables, that you can set on the
`grille-pain` node, directly in CSS.

Here, the different options, with their default values.

```css
grille-pain {
  /* Common options for toasts */
  --grille_pain-width: 320px;                       /* Wrapper size*/
  --grille_pain-toast-width: 320px;                 /* Toast size */
  --grille_pain-toast-min-height: 64px;             /* Toast min height */
  --grille_pain-toast-max-height: 800px;1           /* Toast max height */
  --grille_pain-toast-border-radius: 6px;           /* Toast border radius */

  /* Color for standard toast */
  --grille_pain-Standard-background: #ffffff;       /* Background color */
  --grille_pain-Standard-text-color: #121212;       /* Text color */
  --grille_pain-Standard-progress-bar: #000000b3;   /* Progress bar color */

  /* Color for info toast */
  --grille_pain-Info-background: #3498db;           /* Background color */
  --grille_pain-Info-text-color: #ffffff;           /* Text color */
  --grille_pain-Info-progress-bar: #ffffffb3;       /* Progress bar color */

  /* Color for warning toast */
  --grille_pain-Warning-background: #f1c40f;       /* Background color */
  --grille_pain-Warning-text-color: #ffffff;       /* Text color */
  --grille_pain-Warning-progress-bar: #ffffffb3;   /* Progress bar color */

  /* Color for error toast */
  --grille_pain-Error-background: #e74c3c;         /* Background color */
  --grille_pain-Error-text-color: #ffffff;         /* Text color */
  --grille_pain-Error-progress-bar: #ffffffb3;     /* Progress bar color */

  /* Color for success toast */
  --grille_pain-Success-background: #07bc0c;       /* Background color */
  --grille_pain-Success-text-color: #ffffff;       /* Text color */
  --grille_pain-Success-progress-bar: #ffffffb3;   /* Progress bar color */
}
```

## Contributing

You love the package and want to improve it? You have a shiny new framework and
want to provide an integration with `grille_pain` in this package? Every contribution is
welcome! Feel free to open a Pull Request, and let's discuss about it!
