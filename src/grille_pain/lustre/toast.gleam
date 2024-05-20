import gleam/io
import grille_pain/toast
import lustre/effect

pub const options = toast.options

pub const timeout = toast.timeout

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
  io.debug("nsauternsauitensrtaue")
  toast.custom(options, content)
}
