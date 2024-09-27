//// grille-pain options are made to help you customise the behavior of the
//// default toasts when using them.
//// You should really only take care of `timeout` right now, `debug` being a
//// thing to help grille_pain development.
////
//// `Options` are made as Builder, meaning you can chain your options directly
//// using the pipe operator. The type is public though, meaning you can build it
//// as you prefer.
////
//// While there's nothing apart `timeout` currently, `Options` is made to be
//// extensible in an easy way.
////
//// ```gleam
//// import grille_pain/options
////
//// fn custom_options() {
////   options.default()
////   |> options.timeout(milliseconds: 5000)
//// }
//// ```

pub type Options {
  Options(timeout: Int)
}

/// Default options, 5s seconds of timeout.
pub fn default() -> Options {
  Options(timeout: 5000)
}

/// Define default timeout for toasts. Must be set in milliseconds.
pub fn timeout(_options: Options, milliseconds timeout: Int) -> Options {
  Options(timeout: timeout)
}
