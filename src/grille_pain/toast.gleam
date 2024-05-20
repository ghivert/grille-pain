//// `grille_pain/toast` defines the different side-effects to use to display
//// toasts. They should be used when your outside of lustre applications. Otherwise
//// you should [head up to `grille_pain/lustre/toast`](/grille_pain/grille_pain/lustre/toast.html).

import gleam/option.{type Option, None, Some}
import grille_pain/internals/data/msg
import grille_pain/internals/ffi
import grille_pain/toast/level.{type Level}
import lustre

/// Options type allow to modify timeout or level at the notification level
/// directly. This is used to create custom toasts and override defaults.
/// If you don't need custom toasts, you should head up to default functions
/// (`toast`, `info`, `success`, `error` and `warning`).
///
/// It follows the Builder pattern.
///
/// ```gleam
/// import grille_pain/toast
/// import grille_pain/toast/level
///
/// fn custom_toast() {
///   toast.options()
///   |> toast.timeout(millisecond1s: 30_000)
///   |> toast.level(level.Warning)
///   |> toast.custom("Oops")
/// }
/// ```
pub opaque type Options {
  Options(timeout: Option(Int), level: Option(Level))
}

/// Default, empty options. Use it to start Builder.
pub fn options() {
  Options(None, None)
}

/// Timeout to override defaults. Accepts a timeout in milliseconds.
pub fn timeout(options: Options, milliseconds timeout: Int) {
  Options(..options, timeout: Some(timeout))
}

/// Level of your toast.
pub fn level(options: Options, level: Level) {
  Options(..options, level: Some(level))
}

fn dispatch_toast(options: Options, content: String) {
  let grille_pain_dispatch = ffi.dispatcher()
  let level = option.unwrap(options.level, level.Standard)
  let timeout = options.timeout
  msg.NewToast(content, level, timeout)
  |> lustre.dispatch()
  |> grille_pain_dispatch()
}

pub fn info(content: String) {
  options()
  |> level(level.Info)
  |> dispatch_toast(content)
}

pub fn success(content: String) {
  options()
  |> level(level.Success)
  |> dispatch_toast(content)
}

pub fn error(content: String) {
  options()
  |> level(level.Error)
  |> dispatch_toast(content)
}

pub fn toast(content: String) {
  options()
  |> level(level.Standard)
  |> dispatch_toast(content)
}

pub fn warning(content: String) {
  options()
  |> level(level.Warning)
  |> dispatch_toast(content)
}

pub fn custom(options: Options, content: String) {
  dispatch_toast(options, content)
}
