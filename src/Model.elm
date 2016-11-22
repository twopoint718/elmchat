module Model exposing (..)

import RemoteData exposing (RemoteData(..), WebData)

type alias ChatMessage
  = { name: String, message: String }


type alias Model =
  { messages : WebData (List ChatMessage)
  , errorMessage : String
  , saying : String
  , name : String
  }

model : Model
model =
  { messages = NotAsked
  , saying = ""
  , name = ""
  , errorMessage = ""
  }
