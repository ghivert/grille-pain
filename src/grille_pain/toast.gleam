//// `grille_pain/toast` defines the different side-effects to use to display
//// toasts. They should be used when your outside of lustre applications. Otherwise
//// you should [head up to `grille_pain/lustre/toast`](/grille_pain/grille_pain/lustre/toast.html).

import gleam/function
import gleam/option.{type Option, None, Some}
import grille_pain/internals/data/msg
import grille_pain/internals/data/toast
import grille_pain/internals/effect_manager
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
///   |> toast.timeout(milliseconds: 30_000)
///   |> toast.level(level.Warning)
///   |> toast.custom("Oops")
/// }
/// ```
pub opaque type Options {
  Options(timeout: Option(Int), level: Option(Level), sticky: Bool)
}

/// Default, empty options. Use it to start Builder.
pub fn options() {
  Options(timeout: None, level: None, sticky: False)
}

/// Timeout to override defaults. Accepts a timeout in milliseconds.
pub fn timeout(options: Options, milliseconds timeout: Int) {
  Options(..options, timeout: Some(timeout))
}

/// Activate stickiness for toasts. A sticky toast will never go away while it's
/// not hidden manually.
pub fn sticky(options: Options) {
  Options(..options, sticky: True)
}

/// Level of your toast.
pub fn level(options: Options, level: Level) {
  Options(..options, level: Some(level))
}

fn dispatch_toast(options: Options, message: String) {
  use uuid <- function.tap(toast.uuid())
  use dispatch <- effect_manager.call
  let Options(timeout:, level:, sticky:) = options
  let level = option.unwrap(level, level.Standard)
  msg.UserAddedToast(uuid:, message:, level:, timeout:, sticky:)
  |> lustre.dispatch
  |> dispatch
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

/// Hide toast. Sticky toast can only be hidden using `hide`.
pub fn hide(id: String) {
  use dispatch <- effect_manager.call
  msg.UserHidToast(id)
  |> lustre.dispatch
  |> dispatch
}
