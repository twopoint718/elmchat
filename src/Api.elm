module Api exposing (fetchMessages, sendMessage)


import Http exposing (Error, Response, Request, Body)
import Json.Decode as Json exposing (field)
import Json.Encode exposing (Value, encode, object, string)
import Task exposing (Task)

import Types exposing (ChatMessage)

type alias DontCare = Json.Value
dontCare : Json.Decoder DontCare
dontCare = Json.value

endpoint : String
endpoint = "http://localhost:3000/messages"


-- GET

fetchMessages : (Result Error (List ChatMessage) -> msg) -> Cmd msg
fetchMessages callback =
  Http.send callback fetchMessagesRequest


fetchMessagesRequest : Request (List ChatMessage)
fetchMessagesRequest =
  Http.get endpoint incomingMessagesDecoder


incomingMessagesDecoder : Json.Decoder (List ChatMessage)
incomingMessagesDecoder =
  Json.list messageDecoder


messageDecoder : Json.Decoder ChatMessage
messageDecoder =
  Json.map2 (\name message -> ChatMessage name message)
    (field "name" Json.string)
    (field "message" Json.string)


-- POST

sendMessage : (Result Error Json.Value -> msg) -> ChatMessage -> Cmd msg
sendMessage callback msg =
  Http.send callback <| sendMessageRequest msg


sendMessageRequest : ChatMessage -> Request DontCare
sendMessageRequest msg =
  Http.post endpoint (bodyForSending msg) dontCare


bodyForSending : ChatMessage -> Body
bodyForSending msg =
  Http.jsonBody <| messageEncoder msg


messageEncoder : ChatMessage -> Json.Value
messageEncoder msg =
  object
    [ ("name", string msg.name)
    , ("message", string msg.message)
    ]
