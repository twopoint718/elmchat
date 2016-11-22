module Api.Get exposing (get)

import Http exposing (Error)
import Json.Decode exposing (Decoder)

import RemoteData exposing (WebData)

-- GET

get : String -> Decoder a -> (WebData a -> msg) -> Cmd msg
get endpoint decoder callback =
  Http.get endpoint decoder
    |> Http.toTask
    |> RemoteData.asCmd
    |> Cmd.map callback
