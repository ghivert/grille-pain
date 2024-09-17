import gleam/option.{type Option}
import grille_pain/toast/level.{type Level}

pub type Msg {
  ExternalHide(uuid: String)
  Hide(id: Int, iteration: Int)
  New(
    uuid: String,
    message: String,
    level: Level,
    timeout: Option(Int),
    sticky: Bool,
  )
  Remove(id: Int)
  Resume(id: Int)
  Show(id: Int, timeout: Option(Int), sticky: Bool)
  Stop(id: Int)
}
