import grille_pain/internals/scheduler/timer
import lustre/effect

pub fn schedule(duration: Int, msg: msg) {
  use dispatch <- effect.from()
  use <- timer.set_timeout(duration)
  dispatch(msg)
}
