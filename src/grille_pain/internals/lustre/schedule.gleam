import grille_pain/internals/global
import lustre/effect

pub fn schedule(duration: Int, msg: msg) {
  use dispatch <- effect.from()
  use <- global.set_timeout(duration)
  dispatch(msg)
}
