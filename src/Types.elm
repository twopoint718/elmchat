module Types where


import Array exposing (Array)


type Action
  = SendMessage Message
  | Input String
  | SetName String
  | Incoming (List Message)
  | NoOp


type alias Message
  = { name: String, message: String }


type alias Chat =
  { messages: List Message
  , field: String
  , name: String
  }
