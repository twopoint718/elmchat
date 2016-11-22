module Update exposing (..)


import Api
import Http exposing (Request)
import Task
import Types exposing (Msg(..), Chat, ChatMessage)

import RemoteData exposing (WebData, RemoteData(..))

requestMap : (WebData a -> Msg) -> Request a -> Cmd Msg
requestMap msg request =
  request
    |> Http.toTask
    |> RemoteData.asCmd
    |> Cmd.map msg

update : Msg -> Chat -> (Chat, Cmd Msg)
update msg model =
  case msg of
    SendMessage msg ->
      ( { model | saying = "" }
      , requestMap (always PollMessages) (Api.sendMessage msg)
      )

    Incoming msgsResult ->
      (handleIncoming model msgsResult) ! []

    PollMessages ->
      ( model
      , requestMap Incoming Api.fetchMessages
      )

    Input say ->
      ( { model | saying = say }
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
      { model | messages = Success msgs, errorMessage = "" }

    Failure e ->
      { model
      | errorMessage = toString e
      , messages = Failure e
      }
