module Api exposing (pollMessages, sendMessage)


import Http exposing (Error, Response, Request)
import Json.Decode as Json exposing (field)
import Json.Encode exposing (Value, encode, object, string)
import Task exposing (Task)

import Types exposing (ChatMessage)


endpoint : String
endpoint = "http://localhost:3000/messages"


-- GET


pollMessages : (Result Error (List ChatMessage) -> msg) -> Cmd msg
pollMessages callback =
  Http.send callback getMessagesRequest

getMessagesRequest : Request (List ChatMessage)
getMessagesRequest =
  Http.get endpoint incomingMessagesDecoder


incomingMessagesDecoder : Json.Decoder (List ChatMessage)
incomingMessagesDecoder =
  Json.list messageDecoder


messageDecoder : Json.Decoder ChatMessage
messageDecoder =
  Json.map2 (\name message -> { name = name, message = message })
    (field "name" Json.string)
    (field "message" Json.string)


-- POST


sendMessage : (Result Error Json.Value -> msg) -> ChatMessage -> Cmd msg
sendMessage callback msg =
  Http.send callback <| requestForPostMessage msg


requestForPostMessage : ChatMessage -> Request Json.Value
requestForPostMessage msg =
  Http.post endpoint (bodyForSending msg) Json.value

bodyForSending : ChatMessage -> Http.Body
bodyForSending msg =
  Http.jsonBody <| messageEncoder msg

messageEncoder : ChatMessage -> Json.Value
messageEncoder msg =
  object
    [ ("name", string msg.name)
    , ("message", string msg.message)
    ]
