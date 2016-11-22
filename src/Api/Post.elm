module Api.Post exposing (post)

import Http exposing (Error, Request)
import Json.Decode as Json exposing (Value)

import RemoteData exposing (WebData)

import Api.Base exposing (baseUri)

type alias DontCare = Json.Value
dontCare : Json.Decoder DontCare
dontCare = Json.value

post : String -> Value -> Request DontCare
post path msg =
  Http.post (baseUri ++ path) (Http.jsonBody msg) dontCare
