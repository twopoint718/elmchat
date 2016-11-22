module Update exposing (..)


import Api
import Http
import Task
import Types exposing (Msg(..), Chat, ChatMessage)


update : Msg -> Chat -> (Chat, Cmd Msg)
update msg model =
  case msg of
    SendMessage msg ->
      ( { model | field = "" }
      , Api.sendMessage (\_->PollMessages) msg
      )

    Incoming msgsResult ->
      handleIncoming model msgsResult

    PollMessages ->
      ( model
      , Api.pollMessages Incoming
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


handleIncoming : Chat -> (Result Http.Error (List ChatMessage)) -> (Chat, Cmd Msg)
handleIncoming model msgsResult =
  case msgsResult of
    Ok msgs ->
      ( { model | messages = msgs, errorMessage = "" }
      , Cmd.none
      )

    Err err ->
      ( { model | errorMessage = toString err }
      , Cmd.none
      )
