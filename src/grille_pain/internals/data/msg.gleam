import gleam/option.{type Option}
import grille_pain/internals/global
import grille_pain/toast/level.{type Level}

pub type Msg {
  BrowserUpdatedToasts
  LustreComputedToasts
  LustreRequestedAnimationFrame(global.AnimationFrame)
  ToastHidDisplay(id: Int)
  ToastTimedOut(id: Int, iteration: Int)
  UserAddedToast(
    uuid: String,
    message: String,
    level: Level,
    timeout: Option(Int),
    sticky: Bool,
  )
  UserEnteredToast(id: Int)
  UserHidToast(uuid: String)
  UserLeavedToast(id: Int)
}
