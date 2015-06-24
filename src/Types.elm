module Types where


import Array exposing (Array)


type Action
  = SendMessage
  | Input String
  | SetName String
  | Incoming (Array Message)
  | NoOp


type alias Message
  = { name: String, message: String }


type alias Chat =
  { messages: Array Message
  , field: String
  , name: String
  }
