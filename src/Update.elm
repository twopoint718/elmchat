module Update exposing (update)

import Api
import Messages exposing (Msg(..))
import Model exposing (Chat, ChatMessage)

update : Msg -> Chat -> (Chat, Cmd Msg)
update msg model =
  case msg of
    SendMessage name saying ->
      let
          message = ChatMessage name saying
      in
         ({ model | saying = "" }, Api.sendMessage message (always PollMessages))

    Incoming msgsResult ->
      ({model | messages = msgsResult}, Cmd.none)

    PollMessages ->
      (model, Api.fetchMessages Incoming)

    Input say ->
      ({ model | saying = say }, Cmd.none)

    SetName name ->
      ({ model | name = name }, Cmd.none)
