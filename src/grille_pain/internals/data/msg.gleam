import gleam/option.{type Option}
import grille_pain/internals/data/model
import grille_pain/toast/level.{type Level}

pub type Msg {
  BrowserUpdatedToasts
  LustreComputedToasts
  LustreRequestedAnimationFrame(model.AnimationFrame)
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
