module Api.Get exposing (get)

import Http exposing (Error, Request)
import Json.Decode exposing (Decoder)

import RemoteData exposing (WebData)

import Api.Base exposing (baseUri)

-- GET

get : String -> Decoder a -> Request a
get path decoder =
  Http.get (baseUri ++ path) decoder
