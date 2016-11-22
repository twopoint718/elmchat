module Update exposing (..)


import Api
import Http
import Task
import Types exposing (Msg(..), Chat, ChatMessage)

import RemoteData exposing (WebData, RemoteData(..))

update : Msg -> Chat -> (Chat, Cmd Msg)
update msg model =
  case msg of
    SendMessage msg ->
      ( { model | field = "" }
      , Api.sendMessage msg
          |> Http.toTask
          |> RemoteData.asCmd
          |> Cmd.map (always PollMessages)
      )

    Incoming msgsResult ->
      (handleIncoming model msgsResult) ! []

    PollMessages ->
      ( model
      , Api.fetchMessages
          |> Http.toTask
          |> RemoteData.asCmd
          |> Cmd.map Incoming
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


handleIncoming : Chat -> (WebData (List ChatMessage)) -> Chat
handleIncoming model msgsResult =
  case msgsResult of
    NotAsked ->
      model

    Loading ->
      model

    Success msgs ->
      { model | messages = msgs, errorMessage = "" }

    Failure e ->
      { model | errorMessage = toString e }
