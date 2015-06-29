module Model where


import Types exposing (Chat, Message)


model : Chat
model =
  { messages = []
  , field = ""
  , name = ""
  }
