module Api exposing (fetchMessages, sendMessage)

import Http exposing (Error, Request)
import Json.Decode as JD exposing (Decoder)
import Json.Encode as JE exposing (Value)

import RemoteData exposing (WebData)

import Types exposing (ChatMessage)

import Api.Post exposing (post)
import Api.Get exposing (get)

-- GET

fetchMessages : Request (List ChatMessage)
fetchMessages =
  get "messages" incomingMessagesDecoder

incomingMessagesDecoder : Decoder (List ChatMessage)
incomingMessagesDecoder =
  JD.list receiveDecoder

receiveDecoder : Decoder ChatMessage
receiveDecoder =
  JD.map2 (\name message -> ChatMessage name message)
    (JD.field "name" JD.string)
    (JD.field "message" JD.string)

-- POST

sendMessage : ChatMessage -> Request JD.Value
sendMessage chatMessage =
  post "messages" (sendEncoder chatMessage)


sendEncoder : ChatMessage -> JE.Value
sendEncoder msg =
  JE.object
    [ ("name", JE.string msg.name)
    , ("message", JE.string msg.message)
    ]
