module Api exposing (fetchMessages, sendMessage)

import Http exposing (Error)
import Json.Decode as JD exposing (Decoder)
import Json.Encode as JE exposing (Value)

import Types exposing (ChatMessage)

import Api.Post
import Api.Get

endpoint : String
endpoint = "http://localhost:3000/"

get : String -> Decoder a -> (Result Error a -> msg) -> Cmd msg
get path =
  Api.Get.get (endpoint ++ path)

post : String -> JD.Value -> (Result Error JD.Value -> msg) -> Cmd msg
post path =
  Api.Post.post (endpoint ++ path)

fetchMessages : (Result Error (List ChatMessage) -> msg) -> Cmd msg
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

sendMessage : ChatMessage -> (Result Error JD.Value -> msg) -> Cmd msg
sendMessage chatMessage =
  post "messages" (sendEncoder chatMessage)


sendEncoder : ChatMessage -> JE.Value
sendEncoder msg =
  JE.object
    [ ("name", JE.string msg.name)
    , ("message", JE.string msg.message)
    ]
