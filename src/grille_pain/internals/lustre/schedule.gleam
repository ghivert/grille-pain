import grille_pain/internals/ffi
import lustre/effect

pub fn schedule(duration: Int, msg: msg) {
  use dispatch <- effect.from()
  use <- ffi.set_timeout(duration)
  dispatch(msg)
}
