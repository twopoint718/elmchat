module Api exposing (fetchMessages, sendMessage)

import Http exposing (Body)
import Json.Decode as JD exposing (Decoder)
import Json.Encode as JE exposing (Value)

import RemoteData exposing (WebData)

import Model exposing (ChatMessage, ChatList)
import Messages exposing (Msg)

endpoint : String
endpoint = "http://localhost:3000/messages"

-- GET

fetchMessages : (ChatList -> Msg) -> Cmd Msg
fetchMessages callback =
  Http.get endpoint incomingMessagesDecoder
    |> Http.send (callback << RemoteData.fromResult)

incomingMessagesDecoder : Decoder (List ChatMessage)
incomingMessagesDecoder =
  JD.list incomingMessageDecoder

incomingMessageDecoder : Decoder ChatMessage
incomingMessageDecoder =
  JD.map2 (\name message -> ChatMessage name message)
    (JD.field "name" JD.string)
    (JD.field "message" JD.string)

-- POST

sendMessage : ChatMessage -> (WebData JD.Value -> Msg) -> Cmd Msg
sendMessage chatMessage callback =
  Http.post endpoint (bodyToSend chatMessage) JD.value
    |> Http.send (callback << RemoteData.fromResult)

bodyToSend : ChatMessage -> Body
bodyToSend chatMessage =
  Http.jsonBody <| sendEncoder chatMessage

sendEncoder : ChatMessage -> JE.Value
sendEncoder msg =
  JE.object
    [ ("name", JE.string msg.name)
    , ("message", JE.string msg.message)
    ]
