module Model where


import Array exposing (empty)


import Types exposing (Chat, Message)


model : Chat
model =
  { messages = empty
  , field = ""
  , name = ""
  }
