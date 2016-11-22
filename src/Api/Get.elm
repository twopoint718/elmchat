module Api.Get exposing (get)

import Http exposing (Error)
import Json.Decode exposing (Decoder)

-- GET

get : String -> Decoder a -> (Result Error a -> msg) -> Cmd msg
get endpoint decoder callback =
  Http.get endpoint decoder
    |> Http.send callback
