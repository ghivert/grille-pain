import gleam/option.{type Option}
import grille_pain/internals/data/model
import grille_pain/toast/level.{type Level}

pub type Msg {
  ExternalHide(uuid: String)
  HideToast(id: Int, iteration: Int)
  NewToast(
    uuid: String,
    message: String,
    level: Level,
    timeout: Option(Int),
    sticky: Bool,
  )
  RemoveToast(id: Int)
  ResumeToast(id: Int)
  StopToast(id: Int)
  UpdateDisplay
  UpdateToasts
  UpdateNextAnimationFrame(model.AnimationFrame)
}
