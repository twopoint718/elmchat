module Model exposing (..)


import Types exposing (Chat)


model : Chat
model =
  { messages = []
  , field = ""
  , name = ""
  , errorMessage = ""
  }
