module Model exposing (..)

import RemoteData exposing (RemoteData(..))

import Types exposing (Chat)


model : Chat
model =
  { messages = NotAsked
  , field = ""
  , name = ""
  , errorMessage = ""
  }
