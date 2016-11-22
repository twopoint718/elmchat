module Model exposing (..)

import RemoteData exposing (RemoteData(..))

import Types exposing (Chat)


model : Chat
model =
  { messages = NotAsked
  , saying = ""
  , name = ""
  , errorMessage = ""
  }
