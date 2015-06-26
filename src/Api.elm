module Api where


import Array exposing (Array)
import Http exposing (RawError, Response, defaultSettings, get, send)
import Json.Decode as Json exposing ((:=))
import Json.Encode exposing (Value, encode, object, string)
import Task exposing (..)
import Time exposing (every, second)


import Types exposing (Message, Action(Incoming,NoOp))


endpoint : String
endpoint = "http://localhost:3000/messages"


-- GET


getMessages : Task String (Array Message)
getMessages =
  get messagesDecoder endpoint
    |> Task.mapError toString


messagesDecoder : Json.Decoder (Array Message)
messagesDecoder = Json.array messageDecoder


messageDecoder : Json.Decoder Message
messageDecoder =
  Json.object2 (\name message -> { name = name, message = message })
    ("name" := Json.string)
    ("message" := Json.string)


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


-- POST


postMessage : Message -> Task String Response
postMessage msg =
  always "POST failed"
  `mapError`
  send defaultSettings
    { verb = "POST"
    , headers = []
    , url = endpoint
    , body =
      messageEncoder msg
        |> encode 0
        |> Http.string
    }


messageEncoder : Message -> Json.Value
messageEncoder msg =
  object
    [ ("name", string msg.name)
    , ("message", string msg.message)
    ]


outgoingMessages : Signal.Mailbox Action
outgoingMessages =
  Signal.mailbox NoOp
