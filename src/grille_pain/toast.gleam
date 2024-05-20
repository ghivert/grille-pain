import gleam/option.{type Option, None, Some}
import grille_pain/internals/data/msg
import grille_pain/internals/ffi
import grille_pain/toast/level.{type Level}
import lustre

pub opaque type Options {
  Options(timeout: Option(Int), level: Option(Level))
}

pub fn options() {
  Options(None, None)
}

pub fn timeout(options: Options, timeout: Int) {
  Options(..options, timeout: Some(timeout))
}

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
