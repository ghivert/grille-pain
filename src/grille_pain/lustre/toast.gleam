//// `grille_pain/lustre/toast` defines the different effects to use to display
//// toasts with lustre.

import grille_pain/toast
import lustre/effect

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
pub type Options =
  toast.Options

/// Default options, 5s seconds of timeout.
pub const options = toast.options

/// Timeout to override defaults. Accepts a timeout in milliseconds.
pub const timeout = toast.timeout

/// Level of your toast.
pub const level = toast.level

fn dispatch(content: String, toaster: fn(String) -> Nil) {
  use _dispatch <- effect.from()
  toaster(content)
}

pub fn info(content: String) {
  dispatch(content, toast.info)
}

pub fn success(content: String) {
  dispatch(content, toast.success)
}

pub fn toast(content: String) {
  dispatch(content, toast.toast)
}

pub fn error(content: String) {
  dispatch(content, toast.error)
}

pub fn warning(content: String) {
  dispatch(content, toast.warning)
}

pub fn custom(options: toast.Options, content: String) {
  use _dispatch <- effect.from()
  toast.custom(options, content)
}
