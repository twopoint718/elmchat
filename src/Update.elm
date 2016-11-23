module Update exposing (update)

import Api
import Messages exposing (Msg(..))
import Model exposing (Chat)

update : Msg -> Chat -> (Chat, Cmd Msg)
update msg model =
  case msg of
    SendMessage message ->
      ({ model | saying = "" }, Api.sendMessage message (always PollMessages))

    Incoming msgsResult ->
      ({model | messages = msgsResult}, Cmd.none)

    PollMessages ->
      (model, Api.fetchMessages Incoming)

    Input say ->
      ({ model | saying = say }, Cmd.none)

    SetName name ->
      ({ model | name = name }, Cmd.none)
