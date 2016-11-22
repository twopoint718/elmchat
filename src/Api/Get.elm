module Api.Get exposing (get)

import Http exposing (Error)
import Json.Decode exposing (Decoder)
import Task exposing (Task)

import RemoteData exposing (WebData)

-- GET

get : String -> Decoder a -> Task Error a
get endpoint decoder =
  Http.get endpoint decoder
    |> Http.toTask
