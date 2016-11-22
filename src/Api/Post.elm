module Api.Post exposing (post)

import Http exposing (Error, Request)
import Json.Decode as Json exposing (Value)

type alias DontCare = Json.Value
dontCare : Json.Decoder DontCare
dontCare = Json.value

post : String -> Value -> (Result Error Value -> msg) -> Cmd msg
post endpoint msg callback =
  sendMessageRequest endpoint msg
    |> Http.send callback


sendMessageRequest : String -> Value -> Request DontCare
sendMessageRequest endpoint payload =
  Http.post endpoint (Http.jsonBody payload) dontCare
