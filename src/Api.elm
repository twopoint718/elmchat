module Api exposing (pollMessages, sendMessage)


import Dict
import Http exposing (Error, Response, Request)
import Json.Decode as Json exposing (field)
import Json.Encode exposing (Value, encode, object, string)
import Task exposing (Task)

import Types exposing
  ( ChatMessage
  , Msg(Incoming, PollMessages, ShowError)
  )


endpoint : String
endpoint = "http://localhost:3000/messages"


-- GET


pollMessages : (Result Error (List ChatMessage) -> Msg) -> Cmd Msg
pollMessages callback =
  --Task.perform onError onReceive getMessages
  Http.send callback getMessagesRequest

getMessagesRequest : Request (List ChatMessage)
getMessagesRequest =
  Http.get endpoint incomingMessagesDecoder
  --Http.get messagesDecoder endpoint


incomingMessagesDecoder : Json.Decoder (List ChatMessage)
incomingMessagesDecoder =
  Json.list messageDecoder


messageDecoder : Json.Decoder ChatMessage
messageDecoder =
  Json.map2 (\name message -> { name = name, message = message })
    (field "name" Json.string)
    (field "message" Json.string)


-- POST


sendMessage : (Result Error Json.Value -> Msg) -> ChatMessage -> Cmd Msg
sendMessage callback msg =
  --Task.perform onError onSent (postMessage msg)
  Http.send callback <| requestForPostMessage msg


-- postMessage : ChatMessage -> Task RawError ()
-- postMessage msg =
--   Http.send Http.defaultSettings
--     { verb = "POST"
--     , headers = []
--     , url = endpoint
--     , body =
--         messageEncoder msg
--           |> encode 0
--           |> Http.string
--     }
--     |> Task.andThen handlePostResponse

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


-- Response handlers


onError : err -> Msg
onError err = ShowError (toString err)


-- About the weird type... if we get here then the Http POST worked, now
-- we just refresh messages so the person posting can see their new message.
onSent : () -> Msg
onSent _ = PollMessages
