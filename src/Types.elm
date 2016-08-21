module Types exposing (Msg(..), Chat, ChatMessage)


import Array exposing (Array)


type Msg
  = SendMessage ChatMessage
  | Incoming (List ChatMessage)
  | Input String
  | NoOp
  | PollMessages
  | SetName String
  | ShowError String


type alias ChatMessage
  = { name: String, message: String }


type alias Chat =
  { messages : List ChatMessage
  , errorMessage : String
  , field : String
  , name : String
  }
