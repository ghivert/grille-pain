import gleam/option.{type Option}
import grille_pain/toast/level.{type Level}

pub type Msg {
  NewToast(String, Level, timeout: Option(Int))
  ShowToast(Int, timeout: Option(Int))
  HideToast(Int, Int)
  RemoveToast(Int)
  StopToast(Int)
  ResumeToast(Int)
}
