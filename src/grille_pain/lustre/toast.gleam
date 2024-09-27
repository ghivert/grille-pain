//// `grille_pain/lustre/toast` defines the different effects to use to display
//// toasts with lustre.

import gleam/function
import gleam/option
import grille_pain/toast
import grille_pain/toast/level
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
pub type Options(msg) {
  Options(
    timeout: option.Option(Int),
    level: option.Option(level.Level),
    sticky: Bool,
    msg: option.Option(fn(String) -> msg),
  )
}

/// Default, empty options. Use it to start Builder.
pub fn options() {
  Options(
    timeout: option.None,
    level: option.None,
    sticky: False,
    msg: option.None,
  )
}

/// Timeout to override defaults. Accepts a timeout in milliseconds.
pub fn timeout(options: Options(msg), milliseconds timeout: Int) {
  Options(..options, timeout: option.Some(timeout))
}

/// Activate stickiness for toast. A sticky toast will never go away while it's
/// not hidden manually.
pub fn sticky(options: Options(msg)) {
  Options(..options, sticky: True)
}

/// Level of your toast.
pub fn level(options: Options(msg), level: level.Level) {
  Options(..options, level: option.Some(level))
}

pub fn notify(options: Options(a), msg: fn(String) -> b) -> Options(b) {
  Options(
    timeout: options.timeout,
    level: options.level,
    sticky: options.sticky,
    msg: option.Some(msg),
  )
}

fn maybe(value: option.Option(a), map: fn(toast.Options, a) -> toast.Options) {
  case value {
    option.None -> function.identity
    option.Some(value) -> map(_, value)
  }
}

fn to_options(options: Options(msg)) -> toast.Options {
  toast.options()
  |> case options.sticky {
    True -> toast.sticky
    False -> function.identity
  }
  |> maybe(options.timeout, toast.timeout)
  |> maybe(options.level, toast.level)
}

fn dispatch(
  content: String,
  msg: option.Option(fn(String) -> msg),
  toaster: fn(String) -> String,
) {
  use dispatch <- effect.from()
  let id = toaster(content)
  case msg {
    option.None -> Nil
    option.Some(msg) -> dispatch(msg(id))
  }
}

pub fn info(content: String) {
  dispatch(content, option.None, toast.info)
}

pub fn success(content: String) {
  dispatch(content, option.None, toast.success)
}

pub fn toast(content: String) {
  dispatch(content, option.None, toast.toast)
}

pub fn error(content: String) {
  dispatch(content, option.None, toast.error)
}

pub fn warning(content: String) {
  dispatch(content, option.None, toast.warning)
}

pub fn custom(options: Options(msg), content: String) {
  use dispatch <- effect.from()
  let options_ = to_options(options)
  let id = toast.custom(options_, content)
  case options.msg {
    option.None -> Nil
    option.Some(msg) -> dispatch(msg(id))
  }
}

/// Hide toast. Sticky toast can only be hidden using `hide`.
pub fn hide(id: String) {
  use _ <- effect.from()
  toast.hide(id)
}
