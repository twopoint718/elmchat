module Api where


import Array exposing (Array)
import Http
import Json.Decode as Json exposing ((:=))
import Task exposing (..)
import Time exposing (every, second)


import Types exposing (Message, Action(Incoming,NoOp))


getMessages : Task String (Array Message)
getMessages =
  Http.get messageDecoder "http://localhost:3000/messages"
    |> Task.mapError toString


messageDecoder : Json.Decoder (Array Message)
messageDecoder =
  let message =
        Json.object2 (\name message -> { name = name, message = message })
          ("name" := Json.string)
          ("message" := Json.string)
  in
      Json.array message


port runQuery : Signal (Task x ())
port runQuery =
  Signal.map (\_ -> getMessages) (Time.every (5 * second))
    |> Signal.map queryHandler


queryHandler : Task String (Array Message) -> Task x ()
queryHandler task = andThen (Task.toResult task) sendAction


sendAction : Result String (Array Message) -> Task x ()
sendAction =
  Signal.send (Signal.forwardTo currentMessages.address toAction)


toAction : Result String (Array Message) -> Action
toAction r =
  case r of
    Ok msgs -> Incoming msgs
    Err _ -> NoOp


currentMessages : Signal.Mailbox Action
currentMessages =
  Signal.mailbox NoOp
