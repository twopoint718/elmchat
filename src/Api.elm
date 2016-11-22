module Api exposing (fetchMessages, sendMessage)

import Http exposing (Error, Request)
import Json.Decode as JD exposing (Decoder)
import Json.Encode as JE exposing (Value)

import RemoteData exposing (WebData)

import Model exposing (ChatMessage)

baseUri : String
baseUri = "http://localhost:3000/"

-- GET

get : String -> Decoder a -> Request a
get path decoder =
  Http.get (baseUri ++ path) decoder

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

type alias DontCare = JD.Value
dontCare : JD.Decoder DontCare
dontCare = JD.value

post : String -> JE.Value -> Request DontCare
post path msg =
  Http.post (baseUri ++ path) (Http.jsonBody msg) dontCare


sendMessage : ChatMessage -> Request JD.Value
sendMessage chatMessage =
  post "messages" (sendEncoder chatMessage)


sendEncoder : ChatMessage -> JE.Value
sendEncoder msg =
  JE.object
    [ ("name", JE.string msg.name)
    , ("message", JE.string msg.message)
    ]
