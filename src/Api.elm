module Api exposing (pollMessages, sendMessage)


import Dict
import Http exposing (Error, Response, RawError(RawNetworkError))
import Json.Decode as Json exposing ((:=))
import Json.Encode exposing (Value, encode, object, string)
import Task exposing (Task)

import Types exposing
  ( ChatMessage
  , Msg(Incoming, PollMessages, ShowError)
  )


endpoint : String
endpoint = "http://localhost:3000/messages"


-- GET


pollMessages : Cmd Msg
pollMessages =
  Task.perform onError onReceive getMessages


getMessages : Task Http.Error (List ChatMessage)
getMessages =
  Http.get messagesDecoder endpoint


messagesDecoder : Json.Decoder (List ChatMessage)
messagesDecoder = Json.list messageDecoder


messageDecoder : Json.Decoder ChatMessage
messageDecoder =
  Json.object2 (\name message -> { name = name, message = message })
    ("name" := Json.string)
    ("message" := Json.string)


-- POST


sendMessage : ChatMessage -> Cmd Msg
sendMessage msg =
  Task.perform onError onSent (postMessage msg)


postMessage : ChatMessage -> Task RawError ()
postMessage msg =
  Http.send Http.defaultSettings
    { verb = "POST"
    , headers = []
    , url = endpoint
    , body =
        messageEncoder msg
          |> encode 0
          |> Http.string
    }
    `Task.andThen` handlePostResponse


messageEncoder : ChatMessage -> Json.Value
messageEncoder msg =
  object
    [ ("name", string msg.name)
    , ("message", string msg.message)
    ]


-- Response handlers


onError : err -> Msg
onError err = ShowError (toString err)


-- About the weird type... if we get here then the Http POST worked, now
-- we just refresh messages so the person posting can see their new message.
onSent : () -> Msg
onSent _ = PollMessages


handlePostResponse : Response -> Task RawError ()
handlePostResponse resp =
  case Dict.get "Location" resp.headers of
    Nothing ->
      Task.fail RawNetworkError

    Just _ ->
      Task.succeed ()


onReceive : List ChatMessage -> Msg
onReceive msgs =
    Incoming msgs
