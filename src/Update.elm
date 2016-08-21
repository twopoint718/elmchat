module Update exposing (..)


import Api
import Task
import Types exposing (Msg(..), Chat, ChatMessage)


update : Msg -> Chat -> (Chat, Cmd Msg)
update msg model =
  case msg of
    SendMessage msg ->
      ( { model | field = "" }
      , Api.sendMessage msg
      )

    Incoming msgs ->
      ( { model | messages = msgs, errorMessage = "" }
      , Cmd.none
      )

    PollMessages ->
      ( model
      , Api.pollMessages
      )

    Input say ->
      ( { model | field = say }
      , Cmd.none
      )

    SetName name ->
      ( { model | name = name }
      , Cmd.none
      )

    ShowError err ->
      ( { model | errorMessage = err }
      , Cmd.none
      )

    NoOp -> (model, Cmd.none)
